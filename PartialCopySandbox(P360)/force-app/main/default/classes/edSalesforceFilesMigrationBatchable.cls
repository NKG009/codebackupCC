/* **************************************************************************
* Copyright © 2015-2022, Neilon Technologies LLP.
* All rights reserved
*
* Controller Class: edSalesforceFilesMigrationBatchable
* Created by Suresh Meghnathi: 13/06/2022
*
* -This is batchable class to migrate Salesforce files.

* - Modifications:
* - Suresh Meghnathi, 13/06/2022 – Initial Development
************************************************************************** */
public class edSalesforceFilesMigrationBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	// Query string to get attchments
    public String query;
    
    // Max file size
    public static Integer MAX_SINGLEPART_FILE_EXPORT_SIZE = 1024 * 1024 * 11;
    
    public edSalesforceFilesMigrationBatchable(String query){
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        // Parent record ids for which we need to migrate attachments
        List<Id> parentRecordIds = new List<Id>();
        
        for(sObject record : scope){
            parentRecordIds.add(record.Id);
        }
        
        if(!parentRecordIds.isEmpty()){
        	// Migrate Salesforce files
            edSalesforceFilesMigrationBatchable.migrateSalesforceFiles(parentRecordIds[0]);
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
    /*
    *   Purpose:    Migrate Salesforce files
    *   Parameters: 
    *   UnitTests:  
    */
    public static void migrateSalesforceFiles(Id parentId){
        // Get content document links
        List<ContentDocumentLink> allContentDocumentLinks = new List<ContentDocumentLink>();
        if(Test.isRunningTest() || parentId.getSobjectType() + '' != 'Order'){
            allContentDocumentLinks = [Select Id, LinkedEntityId, ContentDocument.Id, ContentDocument.FileType, ContentDocument.ContentSize, ContentDocument.Title, ContentDocument.FileExtension From ContentDocumentLink Where LinkedEntityId =: parentId ORDER BY ContentDocument.CreatedDate];
        } else{
            allContentDocumentLinks = [Select Id, LinkedEntityId, ContentDocument.Id, ContentDocument.FileType, ContentDocument.ContentSize, ContentDocument.Title, ContentDocument.FileExtension From ContentDocumentLink Where LinkedEntityId =: parentId AND ContentDocument.Title LIKE 'Invoice%' AND ContentDocument.CreatedDate < THIS_YEAR ORDER BY ContentDocument.CreatedDate];
        }
        
        // List of all content document ids
        Set<Id> allContentDocumentIds = new Set<Id>();
                
        // Get content document with size less than 11MB
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        if(!allContentDocumentLinks.isEmpty()){
            for(ContentDocumentLink contentDocumentLink : allContentDocumentLinks){
            	allContentDocumentIds.add(contentDocumentLink.ContentDocument.Id);
                if(contentDocumentLink.ContentDocument.ContentSize <= MAX_SINGLEPART_FILE_EXPORT_SIZE && contentDocumentLink.ContentDocument.FileType != 'SNOTE'){
                    contentDocumentLinks.add(contentDocumentLink);
                }
            }
        }
        
        // Map of migrated files by content document id
        Map<String, NEILON__File__c> migratedFilesByContentDocumentId = new Map<String, NEILON__File__c>();
        
        // File migration failure reason
        String migrationFailureReason;
        
        // Check content document links to export
        if(!contentDocumentLinks.isEmpty()){
	        // Get record home folder for parent
	        List<NEILON__Folder__c> recordHomeFolders = [Select Id From NEILON__Folder__c Where NEILON__Record_Home__c = true AND NEILON__Parent_Id__c =: parentId];
	        
	        // Migrate files if record home folder is available
	        if(!recordHomeFolders.isEmpty()){
	            
                // List of content document ids
                Set<Id> contentDocumentIds = new Set<Id>();
                
                for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
                    contentDocumentIds.add(contentDocumentLink.ContentDocument.Id);
                }
                
                // Get existing migrated files
                List<NEILON__File__c> existingFiles = [Select Id, NEILON__Parent_Id__c, NEILON__Folder__c, NEILON__Content_Document_Id__c From NEILON__File__c Where NEILON__Parent_Id__c =: parentId AND NEILON__Folder__c = :recordHomeFolders[0].Id AND NEILON__Content_Document_Id__c IN : allContentDocumentIds];
                
                // Remove already migrated content document ids
                if(!existingFiles.isEmpty()){
                    // List of migrated content document ids
                    List<Id> migratedContentDocumentIds = new List<Id>();
                    
                    for(NEILON__File__c file : existingFiles){
                        migratedContentDocumentIds.add(file.NEILON__Content_Document_Id__c);
                    }
                    contentDocumentIds.removeAll(migratedContentDocumentIds);
                }
                
                // Content document ids to migrate
                Set<Id> contentDocumentLinkIdsToMigrate = new Set<Id>();
                for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
                    if(contentDocumentIds.contains(contentDocumentLink.ContentDocument.Id)){
                    	contentDocumentLinkIdsToMigrate.add(contentDocumentLink.Id);
                    }
                    
                    if(contentDocumentLinkIdsToMigrate.size() >= 45){
                    	break;
                    }
                }
                
                // List of migrated files
                List<NEILON__File__c> migratedFiles = new List<NEILON__File__c>();
                
                // Create files
                if(!contentDocumentLinkIdsToMigrate.isEmpty()){
                	try{
	                    // Create files
	                    NEILON.apGlobalUtils.createS3LinkFilesForContentVersion(contentDocumentLinkIdsToMigrate, false, false, false);
                		migratedFiles = [Select Id, NEILON__Parent_Id__c, NEILON__Folder__c, NEILON__Content_Document_Id__c From NEILON__File__c Where NEILON__Parent_Id__c =: parentId AND NEILON__Folder__c = :recordHomeFolders[0].Id AND NEILON__Content_Document_Id__c IN : allContentDocumentIds];
                    } catch(Exception ex){
                		migrationFailureReason = ex.getMessage();
                	}
                }
                
                // Add existing migrated files
                if(!existingFiles.isEmpty()){
                    migratedFiles.addAll(existingFiles);
                }
                
                // Prepare map of migrated files by content document id
                if(!migratedFiles.isEmpty()){
                    for(NEILON__File__c migratedFile : migratedFiles){
                        migratedFilesByContentDocumentId.put(migratedFile.NEILON__Parent_Id__c + migratedFile.NEILON__Content_Document_Id__c, migratedFile);
                    }
                }
	        } else{
	            migrationFailureReason = 'Record home folder is not available';
	        }
        }
        
        // Create report
        edSalesforceFilesMigrationBatchable.createAmazonS3FileMigrationReport(allContentDocumentLinks, migratedFilesByContentDocumentId, migrationFailureReason);
    }
    
    /*
    *   Purpose:    Create amazon S3-File migration report
    *   Parameters: 
    *   UnitTests:  
    */
    public static void createAmazonS3FileMigrationReport(List<ContentDocumentLink> contentDocumentLinks, Map<String, NEILON__File__c> migratedFilesByContentDocumentId, String migrationFailureReason){
        // List of amazon S3 file migration reports
        List<Amazon_S3_File_Migration_Report__c> amazonS3FileMigrationReports = new List<Amazon_S3_File_Migration_Report__c>();
        
        // Set of parent record ids
        Set<Id> parentIds = new Set<Id>();
        
        // Parent record object API names
        Set<String> parentRecordObjectAPINames = new Set<String>();
		
		// Parent record object API names for folders
        Set<String> parentRecordObjectAPINamesForFolder = new Set<String>();
        
        // Set of content document titles
        Set<String> contentDocumentTitlesWithParentId = new Set<String>();
        
        // Set of content document link ids with duplicate content document
        Set<String> duplicateContentDocumentTitlesWithParentId = new Set<String>();
        
        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
            // Get content document
            ContentDocument contentDocument = contentDocumentLink.ContentDocument;
            
            if(contentDocument.FileType != 'SNOTE'){
	        	parentIds.add(contentDocumentLink.LinkedEntityId);
	            parentRecordObjectAPINames.add(S3LinkUtils.getParentFieldAPIFromId(contentDocumentLink.LinkedEntityId, true));
				parentRecordObjectAPINamesForFolder.add(S3LinkUtils.getParentFieldAPIFromId(contentDocumentLink.LinkedEntityId, false));
	            
	            if(!contentDocumentTitlesWithParentId.contains(contentDocumentLink.LinkedEntityId + contentDocument.Title)){
	                contentDocumentTitlesWithParentId.add(contentDocumentLink.LinkedEntityId + contentDocument.Title);
	            } else{
	                duplicateContentDocumentTitlesWithParentId.add(contentDocumentLink.LinkedEntityId + contentDocument.Title);
	            }
            }
        }
        
        // Map of record home folder id by parent id
        Map<Id, Id> recordHomeFolderIdsByParentId = new Map<Id, Id>();
        
        // Get record home folders
        if(!parentIds.isEmpty()){
			for(String parentRecordObjectAPIName : parentRecordObjectAPINamesForFolder){
	            String query = 'Select Id, NEILON__Parent_Id__c From NEILON__Folder__c Where NEILON__Record_Home__c = true AND ' + 				  parentRecordObjectAPIName + ' IN ' + S3LinkUtils.prepareQueryStringForInClause(parentIds);
				List<NEILON__Folder__c> folders = Database.query(query);
				
				for(NEILON__Folder__c folder : folders){
					recordHomeFolderIdsByParentId.put(folder.NEILON__Parent_Id__c, folder.Id);
				}
			}
        }
        
        // Map of reports by content document id
        Map<String, Amazon_S3_File_Migration_Report__c> reportsByContentDocumentId = new Map<String, Amazon_S3_File_Migration_Report__c>();
        // Get existing reports
        for(String parentRecordObjectAPIName : parentRecordObjectAPINames){
			String query = 'Select Id, ' + parentRecordObjectAPIName + ', S3_File__c, S3_File__r.NEILON__Parent_Id__c, Salesforce_File_Id__c From Amazon_S3_File_Migration_Report__c Where ' + parentRecordObjectAPIName + ' IN ' + S3LinkUtils.prepareQueryStringForInClause(parentIds);
            List<Amazon_S3_File_Migration_Report__c> reports = Database.query(query);
	        for(Amazon_S3_File_Migration_Report__c report : reports){
	            reportsByContentDocumentId.put(String.valueOf(report.get(parentRecordObjectAPIName)) + report.Salesforce_File_Id__c, report);
	        }
        }
        
        // Get base URL
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
            // Get content document
            ContentDocument contentDocument = contentDocumentLink.ContentDocument;
            
            // Skip notes
            if(contentDocument.FileType == 'SNOTE'){
                continue;
            }
            
            // Get parent record object API name
            String parentRecordObjectAPIName = S3LinkUtils.getParentFieldAPIFromId(contentDocumentLink.LinkedEntityId, true);
            
            // Get migrated file
            NEILON__File__c migratedFile = migratedFilesByContentDocumentId.get(String.valueOf(contentDocumentLink.LinkedEntityId) + String.valueOf(contentDocument.Id));
            
            // Get existing report if available
            Amazon_S3_File_Migration_Report__c report = reportsByContentDocumentId.get(String.valueOf(contentDocumentLink.LinkedEntityId) + String.valueOf(contentDocument.Id));
            if(report == null){
                report = new Amazon_S3_File_Migration_Report__c();
            }
            
            if((report.Id == null && migratedFile == null) || report.Id != null){
                // Get folder
                Id folderId = recordHomeFolderIdsByParentId.get(contentDocumentLink.LinkedEntityId);
                
                // Prepare manual migration URL
                String migrationURL;
                if(duplicateContentDocumentTitlesWithParentId.contains(contentDocumentLink.LinkedEntityId + contentDocument.Title)){
                    migrationURL = baseUrl + '/apex/NEILON__edUploadSalesforceFiles?sfFileIds=' + contentDocument.Id + '&folderId=' + folderId + '&replaceDuplicate=false&retURL=/' + folderId;
                } else{
                    migrationURL = baseUrl + '/apex/NEILON__edUploadSalesforceFiles?sfFileIds=' + contentDocument.Id + '&folderId=' + folderId + '&replaceDuplicate=true&retURL=/' + folderId;
                }
                
                // Set attributes
                if(report.Id == null){
                    report.put(parentRecordObjectAPIName, contentDocumentLink.LinkedEntityId);
                }
                
                // Set file in report
                if(report.S3_File__c == null || (String.valueOf(report.get(parentRecordObjectAPIName)) != report.S3_File__r.NEILON__Parent_Id__c)){
                    report.S3_File__c = migratedFile != null ? migratedFile.Id : null;
                }
                
                if(folderId != null){
                    report.S3_Folder__c = folderId;
                }
                
                report.Parent_Id__c = contentDocumentLink.LinkedEntityId;
                report.Parent_Object_API_Name__c = parentRecordObjectAPIName;
                report.Salesforce_File_Id__c = contentDocument.Id;
                report.Salesforce_File_Size__c = contentDocument.ContentSize;
                report.Salesforce_File_Title__c = contentDocument.Title;
                report.Salesforce_File_Extension__c = contentDocument.FileExtension;
                report.Manual_File_Migration_Link__c = migrationURL;
                
                // Set failure reason
                if(String.isNotBlank(migrationFailureReason)){
                    report.Failure_Reason__c = migrationFailureReason;
                } else if(migratedFile != null){
                    if(migratedFile.Id == null && String.isNotBlank(migratedFile.NEILON__Description__c)){
                        report.Failure_Reason__c = migratedFile.NEILON__Description__c;
                    } else{
                        report.Failure_Reason__c = null;
                    }
                }
                amazonS3FileMigrationReports.add(report);
            }
        }
        
        // Upsert reports
        if(!amazonS3FileMigrationReports.isEmpty()){
            Database.upsert(amazonS3FileMigrationReports, false);
        }
    }
}
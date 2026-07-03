/* **************************************************************************
* Copyright(c) 2015-2019, Neilon Inc.
* All rights reserved
*
* Controller Class: s3LinkTestUtils
* Created by Anil Meghnathi: 15/10/2019
*
* - Used to create the test data.

* - Modifications:
* - Anil Meghnathi, 15/10/2019 – Initial Development
************************************************************************** */
@isTest
public class s3LinkTestUtils {
    public static User createUser(String alias, String emailAddress, String userName){
        // Create a user
        Profile p = [Select Id From Profile Where Name = 'System Administrator'];
        User testUser = new User(alias=alias, email=emailAddress, 
                    emailencodingkey='UTF-8', lastname='testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid=p.id, 
                    timezonesidkey='America/Los_Angeles', username=userName);
        insert testUser;
        System.assertEquals(testUser.Id != null, true);
        return testUser;
    }
    
    public static NEILON__Folder__c createFoldersForBucket(String name){
        NEILON__Folder__c bucket = new NEILON__Folder__c(Name = name);
        bucket.NEILON__Parent__c = null;
        bucket.NEILON__Active__c = true;
        bucket.NEILON__Default__c = true;
        insert bucket;
        return bucket;
    }
    
    public static List<NEILON__File__c> createFiles(NEILON__Folder__c folder){
        
        // Create files
        List<NEILON__File__c> files = new List<NEILON__File__c>();
        NEILON__File__c file1 = new NEILON__File__c(Name= 'File1.png');
        file1.NEILON__Folder__c = folder.Id;
        file1.NEILON__Bucket_Name__c = 'Test_Bucket1';
        file1.NEILON__Extension__c = '.png';
        file1.NEILON__Size__c = 5000;
        file1.NEILON__Content_Type__c = 'image/png';
        file1.NEILON__Track_Download_History__c = true;
        files.add(file1);
        
        NEILON__File__c file2 = new NEILON__File__c(Name= 'File2.png');
        file2.NEILON__Folder__c = folder.Id;
        file2.NEILON__Bucket_Name__c = 'Test_Bucket1';
        file2.NEILON__Extension__c = '.jpg';
        file2.NEILON__Size__c = 5001;
        file2.NEILON__Content_Type__c = 'image/jpg';
        files.add(file2);
        
        NEILON__File__c file3 = new NEILON__File__c(Name= 'File3.png');
        file3.NEILON__Folder__c = folder.Id;
        file3.NEILON__Bucket_Name__c = 'Test_Bucket1';
        file3.NEILON__Extension__c = '.pdf';
        file3.NEILON__Size__c = 5000;
        file3.NEILON__Content_Type__c = 'image/pdf';
        files.add(file3);
        
        insert files;
        return files;
    }
    
    public static List<NEILON__Folder__c> createSubfolders(NEILON__Folder__c parentFolder){
		List<NEILON__Folder__c> subFolders = new List<NEILON__Folder__c>();
		NEILON__Folder__c sub1 = new NEILON__Folder__c(Name= parentFolder.Name+'_Sub_Folder1');
		sub1.NEILON__Bucket_Name__c = parentFolder.NEILON__Bucket_Name__c;
		sub1.NEILON__Parent__c = parentFolder.Id;
		subFolders.add(sub1);
		
		NEILON__Folder__c sub2 = new NEILON__Folder__c(Name= parentFolder.Name+'_Sub_Folder2');
		sub2.NEILON__Bucket_Name__c = parentFolder.NEILON__Bucket_Name__c;
		sub2.NEILON__Parent__c = parentFolder.Id;
		subFolders.add(sub2);
		
		insert subFolders;
		return subFolders;
	}
    
    public static ContentDocument createContentDocument(String title){
		// Create content version
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Description = 'Test Description';
        contentVersion.Title = title;
        contentVersion.OwnerId = UserInfo.getUserId();
        contentVersion.VersionData = Blob.valueOf(title);
        contentVersion.PathOnClient = 'Bucket 1/' + contentVersion.Title + '.pdf';
        contentVersion.ContentLocation = 'S';
        insert contentVersion;
        
        // Get the content documents
        return [SELECT Id, Title FROM ContentDocument WHERE LatestPublishedVersionId =: contentVersion.Id LIMIT 1];
	}
    
    public static ContentDocumentLink createContentDocumentLink(String title, Id linkedEntityId){
		// Create content version
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Description = 'Test Description';
        contentVersion.Title = title;
        contentVersion.OwnerId = UserInfo.getUserId();
        contentVersion.VersionData = Blob.valueOf('TestData');
        contentVersion.PathOnClient = 'Bucket 1/'+contentVersion.Title+'.pdf';
        contentVersion.ContentLocation = 'S';
        insert contentVersion;
        
        // Get the content versions
        List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id LIMIT 1];
        
        // Create content document link
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(LinkedEntityId = linkedEntityId, ContentDocumentId = contentVersions[0].ContentDocumentId, ShareType = 'V');
        insert contentDocumentLink;
    	return contentDocumentLink;
	}
    
    public static Account createAccount(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        return account;
    }
    
    public static Attachment createAttachment(Id parentId){
        Attachment attachment = new Attachment();
        attachment.ParentId = parentId;
        attachment.Name = 'Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attachment.Body = bodyBlob;
        insert attachment;
        return attachment;
    }
	
	public static void createGenericConfiguration(){
        NEILON__Generic_Configuration__c genericConfiguration1 = new NEILON__Generic_Configuration__c(Name='Folder Name Field - Account', NEILON__Configuration_Name__c='Folder Name Field - Account', NEILON__Configured_Value__c='Name');
        insert genericConfiguration1;
    }
}
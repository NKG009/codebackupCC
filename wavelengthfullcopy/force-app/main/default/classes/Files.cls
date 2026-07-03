public without sharing class Files {
    //  private static LoggerCP logger = new LoggerCP('Files');
    
    /**
* Each attachment record should have these fields populated:
*  - Id
*  - ParentId
*  - OwnerId
*  - Name
*  - Description
*  - Body
*  - IsPrivate
*  - CreatedById
*  - CreatedDate
*  - LastModifiedById
*  - LastModifiedDate
*/
    public static ContentVersion[] convert(Attachment[] attachments, Boolean deleteConverted) {
        return convert(attachments, deleteConverted, null);
    }
    
    public static ContentVersion[] convert(Attachment[] attachments,
                                           Boolean deleteConverted, Id contentDocumentId) {
                                               
                                               Map<Id, Id> alreadyConvertedAttachmentIds = getAlreadyConvertedAttachmentIds(attachments);
                                               
                                               Attachment[] attachmentsToConvert = new Attachment[] {};
                                                   for (Attachment attachment : attachments) {
                                                       if (alreadyConvertedAttachmentIds.containsKey(attachment.Id)) {
                                                           continue;
                                                       }
                                                       
                                                       SObjectType parentType = attachment.ParentId.getSobjectType();
                                                       if (EmailMessage.SObjectType == parentType || EmailTemplate.SObjectType == parentType) {
                                                           continue;
                                                       }
                                                       
                                                       attachmentsToConvert.add(attachment);
                                                   }
                                               
                                               ContentVersion[] versions = new ContentVersion[] {};
                                                   if (contentDocumentId == null) {
                                                       versions = create(attachmentsToConvert);
                                                   } else {
                                                       versions = create(attachmentsToConvert, contentDocumentId);
                                                   }
                                               
                                               if (deleteConverted) {
                                                   deleteConverted(versions, attachmentsToConvert);
                                               }
                                               
                                               return versions;
                                           }
    
    /**
* Given a list of attachments then returns those
* that have already been converted and their new file IDs.
*/
    private static Map<Id, Id> getAlreadyConvertedAttachmentIds(List<Attachment> attachments) {
        Map<Id, Id> attachmentIdToVersionId = new Map<Id, Id>();
        
        Set<Id> attachmentIds = new Set<Id>();
        Set<Id> parentIds = new Set<Id>();
        
        for (Attachment att : attachments) {
            attachmentIds.add(att.Id);
            parentIds.add(att.ParentId);
        }
        
        ContentDocumentLink[] links = [
            SELECT ContentDocument.LatestPublishedVersionId,
            ContentDocument.LatestPublishedVersion.TRGTFCMS__Attachment_ID__c
            FROM ContentDocumentLink
            WHERE ContentDocument.LatestPublishedVersion.TRGTFCMS__Attachment_ID__c IN :attachmentIds
            AND LinkedEntityId IN :parentIds
        ];
        DbCustom.isReadable(links);
        
        for (ContentDocumentLink link : links) {
            if (link.ContentDocument == null) {
                continue;
            }
            
            ContentVersion version = link.ContentDocument.LatestPublishedVersion;
            if (version != null && attachmentIds.contains(version.TRGTFCMS__Attachment_ID__c)) {
                attachmentIdToVersionId.put(version.TRGTFCMS__Attachment_ID__c, version.Id);
            }
        }
        
        return attachmentIdToVersionId;
    }
    
    /**
* Insert a new file. Note: Org must have "Salesforce CRM Content" enabled. User is not required to have "Salesforce CRM Content User" license. The method sets contentDocumentId, contentVersion, contentDocumentLink in files parameter
*
* @param file File to insert.
*/
    public static ContentVersion create(File file) {
        return create(file, null);
    }
    
    public static ContentVersion create(File file, Id contentDocumentId) {
        return create(new File[] {file}, contentDocumentId)[0];
    }
    
    public static ContentVersion[] create(File[] files) {
        return create(files, null);
    }
    
    /**
* Insert new files. Note: Org must have "Salesforce CRM Content" enabled. User is not required to have "Salesforce CRM Content User" license. The method sets contentDocumentId, contentVersion, contentDocumentLink in files parameter
*
* @param files Files to insert.
*/
    public static ContentVersion[] create(File[] files, Id contentDocumentId) {
        Attachment[] attachments = new Attachment[] {};
            for (File file : files) {
                attachments.add(new Attachment(
                    Name = file.name,
                    Body = file.body,
                    ParentId = file.parentId
                ));
            }
        
        return create(attachments, contentDocumentId);
    }
    
    private static ContentVersion[] create(Attachment[] attachments) {
        return create(attachments, null);
    }
    
    private static ContentVersion[] create(Attachment[] attachments, Id contentDocumentId) {
        //  logger.log('create', 'contentDocumentId', contentDocumentId);
        
        ContentVersion[] versions = new ContentVersion[] {};
            for (Attachment attachment : attachments) {
                //  logger.log('create', 'attachment', attachment);
                
                if (attachment.Body.size() == 0) {
                    attachment.Body = Blob.valueOf('No body');
                }
                
                // We set the owner of the new content file to be the
                // same as the attachment's owner because both fields
                // must have same value to insert the content file.
                // If they do not match then we get error:
                // "Documents in a user's private library must always be owned by that user."
                // The other reason to reference the old record's owner
                // is if the original creator is inactive and the admin
                // needs the new converted file to be owned by an active user.
                // The owner of records can be changed, the created by cannot.
                ContentVersion version = new ContentVersion(
                    // data fields
                    VersionData = attachment.Body,
                    Title = attachment.Name,
                    ContentDocumentId = contentDocumentId,
                    PathOnClient = attachment.Name,
                    FirstPublishLocationId = contentDocumentId == null ? attachment.ParentId : null,
                    ContentLocation = 'S' // 'S' specify this document is in SF.
                );
                
                if (attachment.Id != null) {
                    version.SharingPrivacy = (attachment.IsPrivate ? 'P' : 'N');
                    version.Description = attachment.Description;
                    
                    // audit fields
                    version.OwnerId = attachment.OwnerId; // system requirement, owner and creator must be the same
                    version.CreatedById = attachment.OwnerId;
                    version.CreatedDate = attachment.CreatedDate;
                    version.LastModifiedById = attachment.LastModifiedById;
                    version.LastModifiedDate = attachment.LastModifiedDate;
                    
                    // custom fields for history tracking and conversion purposes
                    version.TRGTFCMS__Attachment_ID__c = attachment.Id;
                    version.TRGTFCMS__Attachment_Parent_ID__c = attachment.ParentId;
                    version.TRGTFCMS__Attachment_Owner_ID__c = attachment.OwnerId;
                }
                
                /*
// determine if communities are enabled and if so then we will need
// to assign the network id field when inserting the content versions
// otherwise error "INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY" occurs
// if community user uploads an attachment and it tries to get converted
// https://github.com/DouglasCAyers/sfdc-convert-attachments-to-chatter-files/issues/9
MetadataUtilNew mdVersion = MetadataUtilNew.getInstance(ContentVersion.SObjectType);
Boolean communitiesEnabled = (mdVersion.getSObjectField('NetworkId') != null);

// if communities are enabled then assign network id
if (communitiesEnabled) {
newFileVersion.put('NetworkId', this.networkId);
}*/
                
                //  logger.log('create', 'version', version);
                
                versions.add(version);
            }
        
        Db.doInsert(versions, new SObjectField[] {
            ContentVersion.VersionData,
                ContentVersion.Title,
                ContentVersion.PathOnClient,
                ContentVersion.FirstPublishLocationId,
                ContentVersion.ContentLocation,
                ContentVersion.ContentDocumentId,
                ContentVersion.SharingPrivacy,
                ContentVersion.Description,
                
                ContentVersion.OwnerId,
                ContentVersion.CreatedById,
                ContentVersion.CreatedDate,
                ContentVersion.LastModifiedById,
                ContentVersion.LastModifiedDate,
                
                ContentVersion.TRGTFCMS__Attachment_ID__c,
                ContentVersion.TRGTFCMS__Attachment_Parent_ID__c,
                ContentVersion.TRGTFCMS__Attachment_Owner_ID__c
                });
        
        //  logger.log('create', 'versions', versions);
        
        return versions;
    }
    
    private static void deleteConverted(ContentVersion[] versions, Attachment[] attachments) {
        List<Attachment> attachmentsToDelete = new List<Attachment>();
        
        Map<Id, Attachment> attachmentMap = new Map<Id, Attachment>(attachments);
        for (ContentVersion version : versions) {
            attachmentsToDelete.add(attachmentMap.get(version.TRGTFCMS__Attachment_ID__c));
        }
        
        if (attachmentsToDelete.size() > 0) {
            Db.doDelete(attachmentsToDelete);
        }
    }
    
    public static ContentDocumentLink[] linkDocumentToRecord(Id contentDocumentId, Id recordId) {
        return linkDocumentToRecord(new Id[] {contentDocumentId}, new Id[] {recordId});
    }
    
    /**
* Single Content Document IDs in the list are in the same order as parent record IDs.
*
* @param contentDocumentIds
* @param recordIds
*
* @return
*/
    public static ContentDocumentLink[] linkDocumentToRecord(
        Id[] contentDocumentIds, Id[] recordIds) {
            
            ContentDocumentLink[] links = new ContentDocumentLink[] {};
                for (Integer i = 0; i < contentDocumentIds.size(); i++) {
                    Id contentDocumentId = contentDocumentIds[i];
                    Id recordId = recordIds.size() == 1
                        ? recordIds[0]
                        : recordIds[i];
                    
                    links.add(new ContentDocumentLink(
                        ContentDocumentId = contentDocumentId,
                        LinkedEntityId = recordId,
                        ShareType = 'V',
                        Visibility = 'AllUsers'
                    ));
                }
            
            Db.doInsert(links, new SObjectField[] {
                ContentDocumentLink.ContentDocumentId,
                    ContentDocumentLink.LinkedEntityId,
                    ContentDocumentLink.ShareType,
                    ContentDocumentLink.Visibility
                    });
            
            return links;
        }
    
    public static ContentVersion getContentVersionById(Id versionId) {
        return getContentVersionsByIds(new Id[] {versionId})[0];
    }
    
    /**
* @param versionIds
*
* @return Versions are returned in the same order as IDs in versionIds parameter.
*/
    public static ContentVersion[] getContentVersionsByIds(Id[] versionIds) {
        Db.isReadable(ContentVersion.SObjectType, new SObjectField[] {
            ContentVersion.Title,
                ContentVersion.PathOnClient,
                ContentVersion.FileType,
                ContentVersion.VersionData,
                ContentVersion.ContentDocumentId,
                ContentVersion.OwnerId,
                ContentVersion.LastModifiedDate
                });
        Map<Id, ContentVersion> versionsMap = new Map<Id, ContentVersion>([
            SELECT Title, PathOnClient, FileType, VersionData,
            ContentDocumentId, Owner.Name, LastModifiedDate
            FROM ContentVersion
            WHERE Id IN :versionIds
        ]);
        
        ContentVersion[] resultVersions = new ContentVersion[] {};
            for (Id versionId : versionIds) {
                resultVersions.add(versionsMap.get(versionId));
            }
        
        return resultVersions;
    }
    
    /**
*
*
* @param parentId
*
* @return Content Versions of the parent. If parent doesn't have a Content Version then it's ID will be mapped to empty ContentVersion array.
*/
    public static ContentVersion[] getContentVersionsByParentId(Id parentId) {
        return getContentVersionsByParentIds(new Id[] {parentId}).get(parentId);
    }
    
    /**
*
*
* @param parentId
* @param additionalFilterForDocumentLinks
*
* @return Content Versions of the parent. If parent doesn't have a Content Version then it's ID will be mapped to empty ContentVersion array.
*/
    public static ContentVersion[] getContentVersionsByParentId(
        Id parentId, String additionalFilterForDocumentLinks) {
            
            return getContentVersionsByParentIds(
                new Id[] {parentId}, additionalFilterForDocumentLinks).get(parentId);
        }
    
    /**
*
*
* @param parentIds
*
* @return Content Versions grouped by Parent IDs. If parent doesn't have a Content Version then it's ID will be mapped to empty ContentVersion array.
*/
    public static Map<Id, ContentVersion[]> getContentVersionsByParentIds(Id[] parentIds) {
        return getContentVersionsByParentIds(parentIds, (String)null);
    }
    
    public static Map<Id, ContentVersion[]> getContentVersionsByParents(SObject[] parents) {
        return getContentVersionsByParentIds(
            new List<Id>(new Map<Id, SObject>(parents).keySet()), (String)null);
    }
    
    /**
* Returns Content Versions grouped by Parent IDs as a Map.
*
* @param parentIds Parent records' IDs.
* @param additionalFilterForDocumentLinks Additional criteria applied to ContentDocumentLink object query.
*
* @return Content Versions grouped by Parent IDs. If parent doesn't have a Content Version then it's ID will be mapped to empty ContentVersion array.
*/
    public static Map<Id, ContentVersion[]> getContentVersionsByParentIds(
        Id[] parentIds, String additionalFilterForDocumentLinks) {
            
            //  logger.log('getContentVersionsByParentIds', 'parentIds', parentIds);
            //  logger.log('getContentVersionsByParentIds',
            //      'additionalFilterForDocumentLinks', additionalFilterForDocumentLinks);
            
            Map<Id, List<SObject>> parentIdToLinks = new Map<Id, List<SObject>>();
            if (parentIds.size() > 0) {
                String fields = '' +
                    'LinkedEntityId, ' +
                    'ContentDocument.LatestPublishedVersion.Title, ' +
                    'ContentDocument.LatestPublishedVersion.PathOnClient, ' +
                    'ContentDocument.LatestPublishedVersion.FileType, ' +
                    'ContentDocument.LatestPublishedVersion.VersionData, ' +
                    'ContentDocument.LatestPublishedVersion.ContentDocumentId, ' +
                    'ContentDocument.LatestPublishedVersion.Owner.Name, ' +
                    'ContentDocument.LatestPublishedVersion.CreatedDate, ' +
                    'ContentDocument.LatestPublishedVersion.LastModifiedDate';
                
                Db.isReadable(ContentDocumentLink.SObjectType, fields);
                String query = '' +
                    ' SELECT ' + fields +
                    ' FROM ContentDocumentLink ' +
                    ' WHERE LinkedEntityId IN :parentIds ';
                
                if (String.isNotBlank(additionalFilterForDocumentLinks)) {
                    query += ' AND ' + additionalFilterForDocumentLinks;
                }
                
                //      logger.log('getContentVersionsByParentIds', 'query', query);
                
                ContentDocumentLink[] links = Database.query(query);
                
                parentIdToLinks = GroupByHelper.groupByFieldKeyId(links, 'LinkedEntityId');
            }
            
            Map<Id, ContentVersion[]> parentIdToVersions = new Map<Id, ContentVersion[]>();
            for (Id parentId : parentIds) {
                ContentVersion[] versions = new ContentVersion[] {};
                    parentIdToVersions.put(parentId, versions);
                
                ContentDocumentLink[] parentLinks = parentIdToLinks.get(parentId);
                if (parentLinks == null) {
                    continue;
                }
                
                for (ContentDocumentLink link : parentLinks) {
                    versions.add(link.ContentDocument.LatestPublishedVersion);
                }
            }
            
            return parentIdToVersions;
        }
    
    public static void deleteFile(Id contentDocumentId) {
        deleteFiles(new Id[] {contentDocumentId});
    }
    
    public static void deleteFiles(Id[] contentDocumentIds) {
        ContentDocument[] documents = new ContentDocument[] {};
            for (Id contentDocumentId : contentDocumentIds) {
                documents.add(new ContentDocument(Id = contentDocumentId));
            }
        Db.doDelete(documents);
    }
    
    /**
* @param fileName File's name. Make sure extension is there.
* @param body File's content.
* @param parentId Id of an entity the file will be attached to. Can be Chatter users, groups, records (any that support Chatter feed tracking including custom objects), and Salesforce CRM Content libraries.
*/
    public with sharing class File {
        public String name { get; set; }
        public Blob body { get; set; }
        public Id parentId { get; set; }
        
        public File() {
        }
        
        public File(String name, Blob body, Id parentId) {
            this.name = name;
            this.body = body;
            this.parentId = parentId;
        }
    }
    
    public static ContentVersion[] getContentVersionsByParentId(
        Id parentId, Boolean getVersionData) {
            
            return getContentVersionsByParentIds(new Id[] {parentId}, getVersionData).get(parentId);
        }
    
    public static Map<Id, ContentVersion[]> getContentVersionsByParentIds(
        Id[] parentIds, Boolean getVersionData) {
            
            return getContentVersionsByParentIds(parentIds, getVersionData, null);
        }
    
    public static Map<Id, ContentVersion[]> getContentVersionsByParentIds(
        Id[] parentIds, Boolean getVersionData, String additionalFilter) {
            
            //    logger.log('getContentVersionsByParentIds', 'parentIds', parentIds);
            //    logger.log('getContentVersionsByParentIds', 'additionalFilter', additionalFilter);
            
            Map<Id, List<SObject>> parentIdToLinks = new Map<Id, List<SObject>>();
            if (parentIds.size() > 0) {
                String fields = '' +
                    'LinkedEntityId, ' +
                    'ContentDocument.LatestPublishedVersion.Title, ' +
                    'ContentDocument.LatestPublishedVersion.PathOnClient, ' +
                    'ContentDocument.LatestPublishedVersion.FileType, ' +
                    'ContentDocument.LatestPublishedVersion.ContentDocumentId, ' +
                    'ContentDocument.LatestPublishedVersion.Owner.Name, ' +
                    'ContentDocument.LatestPublishedVersion.CreatedDate, ' +
                    'ContentDocument.LatestPublishedVersion.LastModifiedDate';
                
                if (getVersionData) {
                    fields += ', ContentDocument.LatestPublishedVersion.VersionData';
                }
                
                String query = '' +
                    ' SELECT ' + fields +
                    ' FROM ContentDocumentLink ' +
                    ' WHERE LinkedEntityId IN :parentIds ';
                
                if (String.isNotBlank(additionalFilter)) {
                    query += ' AND ' + additionalFilter;
                }
                query += ' ORDER BY ContentDocument.LatestPublishedVersion.CreatedDate DESC';
                
                //      logger.log('getContentVersionsByParentIds', 'query', query);
                
                ContentDocumentLink[] links = Database.query(query);
                Db.isReadable(links);
                
                parentIdToLinks = GroupByHelper.groupByFieldKeyId(links, 'LinkedEntityId');
            }
            
            Map<Id, ContentVersion[]> parentIdToVersions = new Map<Id, ContentVersion[]>();
            for (Id parentId : parentIds) {
                ContentVersion[] versions = new ContentVersion[] {};
                    parentIdToVersions.put(parentId, versions);
                
                ContentDocumentLink[] parentLinks = parentIdToLinks.get(parentId);
                if (parentLinks == null) {
                    continue;
                }
                
                for (ContentDocumentLink link : parentLinks) {
                    versions.add(link.ContentDocument.LatestPublishedVersion);
                }
            }
            
            return parentIdToVersions;
        }
}
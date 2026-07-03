/*
* Class Name: AttachmentInsertInquiryGuestUserHandler
* Description: JPC-2485 - Trigger on attachment to work for Inquiry SiteUser
                Handler Class of AttachmentInsertInquirySiteGuestUser Trigger
* Test Class: TestAttachmentInsertInquiryGuestHandler
* Date : 18th Feb 2020
*/
public class AttachmentInsertInquiryGuestUserHandler{
    
     /*
    * Method Name: handleAfterInsert
    * Description: To Process all record
    * Parameters : Map<Id, Attachment> newItems
    * Return Type: void
    * Date : 18th Feb 2020
    */
    public static void handleAfterInsert(Map<Id, Attachment> newItems) {
        
        List<ContentVersion> lstCntVersionsToInsert = new List<ContentVersion>();       
        Id ProfileId = [SELECT Id FROM Profile WHERE Name = 'Inquiry Profile'].Id;
        List<User> inquirySiteUser = [Select id from User where ProfileId = :ProfileId];
        
        Map<Id,ContentVersion> attachmentIdContentVersion = new Map<Id,ContentVersion>();
        Map<Id,Id> attachmentIdParentId = new Map<Id,Id>();
        
        //CV Parser
        for(Attachment attIterator : newItems.values()){
            system.debug('+++++attIterator.CreatedById+++++++'+attIterator.CreatedById);
            if(attIterator.ParentId != null && attIterator.Name.contains('Resume')){
                system.debug('+++++insertattachment'+attIterator.ParentId);
                ContentVersion objCntVersion = new ContentVersion();
                objCntVersion.Title = attIterator.Name;
                objCntVersion.PathOnClient = '/' + attIterator.Name;
                objCntVersion.VersionData = (attIterator.Body == null ? Blob.valueOf('.') : attIterator.Body);
                objCntVersion.Description = attIterator.Description;
                objCntVersion.SharingPrivacy = 'N'; // Can be always public.
                objCntVersion.FirstPublishLocationId = attIterator.ParentId; // Parent Id
                objCntVersion.OwnerId = attIterator.OwnerId;
                // To avoid "Documents in a user's private library must always be owned by that user" error.
                objCntVersion.CreatedById = attIterator.OwnerId; 
                objCntVersion.CreatedDate = attIterator.CreatedDate;
                objCntVersion.FirstPublishLocationId = attIterator.OwnerId;
                attachmentIdContentVersion.put(attIterator.id,objCntVersion);
                attachmentIdParentId.put(attIterator.id,attIterator.ParentId);
            }
        }
        
        if(inquirySiteUser!=null && !inquirySiteUser.isEmpty()){
            for(Attachment attIterator : newItems.values()){
                system.debug('+++++attIterator.CreatedById+++++++'+attIterator.CreatedById);
                if(attIterator.CreatedById.equals(inquirySiteUser[0].Id) && attIterator.ParentId != null){
                    system.debug('+++++insertattachment'+attIterator.ParentId);
                    ContentVersion objCntVersion = new ContentVersion();
                    objCntVersion.Title = attIterator.Name;
                    objCntVersion.PathOnClient = '/' + attIterator.Name;
                    objCntVersion.VersionData = (attIterator.Body == null ? Blob.valueOf('.') : attIterator.Body);
                    objCntVersion.Description = attIterator.Description;
                    objCntVersion.SharingPrivacy = 'N'; // Can be always public.
                    objCntVersion.FirstPublishLocationId = attIterator.ParentId; // Parent Id
                    objCntVersion.OwnerId = attIterator.OwnerId;
                    // To avoid "Documents in a user's private library must always be owned by that user" error.
                    objCntVersion.CreatedById = attIterator.OwnerId; 
                    objCntVersion.CreatedDate = attIterator.CreatedDate;
                    objCntVersion.FirstPublishLocationId = attIterator.OwnerId;
                    attachmentIdContentVersion.put(attIterator.id,objCntVersion);
                    attachmentIdParentId.put(attIterator.id,attIterator.ParentId);
                }
            }
            
            system.debug('+++++attachmentIdContentVersion.values()+++++++'+attachmentIdContentVersion.values());
            if(!attachmentIdContentVersion.isEmpty() && attachmentIdContentVersion.values().size() > 0) {
                insert attachmentIdContentVersion.values();
            }system.debug('+++++attachmentIdContentVersion.values()+++++++'+attachmentIdContentVersion.values());
            
            //to map ContentVersionId with AttachmentParent Id for ContentDocument Linking
            Map<Id,Id> cvToAttchmtParentIdMap = new Map<Id,Id>();
            List<Id> contentVersionIds = new List<Id>();
            for(Id key : attachmentIdContentVersion.keySet()){
                ContentVersion cv = attachmentIdContentVersion.get(key);
                Id attchmentParentId = attachmentIdParentId.get(key);
                //System.debug('cvToAttchmtParentIdMap'+cvToAttchmtParentIdMap);
                cvToAttchmtParentIdMap.put(cv.Id,attchmentParentId);
                contentVersionIds.add(cv.Id);
                //System.debug('cvIds'+cvIds);
            }
            
            //Fetching contentDocumentId using contentVersionId
            List<ContentVersion> cvWithContentDocIds=[select Id,ContentDocumentId from ContentVersion where Id IN :contentVersionIds];
            System.debug('cvDocIds'+cvWithContentDocIds);

            //to link the files (versions) to its parent records like opportunity,case etc.
            List<ContentDocumentLink> listContentDocumentLinkInsert = new List<ContentDocumentLink>();
            if(!attachmentIdContentVersion.isEmpty()){
                for (ContentVersion cv : cvWithContentDocIds) {
                    Id attachmentParentId = cvToAttchmtParentIdMap.get(cv.Id);
                    ContentDocumentLink contentDocumentLink = new ContentDocumentLink(LinkedEntityId = attachmentParentId, ContentDocumentId = cv.ContentDocumentId, ShareType = 'I');
                    listContentDocumentLinkInsert.add(contentDocumentLink);
                }

                if(listContentDocumentLinkInsert.size() > 0){
                    insert listContentDocumentLinkInsert;
                }system.debug('+++++listContentDocumentLinkInsert+++++++'+listContentDocumentLinkInsert);
            }
        }
    }

}
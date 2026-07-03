/*
* Trigger Name: AttachmentInsertInquirySiteGuestUser
* Description: JPC-2485 - Trigger on attachment to work for Inquiry SiteUser
* Test Class: TestAttachmentInsertInquiryGuestHandler
* Date : 18th Feb 2020
*/
trigger AttachmentInsertInquirySiteGuestUser on Attachment (after insert) {
    
    // After trigger logic
    if (Trigger.IsAfter){
        if (Trigger.IsInsert){
            AttachmentInsertInquiryGuestUserHandler.handleAfterInsert(Trigger.newMap);
        }
    }
    
}
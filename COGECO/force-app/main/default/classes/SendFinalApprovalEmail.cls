public class SendFinalApprovalEmail {

    public virtual class BaseException extends Exception {}
    public class StageException extends BaseException {}

    @InvocableMethod
    public static void sendCustomerFinalApprovalEmail(list<EmailWrapper> lstEmailWrapper){
      try{
        Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
        List<EmailTemplate> emailTemplate = new List<EmailTemplate>();
          
        String internalEmailTemplateName = 'Contract Approved Internal';
        String customerEmailTemplateName = 'Customer Contract Approved';
        
        List<String> internalEmails = cscrm_Settings__c.getInstance().Internal_Contract_Delivery_Email__c.split(',');
        //system.debug(lstEmailWrapper[0].strLangauge);
      
        customerEmailTemplateName = lstEmailWrapper[0].strLangauge.contains('fr') ? customerEmailTemplateName + ' FR': customerEmailTemplateName + ' EN';
        internalEmailTemplateName = lstEmailWrapper[0].strLangauge.contains('fr') ? internalEmailTemplateName + ' FR': internalEmailTemplateName + ' EN';

      // system.debug('Internal Template ---> '+internalEmailTemplateName);
      // system.debug('Customer Template ---> '+customerEmailTemplateName);
        
        // system.debug('Emails Size --> '+internalEmails.size() + ' Email List ---> '+internalEmails);
        
        List<Opportunity> opps = [Select Id, Province__c from opportunity where id =: lstEmailWrapper[0].strOpportunityId];
        List<OpportunityContactRole> contactRoles = [SELECT Id, ContactId FROM OpportunityContactRole where OpportunityId =: lstEmailWrapper[0].strOpportunityId AND IsPrimary = True];
        List<Contact> contact = [SELECT id, Email from Contact where Id =: contactRoles[0].ContactId];

        objEmail.setTargetObjectId(contact[0].Id);
        
        objEmail.setTreatTargetObjectAsRecipient(false);

        //objEmail.setSenderDisplayName(param0)
        List<OrgWideEmailAddress> fromEmail = [Select Id, Address from OrgWideEmailAddress where DisplayName ='No Reply - Business Solutions' limit 1];
        objEmail.setOrgWideEmailAddressId(fromEmail[0].id);
      
          // Set the Template Id
      // system.debug('Email template name ---> '+lstEmailWrapper[0].strEmailTemplate);
        if((lstEmailWrapper[0].strEmailTemplate + ' EN' == customerEmailTemplateName) || (lstEmailWrapper[0].strEmailTemplate + ' FR' == customerEmailTemplateName)){
          // Set the Email of the Recipient.
          objEmail.setToAddresses(new list<String>{contact[0].Email});
          emailTemplate = [SELECT Id, Name FROM EmailTemplate WHERE Name = :customerEmailTemplateName LIMIT 1];
        }
        //internal emails to be sent in else statement, only to ontario
        else {
          if(opps[0].Province__c == 'ON'){
            emailTemplate = [SELECT Id, Name FROM EmailTemplate WHERE Name = :internalEmailTemplateName LIMIT 1];
            objEmail.setToAddresses(internalEmails);
          }
          // objEmail.setWhatId(lstEmailWrapper[0].strOpportunityId);
        }
        if(emailTemplate != null && emailTemplate.size() > 0){
          objEmail.setTemplateId(emailTemplate[0].Id);
          objEmail.setWhatId(lstEmailWrapper[0].strOpportunityId);
            // get attachments from Opp
            //SELECT id, LinkedEntityId, ContentDocument.title FROM ContentDocumentLink WHERE LinkedentityId='00656000008GsCXAA0'
            List<ContentDocumentLink> files = [SELECT id, LinkedEntityId, ContentDocument.title, ContentDocumentId FROM ContentDocumentLink WHERE LinkedentityId=:lstEmailWrapper[0].strOpportunityId AND (ContentDocument.title LIKE 'EN-%' OR ContentDocument.title LIKE 'FR-%') limit 1];
            objEmail.setFileAttachments(ContentDocumentAsAttachement(files[0].ContentDocumentId));
            Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {objEmail});

            if(!emailResult[0].isSuccess()){
                System.debug('Error :' +emailResult[0].getErrors());
            } else{
                System.debug('Success');
            } 
        }
      }
      catch(Exception ex){
        system.debug(ex.getMessage());
      
      }
    }

    public static List<Messaging.EmailFileAttachment> ContentDocumentAsAttachement(string contentDocumentId) {
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>{};
        List<ContentVersion> documents                  = new List<ContentVersion>{};
    
        documents.addAll([
          SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId
          FROM ContentVersion
          WHERE isLatest = true AND ContentDocumentId = :contentDocumentId
        ]);
    
        for (ContentVersion document: documents) {
          Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
    
          attachment.setBody(document.VersionData);
          attachment.setFileName(document.Title);
    
          attachments.add(attachment);
        }
    
        return attachments;
    
    }
}
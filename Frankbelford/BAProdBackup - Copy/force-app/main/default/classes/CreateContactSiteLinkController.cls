public class CreateContactSiteLinkController {

    public Id contactId{get;set;}
    public Contact_Site_Link__c newContactSiteLink{get;set;}
    public Boolean saveNewValue;
    public Contact contact{get;set;}

    public CreateContactSiteLinkController(ApexPages.StandardController controller) {    
        contactId = ApexPages.CurrentPage().getparameters().get('Id');
        system.debug('++++++++++contactId'+contactId );
        saveNewValue = false;
        newContactSiteLink = new Contact_Site_Link__c();
        contact = [Select id,Name,AccountId,Account.Name from Contact where Id=:contactId];
        newContactSiteLink.IP_Contact__c = contactId;
        newContactSiteLink.Account__c = Contact.AccountId;
    }
    
    @AuraEnabled
    public static Contact getSiteContactLink(String contactId){
        if(contactId.contains('&uid')){
            contactId = contactId.removeEnd('&uid');
        }
        Contact conRecord = [Select Id,AccountId from Contact where Id=:contactId];
        return conRecord;
    }
    
    @AuraEnabled
    Public Static String saveNewRecord(Contact_Site_link__c siteContactData,String siteId){
        try{
            system.debug('++++++siteContactData++++++'+siteContactData);
            siteContactData.IP_Site__c = siteId;
            insert siteContactData;            
            return siteContactData.id+'success';
        }
        catch(Exception e){
            String message = 'Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, ';
            String messageValidation = 'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ';
            if(e.getmessage().contains(message)){
                message = e.getmessage().substringAfter(message);
                if(message.contains(': [IP_Site__c]')){
                    message = message.substringBefore(': [IP_Site__c]');
                }
                return message;
            }else if(e.getmessage().contains(messageValidation)){system.debug('++++++44++++++'+e.getmessage());
                messageValidation = e.getmessage().substringAfter(messageValidation);system.debug('++++++messageValidation++++++'+messageValidation);
                if(messageValidation.contains(': []')){
                    messageValidation = messageValidation.substringBefore(': []');
                }
                return messageValidation;
            }
            else{
                return e.getmessage();
            }
        }
    }
    
    Public PageReference cancelRecord(){
        PageReference pageRef = new pageReference('/lightning/r/Contact/'+contactId+'/view'); 
        system.debug('pageRef'+pageRef);
        pageRef.setRedirect(true);
        return pageRef;
    }

}
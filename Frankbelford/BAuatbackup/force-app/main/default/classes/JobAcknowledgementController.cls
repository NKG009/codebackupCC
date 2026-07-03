public without sharing class JobAcknowledgementController {
    public Boolean emailSent { get; set; }
    public String errorMessage { get; set; }
    
    public JobAcknowledgementController() {
        emailSent = false;
        errorMessage = null;
    }
    
    public PageReference sendAcknowledgement() {
        try {
            Id contactId = ApexPages.currentPage().getParameters().get('contactId');
            Id jobOrderId = ApexPages.currentPage().getParameters().get('jobOrderId');
            
            if (String.isBlank(contactId) || String.isBlank(jobOrderId)) {
                errorMessage = 'Required details are missing. Please contact the BA Admin for further assistance.';
                return null;
            }
            
            Contact contact = [
                SELECT Id, Name, Email, Account.Name 
                FROM Contact 
                WHERE Id = :contactId 
                LIMIT 1
            ];
            
            sirenum__JobOrder__c jobOrder = [
                SELECT Id, sirenum__JobRole__r.Name, sirenum__Site__r.Name,Job_Order_Number__c, sirenum__StartDate__c 
                FROM sirenum__JobOrder__c 
                WHERE Id = :jobOrderId 
                LIMIT 1
            ];
            
            User adminUser = [
                SELECT Email 
                FROM User 
                WHERE Name = 'MSP Team' 
                LIMIT 1
            ];
            
            String body = ''
                 + '<p>Dear MSP Team,</p>'
                
                + '<p>The following acknowledgement has been submitted:</p>'
                
                + '<h3>Supplier Details</h3>'
                + '<ul>'
                + '<li><b>Supplier Contact Name:</b> ' + contact.Name + '</li>'
                + '<li><b>Supplier Account Name:</b> ' + (contact.Account != null ? contact.Account.Name : 'N/A') + '</li>'
                + '</ul>'
                
                + '<h3>Job Order Details</h3>'
                + '<ul>'
                + '<li><b>Job Order Number:</b> ' + jobOrder.Job_Order_Number__c + '</li>'
                + '<li><b>Job Role:</b> ' + jobOrder.sirenum__JobRole__r.Name + '</li>'
                + '<li><b>Site Name:</b> ' + jobOrder.sirenum__Site__r.Name + '</li>'
                + '<li><b>Start Date:</b> ' + String.valueOf(jobOrder.sirenum__StartDate__c) + '</li>'
                + '</ul>';
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { adminUser.Email, 'ajay@frankbelford.com' });
            mail.setSubject('New Acknowledgement Submitted');
            mail.setHtmlBody(body);
            mail.setOrgWideEmailAddressId(getOrgWideEmailAddressId('no.reply@bluearrow.co.uk'));
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            emailSent = true;
        } catch (Exception e) {
            errorMessage = 'An error occurred: ' + e.getMessage();
        }
        
        return null;
    }
    
    private static Id getOrgWideEmailAddressId(String emailAddress) {
        List<OrgWideEmailAddress> oweaList = [
            SELECT Id 
            FROM OrgWideEmailAddress 
            WHERE Address = :emailAddress 
            LIMIT 1];
        return oweaList.isEmpty() ? null : oweaList[0].Id;
    }
    
}
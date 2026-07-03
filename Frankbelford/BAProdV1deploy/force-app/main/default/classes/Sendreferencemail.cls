global class Sendreferencemail {
    
    webservice static String sendEmail(id pid, string type){
        String result;
        String inactiveStatus = 'Inactive';
        try{
            ts2__Reference__c p = [select id ,ts2__Status__c,ts2__Name__c,ts2__Email__c,
                                    ts2__Candidate__c, ts2__Candidate__r.Brand__c from ts2__Reference__c where id =: pid];
            if(!inactiveStatus.equals(p.ts2__Status__c)){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
                //Id templateId;
                //templateId = [select id, name from EmailTemplate where developername = 'Sendrefrencemail'].id;
                Id templateId = Util.getEmailTemplateMapping(p.ts2__Candidate__r.Brand__c,'Reference Request').TemplateId__c;
                string[] toaddress = new String[] {p.ts2__Email__c};
                email.setToAddresses(toaddress);  
                email.setTargetObjectId(p.ts2__Candidate__c);
                email.setTreatTargetObjectAsRecipient(false);
                email.setWhatid(p.id);
                email.setTemplateId(templateId);
                email.setSaveasActivity(true); 

                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                result = 'Email Sent';
            }
            else if(inactiveStatus.equals(p.ts2__Status__c)){
                result = 'Email cannot be send because the status of the reference is inactive.';
            }
        } catch(Exception e) {
            result = 'Error in sending email. Please contact your system admin.';
        }
        return result;
    }
}
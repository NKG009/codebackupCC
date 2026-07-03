global class Sendreferencemaillightning {

    @AuraEnabled
    public static ts2__Reference__c getreferenceDetail(String referenceid) {
        ts2__Reference__c ref = [Select id,ts2__Status__c ,ts2__Name__c,ts2__Email__c,ts2__Candidate__c from ts2__Reference__c where id=:referenceid];
        return ref;
    }
  
    @AuraEnabled
    public static String sendemail(String referenceid) {
        String result;
        String inactiveStatus = 'Inactive';
        try {
            ts2__Reference__c p = [select id,ts2__Status__c,ts2__Name__c,Date_Reference_Request_Sent__c,
                                          Date_Latest_Reference_Reminder_Sent__c,ts2__Email__c,ts2__Candidate__c,
                                          ts2__Candidate__r.Brand__c
                                    from ts2__Reference__c where id =: referenceid];
            //Contact candidate = [SELECT Id, Email, Brand__c FROM Contact WHERE ]
            system.debug('++++++++pppppppppp++++++'+p);
            if(!inactiveStatus.equals(p.ts2__Status__c)){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
                Id templateId;
                system.debug('++++++++templateId++++++'+templateId);
                //templateId = [select id, name from EmailTemplate where developername = 'Sendrefrencemail'].id;
                templateId = Util.getEmailTemplateMapping(p.ts2__Candidate__r.Brand__c,'Reference Request').TemplateId__c;
                system.debug('++++++++templateId++++++'+templateId); 
                string[] toaddress = new String[] {p.ts2__Email__c};
                email.setToAddresses(toaddress);  
                email.setTargetObjectId(p.ts2__Candidate__c);
                email.setTreatTargetObjectAsRecipient(false);
                email.setWhatid(p.id);
                email.setTemplateId(templateId);
                email.setSaveasActivity(true); 

                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                 system.debug('++++++++templateId++++++'+r);
                result = 'Email Sent';
                p.Date_Reference_Request_Sent__c = System.now();
                p.Date_Latest_Reference_Reminder_Sent__c = System.now();
                if(p.ts2__Status__c == '' || p.ts2__Status__c == 'Action Required'){
                    p.ts2__Status__c = 'Sent';
                }
                else{
                    p.ts2__Status__c = 'Resent';
                }
                update p;
            }
            else if(inactiveStatus.equals(p.ts2__Status__c)){
                result = 'Email cannot be send because the status of the reference is inactive.';
            }
        } catch(Exception e) {
            system.debug('++++++++1111++++++'+e.getLineNumber());
            result = e.getMessage();
        }
        return result;
    }
}
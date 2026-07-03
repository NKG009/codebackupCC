global class Sendreferencemaillightning {

    @AuraEnabled
    public static TR1__Reference__c getreferenceDetail(String referenceid) {
        TR1__Reference__c ref = [Select id,Status__c ,Name__c,Email__c,TR1__Person_Placed__c from TR1__Reference__c where id=:referenceid];
        return ref;
    }
  
    @AuraEnabled
    public static String sendemail(String referenceid) {
        String result;
        String inactiveStatus = 'Inactive';
        try {
            TR1__Reference__c p = [select id, Status__c,
                                   			Name__c, 
                                   			Date_Reference_Request_Sent__c,
                                          	Date_Latest_Reference_Reminder_Sent__c,
                                   			Email__c,TR1__Person_Placed__c,
                                          	TR1__Person_Placed__r.Brand__c
                                    		from TR1__Reference__c where id =: referenceid];
            //Contact candidate = [SELECT Id, Email, Brand__c FROM Contact WHERE ]
            system.debug('++++++++pppppppppp++++++'+p);
            if(!inactiveStatus.equals(p.Status__c)){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
                Id templateId;
                system.debug('++++++++templateId++++++'+templateId);
                //templateId = [select id, name from EmailTemplate where developername = 'Sendrefrencemail'].id;
                templateId = Util.getEmailTemplateMapping(p.TR1__Person_Placed__r.Brand__c,'Reference Request').TemplateId__c;
                system.debug('++++++++templateId++++++'+templateId); 
                string[] toaddress = new String[] {p.Email__c};
                email.setToAddresses(toaddress);  
                email.setTargetObjectId(p.TR1__Person_Placed__c);
                email.setTreatTargetObjectAsRecipient(false);
                email.setWhatid(p.id);
                email.setTemplateId(templateId);
                email.setSaveasActivity(true); 

                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                 system.debug('++++++++templateId++++++'+r);
                result = 'Email Sent';
                p.Date_Reference_Request_Sent__c = System.now();
                p.Date_Latest_Reference_Reminder_Sent__c = System.now();
                if(p.Status__c == '' || p.Status__c == 'Action Required'){
                    p.Status__c = 'Sent';
                }
                else{
                    p.Status__c = 'Resent';
                }
                update p;
            }
            else if(inactiveStatus.equals(p.Status__c)){
                result = 'Email cannot be send because the status of the reference is inactive.';
            }
        } catch(Exception e) {
            system.debug('++++++++1111++++++'+e.getLineNumber());
            result = e.getMessage();
        }
        return result;
    }
}
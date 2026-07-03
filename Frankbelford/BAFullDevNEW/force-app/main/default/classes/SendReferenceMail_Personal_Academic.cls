public class SendReferenceMail_Personal_Academic{
    
    private static final string REFERENCE_DEVELOPER_NAME = 'Sendrefrencemail';
    private static final string SENT_STATUS = 'Sent';
    private static final string RESENT_STATUS = 'Resent';
    private static final string ACTION_STATUS = 'Action Required';
    private static final string INACTIVE_STATUS = 'Inactive';
    
    @InvocableMethod
    public static void sendEmail(List<String> referenceId){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();            
            List<TR1__Reference__c> reference = [select id,Date_Reference_Request_Sent__c ,Date_Latest_Reference_Reminder_Sent__c,
                                                Status__c,Name__c,Email__c,TR1__Person_Placed__c,TR1__Person_Placed__r.IP_TempestDepartment__c
                                            from TR1__Reference__c where id IN: referenceId limit 1];
            if(!INACTIVE_STATUS.equals(reference[0].Status__c)){
                String department = String.valueOf(reference[0].TR1__Person_Placed__r.IP_TempestDepartment__c);
                IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
                OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];                              
                
                reference[0].Date_Reference_Request_Sent__c = System.now();
                reference[0].Date_Latest_Reference_Reminder_Sent__c = System.now();
                if(String.IsBlank(reference[0].Status__c) || ACTION_STATUS.equals(reference[0].Status__c)){ 
                    reference[0].Status__c = SENT_STATUS; 
                } 
                else { 
                    reference[0].Status__c = RESENT_STATUS; 
                }
                update reference[0];
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
                Id templateId;  
                templateId = [select id, name from EmailTemplate where developername = :REFERENCE_DEVELOPER_NAME].id;
                string[] toaddress = new String[] {reference[0].Email__c};
                email.setToAddresses(toaddress);
                email.setTargetObjectId(reference[0].TR1__Person_Placed__c);
                email.setTreatTargetObjectAsRecipient(false);
                email.setWhatid(reference[0].id);
                email.setOrgWideEmailAddressId(owd.Id);
                email.setTemplateId(templateId);
                email.setSaveasActivity(true);
                mails.add(email);
                Messaging.sendEmail(mails,true);
            }
        } catch(Exception e) {
        }
    }   
}
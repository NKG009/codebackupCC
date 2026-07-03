public class CreditCheckemailcontroller {
@AuraEnabled
    public static String getAccountDetail(String accountId){
        Account acc = [Select id,name,IP_CreditCheckfieldchanged__c,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,comp_house__Company_Creation_Date__c,comp_house__Company_Jurisdiction__c,BillingAddress,comp_house__Company_Number__c,comp_house__Company_Status__c,comp_house__Company_Type__c,IP_CompanyRegistrationNo__c from Account where id=:accountId];
        
        System.debug('Account company number 1'+acc.comp_house__Company_Number__c);
        System.debug('Account company number 2'+acc.name);
        System.debug('Account company number 3'+acc.BillingAddress);
        if(acc.name == '' || acc.BillingStreet == null || acc.BillingCity == null || acc.BillingPostalCode == null || acc.comp_house__Company_Number__c == null){            
                return 'requireddetailsmissing';            
        }
        else{
            String emailSent = sendemailtocredit(acc);
            return emailSent;
        } 
    }
  @AuraEnabled
    public static String getcreditvalue(String accountId){
        Account acc = [Select id,IP_CreditCheckfieldchanged__c from Account where id=:accountId];
        
        if(acc.IP_CreditCheckfieldchanged__c == true){            
                return 'true';            
        }
        else{
            return 'false'; 
        } 
    }
    @AuraEnabled
    public static String accountsetfalse(String accountId){
        Account acc = [Select id,IP_CreditCheckfieldchanged__c from Account where id=:accountId];
        acc.IP_CreditCheckfieldchanged__c = false;
        update acc;
        return 'true';
    }
    
    public static String sendemailtocredit(Account acc){
        String flag;
                acc.IP_CreditCheckfieldchanged__c = false;
           update acc;
            
            String street = acc.BillingStreet.replace('\n',' ');
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
            email.setToAddresses(new String[] {'credit.clearance@bluearrow.co.uk'});
            email.setsubject('Credit Check Request');
            String body = 'Hi Credit Services, \n\n';
            body += 'Please could you credit check the following company: \n\n';
            body += 'Company Name: '+ acc.name +'\n';
            body += 'Company Registration Number : '+acc.IP_CompanyRegistrationNo__c + '\n';
            body += 'Registered Address : '+street+ '\n';
            body += '                                   '+acc.BillingCity+ '\n';
            body += '                                   '+acc.BillingPostalCode+ '\n';
            if(acc.BillingState != null && acc.BillingState != '')
            {
            body += '                                   '+acc.BillingState+'\n';
            }
            if(acc.BillingCountry != null && acc.BillingCountry != '')
            {
            body += '                                    '+acc.BillingCountry+ '\n';
            }
            body += '\n';
            body += 'Thank you,'+ '\n\n';
            body += 'Blue Arrow';
            email.setPlainTextBody(body);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            flag = 'true';
        
        return flag;

}
}
@istest
public class SendemailControllertest{
    
    @istest public static void sendEmailFunctiontest(){
        /*
id accountRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('2nd Tier Supplier').getRecordTypeId();

account acc = new account();
acc.name = 'testaccount';
acc.RecordTypeId = accountRTId; // '0129E0000008tVy';
acc.IP_Business_Type__c = 'Catering';

insert acc;

id contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();

contact con = new contact();
con.LastName = 'test1';
con.RecordTypeId = contactRTId;
con.IP_2nd_Tier_Supplier__c = acc.id;

insert con;
*/
        Account acc = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert acc;
        
        //Inserting Payroll records
        Payroll_Swtich__c payroll = new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        insert payroll;
        
        IP_JSToFrostSwtich__c jsFrostSwitch = new IP_JSToFrostSwtich__c(Name='JSToFrost',IP_RunJSToFrost__c=true);
        insert jsFrostSwitch;
        
        Contact con = TestDataFactory.createCandidate(acc.id, 1)[0];
        Insert con;
        
        
        id payprofileRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        
        IP_PayProfile__c pay = new IP_PayProfile__c();
        
        pay.IP_PayrollID__c = '1234';
        pay.IP_Candidate__c = con.id;
        pay.IP_Status__c    = 'Active';
        pay.IP_CompanyRegNo__c = 'ab123456';
        pay.IP_VATNumber__c    = '123456789';
        pay.IP_VATRegistered__c = true;
        pay.IP_PaymentType__c='BACS';
        insert pay;
        
        
        
        blob b = Blob.valueOf('testing data');
        
        attachment a = new attachment();
        a.Name       = 'test';
        a.body       =  b;
        a.ParentId   =  pay.id;
        
        insert a;
        
        SendemailController send = new SendemailController();
        
        SendemailController.sendEmailFunction(pay.id);
        
    }
    
    
    
}
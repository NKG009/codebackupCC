@isTest
public class Test_CreditCheckemailcontroller {

    static testMethod void creditcheck1(){
     RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
        
        Account acc2 = new Account(Name='Account credit',RecordTypeId=accountRec1.id,comp_house__Company_Number__c = '12345678',BillingStreet = '123', BillingCity = 'abc',BillingPostalCode = '123ba');
        insert acc2;
        
        Test.StartTest();
        CreditCheckemailcontroller.getAccountDetail(acc1.id);
        CreditCheckemailcontroller.getAccountDetail(acc2.id);
        CreditCheckemailcontroller.getcreditvalue(acc1.id);
        CreditCheckemailcontroller.accountsetfalse(acc1.id);
        Test.stopTest();
      }
}
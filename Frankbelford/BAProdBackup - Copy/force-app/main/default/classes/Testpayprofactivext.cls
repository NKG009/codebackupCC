@istest
public class Testpayprofactivext {

    public static testmethod void test1()
    {
      Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
        
        Contact c = TestDataFactory.createContact(acc.id, 1)[0]; 
        insert c;        
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Inactive';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        
        
        insert pay;
        Test.startTest();
        
          ApexPages.StandardController sc = new ApexPages.StandardController(c);
        
        
        Payprofactivext testAccPlan = new Payprofactivext(sc);
        Payprofactivext.wraperpp wr = new Payprofactivext.wraperpp(pay);
        testAccPlan.ppList = testAccPlan.getpayprofile();
        testAccPlan.ppList[0].selected=True; 
        testAccPlan.Finish();
        testAccPlan.closeme();
       
      
            
        PageReference pageRef = Page.Payprofileactive;
        pageRef.getParameters().put('id', String.valueOf(c.Id));
        Test.setCurrentPage(pageRef);
        
        
        Test.stopTest();
    }
    
     public static testmethod void test2()
    {
      Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
        
        Contact c = TestDataFactory.createContact(acc.id, 1)[0]; 
        insert c;  
        
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Inactive';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        
        
        insert pay;
        Test.startTest();
        
          ApexPages.StandardController sc = new ApexPages.StandardController(c);
        
        
        Payprofactivext testAccPlan = new Payprofactivext(sc);
      //  Payprofactivext.wraperpp wr = new Payprofactivext.wraperpp(pay);
      //  testAccPlan.ppList = testAccPlan.getpayprofile();
        testAccPlan.status=false; 
        //testAccPlan.Finish();
       // testAccPlan.closeme();
       
      
            
        PageReference pageRef = Page.Payprofileactive;
        pageRef.getParameters().put('id', String.valueOf(c.Id));
        Test.setCurrentPage(pageRef);
        
        
        Test.stopTest();
    }
        
}
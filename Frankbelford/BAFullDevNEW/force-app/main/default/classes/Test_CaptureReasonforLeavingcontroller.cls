@isTest
public class Test_CaptureReasonforLeavingcontroller {
public static testmethod void reasonforleaving(){
 Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.Birthdate = Date.today().addYears(-20);
        c.EEO_Gender__c = 'Male';
        c.IP_CategoryOfWork__c='Manufacturing';
        c.sirenum__National_Insurance__c='AA123456A';
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
    pay.IP_PaymentType__c = 'BACS';
pay.IP_BankAccountName__c = 'Test Bank Name';
pay.IP_AccountNumber__c = '12345678';
pay.IP_SortCode__c = '112233';
        insert pay;
    
     RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testp76rol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.IP_PaymentType__c = 'BACS';
pay1.IP_BankAccountName__c = 'Test Bank Account';
pay1.IP_AccountNumber__c = '12345678';
pay1.IP_SortCode__c = '112233';
        insert pay1;
    
    Test.startTest();
     PageReference pageRef = Page.CaptureReasonforLeaving; // Add your VF page Name here
           
            pageRef.getParameters().put('id', String.valueOf(c.Id));
            Test.setCurrentPage(pageRef);
            CaptureReasonforLeavingcontroller testAccPlan = new CaptureReasonforLeavingcontroller();
     List<SelectOption> leavingreason = testAccPlan.allleavingreason;
     testAccPlan.selectedleavingreason = 'Pay - Not Enough';
    testAccPlan.processprofiles();
   
    Test.stopTest();

}
public static testmethod void reasonforleaving1(){
 Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.Birthdate = Date.today().addYears(-20);
        c.EEO_Gender__c = 'Male';
        c.IP_CategoryOfWork__c='Manufacturing';
        c.sirenum__National_Insurance__c='AA123456A';
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
     pay.IP_PaymentType__c = 'BACS';
pay.IP_BankAccountName__c = 'Test Bank Name';
pay.IP_AccountNumber__c = '12345678';
pay.IP_SortCode__c = '112233';
        insert pay;
    
     RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testp76rol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
    pay1.IP_PaymentType__c = 'BACS';
pay1.IP_BankAccountName__c = 'Test Bank Account';
pay1.IP_AccountNumber__c = '12345678';
pay1.IP_SortCode__c = '112233';
        insert pay1;
    
    Test.startTest();
     PageReference pageRef = Page.CaptureReasonforLeaving; // Add your VF page Name here
           
            pageRef.getParameters().put('id', String.valueOf(c.Id));
            Test.setCurrentPage(pageRef);
            CaptureReasonforLeavingcontroller testAccPlan = new CaptureReasonforLeavingcontroller();
     List<SelectOption> leavingreason = testAccPlan.allleavingreason;
   //  testAccPlan.selectedleavingreason = 'Pay - Not Enough';
    testAccPlan.processprofiles();
   
    Test.stopTest();

}
public static testmethod void reasonforleaving3(){
 Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.Birthdate = Date.today().addYears(-20);
        c.EEO_Gender__c = 'Male';
        c.IP_CategoryOfWork__c='Manufacturing';
        c.sirenum__National_Insurance__c='AA123456A';
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
     pay.IP_PaymentType__c = 'BACS';
pay.IP_BankAccountName__c = 'Test Bank Name';
pay.IP_AccountNumber__c = '12345678';
pay.IP_SortCode__c = '112233';
        insert pay;
    
     RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testp76rol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
		pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
    pay1.IP_PaymentType__c = 'BACS';
pay1.IP_BankAccountName__c = 'Test Bank Account';
pay1.IP_AccountNumber__c = '12345678';
pay1.IP_SortCode__c = '112233';
        insert pay1;
    
    Test.startTest();
     PageReference pageRef = Page.CaptureReasonforLeaving; // Add your VF page Name here
           
            pageRef.getParameters().put('id', String.valueOf(c.Id));
            Test.setCurrentPage(pageRef);
            CaptureReasonforLeavingcontroller testAccPlan = new CaptureReasonforLeavingcontroller();
     List<SelectOption> leavingreason = testAccPlan.allleavingreason;
     testAccPlan.selectedleavingreason = 'Pay - Not Enough';
    testAccPlan.processprofiles();
   
    Test.stopTest();

}
public static testmethod void reasonforleaving4(){
 Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.Birthdate = Date.today().addYears(-20);
        c.EEO_Gender__c = 'Male';
        c.IP_CategoryOfWork__c='Manufacturing';
        c.sirenum__National_Insurance__c='AA123456A';
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
     pay.IP_PaymentType__c = 'BACS';
pay.IP_BankAccountName__c = 'Test Bank Name';
pay.IP_AccountNumber__c = '12345678';
pay.IP_SortCode__c = '112233';
        insert pay;
    
     RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testp76rol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
    pay1.IP_PaymentType__c = 'BACS';
pay1.IP_BankAccountName__c = 'Test Bank Account';
pay1.IP_AccountNumber__c = '12345678';
pay1.IP_SortCode__c = '112233';
        insert pay1;
    
    Test.startTest();
     PageReference pageRef = Page.CaptureReasonforLeaving; // Add your VF page Name here
           
            pageRef.getParameters().put('id', String.valueOf(c.Id));
            Test.setCurrentPage(pageRef);
            CaptureReasonforLeavingcontroller testAccPlan = new CaptureReasonforLeavingcontroller();
     List<SelectOption> leavingreason = testAccPlan.allleavingreason;
     testAccPlan.selectedleavingreason = 'Pay - Not Enough';
    testAccPlan.processprofiles();
   
    Test.stopTest();

}
    
}
@isTest
private class Test_RequestP45Ext {
    
    @isTest 
    static void leaverPositiveCase() 
    {
        //static Account account;
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
  //  insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
              
         RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='InActive';
        pay.IP_Candidate__c=cont.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        
        
        insert pay;
        
        
        Test.StartTest();
          ApexPages.StandardController sc = new ApexPages.StandardController(cont);
        
        
        RequestP45Ext testAccPlan = new RequestP45Ext(sc);
        RequestP45Ext.wraperpp wr = new RequestP45Ext.wraperpp(pay);
        testAccPlan.ppList = testAccPlan.getpps();
       // testAccPlan.ppList[0].selected=True; 
        testAccPlan.Finish();
        testAccPlan.closeme();
       
      
            
        PageReference pageRef = Page.RequestP45Page;
        pageRef.getParameters().put('id', String.valueOf(cont.Id));
        Test.setCurrentPage(pageRef);
        
        //System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.WARNING));
        
        
        test.stopTest();
        
    }
    
    @isTest 
    static void leaverNegativeCase() 
    {
        //static Account account;
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        /*RecordType condRec = [Select Id  From RecordType Where sObjectType = 'IP_PayProfile__c' And DeveloperName='PAYE'];
IP_PayProfile__c pp = new IP_PayProfile__c(IP_Candidate__c=cont.id,
IP_PaymentType__c='BACS', 
IP_Status__c='Active', 
RecordTypeId=condRec.id,
Reason_for_P45_Internal__c='',
Reason_for_Leaving1__c=''
); */

 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
              
         RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=cont.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        
        
        insert pay;
        
        
        Test.StartTest();
          ApexPages.StandardController sc = new ApexPages.StandardController(cont);
        
        
        RequestP45Ext testAccPlan = new RequestP45Ext(sc);
        RequestP45Ext.wraperpp wr = new RequestP45Ext.wraperpp(pay);
        testAccPlan.ppList = testAccPlan.getpps();
        testAccPlan.ppList[0].selected=True; 
        testAccPlan.Finish();
        testAccPlan.closeme();
       
      
            
        PageReference pageRef = Page.RequestP45Page;
        pageRef.getParameters().put('id', String.valueOf(cont.Id));
        Test.setCurrentPage(pageRef);
        /*
        PageReference testPage = new pagereference('/apex/RequestP45Page'); 
        ApexPages.currentPage().getParameters().put( 'id', cont.Id );     
        ApexPages.currentPage().getParameters().put('sx', '1');  
        ApexPages.StandardController sc = new ApexPages.StandardController(cont);   
        RequestP45Ext MyControllerObj = new RequestP45Ext(sc);
        MyControllerObj.getpps();  
        RequestP45Ext.wraperpp wrapper= new RequestP45Ext.wraperpp(pay);
        
        List<RequestP45Ext.wraperpp> tgetpps=  MyControllerObj.getpps(); 
        
        PageReference pageref1 = MyControllerObj.Finish();
        PageReference pageref2 = MyControllerObj.closeme(); 
        */
        //System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.WARNING));
        
        
        test.stopTest();
        
    }
    
}
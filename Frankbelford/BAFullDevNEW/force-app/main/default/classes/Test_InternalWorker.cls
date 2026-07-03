@isTest
private class Test_InternalWorker {
    
    @testsetup
    static void createWorker()
    {   
       
     /*   Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0]; 
        insert cont; */
        
        //Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        //insert account1; 
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        List<Account> accounts = new List<Account>();
        Account account = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        //Contact cand = TestDataFactory.createCandidate(account1.id, 2)[1];
        //insert cand;
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        List<Contact> Contacts = new List<Contact>();
        Contact contact = new Contact(AccountID = account.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Manish',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='candidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='dsdsdsdd', 
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c='PL',
                                          Title = 'TestLastName',
                                          Initials__c = 'TestLastName',
                                          Birthdate = Date.valueOf('1990-02-20'),
                                          Phone = '9879879877',
                                          EEO_Gender__c = 'M',
                                            
                                          IP_CategoryOfWork__c='Catering;Industrial' );
            
           insert contact;
        
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
               id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
       
       Test.startTest(); 
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());      

         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = contact.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpaynew';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
         
         insert payprofile; 
          sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(account.Id, contact.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
      usr.username = 'nbh.loi@bvc.com';
        insert usr; 
        
                IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(account.id, tpz.id,1)[0];
        insert ssite;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(contact.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.IP_PayMethod__c = payprofile.id;
        splace.sirenum__site__c = ssite.id ;
        Insert splace;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0]; 
    insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(account.id, contact.Id,1)[0]; 
        sts.sirenum__Week_Ending__c = date.newInstance(2017, 12, 31);
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
       // stsl.IP_RateCodes__c = 'CB';
        Insert stsl;
         
         Test.StopTest();  
    }
    
    
    static testMethod void testDoGetModified() 
    {
        /*System.runAs(new user(ID = UserInfo.getUserID())){*/
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardInternalWorker/branchCode/1069';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardInternalWorkerRest.ResponseClass results = StandardInternalWorkerRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        /*}*/
    }  
    
    static testMethod void testDoGetModifiedNegative() 
    {
        /*System.runAs(new user(ID = UserInfo.getUserID())){*/
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/StandardInternalWorker/branchCode/1066';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            StandardInternalWorkerRest.ResponseClass results = StandardInternalWorkerRest.doGet();       
            System.assertEquals('true', results.success);  
        /*}*/
    }  
    
    static testMethod void testDoGet() 
    {
        /*System.runAs(new user(ID = UserInfo.getUserID())) {*/
        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetInternalWorkers/branchCode/1069/date/2017-05-21T00d00d00';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            DateSetInternalWorkersRest.ResponseClass results = DateSetInternalWorkersRest.doGet();       
            System.assertEquals('true', results.success);  
            System.assertEquals('Query executed successfully.', results.message);  
        
        /*}*/
   }
    
    static testMethod void testDoGetNegative() 
    {
        /*System.runAs(new user(ID = UserInfo.getUserID())) {*/
        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = System.URL.getSalesforceBaseURL()+'/services/apexrest/DateSetInternalWorkers/branchCode/1066/date/2217-05-21T00d00d00';  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            DateSetInternalWorkersRest.ResponseClass results = DateSetInternalWorkersRest.doGet();       
            System.assertEquals('true', results.success);  
           
        /*}*/
   }
    
}
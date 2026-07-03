@istest
private class Test_InternalWorkerBatch{

    @isTest
static void testexecute1() 
    {    
       String query = 'Select id from IP_PayProfile__c limit 10';
         String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';  
          String Field3 = 'IP_EmergencyPull__c';
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
    insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
     RecordType condRecord = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
 List<Contact> clist = new List<Contact>();
      Contact con = new Contact(AccountID = acc.Id, 
                                          RecordTypeId=condRecord.id,
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
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName',
                                          Initials__c = 'TestLastName',
                                          Birthdate = Date.valueOf('1990-02-20'),
                                          Phone = '9879879877',
                                        //  IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                                         // ts2__EEO_Gender__c = 'M',
                                          Declaration_Completed__c=true,
                                          PORTW_Completed__c=true,
                                          Equal_Opportunity_Completed__c=true,
                                          IP_PermDisclaimer__c=true,
                                         
                                          IP_CategoryOfWork__c='Catering',
                                          IP_ThirdPartyID__c='testpay12');
                                
       insert con;
        
        
          id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
      
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                           insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
         payprofile.IP_NewStarterTaxStatus__c='A';
         payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BankAccountName__c='Test';
         payprofile.IP_AccountNumber__c='12345678';
         payprofile.IP_SortCode__c='123456';
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
         payprofile.IP_StudentLoan__c='N';
         insert payprofile;
       
        test.startTest(); 
         InternalWorkerBatch b = new InternalWorkerBatch(query,Field1,Field2,GUID);
     
        Database.executeBatch(b,1);
       
       InternalWorkerEmergencyBatch b1 = new InternalWorkerEmergencyBatch(query,Field1,Field2,Field3,GUID);
     
        Database.executeBatch(b1,1);
        test.stopTest();
        
       }
    
    
}
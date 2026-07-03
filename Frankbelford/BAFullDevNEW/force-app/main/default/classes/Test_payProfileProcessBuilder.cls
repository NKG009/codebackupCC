@isTest
public class Test_payProfileProcessBuilder {
     @testSetup 
    static void payprofileSetup() {
        Account acct1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert acct1;
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
  
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        
        Contact cond1 = TestDataFactory.createCandidate(acct1.id, 1)[0];
        cond1.Sync_Pay_Profile__c=False;
        cond1.IP_CitizenshipGroup__c='Citizen of the UK';
        cond1.Equal_Opportunity_Completed__c = true;
        cond1.sirenum__National_Insurance__c='AA123456B';
        cond1.Birthdate=date.newInstance(1992, 04, 23);
        cond1.EEO_Gender__c = 'Male';
        cond1.Declaration_Completed__c = true;
        cond1.Medical_Completed__c = true;
        cond1.WTR_Completed__c = true;
        cond1.New_Starter_Form__c = true;
        cond1.TOE_Completed__c =true;
        cond1.PORTW_Completed__c = true;
        Insert cond1;
         system.debug('check contact'+cond1);
              
       
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'IP_PayProfile__c' And DeveloperName='PAYE'];
        
        IP_PayProfile__c pp1 = new IP_PayProfile__c(IP_Candidate__c=cond1.id,
                                                    IP_PaymentType__c='BACS', 
                                                    IP_Status__c='Active', 
                                                    RecordTypeId=condRec.id,
                                                    IP_LastPassedToTempest__c=system.today(),
                                                    IP_AccountNumber__c='21313212',
                                                    IP_BankAccountName__c='kbc',
                                                    IP_BusinessAddressTown__c='ddssd',  
                                                    IP_BuildingSocietyNumber__c='dcsd12',
                                                    IP_BusinessAddressCounty__c='sds',
                                                    IP_BusinessAddressLine1__c='bfg',
                                                    IP_BusinessAddressLine2__c='hhj',
                                                    IP_BusinessAddressPostcode__c='sfssd',
                                                    IP_SortCode__c='213123',
                                                    IP_NewStarterTaxStatus__c='A',
                                                    IP_StudentLoan__c='N',
                                                    IP_PayrollID__c='payprof1'
                                                   );      
        insert pp1;
        

        }
        @istest 
    static void processdata1() {
      
          IP_PayProfile__c pprof = [select id,P45_Requested__c,Reason_for_Leaving1__c,IP_PasstoTempest__c,IP_PayrollID__c  from IP_PayProfile__c where IP_PayrollID__c= 'payprof1'];
        
        pprof.P45_Requested__c = TRUE;
        pprof.Reason_for_Leaving1__c = 'Dismissal';
    
            update pprof;
    }
    
    @istest 
    static void processdata2() {
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
           insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);
          RecordType AccRec = [Select Id  From RecordType Where sObjectType = 'Account' And DeveloperName= 'Candidate'];
      Account acc = new Account();
        acc.name = 'abctest';
        acc.RecordTypeId = AccRec.id;
        insert acc;
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
       
            Contact con = new Contact(AccountID = acc.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Taji',
                                          Salutation ='Mr',
                                          Email = 'riu@test76.com',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='tajicandidate23',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='test123',
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName1',
                                          Initials__c = 'TestLastName1',
                                          Birthdate = Date.valueOf('1992-02-20'),
                                          Phone = '987999444',
                                          EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering' );
           
        insert con;
       
           
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();

         IP_PayProfile__c payprofile1 = new IP_PayProfile__c();
         payprofile1.RecordTypeId = payRTId;
          
       payprofile1.IP_Candidate__c = con.id;
         payprofile1.IP_CompanyName__c='sfdc';
         payprofile1.IP_Status__c = 'Inactive'; 
         payprofile1.IP_CompanyRegNo__c  = 'ad123456';
         payprofile1.IP_VATNumber__c     = '123456789';
         payprofile1.IP_PayrollID__c  = 't12786c3';
         payprofile1.IP_VATRegistered__c=true;
         payprofile1.IP_OkToSupply__c=1;
         payprofile1.IP_BusinessAddressLine1__c='test address 1';
         payprofile1.IP_BusinessAddressLine2__c='test address 2';
         payprofile1.IP_BusinessAddressTown__c='town city';
         payprofile1.IP_BusinessAddressPostcode__c='12345678';
         payprofile1.IP_PayFrequency__c='Weekly';
         payprofile1.IP_PaymentType__c='BACS';
      //  payprofile1
         insert payprofile1;
    }
    
    }
@isTest 
public class Test_PersonUpdate {
 @testSetup 
    static void consetup() {
            
        
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
                     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'abc@gmail.com';
       con.Salutation ='Mr';
        con.IP_CitizenshipGroup__c='Citizen of the UK';
       con.sirenum__National_Insurance__c='AA123456B';
       con.Birthdate=date.newInstance(1992, 04, 23);
       con.ts2__EEO_Gender__c ='M';
        con.PORTW_Completed__c =true;
        con.Medical_Completed__c =true;
        con.Declaration_Completed__c=true;
        con.TOE_Completed__c =true;
        con.New_Starter_Form__c=true;
        con.Equal_Opportunity_Completed__c=true;
        con.MailingCity ='ddd';
        con.MailingCountry='eee';
       con.MailingState='jjjj';
        con.MailingPostalCode='123456';
       con.MailingStreet='rrrrrr';
        insert con;

                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test57861';
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
        payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
         
         insert payprofile; 
         
                                 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId1 = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        IP_PayProfile__c payprofile1 = new IP_PayProfile__c();
         payprofile1.RecordTypeId = payRTId1;
          
         payprofile1.IP_Candidate__c = con.id;
         payprofile1.IP_CompanyName__c='sfdc';
         payprofile1.IP_Status__c = 'Active'; 
         payprofile1.IP_CompanyRegNo__c  = 'ad123456';
         payprofile1.IP_PayrollID__c  = 'testpay1';
         payprofile1.IP_BankAccountName__c = 'Test name1';
         payprofile1.IP_AccountNumber__c = '98567497';
         payprofile1.IP_SortCode__c = '645362';
        payprofile1.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
        payprofile1.IP_NewStarterTaxStatus__c = 'A';
        payprofile1.IP_StudentLoan__c = 'N';
         
         insert payprofile1; 
        
        }
        
         @istest 
    static void processdata1() {    
    Account acct = TestDataFactory.create2ndTierSupplierAccount(1)[0]; 
        insert acct;
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact cond = TestDataFactory.createCandidate2ndTier(acct.id, 1)[0]; 
        cond.IP_LastPassedToTempest2ndTier__c = system.today();
        cond.Person_Status__c ='Active';
        cond.Salutation ='Mr';
        cond.IP_Pass2ndTierToTempest__c=false;
        insert cond;
        
        cond.Salutation ='Dr';
        update cond;        
    }
    
             @istest 
    static void processdata2() {    
    Contact c = [Select id,Firstname from Contact where sirenum__National_Insurance__c = 'AA123456B'];
    c.Firstname = 'checktrigger';
    update c;
    }
    
                 @istest 
    static void processdata3() {    
    Contact c = [Select id,P45_Suppression_Reason__c from Contact where sirenum__National_Insurance__c = 'AA123456B'];
    c.P45_Suppression_Reason__c = 'Other';
    update c;
    }
    
       static testmethod void Test_PersonUpdate2(){
        Test.StartTest();
       // Account acc = TestDataFactory.createCandidateAccount(1)[0];
       // insert acc; 
       
           RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
insert acc1;
insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main Contact', AccountID=acc1.id);
insert maincon;
       
       Account a = [Select id from Account where name = 'Candidates'];
           
        
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
           id conRTId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        Contact con = new Contact();
           con.Recordtypeid = conRTId1;
        con.FirstName = 'method1';
        con.LastName = 'test1';
          con.Email = 'abc321@gmail.com';
       con.Salutation ='Mrs';
        con.IP_CitizenshipGroup__c='Citizen of the UK';
       con.sirenum__National_Insurance__c='AA123456D';
       con.Birthdate=date.newInstance(1992, 05, 23);
       con.ts2__EEO_Gender__c ='F';
        con.PORTW_Completed__c =true;
        con.Medical_Completed__c =true;
        con.Declaration_Completed__c=true;
        con.TOE_Completed__c =true;
        con.New_Starter_Form__c=true;
        con.Equal_Opportunity_Completed__c=true;
        con.MailingCity ='city1';
        con.MailingCountry='abc1';
       con.MailingState='kjcw';
        con.MailingPostalCode='74393';
       con.MailingStreet='juvr';
        insert con;
        
       // con.Email ='pqr@gmail.com';
        // update con;
        
        IP_TopazGlobalClientInformation__c tp = TestDataFactory.createTopaz(1)[0];
        insert tp;
        
        sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc1.id;
         site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=tp.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.IP_InvoiceContactText__c = 'Contact 1';
       // site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site; 
        
        Contact con1 = [select id,Email from contact where Id=:con.id];
        con1.Email='g@gmail.com';
        con1.sirenum__Default_Site__c=site.id;
        update con1;
        
        sirenum__Site__c  ss = [Select id ,IP_PassClientAddressToTempest__c, IP_PassClientToTempest__c from sirenum__Site__c  ];
        site.IP_PassClientAddressToTempest__c = false;
        site.IP_PassClientToTempest__c = false;  
        site.Name ='pqr';
        
        update site;
        
        Test.StopTest();
        
    }
    
    @istest 
    static void TestFun() {    
        Account acct = TestDataFactory.create2ndTierSupplierAccount(1)[0]; 
        insert acct;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact cond = TestDataFactory.createCandidate2ndTier(acct.id, 1)[0]; 
        cond.IP_LastPassedToTempest2ndTier__c = system.today();
        cond.Person_Status__c ='Active';
        cond.Salutation ='Mr';
        cond.IP_Pass2ndTierToTempest__c=false;
        insert cond;
        
        cond.MailingStreet ='aaaaaaaaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbbbbbbbbb ccccccccccccccccccccccccccc';
        update cond; 
      //  cond.MailingStreet ='aaaaaaaaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbbbbbbbbb ccccccccccccccccccccccccccc ddddddddddddddddd';
       // update cond; 
      //  cond.MailingStreet ='aaaaaaaaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbbbbbb';
      //  update cond; 
        cond.MailingStreet ='';
        update cond;
        
    }
}
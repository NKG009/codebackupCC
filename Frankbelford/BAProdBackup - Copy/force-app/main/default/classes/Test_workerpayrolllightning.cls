@istest 
public class Test_workerpayrolllightning{

public static testmethod void payroll1(){

RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];


        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
        insert maincon;


        System.debug('ACC '+acc);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = new Contact(AccountID = acc1.Id, 
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
                                    PayrollLeaver__c=null,
                                    Title = 'TestLastName',
                                    Initials__c = 'TestLastName',
                                    Birthdate = Date.valueOf('1990-02-20'),
                                    Phone = '9879879877',
                                    IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                                    ts2__EEO_Gender__c = 'M',
                                    IP_CategoryOfWork__c='Catering;Industrial',
                                    IP_ThirdPartyID__c='testpay12',
                                    IP_IsInvoicecontact__c=true
                                );
        insert con;
        //   con.AccountId = acc.id;
        //   update con;

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();

        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = con.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c='23123';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        //payprofile.IP_PassToTempest__c=true;
        insert payprofile;

        Test.startTest();
        WorkerEmergencyPullControllerLightning.payProfileDetailsUpdate(payprofile.id);
        Test.stoptest();
}
public static testmethod void payroll2(){

RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];


        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
        insert maincon;


        System.debug('ACC '+acc);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = new Contact(AccountID = acc1.Id, 
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
                                    PayrollLeaver__c=null,
                                    Title = 'TestLastName',
                                    Initials__c = 'TestLastName',
                                    Birthdate = Date.valueOf('1990-02-20'),
                                    Phone = '9879879877',
                                    IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                                    ts2__EEO_Gender__c = 'M',
                                    IP_CategoryOfWork__c='Catering;Industrial',
                                    IP_ThirdPartyID__c='testpay12',
                                    IP_IsInvoicecontact__c=true
                                );
        insert con;
        //   con.AccountId = acc.id;
        //   update con;

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();

        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = con.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c='23123';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        //payprofile.IP_PassToTempest__c=true;
        insert payprofile;
        
          Profile p1 = [SELECT Id,name FROM Profile where name='JS Recruiter - Hybrid'];
         system.debug('PROFILE NAME ----------------------'+p1.Name);
        //User usr1 = TestDataFactory.createUsers(p.Id,1)[0];
        User usr1 = new User(LastName = 'himanshu',FirstName='JASON',Alias = 'jliv1',Email = 'mm1.sf@outlook.com',
                                Username = 'dummyEm7671ail991'+'@email.com', ProfileId = p1.Id, TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                                IP_TempestDivision__c='NTS'); 
        insert usr1;

        Test.startTest();
        System.runAs(usr1)
        {
        WorkerEmergencyPullControllerLightning.payProfileDetailsUpdate(payprofile.id);
        }
        Test.stoptest();
}
}
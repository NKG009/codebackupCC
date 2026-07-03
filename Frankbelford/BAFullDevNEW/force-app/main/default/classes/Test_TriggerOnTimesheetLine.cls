@isTest
public class Test_TriggerOnTimesheetLine {
    @testSetup static void setupTestData() {
           Profile theProfile = [SELECT Id,Name FROM Profile where Name = 'System Administrator' LIMIT 1];
        User theStandardUser = new User(LastName = 'himanshu',FirstName='JASON',Alias = 'jliv1',Email = 'mm1.sf@outlook.com',
                             Username = 'dummyEmail989'+'@email.com', ProfileId = theProfile.Id, TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                             IP_TempestDivision__c='NTS',IP_PassToTempest__c=true,Brand__c='Blue Arrow'); 
		insert theStandardUser;
        User usr = [SELECT name,IP_TempestDepartment__c FROM User where id=:theStandardUser.Id];
        System.debug('usr:::'+usr.name+'??'+usr.IP_TempestDepartment__c);
        
        System.runAs(usr){
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = UserInfo.getProfileId()
        );

        insert new Impellam_Settings__c(Name='DefaultNIPercentage',IP_DefaultNIPercentage__c=10); 

        insert new IP_CompanyCode__c(name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        
        
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);         
        insert acc1;

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id,  IP_InvoicingMethod__c='Standard'); //IP_InvoicingMethod__c = 'Hourly Percentage',IP_PreAWRWTRValue__c = 5, IP_PostAWRWTRValue__c = 6,
        insert acc;

        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);      
        insert maincon;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
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
            EEO_Gender__c = 'M',
            IP_CategoryOfWork__c='Catering;Manufacturing',
            IP_ThirdPartyID__c='testpay12',
            Compliance_Status__c='Compliant'
                                  
        );       
        insert con;

     
        
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
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
        insert payprofile;

        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = 'LU13BA';
        site.sirenum__Street_Address__c = 'ABC';
        site.sirenum__City__c = 'ABC';
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc.id;
        contract.sirenum__Employee__c = con.id;
        insert contract;

        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;

        sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name = 'testjobtype';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c ='Data Entry -OA002';
        insert jobtype;

        sirenum__Team__c jobroll = new sirenum__Team__c();
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract.id; 
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.IP_OPWIPSRole__c = 'No';
        jobroll.sirenum__Rota__c = sector.id;
        //jobroll.IP_PercentageCharge__c = 3.5;
        insert jobroll;

       // User usr1 = new User(Id=theStandardUser.Id,IP_TempestDepartment__c='1062');
       // update usr1;
        
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = con.id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payprofile.id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.sirenum__Rota__c = sector.id;
        spleacement.IP_Consultant1LookupSplitShare__c = theStandardUser.Id;
        spleacement.IP_Costcode__c = '1062';
        Test.startTest();
        insert spleacement;
        sirenum__Placement__c splace = [SELECT Id,IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c, IP_Department__c from sirenum__Placement__c where id=:spleacement.id];
        System.debug('splace:::'+splace+'??'+splace.IP_Department__c+'??'+splace.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c+'??'+splace.IP_Consultant1LookupSplitShare__c);

        User usr1 = [SELECT id,name,IP_TempestDepartment__c from user where id=:splace.IP_Consultant1LookupSplitShare__c];
        System.debug('usr1::'+usr1+'??'+usr1.IP_TempestDepartment__c+'??'+usr1.name);
        
        IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
        setting.IP_LastTransmissionDate__c =   Date.newInstance(2019,07,01);
        setting.IP_OutboundErrorEmailAddress__c =   'test@abc.com';
        insert setting;

        insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false); 

        IP_BranchStatus__c b  = new IP_BranchStatus__c();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;

        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
        newTimeSheet1.sirenum__Worker__c = con.id;
        newTimesheet1.sirenum__Client__c=acc.id;
        newTimesheet1.sirenum__Team__c=jobroll.id;
        newTimesheet1.sirenum__Site__c=site.Id;
        newTimesheet1.IP_DuplicateCheckPassOK__c = TRUE;
        newTimesheet1.IP_FlaggingCheck__c = TRUE;
        newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
        insert newTimeSheet1;

        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Site__c = site.id;
        shift.sirenum__Placement__c = spleacement.Id;
        shift.sirenum__Team__c = jobroll.id;
        shift.sirenum__Contact__c = con.id;
        shift.sirenum__Rota__c = sector.id;
        shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
        insert shift;
		Test.stopTest();
        
        sirenum__Timesheet_Line__c  stsl = new sirenum__Timesheet_Line__c();
        stsl.sirenum__Timesheet__c =  newTimeSheet1.id;
        stsl.sirenum__Shift__c = shift.id;
        stsl.sirenum__Rate__c = 12;
        stsl.sirenum__Charge__c =10;
        stsl.sirenum__Hours__c = 1;
        stsl.IP_RateCodes__c = 'Standard Hours /P1';
        stsl.sirenum__Code__c = 'P1';
        stsl.For_BatchClass__c = true;
        stsl.IP_TimesheetSplitCheck__c = true;
        insert stsl;
        sirenum__Timesheet_Line__c tsl = [SELECT IP_PayrollPresentedRateCode__c,IP_RateCodes__c,IP_TempestDepartment__c,sirenum__Shift__r.sirenum__Placement__r.IP_Department__c FROM sirenum__Timesheet_Line__c WHERE Id=:stsl.Id];
         System.debug('stsl::::'+tsl.IP_PayrollPresentedRateCode__c+'??'+tsl.IP_RateCodes__c+'??'+tsl.IP_TempestDepartment__c+'??'+tsl.sirenum__Shift__r.sirenum__Placement__r.IP_Department__c);

        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = spleacement.id;
        ob.IP_TransferType__c = 'Assignment';
        ob.IP_Passed__c = '';
        ob.IP_TimesheetID__c = newTimeSheet1.id;
        insert ob;
        }
    }

    static testMethod void testCase_1() {
        User usr = [SELECT Id from user where name like '%himanshu%' and isactive=true limit 1];
        System.runAs(usr){
        sirenum__Timesheet_Line__c stsl = [SELECT IP_TimesheetSplitCheck__c FROM sirenum__Timesheet_Line__c LIMIT 1];
        
        Test.startTest();
        
        stsl.IP_TimesheetSplitCheck__c = TRUE;
        update stsl;
        
        Test.StopTest();
        }
    }

    static testMethod void testCase_2() {
        sirenum__Timesheet_Line__c stsl = [SELECT sirenum__Shift__c,sirenum__Shift__r.sirenum__Placement__c,IP_TimesheetSplitCheck__c,sirenum__Timesheet__c FROM sirenum__Timesheet_Line__c LIMIT 1];
        IP_OutboundDataTransfer__c outbound = [SELECT Id FROM IP_OutboundDataTransfer__c LIMIT 1];
        stsl.IP_OutboundID__c = outbound.Id;
        update stsl;
        
        TestDataFactory.setupUserProfileCustomSettings();
         User usr = [SELECT Id,IP_TempestDepartment__c from user where name like '%himanshu%'  and isactive=true limit 1];
        usr.IP_TempestDepartment__c = '1002';
        update usr;
        
        User usr1 = [SELECT Id,IP_TempestDepartment__c,name from user where name like '%himanshu%'  and isactive=true limit 1];
        System.debug('usr1::'+usr1);
            
        System.runAs(usr){
        
        
        Test.startTest();
        //checkRecurTimesheetline objIns = new checkRecurTimesheetline();
         // objIns.run =true; 
        /*sirenum__Placement__c splace = new sirenum__Placement__c(Id=stsl.sirenum__Shift__r.sirenum__Placement__c,IP_Costcode__c = '1002');
        update splace;
        sirenum__Placement__c newsplace = [SELECT Id,IP_Costcode__c,IP_TempestDepartment__c FROM sirenum__Placement__c WHERE Id = :splace.Id];
        System.debug('newsplace::'+newsplace);
        sirenum__Shift__c shift = new sirenum__Shift__c(id=stsl.sirenum__Shift__c,sirenum__Placement__c=splace.Id);
        update shift;*/
        
        
        //stsl.IP_TempestDepartment__c = '1002';
        
        stsl.IP_TimesheetSplitCheck__c = true;
        update stsl;
        sirenum__Timesheet_Line__c newtsl = [SELECT sirenum__Shift__r.sirenum__Placement__c,IP_TimesheetSplitCheck__c,IP_TempestDepartment__c,sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c,
                                             sirenum__Shift__r.sirenum__Placement__r.IP_Costcode__c FROM sirenum__Timesheet_Line__c WHERE Id=:stsl.Id LIMIT 1];
        System.debug('newtsl::'+newtsl);
            
        
        Test.StopTest();
        }
    }
}
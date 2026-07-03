@istest 
public class BeelineBatchHeaderClasstest{
    
    @testSetup static void dataSetUp(){
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        
        BeeLineEmailAddresses__c emailAddress = new BeeLineEmailAddresses__c();
        emailAddress.Name = 'charu.rani@espire.com';
        insert emailAddress;
        
        BeeLineAccountName__c accountName = new BeeLineAccountName__c();
        accountName.Name = 'Alexander Mann Solutions - Lloyds';
        insert accountName;
        
        BeeLinePayRateCodes__c payRateCode = new BeeLinePayRateCodes__c();
        payRateCode.Job_Science_Pay_Rate_Code__c = 'Overtime /HN';
        payRateCode.Job_Science_Rate_Code__c = 'HN';
        payRateCode.JobScience_Types_on_Beeline__c = 'Overtime';
        payRateCode.Pay_Types_on_Beeline__c = 'Double Overtime USH 10';
        payRateCode.Name = 'DOTUSH10';
        insert payRateCode;

        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);

        insert acc1;
        Account acc = new Account(Name='Alexander Mann Solutions - Lloyds',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');

        insert maincon;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        
        Contact con = new Contact(AccountID = acc.Id, 
                        RecordTypeId=condRec.id,
                        FirstName ='Manish',
                        Salutation ='Mr',
                        MailingCity='ggn',
                        MailingCountry='india',
                        MailingPostalCode='110092',
                        MailingState='Haryana',
                        LastName ='candidate',
                        IP_MailingAddressLine1__c ='Address',                       
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
                        IP_IsInvoicecontact__c=true         );
        insert con;
        

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();

        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = con.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'P106760';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c='123';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        // payprofile.IP_PassToTempest__c=true;
        insert payprofile;
        
        con.AccountId = acc.id;
        update con;
        

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
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.sirenum__Street_Address__c = 'ABC';
        site.sirenum__City__c = 'ABC';
       // site.IP_InvoiceContact__c = maincon.id;
        site.IP_InvoiceContactText__c = 'test site';
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;


        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc.id;
        contract.sirenum__Employee__c = con.id;
        insert contract;

        // to create job roll need to create job type and  Imappelam Sector

        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;

        sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name = 'testjobtype';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c ='Administrator -OA001';
        insert jobtype;

        sirenum__Team__c jobroll = new sirenum__Team__c();
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract.id; 
        jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
        insert jobroll;
        
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = con.id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2019,11,10);
        spleacement.sirenum__End_Date__c= Date.newInstance(2019,11,30);
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payprofile.id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_PassToTempest__c=true;
        insert spleacement;

        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
        newTimeSheet1.sirenum__Worker__c = con.id;
        newTimesheet1.sirenum__Client__c=acc.id;
        newTimesheet1.sirenum__Team__c=jobroll.id;
        newTimesheet1.sirenum__Site__c=site.Id;
        newTimesheet1.sirenum__Week_Ending__c = Date.newInstance(2017,11,24);
        insert newTimeSheet1;

        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='Closed';
        batchheader.IP_BatchType__c ='Beeline';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Open';
        batchline2.IP_State__c  = 'Open';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_TextField2__c = 'P106760';
        batchline2.IP_DateField2__c= Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2019,11,25);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'DOTUSH10';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; 
    }
    
    @istest static void BatchHeaderclassmethod1(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderMethodPayProfileNull(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        listBatchLine[0].IP_TextField2__c  = 'payprofile';
        update listBatchLine;
        
        Database.executeBatch(new BeelineBatchHeaderClass (),1);
        Test.stopTest(); 
    }
    
    @istest static void BatchHeaderclassmethodTwoSplacements(){
        Test.startTest();
        list<Contact> conlist =[Select id from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<sirenum__ProActiveContract__c> contractlist =[Select id from sirenum__ProActiveContract__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = conlist[0].id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2019,11,10);
        spleacement.sirenum__End_Date__c= Date.newInstance(2019,11,30);
        spleacement.sirenum__Contract__c = contractlist[0].id;
        spleacement.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement.sirenum__Site__c = siteList[0].Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payProfilelist[0].id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_PassToTempest__c=true;
        insert spleacement;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderclassmethod2(){
        Test.startTest();       
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_DateField1__c  = Date.newInstance(2017,11,20);
        update listBatchLine;
        
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderclassmethodDeleteSplacement(){
        Test.startTest();       
        List<sirenum__Placement__c> splacement = [Select id from sirenum__Placement__c limit 1];
        delete splacement;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderclassmethodTimesheet(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<Contact> conlist =[Select id,accountid from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];     
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<sirenum__Rota__c> sectorList =[Select id from sirenum__Rota__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        list<sirenum__Placement__c> placementlist =[Select id from sirenum__Placement__c limit 1];
        List<sirenum__Timesheet__c> timesheet = [Select id,sirenum__Week_Ending__c from sirenum__Timesheet__c limit 1];
        timesheet[0].sirenum__Week_Ending__c = Date.newInstance(2019,11,25);
        update timesheet;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(placementlist[0].id, siteList[0].id,1)[0];
        shft.sirenum__Timesheet_summaries__c = timesheet[0].id;
        shft.sirenum__Team__c = jobrolllist[0].id;
        shft.sirenum__Contact__c = conlist[0].id;
        shft.sirenum__Rota__c = sectorList[0].id;
        shft.sirenum__Scheduled_Start_Time__c = System.now();
        shft.sirenum__Scheduled_End_Time__c = System.now() +1;
        insert shft; 
        
        system.debug('check created shift**'+shft);
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=timesheet[0].id;
        stsl.sirenum__Rate__c=22.0;
        stsl.sirenum__Hours__c=1;
        stsl.IP_PassToTempest__c=false;    
        stsl.IP_RateCodes__c='Taxable Expenses /TX';
        stsl.sirenum__Shift__c=shft.id;
        stsl.IP_TimesheetSplitCheck__c = true;
        stsl.IP_POErrorLogField__c = 'TestValue';       
        Insert stsl;

        system.debug('Timesheet Line'+stsl);
        
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderclassmethodTimesheet1(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<Contact> conlist =[Select id,accountid from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];     
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<sirenum__Rota__c> sectorList =[Select id from sirenum__Rota__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        list<sirenum__Placement__c> placementlist =[Select id from sirenum__Placement__c limit 1];
        list<sirenum__Timesheet__c> timesheetList = [Select id from sirenum__Timesheet__c limit 1];
        delete timesheetList;
        
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(conlist[0].accountid, conlist[0].Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        //  sts.IP_EmergencyPull__c=true;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018,12,31);        
        Insert sts;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(placementlist[0].id, siteList[0].id,1)[0];
        shft.sirenum__Timesheet_summaries__c = sts.id;
        shft.sirenum__Team__c = jobrolllist[0].id;
        shft.sirenum__Contact__c = conlist[0].id;
        shft.sirenum__Rota__c = sectorList[0].id;
        shft.sirenum__Scheduled_Start_Time__c = System.now();
        shft.sirenum__Scheduled_End_Time__c = System.now() +1;
        insert shft;
        
        system.debug('check created shift**'+shft);
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
        stsl.sirenum__Rate__c=22.0;
        stsl.sirenum__Hours__c=1;
        stsl.IP_PassToTempest__c=false;    
        stsl.IP_RateCodes__c='Taxable Expenses /TX';
        stsl.sirenum__Shift__c=shft.id;
        stsl.IP_TimesheetSplitCheck__c = true;
        stsl.IP_POErrorLogField__c = 'TestValue';       
        Insert stsl;

        system.debug('Timesheet Line'+stsl);
        
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodTimesheet2(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<Contact> conlist =[Select id,accountid from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];     
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<sirenum__Rota__c> sectorList =[Select id from sirenum__Rota__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        list<sirenum__Placement__c> placementlist =[Select id from sirenum__Placement__c limit 1];
        List<sirenum__Timesheet__c> timesheet = [Select id,sirenum__Week_Ending__c from sirenum__Timesheet__c limit 1];
        timesheet[0].sirenum__Week_Ending__c = Date.newInstance(2019,11,25);
        update timesheet;
        
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderclassmethodTimesheet3(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField3__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField3__c = '55';
        update listBatchLine;
        
        list<Contact> conlist =[Select id,accountid from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];     
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<sirenum__Rota__c> sectorList =[Select id from sirenum__Rota__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        list<sirenum__Placement__c> placementlist =[Select id from sirenum__Placement__c limit 1];
        List<sirenum__Timesheet__c> timesheet = [Select id,sirenum__Week_Ending__c from sirenum__Timesheet__c limit 1];
        timesheet[0].sirenum__Week_Ending__c = Date.newInstance(2019,11,25);
        update timesheet;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(placementlist[0].id, siteList[0].id,1)[0];
        shft.sirenum__Timesheet_summaries__c = timesheet[0].id;
        shft.sirenum__Team__c = jobrolllist[0].id;
        shft.sirenum__Contact__c = conlist[0].id;
        shft.sirenum__Rota__c = sectorList[0].id;
        shft.sirenum__Scheduled_Start_Time__c = System.now();
        shft.sirenum__Scheduled_End_Time__c = System.now() +1;
        insert shft; 
        
        system.debug('check created shift**'+shft);
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=timesheet[0].id;
        stsl.sirenum__Rate__c=22.0;
        stsl.sirenum__Hours__c=1;
        stsl.IP_PassToTempest__c=false;    
        stsl.IP_RateCodes__c='Taxable Expenses /TX';
        stsl.sirenum__Shift__c=shft.id;
        stsl.IP_TimesheetSplitCheck__c = true;
        stsl.IP_POErrorLogField__c = 'TestValue';       
        Insert stsl;

        system.debug('Timesheet Line'+stsl);
        
        Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
}
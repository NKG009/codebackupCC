@istest 
public class GenericBatchHeaderclassTest{
    
    @testSetup static void dataSetUp(){
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);

        insert acc1;
        Account acc = new Account(Name='Alexander Mann Solutions - Lloyds',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);

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
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_InvoiceContactText__c = 'testInvoice';
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;


        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc.id;
        contract.sirenum__Employee__c = con.id;
        insert contract;
        system.debug('check contract--->'+contract);

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
        system.debug('inserted job role--->'+jobroll);
        system.debug('inserted job role account--->'+jobroll.sirenum__Account__c);
        
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
        batchheader.IP_BatchType__c ='Generic';
        batchheader.IP_Account__c = 'Alexander Mann Solutions - Lloyds';
        batchheader.IP_AccountID__c = acc.id;
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Open';
        batchline2.IP_State__c  = 'Open';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_TextField2__c = 'P106760';
        batchline2.IP_DateField2__c= Date.newInstance(2020,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2019,11,25);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P1';
        batchline2.IP_TextField4__c = '16383117';
      //  batchline2.IP_TextField5__c = 'testjobroll';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; 
    }
    
    @istest static void BatchHeaderclassmethod1(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Database.executeBatch(new GenericBatchHeaderclass(),1);
        Test.stopTest();          
            
    }
    
    @istest static void BatchHeaderMethodPayProfileNull(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        listBatchLine[0].IP_TextField2__c  = 'payprofile';
        update listBatchLine;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
    @istest static void BatchHeaderMethodjobrole(){
        Test.startTest();
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        update listBatchLine;
        
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
    @istest static void BatchHeaderMethodsiteandjobrole(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
        
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
	 @istest static void BatchHeaderMethodmultiplejobrole(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
		List<sirenum__Job_Type__c> jobtype = [Select id from sirenum__Job_Type__c limit 1];
		List<sirenum__ProActiveContract__c> contract = [Select id from sirenum__ProActiveContract__c limit 1];
		sirenum__Team__c jobroll = new sirenum__Team__c();
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract[0].id; 
        jobroll.sirenum__Job_Type__c = jobtype[0].id;
         jobroll.IP_OPWIPSRole__c = 'No';
        insert jobroll;
        
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
    @istest static void BatchHeaderMethodexteralref(){
        Test.startTest();
        List<sirenum__placement__c> placelist = [Select id,IP_ExternalAssignmentID__c from sirenum__placement__c where name = 'testing placment' limit 1];
        placelist[0].IP_ExternalAssignmentID__c = '417581739';
        update placelist;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField7__c =  '417581739';
        update listBatchLine;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
     @istest static void BatchHeaderMethodexteralrefnotfound(){
        Test.startTest();       
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField7__c =  '417567q81739';
        update listBatchLine;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
     @istest static void BatchHeaderMethodendDate(){
        Test.startTest();   
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_DateField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
    @istest static void BatchHeaderclassmethodDeleteSplacement(){
        Test.startTest();     
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
        List<sirenum__Placement__c> splacement = [Select id from sirenum__Placement__c limit 1];
        delete splacement;
        Database.executeBatch(new GenericBatchHeaderclass(),1);
        Test.stopTest();          
            
    }
     @istest static void BatchHeaderclassmethodTimesheet2(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
        list<Contact> conlist =[Select id,accountid from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Rota__c> sectorList =[Select id from sirenum__Rota__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        list<sirenum__Placement__c> placementlist =[Select id from sirenum__Placement__c limit 1];
        List<sirenum__Timesheet__c> timesheet = [Select id,sirenum__Week_Ending__c from sirenum__Timesheet__c limit 1];
        timesheet[0].sirenum__Week_Ending__c = Date.newInstance(2020,11,24);
        update timesheet;
        
        Database.executeBatch(new GenericBatchHeaderclass(),1);
        Test.stopTest();          
            
    }
    @istest static void BatchHeaderclassmethodTimesheet3(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
        
        list<Contact> conlist =[Select id,accountid from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Rota__c> sectorList =[Select id from sirenum__Rota__c limit 1];
        list<IP_PayProfile__c> payProfilelist =[Select id from IP_PayProfile__c limit 1];
        list<sirenum__Placement__c> placementlist =[Select id from sirenum__Placement__c limit 1];
        List<sirenum__Timesheet__c> timesheet = [Select id,sirenum__Week_Ending__c from sirenum__Timesheet__c limit 1];
        timesheet[0].sirenum__Week_Ending__c = Date.newInstance(2020,11,24);
        update timesheet;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(placementlist[0].id, siteList[0].id,1)[0];
        shft.sirenum__Timesheet_summaries__c = timesheet[0].id;
        shft.sirenum__Team__c = joblist[0].id;
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
    @istest static void BatchHeaderMethodnoncompliant(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
        List<IP_PayProfile__c> paylist = [Select id,IP_BusinessAddressLine1__c from IP_PayProfile__c where IP_PayrollID__c  = 'P106760'];
        paylist[0].IP_BusinessAddressLine1__c = '';
        update paylist;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
	 @istest static void BatchHeaderMethodnocontact(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c,IP_TextField2__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
		listBatchLine[0].IP_TextField2__c  = '';
		listBatchLine[0].IP_TextField7__c  = '';
        update listBatchLine;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
	
	@istest static void BatchHeaderMethodfindcontact(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
		List<sirenum__placement__c> placelist = [Select id,IP_ExternalAssignmentID__c from sirenum__placement__c where name = 'testing placment' limit 1];
        placelist[0].IP_ExternalAssignmentID__c = '527262828';
        update placelist;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
		listBatchLine[0].IP_TextField7__c  = '527262828';
		listBatchLine[0].IP_TextField2__c  = '';
        update listBatchLine;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
	@istest static void BatchHeaderMethodenddateupdate(){
        Test.startTest();
        List<sirenum__site__c> sitelist = [Select id,name,IP_ClientIDLegacy__c  from sirenum__site__c where name = 'testsite' limit 1];
        List<sirenum__team__c> joblist = [Select id,name from sirenum__team__c where name = 'testjobroll' limit 1];
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField6__c,IP_TextField5__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = joblist[0].Name;
        listBatchLine[0].IP_TextField6__c  = sitelist[0].IP_ClientIDLegacy__c;
		listBatchLine[0].IP_DateField2__c = Date.newInstance(2016,11,12);
        update listBatchLine;
        Database.executeBatch(new GenericBatchHeaderclass (),1);
        Test.stopTest(); 
    }
     @istest static void BatchHeaderclassmethodTwoSplacements(){
        Test.startTest();
        list<Contact> conlist =[Select id from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id,Name from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id,IP_ClientIDLegacy__c from sirenum__Site__c limit 1];
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
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField5__c,IP_TextField6__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField5__c  = jobrolllist[0].Name;
        listBatchLine[0].IP_TextField6__c  = siteList[0].IP_ClientIDLegacy__c;
        update listBatchLine;
         Database.executeBatch(new BeelineBatchHeaderClass(),1);
        Test.stopTest();          
            
    }
    
   
}
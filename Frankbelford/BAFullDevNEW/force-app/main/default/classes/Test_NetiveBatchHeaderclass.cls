@istest 
public class Test_NetiveBatchHeaderclass{


    @testSetup static void dataSetUp(){ 
    
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];


        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main Contact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');
        insert maincon;


        System.debug('ACC '+acc);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        //   insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = True);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];

        Contact con = new Contact(AccountID = acc1.Id, 
                                    RecordTypeId=condRec.id,
                                    FirstName ='Manish',
                                    Salutation ='Mr',
                                    MailingStreet='abc',
                                    MailingCity='ggn',
                                    MailingCountry='india',
                                    MailingPostalCode='110092',
                                    MailingState='Haryana',
                                    LastName ='candidate',
                                    IP_MailingAddressLine1__c =  'abc',                             
                                    sirenum__National_Insurance__c='AA323232A', 
                                    IP_CandidateIDlegacy__c='dsdsdsdd',                                    
                                    P45_Requested__c=true,
                                    PayrollLeaver__c=null,
                                    Title = 'TestLastName',
                                    Initials__c = 'TestLastName',
                                    Birthdate = Date.valueOf('1990-02-20'),
                                    Phone = '9879879877',
                                    IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                                    EEO_Gender__c = 'M',
                                    IP_CategoryOfWork__c='Catering;Industrial',
                                    IP_ThirdPartyID__c='testpay12',
                                    IP_IsInvoicecontact__c=true);

        insert con;
        //con.AccountId = acc.id;
        //update con;
        system.debug('Contact Inserted'+con);

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();

        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = con.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay12';
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

        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjudui572@mko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 

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
        //site.ownerid = usr.id;
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
        jobroll.sirenum__Rota__c = sector.id;
        insert jobroll;

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
        spleacement.IP_Consultant1LookupSplitShare__c = usr.id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_PassToTempest__c=true;
        spleacement.sirenum__Rota__c = sector.id;
        insert spleacement;
        sirenum__Placement__c place1 = [Select id,IP_AssignmentRef__c from sirenum__Placement__c where id=:spleacement.id];    

        system.debug('check created s-placmement**'+spleacement);

        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(acc.id, con.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        //  sts.IP_EmergencyPull__c=true;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018,12,31);        
        Insert sts;

        sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.id, site.id,1)[0];
        shft.sirenum__Timesheet_summaries__c = sts.id;
        shft.sirenum__Team__c = jobroll.id;
        shft.sirenum__Contact__c = con.id;
        shft.sirenum__Rota__c = sector.id;
        shft.sirenum__Scheduled_Start_Time__c = System.now();
        shft.sirenum__Scheduled_End_Time__c = System.now() +1;
        insert shft; 
        
        system.debug('check created shift**'+shft);
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
        stsl.sirenum__Rate__c=22.0;
        stsl.sirenum__Hours__c=1;
        stsl.IP_PassToTempest__c=true;    
        stsl.IP_RateCodes__c='Taxable Expenses /TX';
        stsl.sirenum__Shift__c=shft.id;
        stsl.IP_TimesheetSplitCheck__c = true;
        stsl.IP_POErrorLogField__c = 'TestValue';       
        Insert stsl;

        system.debug('Timesheet Line'+stsl);


        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='Closed';
        batchheader.IP_BatchType__c ='Netive';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'open';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay12';
        batchline2.IP_DateField1__c = Date.newInstance(2018,12,31);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField9__c = 'D2';
        batchline2.IP_Number12d4Field1__c =12;
        batchline2.IP_TextField7__c =place1.IP_AssignmentRef__c;
        insert batchline2; // legacycon

        list<sirenum__Placement__c> placementlist =[Select id,IP_PayrollStatus__c,sirenum__Status__c from sirenum__Placement__c where id =: spleacement.id];
        system.debug('placementlist @@ '+placementlist[0].IP_PayrollStatus__c);
        System.debug('Placement Reference**'+batchline2.IP_TextField7__c);
        //system.debug('sitelist @@ '+sitelist);
                
    }
    
    @istest static void BatchHeaderclassmethod1(){      
        List<IP_BatchLine__c> listBatchLine = [Select id from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod2(){      
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        listBatchLine[0].IP_TextField2__c  = 'testpay121';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod3(){
        list<Contact> conlist =[Select id from Contact where FirstName ='Test' limit 1];        
        
        list<sirenum__Placement__c> placementlist = [select id,IP_PayMethod__c,sirenum__Contact__c,IP_PayrollStatus__c from sirenum__Placement__c limit 1];
        placementlist[0].sirenum__Contact__c = conlist[0].id;
        placementlist[0].IP_PayMethod__c = null;
        update placementlist;
        system.debug('placementlist @@ '+placementlist[0].IP_PayrollStatus__c);
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod4(){
        list<sirenum__Timesheet__c> timesheetList =[Select id from sirenum__Timesheet__c  limit 1];
        delete timesheetList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod5(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Number12d4Field1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_Number12d4Field1__c  = null;
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod6(){
        list<sirenum__Timesheet_Line__c> timesheetList =[Select id,sirenum__Hours__c from sirenum__Timesheet_Line__c  limit 1];
        timesheetList[0].sirenum__Hours__c = -1 ;
        update timesheetList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Number12d4Field1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod7(){
        list<sirenum__Timesheet_Line__c> timesheetList =[Select id,sirenum__Hours__c from sirenum__Timesheet_Line__c  limit 1];
        timesheetList[0].sirenum__Hours__c = -1 ;
        update timesheetList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Number12d4Field1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_Number12d4Field1__c  = null;
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod8(){
        list<Contact> conlist =[Select id from Contact where FirstName ='Manish' limit 1];
        
        list<sirenum__Site__c> sitelist =[Select id from sirenum__Site__c limit 1];
        
        list<sirenum__Team__c> jobRolelist =[Select id from sirenum__Team__c limit 1];

        List<IP_BatchLine__c> listBatchLine = [Select id,IP_DateField1__c,IP_Number12d4Field1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];     
        
        list<sirenum__Timesheet_Line__c> timesheetLineList =[Select id,sirenum__Hours__c from sirenum__Timesheet_Line__c  limit 1];
        timesheetLineList[0].sirenum__Hours__c = -1 ;
        update timesheetLineList;
        
        list<sirenum__Timesheet__c> timesheetList =[Select id,sirenum__Worker__c from sirenum__Timesheet__c  limit 1];
        timesheetList[0].sirenum__Worker__c = conlist[0].id;
        timesheetList[0].sirenum__Week_Ending__c = listBatchLine[0].IP_DateField1__c;
        timesheetList[0].sirenum__site__c = sitelist[0].id;
        timesheetList[0].sirenum__Team__c = jobRolelist[0].id;
        update timesheetList;

        listBatchLine[0].IP_Number12d4Field1__c  = null;
        update listBatchLine;       
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodP1(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'P1';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodPH(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'PH';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodP2(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'P2';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodE1(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'E1';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodNG(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'NG';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodPS(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'PS';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodD3(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'D3';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodD4(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'D4';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodD5(){     
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'D5';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new NetiveBatchHeaderclass (),1);
        Test.stopTest();
    }
}
@istest 
public class ShopDirectFMbookamend_Test{


    @testSetup static void dataSetUp(){    
    
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        RecordType twotier = [Select id from RecordType where sObjectType ='Account' and Developername = 'IP_2ndTierSupplier'];

        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        Account acctier2 = new Account(Name='TestTier',RecordTypeId=twotier.id);
        insert acctier2; 
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');
        insert maincon;

        System.debug('ACC '+acc);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

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
                IP_CandidateIDlegacy__c='testpay12', 
                IP_MailingAddressLine1__c = 'test line 1',
                MailingStreet='abc',
                P45_Requested__c=true,
                PayrollLeaver__c=null,
                Title = 'TestLastName',
                Initials__c = 'TestLastName',
                Birthdate = Date.valueOf('1990-02-20'),
                Phone = '9879879877',
                IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                EEO_Gender__c = 'M',
                IP_CategoryOfWork__c='Catering;Industrial',
                IP_IsInvoicecontact__c=true
        );
        insert con;


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

       // con.AccountId = acc.id;
        //update con;


        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;

        sirenum__Site__c site = new sirenum__Site__c();
         site.Name = 'Littlewoods Shop Direct Home Group Ltd';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.sirenum__Street_Address__c = 'test address';
        site.sirenum__City__c = 'test city address';
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Site__c site1 = new sirenum__Site__c();
         site1.Name = 'Littlewoods Shop Direct Home Group Ltd';
        site1.sirenum__Operating_Company__c= acc.id;
        site1.IP_ClientIDLegacy__c='123456';
        site1.GlobalClientName__c=globalclient.id;
        site1.IP_ClientInvoiceName__c='Testclient123';
        site1.IP_InvoiceAddressStreet__c='101';
        site1.IP_InvoiceAddressCity__c = 'Delhi';
        site1.IP_InvoiceAddressPostcode__c = '110035';
       // site1.sirenum__Street_Address__c = 'test address';
       // site1.sirenum__City__c = 'test city address';
        site1.IP_InvoiceContact__c = maincon.id;
        site1.IP_MainContact__c = maincon.id;
        site1.IP_PublicSector__c = 'No';
        insert site1;
        
        system.debug('check site missing'+site.Missing_Site_Details__c);

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
        jobtype.name = 'testjobtype -IA223';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Internal -INT';
         jobtype.Impellam_Job_Category__c ='Receptionist -OA205';
        insert jobtype;

        sirenum__Team__c jobroll = new sirenum__Team__c();
         jobroll.name = 'LSDHG Amendments';
        jobroll.sirenum__Account__c = contract.id; 
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.IP_OPWIPSRole__c = 'No';
        jobroll.sirenum__rota__c = sector.id;
        insert jobroll;


        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='Open';
         batchheader.IP_BatchType__c ='Shop Direct - FM Booking Amendments';
        insert batchheader;  

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Open';
        batchline2.IP_State__c  = 'Open';
        batchline2.IP_TextField2__c = 'testpay12';
        batchline2.IP_TextField1__c = 'Test Name';
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField4__c = 'REC1';
        batchline2.IP_TextField10__c = '1002';
        batchline2.IP_TextField9__c = 'P1';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
                
    } 
    
    @istest static void BatchHeaderclassmethod1(){
        Test.startTest();       
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);            
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod2(){      
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        listBatchLine[0].IP_TextField2__c  = 'testpay121';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod3(){      
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<sirenum__Placement__c> placementList = [Select id from sirenum__Placement__c limit 1];
        delete placementList;       
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        delete jobrolllist;
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        delete siteList;
        
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod4(){      
        list<IP_PayProfile__c> payProfilelist =[Select id,IP_BusinessAddressLine1__c,IP_MissingPayrollDetail__c from IP_PayProfile__c limit 1];
        payProfilelist[0].IP_BusinessAddressLine1__c = '';
        update payProfilelist;
        
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod5(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        list<IP_PayProfile__c> payProfileList = [Select id from IP_PayProfile__c limit 1];
        delete payProfileList;
        
        List<Account> accTwoTier = [Select id from Account where Name='TestTier' limit 1];
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];
        
        list<Contact> conlist =[Select id,RecordTypeId,accountid from Contact where FirstName ='Manish' limit 1];
        conlist[0].RecordTypeId = condRec.id;
        conlist[0].accountid = accTwoTier[0].id;
        update conlist;
        
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod6(){      
        list<sirenum__Placement__c> placementList = [Select id from sirenum__Placement__c limit 1];
        delete placementList;   
        
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    @istest static void BatchHeaderclassmethod7(){     
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<IP_PayProfile__c> payProfileList = [Select id from IP_PayProfile__c limit 1];
        list<sirenum__ProActiveContract__c> contractlist = [Select id from sirenum__ProActiveContract__c limit 1];
        list<Contact> conlist = [Select id from Contact where name like '%Manish%' limit 1];
        list<sirenum__Rota__c> sectorlist = [Select id from sirenum__Rota__c limit 1];
        sirenum__Placement__c spleacement = new sirenum__Placement__c();         
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = conlist[0].id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contractlist[0].id;
        spleacement.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement.sirenum__Site__c = siteList[0].Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payProfileList[0].id;
        spleacement.sirenum__Rota__c = sectorlist[0].id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        insert spleacement; 
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    @istest static void BatchHeaderclassmethod8(){     
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<IP_PayProfile__c> payProfileList = [Select id from IP_PayProfile__c limit 1];
        list<sirenum__ProActiveContract__c> contractlist = [Select id from sirenum__ProActiveContract__c limit 1];
        list<Contact> conlist = [Select id from Contact where name like '%Manish%' limit 1];
        list<sirenum__Rota__c> sectorlist = [Select id from sirenum__Rota__c limit 1];
        sirenum__Placement__c spleacement = new sirenum__Placement__c();         
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = conlist[0].id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contractlist[0].id;
        spleacement.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement.sirenum__Site__c = siteList[0].Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payProfileList[0].id;
        spleacement.sirenum__Rota__c = sectorlist[0].id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        insert spleacement; 
        sirenum__Placement__c spleacement1 = new sirenum__Placement__c();         
        spleacement1.Name = 'testing placment123';
        spleacement1.sirenum__Contact__c = conlist[0].id;
        spleacement1.sirenum__Start_Date__c =  Date.newInstance(2018,11,01);
        spleacement1.sirenum__End_Date__c= Date.newInstance(2018,12,20);
        spleacement1.sirenum__Contract__c = contractlist[0].id;
        spleacement1.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement1.sirenum__Site__c = siteList[0].Id;
        spleacement1.sirenum__Status__c   = 'Active';
        spleacement1.IP_PayMethod__c = payProfileList[0].id;
        spleacement1.sirenum__Rota__c = sectorlist[0].id;
        spleacement1.IP_Consultant1PercentageSplit__c=100;
        insert spleacement1; 
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod9(){     
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c where IP_ClientInvoiceName__c = 'Testclient123' limit 1];
        list<IP_PayProfile__c> payProfileList = [Select id from IP_PayProfile__c limit 1];
        list<sirenum__ProActiveContract__c> contractlist = [Select id from sirenum__ProActiveContract__c limit 1];
        list<Contact> conlist = [Select id from Contact where name like '%Manish%' limit 1];
        list<sirenum__Rota__c> sectorlist = [Select id from sirenum__Rota__c limit 1];
        sirenum__Placement__c spleacement = new sirenum__Placement__c();         
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = conlist[0].id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contractlist[0].id;
        spleacement.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement.sirenum__Site__c = siteList[0].Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payProfileList[0].id;
        spleacement.sirenum__Rota__c = sectorlist[0].id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        insert spleacement; 
        Test.startTest();
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodDeleteSite(){     
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        list<sirenum__site__c> siteList = [Select id from sirenum__site__c limit 1];
        delete siteList;
        
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodMissingContactDetail(){     
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        list<Contact> conlist =[Select id,IP_MailingAddressLine1__c,MailingCity  from Contact where FirstName ='Manish' limit 1];
        conlist[0].IP_MailingAddressLine1__c = '';
        conlist[0].MailingCity  = '';
        update conlist;
        
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<IP_PayProfile__c> payProfileList = [Select id from IP_PayProfile__c limit 1];
        list<sirenum__ProActiveContract__c> contractlist = [Select id from sirenum__ProActiveContract__c limit 1];
        list<sirenum__Rota__c> sectorlist = [Select id from sirenum__Rota__c limit 1];
        sirenum__Placement__c spleacement = new sirenum__Placement__c();         
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = conlist[0].id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contractlist[0].id;
        spleacement.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement.sirenum__Site__c = siteList[0].Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payProfileList[0].id;
        spleacement.sirenum__Rota__c = sectorlist[0].id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        insert spleacement;
        
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodtimeheet(){     
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<account> acclist =[Select id from account where Name='Candidates' limit 1];        
        list<Contact> conlist =[Select id,IP_MailingAddressLine1__c,MailingCity  from Contact where FirstName ='Manish' limit 1];
        list<sirenum__Team__c> jobrolllist = [Select id from sirenum__Team__c limit 1];
        list<sirenum__Site__c> siteList =[Select id from sirenum__Site__c limit 1];
        list<IP_PayProfile__c> payProfileList = [Select id from IP_PayProfile__c limit 1];
        list<sirenum__ProActiveContract__c> contractlist = [Select id from sirenum__ProActiveContract__c limit 1];
        list<sirenum__Rota__c> sectorlist = [Select id from sirenum__Rota__c limit 1];
        sirenum__Placement__c spleacement = new sirenum__Placement__c();         
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = conlist[0].id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contractlist[0].id;
        spleacement.sirenum__Job_Role__c = jobrolllist[0].id;
        spleacement.sirenum__Site__c = siteList[0].Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payProfileList[0].id;
        spleacement.sirenum__Rota__c = sectorlist[0].id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        insert spleacement;
        
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(acclist[0].id, conlist[0].Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
        sts.sirenum__Worker__c=conlist[0].id;
        sts.sirenum__team__c = jobrolllist[0].id;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2017,11,20);        
        Insert sts;

        sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.id, siteList[0].id,1)[0];
        shft.sirenum__Timesheet_summaries__c = sts.id;
        shft.sirenum__Team__c = jobrolllist[0].id;
        shft.sirenum__Contact__c = conlist[0].id;
        shft.sirenum__Rota__c = sectorlist[0].id;
        shft.sirenum__Scheduled_Start_Time__c = System.now();
        shft.sirenum__Scheduled_End_Time__c = System.now() +1;
        insert shft; 
        
        Database.executeBatch(new ShopDirectFMbookamendclass(),1);
        Test.stopTest();
    }
}
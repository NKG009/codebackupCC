@istest 
public class IkeaBatchHeaderTestClass {
    
   
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
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');

        insert maincon;


        System.debug('ACC '+acc);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];

        Contact con = new Contact(AccountID = acctier2.Id, 
        RecordTypeId=condRec.id,
        FirstName ='Manish',
        Salutation ='Mr',
        MailingCity='ggn',
        MailingCountry='india',
        MailingPostalCode='110092',
        MailingState='Haryana',
        LastName ='candidate',  
        sirenum__National_Insurance__c='AA323232A', 
        IP_CandidateIDlegacy__c='testpay1', 
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
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
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

        con.AccountId = acctier2.id;
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
        jobtype.name = 'testjobtype -IA223';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Warehouse & Distribution -DIS';
        jobtype.Impellam_Job_Category__c ='Assembler -IA223';
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
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = payprofile.id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_PassToTempest__c=true;
        insert spleacement;

        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='open';
        batchheader.IP_BatchType__c ='Vanquish - Ikea - Peterborough';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'open';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_TextField3__c = site.IP_ClientIDLegacy__c;
        batchline2.IP_TextField4__c = 'testjobroll';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2018,11,20);
        //batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField9__c = 'SN';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; 
                
    }
    
    @istest static void BatchHeaderclassmethod1(){
        List<IP_BatchLine__c> listBatchLine = [Select id from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass(),1);
        Test.stopTest();    
    }
    
    @istest static void BatchHeaderclassmethod2(){      
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        listBatchLine[0].IP_TextField2__c  = 'testpay121';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
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
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod4(){      
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];        
        list<sirenum__Placement__c> placementList = [Select id from sirenum__Placement__c limit 1];
        delete placementList;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
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
        
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod6(){
        Test.startTest();
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField2__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodP1(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'P1';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodOF(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'OF';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodBT(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'BT';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodWX(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'WX';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodCB(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'CB';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodMB(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'MB';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodPP(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'PP';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodHN(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'HN';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodDX(){
        list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'DX';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethodDX1(){
    list<sirenum__Site__c> siteList =[Select id,Missing_Site_Details__c,sirenum__Street_Address__c,sirenum__City__c from sirenum__Site__c limit 1];
        siteList[0].sirenum__Street_Address__c = 'ABC';
        siteList[0].sirenum__City__c = 'ABC';
        update siteList;
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_TextField9__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField9__c  = 'DX1';
        update listBatchLine;
        
        Test.startTest();
        Database.executeBatch(new IkeaBatchHeaderClass (),1);
        Test.stopTest();
    }
}
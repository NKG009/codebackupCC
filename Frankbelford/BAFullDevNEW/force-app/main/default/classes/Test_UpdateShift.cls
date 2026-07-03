@isTest
public class Test_UpdateShift {
    
    Public static testmethod void test1()
    {
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        // RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        // Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');
        
        // insert maincon;
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                  IP_CategoryOfWork__c='Catering;Industrial',
                                  IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                 );
        
        insert con;
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=1;
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
        
        // site.IP_InvoiceContact__c = maincon.id;
        //site.IP_MainContact__c = maincon.id;
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
        
        sirenum__Break_definition__c brk = new sirenum__Break_definition__c();
        brk.sirenum__Break_length__c=20;
        brk.sirenum__Minimum_shift_length__c=7;
        brk.sirenum__Site__c=site.id;
        brk.sirenum__Team__c=jobroll.id;
        
        insert brk;
        
        
        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Site__c = site.id;
        shift.sirenum__Scheduled_Start_Time__c = System.now();
        shift.sirenum__Scheduled_End_Time__c = System.now();
        shift.sirenum__Team__c = jobroll.id;
        shift.sirenum__Contact__c = con.id;
        
        
        insert shift;
        
        sirenum__Break_definition__c brk1 = new sirenum__Break_definition__c();
        brk1.sirenum__Break_length__c = 20 ;
        brk1.sirenum__Minimum_shift_length__c=7;
        brk1.sirenum__Site__c=site.id;
        brk1.sirenum__Team__c=jobroll.id;
        
        insert brk1;
        
        
        sirenum__Shift__c shift1 = new sirenum__Shift__c();
        shift1.sirenum__Site__c = site.id;
        shift1.sirenum__Scheduled_Start_Time__c = null;
        shift1.sirenum__Scheduled_End_Time__c = null;
        shift1.sirenum__Team__c = jobroll.id;
        shift1.sirenum__Contact__c = con.id;
        
        
        insert shift1;
        
    }
    
}
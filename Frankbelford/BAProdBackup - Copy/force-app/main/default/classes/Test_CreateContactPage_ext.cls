@isTest
public class Test_CreateContactPage_ext {
    
    public static testmethod void createcontact(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);

        insert maincon;


        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Contact con = new Contact(AccountID = account1.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='XYZ',  
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='test123',
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName1',
            Initials__c = 'TestLastName1',
            Birthdate = Date.valueOf('1992-02-20'),
            Phone = '9879879877',
            ts2__EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering;Industrial' );

        insert con;
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
        //site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.CreateContactPage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id); 
        System.currentPageReference().getParameters().put('siteId', site.id); 
        System.currentPageReference().getParameters().put('accid', account1.id);  
        System.currentPageReference().getParameters().put('fname', con.FirstName);  
        System.currentPageReference().getParameters().put('lname', con.Lastname);  
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactPage_ext  permgenerate = new CreateContactPage_ext (sc);
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect2();
        permgenerate.SaveandAddAddress();
        permgenerate.changeAcc();
        permgenerate.cancelredirect();       
        Test.stopTest();  
    }
     
    public static testmethod void createcontact2(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false); 
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);

        insert maincon;


        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Contact con = new Contact(AccountID = account1.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='XYZ',  
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='test123',
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName1',
            Initials__c = 'TestLastName1',
            Birthdate = Date.valueOf('1992-02-20'),
            Phone = '9879879877',
            ts2__EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering;Industrial' );

        insert con;

        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.CreateContactPage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id); 

        System.currentPageReference().getParameters().put('accid', account1.id);  
        System.currentPageReference().getParameters().put('fname', con.FirstName);  
        System.currentPageReference().getParameters().put('lname', con.Lastname);  
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactPage_ext  permgenerate = new CreateContactPage_ext (sc);
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect2();
        permgenerate.SaveandAddAddress();
        permgenerate.changeAcc();
        permgenerate.cancelredirect();       
        Test.stopTest();
    }
    
    public static testmethod void createcontactEmail(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');        
        //insert maincon;

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Contact con = new Contact(AccountID = acc.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='XYZ',
            Email = 'test@gmail.com',
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='test123',
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName1',
            Initials__c = 'TestLastName1',
            Birthdate = Date.valueOf('1992-02-20'),
            Phone = '9879879877',
            ts2__EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering;Industrial' );

        //insert con;
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
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.CreateContactPage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id); 
        System.currentPageReference().getParameters().put('siteId', site.id); 
        System.currentPageReference().getParameters().put('accid', acc.id);  
        System.currentPageReference().getParameters().put('fname', con.FirstName);  
        System.currentPageReference().getParameters().put('lname', con.Lastname);  
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactPage_ext  permgenerate = new CreateContactPage_ext (sc);
        permgenerate.conrec.Email = 'test@gmail.com';
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect2();   
        Test.stopTest();  
    }
    
    public static testmethod void createcontactEmail1(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');        
        //insert maincon;

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Contact con = new Contact(AccountID = acc.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='XYZ',
            Email = 'test@gmail.com',
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='test123',
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName1',
            Initials__c = 'TestLastName1',
            Birthdate = Date.valueOf('1992-02-20'),
            Phone = '9879879877',
            ts2__EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering;Industrial' );

        //insert con;
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
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.CreateContactPage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id); 
        System.currentPageReference().getParameters().put('siteId', site.id); 
        System.currentPageReference().getParameters().put('accid', acc.id);  
        System.currentPageReference().getParameters().put('fname', con.FirstName);  
        System.currentPageReference().getParameters().put('lname', con.Lastname);  
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactPage_ext  permgenerate = new CreateContactPage_ext (sc);
        permgenerate.conrec.Email = 'test@gmail.com';
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.SaveandAddAddress();   
        Test.stopTest();  
    }
    
    public static testmethod void createcontactEmail3(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');        
        //insert maincon;

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Contact con = new Contact(AccountID = acc.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='XYZ',
            Email = 'test@gmail.com',
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='test123',
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName1',
            Initials__c = 'TestLastName1',
            Birthdate = Date.valueOf('1992-02-20'),
            Phone = '9879879877',
            ts2__EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering;Industrial' );

        //insert con;
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
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());
        Test.setCurrentPageReference(new PageReference('Page.CreateContactPage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id); 
        System.currentPageReference().getParameters().put('siteId', site.id); 
        System.currentPageReference().getParameters().put('accid', acc.id);  
        System.currentPageReference().getParameters().put('fname', con.FirstName);  
        System.currentPageReference().getParameters().put('lname', con.Lastname);  
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactPage_ext  permgenerate = new CreateContactPage_ext (sc);
        permgenerate.conrec.Email = 'test@gmail.com';
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect2();   
        Test.stopTest();  
    }
    
    public static testmethod void createcontactEmail4(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');        
        //insert maincon;

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Contact con = new Contact(AccountID = acc.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='XYZ',
            Email = 'test@gmail.com',
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='test123',
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName1',
            Initials__c = 'TestLastName1',
            Birthdate = Date.valueOf('1992-02-20'),
            Phone = '9879879877',
            ts2__EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering;Industrial' );

        //insert con;
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
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());
        Test.setCurrentPageReference(new PageReference('Page.CreateContactPage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id); 
        System.currentPageReference().getParameters().put('siteId', site.id); 
        System.currentPageReference().getParameters().put('accid', acc.id);  
        System.currentPageReference().getParameters().put('fname', con.FirstName);  
        System.currentPageReference().getParameters().put('lname', con.Lastname);  
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactPage_ext  permgenerate = new CreateContactPage_ext (sc);
        permgenerate.conrec.Email = 'test@gmail.com';
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.SaveandAddAddress();   
        Test.stopTest();  
    }
}
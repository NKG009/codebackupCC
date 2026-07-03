@isTest
public class Test_create2ndtiersupplier_ext {
    
    public static testmethod void create2ndtiercandidate(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'IP_2ndTierSupplier']; 

        Account account1 = new Account(Name='2nd Tier',RecordTypeId=accountRec.id);
        insert account1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];

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
            EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering' );

        insert con;
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.create2ndtiersupplier')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        create2ndtiersupplier_ext  permgenerate = new create2ndtiersupplier_ext (sc);
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect1();
        permgenerate.cancelredirect(); 
        permgenerate.getContextUserUiThemeDisplayed();
        Test.stopTest();
    }
    
    public static testmethod void create2ndtiercandidateEmailNotNull(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'IP_2ndTierSupplier']; 

        Account account1 = new Account(Name='2nd Tier',RecordTypeId=accountRec.id);
        insert account1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];

        Contact con = new Contact(AccountID = account1.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            Email = 'test@gmail.com',
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
            EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering' );

        //insert con;
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.create2ndtiersupplier'));
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());        
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        create2ndtiersupplier_ext  permgenerate = new create2ndtiersupplier_ext (sc);
        permgenerate.conrec = con;
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect1();
        permgenerate.cancelredirect(); 
        permgenerate.getContextUserUiThemeDisplayed();
        Test.stopTest();
    }
    
    public static testmethod void create2ndtiercandidateEmailNull(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'IP_2ndTierSupplier']; 

        Account account1 = new Account(Name='2nd Tier',RecordTypeId=accountRec.id);
        insert account1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];

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
            EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering' );

        //insert con;
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.create2ndtiersupplier'));
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        create2ndtiersupplier_ext  permgenerate = new create2ndtiersupplier_ext (sc);
        permgenerate.conrec = con;
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect1();
        permgenerate.cancelredirect(); 
        permgenerate.getContextUserUiThemeDisplayed();
        Test.stopTest();
    }
    
    public static testmethod void create2ndtiercandidateEmailNotNull1(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'IP_2ndTierSupplier']; 

        Account account1 = new Account(Name='2nd Tier',RecordTypeId=accountRec.id);
        insert account1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];

        Contact con = new Contact(AccountID = account1.id, 
            RecordTypeId=condRec.id,
            FirstName ='ABC',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            Email = 'test@gmail.com',
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
            EEO_Gender__c = 'M',
            // P45_Date_by_Head_Office__c= System.today(),
            IP_CategoryOfWork__c='Catering' );

        //insert con;
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.create2ndtiersupplier'));
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());      
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        create2ndtiersupplier_ext  permgenerate = new create2ndtiersupplier_ext (sc);
        permgenerate.conrec = con;
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect1();
        permgenerate.cancelredirect(); 
        permgenerate.getContextUserUiThemeDisplayed();
        Test.stopTest();
    }
}
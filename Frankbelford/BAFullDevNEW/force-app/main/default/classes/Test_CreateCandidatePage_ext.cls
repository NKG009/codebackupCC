@isTest
public class Test_CreateCandidatePage_ext {
    
    public static testmethod void createcandidate(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];

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
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.CreateCandidatePage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateCandidatePage_ext  permgenerate = new CreateCandidatePage_ext(sc);
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.saveandredirect();
        permgenerate.cancelredirect();   
        permgenerate.checkduplicate();
        Test.stopTest();  
    }
    
    public static testmethod void createcandidate1(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Test.startTest();
        Contact con = new Contact(AccountID = acc1.id, 
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
        
        system.debug('++++++++con++++++'+con);
        
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.CreateCandidatePage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateCandidatePage_ext  permgenerate = new CreateCandidatePage_ext (sc);
        permgenerate.conrec = con;
        permgenerate.saveandredirect();
        permgenerate.cancelredirect();   
        permgenerate.checkduplicate();
        //permgenerate.saveandredirectallowbypass();
        Test.stopTest();  
    }
    
    public static testmethod void createcandidate2(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Test.startTest();
        Contact con = new Contact(AccountID = acc1.id, 
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
        
        system.debug('++++++++con++++++'+con);
        
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.CreateCandidatePage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateCandidatePage_ext  permgenerate = new CreateCandidatePage_ext (sc);
        permgenerate.conrec = con;
        permgenerate.saveandredirectallowbypass();
        Test.stopTest();  
    }
    
    public static testmethod void createcandidate3(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Test.startTest();
        Contact con = new Contact(AccountID = acc1.id, 
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
        
        system.debug('++++++++con++++++'+con);
        
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());
        Test.setCurrentPageReference(new PageReference('Page.CreateCandidatePage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateCandidatePage_ext  permgenerate = new CreateCandidatePage_ext (sc);
        permgenerate.conrec = con;
        permgenerate.saveandredirect();
        permgenerate.cancelredirect();   
        permgenerate.checkduplicate();
        //permgenerate.saveandredirectallowbypass();
        Test.stopTest();  
    }
    
    public static testmethod void createcandidate4(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Test.startTest();
        Contact con = new Contact(AccountID = acc1.id, 
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
        
        system.debug('++++++++con++++++'+con);
        
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());
        Test.setCurrentPageReference(new PageReference('Page.CreateCandidatePage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateCandidatePage_ext  permgenerate = new CreateCandidatePage_ext (sc);
        permgenerate.conrec = con;
        permgenerate.saveandredirectallowbypass();
        Test.stopTest();  
    }
    
    public static testmethod void createcandidate5(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Test.startTest();
        Contact con = new Contact(AccountID = acc1.id, 
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
        
        system.debug('++++++++con++++++'+con);
        
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());
        Test.setCurrentPageReference(new PageReference('Page.CreateCandidatePage')); 
        System.currentPageReference().getParameters().put('recid', condRec.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateCandidatePage_ext  permgenerate = new CreateCandidatePage_ext (sc);
        permgenerate.conrec = con;
        permgenerate.saveandredirectallowbypass();
        Test.stopTest();  
    }
    
}
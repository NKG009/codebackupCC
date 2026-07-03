/*
* Class Name: TestEmailAddressVerificationController
* Description: Test Class of EmailAddressVerificationController
*/
@isTest
public class TestEmailAddressVerificationController{

    public static testmethod void EmailAddressVerificationMethod(){
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
                                EEO_Gender__c = 'M',
                                // P45_Date_by_Head_Office__c= System.today(),
                                IP_CategoryOfWork__c='Catering;Industrial' );
        insert con;                     
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.EmailAddressVerification')); 
        System.currentPageReference().getParameters().put('conId', con.id);
        EmailAddressVerificationController  emailAddressVerification = new EmailAddressVerificationController();
        emailAddressVerification.contactEmailVerificationFunction();
        emailAddressVerification.updateEmailOnContact();
        emailAddressVerification.cancelEmailVerification();
        Test.stopTest();
    }
    
    public static testmethod void EmailAddressVerificationMethod1(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');
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
                                Email = 'test1@gmail.com',
                                Title = 'TestLastName1',
                                Initials__c = 'TestLastName1',
                                Birthdate = Date.valueOf('1992-02-20'),
                                Phone = '9879879877',
                                EEO_Gender__c = 'M',
                                // P45_Date_by_Head_Office__c= System.today(),
                                IP_CategoryOfWork__c='Catering;Industrial' );
        insert con;                     
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailnotValidatedResonse());
        Test.setCurrentPageReference(new PageReference('Page.EmailAddressVerification')); 
        System.currentPageReference().getParameters().put('conId', con.id);
        EmailAddressVerificationController  emailAddressVerification = new EmailAddressVerificationController();
        emailAddressVerification.contactEmailValue = con.Email;
        emailAddressVerification.contactEmail = con.Email;
        emailAddressVerification.contactEmailVerificationFunction();
        emailAddressVerification.updateEmailOnContact();
        emailAddressVerification.cancelEmailVerification();
        Test.stopTest();
    }
    
    public static testmethod void EmailAddressVerificationMethod2(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');
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
                                Email = 'test2@gmail.com',
                                Title = 'TestLastName1',
                                Initials__c = 'TestLastName1',
                                Birthdate = Date.valueOf('1992-02-20'),
                                Phone = '9879879877',
                                EEO_Gender__c = 'M',
                                // P45_Date_by_Head_Office__c= System.today(),
                                IP_CategoryOfWork__c='Catering;Industrial' );
        insert con;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailMockHttpResponseGenerator());
        Test.setCurrentPageReference(new PageReference('Page.EmailAddressVerification')); 
        System.currentPageReference().getParameters().put('conId', con.id);
        EmailAddressVerificationController  emailAddressVerification = new EmailAddressVerificationController();
        emailAddressVerification.contactEmailValue = con.Email;
        emailAddressVerification.contactEmail = con.Email;
        emailAddressVerification.contactEmailVerificationFunction();
        emailAddressVerification.updateEmailOnContact();
        emailAddressVerification.cancelEmailVerification();
        Test.stopTest();
    }
    
    public static testmethod void EmailAddressVerificationMethod3(){
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id,Email = 'test@gmail.com');
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
                                Email = 'test2@gmail.com',
                                Title = 'TestLastName1',
                                Initials__c = 'TestLastName1',
                                Birthdate = Date.valueOf('1992-02-20'),
                                Phone = '9879879877',
                                EEO_Gender__c = 'M',
                                // P45_Date_by_Head_Office__c= System.today(),
                                IP_CategoryOfWork__c='Catering;Industrial' );
        insert con;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EmailMailRoutableDomain());
        Test.setCurrentPageReference(new PageReference('Page.EmailAddressVerification')); 
        System.currentPageReference().getParameters().put('conId', con.id);
        EmailAddressVerificationController  emailAddressVerification = new EmailAddressVerificationController();
        emailAddressVerification.contactEmailValue = con.Email;
        emailAddressVerification.contactEmail = con.Email;
        emailAddressVerification.contactEmailVerificationFunction();
        emailAddressVerification.updateEmailOnContact();
        emailAddressVerification.cancelEmailVerification();
        Test.stopTest();
    }
    
}
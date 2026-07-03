@istest
public class PayProfileTrigger_Test {

    public static testmethod void CreatePayrofile1(){
 RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = false);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);

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
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        RecordType rec = [Select id,Name from RecordType where id =: payRTId];

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
        
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.PayeandUmbPage')); 
        System.currentPageReference().getParameters().put('recid', payRTId);
        System.currentPageReference().getParameters().put('conID', con.id);     
        ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
        createpayumbpayprofile  permgenerate = new createpayumbpayprofile (sc);
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
        permgenerate.recordTypeName = rec.Name;
        permgenerate.saveandredirect();
        permgenerate.cancelredirect();   
        permgenerate.saveandredirectnewpage();
        Test.stopTest();
    }
    
    public static testmethod void CreatePayrofile2(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = false);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);

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
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        RecordType rec = [Select id,Name from RecordType where id =: payRTId];

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
        
        con.AccountId = account1.id;
        update con;
        
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.PayeandUmbPage')); 
        System.currentPageReference().getParameters().put('conID', con.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
        createpayumbpayprofile permgenerate = new createpayumbpayprofile (sc);
        permgenerate.recordTypeName = rec.Name;
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;        
        permgenerate.saveandredirect();
        permgenerate.cancelredirect();   
        permgenerate.saveandredirectnewpage();
        Test.stopTest();

    }
    
    public static testmethod void CreatePayrofileUmbrella(){
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

        Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;

         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = false);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);

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
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();
        RecordType rec = [Select id,Name from RecordType where id =: payRTId];

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
        
        con.AccountId = account1.id;
        update con;
        
        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.PayeandUmbPage')); 
        System.currentPageReference().getParameters().put('conID', con.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
        createpayumbpayprofile permgenerate = new createpayumbpayprofile (sc);
        permgenerate.recordTypeName = rec.Name;
        // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;        
        permgenerate.saveandredirect();
        permgenerate.cancelredirect();   
        permgenerate.saveandredirectnewpage();
        Test.setCurrentPageReference(new PageReference('Page.RecordTypeselection'));
        Test.setCurrentPageReference(new PageReference(payprofile.id));
        Test.stopTest();

    }
    
}
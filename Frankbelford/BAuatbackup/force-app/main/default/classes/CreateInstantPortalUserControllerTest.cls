@isTest
public class CreateInstantPortalUserControllerTest{
    
    
    private static testMethod void createUser(){
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        //UserRole ur = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert ur;
        Account acc = TestDataFactory.createClients(1)[0];
        acc.OwnerId = UserInfo.getUserId();
        insert acc;

        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAcc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
        //insert new User_Profile_Id__c (name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG');

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        TestDataFactory.setupUserProfileCustomSettings();
         Contact c = new Contact();
        c.FirstName='Con';
        c.email = 'test123@gmail.com';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Catering';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        User thisUser = [ select Id,UserType from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
        UserRole ur = new UserRole(); 
        if(acc.isCustomerPortal)
            ur = [Select Id,Name from UserRole Where Name =:acc.name+' Customer User'];
        Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        
        User newUser = new User(
            UserRoleId = ur.Id,
            profileId = p.id,
            contactId = c.id,
            Username = c.email ,
            street = c.mailingstreet,
            city = c.mailingcity,
            postalcode = c.mailingpostalcode,
            state = c.mailingstate,
            country = c.mailingcountry,
            Alias = c.firstName.substring(0,1)+c.LastName.substring(0,3),
            Email=c.email,
            EmailEncodingKey='UTF-8',
            Firstname=c.firstName,
            Lastname=c.LastName,
            LanguageLocaleKey='en_GB',
            LocaleSidKey='en_GB',
            TimeZoneSidKey='Europe/London'
        );
            Database.insert(newUser);  
        }
        
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;

        Test.StartTest(); 

            ApexPages.currentPage().getParameters().put('id', String.valueOf(c.Id));
            CreateInstantPortalUserController.createUser();  
            
        Test.StopTest();
    }

     private static testMethod void createUser2(){
         Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
         //UserRole ur = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
         //insert ur;
         Account acc = TestDataFactory.createClients(1)[0];
         acc.OwnerId = UserInfo.getUserId();
         insert acc;

         Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
         insert candidateAcc;
         TestDataFactory.setupUserProfileCustomSettings();
         insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
         //insert new User_Profile_Id__c (name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG');
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.email = 'arora.charu0523@gmail.com';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Catering';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;

         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];

        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;

        Test.StartTest();

            ApexPages.currentPage().getParameters().put('id', String.valueOf(c.Id));
            CreateInstantPortalUserController.createUser();

        Test.StopTest();
    }

    private static testMethod void createUser3(){
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        //UserRole ur = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert ur;
        Account acc = TestDataFactory.createClients(1)[0];
        acc.OwnerId = UserInfo.getUserId();
        insert acc;

        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAcc;
        TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
        //insert new User_Profile_Id__c (name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG');
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        RecordType rtContact=[SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Contact'];
        Contact c = new Contact();
        c.FirstName='Con';
        c.email = 'arora.charu0523@gmail.com';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Catering';
        c.RecordTypeId=rtContact.id;
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];

        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;

        Test.StartTest();

            ApexPages.currentPage().getParameters().put('id', String.valueOf(c.Id));
            CreateInstantPortalUserController.createUser();

        Test.StopTest();
    }

    private static testMethod void createUser4(){
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        //UserRole ur = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert ur;
        Account acc = TestDataFactory.createClients(1)[0];
        acc.OwnerId = UserInfo.getUserId();
        insert acc;

        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAcc;
        TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
        //insert new User_Profile_Id__c (name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG');
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        RecordType rtContact=[SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Contact'];
        Contact c = new Contact();
        c.FirstName='Con';
        c.email = 'arora.charu0523@gmail.com';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Catering';
        c.RecordTypeId=rtContact.id;
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;
        
        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
        insert topaz;
        
        sirenum__Site__c site1 = TestDataFactory.createSites(acc.id,topaz.id,1)[0];
        site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = c.id;
        site1.IP_InvoiceContact__c = c.id;
        site1.IP_PassClientToTempest__c = false;
        insert site1;
        
        Contact_Site_link__c csl = new Contact_Site_link__c();
        csl.Account__c = acc.id;
        csl.IP_Contact__c = c.id;
        csl.IP_PortalType__c = 'Primary Hours Approver';
        csl.IP_Site__c = site1.id;        
        insert csl;

        Test.StartTest(); 

            ApexPages.currentPage().getParameters().put('id', String.valueOf(c.Id));
            CreateInstantPortalUserController.createUser();  
            
        Test.StopTest();
    }
}
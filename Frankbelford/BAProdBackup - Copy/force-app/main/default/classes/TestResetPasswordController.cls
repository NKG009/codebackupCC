@isTest
public class TestResetPasswordController{
    @TestSetup
    static void setupTestData(){
        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        Insert candidateAcc;
        TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=candidateAcc.Id);
    }
    
    
    private static testMethod void ResetPassword1(){
        Account acc = TestDataFactory.createClients(1)[0];
        acc.OwnerId = UserInfo.getUserId();
        insert acc; 

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
        Test.StartTest();
        ResetPasswordController restcontrller = new ResetPasswordController();
        ResetPasswordController.resetPasswordForClient(c.id);
        Test.StopTest();
    }
    
    
    private static testMethod void ResetPassword2(){
        Account acc = TestDataFactory.createClients(1)[0];
        acc.OwnerId = UserInfo.getUserId();
        insert acc;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact c = new Contact();
        c.FirstName='Con';
        c.email = 'test123@gmail.com';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
        Test.StartTest();
        ResetPasswordController restcontrller = new ResetPasswordController();
        ResetPasswordController.resetPasswordForClient(c.id);
        Test.StopTest();
    }
    
    private static testMethod void ResetPassword3(){
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        
        Account acc = TestDataFactory.createClients(1)[0];
        acc.OwnerId = UserInfo.getUserId();
        insert acc;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact c = new Contact();
        c.FirstName='Con';
        c.email = 'test123@gmail.com';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
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
        Test.StartTest();
        ResetPasswordController restcontrller = new ResetPasswordController();
        ResetPasswordController.resetPasswordForClient(c.id);
        Test.StopTest();
    }
}
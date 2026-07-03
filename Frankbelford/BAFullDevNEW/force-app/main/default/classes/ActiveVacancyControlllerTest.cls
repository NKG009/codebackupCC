@isTest
private class ActiveVacancyControlllerTest {

    // Test data setup
    @testSetup static void shiftSetupTest() {
        
        // Create Standard User profile
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Create a User for testing
        User usr = new User(
            LastName = 'LIVESTON',
            FirstName = 'JASON',
            Alias = 'jliv',
            Email = 'jason.liveston@asdf.com',
            Username = 'jason.liveston@asdf.com',
            ProfileId = profileId.Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US'
        );
        insert usr;
        
        Payroll_Swtich__c pay = new Payroll_Swtich__c();
        pay.Name = 'Stoppayroll'; // Match the name expected by the trigger
        pay.Batch_check__c = true;
        insert pay;
        
        // Create an Account and Contact
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.Id, 1)[0]; 
        insert con;
        
        // Create an associated Topaz Global Client Information record
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = acc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c = '345432';
        insert topzClientInfo;
        
        // Create UserRole and Profile for Portal Account Owner
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1];
        
        // Create a test User in a different context (System.runAs)
        System.runAs(new User(
            ProfileId = profile1.Id,
            Username = 'test' + System.currentTimeMillis() + '@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Bruce',
            LastName = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago', 
            ContactId = con.Id
        )) {
            // Any DML operations or setup done here will not interfere with other tests
        }
    }

    // Actual Test Method
    @isTest
    static void testGetUserInformation() {
        
        // Start the test context
        Test.startTest();
        
        // Call the controller method you want to test
        ActiveVacancyControlller.getUserInformation();

        // Optionally add an assertion to validate the results, for example:
        // System.assertNotEquals('Expected User Information', ActiveVacancyControlller.someResult);
        
        // End the test context
        Test.stopTest();

        // Optionally, assert specific behavior depending on what getUserInformation does
        // Example: Assert if a specific action occurred or data was fetched properly.
    }

    // Optionally add additional test methods to cover other use cases (like getSites)
    @isTest
    static void testGetSites() {
        Test.startTest();
            User runningUser = [SELECT Id, ContactId FROM User WHERE Email='bruce.wayne@wayneenterprises.com' LIMIT 1];
        // Assuming getSites() is a method you intend to test
           System.runAs(runningUser) {
        ActiveVacancyControlller.getSites();
                }
        
        // Optionally, add assertions here to validate the results
        
        Test.stopTest();
    }
}
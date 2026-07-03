@isTest
public class UpdateContactFromCommunityClass_Test {
    @TestSetup
    static void setupTestData() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert new User_Profile_Id__c(
                Name = 'User Portal',
                Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
            );
        }

        Profile theProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uniqueString = 'test_admin' + System.now().millisecond() + 'test' + (Math.random() * 1000).intValue() + '@test.com';

        // Create portal account owner.
        User portalAccountOwner = new User(
            UserRoleId = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1].Id,
            ProfileId = theProfile.Id,
            Username = uniqueString,
            Alias = 'batman',
            Email = uniqueString,
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago',
            IP_TempestDepartment__c = '1062',
			Brand__c = 'Blue Arrow',
			IP_TempestDivision__c = 'NTN'
        );
        insert portalAccountOwner;
        
        Contact theContact = null;
        System.runAs(portalAccountOwner) {
            TestDataFactory.setupUserProfileCustomSettings();

            // Insert test accounts.
            Account portalAccount = TestDataFactory.createClients(1)[0];
            portalAccount.OwnerId = portalAccountOwner.Id;
            Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
            insert new List<Account> { portalAccount, candidateAccount };

            TestDataFactory.setupCustomSettings(candidateAccount.Id);
            
            // Insert test contact.
            uniqueString = 'test_clientContact' + System.now().millisecond() + 'test' + (Math.random() * 1000).intValue() + '@test.com';
            theContact = TestDataFactory.createContact(portalAccount.Id, 1)[0];
            theContact.FirstName = 'Test';
            theContact.Lastname = 'McTesty';
            theContact.Email = uniqueString;
            theContact.PPE_Type__c = 'Polo shirt';
            insert theContact;
        }

        // Create portal user.
        Id portalProfileId = User_Profile_Id__c.getValues(Label.Client_Portal_User_Profile).Profile_Id__c;
        User portalUser = new User(
            Username = theContact.Email,
            ContactId = theContact.Id,
            ProfileId = portalProfileId,
            Alias = 'test'+ (Math.random()*1000).intValue(),
            Email = theContact.Email,
            EmailEncodingKey = 'UTF-8',
            FirstName = theContact.FirstName,
            LastName = theContact.LastName,
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            Street = '1223',
            City = 'Delhi',
            State = 'Delhi',
            Country = 'India',
            phone = '1234567890',
            mobilePhone = '9034567865',
            IP_TempestDepartment__c='1062',
			Brand__c = 'Blue Arrow',
			IP_TempestDivision__c = 'NTN'
        );

        User exceptionUser = TestDataFactory.createUsers(theProfile.Id, 1)[0];
        exceptionUser.username = 'mko.vfr@njh.com';
        exceptionUser.GUID_user__c = 'ABC123';
		exceptionUser.Brand__c = 'Blue Arrow';
		exceptionUser.IP_TempestDivision__c = 'NTN';

		insert new List<User> { portalUser, exceptionUser };
    }
    
    @isTest
    static void userSetup() {
        TestDataFactory.getEmailTemplate();
        User clientContactUser = [SELECT Id, FirstName, LastName, Email FROM User
                                  WHERE Contact.AccountId = :[SELECT Id FROM Account LIMIT 1].Id];
        System.runAs(clientContactUser) {
            String uniqueString = 'test_admin' + System.now().millisecond() + 'test' + (Math.random() * 1000).intValue() + '@test.com';

            Test.startTest();

            clientContactUser.email = uniqueString;
            clientContactUser.Street = '666';
            clientContactUser.city= 'DL';
            clientContactUser.State = 'DL';
            clientContactUser.Country = 'IND';
            clientContactUser.phone = '1994567890';
            clientContactUser.mobilePhone = '9030967865';
            clientContactUser.Firstname = 'test123123';
            clientContactUser.Lastname = 'test1234456';
            clientContactUser.Title = 'Mr';

            update clientContactUser;

            Test.stoptest();

            System.assert([SELECT Email FROM Contact WHERE Email = :uniqueString].size() > 0);
        }
    }

    @isTest
    static void validatePayrollFunctionality_TestCase_One() {
        insert new IP_CompanyCode__c(name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false);

        IP_BranchStatus__c theBranchStatus = new IP_BranchStatus__c();
        theBranchStatus.IP_BranchID__c = '1062';
        theBranchStatus.Name = 'Test';
        insert theBranchStatus;

        IP_ImpellamGlobalSetting__c theSetting = new IP_ImpellamGlobalSetting__c();
        theSetting.IP_LastTransmissionDate__c = Date.newInstance(2019,07,01);
        theSetting.IP_OutboundErrorEmailAddress__c = 'test@test.com';
        insert theSetting;

        Test.startTest();
        
        UserProcessupdate.sendMail = true;


        User theUser = new User();
        theUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].id;
        theUser.FirstName = 'Dev';
        theUser.LastName = 'Test';
        theUser.email = 'test3_' + System.now().millisecond() + 'test3@test.com';
        theUser.username = 'test3_' + System.now().millisecond() + 'test3@test.com';
        theUser.IP_TempestDepartment__c = '1062';
        theUser.IP_TempestID__c = '65742';
        theUser.Alias = 'abc1';
        theUser.TimeZoneSidKey = 'GMT';
        theUser.LanguageLocaleKey = 'en_US';
        theUser.EmailEncodingKey = 'UTF-8';
        theUser.LocaleSidKey = 'en_US';
        theUser.Brand__c = 'Blue Arrow';
        theUser.IP_TempestDivision__c = 'NTN';
        insert theUser;

        theUser.IP_PassToTempest__c = TRUE;
        update theUser;

        Test.stoptest();

        System.assert([SELECT Id FROM IP_OutboundDataTransfer__c].size() > 0);
    }
}
/**
 * Created by Charlie Nash (RSS Global) on 15/11/2023.
 * @date 15/11/2023
 *
 * @description Test class for the 'NewSelfRegController' class.
 *
 */

@IsTest
private class NewSelfRegControllerTest {

    static List<Account> accounts;
    static List<Contact> candidates;

    @TestSetup
    static void testSetupMethod() {

        Account candidateAcc = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAcc;
        TestDataFactory.setupCustomSettings(candidateAcc.Id);
        Id urId = [SELECT Id FROM UserRole WHERE Name='Impellam IT'].Id;
        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'l4848',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1010',
                IP_TempestDivision__c='NTS',Department='1010',IP_PassToTempest__c=true, Brand__c='Blue Arrow',
                UserRoleId = urId);
        TestDataFactory.insertUser(new List<String> {JSON.serialize(u)});
        //TestDataFactory.setupUserProfileCustomSettings();

        User_Profile_Id__c setting = new User_Profile_Id__c(
                Profile_Id__c = '00e0Y000000QNyxQAG',
                Name = 'User Portal'
        );

        insert setting;

        candidateSelfRegistrationSettings__c emailSetting = new candidateSelfRegistrationSettings__c(
                Name = 'Candidate',
                Send_Custom_Template__c = true,
                Template_API_Name__c = 'Self_Registration_Sign_Up_Email'
        );

        insert emailSetting;

    }

    @IsTest
    static void testNewCandidateLogic(){

        //Contact candidate = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];

        Test.startTest();
        //Test the creation of a new candidate user when an existing candidate record is already on the system.
        String result = NewSelfRegController.initiateSelfReg('Charlie', 'Testing', 'Test12345CharlieNash@test.com');
        Test.stopTest();
    }

    @IsTest
    static void testExistingCandidateLogic(){

        Id cId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();

        Contact newContact = new Contact(
                FirstName = 'firstName',
                LastName = 'lastName',
                Email = 'testemail@test.com',
                RecordTypeId = cId
                //OwnerId = [SELECT Id FROM User WHERE Name = 'Blue Arrow User' LIMIT 1].Id,
                //AccountId = '0014J00000XaetjQAB' //TODO Change this to be dynamic
        );

        insert newContact;

        Test.startTest();

        String result = NewSelfRegController.initiateSelfReg(newContact.FirstName, newContact.LastName, newContact.Email);

        Test.stopTest();

    }

    @IsTest
    static void testReturnCandidateEmail(){

        Id cId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();

        Contact newContact = new Contact(
                FirstName = 'firstName',
                LastName = 'lastName',
                Email = 'testemail@test.com',
                RecordTypeId = cId
                //OwnerId = [SELECT Id FROM User WHERE Name = 'Blue Arrow User' LIMIT 1].Id,
                //AccountId = '0014J00000XaetjQAB' //TODO Change this to be dynamic
        );

        insert newContact;

        Test.startTest();

        String result = NewSelfRegController.returnContactEmailFromId(newContact.Id);

        Test.stopTest();

        //Assert the correct email is returned
        System.assertEquals('testemail@test.com', result);

    }
}
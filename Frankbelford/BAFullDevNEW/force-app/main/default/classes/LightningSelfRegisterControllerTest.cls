/**
 * Created by mrahman on 2021-02-04.
 */



@IsTest
public with sharing class LightningSelfRegisterControllerTest {
    @TestSetup
    public static void makeData(){
        Id candidateAccountRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        Account candidateAccount = new Account(RecordTypeId= candidateAccountRTID, Name='Candidates');
        insert candidateAccount;

        Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
        objCustomPayrol.Batch_check__c = false;
        objCustomPayrol.Name = 'Stoppayroll';
        insert objCustomPayrol;
        insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );

    //Create contact
    Contact contact1 = new Contact(
        FirstName = 'Bruce',
        Lastname = 'Wayne',
        AccountId = candidateAccount.Id,
        RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId(),
        Email = 'test2'+System.now().millisecond() + 'test2@test.com'
    );
    Database.insert(contact1);


    User portalAccountUser1 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User']
        .Id,
        ContactId = contact1.Id,
        Username = System.now().millisecond() + 'test254@test.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
    );
    
    insert portalAccountUser1;
    }

    @IsTest
    static  void testInitVerification(){
        System.assertNotEquals(null, LightningSelfRegisterController.initVerification('Test', 'Candidate', 'test_candidate@test.com'));
    }

    @IsTest
    static void testValidatePassword(){
        Account ca = [SELECT Id, Name FROM Account WHERE RecordType.Name='Candidate' LIMIT 1];
        Contact worker = TestDataFactory.createCandidate(ca.Id,1)[0];
        insert worker;
        Profile p = [Select id from Profile where Name = 'User Portal' LIMIT 1];
        User u = TestDataFactory.createUsers(p.id,1)[0];
        u.IP_TempestDepartment__c = '2043';
        u.username = 'test1234@test2.com';
        u.Brand__c = 'Blue Arrow';
        u.ContactId = worker.Id;
        insert u;
        LightningSelfRegisterController.validatePassword(u, 'Password', 'Password1');
    }

    /* Verifies that IsValidPassword method with various password combinations. */
    @IsTest
    static void testIsValidPassword() {
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
        System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
        System.assert(LightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
    }

    @IsTest
    static void testSiteAsContainerEnabled() {
        System.assertNotEquals(null, LightningSelfRegisterController.siteAsContainerEnabled('https://uat-yourcompanyportal-15728bf70b1.cs81.force.com'));
    }

    /* Verifies the selfRegistration method flow with various invalid inputs */
    @IsTest
    static void testSelfRegistration() {
        Map < String, String > paramsMap = initializeParams();
        Map < String, String > rtValue = new Map < String, String >();
        System.assertNotEquals(null, paramsMap);
        //rtValue = LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code'));
        //System.assertEquals(Label.Site.lastname_is_required, rtValue.values()[0]);
        //System.assertEquals(Label.Site.email_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code')));
        rtValue = LightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), '', null, paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code'));
        System.assertEquals(Label.Site.email_is_required, rtValue.values()[0]);
        rtValue = LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code'));
        System.assertEquals(Label.site.passwords_dont_match, rtValue.values()[0]);
        System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false, paramsMap.get('id'), paramsMap.get('code')));
    }


    /* Verifies the selfRegistration flow for valid inputs */
    @IsTest
    static void testSelfRegisterWithProperCredentials() {
        Map < String, String > paramsMap = initializeParams();
        Map < String, String > rtValue = new Map < String, String >();
        rtValue = LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code'));
        //System.assert(rtValue.keySet().contains('-1'));
        System.assertNotEquals(null, rtValue);
    }

    @IsTest
    static void testSelfRegisterWithNullPassCredentials() {
        Map < String, String > paramsMap = initializeParams();
        Map < String, String > rtValue = new Map < String, String >();
        rtValue = LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), null, paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code'));
        //System.assert(rtValue.keySet().contains('-1'));
        System.assertNotEquals(null, rtValue);
    }

    /* Verifies SelfRegistration flow with an accounId that is created within the test */
    @IsTest
    static void testSelfRegisterWithCreatedAccount() {
        Account acc = new Account(name = 'test acc');
        insert acc;
        List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
        System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        String accountId = accounts[0].Id;
        Map < String, String > paramsMap = initializeParams();
        Map < String, String > rtValue = new Map < String, String >();
        rtValue = LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false, paramsMap.get('id'), paramsMap.get('code'));
        System.assertNotEquals(null, rtValue);
    }

    @IsTest
    static void testSelfRegisterWithExistingContact() {
        Account acc = new Account(name = 'test acc');
        insert acc;
        List < Account > accounts = [SELECT Id FROM Account WHERE Name='Candidates' LIMIT 1];
        System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        String accountId = accounts[0].Id;
        User existWorderUsr = [SELECT Id, FirstName, LastName, Email FROM User WHERE Profile.Name='User Portal' AND IsActive=true AND LastName='Wayne' LIMIT 1];
        Map < String, String > paramsMap = initializeParams();
        Map < String, String > rtValue = new Map < String, String >();
        rtValue = LightningSelfRegisterController.selfRegister(existWorderUsr.FirstName, existWorderUsr.LastName, existWorderUsr.Email, paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code'));
        System.assertNotEquals(null, rtValue);
    }

    @IsTest
    static void testGetNullExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields(null));
    }

    @IsTest
    static void testGetNonEmptyExtraFields() {
        System.assert(LightningSelfRegisterController.getExtraFields('ts2__additionalinformation_js').size()>0);
    }

    @IsTest
    static void testReturnMessage(){
        System.assertEquals('test message', LightningSelfRegisterController.returnMessage('2', 'test message').get('2'));
    }

    /* Verifies validation of extraFields within the Self Registration flow */
    @IsTest
    static void testGetExtraFieldsInSelfRegistration() {
        List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
        Map < String, String > paramsMap = initializeParams();
        Map < String, Object > fieldMap = new Map < String, Object > ();
        fieldMap.put('description', 'new field');
        fieldMap.put('fieldPath', 'dummyPath');
        //fieldMap.put('Phone', 'User');
        fieldlist.add(fieldMap);
        String extraFields = JSON.serialize(fieldlist);
        //WITH EXTRA FIELD
        System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code')));
        //WITHOUT EXTRA FIELD
        System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, paramsMap.get('id'), paramsMap.get('code')));
    }

    @IsTest
    static void LightningSelfRegisterControllerInstantiation() {
        LightningSelfRegisterController controller = new LightningSelfRegisterController();
        System.assertNotEquals(controller, null);
    }

    /* Helper method to initialize the parameters required for SelfRegistration. */
    private static Map < String, String > initializeParams() {
        Map < String, String > paramsMap = new Map < String, String > ();
        String firstName = 'test';
        String lastName = 'User';
        String email = 'testUser@salesforce.com';
        String password = 'Password123';
        String confirmPasswordCorrect = 'Password123';
        String confirmPasswordWrong = 'wrongPassword';
        String accountId = 'testuser123';
        String regConfirmUrl = 'https://uat-yourcompanyportal-15728bf70b1.cs81.force.com';
        String startUrl = '/';
        String id = '3rwerwerq';
        String code = '432423';
        paramsMap.put('firstName', firstName);
        paramsMap.put('lastName', lastName);
        paramsMap.put('email', email);
        paramsMap.put('password', password);
        paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
        paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
        paramsMap.put('accountId', accountId);
        paramsMap.put('regConfirmUrl', regConfirmUrl);
        paramsMap.put('startUrl', startUrl);
        paramsMap.put('id', id);
        paramsMap.put('code', code);
        return paramsMap;
    }


    @IsTest
    static void TestGetContactFromId() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Assert.isNotNull(contact);

        Contact output = LightningSelfRegisterController.getCandidateFromId(contact.Id);
        Assert.isNotNull(output);
    }
}
@isTest
public class TestCreatePortalUserController {
    
    @testsetup
    static void splacementDetails(){
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;

        Account clientacc = TestDataFactory.createCandidateAccount(1)[0];
        Insert clientacc;

        TestDataFactory.setupUserProfileCustomSettings();
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=clientacc.Id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);


        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;

        Contact candidate = TestDataFactory.createCandidate(clientacc.id, 1)[0];
        Insert candidate;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
    }

    public static testmethod void getContactInfo(){
        List<Contact> listContact = [Select id from Contact limit 1];
        Test.startTest();
        CreatePortalUserController.getContact(listContact[0].id);
        Test.stopTest();     
    }
    
    public static testmethod void insertPortalUser(){
        Profile p1 = [SELECT Id,name FROM Profile where name='Customer Portal Manager Custom'];
        User usr1 = new User(LastName = 'himanshu',FirstName='JASON',Alias = 'jliv1',Email = 'mm1.sf@outlook.com',
                                Username = 'dummyEmail991'+'@email.com', TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                                IP_TempestDivision__c='NTS'); 
        CreatePortalUserController.insertPortalUser(usr1,p1.id);
    }
}
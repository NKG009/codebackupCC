@isTest
public class ContactTriggerHandlerTest {
      @testSetup
        static void setup(){
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
    }

    static testMethod void insertPropertyTest(){
           RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Property'];
           Account acc = new Account(
            Name = 'testaccount',
            Property_Manager_Name__c = 'testsname',
            PM_Last_Name__c  = 'testlastname',
            PM_First_Name__c = 'testfirstname',
            Current_PM_Email__c = 'test@firstname.com',
            RecordTypeId = PropertyRecordType.Id //Set this account to the Property Record Type
        );
        insert acc;
           Account accsecond = new Account(
            Name = 'secondtestaccount',
            Property_Manager_Name__c = 'secondtestsname',
            PM_Last_Name__c  = 'secondtestlastname',
            PM_First_Name__c = 'secondtestfirstname',
            Current_PM_Email__c = 'secondtest@firstname.com',
            RecordTypeId = PropertyRecordType.Id //Set this account to the Property Record Type
        );
        insert accsecond;         
        Contact con = new Contact(
            AccountId = acc.id,
            Lastname = 'newtestcontact',
            Firstname ='testdata1',
            OwnerId = Userinfo.getUserid(),
            email = 'newtest123@firstname.com'
        );
        insert con;
        Contact secondcon = new Contact(
            AccountId = accsecond.id,
            Lastname = 'secondnewtestcontact',
            Firstname ='secondtestdata1',
            OwnerId = Userinfo.getUserid(),
            email = 'secondnewtest123@firstname.com'
        );
        insert secondcon;
        Contact thirdcon = new Contact(
            AccountId = accsecond.id,
            Lastname = 'thirdnewtestcontact',
            Firstname ='thirdtestdata1',
            OwnerId = Userinfo.getUserid(),
            email = 'thirdnewtest123@firstname.com'
        );
        insert thirdcon;
        Contact forthcon = new Contact(
            AccountId = accsecond.id,
            Lastname = 'forthnewtestcontact',
            Firstname ='forthtestdata1',
            OwnerId = Userinfo.getUserid(),
            email = 'forthnewtest123@firstname.com'
        );
        insert forthcon;        
        AccountContactRelation accConRel = new AccountContactRelation(
            AccountId = accsecond.id,
            ContactId = con.id,
            Roles = 'Property Manager',
            IsActive = true        
        );
        insert accConRel;
        AccountContactRelation secondAccConRel = new AccountContactRelation(
            AccountId = acc.id,
            ContactId = secondcon.id,
            Roles = 'Property Manager',
            IsActive = true        
        );
        insert secondAccConRel;
        con.Lastname = 'Smith';
        con.Firstname = 'John';
        con.email = 'john@testemail.com';
        con.Preferred_Email_Raw__c = 'john@testemail.com;';
        secondcon.Firstname = null;
        thirdcon.Preferred_Email_Raw__c = 'johny@testemail.com&';
        forthcon.Preferred_Email_Raw__c = 'johny@testemail.com';        
        Test.startTest();
        update con;
        update secondcon;
        update thirdcon;
        update forthcon;
        Test.stopTest();
		Account result = [SELECT Property_Manager_Name__c,PM_First_Name__c,Current_PM_Email__c,PM_Last_Name__c from Account where Id =:accsecond.Id];
        System.assertEquals(con.Firstname, result.PM_First_Name__c);
        System.assertEquals(con.Lastname, result.PM_Last_Name__c);
        System.assertNotEquals('newtestcontact', result.PM_Last_Name__c);        
        System.assertEquals(con.email, result.Current_PM_Email__c);
        Account secondresult = [SELECT Property_Manager_Name__c,PM_Last_Name__c from Account where Id =:acc.Id];
        System.assertEquals(secondresult.PM_Last_Name__c, secondresult.Property_Manager_Name__c);
        System.assertEquals(secondresult.PM_Last_Name__c, 'secondnewtestcontact');
        Contact thirdresult = [SELECT email,preferred_email__c from Contact where Id =:thirdcon.Id];
        System.assertEquals('johny@testemail.com', thirdresult.preferred_email__c);
        System.assertEquals(thirdresult.email, thirdresult.preferred_email__c);         
 }
}
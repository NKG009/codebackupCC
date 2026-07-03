@isTest
private class TestReferenceDetailsAutoReminder{

    @testSetup static void setup() {
        TestDataFactory.setupUserProfileCustomSettings();
        Profile ProfSysAdmin=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        //User user1 = [SELECT Id, IP_TempestDepartment__c FROM User WHERE ProfileId =: ProfSysAdmin.Id AND IsActive = true  AND IP_TempestDepartment__c != null AND IP_TempestDepartment__c != '0000' LIMIT 1];
        User user1 = new User();
        DateTime dt = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime1 = dt.getTime();
        user1.LastName = 'UserSalesforce1';
        user1.FirstName='Testuser1';
        user1.Alias = 'tu' + 12324;
        user1.Email = 'abc.efgee@test.com';
        user1.username = 'te'+gettime1+'we@js.com.uk';
        user1.ProfileId = ProfSysAdmin.id;
        user1.TimeZoneSidKey = 'GMT';
        user1.LanguageLocaleKey = 'en_US';
        user1.EmailEncodingKey = 'UTF-8';
        user1.LocaleSidKey = 'en_US';
        user1.IP_TempestDepartment__c='1062';
        user1.IP_TempestID__c='1084678';
        user1.IP_TempestDivision__c='NTS';
        user1.Department='1062';
        user1.IP_PassToTempest__c=true;
        user1.Brand__c = 'Blue Arrow';
        insert user1;

        System.runas(user1){

            //Insert Shift Template
            insert new IP_Shift_Template__c(name = user1.IP_TempestDepartment__c, IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',
                    IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='W12 3AA',Branch_Address__c='street1',
                    Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

            //Insert Account
            Account acc =  TestDataFactory.createCandidateAccount(1)[0];
            insert acc;
            TestDataFactory.setupCustomSettings(acc.Id);

            //Insert Contact
            Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
            insert con;

            id payRTId = Schema.SObjectType.ts2__Reference__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
            //Insert Reference
            ts2__Reference__c ref = new ts2__Reference__c();
            ref.ts2__Candidate__c = con.id;
            ref.ts2__Name__c = 'Name1';
            ref.ts2__Email__c = 'abc@123.com';
            ref.Verbal_Reference__c = true;
            ref.Educational_Establishment__c = 'abc';
            ref.Date_Reference_Request_Sent__c = System.today().adddays(-7);
            ref.Course_Start_Date__c = System.today();
            ref.RecordTypeId = payRTId;
            insert ref;
            insert TestDataFactory.createJSForms(user1.Brand__c);
        }
    }

    private static testmethod void referencePositive(){
        List<ts2__Reference__c> ref = [Select id,ts2__Candidate__r.IP_TempestDepartment__c from ts2__Reference__c limit 1];
        referenceDetailsAutoReminder refautoreminder = new referenceDetailsAutoReminder();
        refautoreminder.record_Id = ref[0].id;

        test.startTest();
        refautoreminder.referenceid= refautoreminder.generateName();
        test.stopTest();
    }
}
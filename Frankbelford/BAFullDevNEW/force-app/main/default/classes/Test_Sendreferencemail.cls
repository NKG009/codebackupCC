@isTest
public class Test_Sendreferencemail {

    @TestSetup
    public static void setupTestData(){
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
        user1.Department='1010';
        user1.IP_TempestDepartment__c = '1010';
        user1.IP_PassToTempest__c=true;
        user1.Brand__c = 'Blue Arrow';
        insert user1;
        System.runAs(user1){
            insert new IP_Shift_Template__c(name = user1.Department, IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
            Account acc =  TestDataFactory.createCandidateAccount(1)[0];
            insert acc;
            TestDataFactory.setupCustomSettings(acc.Id);

            Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
            con.OwnerId = user1.Id;
            insert con;
            insert TestDataFactory.createJSForms(user1.Brand__c);

            TR1__Reference__c ref = new TR1__Reference__c();
            ref.TR1__Person_Placed__c = con.id;
            ref.Name__c = 'Name1';
            ref.Email__c = 'abc@123.com';
            ref.Verbal_Reference__c = true;
            ref.Educational_Establishment__c = 'abc';
            ref.Course_Start_Date__c = System.today();
            insert ref;
        }
    }

    public static testmethod void shiftdetails1(){
        TR1__Reference__c ref = [SELECT Id, Name, Status__c FROM TR1__Reference__c LIMIT 1];

        test.startTest();
            Sendreferencemail.sendEmail(ref.id,'Professional');
            Integer invocations = Limits.getEmailInvocations();
        test.stopTest();
    }

    public static testmethod void shiftdetails2(){
        User u = [SELECT Id, Username, Email FROM User WHERE Email = 'abc.efgee@test.com' LIMIT 1];
        TR1__Reference__c ref = [SELECT Id, Name, Status__c FROM TR1__Reference__c LIMIT 1];

        test.startTest();
        System.runAs(u) {
            referencedetails obj = new referencedetails();
            obj.record_Id = ref.id;
            obj.referenceid = obj.generateName();
        }
        test.stopTest();
    }
    
    public static testmethod void shiftdetails3(){
        TR1__Reference__c ref = [SELECT Id, Name FROM TR1__Reference__c LIMIT 1];
        test.startTest();
            Sendreferencemaillightning.getreferenceDetail(ref.id);
            Sendreferencemaillightning.sendemail(ref.id);
        test.stopTest();
    }
    
    public static testmethod void referencedetails3(){
        TR1__Reference__c ref = [SELECT Id, Name, Status__c FROM TR1__Reference__c LIMIT 1];
        ref.Status__c = 'Inactive';
        update ref;

        test.startTest();
            Sendreferencemail.sendEmail(ref.id,'Professional');
            Integer invocations = Limits.getEmailInvocations();
        test.stopTest();
    }

}
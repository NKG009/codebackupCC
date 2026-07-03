@isTest
public class Test_ClientNotification {

    @testSetup
    static void shiftSetup() {
        List<Contact> clientContacts = new List<Contact>();
        UserRole rId = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, Brand__c='Blue Arrow', UserRoleId=rId.Id);
        insert u;
        System.runAs(u){
            insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='B12 3SS',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
            TestDataFactory.setupShifts();
            List<sirenum__Shift__c> unApprovedShifts = new List<sirenum__Shift__c>();
            for(sirenum__Shift__c s : [SELECT Id, Name, sirenum__Site__c, sirenum__Contact__c, sirenum__Scheduled_End_Time__c, sirenum__Cancelled__c, sirenum__Published__c, IP_ClientRejected__c, IP_CandidateApproved__c, IP_ClientApproved__c
                                        FROM sirenum__Shift__c LIMIT 10]){
                sirenum__Shift__c cs = s.clone();
                cs.sirenum__Cancelled__c  = false;
                cs.sirenum__Published__c = true;
                cs.IP_ClientRejected__c  = false;
                cs.IP_CandidateApproved__c = true;
                cs.IP_ClientApproved__c = false;
                cs.sirenum__Scheduled_Start_Time__c = Datetime.now().addDays(-7).addHours(-10);
                cs.sirenum__Scheduled_End_Time__c = Datetime.now().addDays(-7);
                cs.sirenum__Site__c = s.sirenum__Site__c;
                cs.sirenum__Contact__c = s.sirenum__Contact__c;
                unApprovedShifts.add(cs);
            }
            insert unApprovedShifts;
            Account client = [SELECT Id, Name FROM Account WHERE RecordType.Name = 'Account' LIMIT 1];
            Contact cc = TestDataFactory.createContact(client.Id, 1)[0];
            insert cc;
            List<Contact_Site_link__c> csls = new List<Contact_Site_link__c>();
            for(sirenum__Site__c s : [SELECT Id, Name, sirenum__Operating_Company__c FROM sirenum__Site__c WHERE sirenum__Operating_Company__c =: client.Id]){
                csls.add(new Contact_Site_link__c(Account__c=s.sirenum__Operating_Company__c
                        ,IP_Contact__c = cc.Id
                        ,IP_PortalType__c='Escalation Hours Approver'
                        ,IP_Site__c = s.Id)
                );
            }
            insert csls;
            clientContacts = [SELECT Id, FirstName, LastName, Email, Brand__c, Account.Name, AccountId FROM Contact WHERE Account.RecordType.Name = 'Account'];
        }
        ApexPages.currentPage().getParameters().put('id', String.valueOf(clientContacts[0].Id));
        CreateInstantPortalUserController.createUser();

        ApexPages.currentPage().getParameters().put('id', String.valueOf(clientContacts[1].Id));
        CreateInstantPortalUserController.createUser();
    }

    @IsTest
    static void testClientNotificationPortals(){
        Test.startTest();
            Database.executeBatch(new ClientNotificationPortals());
        Test.stoptest();
    }

    @IsTest
    static void testClientEscalarionNotificationPortals(){
        Test.startTest();
            ClientEscalarionNotificationPortals  b = new ClientEscalarionNotificationPortals ();
            id batchID =  Database.executeBatch(b,200);
        Test.stopTest();
    }
}
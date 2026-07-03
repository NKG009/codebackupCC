@isTest
public with sharing class AccountTrigger_TEST {    
    
    @testSetup
    static void setup(){
        
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
        
        Manage_Triggers__c cs2 = new Manage_Triggers__c();
        cs2.Name = 'WorkOrderTrigger';
        cs2.isActive__c = false;
        insert cs2;
        
        
        Contact con2 = new Contact();
        con2.FirstName = 'Test';
        con2.LastName = 'Usertest';
        //con2.AccountId = acc.Id;
        insert con2;
        Contact con1 = new Contact();
        con1.FirstName = 'ttTest';
        con1.LastName = 'ttUsertest';
        // con1.AccountId = acc.Id;
        insert con1;
        User usr1 = new User();
        usr1.FirstName = 'Test';
        usr1.LastName = 'User1';
        usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;  
        usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
        usr1.Email = 'test.user1@yopmail.com.ps360.test';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.EmailEncodingKey = 'UTF-8';
        usr1.LocaleSidKey = 'en_US';
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.Alias = 'Alias1';
        usr1.Title = 'Title1';
        //usr1.ContactId = con2.Id;
        insert usr1;
        
        User usr2 = new User();
        usr2.FirstName = 'Test';
        usr2.LastName = 'User2';
        usr2.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;    
        usr2.Username = 'Test.User2@yopmail.com.ps360.test' + System.currentTimeMillis();    
        usr2.Email = 'test.user2@yopmail.com.ps360.test';
        usr2.LanguageLocaleKey = 'en_US';
        usr2.EmailEncodingKey = 'UTF-8';
        usr2.LocaleSidKey = 'en_US';
        usr2.TimeZoneSidKey = 'America/Los_Angeles';
        usr2.Alias = 'Alias2';
        usr2.Title = 'Title2';
        // usr2.ContactId = con1.Id;
        insert usr2;  
        Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
        account acc= new account();
        acc.name='paccount';
        acc.Invoice_Recipient_Preferences__c='Both Agency and Property Manager';
        acc.Invoicing_Email__c='inv@test.com';
        acc.Document_Receipt_Preferences__c='Both Agency and Property Manager';
        acc.Compliance_Cert_Email__c='comp@test.com';
        acc.RecordTypeId=rcId;
        insert acc;
        Id rctId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        account acct= new account();
        acct.name='tpaccount';
        acct.Property_Office_Agent__c=usr1.Id;
        acct.RecordTypeId=rctId;
        acct.Property_Source__c='Property Tree';
        acct.address_line_1__c ='tynbakingum street';
        acct.address_line_2__c='streetox' ;
        acct.address_street_number__c='10';
        acct.address_unit__c ='1';
        acct.address_suburb__c ='xyz';
        acct.address_state__c ='celsea';
        acct.address_country__c='USA';
        acct.address_post_code__c='1456387';
        acct.Last_Service_Date__c=system.today();
        insert acct;
        
        account acc1= new account();
        acc1.name='pnaaccount';
        acc1.Invoice_Recipient_Preferences__c='Agency Address Only';
        acc1.Document_Receipt_Preferences__c='Agency Address Only';
        acc1.RecordTypeId=rcId;
        insert acc1;
        account acc2= new account();
        acc2.name='paccount2';
        acc2.Invoice_Recipient_Preferences__c='Property Manager Only';
        acc2.Document_Receipt_Preferences__c='Property Manager Only';
        acc2.RecordTypeId=rcId;
        insert acc2;
        // acc.Property_Office_Agent__c=[select id from user where LastName = 'User1' limit 1].id;
        Id caccId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId() ;
        account cacc= new account();
        cacc.Name='caccount';
        cacc.ParentId=acc.Id;
        cacc.Current_PM_Email__c='pmo@test.com';
        cacc.RecordTypeId=caccId;
        insert cacc;
        account cacc1= new account();
        cacc1.Name='caccount2';
        cacc1.ParentId=acc1.Id;
        cacc1.Current_PM_Email__c='pmo2@test.com';
        cacc1.RecordTypeId=caccId;
        insert cacc1;
        account cacc2= new account();
        cacc2.Name='caccount3';
        cacc2.ParentId=acc2.Id;
        cacc2.Current_PM_Email__c='pmo3@test.com';
        cacc2.RecordTypeId=caccId;
        insert cacc2;
        
    }
    @isTest
    public static void assignAccounts() {
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        System.runAs(adminUsr){
            Account acc1 = new Account();
            acc1.Name = 'Account A';
            insert acc1;
            System.assert(acc1.Id != null);
            Account acc2 = new Account();
            acc2.Name = 'Account B';
            insert acc2;
            System.assert(acc2.Id != null);            
            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.AccountId = acc1.Id;
            insert con1;
            System.assert(con1.Id != null);
            Contact con2 = new Contact();
            con2.FirstName = 'Test';
            con2.LastName = 'User1';
            con2.AccountId = acc1.Id;
            insert con2;
            System.assert(con2.Id != null);
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con1.Id;
            acr.IsActive = true;
            acr.Roles = 'Property Manager';
            insert acr;
            System.assert(acr.Id != null);
            User usr1 = new User();
            usr1.FirstName = 'Test';
            usr1.LastName = 'User1';
            usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;    
            usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr1.Email = 'test.user1@yopmail.com.ps360.test';
            usr1.LanguageLocaleKey = 'en_US';
            usr1.EmailEncodingKey = 'UTF-8';
            usr1.LocaleSidKey = 'en_US';
            usr1.TimeZoneSidKey = 'America/Los_Angeles';
            usr1.Alias = 'Alias1';
            usr1.Title = 'Title1';
            usr1.ContactId = con1.Id;
            insert usr1;
            System.assert(usr1.Id != null);   
            User usr2 = new User();
            usr2.FirstName = 'Test';
            usr2.LastName = 'User2';
            usr2.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;    
            usr2.Username = 'Test.User2@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr2.Email = 'test.user2@yopmail.com.ps360.test';
            usr2.LanguageLocaleKey = 'en_US';
            usr2.EmailEncodingKey = 'UTF-8';
            usr2.LocaleSidKey = 'en_US';
            usr2.TimeZoneSidKey = 'America/Los_Angeles';
            usr2.Alias = 'Alias2';
            usr2.Title = 'Title2';
            usr2.ContactId = con2.Id;
            insert usr2;
            System.assert(usr2.Id != null);   
            acc1.ParentId=acc2.ID;
            acc1.Property_Office_Agent__c = usr1.Id;
            update acc1;
            acc1.Property_Office_Agent__c = usr2.Id;
            acc1.API_Agent_2_External_ID__c='testapi';
            update acc1;
        }
    }
    @isTest
    public static void assignAgentAccountContactRelation() {
        Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        System.runAs(adminUsr){
            Account acc1 = new Account();
            acc1.Name = 'Account A';
            insert acc1;
            System.assert(acc1.Id != null);
            Account acc2 = new Account();
            acc2.Name = 'Account B';
            insert acc2;
            System.assert(acc2.Id != null);
            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.AccountId = acc1.Id;
            insert con1;
            List<AccountContactRelation> acrs=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation  ];
            List<Contact> testacrs=new List<Contact>();
            for(AccountContactRelation tacr : acrs){
                System.debug('extid'+tacr.External_ID__c+'detail'+tacr.contactId);
                tacr.IsActive = true;
                tacr.roles='Property Manager';
                if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
            }
            update acrs;
            System.assert(con1.Id != null);
            Id sfrcdId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
            acc2.RecordTypeId=sfrcdId;
            update acc2;
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con1.Id;
            acr.IsActive = true;
            acr.Roles = 'Property Manager';
            acr.External_ID__c='test';
            insert acr;
            System.assert(acr.Id != null);
            Contact con2 = new Contact();
            con2.FirstName = 'Test';
            con2.LastName = 'Usertest';
            con2.External_ID__c='testapi';
            con2.AccountId = acc1.Id;
            insert con2;
            List<AccountContactRelation> acrslst=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation where ContactId=:con2.ID ];
            for(AccountContactRelation tacr : acrslst){
                tacr.External_ID__c='testexternalid';
                System.debug('extid'+tacr.External_ID__c+'detail'+tacr.contactId);
                tacr.IsActive = true;
                tacr.roles='Property Management';
                if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
            }
            update acrslst;
            User usr1 = new User();
            usr1.FirstName = 'Test';
            usr1.LastName = 'User1';
            usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;  
            usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr1.Email = 'test.user1@yopmail.com.ps360.test';
            usr1.LanguageLocaleKey = 'en_US';
            usr1.EmailEncodingKey = 'UTF-8';
            usr1.LocaleSidKey = 'en_US';
            usr1.TimeZoneSidKey = 'America/Los_Angeles';
            usr1.Alias = 'Alias1';
            usr1.Title = 'Title1';
            usr1.ContactId = con1.Id;
            insert usr1;
            System.assert(usr1.Id != null);   
            acc1.ParentId=acc2.ID;
            acc1.RecordTypeId=sfrcdId;
            acc1.Property_Office_Agent__c = usr1.Id;
            acc1.External_ID__c='testexternalid';
            update acc1;
            acc2.API_Agent_1_External_ID__c='testapi';
            update acc2;  
            acc1.API_Agent_1_External_ID__c='testapi';
            acc1.API_Agent_2_External_ID__c='testexternalapi';
            update acc1;
            
            
            Test.startTest();
            Database.executeBatch( new BatchUpdateAgentAcountContactRelation(),200);
            Test.stopTest();
        }
    }
    
    
    /*
@isTest
public static void assignAgentAccountContactRelations() {
Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
update adminUsr;
System.runAs(adminUsr){
Account acc1 = new Account();
acc1.Name = 'Account A';
insert acc1;
System.assert(acc1.Id != null);
Account acc2 = new Account();
acc2.Name = 'Account B';
insert acc2;
System.assert(acc2.Id != null);
Contact con1 = new Contact();
con1.FirstName = 'Test';
con1.LastName = 'User1';
con1.AccountId = acc1.Id;
insert con1;
List<AccountContactRelation> acrs=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation  ];
List<Contact> testacrs=new List<Contact>();
for(AccountContactRelation tacr : acrs){
tacr.IsActive = true;
tacr.roles='Property Manager';
if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
}
update acrs;
System.assert(con1.Id != null);
Id sfrcdId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
acc2.RecordTypeId=sfrcdId;
update acc2;
AccountContactRelation acr = new AccountContactRelation();
acr.AccountId = acc2.Id;
acr.ContactId = con1.Id;
acr.IsActive = true;
acr.Roles = 'Property Manager';
acr.External_ID__c='test';
insert acr;
System.assert(acr.Id != null);
User usr1 = new User();
usr1.FirstName = 'Test';
usr1.LastName = 'User1';
usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;  
usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
usr1.Email = 'test.user1@yopmail.com.ps360.test';
usr1.LanguageLocaleKey = 'en_US';
usr1.EmailEncodingKey = 'UTF-8';
usr1.LocaleSidKey = 'en_US';
usr1.TimeZoneSidKey = 'America/Los_Angeles';
usr1.Alias = 'Alias1';
usr1.Title = 'Title1';
usr1.ContactId = con1.Id;
insert usr1;
System.assert(usr1.Id != null);   
acc1.ParentId=acc2.ID;
acc1.RecordTypeId=sfrcdId;
acc1.Property_Office_Agent__c = usr1.Id;
acc1.External_ID__c='testexternalid';
update acc1;
acc2.API_Agent_1_External_ID__c='testapi';
update acc2;  
acc1.API_Agent_1_External_ID__c='testapi';
acc1.API_Agent_2_External_ID__c='testexternalapi';
update acc1; 
Test.startTest();
Database.executeBatch( new BatchUpdateAgentAcountContactRelation(),200);
Test.stopTest();
}
}
@isTest
public static void assignAgentAccountContactRelation1() {
Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
update adminUsr;
System.runAs(adminUsr){
Account acc1 = new Account();
acc1.Name = 'Account A';
insert acc1;
System.assert(acc1.Id != null);
Account acc2 = new Account();
acc2.Name = 'Account B';
insert acc2;
System.assert(acc2.Id != null);
Contact con1 = new Contact();
con1.FirstName = 'Test';
con1.LastName = 'User1';
con1.AccountId = acc1.Id;
insert con1;
List<AccountContactRelation> acrs=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation ];
List<Contact> testacrs=new List<Contact>();
for(AccountContactRelation tacr : acrs){
tacr.External_ID__c='testexternalid';
tacr.IsActive = true;
tacr.roles='Property Manager';
if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
}
update acrs;
System.assert(con1.Id != null);
Id sfrcdId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
acc2.RecordTypeId=sfrcdId;
update acc2;
AccountContactRelation acr = new AccountContactRelation();
acr.AccountId = acc2.Id;
acr.ContactId = con1.Id;
acr.IsActive = true;
acr.Roles = 'Property Manager';
acr.External_ID__c='test';
insert acr;
System.assert(acr.Id != null);
User usr1 = new User();
usr1.FirstName = 'Test';
usr1.LastName = 'User1';
usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;  
usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
usr1.Email = 'test.user1@yopmail.com.ps360.test';
usr1.LanguageLocaleKey = 'en_US';
usr1.EmailEncodingKey = 'UTF-8';
usr1.LocaleSidKey = 'en_US';
usr1.TimeZoneSidKey = 'America/Los_Angeles';
usr1.Alias = 'Alias1';
usr1.Title = 'Title1';
usr1.ContactId = con1.Id;
insert usr1;
System.assert(usr1.Id != null);   
acc1.ParentId=acc2.ID;
acc1.RecordTypeId=sfrcdId;
acc1.Property_Office_Agent__c = usr1.Id;
acc1.External_ID__c='testexternalid';
update acc1;
acc2.API_Agent_1_External_ID__c='testapi';
update acc2;  
acc1.API_Agent_1_External_ID__c='testapi';
acc1.API_Agent_2_External_ID__c='testexternalapi';
update acc1;
Test.startTest();
Database.executeBatch( new BatchUpdateAgentAcountContactRelation(),200);
Test.stopTest();
}
}

@isTest
public static void testAgentAcountContactRelationSchedulable() {
Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
update adminUsr;
System.runAs(adminUsr){
Account acc1 = new Account();
acc1.Name = 'Account A';
insert acc1;
System.assert(acc1.Id != null);
Account acc2 = new Account();
acc2.Name = 'Account B';
insert acc2;
System.assert(acc2.Id != null);
Contact con1 = new Contact();
con1.FirstName = 'Test';
con1.LastName = 'User1';
con1.AccountId = acc1.Id;
insert con1;
List<AccountContactRelation> acrs=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation ];
List<Contact> testacrs=new List<Contact>();
for(AccountContactRelation tacr : acrs){
tacr.External_ID__c='testexternalid';
tacr.IsActive = true;
tacr.roles='Property Manager';
if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
}
update acrs;
System.assert(con1.Id != null);
Id sfrcdId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
acc2.RecordTypeId=sfrcdId;
update acc2;
AccountContactRelation acr = new AccountContactRelation();
acr.AccountId = acc2.Id;
acr.ContactId = con1.Id;
acr.IsActive = true;
acr.Roles = 'Property Manager';
acr.External_ID__c='test';
insert acr;
System.assert(acr.Id != null);
User usr1 = new User();
usr1.FirstName = 'Test';
usr1.LastName = 'User1';
usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;  
usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
usr1.Email = 'test.user1@yopmail.com.ps360.test';
usr1.LanguageLocaleKey = 'en_US';
usr1.EmailEncodingKey = 'UTF-8';
usr1.LocaleSidKey = 'en_US';
usr1.TimeZoneSidKey = 'America/Los_Angeles';
usr1.Alias = 'Alias1';
usr1.Title = 'Title1';
usr1.ContactId = con1.Id;
insert usr1;
System.assert(usr1.Id != null);   
acc1.ParentId=acc2.ID;
acc1.RecordTypeId=sfrcdId;
acc1.Property_Office_Agent__c = usr1.Id;
acc1.External_ID__c='testexternalid';
update acc1;
acc2.API_Agent_1_External_ID__c='testapi';
update acc2;  
acc1.API_Agent_1_External_ID__c='testapi';
acc1.API_Agent_2_External_ID__c='testexternalapi';
update acc1;
Test.startTest();
System.schedule('Scheduled Job 1', '0 0 * * * ?', new AgentAcountContactRelationSchedulable());
Test.stopTest();

}
}


@isTest
public static void assignAgentAccountContactRelationError() {
Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsertError());
User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
update adminUsr;
System.runAs(adminUsr){
Account acc1 = new Account();
acc1.Name = 'Account A';
insert acc1;
System.assert(acc1.Id != null);
Account acc2 = new Account();
acc2.Name = 'Account B';
insert acc2;
System.assert(acc2.Id != null);
Id sfrcdId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
acc2.RecordTypeId=sfrcdId;
update acc2;
acc1.ParentId=acc2.ID;
acc1.RecordTypeId=sfrcdId;
acc1.External_ID__c='testexternalid';
update acc1;
acc2.API_Agent_1_External_ID__c='testapi';
update acc2;  
acc1.API_Agent_1_External_ID__c='testapi';
acc1.API_Agent_2_External_ID__c='testexternalapi';
update acc1;
Test.startTest();
Database.executeBatch( new BatchUpdateAgentAcountContactRelation(),200);
Test.stopTest();
}
}*/
    public class  TestAgentsDataUpsert implements HttpCalloutMock {
        public  HTTPResponse respond(HTTPRequest req) {       
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"first_name": "teststring","last_name":"teststring","id": "testexternalid","roles": [{"name": "Property Manager","property_management_contact": true }]},{"first_name":"testusr1","last_name":"lname","id":"18f335b7-50b5-452e-a4b2-f9740ee3708d","roles":[{"name":"Principal","property_management_contact":false},{"name":"Head, Property Management","property_management_contact":false}]}, {}]');
            res.setStatusCode(200);
            return res;
        }
    } 
    public class  TestAgentsDataUpsertError implements HttpCalloutMock {
        public  HTTPResponse respond(HTTPRequest req) {       
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('["first_name": "teststring","last_name":"teststring","id": "testexternalid","roles": [{"name": "Property Management","property_management_contact": true }]]');
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest
    public static void accountcomplaince(){
        test.startTest();
        Account acc = [select id,RecordType.Developername from account where name='paccount' limit 1];
        System.debug('rec'+acc.RecordType.Developername);
        
        acc.Invoice_Recipient_Preferences__c='Agency Address Only';
        acc.Invoicing_Email__c='upinv@test.comwff';
        acc.Document_Receipt_Preferences__c='Agency Address Only';
        acc.Compliance_Cert_Email__c='upcomp@test.com';
        acc.Property_Office_Agent__c=[select id from user where LastName = 'User2' limit 1].id;
        update acc;
        acc.Invoice_Recipient_Preferences__c='Property Manager Only';
        acc.Invoicing_Email__c='up1inv@test.comsdf';
        acc.Document_Receipt_Preferences__c='Property Manager Only';
        acc.Compliance_Cert_Email__c='up1comp@test.comiuyt';
        //acc.RecordTypeId=rcId;
       // update acc;
        Account acct = [select id,name,RecordType.Developername,Property_Source__c,Property_Office_Agent__c from account where name='tpaccount' limit 1];
        WorkOrder wo = new WorkOrder();
        wo.accountid=acct.Id;
        insert wo;
        Order od = new Order();
        od.AccountId=acct.id;
        od.Status='Draft';
        od.EffectiveDate=system.today();
        insert od;
        
        acct.address_line_1__c = 'tbakingum street';
        acct.address_line_2__c='tstreetox' ;
        acct.address_street_number__c='210';
        acct.address_unit__c ='11';
        acct.address_suburb__c ='txyz';
        acct.address_state__c ='tcelsea';
        acct.address_country__c='tUSA';
        acct.address_post_code__c='91456387';
        acct.Property_Office_Agent__c=[select id from user where LastName = 'User2' limit 1].id;       
        update acct;
        ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Document2';
            cv.PathOnClient = 'TestDocument2.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
            Insert cv;
                
                Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
            
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = od.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.Visibility = 'AllUsers';
            Insert cdl;
        
        
        Bread_Winner__Invoice__c inv = new Bread_Winner__Invoice__c();
        //inv.Name='28842';
        inv.Order_Lookup__c=od.Id;
        insert inv;
        
        test.stopTest();
    }   
    @isTest
    public static void PoweruserSharing(){
        
        
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        
        System.runAs(adminUsr){
            
            
            Id prcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
            account pacc= new account();
            pacc.Name='Agencyaccount';
            pacc.RecordTypeId=prcId;
            insert pacc;
            
            
            
            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.AccountId = pacc.Id;
            insert con1;
            System.assert(con1.Id != null);
            
            User usr1 = new User();
            usr1.FirstName = 'Test';
            usr1.LastName = 'User1';
            usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;    
            usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr1.Email = 'test.user1@yopmail.com.ps360.test';
            usr1.LanguageLocaleKey = 'en_US';
            usr1.EmailEncodingKey = 'UTF-8';
            usr1.LocaleSidKey = 'en_US';
            usr1.TimeZoneSidKey = 'America/Los_Angeles';
            usr1.Alias = 'Alias1';
            usr1.Title = 'Title1';
            usr1.ContactId = con1.Id;
            insert usr1;
            System.assert(usr1.Id != null);
            
            account pacc2= new account();
            pacc2.Name='Agencyaccount2';
            pacc2.RecordTypeId=prcId;
            pacc2.Power_User__c=usr1.id; 
            insert pacc2;
            
            Contact con2 = new Contact();
            con2.FirstName = 'Test2';
            con2.LastName = 'User2';
            con2.AccountId = pacc2.Id;
            insert con2;
            System.assert(con1.Id != null);
            
            User usr = new User();
            usr.FirstName = 'Test2';
            usr.LastName = 'User';
            usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;    
            usr.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr.Email = 'test.user1@yopmail.com';
            usr.LanguageLocaleKey = 'en_US';
            usr.EmailEncodingKey = 'UTF-8';
            usr.LocaleSidKey = 'en_US';
            usr.TimeZoneSidKey = 'America/Los_Angeles';
            usr.Alias = 'Alias';
            usr.Title = 'Title';
            usr.ContactId = con2.Id;
            insert usr;
            Id CrcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
            account chacc2= new account();
            chacc2.Name='property';
            chacc2.ParentId=pacc.id;
            chacc2.RecordTypeId=CrcId;
            insert chacc2;
            
           
            //Id prcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
             pacc.Power_User__c=usr1.id;
            update pacc;   
            pacc2.Power_User__c=usr.id; 
            update pacc2;
              pacc2.Power_User__c=usr1.id; 
            update pacc2;
           
            
            account chacc= new account();
            chacc.Name='property';
            chacc.ParentId=pacc2.id;
            chacc.RecordTypeId=CrcId;
            insert chacc;
            
            
            chacc.ParentId=pacc.Id;
            update chacc;
            
            WorkOrder pwo = new WorkOrder();
            pwo.accountid=pacc2.Id;
            insert pwo;
            
            WorkOrder wo = new WorkOrder();
            wo.accountid=chacc.Id;
            insert wo;
             pacc.Power_User__c=usr.id;
            update pacc;   
            pacc2.Power_User__c=usr1.id; 
            update pacc2;
              pacc2.Power_User__c=usr.id; 
            update pacc2;
            Order od = new Order();
            od.AccountId=pacc2.id;
            od.Status='Draft';
            od.EffectiveDate=system.today();
            insert od; 
            
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Document';
            cv.PathOnClient = 'TestDocument.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
            Insert cv;
                
                Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
            
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = od.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.Visibility = 'AllUsers';
            Insert cdl;
            
            Bread_Winner__Invoice__c poinv = new Bread_Winner__Invoice__c();
            poinv.Bread_Winner__Account__c=pacc2.id;
            insert poinv; 
            
        }
    }
    
    @isTest
    public static void ACRforcreateandupdatetest(){
        
        Id prcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
        account pacc= new account();
        pacc.Name='Agencyaccount';
        pacc.RecordTypeId=prcId;
        insert pacc;
        
        Id ConId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        Contact con2= new Contact();
        con2.lastname='testcont2';
        con2.RecordTypeId=ConId;
        con2.External_ID__c='123456';
        con2.AccountId=pacc.id;
        insert con2;
       
        Id CrcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        Account acc = new Account();
        acc.name='acracc';
        acc.ParentId=pacc.id;
        acc.API_Agent_1_External_ID__c='123456';
        acc.External_ID__c='98563214';
        acc.RecordTypeId=CrcId;
        acc.Property_Source__c='Property Me';
       insert acc;
        
        
        Account acc1 = new Account();
        acc1.name='acracc1';
        acc1.External_ID__c='897456';
        acc1.RecordTypeId=CrcId;
        acc1.Property_Source__c='Property Me';
        insert acc1;
        
        
         Id Con3Id=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        Contact con3 = new Contact();
        con3.lastname='testcontch';
        con3.RecordTypeId=Con3Id;
        con3.AccountId=acc.Id;
        con3.External_ID__c='0786';
        insert con3;
        
         Account acc12 = new Account();
        acc12.name='acracc11';
       acc12.External_ID__c='89745632';
        acc12.RecordTypeId=CrcId;
        acc12.API_Agent_1_External_ID__c='123456';
        acc12.Property_Source__c='Property Me';
       insert acc12;
        
        
         Id Con2Id=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        Contact con= new Contact();
        con.lastname='testcont';
        con.RecordTypeId=Con2Id;
        con.accountid=acc.id;
        con.External_ID__c='897456';
        insert con;
        
      acc.API_Agent_1_External_ID__c='897456';
        update acc;
        
        acc.API_Agent_1_External_ID__c='0786';
        update acc;
        
        acc1.API_Agent_1_External_ID__c='0786';
        update acc1;
        
        acc1.API_Agent_1_External_ID__c='897456';
        update acc1;
        
        
        
    }
}
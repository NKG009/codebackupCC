@isTest
public class TestAcountContactRelationSchedulable {
     @testSetup
    static void setup(){
        
 				Manage_Triggers__c cs1 = new Manage_Triggers__c();
			cs1.Name = 'AccountTrigger';
			cs1.isActive__c = true;
			insert cs1;        
    }
    @isTest
    public static void assignAgentAccountContactRelation() {
        Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];    
        Id AgentRecordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
        Id RealStateRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Real Estate Office').getRecordTypeId();
        Id PropertyRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();

        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        System.runAs(adminUsr){
            Account acc1 = new Account();
            acc1.Name = 'Account A';
            acc1.recordtypeID=RealStateRecordTypeId;
             acc1.External_ID__c='testExternalId1';
            insert acc1;
            System.assert(acc1.Id != null);
            Account acc2 = new Account();
            acc2.Name = 'Account B';
            acc2.recordtypeID=PropertyRecordTypeId;
            acc2.External_ID__c='testExternalId1test';
            acc2.ParentId=acc1.Id;
            insert acc2;
            System.assert(acc2.Id != null);
            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.recordTypeId=AgentRecordTypeId;
            con1.AccountId = acc1.Id;
            con1.External_ID__c='testexternalId';
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
//            acc2.RecordTypeId=sfrcdId;
  //          update acc2;
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
           // acc1.ParentId=acc2.ID;
            acc1.Property_Office_Agent__c = usr1.Id;
            acc1.External_ID__c='testexternalid';
            update acc1;
            acc2.API_Agent_1_External_ID__c='testapi';
            acc2.API_Agent_2_External_ID__c='testexternalapi';
            update acc2;
            //System.assertEquals([Select Id,External_ID__c,ParentID from Account   where Id=:acc2.Id], null);
            Test.startTest();
           // Database.executeBatch(new BatchUpdateAgentAcountContactRelation(),200);
            //Database.executeBatch(new BatchUpdateAgentAcountContactRelation());
            System.schedule('Scheduled Job 1', '0 0 * * * ?', new AgentAcountContactRelationSchedulable());
		  Test.stopTest();
        }
    }
    @isTest
    public static void assignAgentAccountContactRelations() {
    
            Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];    
        Id AgentRecordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
        Id RealStateRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Real Estate Office').getRecordTypeId();
        Id PropertyRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();

        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        System.runAs(adminUsr){
            Account acc1 = new Account();
            acc1.Name = 'Account A';
            acc1.recordtypeID=RealStateRecordTypeId;
             acc1.External_ID__c='testExternalId1';
            insert acc1;
            System.assert(acc1.Id != null);
            Account acc2 = new Account();
            acc2.Name = 'Account B';
            acc2.recordtypeID=PropertyRecordTypeId;
            acc2.External_ID__c='testExternalId1test';
            acc2.ParentId=acc1.Id;
            insert acc2;
            System.assert(acc2.Id != null);
            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.recordTypeId=AgentRecordTypeId;
            con1.AccountId = acc1.Id;
            con1.External_ID__c='18f335b7-50b5-452e-a4b2-f9740ee3708d';
            insert con1;
                List<AccountContactRelation> acrs=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation  ];
            List<Contact> testacrs=new List<Contact>();
            for(AccountContactRelation tacr : acrs){
                System.debug('extid'+tacr.External_ID__c+'detail'+tacr.contactId);
                tacr.IsActive = true;
                tacr.roles='Property Management';
                if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
            }
            update acrs;
            System.assert(con1.Id != null);
//            acc2.RecordTypeId=sfrcdId;
  //          update acc2;
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con1.Id;
            acr.IsActive = true;
            acr.Roles = 'Property Management';
            acr.External_ID__c='test';
            insert acr;
            System.assert(acr.Id != null);
              Contact con2 = new Contact();
			  con2.FirstName = 'Test';
			  con2.LastName = 'Usertest';
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
           // acc1.ParentId=acc2.ID;
            acc1.Property_Office_Agent__c = usr1.Id;
            acc1.External_ID__c='testexternalid';
            update acc1;
            acc2.API_Agent_1_External_ID__c='testapi';
            acc2.API_Agent_2_External_ID__c='testexternalapi';
            update acc2;
            //System.assertEquals([Select Id,External_ID__c,ParentID from Account   where Id=:acc2.Id], null);
            Test.startTest();
           // Database.executeBatch(new BatchUpdateAgentAcountContactRelation(),200);
            //Database.executeBatch(new BatchUpdateAgentAcountContactRelation());
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
            System.schedule('Scheduled Job 1', '0 0 * * * ?', new AgentAcountContactRelationSchedulable());
		  Test.stopTest();
        }
    }
    public class  TestAgentsDataUpsert implements HttpCalloutMock {
        public  HTTPResponse respond(HTTPRequest req) {       
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"first_name": "teststring","last_name":"teststring","id": "testexternalId","roles": [{"name": "Property Manager","property_management_contact": true }]},{"first_name":"testusr1","last_name":"lname","id":"18f335b7-50b5-452e-a4b2-f9740ee3708d","roles":[{"name":"Principal","property_management_contact":false},{"name":"Head, Property Management","property_management_contact":false}]}, {}]');
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
}
@isTest
public with sharing class InvoiceTrigger_TEST {
     @testSetup
    static void setup(){
        
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = false;
        insert cs1;
    }

    @isTest
    public static void shareInvoices(){  
        
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        
        System.runAs(adminUsr){
            
             Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
         	account acc= new account();
        	acc.name='paccount';
            acc.RecordTypeId=rcId;
            insert acc;

            Account acc1 = new Account();
            acc1.Name = 'Account A';
            acc1.ParentId=acc.id;
            insert acc1;
            System.assert(acc1.Id != null);

            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.AccountId = acc1.Id;
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

            acc1.Property_Office_Agent__c = usr1.Id;
            update acc1;
            
             acc.Power_User__c = usr1.Id;
            update acc;

            Order ord = new Order();
            ord.AccountId = acc1.Id;
            ord.EffectiveDate = System.today();
            ord.Status = 'Draft';
            insert ord;
            System.assert(ord.Id != null);   
            
             ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Document';
            cv.PathOnClient = 'TestDocument.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
            Insert cv;
                
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
            
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = ord.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.Visibility = 'AllUsers';
            Insert cdl;
            system.debug('cdl.id'+cdl.id);
            
            id cdid=[SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where id=:cdl.id].ContentDocumentId;
            
            Bread_Winner__Invoice__c inv = new Bread_Winner__Invoice__c();
            inv.Order_Lookup__c = ord.Id;
            insert inv;
            
            Bread_Winner__Invoice__c inv1 = new Bread_Winner__Invoice__c();
            inv1.Bread_Winner__Account__c = acc.Id;
            insert inv1;
            
          /*  ContentDocumentLink cd = New ContentDocumentLink();
            cd.LinkedEntityId = inv.Id;
            cd.ContentDocumentId = cdid;
            cd.Visibility = 'AllUsers';
            Insert cd;
            System.assert(inv.Id != null);              
            */
            update inv;

        }




        
    }

}
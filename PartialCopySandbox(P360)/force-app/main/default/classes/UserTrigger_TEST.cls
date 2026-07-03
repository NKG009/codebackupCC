@isTest
public with sharing class UserTrigger_TEST {

    @isTest
    public static void assignAccounts(){

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
            
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'User1';
            con.AccountId = acc1.Id;
            insert con;
            System.assert(con.Id != null);

            WorkOrder wor = new WorkOrder();
            wor.AccountId = acc2.Id;
            insert wor;
            System.assert(wor.Id != null);

            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con.Id;
            acr.IsActive = true;
            acr.Roles = 'Property Manager';
            insert acr;
            System.assert(acr.Id != null);
            
            

            User usr = new User();
            usr.FirstName = 'Test';
            usr.LastName = 'User1';
            usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;    
            usr.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr.Email = 'test.user@yopmail.com.ps360.test';
            usr.LanguageLocaleKey = 'en_US';
            usr.EmailEncodingKey = 'UTF-8';
            usr.LocaleSidKey = 'en_US';
            usr.TimeZoneSidKey = 'America/Los_Angeles';
            usr.Alias = 'Alias';
            usr.Title = 'title';
            usr.ContactId = [SELECT ID FROM Contact LIMIT 1].Id;
            //usr.UserRoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'DiJONESPittwaterCustomerManager' LIMIT 1].Id;
            insert usr;
            System.assert(usr.Id != null);   

        }

/*        
        User currentUsr = new User(Id=UserInfo.getUserId());
        currentUsr.UserRoleId =  [SELECT Id FROM UserRole WHERE DeveloperName = 'DiJONESPittwaterCustomerManager' LIMIT 1].Id;
        update currentUsr;

        System.runAs(currentUsr) {

            Account acc = new Account();
            acc.Name = 'Account';
            insert acc;
            System.assert(acc.Id != null);

            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'User1';
            con.AccountId = acc.Id;
            insert con;
            System.assert(con.Id != null);            

     

            
        }

*/

    }

}
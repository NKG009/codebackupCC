@isTest
public without sharing class PortfolioViewerController_TEST {

    @isTest
    public static void assignAccounts(){    

        PortfolioWrapper myPortfolio1 = new PortfolioWrapper();        
        PortfolioWrapper myPortfolio2 = new PortfolioWrapper('Name', 1, 10);


        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        
        System.runAs(adminUsr){
            
            Account acc1 = new Account();
            acc1.Name = 'Account 1';
            insert acc1;
            System.assert(acc1.Id != null);
    
            Account acc2 = new Account();
            acc2.Name = 'Account 2';
            insert acc2;
            System.assert(acc2.Id != null);            
    
            Contact con = new Contact();
            con.FirstName = 'Contact';
            con.LastName = 'User1';
            con.AccountId = acc1.Id;
            insert con;
            System.assert(con.Id != null);
    
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
            insert usr;
            System.assert(usr.Id != null);   
    
            PortfolioViewerController.getMyPortfolio(null, usr.Id);

        }

    }

    @isTest
    public static void getAccountContactRelationshipsByContactAccountId(){

        Account acc1 = new Account();
        acc1.Name = 'Account 1';
        insert acc1;
        System.assert(acc1.Id != null);

        Account acc2 = new Account();
        acc2.Name = 'Account 2';
        insert acc2;
        System.assert(acc2.Id != null);            

        Contact con = new Contact();
        con.FirstName = 'Contact';
        con.LastName = 'User1';
        con.AccountId = acc1.Id;
        insert con;
        System.assert(con.Id != null);

        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = acc2.Id;
        acr.ContactId = con.Id;
        acr.IsActive = true;
        acr.Roles = 'Property Manager';
        insert acr;
        System.assert(acr.Id != null);

        List<AccountContactRelation> acrList = PortfolioViewerController.getAccountContactRelationshipsByContactAccountId(new Set<Id>{acc1.Id}, 'Property Manager');
        System.assert(acrList.size() == 1);

    }

}
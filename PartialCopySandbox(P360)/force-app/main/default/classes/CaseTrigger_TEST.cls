@isTest
public with sharing class CaseTrigger_TEST {

    @isTest
    public static void validateContacts() {

        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];        
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        
        System.runAs(adminUsr){

            Account accA = new Account();
            accA.Name = 'Account A';
            insert accA;
            System.assert(accA.Id != null);

            Account accB = new Account();
            accB.Name = 'Account B';
            accB.ParentId = accA.Id;
            insert accB;
            System.assert(accB.Id != null);
            
            Account accC = new Account();
            accC.Name = 'Account C';
            accC.ParentId = accB.Id;
            insert accC;
            System.assert(accC.Id != null);
            
            Account accD = new Account();
            accD.Name = 'Account D';
            accD.ParentId = accC.Id;
            insert accD;
            System.assert(accD.Id != null);

            Account accE = new Account();
            accE.Name = 'Account E';
            accE.ParentId = accD.Id;
            insert accE;
            System.assert(accE.Id != null);




            Account acc3 = new Account();
            acc3.Name = 'Account C';
            insert acc3;
            System.assert(acc3.Id != null);       


            Account acc2 = new Account();
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
            acc2.ParentId = accE.Id;
            acc2.Name = 'Property A';
            insert acc2;
            System.assert(acc2.Id != null);     
            
            

/*            
            Contact con1 = new Contact();        
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.AccountId = acc1.Id;
            insert con1;
            System.assert(con1.Id != null);
*/
            Contact con2 = new Contact();
            con2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
            con2.FirstName = 'Property';
            con2.LastName = 'Agent1';
            con2.AccountId = acc3.Id;
            insert con2;
            System.assert(con2.Id != null);

/*            
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con1.Id;
            acr.IsActive = true;
            acr.Roles = 'Property Manager';
            insert acr;
            System.assert(acr.Id != null);
*/            
/*                    
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
*/
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

            
            Case cas = new Case();
            cas.ContactId = con2.Id;
            cas.AccountId = acc2.Id;
            try{
                insert cas;
            }catch(Exception e){
                //System.assert(e.getMessage().contains('does not belongs to the same real estate of the property that you are trying to add') == true);
            }

            Case cas2 = new Case();
            insert cas2;             
            cas2.AccountId = acc2.Id;
            try{
                update cas2;
            }catch(Exception e){
                //System.assert(e.getMessage().contains('does not belongs to the same real estate of the property that you are trying to add') == true);
            }
        }
        
    }

}
@isTest
public class OrderTrigger_Test {
    
      @testSetup
    static void setup(){
        
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = false;
        insert cs1;
         Manage_Triggers__c cs2 = new Manage_Triggers__c();
        cs2.Name = 'OrderTrigger';
        cs2.isActive__c = true;
        insert cs2;
        
    }

     @isTest
    public static void testOrderupdate(){
        
         Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
         	account acc= new account();
        	acc.name='paccount';
            acc.RecordTypeId=rcId;
            insert acc;
        
         Account acc1 = new Account();
            acc1.Name = 'Account A';
        	acc1.ParentId=acc.Id;
            acc1.Prop_Invoice_Recipent_Email__c='test@testing.com';
        	acc1.Prop_Invoice_Recipient_Email_2__c='test2@test.com';
            insert acc1;
            System.assert(acc1.Id != null);
         Account acc2 = new Account();
            acc2.Name = 'Account B';
            acc2.ParentId=acc.Id;
        	acc2.Prop_Invoice_Recipent_Email__c='test@testing.com';
        	acc2.Prop_Invoice_Recipient_Email_2__c='test2@test.com';
            insert acc2;
            System.assert(acc2.Id != null);            
            
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'User1';
        	con.Email='test@testing.com';
            con.AccountId = acc1.Id;
            insert con;
            System.assert(con.Id != null);
        
           Contact co = new Contact();
         co.FirstName='test1';
        co.LastName='tu';
        co.Email='test2@test.com';
        insert co;
        
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
            usr1.ContactId = con.Id;
            insert usr1;
            System.assert(usr1.Id != null);  
        
            acc.Power_User__c = usr1.Id;
            update acc;

         
        
        //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
        ID standardPBID = Test.getStandardPricebookId();
        Product2 p = new Product2();
        p.Name='testp';
        insert p;
        
        Pricebook2 p2 = new Pricebook2();
        p2.Name='testpricwe';
        p2.IsActive=true;
        insert p2;
        
          PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBID, Product2Id = p.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        PricebookEntry pent =new PricebookEntry();
        pent.Pricebook2Id=p2.id;
        pent.Product2Id=p.Id;
        pent.UnitPrice=1;
        pent.UseStandardPrice=false;
        pent.IsActive=true;
        insert pent;
        
        Id opprcId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Renewal').getRecordTypeId();
 
        opportunity opp = new opportunity();
        opp.RecordTypeId=opprcId;
        opp.StageName='Cold';
        opp.CloseDate=system.today();  
        opp.AccountId=acc1.id;
        opp.Name='testopp';
        insert opp;
        
         order od = new order();
        od.AccountId=acc1.Id;
        od.EffectiveDate=system.today();
        od.Status='Draft';
        od.Pricebook2Id=p2.Id;
        od.OpportunityId=opp.Id;
        insert od;
        
        OrderItem oi = new OrderItem();
        oi.OrderId=od.id;
        oi.Product2Id=p.id;
        oi.Quantity=1;
        oi.ListPrice=1;
        oi.UnitPrice=1;
        oi.PricebookEntryId=pent.id;
        insert oi;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = od.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        
        od.Status='Send Invoice';
        update od;
        
          od.Validation_Error__c=true;
        update od;
        od.Validation_Error__c=False;
        update od;
        
    }
    
}
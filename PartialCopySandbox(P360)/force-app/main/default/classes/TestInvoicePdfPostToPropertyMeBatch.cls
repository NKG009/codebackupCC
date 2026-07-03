/*
********************************************************************************************************
Apex Class Name    : TestInvoicePdfPostToPropertyMeBatch
Created Date       : May 29, 2023
@description       : This is test class for InvoicePdfPostToPropertyMeBatch 
@author            : Nikhil Gaurav
Modification Log:
Ver   Date         Author                     Modification
1.0   29-05-2023   Nikhil Gaurav            Initial Version
*******************************************************************************************************
*/
@IsTest
public class TestInvoicePdfPostToPropertyMeBatch {
    
    @testSetup
    static void setup(){
          Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = false;
        insert cs1;
         Manage_Triggers__c cs2 = new Manage_Triggers__c();
        cs2.Name = 'OrderTrigger';
        cs2.isActive__c = false;
        insert cs2;
        
          Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
         	account acc= new account();
        	acc.name='paccount';
            acc.RecordTypeId=rcId;
            insert acc;
        
                Id rcIdp=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();

         Account acc1 = new Account();
            acc1.Name = 'Account A';
        acc.RecordTypeId=rcIdp;
        	acc1.ParentId=acc.Id;
            acc1.External_ID__c='aed2016c-3aaa-4ff6-907b-06fc1ba4efb';
            acc1.API_Ownership_External_ID__c='aed2016d-6b67-41c8-aca6-002162b7ab11';
            insert acc1;    
            
                   
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
        od.Invoice_Due_Date__c=system.today();
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
        
        OrderId_For_PropertyMeBills__c opmb =new OrderId_For_PropertyMeBills__c();
        opmb.Name=od.id;
        opmb.AccountParentID__c=acc.id;
        insert opmb;
        
       
        
        Agency_Integration_Info__c ai = new Agency_Integration_Info__c();
        ai.Agency_Account__c=acc.Id;
        ai.Access_Token__c='xyz';
        ai.Client_ID__c='xyaa';
        ai.Client_Secret__c='xyaa';
        ai.Refresh_Token__c='xyaa';
        ai.Turn_On_Bills_Post__c=true;
        ai.FromFolioID__c='ae2e04da-c748-490b-9187-d70ee4965ee2';
        ai.Chart_Account_ID__c='ae2e04da-c6dc-4c5f-8a78-3749ec615a5a';
        insert ai;

       
    }
    
      static testMethod void myTestMethod() {        
        test.starttest();
        Account acc = [select id,RecordType.Developername from account where name='paccount' limit 1];
        InvoicePdfPostToPropertyMeSchedular myClass = new InvoicePdfPostToPropertyMeSchedular (); 
      
			//System.abort(batchJobId);
        Test.setMock(HttpCalloutMock.class, new mockcallout());
               // Test.setMock(HttpCalloutMock.class, new createjobmockcallout());
    
         String chron = '0 0 22 * * ?';        
         system.schedule('Test Sched', chron, myClass);
        test.stopTest();
    }
    
     static testMethod void mytesterrormrthod() {        
        test.starttest();
        Account acc = [select id,RecordType.Developername from account where name='paccount' limit 1];
        InvoicePdfPostToPropertyMeSchedular myClass = new InvoicePdfPostToPropertyMeSchedular (); 
      
			//System.abort(batchJobId);
        Test.setMock(HttpCalloutMock.class, new mockcallouterror());
               // Test.setMock(HttpCalloutMock.class, new createjobmockcallout());
    
         String chron = '0 0 22 * * ?';        
         system.schedule('Test Sched', chron, myClass);
        test.stopTest();
    }
    
     public class mockcallout implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req) {
             HttpResponse res = new HttpResponse(); 
            res.setStatusCode(200);
            res.setHeader('Authorization' , 'Basic ');
            res.setHeader('Content-Type', 'application/json');
             res.setBody('{"TrackingIds":["df0bf106-1ca9-415d-867d-4b2108f02280"],"ResponseStatus":{"ErrorCode":"posted","Message":null,"StackTrace":null,"Errors":null,"Meta":null},"IsSuccessful":true}');            
       		return res;
        }
    
     }
    
    public class mockcallouterror implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req) {
             HttpResponse res = new HttpResponse(); 
            res.setStatusCode(200);
            res.setHeader('Authorization' , 'Basic ');
            res.setHeader('Content-Type', 'application/json');
             res.setBody('{"TrackingIds":["\ndf0bf106-1ca9-415d-867d-4b2108f02280"],"ResponseStatus":{"ErrorCode":"posted","Message":null,"StackTrace":null,"Errors":null,"Meta":null},"IsSuccessful":true}');            
       		return res;
        }
    
     }

}
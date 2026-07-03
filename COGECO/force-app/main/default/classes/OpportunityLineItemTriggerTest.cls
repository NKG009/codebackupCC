@isTest
public class OpportunityLineItemTriggerTest {
    @testSetup
    static void setup() {
        insert new Run_Rules__c(Run_Triggers__c = true);
        insert new System_Values__c(Name = 'Quote Communications Language Default', Value__c = 'French');
        insert new System_Values__c(Name = 'Order Fulfillment Status Default', Value__c = 'Draft');
        insert new System_Values__c(Name = 'Asset Rollup Batch Size', Value__c = '200');
        System_Values__c sv =[select id, Name,Value__c from System_Values__c where Value__c = 'French' limit 1];

        Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId()
        );
        insert accountRecord;
        
        Id priceBookId = Test.getStandardPricebookId();

        Opportunity opportunityRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Pricebook2Id = priceBookId,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        insert opportunityRecord;
        
        Product2 product = new Product2(
            Name = 'TestProduct',
            IsActive = true
        );
        insert product;

        PricebookEntry pricebookEntryRecord = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = product.Id, 
            UnitPrice = 10000, 
            IsActive = true
        );
        insert pricebookEntryRecord;
        
        Quote quoteRecord = new Quote(
            Pricebook2Id = priceBookId,
            Name = 'Quote Test',
            OpportunityId = opportunityRecord.Id,
            Communication_Language__c=sv.Value__c
        );
        insert quoteRecord;

		OpportunityLineItem opportunityLineItemRecord = new OpportunityLineItem(
            vlocity_cmt__OneTimeCharge__c = 10,
            OpportunityId = opportunityRecord.Id,
            Product2Id = product.Id,
            Quantity = 1,
            UnitPrice = 1                        
        );
        insert opportunityLineItemRecord;
QuoteLineItem quoteLineItem = new QuoteLineItem(

            vlocity_cmt__OneTimeCharge__c = 10,
            QuoteId = quoteRecord.Id,
            Quantity = 1,
            UnitPrice = 1, 
            Product2Id = product.Id,
    		vlocity_cmt__Action__c='Disconnect',
            PricebookEntryId = pricebookEntryRecord.Id

        );

        Test.startTest();

        insert quoteLineItem;

        Test.stopTest();

        opportunityRecord.SyncedQuoteId = quoteRecord.Id;
        update opportunityRecord;
    } 
    
    @isTest
    static void processLineItemSyncInsertFromOpportunityLineItemTest() {
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        Opportunity opportunityRecord = [SELECT Id FROM Opportunity LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry LIMIT 1];

        //OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem WHERE Product2Id = :productRecord.Id];
        Id priceBookId = Test.getStandardPricebookId();
        
        Product2 prd1 = new Product2 (); // ----> Create  product
   		prd1.Name='Accomodation';
    	insert prd1;
        
        PricebookEntry pbe1 = new PricebookEntry ();  //------->Create PriceBookEntry
    	pbe1.Product2ID=prd1.id;
   		pbe1.Pricebook2ID=priceBookId;
    	pbe1.UnitPrice=50;
    	pbe1.isActive=true;
    	insert pbe1;
        
         OpportunityLineItem oppli = new OpportunityLineItem(); //---->Create OpportunityLineItem.
        oppli.PricebookEntryId=pricebookEntryRecord.Id;
        oppli.OpportunityId = opportunityRecord.Id;
        oppli.Quantity = 5;
        oppli.TotalPrice = 10.0;
        
       
        /*
		OpportunityLineItem opportunityLineItem = new OpportunityLineItem(
            vlocity_cmt__OneTimeCharge__c = 10,
            OpportunityId = opportunityRecord.Id,
            Product2Id = pbe1.Id,
            PricebookEntryId = pricebookEntryRecord.Id,
            Quantity = 1,
            //UnitPrice = 0.5,
            TotalPrice = 10.0,
            Discount = 10
        );
     
        */
        Test.startTest();
 		insert oppli;
       // insert opportunityLineItem;

        Test.stopTest();
    
        
        QuoteLineItem quoteLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c, OpportunityLineItemId FROM QuoteLineItem WHERE OpportunityLineItemId = :oppli.Id];
        OpportunityLineItem opportunityLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c FROM OpportunityLineItem WHERE Id = :quoteLineItemResult.OpportunityLineItemId];
        
        System.assertEquals(quoteLineItemResult.vlocity_cmt__OneTimeCharge__c, opportunityLineItemResult.vlocity_cmt__OneTimeCharge__c);
    }
    
    @isTest
    static void processLineItemSyncInsertFromQuoteLineItemTest() {
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry LIMIT 1];
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
		
        QuoteLineItem quoteLineItem = new QuoteLineItem(
            vlocity_cmt__OneTimeCharge__c = 10,
            QuoteId = quoteRecord.Id,
            Quantity = 1,
            UnitPrice = 10, 
            Product2Id = productRecord.Id,
            vlocity_cmt__Action__c = 'Disconnect',
            PricebookEntryId = pricebookEntryRecord.Id
        );
        
        Test.startTest();
        
        insert quoteLineItem;
        
        Test.stopTest();
        
        QuoteLineItem quoteLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c, OpportunityLineItemId FROM QuoteLineItem WHERE Id = :quoteLineItem.Id];
        OpportunityLineItem opportunityLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c FROM OpportunityLineItem WHERE Id = :quoteLineItemResult.OpportunityLineItemId];
        
        System.assertEquals(quoteLineItemResult.vlocity_cmt__OneTimeCharge__c, opportunityLineItemResult.vlocity_cmt__OneTimeCharge__c);
    }
    
    @isTest
    static void processLineItemSyncInsertBulkFromQuoteLineItemTest() {
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        PricebookEntry pricebookEntryRecord = [SELECT Id FROM PricebookEntry LIMIT 1];
        //Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        Opportunity opportunityRecord = [SELECT Id FROM Opportunity LIMIT 1];
        Quote quoterecord = new Quote(
			 Name = 'Quote Test',
            OpportunityId = opportunityRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        
        insert quoterecord;
		List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
		List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        
        Integer counter = 0;
        
        while (counter < 200) {
			oppLineItems.add(new OpportunityLineItem(
           PricebookEntryId=pricebookEntryRecord.Id,
       OpportunityId = opportunityRecord.Id,
       Quantity = 5,
       TotalPrice = 10.0
       
        ));
            
            counter++;
        }
		List<Database.SaveResult> oppResults = Database.insert(oppLineItems);
		while (counter < 200) {
        quoteLineItems.add(new QuoteLineItem(
                vlocity_cmt__OneTimeCharge__c = 10,
                QuoteId = quoteRecord.Id,
                Quantity = 1,
                UnitPrice = 10, 
                Product2Id = productRecord.Id,
            vlocity_cmt__Action__c='Disconnect',
                PricebookEntryId = pricebookEntryRecord.Id,
				OpportunityLineItemId = oppResults[counter].getId()
            ));
            
      
            
            counter++;
        }
        Test.startTest();
        
        List<Database.SaveResult> results = Database.insert(quoteLineItems);
        
        Test.stopTest();
        
        //String recordId = results[0].getId();
        
      //  QuoteLineItem quoteLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c, OpportunityLineItemId FROM QuoteLineItem WHERE Id = :recordId];
      //  OpportunityLineItem opportunityLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c FROM OpportunityLineItem WHERE Id = :quoteLineItemResult.OpportunityLineItemId];
        
      //  System.assertEquals(quoteLineItemResult.vlocity_cmt__OneTimeCharge__c, opportunityLineItemResult.vlocity_cmt__OneTimeCharge__c);
    }
    
    @istest
    static void processLineItemSyncUpdateTest() {
        Decimal oneTimeCharge = 10;
        Product2 productRecord = [SELECT Id FROM Product2 LIMIT 1];
        System.debug([SELECT Id FROM Product2]);
        System.debug([SELECT Id, vlocity_cmt__OneTimeCharge__c, Product2Id FROM OpportunityLineItem]);
        OpportunityLineItem opportunityLineItemRecord = [SELECT Id, vlocity_cmt__OneTimeCharge__c, Product2Id FROM OpportunityLineItem WHERE Product2Id = :productRecord.Id];
        opportunityLineItemRecord.vlocity_cmt__OneTimeCharge__c = oneTimeCharge;
        
        Test.startTest();
        
        update opportunityLineItemRecord;
        
        Test.stopTest();
        
        QuoteLineItem quoteLineItemResult = [SELECT Id, vlocity_cmt__OneTimeCharge__c, OpportunityLineItemId FROM QuoteLineItem WHERE OpportunityLineItemId = :opportunityLineItemRecord.Id];
        
        System.assertEquals(oneTimeCharge, quoteLineItemResult.vlocity_cmt__OneTimeCharge__c);
    }
}
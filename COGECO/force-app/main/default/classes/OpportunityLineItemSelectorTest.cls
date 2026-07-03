@isTest
public class OpportunityLineItemSelectorTest {
    
    
@isTest
    public static void getOpportunityLineItem(){
        Account accountRecord = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId()
        );
        
        insert accountRecord;
        
        Opportunity opportuntyRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportuntyRecord;
        
       Id priceBookId = Test.getStandardPricebookId();
        
        Pricebook2 pb=new Pricebook2();
        pb.name='test';
        pb.IsActive=true;
        
        insert pb;
    
    	Product2 prd1 = new Product2 (); // ----> Create  product
   		prd1.Name='Accomodation';
    	insert prd1;
    
    	PricebookEntry pbe1 = new PricebookEntry ();  //------->Create PriceBookEntry
    	pbe1.Product2ID=prd1.id;
   		pbe1.Pricebook2ID=priceBookId;
    	pbe1.UnitPrice=50;
    	pbe1.isActive=true;
    	insert pbe1;
        
       //Id pricebk= [select Id from PricebookEntry where Product2.Name = 'Accomodation' limit 1][0].Id;
        OpportunityLineItem oppli = new OpportunityLineItem(); //---->Create OpportunityLineItem.
        oppli.PricebookEntryId=pbe1.Id;
        oppli.OpportunityId = opportuntyRecord.Id;
        oppli.Quantity = 5;
        oppli.TotalPrice = 10.0;
        
        insert oppli;
        
        
        Set<String> fieldApiNames = new Set<String>{'OpportunityId', 'Quantity','PricebookEntryId'};
        Set<Id> filterIds = new Set<Id>{oppli.Id};
            
            // method call
     List<OpportunityLineItem> selectedOLIs = OpportunityLineItemSelector.getOpportunityLineItemsForSyncByQueryString(fieldApiNames, filterIds);
		System.assertEquals(1, selectedOLIs.size(), 'test');
    }
}
@isTest
public class OrderSelectorTest {
@isTest
    public static void getOrder(){
        
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
        
        Quote quoterecord = new Quote(
			 Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id,
            Communication_Language__c='',
            Business_Case_Required__c=true,
            Approval_Required__c=true,
            Status='Draft',
            Approval_Date__c=null,
            Approved_By__c = null
        );
        
        insert quoterecord;
        
        order od = new order();
        od.Name = 'Test';
        od.OpportunityId=opportuntyRecord.Id;
        od.AccountId=accountRecord.Id;
        od.Status='Draft';
        od.QuoteId=quoterecord.Id;
        od.EffectiveDate=system.today();
        insert od;
        system.assertEquals(1,[select Id from order].size(),'test');
        
        // Call the getOrderRecord method
        Order selectedOrder = OrderSelector.getOrderRecord(od.Id);
        
        System.assertEquals(od.OpportunityId, selectedOrder.OpportunityId, 'test');
        
    }
    
    }
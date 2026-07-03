@isTest
public class icDTOShippingConfirmationTest {
    
     @isTest
    static void  icDTOShippingConfirmation() {
        
         Account a = new Account(Name='Account Test');
            insert a;
            
            Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
            insert testPricebook;
            
            vlocity_cmt__PriceList__c pl1 = new vlocity_cmt__PriceList__c(vlocity_cmt__Pricebook2Id__c = testPricebook.Id, vlocity_cmt__IsActive__c = true, vlocity_cmt__Code__c = 'TestPricebook5');
            insert pl1;
            
            
            Order testOrder = new Order(Name='Test Order',EffectiveDate=System.today(),status='Draft',AccountId = a.Id, vlocity_cmt__PriceListId__c = pl1.Id, Pricebook2Id = testPricebook.Id);
            insert testOrder;
        
        icDTOShippingConfirmation  dtoShippingConfirmation = new icDTOShippingConfirmation();
        dtoShippingConfirmation.deliveryRequestID='';
        dtoShippingConfirmation.orderID=testOrder.Id;
        dtoShippingConfirmation.shippingWaybillNumber='12345';
        dtoShippingConfirmation.shippingWaybillStatus='Done';
        dtoShippingConfirmation.shippingReturnWaybillNumber='12345';
        dtoShippingConfirmation.referencecustomerRef1='';
        dtoShippingConfirmation.referencecustomerRef2='';
        dtoShippingConfirmation.resourceID='';
        dtoShippingConfirmation.resourceIDType='';
          dtoShippingConfirmation.shippingDate='11-10-2023';
         
    }

}
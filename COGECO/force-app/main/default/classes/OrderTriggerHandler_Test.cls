@isTest(SeeAllData=false)
public class OrderTriggerHandler_Test {
    
    @isTest
    static void insertOrderRec() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User userRecord = new User(
            Title = 'Mr.',
            Username = 'tiwary91134111@gmail.com',
            LastName = 'System',
            Email = 'abc@gmail.com',
            Alias = 'autocase',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_CA',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = testProfile.Id
        );
        
        Test.startTest();
        insert userRecord;
        
        System.runAs(userRecord) {
            Account a = new Account(Name='Account Test', ShippingPostalCode = 'A1A1A1', ShippingStreet = '123 Test Street');
            insert a;
            
            Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
            insert testPricebook;
            
            vlocity_cmt__PriceList__c pl1 = new vlocity_cmt__PriceList__c(vlocity_cmt__Pricebook2Id__c = testPricebook.Id, vlocity_cmt__IsActive__c = true, vlocity_cmt__Code__c = 'TestPricebook5');
            insert pl1;
            
            System_Values__c systemValuesRecord = new System_Values__c(
                Name = ApexConstants.SYSTEM_VALUES_ORDER_FULFILLMENT_STATUS_DEFAULT,
                Value__c = 'Draft'
            );
            insert systemValuesRecord;
            
            List<Order> orderRec =new List<Order> ();
            Order testOrder = new Order(Name='Test Order',vlocity_cmt__FulfilmentStatus__c ='',EffectiveDate=System.today(),status='Draft',AccountId = a.Id, vlocity_cmt__PriceListId__c = pl1.Id, Pricebook2Id = testPricebook.Id);
            insert testOrder;
       
            OrderTriggerHandler.setOrderDefaults(orderRec); // for null List
            orderRec.add(testOrder);
            OrderTriggerHandler.setOrderDefaults(orderRec);
           
        }
       
        Test.Stoptest();
    }
    
    
}
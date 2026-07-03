@IsTest
public class OrderTriggerNewTest {

    @testSetup
    static void setupData() {

        // Account hierarchy
        Account soldTo = new Account(Name = 'Sold To Account');
        insert soldTo;
        
        Opportunity opp = new Opportunity(
        Name = 'Test Opportunity',
        StageName = 'Closed Won',
        CloseDate = Date.today(),
        AccountId = soldTo.Id
    );
    insert opp;

        Account shipTo = new Account(
            Name = 'Ship To Account',
            ParentId = soldTo.Id
        );
        insert shipTo;

        // Contact
        Contact primaryContact = new Contact(
            firstname='test',
            LastName = 'Primary Contact',
            AccountId = shipTo.Id
        );
        insert primaryContact;

        // Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__Status__c = 'Draft',
            SBQQ__Opportunity2__c=opp.id,
            SBQQ__Primary__c=true,
            SBQQ__Account__c = shipTo.Id,
            SBQQ__PrimaryContact__c = primaryContact.Id,
            SBQQ__ShippingStreet__c = '123 Main St',
            SBQQ__ShippingCity__c = 'Bangalore',
            SBQQ__ShippingState__c = 'KA',
            SBQQ__ShippingPostalCode__c = '560001',
            SBQQ__ShippingCountry__c = 'India'
        );
        insert quote;
    }

    /* -----------------------------------------
       TEST: BEFORE INSERT ORDER
    ------------------------------------------*/
    @IsTest
    static void testBeforeInsertOrder() {

        SBQQ__Quote__c quote =
            [SELECT Id,SBQQ__Account__c, CreatedDate FROM SBQQ__Quote__c LIMIT 1];

        Test.startTest();

        Order ord = new Order(
            Name = 'Test Order',
            EffectiveDate = Date.today(),
            Status = 'Draft',
            AccountId = quote.SBQQ__Account__c,
            SBQQ__Quote__c = quote.Id
        );

        insert ord;

        Test.stopTest();

        
    }

    /* -----------------------------------------
       TEST: ORDER WITHOUT QUOTE
       (Trigger should safely skip)
    ------------------------------------------*/
    @IsTest
    static void testOrderWithoutQuote() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Order ord = new Order(
            Name = 'Order Without Quote',
            EffectiveDate = Date.today(),
            Status = 'Draft',
            AccountId = acc.Id
        );

        insert ord;

       
    }

    /* -----------------------------------------
       TEST: BULK INSERT
    ------------------------------------------*/
    @IsTest
    static void testBulkInsertOrders() {

        SBQQ__Quote__c quote =
            [SELECT Id FROM SBQQ__Quote__c LIMIT 1];

        Account acc = [SELECT Id FROM Account LIMIT 1];

        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < 5; i++) {
            orders.add(new Order(
                Name = 'Bulk Order ' + i,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                AccountId = acc.Id,
                SBQQ__Quote__c = quote.Id
            ));
        }

        Test.startTest();
        insert orders;
        Test.stopTest();

    }
}
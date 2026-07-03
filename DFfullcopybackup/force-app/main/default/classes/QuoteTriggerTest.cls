@IsTest
public class QuoteTriggerTest {

    @testSetup
    static void setupData() {

        // Sold-To Account
        Account soldTo = new Account(
            Name = 'Sold To Account',
            APTS_Pricing_Notes__c = 'Special pricing applies'
        );
        insert soldTo;

        // Ship-To Account
        Account shipTo = new Account(
            Name = 'Ship To Account',
            ParentId = soldTo.Id,
            ShippingStreet = '123 Main St',
            ShippingCity = 'Bangalore',
            ShippingState = 'KA',
            ShippingPostalCode = '560001',
            ShippingCountry = 'India'
        );
        insert shipTo;

        // Another account for update scenario
        Account newShipTo = new Account(
            Name = 'New Ship To',
            ShippingStreet = '456 Market St',
            ShippingCity = 'Mumbai',
            ShippingState = 'MH',
            ShippingPostalCode = '400001',
            ShippingCountry = 'India'
        );
        insert newShipTo;
    }

    /* -----------------------------------------
       TEST: BEFORE INSERT
    ------------------------------------------*/
    @IsTest
    static void testBeforeInsert() {

        Account shipTo =
            [SELECT Id FROM Account WHERE Name = 'Ship To Account' LIMIT 1];

        SBQQ__Quote__c quote = new SBQQ__Quote__c(
           SBQQ__Status__c = 'Draft',
            SBQQ__Account__c = shipTo.Id
        );

        insert quote;

       

     
    }

  
}
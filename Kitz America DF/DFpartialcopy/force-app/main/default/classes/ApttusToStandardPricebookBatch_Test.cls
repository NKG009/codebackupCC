@isTest
public class ApttusToStandardPricebookBatch_Test {

    /* =====================================================
       TEST DATA SETUP
       ===================================================== */
    @testSetup
    static void setupData() {

        // Activate Standard Pricebook
        Id standardPBId = Test.getStandardPricebookId();

        // Create Products
        Product2 p1 = new Product2(Name = 'Product One', IsActive = true);
        Product2 p2 = new Product2(Name = 'Product Two', IsActive = true);
        insert new List<Product2>{ p1, p2 };

        // Existing Pricebook Entry for p2 (to test UPDATE)
        PricebookEntry existingPBE = new PricebookEntry(
            Pricebook2Id = standardPBId,
            Product2Id = p2.Id,
            UnitPrice = 50,
            IsActive = true,
            UseStandardPrice = false
        );
        insert existingPBE;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;   

        // Apttus Price List Items (latest should be picked)
        Apttus_Config2__PriceListItem__c pli1_old =
            new Apttus_Config2__PriceListItem__c(
                Apttus_Config2__ProductId__c = p1.Id,
                Apttus_Config2__ListPrice__c = 100,
                Apttus_Config2__Active__c = true,
                Apttus_Config2__PriceListId__c = priceList.id
            );

        Apttus_Config2__PriceListItem__c pli1_new =
            new Apttus_Config2__PriceListItem__c(
                Apttus_Config2__ProductId__c = p1.Id,
                Apttus_Config2__ListPrice__c = 150,
                Apttus_Config2__Active__c = true,
                Apttus_Config2__PriceListId__c = priceList.id
            );

        Apttus_Config2__PriceListItem__c pli2 =
            new Apttus_Config2__PriceListItem__c(
                Apttus_Config2__ProductId__c = p2.Id,
                Apttus_Config2__ListPrice__c = 200,
                Apttus_Config2__Active__c = true,
                Apttus_Config2__PriceListId__c = priceList.id
            );

        insert new List<Apttus_Config2__PriceListItem__c>{
            pli1_old,
            pli1_new,
            pli2
        };
    }

    /* =====================================================
       TEST: Batch Execution
       ===================================================== */
    @isTest
    static void test_batch_execution() {

        Test.startTest();
        ApttusToStandardPricebookBatch batch =
            new ApttusToStandardPricebookBatch();

        Database.executeBatch(batch, 200);
        Test.stopTest();

        Id standardPBId = Test.getStandardPricebookId();

        // Fetch PBEs
        List<PricebookEntry> pbes = [
            SELECT Product2.Name, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id = :standardPBId
        ];

       
        
    }
}
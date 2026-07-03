@IsTest
public class PricingMatrixBatchTest {

    @testSetup
    static void setupData() {

        // Accounts
        Account soldTo = new Account(
            Name = 'Sold To Account'
        );
        insert soldTo;

        Account shipTo = new Account(
            Name = 'Ship To Account',
            ParentId = soldTo.Id
        );
        insert shipTo;

        Date today = Date.today();
        
          Product2 parentProd = new Product2(
            Name = 'Parent Product1',
            IsActive = true
        );
        insert parentProd;
        
          Product2 parentProd2 = new Product2(
            Name = 'Parent Product2',
            IsActive = true
        );
        insert parentProd2;

        List<APTS_ContractualPriceMultiplier__c> srcList =
            new List<APTS_ContractualPriceMultiplier__c>();

        // 1️⃣ NET PRICE
        srcList.add(new APTS_ContractualPriceMultiplier__c(
            APTS_Sold_To_Account__c = soldTo.Id,
            APTS_Sold_To_Acct_Number__c = 'SOLD001',
            APTS_Product_Name__c = parentProd.id,
            APTS_Material_Number__c = 'MAT001',
            APTS_Contract_Price__c = 100,
            APTS_Valid_From_Date__c = today.addDays(-5),
            APTS_Valid_Until_Date__c = today.addDays(5)
        ));

        // 2️⃣ PRODUCT DISCOUNT
        srcList.add(new APTS_ContractualPriceMultiplier__c(
            APTS_Ship_To_Account__c = shipTo.Id,
            APTS_Ship_To_Acct_Number__c = 'SHIP001',
            APTS_Product_Name__c = parentProd2.id,
            APTS_Material_Number__c = 'MAT002',
            APTS_Multiplier__c = 0.9,
            APTS_Valid_From_Date__c = today.addDays(-2),
            APTS_Valid_Until_Date__c = today.addDays(10)
        ));

        // 3️⃣ SUB-CATEGORY DISCOUNT
        srcList.add(new APTS_ContractualPriceMultiplier__c(
            APTS_Sold_To_Account__c = soldTo.Id,
            APTS_Sold_To_Acct_Number__c = 'SOLD002',
            APTS_Mat_Grp_3_Catgr_CD__c = 'S01',
            APTS_Multiplier__c = 0.85,
            APTS_Valid_From_Date__c = today.addDays(-1),
            APTS_Valid_Until_Date__c = today.addDays(20)
        ));

        // 4️⃣ CATEGORY DISCOUNT
        srcList.add(new APTS_ContractualPriceMultiplier__c(
            APTS_Sold_To_Account__c = soldTo.Id,
            APTS_Sold_To_Acct_Number__c = 'SOLD003',
            APTS_Mat_Grp_1_CIT__c = 'CT1',
            APTS_Mat_Grp_2_Catlg__c = 'C01',
            APTS_Multiplier__c = 0.8,
            APTS_Valid_From_Date__c = today.addDays(-10),
            APTS_Valid_Until_Date__c = today.addDays(10)
        ));

        insert srcList;
    }

    @IsTest
    static void testPricingMatrixBatch() {

        Test.startTest();
        Database.executeBatch(new PricingMatrixBatch(), 5);
        Test.stopTest();

        // 🔍 Verify Pricing Matrix records created
        List<Pricing_Matrix__c> results =
            [SELECT Id,
                    Active__c,
                    NET_Price__c,
                    Product_Discount__c,
                    Product_Sub_Category_Discount__c,
                    Product_Category_Discount__c
             FROM Pricing_Matrix__c];

        System.assert(
            results.size() > 0,
            'Pricing Matrix records should be created'
        );

        Boolean hasNetPrice = false;
        Boolean hasProdDiscount = false;
        Boolean hasSubCat = false;
        Boolean hasCategory = false;

        for (Pricing_Matrix__c pm : results) {
            if (pm.NET_Price__c != null) hasNetPrice = true;
            if (pm.Product_Discount__c != null) hasProdDiscount = true;
            if (pm.Product_Sub_Category_Discount__c != null) hasSubCat = true;
            if (pm.Product_Category_Discount__c != null) hasCategory = true;

            System.assertEquals(true, pm.Active__c, 'Record should be active');
        }

        
    }
}
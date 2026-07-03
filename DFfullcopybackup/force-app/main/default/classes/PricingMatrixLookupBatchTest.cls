@IsTest
public class PricingMatrixLookupBatchTest {

    @IsTest
    static void testPricingMatrixLookupBatch() {

        /* --------- Accounts --------- */

        Account parentAcc = new Account(
            Name = 'Parent SAP Account',
            AccountNumber = '30T2359'
        );
        insert parentAcc;

        Account childAcc = new Account(
            Name = 'Child SAP Account',
            AccountNumber = '30S0001',
            ParentId =parentAcc.id
        );
        insert childAcc;

        /* --------- Product --------- */

        Product2 prod = new Product2(
            Name = 'Test Product',
            IsActive = true,
            APTS_Material_Num__c = '01K1A4S020'
        );
        insert prod;

        /* --------- Pricing Matrix --------- */

        Pricing_Matrix__c pm = new Pricing_Matrix__c(
            Active__c = true,
            Valid_From__c = System.today().addDays(-10),
            Valid_Till__c = System.today().addYears(10),
            SAP_Account_Number__c = '30T2359',
            SAP_Account_Number_Child__c = '30S0001',
            SAP_Material_Number__c = '01K1A4S020',
            NET_Price__c = 7.06
        );
        insert pm;

        /* --------- Execute Batch --------- */

        Test.startTest();
        Database.executeBatch(new PricingMatrixLookupBatch(), 200);
        Test.stopTest();

        /* --------- Assertions --------- */

        Pricing_Matrix__c result = [
            SELECT Parent_Account__c,
                   Customer_Account__c,
                   Product__c
            FROM Pricing_Matrix__c
            WHERE Id = :pm.Id
        ];

        System.assertEquals(
            parentAcc.Id,
            result.Parent_Account__c,
            'Parent account should be mapped correctly'
        );

        System.assertEquals(
            childAcc.Id,
            result.Customer_Account__c,
            'Customer account should be mapped correctly'
        );

        System.assertEquals(
            prod.Id,
            result.Product__c,
            'Product should be mapped correctly'
        );
    }
    
    @IsTest
    static void testScheduler() {

        Test.startTest();
        String cronExp = '0 0 0 1 1 ? 2099';
        System.schedule(
            'Test Pricing Matrix Scheduler',
            cronExp,
            new PricingMatrixLookupScheduler()
        );
        Test.stopTest();

        
    }
}
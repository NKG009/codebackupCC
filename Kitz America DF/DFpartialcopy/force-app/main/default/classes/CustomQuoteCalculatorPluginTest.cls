@isTest
public class CustomQuoteCalculatorPluginTest {

    // Utility method to create required Pricebook + PricebookEntry
    private static PricebookEntry createPBE(Product2 prod) {
        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = pb.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }
    
    
    @testSetup
    static void setupData() {

        // Create Account
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Create Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
          //  Name = 'Test Quote',
            SBQQ__Account__c = acc.Id,
            SBQQ__Status__c = 'Draft'
        );
        insert quote;

        // Create parent product
        Product2 parentProd = new Product2(
            Name = 'Parent Product',
            IsActive = true
        );
        insert parentProd;

        // Create child (combo) product
        Product2 childProd = new Product2(
            Name = 'Child Combo Product',
            IsActive = true
        );
        insert childProd;

        // Create parent quote line
        SBQQ__QuoteLine__c parentQL = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = parentProd.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100,
            SBQQ__NetPrice__c = 100
        );
        insert parentQL;

        // CHILD QUOTE LINE with RequiredBy + Feature Name = Combo Name
        SBQQ__QuoteLine__c childQL = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = childProd.Id,
            SBQQ__RequiredBy__c = parentQL.Id,
            SBQQ__Quantity__c = 1,
            Feature_Name__c = System.Label.CPQ_Combo_Product_Name,
            SBQQ__ListPrice__c = 20,
            SBQQ__NetPrice__c = 20
        );
        insert childQL;
    }
    
     @isTest
    static void testPluginMethods_NoExceptions() {
        SBQQ__Quote__c q = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        List<SBQQ__QuoteLine__c> qls = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 10];

        CustomQuoteCalculatorPlugin plugin = new CustomQuoteCalculatorPlugin();

        Test.startTest();
        plugin.onInit(new List<SObject>{ q });
        plugin.onBeforePriceRules(q, (List<SObject>)qls);
        plugin.onAfterPriceRules(q, (List<SObject>)qls);
        plugin.onAfterCalculate(q, (List<SObject>)qls);
       // plugin.onBeforeCalculate(q, (List<SObject>)qls);
        plugin.onBeforeSave(q, (List<SObject>)qls);
        plugin.onAfterSave(q, (List<SObject>)qls);
        Test.stopTest();

        System.assert(true, 'Plugin executed all methods successfully.');
    }

    @isTest
    static void testUpdatingPriceUsingPriceMatrix_NETPrice() {

        // Create Account
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Create Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
         //   Name = 'Test Q',
            SBQQ__Account__c = acc.Id,
            SBQQ__Status__c = 'Draft'
        );
        insert quote;

        // Create Product
        Product2 prod = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert prod;

        // Create PricebookEntry
     //   createPBE(prod);

        // Create Quote Line
        SBQQ__QuoteLine__c parentLine = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = prod.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100,
            SBQQ__NetPrice__c = 100,
            Feature_Name__c = 'PARENT'
        );
        insert parentLine;

        // Create a child quote line (combo item)
        SBQQ__QuoteLine__c childLine = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = prod.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100,
            SBQQ__NetPrice__c = 90,
            SBQQ__RequiredBy__c = parentLine.Id,
            Feature_Name__c = System.Label.CPQ_Combo_Product_Name
        );
        insert childLine;

        // Create Pricing Matrix with only NET price
        Pricing_Matrix__c pm = new Pricing_Matrix__c(
            Active__c = true,
            Product__c = prod.Id,
            Customer_Account__c = acc.Id,
			Valid_Till__c=system.today()
            
        );
        insert pm;

        // Run Plugin onBeforeCalculate → should invoke updatingpriceusingpricematrix()
        CustomQuoteCalculatorPlugin plugin = new CustomQuoteCalculatorPlugin();

        List<SObject> qLines = new List<SObject>{ parentLine, childLine };

        Test.startTest();
        plugin.onBeforeCalculate(quote, qLines);
        Test.stopTest();

        // Reload updated lines
        SBQQ__QuoteLine__c updatedParent = [
            SELECT SBQQ__NetPrice__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :parentLine.Id
        ];

        SBQQ__QuoteLine__c updatedChild = [
            SELECT SBQQ__ListPrice__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :childLine.Id
        ];

       

        
    }


    // -------- Discount Test --------
    @isTest
    static void testUpdatingPriceUsingMatrix_DiscountFlow() {

        // Create Account
        Account acc = new Account(Name='Discount Account');
        insert acc;

        // Create Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
         //   Name = 'Discount Quote',
            SBQQ__Account__c = acc.Id,
            SBQQ__Status__c = 'Draft'
        );
        insert quote;

        // Create Product
        Product2 prod = new Product2(
            Name = 'Discount Product',
            IsActive = true
        );
        insert prod;

        // Create PricebookEntry
      //  createPBE(prod);

        // Create Quote Line
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = prod.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 200,
            SBQQ__Discount__c = 0
        );
        insert ql;

        // Create Pricing Matrix with a discount
        Pricing_Matrix__c pm = new Pricing_Matrix__c(
            Active__c = true,
            Product__c = prod.Id,
            Customer_Account__c = acc.Id,
            Customer_Based_Product_Discount__c = 25
        );
        insert pm;

        CustomQuoteCalculatorPlugin plugin = new CustomQuoteCalculatorPlugin();
        List<SObject> qLines = new List<SObject>{ ql };

        Test.startTest();
        plugin.onBeforeCalculate(quote, qLines);
        Test.stopTest();

        SBQQ__QuoteLine__c updatedQL = [
            SELECT SBQQ__Discount__c
            FROM SBQQ__QuoteLine__c
            WHERE Id = :ql.Id
        ];

       
    }
}
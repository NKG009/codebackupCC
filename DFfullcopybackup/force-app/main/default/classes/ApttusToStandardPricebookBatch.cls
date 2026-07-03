global class ApttusToStandardPricebookBatch implements Database.Batchable<SObject>, Database.Stateful {

    private Id standardPricebookId;

    global ApttusToStandardPricebookBatch() {
        standardPricebookId = Test.isRunningTest()
            ? Test.getStandardPricebookId()
            : [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
    }

    /* ---------------------------------------
       START METHOD – Query Products
    ----------------------------------------*/
    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(
            [SELECT Id FROM Product2 WHERE IsActive = true]
        );
    }

    /* ---------------------------------------
       EXECUTE METHOD
    ----------------------------------------*/
    global void execute(Database.BatchableContext bc, List<Product2> scope) {

        Set<Id> productIds = new Set<Id>();
        for (Product2 p : scope) {
            productIds.add(p.Id);
        }

        if (productIds.isEmpty()) return;

        /* ---------------------------------------
           1️⃣ Get Latest Apttus Price per Product
        ----------------------------------------*/
        Map<Id, Apttus_Config2__PriceListItem__c> latestApttusPriceMap =
            new Map<Id, Apttus_Config2__PriceListItem__c>();

        for (Apttus_Config2__PriceListItem__c pli :
            [
                SELECT Id,
                       Apttus_Config2__ListPrice__c,
                       Apttus_Config2__ProductId__c,
                       CreatedDate
                FROM Apttus_Config2__PriceListItem__c
                WHERE Apttus_Config2__Active__c = true
                AND Apttus_Config2__ProductId__c IN :productIds
                ORDER BY CreatedDate DESC
            ]
        ) {
            // Pick only the first (latest) record per product
            if (!latestApttusPriceMap.containsKey(pli.Apttus_Config2__ProductId__c)) {
                latestApttusPriceMap.put(
                    pli.Apttus_Config2__ProductId__c,
                    pli
                );
            }
        }

        if (latestApttusPriceMap.isEmpty()) return;

        /* ---------------------------------------
           2️⃣ Fetch Existing Standard PB Entries
        ----------------------------------------*/
        Map<Id, PricebookEntry> standardPBMap =
            new Map<Id, PricebookEntry>();

        for (PricebookEntry pbe :
            [
                SELECT Id, Product2Id, UnitPrice, IsActive
                FROM PricebookEntry
                WHERE Pricebook2Id = :standardPricebookId
                AND Product2Id IN :latestApttusPriceMap.keySet()
            ]
        ) {
            standardPBMap.put(pbe.Product2Id, pbe);
        }

        List<PricebookEntry> toInsert = new List<PricebookEntry>();
        List<PricebookEntry> toUpdate = new List<PricebookEntry>();

        /* ---------------------------------------
           3️⃣ Insert / Update Logic
        ----------------------------------------*/
        for (Id productId : latestApttusPriceMap.keySet()) {

            Decimal listPrice =
                latestApttusPriceMap.get(productId)
                                    .Apttus_Config2__ListPrice__c;

            if (listPrice == null) continue;

            if (standardPBMap.containsKey(productId)) {
                // Update existing
                PricebookEntry pbe = standardPBMap.get(productId);
                pbe.UnitPrice = listPrice;
                pbe.IsActive = true;
                toUpdate.add(pbe);

            } else {
                // Create new
                toInsert.add(new PricebookEntry(
                    Pricebook2Id = standardPricebookId,
                    Product2Id = productId,
                    UnitPrice = listPrice,
                    IsActive = true,
                    UseStandardPrice = false
                ));
            }
        }

        if (!toInsert.isEmpty()) insert toInsert;
        if (!toUpdate.isEmpty()) update toUpdate;
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Apttus → Standard Pricebook sync completed');
    }
}
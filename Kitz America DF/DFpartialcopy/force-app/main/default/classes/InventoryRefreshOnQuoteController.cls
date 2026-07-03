public with sharing class InventoryRefreshOnQuoteController {

    public String quoteId { get; private set; }
    public Boolean isLoading { get; set; }
    public List<LineChangeInfo> changedLines { get; set; }
    public String message { get; set; }

    /* =========================
       INNER WRAPPER
       ========================= */
    public class LineChangeInfo {
        public Decimal lineNumber { get; set; }
        public Decimal oldQty { get; set; }
        public Decimal newQty { get; set; }
    }

    /* =========================
       Constructor
       ========================= */
    public InventoryRefreshOnQuoteController() {
        quoteId = ApexPages.currentPage().getParameters().get('id');
        isLoading = true;
        changedLines = new List<LineChangeInfo>();
        message = 'Refreshing inventory, please wait...';
    }

    /* =========================
       Inventory Refresh
       ========================= */
    public void refreshInventory() {
        isLoading = true;

        if (quoteId == null) {
            isLoading = false;
            return;
        }

        List<SBQQ__QuoteLine__c> qliList = [
            SELECT Id,
                   SBQQ__Number__c,
                   Warehouse__c,
                   Material_Number__c,
                   Available_Qty__c,
                   SBQQ__Product__c,SBQQ__Product__r.Available_Qty__c
            FROM SBQQ__QuoteLine__c
            WHERE SBQQ__Quote__c = :quoteId
        ];

        InventoryCalloutMulesoft call = new InventoryCalloutMulesoft();

        List<SBQQ__QuoteLine__c> qliToUpdate = new List<SBQQ__QuoteLine__c>();
        Map<Id, Product2> productsToUpdate = new Map<Id, Product2>();

        for (SBQQ__QuoteLine__c qli : qliList) {

            if (String.isBlank(qli.Material_Number__c)) continue;

            Decimal oldQty = qli.Available_Qty__c;
            Decimal prdavlqty = qli.SBQQ__Product__r.Available_Qty__c;
            Integer newQty = null;

            String response;
            if (Test.isRunningTest()) {
                response =
                    '{"WAREHOUSE":{"WAREHOUSE_Data":[' +
                    '{"WAREHOUSE_NAME":"STAFFORD","QTY":100}' +
                    ']}}';
            } else {
                response = call.callInventory(qli.Material_Number__c, 'WHSE');
            }

            if (String.isBlank(response)) continue;

            Map<String, Object> raw =
                (Map<String, Object>) JSON.deserializeUntyped(response);

            List<Object> whList = new List<Object>();

            if (raw.containsKey('WAREHOUSE')) {
                Map<String, Object> whObj =
                    (Map<String, Object>) raw.get('WAREHOUSE');

                if (whObj.containsKey('WAREHOUSE_Data')) {
                    whList = (List<Object>) whObj.get('WAREHOUSE_Data');
                }
            }

            /* =========================
               CASE: No warehouse data
               ========================= */
            system.debug('whList:'+whList.size());
            if (whList.isEmpty()) {
                newQty = 0;
            }
            /* =========================
               Normal warehouse match
               ========================= */
            else {
                for (Object o : whList) {
                    Map<String, Object> wh =
                        (Map<String, Object>) o;

                    if (qli.Warehouse__c ==
                        (String) wh.get('WAREHOUSE_NAME')) {
                        newQty = (Integer) wh.get('QTY');
                        break;
                    }
                }
            }

            if (newQty == null) continue;

            if (oldQty != newQty) {
				 system.debug('qle avl chnge');
                /* ---- Quote Line update ---- */
                qli.Available_Qty__c = newQty;
                qliToUpdate.add(qli);

                /* ---- Product update ---- */
                if (qli.SBQQ__Product__c != null &&
                    !productsToUpdate.containsKey(qli.SBQQ__Product__c)) {

                    productsToUpdate.put(
                        qli.SBQQ__Product__c,
                        new Product2(
                            Id = qli.SBQQ__Product__c,
                            APTS_Available_Quantity__c = newQty
                        )
                    );
                }

                /* ---- UI Tracking ---- */
                LineChangeInfo info = new LineChangeInfo();
                info.lineNumber = qli.SBQQ__Number__c;
                info.oldQty = oldQty;
                info.newQty = newQty;
                changedLines.add(info);
            }
            if(prdavlqty !=newQty){
                system.debug('prd avl chnge');
                 if (!productsToUpdate.containsKey(qli.SBQQ__Product__c)) {
                    productsToUpdate.put(
                        qli.SBQQ__Product__c,
                        new Product2(
                            Id = qli.SBQQ__Product__c,
                            APTS_Available_Quantity__c = newQty
                        )
                    );
                }
                
            }
        }
		System.debug('qliToUpdate Lines Count: ' + qliToUpdate.size());
        if (!qliToUpdate.isEmpty()) {
            update qliToUpdate;
        }
		System.debug('productsToUpdate Count: ' + productsToUpdate.values().size());
        if (!productsToUpdate.isEmpty()) {
            update productsToUpdate.values();
        }

        System.debug('Changed Lines Count: ' + changedLines.size());

        isLoading = false;
        message = '✅ Inventory refresh complete.';
    }

    /* =========================
       Redirect to QLE
       ========================= */
    public PageReference redirecttoqle() {
        PageReference pr =
            new PageReference('/apex/SBQQ__sb?id=' + quoteId);
        pr.setRedirect(true);
        return pr;
    }
}
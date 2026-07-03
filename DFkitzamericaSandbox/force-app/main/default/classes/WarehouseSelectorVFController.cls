public class WarehouseSelectorVFController {

    public string quoteLineId { get; set; }
    public string quoteId { get; set; }
	public Boolean showLineIdError { get; set; }
    // Wrapper for VF table
    public class WH {
         public Integer id { get; set; }
    public String name { get; set; }
    public String location { get; set; }
    public Integer qty { get; set; }
    }

    public List<WH> warehouseList { get; set; }

    public WarehouseSelectorVFController() {
		Map<String, String> p = ApexPages.currentPage().getParameters();
		system.debug('p'+p);
        quoteLineId = ApexPages.currentPage().getParameters().get('LineId');
        quoteId     = ApexPages.currentPage().getParameters().get('QuoteId');
		
		system.debug('quoteLineId'+quoteLineId);
		system.debug('quoteId'+quoteId);
        if (quoteLineId==null || quoteLineId=='null') {
            showLineIdError = true;
        } else {
            showLineIdError = false;
        }
		system.debug('showLineIdError:'+showLineIdError);
		/*if (quoteLineId ==null || quoteLineId=='null') {
        ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Please do a Quick Save on Quote before Warehouse Selection.'
        ));
    }*/
        warehouseList = new List<WH>();

        // Static JSON from your LWC (you can replace later)
        List<Object> raw = (List<Object>)JSON.deserializeUntyped(
            '[{"MTR_Number":"01K1AF6110","WAREHOUSE_Data":[{"QTY":356,"WAREHOUSE_NAME":"STAFFORD","LGORT":"3008","ROWNO":1},{"QTY":90,"WAREHOUSE_NAME":"INTRASIT","LGORT":"3099","ROWNO":2},{"QTY":6,"WAREHOUSE_NAME":"DENSAND INC","LGORT":"30W0030","ROWNO":3},{"QTY":4,"WAREHOUSE_NAME":"R.D. KINCAIDE","LGORT":"30W0024","ROWNO":4},{"QTY":2,"WAREHOUSE_NAME":"SOUTHERN SPEC","LGORT":"30W0031","ROWNO":5},{"QTY":2,"WAREHOUSE_NAME":"WILLIAMS & ASSOCIATES","LGORT":"30W0003","ROWNO":6}]}]'
        );

        Map<String,Object> wrapper = (Map<String,Object>)raw[0];
        List<Object> whList        = (List<Object>)wrapper.get('WAREHOUSE_Data');

        for (Object o : whList) {
            Map<String,Object> m = (Map<String,Object>)o;

            // Exclude INTRASIT (same as LWC)
            if ((String)m.get('WAREHOUSE_NAME') == 'INTRASIT') continue;

            WH w = new WH();
            w.id     = (Integer)m.get('ROWNO');
            w.name   = (String)m.get('WAREHOUSE_NAME');
            w.location = (String)m.get('LGORT');
            w.qty    = (Integer)m.get('QTY');

            warehouseList.add(w);
        }
    }

    public PageReference applyWarehouse() {

        String selected = ApexPages.currentPage().getParameters().get('warehouseSelect');

        if (String.isBlank(selected) && !Test.isRunningTest()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a warehouse.'));
            return null;
        }

        WH selectedWH;
        for (WH w : warehouseList) {
            if (String.valueOf(w.id) == selected) {
                selectedWH = w;
                break;
            }
        }
		SBQQ__QuoteLine__c ql = [
            SELECT Id, Warehouse__c, Available_Qty__c
            FROM SBQQ__QuoteLine__c
            WHERE Id =:quoteLineId
        ];

        ql.Warehouse__c = selectedWH.name;
        ql.Available_Qty__c = selectedWH.qty;

        update ql;
       
       

        // Redirect to CPQ QLE
        PageReference pr = new PageReference('/apex/SBQQ__sb?id=' + quoteId);
        pr.setRedirect(true);
        return pr;
    }

    public PageReference redirecttoqle() {
         PageReference pr = new PageReference('/apex/SBQQ__sb?id=' + quoteId);
        pr.setRedirect(true);
        return pr;
    }
}
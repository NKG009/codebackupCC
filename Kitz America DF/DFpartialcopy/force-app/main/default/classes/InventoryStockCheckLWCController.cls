public with sharing class InventoryStockCheckLWCController {

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchProducts(String searchKey) {
        if (String.isBlank(searchKey)) {
            return new List<ProductWrapper>();
        }

        List<PricebookEntry> pbes = [
            SELECT Id,
                   UnitPrice,
                   Product2.Id,
                   Product2.Name,
                   Product2.APTS_Size_inch__c,
                   Product2.Available_Qty__c,
            		Product2.APTS_Main_Plant_Desc__c,Product2.APTS_Weight_gm__c,Product2.Case_Quantity__c,Product2.Box_Quantity__c,Product2.APTS_Material_Num__c
            FROM PricebookEntry
            WHERE Pricebook2.IsStandard = true
            AND Product2.Name LIKE :('%' + searchKey + '%')
        ];

        List<ProductWrapper> results = new List<ProductWrapper>();
        for (PricebookEntry pbe : pbes) {
            results.add(new ProductWrapper(
                pbe.Product2.Id,
                pbe.Product2.Name,
                pbe.Product2.APTS_Size_inch__c,
                pbe.Product2.APTS_Material_Num__c,
                pbe.Product2.APTS_Main_Plant_Desc__c,
                pbe.UnitPrice,
                pbe.Product2.Available_Qty__c,
                pbe.Product2.Case_Quantity__c,
                pbe.Product2.Box_Quantity__c,
                pbe.Product2.APTS_Weight_gm__c

            ));
        }
        return results;
    }

    // 🔹 Mock API data – replace with real API call
    @AuraEnabled
    public static List<LocationStockWrapper> getLocationStock(string matnum) {
        List<LocationStockWrapper> data = new List<LocationStockWrapper>();
        
        InventoryCalloutMulesoft call = new InventoryCalloutMulesoft();
        string reqbody = call.callInventory(matnum,'WHSE');
        if(test.isrunningtest()) reqbody ='{"WAREHOUSE":{"WAREHOUSE_Data":[{"WAREHOUSE_NAME":"STAFFORD","WAREHOUSE_LOC":"USA","LGORT":"3008","QTY":100},{"WAREHOUSE_NAME":"INTRASIT","WAREHOUSE_LOC":"TRANSIT","LGORT":"3099","QTY":50}]}}';

        system.debug('API reqbody:-------'+reqbody);
        Map<String,Object> rawnew = (Map<String,Object>)JSON.deserializeUntyped(reqbody);
        system.debug('API rawnew:-------'+rawnew);
      
		Map<String,Object> wrapper = (Map<String,Object> )rawnew.get('WAREHOUSE');
        List<Object> whList        = (List<Object>)wrapper.get('WAREHOUSE_Data');
		integer i =0;
        for (Object o : whList) {
            Map<String,Object> m = (Map<String,Object>)o;
			
            if ((String)m.get('WAREHOUSE_NAME') == 'INTRASIT') continue;
            data.add(new LocationStockWrapper((String)m.get('WAREHOUSE_NAME'), (Integer)m.get('QTY')));
		
            
        }

       // data.add(new LocationStockWrapper('Bangalore Warehouse', 20));
       // data.add(new LocationStockWrapper('Mumbai Warehouse', 35));
        //data.add(new LocationStockWrapper('Delhi Warehouse', 15));

        return data;
    }


    public class ProductWrapper {
        @AuraEnabled public Id productId;
        @AuraEnabled public String name;
        @AuraEnabled public String size;
        @AuraEnabled public String materialNum;
        @AuraEnabled public String mainPlantDesc;
        @AuraEnabled public Decimal listPrice;
        @AuraEnabled public Decimal availableQty;
        @AuraEnabled public Decimal caseQty;
        @AuraEnabled public Decimal boxQty;
        @AuraEnabled public Decimal weightKg;
        

        public ProductWrapper(Id productId, String name, String size,string materialNum,string mainPlantDesc, Decimal listPrice, Decimal availableQty,Decimal caseQty,Decimal boxQty,Decimal weightKg) {
            this.productId = productId;
            this.name = name;
            this.size = size;
            this.materialNum =materialNum;
            this.mainPlantDesc =mainPlantDesc;
            this.listPrice = listPrice;
            this.availableQty = availableQty;
            this.caseQty=caseQty;
            this.boxQty=boxQty;
            this.weightKg =weightKg;
        }
    }

    public class LocationStockWrapper {
        @AuraEnabled public String location;
        @AuraEnabled public Decimal qty;

        public LocationStockWrapper(String location, Decimal qty) {
            this.location = location;
            this.qty = qty;
        }
    }
}
global class PricingMatrixBatch
implements Database.Batchable<SObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {   	
       // list<string> ids = new  list<string>{'a6GVH0000086mwa2AA','a6GVH0000086W2H2AU','a6GVH0000086Yob2AE','a6GVH0000086hFA2AY','a6GVH0000086oO72AI','a6GVH0000086oOu2AI'};
		//string query ='SELECT Id,APTS_Sold_To_Account__c,APTS_Ship_To_Account__c,APTS_Sold_To_Acct_Number__c,APTS_Ship_To_Acct_Number__c,APTS_Product_Name__c,APTS_Material_Number__c,APTS_Mat_Grp_1_CIT__c,APTS_Mat_Grp_2_Catlg__c,APTS_Mat_Grp_3_Catgr_CD__c,APTS_Valid_From_Date__c,APTS_Valid_Until_Date__c,APTS_Contract_Price__c,APTS_Multiplier__c FROM APTS_ContractualPriceMultiplier__c WHERE ID IN :'+ids;
        return Database.getQueryLocator([
        SELECT Id,
               APTS_Sold_To_Account__c,
               APTS_Ship_To_Account__c,
               APTS_Sold_To_Acct_Number__c,
               APTS_Ship_To_Acct_Number__c,
               APTS_Product_Name__c,
               APTS_Material_Number__c,
               APTS_Mat_Grp_1_CIT__c,
               APTS_Mat_Grp_2_Catlg__c,
               APTS_Mat_Grp_3_Catgr_CD__c,
               APTS_Valid_From_Date__c,
               APTS_Valid_Until_Date__c,
               APTS_Contract_Price__c,
               APTS_Multiplier__c
        FROM APTS_ContractualPriceMultiplier__c
       // WHERE Id IN :ids
    ]);
    }
    
    global void execute(
        Database.BatchableContext bc,
        List<APTS_ContractualPriceMultiplier__c> scope
    ) {
        system.debug('scopeall data:'+scope.size());
        Date today = Date.today();
        List<Pricing_Matrix__c> pricingMatrixList = new List<Pricing_Matrix__c>();
        
        for (APTS_ContractualPriceMultiplier__c src : scope) {
            
            Pricing_Matrix__c pm = new Pricing_Matrix__c();
            
          
            if(src.APTS_Ship_To_Account__c != null){
                pm.Customer_Account__c =src.APTS_Ship_To_Account__c;
            }
            else{
                pm.Parent_Account__c = src.APTS_Sold_To_Account__c;
            }
            
            pm.SAP_Account_Number__c =
                src.APTS_Ship_To_Account__c != null
                ? src.APTS_Ship_To_Acct_Number__c
                : src.APTS_Sold_To_Acct_Number__c;
            
         
            pm.Valid_From__c = src.APTS_Valid_From_Date__c;
            pm.Valid_Till__c = src.APTS_Valid_Until_Date__c;
            pm.Active__c =
                src.APTS_Valid_From_Date__c != null &&
                src.APTS_Valid_Until_Date__c != null &&
                today >= src.APTS_Valid_From_Date__c &&
                today <= src.APTS_Valid_Until_Date__c;
            
         
            
            // NET PRICE
            if (src.APTS_Contract_Price__c != null &&
                src.APTS_Product_Name__c != null) {
                    
                    pm.NET_Price__c = src.APTS_Contract_Price__c;
                    pm.Product__c              = src.APTS_Product_Name__c;
                    pm.SAP_Material_Number__c  = src.APTS_Material_Number__c;
                }
            
            //PRODUCT DISCOUNT
            else if (src.APTS_Multiplier__c != null &&
                     src.APTS_Product_Name__c != null) {
                         
                         pm.Product_Discount__c = src.APTS_Multiplier__c;
                         pm.Product__c              = src.APTS_Product_Name__c;
                         pm.SAP_Material_Number__c  = src.APTS_Material_Number__c;
                     }
            
            //SUB-CATEGORY DISCOUNT
            else if (src.APTS_Product_Name__c == null &&
                     src.APTS_Mat_Grp_3_Catgr_CD__c != null) {
                         pm.Product_Sub_Category__c = src.APTS_Mat_Grp_3_Catgr_CD__c;
                         pm.Product_Sub_Category_Discount__c =src.APTS_Multiplier__c;
                     }
            
            //CATEGORY DISCOUNT
            else if (src.APTS_Product_Name__c == null &&
                     src.APTS_Mat_Grp_1_CIT__c != null &&
                     src.APTS_Mat_Grp_2_Catlg__c != null) {
                         
                         pm.Product_Category_Discount__c =src.APTS_Multiplier__c;
                         pm.Product_Category_CIT__c = src.APTS_Mat_Grp_1_CIT__c;
                         pm.Product_Catalog__c      = src.APTS_Mat_Grp_2_Catlg__c;
                     }
            
            pricingMatrixList.add(pm);
        }
        system.debug('pricingMatrixList:'+pricingMatrixList.size());
        if (!pricingMatrixList.isEmpty()) {
            insert pricingMatrixList;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Pricing Matrix Batch Completed Successfully');
    }
}
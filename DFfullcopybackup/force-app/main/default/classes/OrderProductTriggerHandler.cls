public class OrderProductTriggerHandler {

    public static void applyPricingandvaluepopulate(List<OrderItem> orderItems) {

        /* -------------------------------
           Collect Ids
        --------------------------------*/
        Set<Id> productIds = new Set<Id>();
        Set<Id> orderIds   = new Set<Id>();

        for (OrderItem oi : orderItems) {
            if (oi.Product2Id != null) productIds.add(oi.Product2Id);
            if (oi.OrderId != null) orderIds.add(oi.OrderId);
        }

        if (productIds.isEmpty() || orderIds.isEmpty()) return;

        /* -------------------------------
           Orders + Accounts
        --------------------------------*/
        Map<Id, Order> orderMap = new Map<Id, Order>(
            [SELECT Id, AccountId FROM Order WHERE Id IN :orderIds]
        );

        Set<Id> customerAccIds = new Set<Id>();
        for (Order o : orderMap.values()) {
            if (o.AccountId != null) customerAccIds.add(o.AccountId);
        }

        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, ParentId FROM Account WHERE Id IN :customerAccIds]
        );

        Set<Id> parentAccIds = new Set<Id>();
        for (Account a : accMap.values()) {
            if (a.ParentId != null) parentAccIds.add(a.ParentId);
        }
        
        

        /* -------------------------------
           Products (✅ FIXED)
        --------------------------------*/
        Map<Id, Product2> productMap = new Map<Id, Product2>(
            [SELECT Id,
                    APTS_Mat_Grp_1_CIT__c,
                    APTS_Mat_Grp_2_Catlg__c,
                    APTS_Mat_Grp_3_Catgr_CD__c,
             		APTS_Material_Num__c,
             		APTS_Weight_gm__c ,(SELECT Id,APTS_Cost__c,APTS_Product_Name__c FROM All_Costs__r WHERE APTS_Invalid__c = false AND APTS_Valid_From_Date__c <= TODAY AND APTS_Valid_Until_Date__c >= TODAY order by createddate desc)
             FROM Product2
             WHERE Id IN :productIds]
        );

        Set<String> categorySet     = new Set<String>();
        Set<String> catalogSet      = new Set<String>();
        Set<String> subCategorySet  = new Set<String>();

        for (Product2 p : productMap.values()) {
            if (p.APTS_Mat_Grp_1_CIT__c != null)
                categorySet.add(p.APTS_Mat_Grp_1_CIT__c);

            if (p.APTS_Mat_Grp_2_Catlg__c != null)
                catalogSet.add(p.APTS_Mat_Grp_2_Catlg__c);

            if (p.APTS_Mat_Grp_3_Catgr_CD__c != null)
                subCategorySet.add(p.APTS_Mat_Grp_3_Catgr_CD__c);
        }

        /* -------------------------------
           🔥 PRICING MATRIX QUERY (FIXED AND CONDITIONS)
        --------------------------------*/
        String soql =
            'SELECT Id, Customer_Account__c, Parent_Account__c, Product__c, ' +
            'Product_Category_CIT__c, Product_Catalog__c, Product_Sub_Category__c, ' +
            'NET_Price__c, Product_Discount__c, ' +
            'Product_Sub_Category_Discount__c, Product_Category_Discount__c ' +
            'FROM Pricing_Matrix__c ' +
            'WHERE Active__c = true ' +
            'AND Valid_Till__c >= TODAY ' +
            'AND ( Product__c IN :productIds ' +
            '   OR (Product_Category_CIT__c IN :categorySet ' +
            '       AND Product_Catalog__c IN :catalogSet) ' +
            '   OR Product_Sub_Category__c IN :subCategorySet ) ' +
            'AND ( Customer_Account__c IN :customerAccIds';

        if (!parentAccIds.isEmpty())
            soql += ' OR Parent_Account__c IN :parentAccIds';

        soql += ' )';

        List<Pricing_Matrix__c> matrixList = Database.query(soql);

        /* -------------------------------
           Apply Waterfall
        --------------------------------*/
        for (OrderItem oi : orderItems) {
            

            Order ord = orderMap.get(oi.OrderId);
            if (ord == null || oi.Product2Id == null) continue;

            Id customerId = ord.AccountId;
            Id parentId   = accMap.containsKey(customerId)
                            ? accMap.get(customerId).ParentId
                            : null;

            Product2 prod = productMap.get(oi.Product2Id);
            if (prod == null) continue;
			
            //oi.Material_Number__c = prod.APTS_Material_Num__c !=null? prod.APTS_Material_Num__c:null;
           // oi.Weight_lb__c= prod.APTS_Weight_gm__c * 2.20462;
            oi.Total_Weight_lb__c =oi.Weight_lb__c * oi.Quantity;
            if(prod.All_Costs__r.size()>0){
                oi.Prod_Cost__c = prod.All_Costs__r[0].APTS_Cost__c;
            }
            
            PricingResult best;
            Integer bestPriority = 99;

            for (Pricing_Matrix__c pm : matrixList) {
                PricingResult r = match(pm, oi, prod, customerId, parentId);
                system.debug('PricingResult:'+r);
                if (r != null && r.priority < bestPriority) {
                    best = r;
                    bestPriority = r.priority;
                }
            }

            if (best != null) {
                
                if (best.isNetPrice) {
                    // 🔥 Absolute price override
                    oi.UnitPrice = best.value;
                    //oi.Multiplier__c = null;
                } else {
                    // 🔥 Discount-based pricing
                    oi.Multiplier__c = best.value;
                    oi.UnitPrice = oi.ListPrice * (best.value / 100);
                }
            }
        }
    }

    /* =====================================================
       WATERFALL (WITH CATALOG CHECK ADDED)
       =====================================================*/
    private static PricingResult match(
        Pricing_Matrix__c pm,
        OrderItem oi,
        Product2 prod,
        Id custId,
        Id parentId
    ) {
        
        // 1️⃣ Customer + Product + NET_Price
        if (pm.Customer_Account__c == custId &&
            pm.Product__c == oi.Product2Id &&
            pm.NET_Price__c != null)
            return new PricingResult(1, pm.NET_Price__c, true);
        
        // 2️⃣ Parent + Product + NET_Price
        if (pm.Parent_Account__c == parentId &&
            pm.Product__c == oi.Product2Id &&
            pm.NET_Price__c != null)
            return new PricingResult(2, pm.NET_Price__c, true);
        
        // 3️⃣ Customer + Product + Discount
        if (pm.Customer_Account__c == custId &&
            pm.Product__c == oi.Product2Id &&
            pm.Product_Discount__c != null)
            return new PricingResult(3, pm.Product_Discount__c, false);
        
        // 4️⃣ Parent + Product + Discount
        if (pm.Parent_Account__c == parentId &&
            pm.Product__c == oi.Product2Id &&
            pm.Product_Discount__c != null)
            return new PricingResult(4, pm.Product_Discount__c, false);
        
        // 5️⃣ Customer + Sub-Category
        if (pm.Customer_Account__c == custId &&
            pm.Product_Sub_Category__c == prod.APTS_Mat_Grp_3_Catgr_CD__c &&
            pm.Product_Sub_Category_Discount__c != null)
            return new PricingResult(5, pm.Product_Sub_Category_Discount__c, false);
        
        // 6️⃣ Parent + Sub-Category
        if (pm.Parent_Account__c == parentId &&
            pm.Product_Sub_Category__c == prod.APTS_Mat_Grp_3_Catgr_CD__c &&
            pm.Product_Sub_Category_Discount__c != null)
            return new PricingResult(6, pm.Product_Sub_Category_Discount__c, false);
        
        // 7️⃣ Customer + Category + Catalog
        if (pm.Customer_Account__c == custId &&
            pm.Product_Category_CIT__c == prod.APTS_Mat_Grp_1_CIT__c &&
            pm.Product_Catalog__c == prod.APTS_Mat_Grp_2_Catlg__c &&
            pm.Product_Category_Discount__c != null)
            return new PricingResult(7, pm.Product_Category_Discount__c, false);
        
        // 8️⃣ Parent + Category + Catalog
        if (pm.Parent_Account__c == parentId &&
            pm.Product_Category_CIT__c == prod.APTS_Mat_Grp_1_CIT__c &&
            pm.Product_Catalog__c == prod.APTS_Mat_Grp_2_Catlg__c &&
            pm.Product_Category_Discount__c != null)
            return new PricingResult(8, pm.Product_Category_Discount__c, false);
        
        
        return null;
    }

    public class PricingResult {
        public Integer priority;
        public Decimal value;
        public Boolean isNetPrice;
        
        public PricingResult(Integer p, Decimal v, Boolean isNet) {
            priority = p;
            value = v;
            isNetPrice = isNet;
        }
    }
    
    public static void applyvalidationrule(List<OrderItem> orderItems){
        
    }
}
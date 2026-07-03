global with sharing class CustomQuoteCalculatorPlugin implements SBQQ.QuoteCalculatorPlugin {
	
    global void onInit(List<SObject> quotes){}
    global void onBeforePriceRules(SObject quote, List<SObject> quoteLines) {}	
    
    global void onAfterPriceRules(SObject quote, List<SObject> quoteLines) {
        System.debug('🚀 CustomQuoteCalculatorPlugin: onAfterPriceRules started for Quote Id: ' + quote.Id);
      //  updatingparentpriceoncomboselection(quote,quoteLines);
    }
	global void onBeforeCalculate(SObject quote, List<SObject> quoteLines) {
         System.debug('🚀 CustomQuoteCalculatorPlugin: onBeforeCalculate started for Quote Id: ' + quote.Id );
        System.debug('SObject quote: ' + quote);
        System.debug('quoteLines: ' + quoteLines);
       // updatingpriceusingpricematrix(quote,quoteLines);
        updatingpriceusingpricematrixv2(quote,quoteLines);
        updatingparentpriceoncomboselection(quote,quoteLines);
    }

    // Core logic- for implementing price matrix for unit price change
    global void onAfterCalculate(SObject quote, List<SObject> quoteLines) {
       System.debug('🚀 CustomQuoteCalculatorPlugin: onAfterCalculate started for Quote Id: ' + quote.Id );
		for (SObject sobj : quoteLines) {
            SBQQ__QuoteLine__c ql = (SBQQ__QuoteLine__c) sobj;
            if (ql.SBQQ__Quantity__c > ql.Available_Qty__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please check your inputs.'));
                //throw new AuraHandledException('Error: Please check your inputs.');
            }
        }
	
    }



    global void onBeforeSave(SObject quote, List<SObject> quoteLines) {
        System.debug('🚀 onBeforeSave CustomQuoteCalculatorPlugin:');
    }
    global void onAfterSave(SObject quote, List<SObject> quoteLines) {
        System.debug('🚀 onBeforeSave CustomQuoteCalculatorPlugin:');
    }
    
       
    global void updatingparentpriceoncomboselection(SObject quote, List<SObject> quoteLines){
        System.debug('===================inside updatingparentpriceoncomboselection method ===================');
        Set<Id> QLIids = New Set<Id>();
        integer i=0;
        Map<Id, SBQQ__QuoteLine__c> qlMap = new Map<Id, SBQQ__QuoteLine__c>();
        for (SObject s : quoteLines) {
            qlMap.put(((SBQQ__QuoteLine__c)s).Id, (SBQQ__QuoteLine__c)s);
            if(((SBQQ__QuoteLine__c)s).SBQQ__Bundle__c == false && ((SBQQ__QuoteLine__c)s).Id !=null){
            QLIids.add(((SBQQ__QuoteLine__c)s).Id);
            }
        }
        system.debug('QLIids============='+QLIids);
        Map<Id,SBQQ__QuoteLine__c> qliidtomap = New Map<Id,SBQQ__QuoteLine__c>([Select Id,SBQQ__RequiredBy__c,Feature_Name__c from SBQQ__QuoteLine__c where ID IN:QLIids]);
        system.debug('=====qliidtomap============='+qliidtomap);
        // Find all parent quote line IDs that need update
        Set<Id> parentIds = new Set<Id>();
        for (SObject s : quoteLines) {
            i+=1;
            system.debug('values of i='+ i);
            SBQQ__QuoteLine__c child = (SBQQ__QuoteLine__c)s;
            if(child.SBQQ__Bundle__c == false && child.id !=null){
                
               // system.debug('child.SBQQ__RequiredBy__c'+child.SBQQ__RequiredBy__c );
                  //      system.debug('-----qliidtomap.get(child.id).Feature_Name__c:'+qliidtomap.get(child.id).Feature_Name__c);
               // system.debug('child.Feature_Name__c'+child.Feature_Name__c );
               
                 //system.debug('-----qliidtomap.get(child.id).Feature_Name__c:'+qliidtomap.get(child.id).SBQQ__RequiredBy__c);
                if (child.SBQQ__RequiredBy__c != null &&
                    qliidtomap.get(child.id).Feature_Name__c == System.label.CPQ_Combo_Product_Name ) {    
                        system.debug('child.SBQQ__RequiredBy__c'+child.SBQQ__RequiredBy__c );
                        system.debug('-----qliidtomap.get(child.id).Feature_Name__c:'+qliidtomap.get(child.id).Feature_Name__c);
                        parentIds.add(child.SBQQ__RequiredBy__c);
                    }
               
            }
        }
        system.debug('--parentIds:'+parentIds);
        for (Id parentId : parentIds) {
            if (qlMap.containsKey(parentId)) {
                SBQQ__QuoteLine__c parent = qlMap.get(parentId);
                parent.SBQQ__ListPrice__c = 0;   
                // parent.SBQQ__ListPrice__c = 0;  
                // parent.SBQQ__RegularPrice__c = 0;
            }
        }
        
        
    }
    
     global void updatingpriceusingpricematrix(SObject quote, List<SObject> quoteLines){
        System.debug('===================inside updatingpriceusingpricematrix method ===================');
       // date currentdate = system.today();
         
            SBQQ__Quote__c quoterec = [select id,SBQQ__Account__c,SBQQ__Account__r.ParentId from SBQQ__Quote__c where id=:quote.Id ];
        id accountid = quoterec.SBQQ__Account__c;
        id parentaccid= quoterec.SBQQ__Account__r.ParentId;
        if (quoteLines == null || quoteLines.isEmpty()) {
            System.debug('⚠️ No quote lines found.');
            return;
        }
        
        Set<Id> productIds = new Set<Id>();
        integer i=0;
       
        // Collect product IDs from quote lines
      /*  for (SObject sobj : quoteLines) {
            
            SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c) sobj;
            if (line.SBQQ__Product__c != null) {
                productIds.add(line.SBQQ__Product__c);
            }
        }

        if (productIds.isEmpty()) return;

        // Query Product Matrix data for relevant products
         Map<Id, Pricing_Matrix__c> productMatrixMap = new Map<Id, Pricing_Matrix__c>(
            [SELECT Id,
                Product__c,
                Location_Based_NET_Price__c,
                Customer_Based_NET_Price__c,
                Location_Based_Product_Discount__c,
                Customer_Based_Product_Discount__c,
                Location_Based_Product_Sub_Cat_Discount__c,
                Customer_Based_Product_Sub_Cat_Discount__c,
                Location_Based_Product_Category_Discount__c,
                Customer_Based_Product_Category_Discount__c
             FROM Pricing_Matrix__c
             WHERE Product__c IN :productIds AND Active__c =true]
        );
		system.debug('productMatrixMap:'+productMatrixMap);*/
        // Apply pricing logic
        for (SObject sobj : quoteLines) {
            i+=1;
            system.debug('values of i='+ i);
            Decimal calculatedNetPrice;
            Decimal calculatedDiscount;
            list<Pricing_Matrix__c> pmlist = new list<Pricing_Matrix__c> ();
            SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c) sobj;
			system.debug('((SBQQ__QuoteLine__c)s).Id'+ line.Id);
           // string query = 'SELECT Id,Product__c,NET_Price__c,Product_Discount__c,Product_Sub_Category_Discount__c,Product_Category_Discount__c FROM Pricing_Matrix__c WHERE Product__c =:'+ line.SBQQ__Product__c +' AND Active__c =true AND Valid_Till__c <=:system.today()';
            if(parentaccid != null){
              // query += 'AND (Customer_Account__c=:'+accountid + 'OR Parent_Account__c=:'+parentaccid+ ')';
              system.debug('here in if');
              pmlist = [SELECT Id,Parent_Account__c,Customer_Account__c,
                      Product__c,
                      NET_Price__c,
                      Product_Discount__c,
                      Product_Sub_Category_Discount__c,
                      Product_Category_Discount__c
                      FROM Pricing_Matrix__c
                      WHERE Product__c =:line.SBQQ__Product__c 
                      AND Active__c =true 
                      AND Valid_Till__c >=:system.today() 
                      AND ( Customer_Account__c=:accountid OR Parent_Account__c=:parentaccid)];
            }
            else{
             //  query +='AND Customer_Account__c=:'+accountid;
			system.debug('here in else');
             pmlist = [SELECT Id,Parent_Account__c,Customer_Account__c,
                      Product__c,
                      NET_Price__c,
                      Product_Discount__c,
                      Product_Sub_Category_Discount__c,
                      Product_Category_Discount__c
                      FROM Pricing_Matrix__c
                      WHERE Product__c =:line.SBQQ__Product__c 
                      AND Active__c =true 
                      AND Valid_Till__c >=:system.today() 
                      AND Customer_Account__c=:accountid];
            }
            
			 system.debug('pmlist:'+pmlist.size());
            if (pmlist.size()>0 && line.Id !=null){
                
               // Pricing_Matrix__c pm = pmlist[0];
                system.debug('pmlist:'+pmlist);
                //calculatedNetPrice = line.SBQQ__ListPrice__c != null ? line.SBQQ__ListPrice__c : 0;
                Pricing_Matrix__c locationMatrix;
                Pricing_Matrix__c parentMatrix;
                
                for (Pricing_Matrix__c pmrec : pmlist) {
                    
                    if (pmrec.Customer_Account__c == accountId) {
                        locationMatrix = pmrec;
                    }
                    if (pmrec.Parent_Account__c == parentAccId) {
                        parentMatrix = pmrec;
                    }
                }
                
                // ---------- Waterfall Logic ----------
                if (locationMatrix != null && locationMatrix.NET_Price__c != null ) {
                    calculatedNetPrice = locationMatrix.NET_Price__c;
                    
                } else if (parentMatrix != null && parentMatrix.NET_Price__c != null) {
                    calculatedNetPrice = parentMatrix.NET_Price__c;
                    
                } else if (locationMatrix != null && locationMatrix.Product_Discount__c != null) {
                    calculatedDiscount = locationMatrix.Product_Discount__c;
                    
                } else if (parentMatrix != null && parentMatrix.Product_Discount__c != null) {
                    calculatedDiscount = parentMatrix.Product_Discount__c;
                    
                } else if (locationMatrix != null && locationMatrix.Product_Sub_Category_Discount__c != null) {
                    calculatedDiscount = locationMatrix.Product_Sub_Category_Discount__c;
                    
                } else if (parentMatrix != null && parentMatrix.Product_Sub_Category_Discount__c != null) {
                    calculatedDiscount = parentMatrix.Product_Sub_Category_Discount__c;
                    
                } else if (locationMatrix != null && locationMatrix.Product_Category_Discount__c != null) {
                    calculatedDiscount = locationMatrix.Product_Category_Discount__c;
                    
                } else if (parentMatrix != null && parentMatrix.Product_Category_Discount__c != null) {
                    calculatedDiscount = parentMatrix.Product_Category_Discount__c;
                }
            }
            system.debug('calculatedNetPrice:'+calculatedNetPrice);
            system.debug('calculatedDiscount:'+calculatedDiscount);
            
            // ---------- Apply to Quote Line ----------
            if (calculatedNetPrice != null) {
                // Direct NET price override
                // line.SBQQ__NetPrice__c = calculatedNetPrice;
                line.SBQQ__ListPrice__c =calculatedNetPrice;
                //line.SBQQ__Discount__c = 0;
            } else if (calculatedDiscount != null) {
                // Apply discount %
                line.SBQQ__Discount__c = calculatedDiscount;
            } else {
                // No pricing data found — leave defaults
                line.SBQQ__ListPrice__c=line.SBQQ__ListPrice__c;
                line.SBQQ__Discount__c=line.SBQQ__Discount__c;
                
            }
        }
        
    }
    
    global void updatingpriceusingpricematrixv2( SObject quote,List<SObject> quoteLines){
        System.debug('=== updatingpriceusingpricematrix START ===');
        Set<String> subCategorySet = new Set<String>();
        Set<String> categorySet = new Set<String>();
        
        if (quoteLines == null || quoteLines.isEmpty()) {
            return;
        }
        
        // ---------------- QUOTE ----------------
        SBQQ__Quote__c quoteRec = [ SELECT Id, SBQQ__Account__c,  SBQQ__Account__r.ParentId FROM SBQQ__Quote__c WHERE Id = :quote.Id];
        
        Id accountId   = quoteRec.SBQQ__Account__c;
        Id parentAccId = quoteRec.SBQQ__Account__r.ParentId;
        
        // ---------------- PRODUCTS ----------------
        Set<Id> productIds = new Set<Id>();
        for (SObject sobj : quoteLines) {
            SBQQ__QuoteLine__c ql = (SBQQ__QuoteLine__c) sobj;
            if (ql.SBQQ__Product__c != null) {
                productIds.add(ql.SBQQ__Product__c);
            }
        }
        if (productIds.isEmpty()) return;
        
        // ---------------- PRODUCT METADATA ----------------
        Map<Id, Product2> productMap = new Map<Id, Product2>(
            [SELECT Id, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c, APTS_Mat_Grp_3_Catgr_CD__c FROM Product2 WHERE Id IN :productIds]);
        
        
        //--------------Sets for Sub-Category & Category --------------
        for (Product2 p : productMap.values()) {
            if (p.APTS_Mat_Grp_3_Catgr_CD__c != null) {subCategorySet.add(p.APTS_Mat_Grp_3_Catgr_CD__c);}
            
            if (p.APTS_Mat_Grp_1_CIT__c != null) {
                categorySet.add(p.APTS_Mat_Grp_1_CIT__c);
            }
        }
        
        // ---------------- PRICING MATRIX QUERY----------------
        List<Pricing_Matrix__c> matrixList = [
            SELECT Id,
            Customer_Account__c,
            Parent_Account__c,
            Product__c,
            Product_Category_CIT__c,
            Product_Sub_Category__c,
            Product_Catalog__c,
            NET_Price__c,
            Product_Discount__c,
            Product_Sub_Category_Discount__c,
            Product_Category_Discount__c
            FROM Pricing_Matrix__c
            WHERE Active__c = true
            AND Valid_Till__c >= :System.today()
            AND (
                Product__c IN :productIds
                OR Product_Sub_Category__c IN :subCategorySet
                OR Product_Category_CIT__c IN :categorySet
            )
            AND (
                Customer_Account__c = :accountId
                OR Parent_Account__c   = :parentAccId
            )
        ];
        
        // ---------------- APPLY PRICING ----------------
        for (SObject sobj : quoteLines) {
            
            SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c) sobj;
           
            Product2 prod = productMap.get(line.SBQQ__Product__c);
            
            Pricing_Matrix__c custProdN, parentProdN;
            Pricing_Matrix__c custProdD, parentProdD;
            Pricing_Matrix__c custSubCat, parentSubCat;
            Pricing_Matrix__c custCat, parentCat;
            
            // -------- CLASSIFY MATRIX Records --------
            for (Pricing_Matrix__c pm : matrixList) {
                
                if (pm.Product__c == line.SBQQ__Product__c) {
                    if (pm.Customer_Account__c == accountId && pm.NET_Price__c != null){
                        custProdN = pm;
                    }
                    else if(pm.Customer_Account__c == accountId && pm.Product_Discount__c != null){
                        custProdD = pm;
                    }
                        
                    else if (pm.Parent_Account__c == parentAccId && pm.NET_Price__c != null){
                        parentProdN = pm;
                    } 
                    else if (pm.Parent_Account__c == parentAccId && pm.Product_Discount__c != null){
                        parentProdD = pm;
                    }
                }
                
                else if (pm.Product_Sub_Category__c != null && pm.Product_Sub_Category__c == prod.APTS_Mat_Grp_3_Catgr_CD__c) {
                    
                    if (pm.Customer_Account__c == accountId){
                        custSubCat = pm;
                    }
                        
                    else if (pm.Parent_Account__c == parentAccId){
                        parentSubCat = pm;
                    }
                        
                }
                
                else if (pm.Product_Category_CIT__c != null && pm.Product_Category_CIT__c == prod.APTS_Mat_Grp_1_CIT__c && pm.Product_Catalog__c == prod.APTS_Mat_Grp_2_Catlg__c) {
                    if (pm.Customer_Account__c == accountId){
                        custCat = pm;
                    }
                    
                    else if (pm.Parent_Account__c == parentAccId){
                        parentCat = pm;
                    }
                    
                }
            }
            
            Decimal netPrice;
            Decimal discount;
            
            // -------- WATERFALL --------
            
            if (custProdN != null && custProdN.NET_Price__c != null) {
                netPrice = custProdN.NET_Price__c;     
            } 
            else if (parentProdN != null && parentProdN.NET_Price__c != null) {
                netPrice = parentProdN.NET_Price__c;
            }
            else if (custProdD != null && custProdD.Product_Discount__c != null) {
                discount = custProdD.Product_Discount__c;
            } 
            else if (parentProdD != null && parentProdD.Product_Discount__c != null) {
                discount = parentProdD.Product_Discount__c;
            }
            else if (custSubCat != null && custSubCat.Product_Sub_Category_Discount__c != null) {
                discount = custSubCat.Product_Sub_Category_Discount__c;  
            } 
            else if (parentSubCat != null && parentSubCat.Product_Sub_Category_Discount__c != null) {
                discount = parentSubCat.Product_Sub_Category_Discount__c;
            }
            else if (custCat != null && custCat.Product_Category_Discount__c != null) {
                discount = custCat.Product_Category_Discount__c;
            } 
            else if (parentCat != null && parentCat.Product_Category_Discount__c != null) {
                discount = parentCat.Product_Category_Discount__c;
            }
            
            // -------- APPLY TO QLI --------
            if (netPrice != null) {
                line.SBQQ__ListPrice__c = netPrice;
                line.SBQQ__Discount__c  = 0;
                
            } else if (discount != null) {
                line.SBQQ__Discount__c = discount;
            }
        }
        
        System.debug('=== updatingpriceusingpricematrix END ===');
    }
    
    
    
    
    
}
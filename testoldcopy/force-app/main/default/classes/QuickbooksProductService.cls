public class QuickbooksProductService {
    
  /*    @future(callout=true) 
    public static void createiteminQBO(set<Id> productIdSet) {
         String response;
        try{
            Map<Id, Product2> productIdMap = new Map<Id, Product2>();
            List<Product2> updateProduct2List = new List<Product2>();
            QuickbooksItemWrapper itemBatch= new QuickbooksItemWrapper();
            List<QuickbooksItemWrapper.BatchItemRequest> listBatchItemreq = new List<QuickbooksItemWrapper.BatchItemRequest>();
            for(Product2 productRec : [SELECT Id, QBO_Item_Id__c, Name, Description, ProductCode, DisplayUrl, Family, IsActive FROM Product2 where id IN:productIdSet AND QBO_Item_Id__c = null]) {
                productIdMap.put(productRec.Id, productRec);
                QuickbooksItemWrapper.BatchItemRequest batchitemrequest = new QuickbooksItemWrapper.BatchItemRequest();
                batchitemrequest.Item = new QuickbooksItemWrapper.QBOItem(productRec);
                batchitemrequest.operation='create';
                batchitemrequest.bId = String.valueof(productRec.Id);
                listBatchItemreq.add(batchitemrequest);
            }
            itemBatch.BatchItemRequest = listBatchItemreq;
            String JsonString = Json.serialize(itemBatch);
            System.debug('ProductJsonString'+JsonString);
            
            response = QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch?minorversion=4', 'POST');  
            System.debug('Productresponse'+response);
            if(response != null) {
                QuickbooksBatchResponse responseJsonBatch = (QuickbooksBatchResponse)JSON.deserialize(response, QuickbooksBatchResponse.class);
                if(responseJsonBatch.BatchItemResponse != null) {
                    for(QuickbooksBatchResponse.BatchItemResponse b: responseJsonBatch.BatchItemResponse) {
                        if(Test.isRunningTest()) b.bId = listBatchItemreq[0].bId;
                        if(productIdMap.get(b.bId) != null){
                            Product2 product = new Product2(id = b.bId);
                            product.QBO_Item_Id__c = b.Item.Id;  
                            //product.QBO_SyncToken__c = b.Item.synctoken;
                            updateProduct2List.add(product);
                        }
                    }
                }
                if(!updateProduct2List.isEmpty()){
                    update updateProduct2List;
                   
                    
                }
            }
        }catch(Exception e){
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksProductService', 'createiteminQBO', LogUtil.ERROR, productIdSet.toString(), 
                                                    null, response, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
        LogUtil.insertLogs();
     
    }
    
    //checking of items in qbo 
    public static map<id,string> QueryitemQBO(set<Id> productIdSet) { 
        
        system.debug('QueryitemQBO');
        map<id,string> skuidtoqboid= new map<id,string>(); 
        try{
       String query = 'SELECT * FROM Item WHERE Sku IN (\'' + String.join(new List<Id>(productIdSet), '\',\'') + '\')';
            query = EncodingUtil.urlEncode(query, 'UTF-8').replaceAll('\\+','%20');
            HttpResponse res = QuickbooksSendRequestAndRecieveResponse.getRequest('query?query='+query+'&minorversion=4');
            if(res.getStatusCode() == 200){
                system.debug('== res.getBody() ==' + res.getBody());
                QBOQueryResponse qboResult = (QBOQueryResponse) System.JSON.deserialize(res.getBody(), QBOQueryResponse.class);
                if(qboResult.QueryResponse != null && qboResult.QueryResponse.Item != null && !qboResult.QueryResponse.Item.isEmpty()) {
                    List<QBOQueryResponse.QuickBooksEntityItem> itemList = qboResult.QueryResponse.Item;
                    for(QBOQueryResponse.QuickBooksEntityItem qboItem : itemList) {
                        if(productIdSet.contains(qboItem.sku)){
                        skuidtoqboid.put(qboItem.sku,qboItem.id);
                        }
                    }
                }
            }
             }catch(Exception e){
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksProductService', 'QueryitemQBO', LogUtil.ERROR, productIdSet.toString(), 
                                                    null, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
        LogUtil.insertLogs();
        system.debug('skuidtoqboid'+skuidtoqboid);
        return skuidtoqboid;
    }
            
   // create product in QBO
    public static map<id,string> NewitemcreationinQBO(set<Id> productIdSet) {
        system.debug('NewitemcreationinQBO');
         String response;
        map<id,string> prdSfidtoqboid= new map<id,string>(); 
        
        try{
            
            Map<Id, Product2> productIdMap = new Map<Id, Product2>();
            List<Product2> updateProduct2List = new List<Product2>();
            QuickbooksItemWrapper itemBatch= new QuickbooksItemWrapper();
            List<QuickbooksItemWrapper.BatchItemRequest> listBatchItemreq = new List<QuickbooksItemWrapper.BatchItemRequest>();
            for(Product2 productRec : [SELECT Id, QBO_Item_Id__c, Name, Description, ProductCode, DisplayUrl, Family, IsActive FROM Product2 where id IN:productIdSet AND QBO_Item_Id__c = null]) {
                productIdMap.put(productRec.Id, productRec); 
                QuickbooksItemWrapper.BatchItemRequest batchitemrequest = new QuickbooksItemWrapper.BatchItemRequest();
                batchitemrequest.Item = new QuickbooksItemWrapper.QBOItem(productRec);
                batchitemrequest.operation='create';
                batchitemrequest.bId = String.valueof(productRec.Id);
                listBatchItemreq.add(batchitemrequest);
            }
            itemBatch.BatchItemRequest = listBatchItemreq;
            String JsonString = Json.serialize(itemBatch);
            System.debug('NewitemcreationinQBOJSONSTRING'+JsonString);
            
            response = QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch?minorversion=4', 'POST');  
            System.debug('NewitemcreationinQBOResponse'+response);
            if(response != null) {
                QuickbooksBatchResponse responseJsonBatch = (QuickbooksBatchResponse)JSON.deserialize(response, QuickbooksBatchResponse.class);
                if(responseJsonBatch.BatchItemResponse != null) {
                    for(QuickbooksBatchResponse.BatchItemResponse b: responseJsonBatch.BatchItemResponse) {
                        if(Test.isRunningTest()) b.bId = listBatchItemreq[0].bId;
                        if(productIdMap.get(b.bId) != null){
                           // Product2 product = new Product2(id = b.bId);
                           // product.QBO_Item_Id__c = b.Item.Id;  
                            //product.QBO_SyncToken__c = b.Item.synctoken;
                            prdSfidtoqboid.put(b.bId, b.Item.Id);
                        }
                    }
                }
                
            }
            
        }catch(Exception e){
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksProductService', 'NewitemcreationinQBO', LogUtil.ERROR, productIdSet.toString(), 
                                                    null, response, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
        LogUtil.insertLogs();

        
       return prdSfidtoqboid; 
    }*/

}
/**
 * @description       : 
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 12-29-2025;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
public with sharing class SendOrderToSAPController {

    @AuraEnabled
    public static string checkForDuplicates(Id orderId){
        Map<String, Object> retResp = new Map<String, Object>();
        /* List<Apttus_Config2__Order__c> orderInfoList = [Select Id,name,Apttus_Config2__PONumber__c from Apttus_Config2__Order__c 
                                              where Id =: orderId];
        List<Apttus_Config2__Order__c> checkDuplicateOrders = [Select Id,name,Apttus_Config2__PONumber__c from Apttus_Config2__Order__c 
                                            where Apttus_Config2__PONumber__c =: orderInfoList[0].Apttus_Config2__PONumber__c and Id !=: orderId]; */
        List<Order> orderInfoList = [Select Id,OrderNumber,PoNumber from Order 
                                            where Id =: orderId];
        List<Order> checkDuplicateOrders = [Select Id,OrderNumber,PoNumber from Order 
                                            where PoNumber =: orderInfoList[0].PoNumber and Id !=: orderId];
        
        if(checkDuplicateOrders.size() > 0)
        {
            retResp.put('duplicateOrderFound', true);
            retResp.put('duplicateOrderName', 'O-'+checkDuplicateOrders[0].OrderNumber);
            retResp.put('duplicateOrderId', checkDuplicateOrders[0].Id);
        }
        else {
            retResp.put('duplicateOrderFound', false);
        }

        return JSON.serialize(retResp);
    }

    @AuraEnabled
    public static string sendOrderToSAP(Id orderId){
        Map<String, Object> retResp = new Map<String, Object>();
        List<Order> orderInfoList = [Select Id,OrderNumber,PoNumber,Sales_Order_Type__c,Freight_Terms__c,ST_SAP_SO_Number__c from Order 
                                            where Id =: orderId];
        String errorMsgCollated = ''; Boolean validationSuccess = true;
        if (String.isNotBlank(orderInfoList[0].ST_SAP_SO_Number__c)) {
            retResp.put('success', false);
            retResp.put('responseMessage', 'Order already sent to SAP. SAP Order Number: '+orderInfoList[0].ST_SAP_SO_Number__c);
            return JSON.serialize(retResp);
        }
        if (String.isBlank(orderInfoList[0].Sales_Order_Type__c)) {
            retResp.put('success', false);
            validationSuccess = false;
            errorMsgCollated = 'Sales Order Type';
            retResp.put('responseMessage', errorMsgCollated+' is Required.');
        }
        if (String.isBlank(orderInfoList[0].PoNumber)) {
            retResp.put('success', false);
            validationSuccess = false;
            errorMsgCollated = String.isBlank(errorMsgCollated) ? 'PO Number':errorMsgCollated+', PO Number';
            retResp.put('responseMessage', errorMsgCollated+' is Required.');
        }
        if (String.isBlank(orderInfoList[0].Freight_Terms__c)) {
            retResp.put('success', false);
            validationSuccess = false;
            errorMsgCollated = String.isBlank(errorMsgCollated) ? 'Freight Terms':errorMsgCollated+', Freight Terms';
            retResp.put('responseMessage', errorMsgCollated+' is Required.');
        }
        if(validationSuccess == false){
            return JSON.serialize(retResp);
        }
        HttpResponse response;
        
        List<Order_Error_Queue__c> toUpsertOEQList = new List<Order_Error_Queue__c>();
        try {
            
            SAP_Order_Integration_Settings__c config = [Select Id,Mulesoft_Client_Id__c, Mulesoft_Client_Secret__c, Order_Endpoint_Url__c 
                                          from SAP_Order_Integration_Settings__c where Name = 'Mulesoft Integration'];
            String endpoint = config.Order_Endpoint_Url__c;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint+'/'+orderId);
            request.setMethod('POST');
            request.setHeader('client_id', config.Mulesoft_Client_Id__c);
            request.setHeader('client_secret', config.Mulesoft_Client_Secret__c);
            response = http.send(request);
            System.debug('HTTPResponse-->' + response);

            Map<String, Object> responseJsonMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('responseJsonMap>>>>>'+responseJsonMap);

            if (response.getStatusCode() != 200) {
                retResp.put('success', false);
                retResp.put('responseMessage', (String)responseJsonMap.get('errorType')+' : '+(String)responseJsonMap.get('errorDescription'));
                Order_Error_Queue__c oeq = new Order_Error_Queue__c();
                //oeq.APTSOrder__c = orderId;
                oeq.Order__c = orderId;
                oeq.External_Id__c = orderId;
                oeq.Error_Message__c = (String)responseJsonMap.get('errorType')+' : '+(String)responseJsonMap.get('errorDescription');
                toUpsertOEQList.add(oeq);
            }
            else {
            
                //String respjson = '{"response":{"message":"Message queued for processing on SAP - O-00000057","soNumber":"","statusCode":200}}';
                //Map<String, Object> responseJsonMap = (Map<String, Object>)JSON.deserializeUntyped(respjson);
                Map<String, Object> responseObj = (Map<String, Object>)responseJsonMap.get('response');
                //System.debug('responseJsonMap>>>>>'+responseJsonMap);

                
                if((Integer)responseObj.get('statusCode') == 200)
                {
                    if(String.isNotBlank((String)responseObj.get('soNumber')))
                    {
                        retResp.put('success', true);
                        retResp.put('responseMessage', 'Order was successfully sent to SAP. SAP Order Number: '+(String)responseObj.get('soNumber'));
                        List<Order_Error_Queue__c> oeqToDelList = [Select Id from Order_Error_Queue__c where Order__c =: orderId];
                        if(oeqToDelList.size() > 0)
                        {
                            delete oeqToDelList;
                        }
                    }
                    else {
                        retResp.put('success', false);
                        retResp.put('responseMessage', (String)responseObj.get('message')+' - Order Added to Error Queue');

                        Order_Error_Queue__c oeq = new Order_Error_Queue__c();
                        //oeq.APTSOrder__c = orderId;
                        oeq.Order__c = orderId;
                        oeq.External_Id__c = orderId;
                        oeq.Error_Message__c = (String)responseObj.get('message');
                        toUpsertOEQList.add(oeq);
                    }
                }
                
                if((Integer)responseObj.get('statusCode') == 400)
                {
                    retResp.put('success', false);
                    retResp.put('responseMessage', (String)responseObj.get('name')+' - '+(String)responseObj.get('message')+' - Order Added to Error Queue');
                    
                    Order_Error_Queue__c oeq = new Order_Error_Queue__c();
                    //oeq.APTSOrder__c = orderId;
                    oeq.Order__c = orderId;
                    oeq.External_Id__c = orderId;
                    oeq.Error_Message__c = (String)responseObj.get('name')+' - '+(String)responseObj.get('message');
                    toUpsertOEQList.add(oeq);
                }
            }
            
        }
        catch (Exception e) {
            retResp.put('success', false);
            retResp.put('responseMessage', e.getMessage()+' - Order Added to Error Queue');
            System.debug('Exception caught in SendOrderToSAPController.sendOrderToSAP: ' + e.getMessage());
            System.debug(e.getLineNumber());
        }

        if(toUpsertOEQList.size() > 0)
        {
            Database.upsert(toUpsertOEQList,Order_Error_Queue__c.External_Id__c.getDescribe().getSObjectField(), false);
        }

        return JSON.serialize(retResp);
    }
}
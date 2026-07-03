public class Saporder{
    
    @future (callout=true)
    public static void sendorderInfo(set<string> orderids) {
        
        try{
            list<SAP_Order_Integration_Settings__c> SAP_Order_Integration_Settings = new list<SAP_Order_Integration_Settings__c>();
            SAP_Order_Integration_Settings = [select id,Order_Endpoint_Url__c, Order_X_IBM_Client_Id__c
                                              from SAP_Order_Integration_Settings__c];        
            list<Apttus_Config2__Order__c> orders = new list<Apttus_Config2__Order__c>();
            map<id,Apttus_Config2__Order__c> ordersmap;
            ordersmap = new map<id,Apttus_Config2__Order__c>([select id, Sap_api_message__c from Apttus_Config2__Order__c where id IN :orderids]);
            
            for(string oid : orderids){
                
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                
                //request.setEndpoint(SAP_Order_Integration_Settings[0].Order_Endpoint_Url__c+oid);
                
                
                /*request.setHeader('X-IBM-Client-Id',SAP_Order_Integration_Settings[0].Order_X_IBM_Client_Id__c); */
                //string body = '{ "Username" : '+SAP_Order_Integration_Settings[0].Order_Username__c+', "Password" :'+SAP_Order_Integration_Settings[0].Order_Password__c+'}';
                
             request.setEndpoint('callout:OrderCredentails/'+ oid);
       
                
                request.setMethod('GET');
                //request.setCompressed(true);
                
                response = http.send(request);
                
                if (response.getStatusCode() == 200 || response.getStatusCode() == 204) {
                    
                    OrderData od = new OrderData();
                    od = OrderData.parse(response.getBody());
                    
                    System.debug('statusCode-' + od.error.statusCode);
                    System.debug('message-' + od.error.message);
                    System.debug('name-' + od.error.name);
                    
                    Apttus_Config2__Order__c o = ordersmap.get(oid);
                    String msg = od.Error.message;                   
                    o.Sap_api_message__c = msg;
                    
                    orders.add(o);
                    
                    System.debug('Response-' + response);
                    System.debug('Response Body-' + response.getBody());
                    
                }
                
                if(response.getStatusCode() == 400){
                    Integer statusCode;
                    String message;
                    String name;
                    orderdataerror400 od400 = new orderdataerror400();
                    od400 = orderdataerror400.parse(response.getBody());
                    
                    System.debug('statusCode-' + od400.error.statusCode);
                    System.debug('message-' + od400.error.message);
                    System.debug('name-' + od400.error.name);
                    
                    Apttus_Config2__Order__c o = ordersmap.get(oid);
                    String msg = od400.error.message;                   
                    o.Sap_api_message__c = msg;
                    
                    orders.add(o);
                    
                }                
                
            }
            
            if(orders.size()> 0){
                update orders;
            }
            
        }
        catch(System.CalloutException e){
            System.debug('Error-' + e.getMessage());   
        }
    }
    
}
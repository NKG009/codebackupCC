/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to Call SAP REST API
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* @created        3/24/2023
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class InventoryCallout {
    list<SAP_Order_Integration_Settings__c> SAP_Order_Integration_Settings = new list<SAP_Order_Integration_Settings__c>();
    String response;
    public String callInventory(string MTRNUMBER, String METHOD){
        try{
            SAP_Order_Integration_Settings = [select id,Inventory_Endpoint_Url__c, X_IBM_Client_Id__c from SAP_Order_Integration_Settings__c];            
            
            String endPoint = SAP_Order_Integration_Settings[0].Inventory_Endpoint_Url__c;
            endPoint+='MTRNUMBER='+MTRNUMBER+'&METHOD='+METHOD;            
            HttpRequest httpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            Http http = new Http();
            httpReq.setHeader('X-IBM-Client-Id', SAP_Order_Integration_Settings[0].X_IBM_Client_Id__c);
            httpReq.setMethod('GET');
            httpReq.setEndPoint(endPoint);
            httpReq.setTimeout(120000); 
            httpRes = http.send(httpReq);
            system.debug(httpRes.getStatusCode()+'&&&&&&'+httpRes+'******');
            if(httpRes.getStatusCode() == 200){
                system.debug('Response********'+httpRes.getBody());
                response = httpRes.getBody();
            }
            return response;
            
        }Catch(Exception e){
            system.debug('Error Message From Inventory Integration********'+e.getmessage());
            return null;
        }
        
    }
}
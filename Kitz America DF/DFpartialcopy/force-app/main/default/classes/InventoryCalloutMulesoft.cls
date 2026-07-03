/**
 * @description       : This is Apex Class used to Call Mulesoft Inventory REST API
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 01-12-2026;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
public class InventoryCalloutMulesoft {
    list<SAP_Order_Integration_Settings__c> SAP_Order_Integration_Settings = new list<SAP_Order_Integration_Settings__c>();
    String response;
    public String callInventory(string MTRNUMBER, String METHOD){
        try{
            SAP_Order_Integration_Settings = [Select Id,Mulesoft_Client_Id__c, Mulesoft_Client_Secret__c, Inventory_Endpoint_Url__c from SAP_Order_Integration_Settings__c where Name = 'Mulesoft Integration'];            
            
            String endPoint = SAP_Order_Integration_Settings[0].Inventory_Endpoint_Url__c;
            endPoint+='MTRNUMBER='+MTRNUMBER+'&METHOD='+METHOD;            
            HttpRequest httpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            Http http = new Http();
            httpReq.setHeader('client_id', SAP_Order_Integration_Settings[0].Mulesoft_Client_Id__c);
            httpReq.setHeader('client_secret', SAP_Order_Integration_Settings[0].Mulesoft_Client_Secret__c);
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
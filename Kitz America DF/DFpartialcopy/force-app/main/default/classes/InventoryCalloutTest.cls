/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of InventoryCallout
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* @created        3/29/2023
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
private class InventoryCalloutTest {    
    static testMethod void testGETCallout() {
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = Testutility.createSAP_Order_Integration_Settings(true);
        InventoryCallout call = new InventoryCallout();
        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock()); 
        String strResp = call.callInventory('01K1A87063', 'ALL');
    }
}
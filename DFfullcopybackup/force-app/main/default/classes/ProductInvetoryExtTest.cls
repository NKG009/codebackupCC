/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of ProductInvetoryExt
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class ProductInvetoryExtTest {
    @isTest
    static void ProductInvetoryExTest(){
        Product2 prod = Testutility.createProduct();
        insert prod;
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = Testutility.createSAP_Order_Integration_Settings(true);
        InventoryCallout call = new InventoryCallout();
        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock()); 
        String strResp = call.callInventory('01K1A87063', 'ALL');
        
        test.startTest();        
        PageReference pageReference = Page.ProductInvetoryPage;
        Test.setCurrentPage(pageReference);        
        ApexPages.StandardController sc = new ApexPages.StandardController(prod);
        ProductInvetoryExt Obj = new ProductInvetoryExt(sc);
        Obj.close();
        Obj.getMockDataForRestockOrderAndETA();
        Obj.getMockDataForIndentETA();
        Obj.getMockDataForAllocation(); 
        Obj.Restocklst.clear();
        Obj.getMockDataForRestockOrderAndETA();
        Obj.restockmsg = true;
        Obj.Indentmsg = true; 
        Obj.Allocationmsg = true;        
        test.StopTest();
    }
    
   
}
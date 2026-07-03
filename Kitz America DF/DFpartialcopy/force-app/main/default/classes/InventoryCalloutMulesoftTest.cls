/**
 * @description       : Test Class for InventoryCalloutMulesoft
 * @author            : avinash_s@decisionfoundry.com
 * @group             : 
 * @last modified on  : 01-12-2026;
 * @last modified by  : avinash_s@decisionfoundry.com
**/
@isTest
public with sharing class InventoryCalloutMulesoftTest {
    static testMethod void testGETCallout() {
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = TestUtilityv2.createSAP_Order_Integration_Settings_Mulesoft(true);
        InventoryCalloutMulesoft call = new InventoryCalloutMulesoft();
        Test.setMock(HttpCalloutMock.class, new InventoryCalloutMock()); 
        String strResp = call.callInventory('01K1A87063', 'ALL');
    }
}
@isTest
public class AccountTriggerTest {
    @testSetup
    static void setup() {
        insert new Run_Rules__c(Run_Triggers__c = true);
        
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(
        	Name = 'Test Price List',
            vlocity_cmt__IsActive__c = true,
            vlocity_cmt__Code__c = '08832'
        );
        
        insert priceList;
        
        Default_Price_List_Setting__c setting = new Default_Price_List_Setting__c(
        	Name = 'SMB',
            Active__c = true,
            Price_List_Id__c = priceList.Id
        );
        
        insert setting;
    }
    
    @isTest
    static void testSetDefaultPriceList() {
        Account accountRecord = new Account(
        	Name = 'Test Price List',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        
        Test.startTest();
        
        insert accountRecord;
        
        Test.stopTest();
        
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c LIMIT 1];
        Account accountRecordResult = [SELECT Id, Price_List__c FROM Account WHERE Id = :accountRecord.Id];
        
        System.assertEquals(priceList.Id, accountRecordResult.Price_List__c);
    }
}
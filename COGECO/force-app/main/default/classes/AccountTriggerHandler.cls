public without sharing class AccountTriggerHandler {
    public static void setDefaultPriceList(List<Account> accountRecords) {
        if (accountRecords == null || accountRecords.isEmpty()) {
            return;
        }
        
        for (Account accountRecord : accountRecords) {
            if (String.isNotBlank(accountRecord.Price_List__c)) {
                continue;
            }
            
            String recordTypeDeveloperName = Schema.getGlobalDescribe().get(ApexConstants.ACCOUNT_OBJECT_API_NAME).getDescribe().getRecordTypeInfosById().get(accountRecord.RecordTypeId)?.getDeveloperName();
            Default_Price_List_Setting__c priceList = Default_Price_List_Setting__c.getInstance(recordTypeDeveloperName);
            
            if (priceList != null && priceList.Active__c) {
                accountRecord.Price_List__c = priceList.Price_List_Id__c;
            }
        }
    }
    
    public static void setDefaultValues(List<Account> accountRecords, Map<Id, Account> oldAccountRecords) {
        if (accountRecords == null || accountRecords.isEmpty()) {
            return;
        }
        
        for (Account accountRecord : accountRecords) {
            Account oldAccount = oldAccountRecords == null || oldAccountRecords.get(accountRecord.Id) == null ? new Account() : oldAccountRecords.get(accountRecord.Id);
            
            if (accountRecord.ShippingPostalCode != oldAccount.ShippingPostalCode || String.isBlank(accountRecord.Postal_Code_Unformatted__c)) {
                accountRecord.Postal_Code_Unformatted__c = accountRecord.ShippingPostalCode?.replace(' ', '').trim();
            }
        }
    }
}
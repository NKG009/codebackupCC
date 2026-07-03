@isTest
private class OwnershipNameUpdateServiceTest {
	
    @isTest
    static void testOwnershipNameUpdateService() {
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
        
        String companyName = 'Raine & Horne Lower North Shore - Willoughby';
        insert new Property_360_Company__c(Name = 'X1', Company_Name__c = companyName, Key__c = '726349-32423-234-2324');
        
        String realEstateRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Real Estate Office').getRecordTypeId();
        Account acc = new Account(Name = companyName, RecordTypeId = realEstateRecordTypeId);
        insert acc;
            
        OwnershipNameUpdateService.updateOwnershipNameByAccountId(acc.Id);
    }
}
@isTest
public class TombstoneControllerTest {
    static final String ACCOUNT_NAME = 'Test Account';
    
    @testSetup
    static void setup() {
        Account customerAccount = new Account(
            Name = ACCOUNT_NAME
        );
        insert customerAccount;
        
        insert new Account(
            Name = ACCOUNT_NAME,
            AccountNumber = '12345',
            ParentId = customerAccount.Id,
            RecordTypeId = ApexConstants.ACCOUNT_BILLING_RECORD_TYPE_ID,
            vlocity_cmt__Active__c = ApexConstants.ACCOUNT_ACTIVE_YES
        );
    }
    
    @isTest
    static void testGetTombstoneData() {
        
        
        Account accountRecord = [SELECT Id, Name FROM Account LIMIT 1];
        final String accountNameFieldApiName = 'Name';
        final String accountObjectApiName = 'Account';
 
        Set<String> fieldApiNames = new Set<String>{'TS_Account_Snapshot', 'TS_Services'};
        Set<Id>  accountId = new Set<Id>{accountRecord.Id};
            
        Test.startTest();
        AccountSelector.getAccountsForRollupProcessing(accountId);
        TombstoneDto tombstone = TombstoneController.getTombstoneData(accountObjectApiName, accountRecord.Id, accountNameFieldApiName, accountNameFieldApiName, accountNameFieldApiName);
        
        TombstoneService tombstoneService = new TombstoneService('Account');
        tombstoneService.setFieldApiNames(fieldApiNames);
        tombstoneService.addFieldApiNames(fieldApiNames);
        Set<String> result = tombstoneService.getFieldApiNames();
        
        TombstoneDto tombstoneDto = new TombstoneDto();
        tombstoneDto.highlightPhotoUrl = 'highlightPhotoUrl.com';
        tombstoneDto.subHighlightPhotoUrl = 'highlightPhotoUrl.com';
        
        TombstoneDto.TombstoneSection section = new TombstoneDto.TombstoneSection(accountObjectApiName, 'TestKey');
        
          List<TombstoneDto.TombstoneField> fields = new List<TombstoneDto.TombstoneField>{
        };
        section = new TombstoneDto.TombstoneSection('Test Section', fields);
        
        
        Test.stopTest();
        System.assertEquals(fieldApiNames, result);
        System.assertEquals(accountObjectApiName, tombstone.objectApiName);
        System.assertEquals(ACCOUNT_NAME, tombstone.spotlightValue);
    }
    
}
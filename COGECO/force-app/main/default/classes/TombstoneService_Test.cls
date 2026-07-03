@isTest
public class TombstoneService_Test {
    
    @isTest
    static void testTombstoneService() {
     
        /*
         Account accountSMBRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        */
        
        Set<String> fieldApiNames = new Set<String>{'TS_Account_Snapshot', 'TS_Services'};
            
        
      
        Test.startTest();
        TombstoneService tombstoneService = new TombstoneService('Account');
        tombstoneService.initializeTombstoneSettings();
        tombstoneService.getTombstoneFieldSettings();
        tombstoneService.getTombStoneSettings();
        tombstoneService.setFieldApiNames(fieldApiNames);
        tombstoneService.addFieldApiNames(fieldApiNames);
        Set<String> result = tombstoneService.getFieldApiNames();
        
        System.assertEquals(fieldApiNames, result);
        Test.stopTest();


      
    }

}
@isTest
private class GenericDataServiceTest {

    
    @isTest
    static void testGetGenericDataFromRecordId() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        
        String objectApiName = 'Account';
        Set<String> fieldApiNames = new Set<String>{'Name', 'Industry'};
        String filterRecordId = testAccount.Id;

        
        Test.startTest();
        SObject resultData = GenericDataService.getGenericDataFromRecordId(objectApiName, fieldApiNames, filterRecordId);
        Test.stopTest();

       
        System.assertNotEquals(null, resultData, 'Result should not be null');
        System.assertEquals(testAccount.Id, resultData.Id, 'Record ID should match');
        System.assertEquals(testAccount.Name, resultData.get('Name'), 'Name field should match');
        System.assertEquals(testAccount.Industry, resultData.get('Industry'), 'Industry field should match');
    }

    
    @isTest
    static void testGetGenericDataFromRecordIdWithDifferentParameters() {
        
        Contact testContact = new Contact(LastName = 'TestContact');
        insert testContact;

        
        String objectApiName = 'Contact';
        Set<String> fieldApiNames = new Set<String>{'LastName', 'Email'};
        String filterRecordId = testContact.Id;

        
        Test.startTest();
        SObject resultData = GenericDataService.getGenericDataFromRecordId(objectApiName, fieldApiNames, filterRecordId);
        Test.stopTest();

       
        System.assertNotEquals(null, resultData, 'Result should not be null');
        System.assertEquals(testContact.Id, resultData.Id, 'Record ID should match');
        System.assertEquals(testContact.LastName, resultData.get('LastName'), 'LastName field should match');
        System.assertEquals(testContact.Email, resultData.get('Email'), 'Email field should match');
    }
}
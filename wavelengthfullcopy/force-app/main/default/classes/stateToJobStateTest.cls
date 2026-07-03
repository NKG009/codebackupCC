@isTest
public class stateToJobStateTest {
@isTest
    static void testUpdatestate() {
        
        AVTRRT__Config_Settings__c config = new AVTRRT__Config_Settings__c();
        config.Name = 'Default';
        config.AVTRRT__Do_not_heck_Candidates_for_Duplicates__c = true;
        config.Update_DealSheet_Template_Job_Stages__c = 'Open;Offer Made;';
        insert config;
        
        Account account = new Account(Name = 'Test Account');
        insert account;

        List<AVTRRT__Job__c> testJobList = new List<AVTRRT__Job__c>();
        AVTRRT__Job__c job = new AVTRRT__Job__c(AVTRRT__Account_Job__c = account.Id);
        testJobList.add(job);

        insert testJobList;

        Test.startTest();
        updateAccAddToJobAddressHandler.updateAccountAddress(testJobList);
        Test.stopTest();

        List<AVTRRT__Job__c> updatedJobs = [SELECT Id, AVTRRT__Job_City__c, AVTRRT__State__c, AVTRRT__Country_Locale__c, AVTRRT__Street_Address__c, AVTRRT__Job_Postal_Code__c
                                           FROM AVTRRT__Job__c WHERE Id IN :testJobList];

        for (AVTRRT__Job__c updatedJob : updatedJobs) {
            System.assertEquals(updatedJob.AVTRRT__Job_City__c, account.ShippingCity);
            System.assertEquals(updatedJob.AVTRRT__State__c, account.ShippingState);
            System.assertEquals(updatedJob.AVTRRT__Country_Locale__c, account.ShippingCountry);
            System.assertEquals(updatedJob.AVTRRT__Street_Address__c, account.ShippingStreet);
            System.assertEquals(updatedJob.AVTRRT__Job_Postal_Code__c, account.ShippingPostalCode);
        }
        
        account.ShippingCity = 'kkk';
        update account;
    }
   
}
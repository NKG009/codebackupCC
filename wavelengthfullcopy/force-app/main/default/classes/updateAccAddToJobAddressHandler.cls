public class updateAccAddToJobAddressHandler {
    public static void updateAccountAddress(List<AVTRRT__Job__c> jobList){
      Set<Id> accountIds = new Set<Id>();
    for (AVTRRT__Job__c job : jobList) {
        if (job.AVTRRT__Account_Job__c != null) {
            accountIds.add(job.AVTRRT__Account_Job__c);
        }
    }
        List<Account> relatedAccounts = [SELECT Id, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
                                     FROM Account WHERE Id IN :accountIds];
        
        for (AVTRRT__Job__c job : jobList) {
        if (job.AVTRRT__Account_Job__c != null) {
            for (Account acc : relatedAccounts) {
                if (job.AVTRRT__Account_Job__c == acc.Id) {
                    job.AVTRRT__Job_City__c = acc.ShippingCity;
                    job.AVTRRT__State__c = acc.ShippingState;
                    job.AVTRRT__Country_Locale__c =  acc.ShippingCountry;
                    job.AVTRRT__Street_Address__c = acc.ShippingStreet;
                    job.AVTRRT__Job_Postal_Code__c = acc.ShippingPostalCode;
                }
            }
        }
    }
  }
}
public class OwnershipNameUpdateService {
    
    @AuraEnabled
	public static String updateOwnershipNameByAccountId(String accountId) {
        List<Account> accountList = [Select Id, Name, ExternalIdEncrypted__c FROM Account WHERE Id =: accountId AND RecordType.Name = 'Real Estate Office'];
        String errMsg = '';
        if(accountList.isEmpty()) {
            errMsg = 'Error - This action is available only for Real Estate offices.';
        } else {
            List<Property_360_Company__c> companies = getP360CompanyDetailByRealEstateAccount(accountList[0]);
            Boolean isSuccess = false;
            if(!companies.isEmpty()) {
                isSuccess = OwnershipNameUpdateBatch.updateOwnershipsNameOnProperties(companies[0].Company_Name__c, companies[0].Key__c, true);
                errMsg = isSuccess ? 'Successfully updated ownership name on properties.' : 'Error - Something went wrong while executing API call.';
            } else {
                errMsg = 'Error - No active company found for this account.';
            }
        }
        return errMsg;
    }
    
    public static List<Property_360_Company__c> getP360CompanyDetailByRealEstateAccount(Account realEstateAcc) {
        List<Property_360_Company__c> companies = new List<Property_360_Company__c>();
        if(realEstateAcc != null) {
            if(String.isNotBlank(realEstateAcc.ExternalIdEncrypted__c)) {
                companies = [Select Id, Company_Name__c, Key__c FROM Property_360_Company__c WHERE Key__c =: realEstateAcc.ExternalIdEncrypted__c];
            }
            if(companies.isEmpty() ) {
                companies = [Select Id, Company_Name__c, Key__c FROM Property_360_Company__c WHERE Company_Name__c =: realEstateAcc.Name];
            }
        }
        return companies;
    }
}
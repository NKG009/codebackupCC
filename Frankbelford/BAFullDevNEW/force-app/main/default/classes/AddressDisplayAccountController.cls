/**
* @File Name : AddressDisplayAccountController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : April 25, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | April 25, 2025 |   | Initial Version
**/

public class AddressDisplayAccountController {
	
	@AuraEnabled
	public static List<Account> fetchExistingAccountAddress(String recordId) {
    if (String.isBlank(recordId)) {
        return new List<Account>();
    }

    return [
        SELECT Id, Name, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry,
               ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
        FROM Account
        WHERE Id = :recordId
        LIMIT 1
    ];
	}

	@AuraEnabled
	public static Boolean updateAddressOnRecord(String recordId, String addressType, String street, String city, String county, String postalCode, String country){
		
		Boolean updated = false;
		try{
			if (String.isBlank(recordId)) {
                throw new AuraHandledException('Record ID cannot be blank');
            }

			Account acc = [SELECT Id, Name, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry,
               				ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
        					FROM Account WHERE Id = :recordId LIMIT 1];

							if (acc != null) {
                if(addressType == 'Billing'){
                    if (street != null) acc.BillingStreet = street;
                    if (city != null) acc.BillingCity = city;
                    if (county != null) acc.BillingState = county;
                    if (postalCode != null) acc.BillingPostalCode = postalCode;
                    if (country != null) acc.BillingCountry = country;
                    update acc;
                    updated = true;
                }else if(addressType == 'Shipping'){
                    if (street != null) acc.ShippingStreet = street;
                    if (city != null) acc.ShippingCity = city;
                    if (county != null) acc.ShippingState = county;
                    if (postalCode != null) acc.ShippingPostalCode = postalCode;
                    if (country != null) acc.ShippingCountry = country;
                    update acc;
                    updated = true;
                } 
				 return updated;
            } else {
                throw new AuraHandledException('Account record not found with ID: ' + recordId);
            }
        } catch (Exception e) {
            System.debug('Error updating Account address: ' + e.getMessage() + '\n' + e.getStackTraceString());
            throw new AuraHandledException('Error updating address: ' + e.getMessage());
        }

		}
	}
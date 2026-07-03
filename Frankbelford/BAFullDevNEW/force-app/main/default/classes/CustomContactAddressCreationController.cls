/**
* @File Name : CustomContactAddressCreationController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : May 2, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | May 2, 2025 |   | Initial Version
**/

public class CustomContactAddressCreationController {
	@AuraEnabled
	public static List<Contact> fetchExistingAddress(String recordId){
		return [SELECT Id, Name, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherStateCode, OtherCountryCode, OtherLatitude, OtherLongitude, 
				MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateCode, MailingCountryCode, MailingLatitude, MailingLongitude 
				FROM Contact WHERE Id =:recordId LIMIT 1];
	}

	@AuraEnabled
	public static Boolean updateAddress(String recordId, String addressType, String street, String city, String county, String postalCode, String country){
		Boolean updated = false;
		System.debug('=======Address Update Parameters - ' + 
             'RecordId: ' + recordId + ', ' +
             'Street: ' + street + ', ' +
             'City: ' + city + ', ' +
             'County: ' + county + ', ' +
             'PostalCode: ' + postalCode + ', ' +
             'Country: ' + country);

			 try {
				if (String.isBlank(recordId)) {
                	throw new AuraHandledException('Record ID cannot be blank');
            	}else{
					Contact con = [SELECT Id, Name, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherStateCode, OtherCountryCode, OtherLatitude, OtherLongitude, 
									MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateCode, MailingCountryCode, MailingLatitude, MailingLongitude 
									FROM Contact WHERE Id =:recordId LIMIT 1];

					if (con != null) {
                if(addressType == 'Mailling'){
                    if (street != null) con.MailingStreet = street;
                    if (city != null) con.MailingCity = city;
                    if (county != null) con.MailingState = county;
                    if (postalCode != null) con.MailingPostalCode = postalCode;
                    if (country != null) con.MailingCountry = country;
                    update con;
                    updated = true;
                }else if(addressType == 'Other'){
                    if (street != null) con.OtherStreet = street;
                    if (city != null) con.OtherCity = city;
                    if (county != null) con.OtherState = county;
                    if (postalCode != null) con.OtherPostalCode = postalCode;
                    if (country != null) con.OtherCountry = country;
                    update con;
                    updated = true;
                }
                return updated;
				} else {
                throw new AuraHandledException('Contact record not found with ID: ' + recordId);
            }
				}
			 }catch(Exception e){
				System.debug('Error updating con address: ' + e.getMessage() + '\n' + e.getStackTraceString());
            	throw new AuraHandledException('Error updating address: ' + e.getMessage());
			 }
	}
}
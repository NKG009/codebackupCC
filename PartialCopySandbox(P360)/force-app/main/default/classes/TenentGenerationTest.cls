/*******************************************************************************************
* @Name         TenentGenerationTest
* @Author       Rajesh
* @Date         20/07/2021
* @Description  This class contains all methods to provide code coverage for apex class 'TenentGeneration'.
*******************************************************************************************/
@isTest
public class TenentGenerationTest {

    @isTest
   	static void testTenantParse() {
		String json=		'[{'+
		'  "contacts": [{'+
		'    "id": "44a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'    "address": {'+
		'      "address_line_1": "Streatfield Road",'+
		'      "address_line_2": "",'+
		'      "country": null,'+
		'      "post_code": "2023",'+
		'      "state": "NSW",'+
		'      "street_number": "54",'+
		'      "suburb": "BELLEVUE HILL",'+
		'      "unit": "8"'+
		'    },'+
		'    "email_address": "leeannwalsh@hotmail.com",'+
		'    "preferred_email_address": "leeannwalsh@hotmail.com",'+
		'    "first_name": "Leeann",'+
		'    "is_primary": true,'+
		'    "last_name": "Walsh",'+
		'    "mobile_phone_number": "+61425222660",'+
		'    "phone_number": "9363 4887",'+
		'    "preferred_phone_number": "+61425222660",'+
		'    "title": "",'+
		'    "contact_types": ["Other: Lease, Arrears, Repairs", "Tenant"],'+
		'    "no_marketing": false'+
		'  }],'+
		'  "id": "46a9a69e-82fb-e911-b5e9-281878b47bfb",'+
		'  "name": "Leeann Walsh",'+
		'  "lease_end_date": "2003-08-11T00:00:00",'+
		'  "lease_start_date": "2002-08-11T00:00:00",'+
		'  "original_lease_start_date": "2002-08-11T00:00:00",'+
		'  "vacate_date": "2021-03-12T00:00:00",'+
		'  "property": "51b09b0a-629f-4f75-b8b6-a4ecea4c4bfd",'+
		'  "rent": {'+
		'    "amount": 2389.8800,'+
		'    "period": "Monthly"'+
		'  },'+
		'  "prospect": false,'+
		'  "deleted": false,'+
		'  "archived": true'+
		'}]';
        List<TenentGeneration> obj =  TenentGeneration.parse(json);
		System.assert(obj != null);
	}    
    
}
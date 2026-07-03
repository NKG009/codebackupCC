/*******************************************************************************************
* @Name         OwnerShipsGenerationTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'OwnerShipsGeneration'.
*******************************************************************************************/
@isTest
public class OwnerShipsGenerationTest {
    
    @isTest
    static void testOwnershipParse() {
		String json=		'[{'+
		'  "abn": null,'+
		'  "contacts": [{'+
		'    "id": "b9bfa088-80fb-e911-b5e9-281878b47bfb",'+
		'    "address": {'+
		'      "address_line_1": "PO Box 484",'+
		'      "address_line_2": null,'+
		'      "country": "AUSTRALIA",'+
		'      "post_code": "2107",'+
		'      "state": "NSW",'+
		'      "street_number": null,'+
		'      "suburb": "AVALON BEACH",'+
		'      "unit": null'+
		'    },'+
		'    "email_address": "karen.atf@optusnet.com.au",'+
		'    "preferred_email_address": "karen.atf@optusnet.com.au",'+
		'    "first_name": "Kevin Leo",'+
		'    "is_primary": true,'+
		'    "last_name": "Young",'+
		'    "mobile_phone_number": "+61411443835",'+
		'    "phone_number": null,'+
		'    "preferred_phone_number": "+61411443835",'+
		'    "title": "",'+
		'    "contact_types": ["Owner"],'+
		'    "no_marketing": false'+
		'  }, {'+
		'    "id": "bbbfa088-80fb-e911-b5e9-281878b47bfb",'+
		'    "address": {'+
		'      "address_line_1": ".",'+
		'      "address_line_2": null,'+
		'      "country": "AUSTRALIA",'+
		'      "post_code": null,'+
		'      "state": null,'+
		'      "street_number": null,'+
		'      "suburb": null,'+
		'      "unit": null'+
		'    },'+
		'    "email_address": "karen.atf@optusnet.com.au",'+
		'    "preferred_email_address": "karen.atf@optusnet.com.au",'+
		'    "first_name": "Karen",'+
		'    "is_primary": false,'+
		'    "last_name": "Young",'+
		'    "mobile_phone_number": null,'+
		'    "phone_number": null,'+
		'    "preferred_phone_number": null,'+
		'    "title": "",'+
		'    "contact_types": ["Owner"],'+
		'    "no_marketing": false'+
		'  }],'+
		'  "id": "b8bfa088-80fb-e911-b5e9-281878b47bfb",'+
		'  "properties": ["7b029168-e591-48b0-aaed-72fec08ed37e"],'+
		'  "deleted": false,'+
		'  "archived": false,'+
		'  "name": "Kevin Leo Young & Karen Jane Young"'+
		'}]';
		List<OwnerShipsGeneration> obj =  OwnerShipsGeneration.parse(json);
		System.assert(obj != null);
	}

}
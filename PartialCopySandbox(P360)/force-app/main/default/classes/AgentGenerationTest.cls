/*******************************************************************************************
* @Name         AgentGenerationTest
* @Author       Rajesh
* @Description  This class contains all methods to provide code coverage for apex class 'AgentGeneration'.
*******************************************************************************************/
@isTest
public class AgentGenerationTest {
    
    @isTest
    static void testAgentsParse() {
		String json=		'[{'+
		'  "email_address": "support@propertytree.com",'+
		'  "first_name": "PropertyTree",'+
		'  "id": "5830446f-fb1f-479a-be01-4afdd1385150",'+
		'  "last_name": "Support",'+
		'  "mobile_phone_number": "+61466978733",'+
		'  "properties": [],'+
		'  "roles": [],'+
		'  "deleted": true'+
		'}]';
		List<AgentGeneration> obj =  AgentGeneration.parse(json);
		System.assert(obj != null);
	}

}
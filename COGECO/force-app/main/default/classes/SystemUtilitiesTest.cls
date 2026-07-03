@isTest
public class SystemUtilitiesTest {
	private static final String SOURCE_IP = 'SourceIp';
    
    @isTest
    static void testGetFieldApiNameAndLabelFromFieldSet() {
        final String accountNameFieldApiName = 'Account_Services';
        final String accountObjectApiName = 'Account';
        
        Test.startTest();
        Map<String, String> fieldApiNameAndLabel = SystemUtilities.getFieldApiNameAndLabelFromFieldSet(accountNameFieldApiName, accountObjectApiName);
        Test.stopTest();

        System.assertEquals(true, !fieldApiNameAndLabel.isEmpty());
    }
        
    @isTest
    static void testGetMetadataOfFieldsOnObject() {
        Test.startTest();
        Map<String, Schema.SObjectField> fieldsMap = SystemUtilities.getMetadataOfFieldsOnObject('Account');
        Test.stopTest();

        System.assertEquals(true, !fieldsMap.isEmpty());
    }

    @isTest
    static void testGetFieldType() {
        Test.startTest();
        Schema.SoapType fieldType = SystemUtilities.getFieldType(Account.Name);
        Test.stopTest();
        
        String result = String.valueOf(fieldType);

        System.assertEquals('STRING', result);
    }

	@isTest
    static void testGetOrgWideEmailAddressId() {
        Test.startTest();
        OrgWideEmailAddress orgWideEmail = SystemUtilities.getOrgWideEmailAddressId('No Reply - Business Solutions');
        Test.stopTest();

        System.assertEquals(true, String.isNotEmpty(orgWideEmail.Id));
    }
    
    @isTest
    static void testGetUserIPAddress() {
        

        Test.startTest();
		Map<String, String> session = New Map<String, String> ();
		session.put('SOURCE_IP','TestSession');
        String userIPAddress = SystemUtilities.getUserIPAddress();
        Test.stopTest();

        System.assertEquals(session.get(SOURCE_IP), userIPAddress);
    }

	 @isTest
    static void testGetNullFieldApiNameAndLabelFromFieldSet() {
        final String accountNameFieldApiName = '';
        final String accountObjectApiName = '';
        
        Test.startTest();
        Map<String, String> fieldApiNameAndLabel = SystemUtilities.getFieldApiNameAndLabelFromFieldSet('Account_Services', accountObjectApiName);
		Map<String, String> fieldApiNameAndLabel1 = SystemUtilities.getFieldApiNameAndLabelFromFieldSet(accountNameFieldApiName, 'Account');
        Test.stopTest();

        System.assertEquals(null, fieldApiNameAndLabel);
		System.assertEquals(null, fieldApiNameAndLabel1);
    }
}
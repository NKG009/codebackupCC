@IsTest
private inherited sharing class UrlTest {
    private static AVTRRT.Logger logger = new AVTRRT.Logger('UrlTest');
    
    @IsTest
    private static void test() {
        Test.startTest();
        
        String accountName = 'Test';
        Url.setParam('accountName', accountName);
        
        String accountId = '0011U00000oIPp9';
        Url.setParam('accountId', accountId);
        Url.getParamInteger('test');
         Url.getParamBoolean('test');

        String accountNameFromUrl = Url.getParam('accountName');
        System.assertEquals(accountName, accountNameFromUrl);

        Id accountIdFromUrl = Url.getParamId('accountId');
        System.assertEquals(accountId, accountIdFromUrl);
        
        PageReference pr = Url.redirect('/apex/Fake');
        System.assertNotEquals(null, pr);
        
        Test.stopTest();
    }
}
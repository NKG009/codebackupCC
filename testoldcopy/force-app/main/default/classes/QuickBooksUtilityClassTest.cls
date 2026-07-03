@isTest(seeAllData=false)
public class QuickBooksUtilityClassTest {
   /* public static testmethod void test1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new QuickBooksHttpCalloutMock());
        QuickBooksUtilityClass.doFetchAccessToken();
        QuickbooksSendRequestAndRecieveResponse.SendRequest('{"test":"test"}','Invoice','POST');
        Test.stopTest();
    }
    public static testmethod void test2(){
        QBO_QuickBook_Auth_Info__c quickBooksSettingInfo= new QBO_QuickBook_Auth_Info__c();
        quickBooksSettingInfo.QBO_Access_Token__c = 'test';
        quickBooksSettingInfo.QBO_Refresh_Token__c = 'test';
        quickBooksSettingInfo.QBO_Expires_In_Seconds__c = 1234;
        quickBooksSettingInfo.QBO_Refresh_Token_Expires_In__c = 1234;
        quickBooksSettingInfo.QBO_Expires_In_Date_Time__c = System.Now().addSeconds(Integer.valueOf(-100));
        insert quickBooksSettingInfo;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new QuickBooksHttpCalloutMock());
        QuickbooksSendRequestAndRecieveResponse.SendRequest('{"test":"test"}','Invoice','POST');
         QuickBookAccessTokenUpdateSchedular schqb = new QuickBookAccessTokenUpdateSchedular(); 
        String sch = '0 0 * * * ?'; 
        system.schedule('AccessTokenbtch', sch, schqb); 
        Test.stopTest();
    }*/
}
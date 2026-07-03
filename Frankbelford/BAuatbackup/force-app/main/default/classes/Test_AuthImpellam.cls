@isTest 
public class Test_AuthImpellam {
    
  @testSetup 
    static void sSetup() {
               
        
    } 
    
    @isTest  static void dbToken_positive() {
		
        ImpellamCPConnect__c st = new ImpellamCPConnect__c();
        st.Name='ImpellamConnect';
        st.client_id__c='12';
        st.client_secret__c='23';
        st.HolidaysEndPointUrl__c='http://example.com/example/test';
        st.PayslipEndPointUrl__c='http://example.com/example/test';
        st.PayslipExportEndPointUrl__c='http://example.com/example/test';
        st.PaySlipFolderID__c='';    
        st.TokenExpiryDateTime__c='';
        st.TokenURL__c='http://example.com/example/test';    
        st.DocumentID__c='';
        st.ExpireAt__c=Datetime.now();
        st.LiveToken__c='1234567';         
        
        
        Test.setMock(HttpCalloutMock.class, new Mock_AuthImpellam());       
       	HttpResponse res = MyDemoToken.getAccessToken();
        
        String contentType = res.getHeader('Content-Type');
		System.assert(contentType == 'application/json');
		String actualValue = res.getBody();
		String expectedValue = '{"example":"test"}';
		System.assertEquals(actualValue, expectedValue);
		System.assertEquals(200, res.getStatusCode());
       insert st;          
        ImpellamCPConnect__c icpc = [select Name,client_id__c from ImpellamCPConnect__c where Name = 'ImpellamConnect' limit 1];
        
    }
    
}
public with sharing class QuickBooksLoginController {
  	public static QBO_Quickbooks_App_Info__c QBappInfo = QBO_Quickbooks_App_Info__c.getOrgDefaults();

    /*
     * @Name - doAuthorizationQuickBooks
     * @Param - None
     * @Description - to get the authentication code from the QuickBooks Account
     * @ReturnType - PageReference
    */
    
    public static PageReference doAuthorizationQuickBooks(){
   
        
        String final_EndPoint = QBappInfo.QBO_OAuth_Endpoint__c+'?client_id='+QBappInfo.QBO_Client_ID__c+'&response_type=code&scope='+
                                    QBappInfo.QBO_Scope__c+'&state=SFToQBrequest&redirect_uri='+QBappInfo.QBO_Redirect_URI__c;

        PageReference pageRef = new PageReference(final_EndPoint);
        return pageRef;
    }
    
    public void completeAuthorization() {
        String oAuthCode = ApexPages.currentPage().getParameters().get('code');
        
        if(oAuthCode != NULL) {
            QuickBooksUtilityClass.doFetchAccessToken();
        }
    }
}
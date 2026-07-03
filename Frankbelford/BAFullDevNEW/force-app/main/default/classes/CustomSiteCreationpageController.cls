public class CustomSiteCreationpageController {
    public String accountId { get;  set; }
    
    public CustomSiteCreationpageController(ApexPages.StandardController controllers) {
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        
         accountId = params.get('CF00NQH00000DXyOE_lkid');
        System.debug('=================== relativeUrl : '+accountId);
        
    }
}
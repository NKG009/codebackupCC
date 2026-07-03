public class MTRLWCController {
    
    @AuraEnabled
    public static List<Object> getMTRData(String mfg, String suborder, String po) {
        
        List<Object> mtrDataList = new List<Object>();
        ExperienceCloudController expContrl = new ExperienceCloudController();
        string reqresult = expContrl.getMTR(mfg, suborder, po);
        
        system.debug('API reqbody:-------'+reqresult);
        List<Object> rawnew = ( List<Object>)JSON.deserializeUntyped(reqresult);
        
        return mtrDataList;
    }
    
    
}
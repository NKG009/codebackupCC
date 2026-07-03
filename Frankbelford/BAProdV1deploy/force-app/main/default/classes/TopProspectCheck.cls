public class TopProspectCheck {
    
    public Account acct;
    public Id acctId{get; set;}
    public  boolean show {get; set;}
    public List<sirenum__Site__c> lstSites;
    private ApexPages.StandardController c;
    
    public TopProspectCheck(ApexPages.StandardController stdController){
        c = stdController;
        this.acct = (Account)stdController.getRecord();
        acctId = acct.id;
        lstSites = new List<sirenum__Site__c>();
        lstSites =  [Select Id,Name,Top_Prospect__c from sirenum__Site__c where sirenum__Operating_Company__c =:acct.id Limit 10000];
        Show=true;
    }
    
    public void updateTopProspect(){
        List<sirenum__Site__c> lstSitesToUpdate = new List<sirenum__Site__c>();
        if(!lstSites.isEmpty()){
            for(sirenum__Site__c site : lstSites){
                site.Top_Prospect__c = false;
                lstSitesToUpdate.add(site);
            }
        }
        update lstSitesToUpdate;
        
        acct.Check_Top_Prospect__c = true;
        update acct;
        Show = false;
    }
    
    
    public void revertTopProspect(){
        acct.Top_Prospect__c = true;
        update acct;
        
        Show = false; 
    }
    
}
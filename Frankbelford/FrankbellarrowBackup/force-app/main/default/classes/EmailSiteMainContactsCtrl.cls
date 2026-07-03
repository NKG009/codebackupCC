public class EmailSiteMainContactsCtrl {
 public List<Id> selectedSiteIDs{get;set;}
 public String listViewId{get;set;}
    
    public EmailSiteMainContactsCtrl(ApexPages.StandardSetController listcontroller){
        listViewId = listcontroller.getFilterId();
        selectedSiteIDs=new List<Id>();
        for(sirenum__Site__c site : (sirenum__Site__c[])listcontroller.getSelected()){
            selectedSiteIDs.add(site.Id);
        }
        System.debug('selectedSiteIDs:::'+selectedSiteIDs+'???'+listViewId);
    }
}
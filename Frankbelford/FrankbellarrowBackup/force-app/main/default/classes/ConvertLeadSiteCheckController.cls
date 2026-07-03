public class ConvertLeadSiteCheckController {
    
    public String inquiryId{get;set;}
    public String accountId{get;set;}
    public jsinq__Inquiry__c inquiry;
    //Our collection of the class/wrapper objects wrapSite 
    public List<wrapSite> wrapSiteList {get; set;}
    public Id selectedSiteid{get;set;}
    public List<Id> selectedSites{get;set;}
    private static Final string PROSPECT = 'Prospect';
    
    public ConvertLeadSiteCheckController(ApexPages.StandardController controller) {
        inquiryId = ApexPages.currentPage().getParameters().get('id');
        accountId = ApexPages.currentPage().getParameters().get('accId');
        wrapSiteList = new List<wrapSite>();
        inquiry = [Select id,Name,National_Competitor__c,Local_Competitor__c,Estimated_Perm_Vacancies__c,Estimated_Temp_Requirements__c,Company_Registration_No__c,Business_Type__c,jsinq__Website__c,jsinq__Email__c,jsinq__Phone_Number__c,jsinq__Contact__c,jsinq__Contact_Last_Name__c,jsinq__Contact_First_Name__c,jsinq__Street__c,jsinq__State__c,jsinq__Country__c,jsinq__City__c,jsinq__Zip_Postal_Code__c,Ownerid,jsinq__Title__c,jsinq__Job_Title__c,jsinq__Description__c,jsinq__Converted__c from jsinq__Inquiry__c where id=:inquiryId limit 1];
        
        // Adding Sites in Wrapper
        for(sirenum__Site__c site : [Select Id,Name,OwnerId,LastModifiedDate,Owner.Name,Status__c from sirenum__Site__c where sirenum__Operating_Company__c =:accountId Limit 10] ){
            wrapSiteList.add(new wrapSite(site));
        }
        
    }
    
    public Pagereference ConvertToSelectedSite(){
        selectedSites = new List<Id>();
 
        for(wrapSite wrapSiteObj : wrapSiteList) {
            if(wrapSiteObj.selected == true) {
                selectedSites.add(wrapSiteObj.site.id);
            }
        }
        selectedSiteid = selectedSites[0];
        system.debug('++selectedSiteid++++'+selectedSiteid);
        if(selectedSiteid!=null){
            PageReference pageref = new PageReference('/apex/ConvertLeadContactCheck?id='+inquiry.id+'&accId='+accountId+'&siteId='+selectedSiteid);
            pageref.setRedirect(true);
            return pageref;
        }
        return null;
    }
    
    public Pagereference ConvertToNewSite(){
        sirenum__Site__c site = new sirenum__Site__c();     
        //Inser New Site
        site.Name = inquiry.Name;
        site.Status__c = PROSPECT;
        site.sirenum__Phone1__c = inquiry.jsinq__Phone_Number__c;
        site.sirenum__Street_Address__c = inquiry.jsinq__Street__c;
        site.sirenum__City__c = inquiry.jsinq__City__c;
        site.sirenum__County__c = inquiry.jsinq__State__c;
        site.sirenum__Country__c = inquiry.jsinq__Country__c;
        site.sirenum__Postal_Code__c = inquiry.jsinq__Zip_Postal_Code__c;
        site.sirenum__Comments__c = inquiry.jsinq__Description__c;
        site.sirenum__Operating_Company__c = accountid;
        site.ownerId = inquiry.Ownerid;
        site.National_Competitor__c = inquiry.National_Competitor__c;
        site.Local_Competitor__c = inquiry.Local_Competitor__c;
        site.Estimated_Perm_Vacancies__c = inquiry.Estimated_Perm_Vacancies__c;
        site.Estimated_Temp_Requirements__c   = inquiry.Estimated_Temp_Requirements__c;
        site.Updated_From_New_Business__c = true;
        insert site;
                
        List<Task> tasklist = [Select id,WhatID from Task where Whatid =:inquiryId];
        if(tasklist.size()>0)
        {
            for(Task t:tasklist)
            {
                t.WhatID = site.id;
            }
            update tasklist;
        }
        
        List<Event> eventlist = [Select id,WhatID from Event where Whatid =:inquiryId];
        if(eventlist.size()>0)
        {
            for(Event t:eventlist)
            {
                t.WhatID = site.id;
            }
            update eventlist;
        }
        
        System.debug('Tasklist'+tasklist);
        PageReference pageref = new PageReference('/apex/ConvertLeadContactCheck?id='+inquiry.id+'&accId='+accountId+'&siteId='+site.id);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public Pagereference Cancel(){
        PageReference pageref = new PageReference('/'+inquiry.id);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public class wrapSite {
        public sirenum__Site__c site {get; set;}
        public Boolean selected {get; set;}
 
        public wrapSite(sirenum__Site__c s) {
            site = s;
            selected = false;
            system.debug('+++++++++++++selected+++'+selected);
        }
    }
}
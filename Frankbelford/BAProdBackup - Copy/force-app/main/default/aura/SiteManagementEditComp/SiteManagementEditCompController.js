({
    doInit : function(component, event, helper) {
        helper.getSiteList(component);		
        helper.getLoggedInUserInformation(component);
        helper.SiteInformationToupdate(component);	
        $A.get('e.force:refreshView').fire();         
  },
    
   updateSite : function(component, event, helper){
        helper.updateSiteInfo(component,event,helper);
        $A.get('e.force:refreshView').fire(); 
    },
     myrates: function(component, event, helper)
    {
         event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"rateinfo?site="+param;
        window.location.replace(urlRedirect);
        return false;
        
    },
   dashboardnavigate: function(component, event, helper)
    {
          event.preventDefault();
          var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
         var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'testpastvacancynew?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    myProfileNavigate: function(component, event, helper)
    {
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/myprofile?site='+param
        });
        urlEvent.fire();
         $A.get('e.force:refreshView').fire(); 
    },
    siteManagementNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function(component, event, helper)
    {
        event.preventDefault();
       var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"fastbooking?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
      var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testnewvacancy?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function(component, event, helper){
        event.preventDefault();
       var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newbookedtemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'pasttemps?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function(component, event, helper)
    {
        event.preventDefault();
      var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'newcontactus?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet  : function(component,event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"approved-timeSheets-new?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function(component,event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shiftdateview?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    candidateView: function(component,event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidateview?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    
    activeVacancy: function(component, event,helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testtemps?site="+param;
        window.location.replace(urlRedirect);
        return false; 
    },
    
    SiteManagementNavigate :function(component, event,helper) {
       
       event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement"+'?site='+param;
        window.location.replace(urlRedirect);
        return false; 
    },
    
    logout: function(component, event, helper)
    {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"login/?startURL=%2Fclient%2Fs%2F&ec=302";
        window.location.replace(urlRedirect);
        return false;
    },
    
     goback: function(component,event,helper){
         
		 event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement"+'?site='+param;
       
        window.location.replace(urlRedirect);
        return false; 
    },
    
})
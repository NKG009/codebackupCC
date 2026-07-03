({
	doInit : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        component.set('v.baseURL', baseURL);
        
        $A.get('e.force:refreshView').fire(); 
        helper.getSiteList(component);		
		helper.getLoggedInUserInformation(component);
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
    openActionWindow : function(component, event, helper) {
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
         var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/myprofileedit?site='+param
        });
        urlEvent.fire();
         $A.get('e.force:refreshView').fire(); 
        /*
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofileedit"+'?site='+component.find("siteId").get("v.value");
        window.location.replace(urlRedirect);
        return false; */
    },
  dashboardnavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = helper.getJsonFromUrl().site;
        
        var urlRedirect = component.get('v.baseURL')+"?site="+param;
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
        
        /*event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile"+'?site='+component.find("siteId").get("v.value");
        window.location.replace(urlRedirect);
        return false; */
    },
    siteManagementNavigate: function(component, event, helper)
    {
         var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
         var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/sitemanagement?site='+param
        });
        urlEvent.fire();
         $A.get('e.force:refreshView').fire(); 
        /*
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement"+'?site='+component.find("siteId").get("v.value");
        window.location.replace(urlRedirect);
        return false; */
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
    
    logout: function(component, event, helper)
    {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
   window.location.replace(urlRedirect);
        return false;
    },
})
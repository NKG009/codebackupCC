({
    doInit: function(component, event, helper) {
        
        helper.getLoggedInUserName(component);  
        helper.getsitejobrole(component);
        helper.getShifts(component);
        
          
           $A.get('e.force:refreshView').fire(); 
        
    },
    myrates: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"rateinfo?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    scriptsLoaded: function (cmp, evt, helper) {
        
    },
       // this function automatic call by aura:waiting event
    showSpinner: function (component,event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner",true);
    },
    
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component,event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner",false);
    },
    changedatavalue: function(component, event, helper) {
       component.set("v.nodata",false);
        
    },
    searchShifts: function(component, event, helper) {
        
        component.set("v.checkSearch",true)
        component.set("v.selectedSite", component.find("site").get("v.value"));
          component.set("v.site", component.find("site").get("v.value")); 
        component.set("v.selectedjobrole", component.find("jobRole").get("v.value"));
        var x =  document.getElementById("timePeriod").value;
        component.set("v.timeperiodselected", x)
        
        helper.getShifts(component);
        helper.getsitejobroleonSiteChange(component,event, helper);
    },
    dashboardnavigate: function(component, event, helper)
    {
          event.preventDefault();
          var param = component.find('site').get('v.value');
       
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
         var param = component.find('site').get('v.value');
       
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
        event.preventDefault();
        var param = component.find('site').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    siteManagementNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('site').get('v.value');
       
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
       var param = component.find('site').get('v.value');
       
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
      var param = component.find('site').get('v.value');
       
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
       var param = component.find('site').get('v.value');
       
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
        var param = component.find('site').get('v.value');
       
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
      var param = component.find('site').get('v.value');
       
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
        var param = component.find('site').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"approved-timeSheets-new?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
     shiftsToBeApprovedDataView: function(component,event, helper) {
        
          var param = component.find('site').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/shiftdateview?site='+param
        });
        urlEvent.fire();
         $A.get('e.force:refreshView').fire(); 
        
      /*  event.preventDefault();
        var param = component.find('site').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shiftdateview?site="+param;
        window.location.replace(urlRedirect);
        return false; */
    },
    candidateView: function(component,event, helper) {
         var param = component.find('site').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/candidateview?site='+param
        });
        urlEvent.fire();
         $A.get('e.force:refreshView').fire(); 
        
     /*   event.preventDefault();
        var param = component.find('site').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidateview?site="+param;
        window.location.replace(urlRedirect);
        return false; */
    },
    
    activeVacancy: function(component, event,helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
       
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
    // this function automatic call by aura:waiting event  
    scriptsLoaded: function(component, event, helper) {//alert('2222');
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {//alert('2222');
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },  
     resetAllValues : function(component,event,helper){
         console.log('reset '+component.find("jobRole").get("v.value") +document.getElementById("timePeriod").value);
        if(component.get("v.selectedjobrole") != null || component.get("v.timeperiodselected") !=null )
        {
        component.set("v.selectedjobrole", null);
      
        component.set("v.timeperiodselected", null);
             console.log('no');
         component.find("jobRole").set("v.value",null);
           console.log('no2');
          document.getElementById("timePeriod").value =null;
          component.set("v.checkSearch",true)
  
          helper.getShifts(component);
        }
    },
    handleOnClick : function(component, event, helper) {
        event.preventDefault();
        return false;
    }, 
    handleKeyPress : function(component, event, helper) {
        event.preventDefault();
        return false;
    },
    handleMouseEnter : function(component, event, helper) {
        event.preventDefault();
        return false;
    },
})
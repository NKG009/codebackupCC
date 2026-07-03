({
    keyCheck : function(component, event, helper){
        if (event.which == 13){
            event.preventDefault();
             var param = component.find('site').get('v.value');
          component.set("v.selectedSite",param);
            var cand = component.find('candinput').get('v.value');
       console.log('cand '+cand);
      //  helper.dosearch(component);
        }
},
    dashboardnavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testpastvacancynew?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    MyProfileNavigate: function(component, event, helper)
    {
        event.preventDefault();
        //var param = component.find('select').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile";
        //alert('profile');
        window.location.replace(urlRedirect);
        return false;
    },
    SiteManagementNavigate: function(component, event, helper)
    {
        event.preventDefault();
        //var param = component.find('select').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement";
        // alert('site');
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"fastbooking?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
         var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testnewvacancy?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function(component, event, helper){
        event.preventDefault();
         var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newbookedtemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function(component, event, helper)
    {
        event.preventDefault();
         var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"pasttemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newcontactus?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet  : function(component,event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"approved-timeSheets-new?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function(component,event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shifts-to-be-approved-data-view?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    candidateView: function(component,event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidate-view?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    
    activeVacancy: function(component, event,helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testtemps?site="+param;
        window.location.replace(urlRedirect);
        return false; 
    }, 
    doInit: function(component,event,helper){
      console.log('in load');  
     /*   var idParam = helper.getJsonFromUrl().site;  
        var siteList = component.get("c.getSites");
        var siteID;
        siteList.setCallback(this, function(response) {
            var state = response.getState();
           
            var optsSite = [];
            var equalFlag = false;
            if(component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();    
                for (var i = 0; i < SiteArray.length; i++) {
                    
                    if(SiteArray[i].Id==idParam){
                        //flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                   
                       equalFlag = true
                    }else{
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                        });
                       // var siteV =  component.find("site");
                       // siteV.set("v.value",optsSite[0].value);
                    }
                }
                
                 if(equalFlag==true)
                {
                    component.find("site").set("v.value", idParam);
                }
                else
                {
                      component.find("site").set("v.value", optsSite[0].value);
                }
                siteID = optsSite[0].value;
              
                component.set("v.SiteList", optsSite);
             
                //component.set("v.selectedSite",siteID);  
               // component.search(component,helper,event);
                //var a = component.get('c.search');
                //$A.enqueueAction(a);

            }
        }); 
        
        var action = component.get("c.getAllShiftsForCandidate");
        
        action.setParams({
            "contact": component.get("v.CandidateName"),
            "site":idParam//component.get("v.selectedSite")
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.ShiftList", result);
            component.set("v.truly",true);    
        });
        
        
        var action1 = component.get("c.fetchUser");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.Name", storeResponse);
                
                
                
            }
        });
        
        var fetchUserName = component.get("c.getUserInformation");
        
        fetchUserName.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
            
        });
        
       
        console.log('in else'+idParam);
             component.set("v.selectedSite", idParam);
      
        $A.enqueueAction(fetchUserName);
        $A.enqueueAction(action1);
        $A.enqueueAction(action); 
        $A.enqueueAction(siteList);
        */
    },
       onChangeSiteVal: function(component,event,helper){
        var site= event.getSource().get('v.value')
         console.log('site '+site);
        component.set("v.selectedSite",site);
        
        component.set("v.CandidateName",null); 
       helper.dosearch(component);
    },
    search:  function(component,event,helper)
    {
       // alert(component.find("site").get("v.value"));
            var param = component.find('site').get('v.value');
          component.set("v.selectedSite",param);
       console.log(component.get("v.selectedSite"));
        helper.dosearch(component);
       
    },
    logout: function(component, event, helper)
    {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
  window.location.replace(urlRedirect);
        return false;
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
       //  console.log('reset '+component.find("jobRole").get("v.value") +document.getElementById("timePeriod").value);
        if( component.get("v.CandidateName") !=null )
        {
        component.set("v.CandidateName", null);
      
      
          helper.dosearch(component);
        }
    },
    
})
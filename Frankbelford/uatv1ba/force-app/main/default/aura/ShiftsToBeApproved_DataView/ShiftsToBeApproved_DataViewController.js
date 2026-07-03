({
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
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile?site="+param;
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
        
        //var param = component.find('select').get('v.value');
        event.preventDefault();
        var param = component.find('site').get('v.value');
        //alert(param);
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
        //alert(4);
        var idParam = helper.getJsonFromUrl().site;  
        //var siteList = component.get("c.getSites");
         //component.find("childC").destroy();
        //component.set("v.SearchBtn",true);
        component.set("v.truly",false); 
        var action = component.get("c.getAllShifts");
        action.setParams({
            "site": idParam,//component.get("v.SiteSelected"),
            "role": component.get("v.roleSelected"),
            "contact": component.get("v.CandidateSelected"),
            "DateRange": component.get("v.DateSelected")
            
        });
        console.log('action '+action);
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.shifts", result);
            setTimeout(function(){ 
                 }, 500); 
            component.set("v.truly",true);    
            
       });
        
      
        var RoleCand = component.get("c.getRolesAndCandidate");
         RoleCand.setParams({
            "site": idParam
          
        });

        RoleCand.setCallback(this, function(response) {
            var state = response.getState();
            var optsSite = [];
            if(component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue().Role;
                optsSite.push({
                    class: "optionClass",
                    label: "Select Role Name ",
                    value: ""
                });
                for (var i = 0; i < SiteArray.length; i++) {
                    optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                    });
                }
                component.set("v.roleList", optsSite);
                
                var optsCandi = [];
                var condidateList = response.getReturnValue().Candidate;
                optsCandi.push({
                    class: "optionClass",
                    label: "Select Temp Name ",
                    value: ""
                });
                for (var i = 0; i < condidateList.length; i++) {
                    optsCandi.push({
                        class: "optionClass",
                        label: condidateList[i].sirenum__Contact__r.Name,
                        value: condidateList[i].sirenum__Contact__r.Id
                    });
                }
                component.set("v.CandidateList", optsCandi);
            }
        });
        var siteListOnly = component.get("c.getSites");
        siteListOnly.setCallback(this, function(response) {
            var state = response.getState();
            console.log('check state'+state);
            var optsSite = [];
            if(component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();    
                /* optsSite.push({
                    class: "optionClass",
                    label: "Select Site",
                    value: ""
                });*/
                
                var idParam = helper.getJsonFromUrl().site;
                console.log('site id'+SiteArray[0].Name);
                var equalFlag = false;
                for (var i = 0; i < SiteArray.length; i++) {
                    if(SiteArray[i].Id==idParam){
                        
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                        equalFlag = true
                   //    var siteV =  component.find("site");
                     //   siteV.set("v.value",idParam);
                       
                    }else{
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                            
                        });
                      
                        
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
                component.set("v.SiteList1", optsSite);
                
            }
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

        $A.enqueueAction(fetchUserName);
        
        $A.enqueueAction(action1);
         $A.enqueueAction(RoleCand);
         $A.enqueueAction(siteListOnly);
         // $A.enqueueAction(siteList);
         $A.enqueueAction(action);       
        
      
     },
    
        scriptsLoaded: function (cmp, evt, helper) {
        
    },
    onChangeCandidateVal: function(component,event,helper){
        var Candidate = event.getSource().get('v.value')
        component.set("v.CandidateSelected",Candidate);
    },
    
    onChangeRoleVal: function(component,event,helper){
        var site= event.getSource().get('v.value')
        component.set("v.roleSelected",site);
    },
    
    onChangeSiteVal: function(component,event,helper){
        var site= event.getSource().get('v.value')
         console.log('site '+site);
        component.set("v.selectedSite",site);
         component.set("v.checktrue",true);
        component.set("v.CandidateSelected",null); 
       helper.dosearch(component);
    },
    
    getTime : function(component,event,helper)
    {
        var dt =  component.find("timePeriod").getElement().value;
       // alert(dt);
    },
    
    search:  function(component,event,helper)
    {
          component.set("v.checktrue",false);
      helper.dosearch(component);
    },
    ApproveAll: function(component,event,helper)
    {
        alert('All');
        //component.find("match").set("v.checked",false);
        var myEvent = $A.get("e.c:ShiftApproveAllEvent");
        alert('myEvent');
        myEvent.fire();
        alert('All1');
    },
    
    Matched: function(component,event,helper){
        //var a = component.find("match").get("v.checked");
        if(component.get("v.Match")==true)
        {
            component.set("v.Match",false); 
        }
        else
        {
            component.set("v.Match",true); 
        }
        
        var shifts = component.get("v.shifts");
        component.set("v.shifts", shifts);
    },
    
    logout: function(component, event, helper)
    {
        event.preventDefault();
      var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
    window.location.replace(urlRedirect);
        return false;
    },
  	scriptsLoaded: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner
       //alert('1111');
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
         console.log('reset ');
        if(component.get("v.selectedjobrole") != null || component.get("v.timeperiodselected") !=null ||  component.get("v.CandidateSelected") != null )
        {
        component.set("v.selectedjobrole", null);
      
        component.set("v.DateSelected", null);
             console.log('no');
         component.find("site1").set("v.value",null);
             component.find("site2").set("v.value",null);
           console.log('no2');
          document.getElementById("timePeriod").value =null;
          component.set("v.CandidateSelected",null); 
         
          helper.dosearch(component);
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
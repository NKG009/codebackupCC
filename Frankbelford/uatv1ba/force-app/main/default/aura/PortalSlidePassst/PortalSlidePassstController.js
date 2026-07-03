({
    doInit : function(component, event, helper) {
       console.log('==Enter==');
        helper.getSiteList(component);		
        helper.getLoggedInUserInformation(component);
        helper.JobRoleList(component)    
        helper.SiteCandidatesHelper(component);
        helper.getShiftsOnLoad(component);
    },
     myrates: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"rateinfo?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    resetstar : function(component, event, helper){
        console.log('test '+  component.get("v.ratingreset"));
          component.set("v.ratingreset",false);
    },
    siteChanged :function(component, event, helper) {        
        component.set("v.checkSearch",true)
        component.set("v.selectedSite", component.find("siteId").get("v.value"));
        	 component.set("v.site", component.find("siteId").get("v.value")); 
        component.set("v.selectedjobrole", component.find("jobRoleId").get("v.value"));
        var x =  document.getElementById("timePeriod").value;
        component.set("v.timeperiodselected", x)
        helper.SiteCandidatesHelper(component, event, helper);
        helper.JobRoleList(component)  
    },
    searchShifts : function(component, event, helper){
        component.set("v.checkSearch",true)
        helper.searchShiftsHelper(component, event, helper);
    },
    renderPage: function(component, event, helper) {
        //  helper.renderPage(component);
    },
    feedback: function(component, event, helper) {
       var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        console.log('in help fire '+appEvent);
        var buttonName = event.target.id;
        component.set("v.selectedRating",1);
        //   var target = event.getSource();
        var idToBeCancelled = buttonName;
        var shiftList = component.get("v.shifts");
        for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idToBeCancelled){
                component.set("v.feedbackshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
            }
        }
        
  
    },
    closeModelCancel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenCancel", false);
        component.set("v.selectedRating",1);
    },
    selectRating: function(component, event, helper) {
        
        component.set("v.Spinner", false);
        var selectedRating = event.getParam("rating");
        component.set("v.selectedRating",selectedRating);
        
    },
    submitRating: function(component, event, helper) {
     //     helper.helpercloseModelCancel(component,event,helper);
       console.log('submit'); 
     //   component.set("v.Spinner", false);
        var shift = component.get("v.feedbackshift");
        var action = component.get("c.submitRatings");
        var selectedRating = component.get("v.selectedRating");
        //helper.submitRating(component);
        if(selectedRating==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               			
                        message:'Please select Rating',
                     
                        mode: 'pester'  
            });
            toastEvent.fire();
            component.set("v.Spinner", false);
        }
        else{
              var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');
        
        var siteIdvalue = component.find("siteId").get("v.value");
        if(siteIdvalue == undefined || siteIdvalue == ""){            
            siteIdvalue = siteRecId;
        }
          //    helper.helpercloseModelCancel(component, event, helper);
        console.log(' action'); 
           // debugger;
            action.setParams({
                "shiftID": component.get("v.feedbackshift").Id,
                "selectedRating": component.get("v.selectedRating"),
                "siteId" : siteIdvalue,
                "jobRoleId" : component.find("jobRoleId").get("v.value"),
                "candidateId" : component.find("candidateId").get("v.value"),
                "timePeriod" : document.getElementById("timePeriod").value
            });
            action.setCallback(this, function(response) {
                  console.log('submit action'); 
            //   debugger;
                var state = response.getState();
                var result = response.getReturnValue();
                if (state === "SUCCESS"){
                    //component.set("v.shifts", result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : '',
                        message:'Thank you for your feedback',
                       
                        type: 'success',
                        mode: 'pester'  
                    });
                    toastEvent.fire();
                     $("#overlay").show();
                    // component.set("v.isOpenCancel", false);
                    var elements = document.getElementsByClassName("feedbackSpnId1");
                    var cmpTarget = component.find('feedbackSpnId1');
                    $A.util.addClass(elements, 'disablebutton');
                    component.set("v.selectedRating",1);
                    component.set("v.Spinner", false);
                    $A.get('e.force:refreshView').fire();
                    /*table*/
                    component.set("v.shifts", result);
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();
                    setTimeout(function(){ 
                        $('#tableId').DataTable({responsive: true,
                                                aaSorting: []
                                                 
                                 
                             });
                        
                     $("#overlay").hide();}, 1000); 
                    
                    //var button = component.find("rating");
                    var button = event.getParam("rating");
                    for(var i=0;i<button.length;i++){    
                        // $A.util.removeClass(button[i], 'slds-button_brand');
                        $A.util.removeClass(button[i], 'slds-button_success');
                    }
                    $A.util.addClass(target, 'slds-button_success');
                    
                    component.set("v.selectedRating",1);
                    

                    /* . end*/
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                       
                        message:'There is some issues while submitting rating. Please contact your consultant',
                       
                    });
                    toastEvent.fire();
                    component.set("v.Spinner", false);
                }
            });
            
            var appEvent = $A.get("e.c:RatingAppEvent");
        	appEvent.fire();
            
            $A.enqueueAction(action);
            // $A.enqueueAction(action2);
            component.set("v.checkSearch",true)
            component.set("v.Spinner", false);
            //    helper.searchShiftsHelper(component);
        }
        
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
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
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
    
    
    logout: function(component, event, helper)
    {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
    window.location.replace(urlRedirect);
        return false;
    },
    // this function automatic call by aura:waiting event  
     scriptsLoaded: function (component,event, helper) {
         console.log('in ');
helper.helperscriptload(component,event,helper);
        console.log('in asscript'); 
    },
    closeModalWindowOnCancel : function(component,event,helper){
     helper.helpercloseModelCancel(component,event,helper);
        
    },
    resetAllValues : function(component,event,helper){
        console.log('reset ');  
       
        if(component.get("v.selectedjobrole") != null || component.get("v.timeperiodselected") !=null || component.find("candidateId").get("v.value") != null)
        {
            component.set("v.selectedjobrole", null);
            
            component.set("v.timeperiodselected", null);
            
            component.find("jobRoleId").set("v.value",null);
            component.find("candidateId").set("v.value",null);
            document.getElementById("timePeriod").value =null;
            component.set("v.checkSearch",true);
            helper.getShiftsOnLoad(component);
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
    handleMouseLeave : function(component, event, helper) {
        event.preventDefault();
        return false;
    },
    
    cancel : function(component, event, helper) {
        helper.helpercancel(component,event,helper);
    },
    
})
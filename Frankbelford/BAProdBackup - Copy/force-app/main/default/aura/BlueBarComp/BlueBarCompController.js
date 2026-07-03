({
	doInit: function(component, event, helper){
	    //component.set("v.site", helper.getJsonFromUrl().site);

	    var userId = $A.get( "$SObjectType.CurrentUser.Id" );
	    console.log('Id>>>' + userId);
	    var action = component.get("c.getVMSSubscriptoinFlag");
	    action.setParam("userId",userId);
	    action.setCallback(this, function(response){
	        var state = response.getState();
	        if(state=="SUCCESS"){
	            component.set("v.isVMSClient",response.getReturnValue());
	            //console.log('response.getReturnValue() >> ' + response.getReturnValue());
            } else if(state=="ERROR"){
                var errorMsg="Error:";
               for(i=0;i<response.error.length; i++){
                   errorMsg+=response.error[i].message + "\n";
               }
               console.error("Something went wrong:: "+JSON.stringify(errorMsg));
               /*rsToast.setParams({"title":"Error","message":"Something went wrong! " + errorMsg});
               rsToast.fire();*/
            }
        });
        $A.enqueueAction(action);
	    console.log("isVmsUser >> " + component.get("v.isVMSClient"));
    },

    onSiteChange: function(component, event, helper){
        var site = event.getParam("selectedSiteId");
        component.set("v.site", site);
    },

    currentJobOrders: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site"); //helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"current-bookings?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    previousJobOrders: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"previous-bookings?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    createNewJobOrder: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"create-new-booking?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pendingJobOrders: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"pending-booking?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    notificationSettings: function(component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"notification-settings?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    myrates: function(component, event, helper){
            event.preventDefault();
            var param = component.get("v.site");
            var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"rateinfo?site="+param;
            window.location.replace(urlRedirect);
            return false;
    },
    PoManagement: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site"); //helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"pomanage?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },

    dashboardnavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); //helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },

    pastVacancyNavigate: function(component, event, helper)
    {
        alert($A.get("$Label.c.Lightning_Component_URL")+"testpastvacancynew?site=");
        event.preventDefault();
        var param = component.get("v.site");

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testpastvacancynew?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    MyProfileNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'myprofile?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    SiteManagementNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'sitemanagement?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function(component, event, helper)
    {
       event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"fastbooking?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testnewvacancy?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newbookedtemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"pasttemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newcontactus?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    viewApprovedShifts: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"approved-shifts?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet  : function(component,event, helper) {
        event.preventDefault();
		var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"approved-timeSheets-new?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function(component,event, helper) {
        console.log('was here ');
        //event.preventDefault();
        console.log('site from here: '+component.get('v.site'));
        //var param = component.find('site').get('v.value');
        var param=component.get('v.site');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shiftdateview?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    candidateView: function(component,event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidateview?site="+param;;
        window.location.replace(urlRedirect);
        return false;
    },
    
    activeVacancy: function(component, event,helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testtemps?site="+param;;
        window.location.replace(urlRedirect);
        return false; 
    },
    ActiveVacancy: function(component, event,helper) 
    {
        event.preventDefault();
        var urlRedirect = "https://sandboxb-yourcompanyportal-15728bf70b1.cs105.force.com/client/s/testtemps";
       
        window.location.replace(urlRedirect);
        return false;
    },
   
    PastVacnavigate: function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/testpastvacancynew'
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    FaStBookingNavigate: function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/fastbooking'
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    NewVacancyNavigate: function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/testnewvacancy'
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
     BookedTempsNavigate: function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/newbookedtemps'
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    PastTempsNavigate: function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/pasttemps'
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    ContactUsNavigate: function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/newcontactus'
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    logout: function(component, event, helper)
    {
       event.preventDefault();
       var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
       window.location.replace(urlRedirect);
       return false;
    }
})
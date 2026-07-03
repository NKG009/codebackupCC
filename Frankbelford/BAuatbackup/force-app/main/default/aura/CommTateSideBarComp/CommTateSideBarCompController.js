({
	doInit : function(component, event, helper){
	    var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        component.set('v.baseURL', baseURL);

	    var userId = $A.get( "$SObjectType.CurrentUser.Id" );
	    //console.log('Id>>>' + userId);
	    var action = component.get("c.getVMSSubscriptoinFlag");
	    action.setParam("userId",userId);
	    action.setCallback(this, function(response){
	        var state = response.getState();
	        if(state=="SUCCESS"){
	            component.set("v.isVMSClient",response.getReturnValue());
            } else if(state=="ERROR"){
                var errorMsg="Error:";
               for(i=0;i<response.error.length; i++){
                   errorMsg+=response.error[i].message + "\n";
               }
               console.error("Something went wrong:: "+JSON.stringify(errorMsg));
            }
        });
        $A.enqueueAction(action);
	    //console.log("isVmsUser > " + component.get("v.isVMSClient"));

    },
    onSiteChange: function (cmp, evt, helper) {
        var selectedSite = evt.getParam("selectedSiteId");
        //console.log('Current Site >> ' + cmp.get('v.site') + " change handler newly selected site >> " + selectedSite);
        cmp.set("v.site", selectedSite);

        //console.log('site updated >>> ' + cmp.get("v.site"));
    },
    currentJobOrders: function(component, event, helper){
        //helper.goToUrl("/current-bookings", component, event);
        helper.doCommPageNav("current-bookings", component, event);
    },
    previousJobOrders: function(component, event, helper){
        //helper.goToUrl("/previous-bookings", component, event);
        helper.doCommPageNav("previous-bookings", component, event);
    },
    createNewJobOrder: function(component, event, helper){
        event.preventDefault();
        //helper.goToUrl("/create-new-booking", component, event);
        helper.doCommPageNav("create-new-booking", component, event);
    },
    pendingJobOrders: function(component, event, helper){
        helper.doCommPageNav("pending-booking", component, event);
    },
    notificationSettings: function(component, event, helper) {
        //helper.goToUrl("/notification-settings", component, event);
        helper.doCommPageNav("notification-settings", component, event);
    },
    myRates: function(component, event, helper){
        //helper.goToUrl("/rateinfo", component, event);
        helper.doCommPageNav("rateinfo", component, event);
    },
    poManagement: function(component, event, helper){
        //helper.goToUrl("/pomanage", component, event);
        helper.doCommPageNav("pomanage", component, event);
    },

    dashboardNavigate: function(component, event, helper) {
        helper.doWindowLocReplace("", component, event);
    },

    pastVacancyNavigate: function(component, event, helper) {
        //helper.goToUrl("/previous-shifts", component, event);
        //helper.doCommPageNav("previous-shifts", component, event);
        helper.doWindowLocReplace("previous-shifts", component, event);
    },

    fastBookingNavigate: function(component, event, helper) {
        //helper.doCommPageNav("fastbooking", component, event);
        helper.doWindowLocReplace("fastbooking", component, event);
    },

    newVacancyNavigate: function(component, event, helper) {
        //helper.goToUrl("/shift-or-vacancy-request", component, event);
        //helper.doCommPageNav("shift-or-vacancy-request", component, event);
        helper.doWindowLocReplace("shift-or-vacancy-request", component, event);
    },
    bookedTempsNavigate: function(component, event, helper){
        //helper.goToUrl("/newbookedtemps", component, event);
        helper.doWindowLocReplace("newbookedtemps", component, event);
    },
    pastTempsNavigate: function(component, event, helper) {
        //helper.goToUrl("/pasttemps", component, event);
        helper.doWindowLocReplace("pasttemps", component, event);
    },
    contactUsNavigate: function(component, event, helper) {
        //helper.goToUrl("/contacts-us", component, event);
        helper.doCommPageNav("contacts-us", component, event);
    },
    gotoApprovedShifts : function(component,event, helper) {
        helper.doWindowLocReplace("approved-shifts", component, event);
    },
    gotoApprovedTimesheet  : function(component,event, helper) {
        //helper.doCommPageNav("approved-timeSheets-new", component, event);
        helper.doWindowLocReplace("approved-timeSheets-new", component, event);
    },
    shiftsToBeApprovedDataView: function(component,event, helper) {
        event.preventDefault();
        helper.goToUrl("/shiftdateview", component, event);
        //helper.doCommPageNav("shiftdateview", component, event);
        //helper.doWindowLocReplace("shiftdateview", component, event);
    },
    candidateView: function(component,event, helper) {
        helper.goToUrl("/candidateview", component, event);
        //helper.doCommPageNav("candidateview", component, event);
        //helper.doWindowLocReplace("candidateview", component, event);
    },

    activeVacancy: function(component, event, helper) {
        event.preventDefault();
        helper.doWindowLocReplace("current-shifts", component, event);
        //helper.goToUrl("/current-shifts", component, event);
        //helper.doCommPageNav("current-shifts", component, event);
    },

    logout: function(component, event, helper){
       event.preventDefault();
       var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
       window.location.replace(urlRedirect);
       return false;
    },
})
({
	ApprovedTimesheets: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/approved-timesheets" });
        urlEvent.fire();
    },
     shiftstobeapproved: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/shifts-to-be-approved" });
        urlEvent.fire();
    },
      getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },
    
})
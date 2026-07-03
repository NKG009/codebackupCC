({
    ApproveTimesheets: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/client-approved-timesheets" });
        urlEvent.fire();
    },
     CurrentVacancies: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/vacancies" });
        urlEvent.fire();
    },
    mytemps: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/my-temps" });
        urlEvent.fire();
    },
    mydetails: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/profile/:{!v.recordid}" });
        urlEvent.fire();
    },
    
    
})
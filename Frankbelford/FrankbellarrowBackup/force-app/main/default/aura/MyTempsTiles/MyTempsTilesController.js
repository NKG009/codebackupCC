({
	BookedTemps: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/booked-temps" });
        urlEvent.fire();
    },
    PastTemps: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/past-temps" });
        urlEvent.fire();
    },
    getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },  
})
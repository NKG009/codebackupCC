({
    TrackMyPay: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/track-my-pay" });
        urlEvent.fire();
    },
     Confirmyourhours: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/confirmyourhours" });
        urlEvent.fire();
    },
     myTimesheet: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/mytimesheet" });
        urlEvent.fire();
    },
     payslip: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/payslips" });
        urlEvent.fire();
    },
     getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },
})
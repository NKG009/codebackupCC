({
    doInit: function(component, event, helper) {
        
    },
    PaySlipTimesheet: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/pay-and-timesheet" });
        urlEvent.fire();
    },
     myjobs: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/myjobs" });
        urlEvent.fire();
    },
    holidays: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/holidays" });
        urlEvent.fire();
    },
   
   mydetails : function(component, event,helper) 
    {
  
          var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": "/my-details" });
     		     urlEvent.fire();
    
    },
    
    
})
({
MyShiftsPage: function(component, event,helper) 
    {
        console.log('SHIFTPAG ');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/myshifts" });
        urlEvent.fire();
    },
    
    MyShiftHistory: function(component, event,helper) 
    {
        console.log('in history');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/shifthistory" });
        urlEvent.fire();
    },
      getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },
})
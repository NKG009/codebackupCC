({
	 getBackscreen : function(component, event, helper) {
   var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },
     showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    },
})
({
    bankdetails: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/bank-details" });
        urlEvent.fire();
    },
    
    myskills: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/my-skills" });
        urlEvent.fire();
    },
    
     myprofile: function(component, event) 
    {
          var action = component.get("c.getuserId");
      	  console.log('abc '+action);
 		action.setCallback(this, function(response) {
		var state = response.getState();
		console.log('STAte '+state);
            
           var records = response.getReturnValue();
           console.log('records '+records); 
       var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/profile/"+records });
        urlEvent.fire();
            
            });
        $A.enqueueAction(action);
       
    },
     getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },
})
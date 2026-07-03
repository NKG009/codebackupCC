({
	viewratecard : function(component) {
		var action = component.get("c.ViewRateCard");
		action.setParams({"JobroleId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
           // console.log('+++state+++'+state);
			if(state === "SUCCESS") {				

              var urlRedirect = "/"+result;
    	   var eUrl= $A.get("e.force:navigateToURL");
            eUrl.setParams({
              "url": urlRedirect
            });
            eUrl.fire();
			}
       
        });
          
        $A.enqueueAction(action);
	}
})
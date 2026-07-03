({
	doInit : function(component, event, helper) {
        //document.getElementById("create").click();
		 var action = component.get("c.getOAuthcode");
        console.log('v.recordId'+component.get("v.recordId"))
        action.setParams({recordId: component.get("v.recordId")});
        action.setCallback(this, function(response) {
             console.log('state'+ JSON.stringify(response.getState()));
            console.log('value'+ JSON.stringify(response.getReturnValue()));
            var cururl=window.location.href;
            var reurl=response.getReturnValue();
             window.location.href=reurl;
             
        
        });
         $A.enqueueAction(action);
	}
})
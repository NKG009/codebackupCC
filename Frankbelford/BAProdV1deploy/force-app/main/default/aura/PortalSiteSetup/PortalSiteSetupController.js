({
	doInit : function(component, event, helper) {
        component.set("v.processing",true);
        var action = component.get("c.sitesetup");
		action.setParams({"siteId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
			var state = response.getState();
            var returnmessage = response.getReturnValue();
            
			if(state === "SUCCESS") {
                if(returnmessage=='Record has been updated successfully.')
                {
                    component.set("v.processing",false);
                    component.set("v.success",true);
                    component.set("v.error",false);
                    component.set("v.message",returnmessage);
                    $A.get('e.force:refreshView').fire();
                }
                else
                {
                    component.set("v.processing",false);
                    component.set("v.success",false);
                    component.set("v.error",true);
                    component.set("v.message",returnmessage);
                }
                
            }
            else
            {
                component.set("v.processing",false);
                component.set("v.success",false);
                component.set("v.error",true);
                component.set("v.message",'There are some problem with this record please contact your system admin');
            }
	});
    $A.enqueueAction(action);
		
    }
                           
                           
                           
})
({
	doInit : function(component, event, helper) {
        component.set("v.processing",true);
        var action = component.get("c.resetPasswordForClient");
		action.setParams({"contactId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
			var state = response.getState();
            var returnmessage = response.getReturnValue(); 
            console.log('++++++returnmessage+++'+returnmessage)
			if(state === "SUCCESS") {
                if(returnmessage=='emailBlankMessage' || returnmessage=='userNotSetUp'){
                    component.set("v.message",$A.get("$Label.c.UserNotSetUpForPortal"));
                	component.set("v.error",true);
                    component.set("v.success",false);
                    component.set("v.processing",false);
                }
                else if(returnmessage=='passwordReset'){
                    component.set("v.message",$A.get("$Label.c.PasswordResetSuccessfully"));
                	component.set("v.error",false);
                    component.set("v.success",true);
                    component.set("v.processing",false);
                }
                else{
                    component.set("v.processing",false);
                    component.set("v.success",true);
                    component.set("v.error",false);
                    component.set("v.message",returnmessage);
                }
            }
            else {
                component.set("v.processing",false);
                component.set("v.success",false);
                component.set("v.error",true);
                component.set("v.message",returnmessage);
            }
	});    
        $A.enqueueAction(action);		
    }                      
})
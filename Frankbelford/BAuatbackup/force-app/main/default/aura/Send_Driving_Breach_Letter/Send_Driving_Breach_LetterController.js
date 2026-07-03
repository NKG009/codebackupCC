({
	doInit : function(component, event, helper) {
        var action = component.get("c.getContact");
        action.setParams({"contactId": component.get("v.recordId")});
        
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse){
					component.set("v.displayMessage", true); 
                }
                else{
					component.set("v.displayCandidateMessage", true); 
                }
            } else {
                //$A.get('e.force:refreshView').fire();
        		$A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
	},
	
	handleClick : function(component, event, helper) {
        var callAction = component.get("c.sendcandidateemail");
		callAction.setParams({"contactId": component.get("v.recordId")});
		
		// Configure response handler
		callAction.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				var storeResponseVal = response.getReturnValue();
				if(storeResponseVal == 'true'){
                    component.set("v.displayEmailMessage", true);
                    component.set("v.displayMessage", false);
				}
				else{
                    component.set("v.displayEmailErrorMessage", true); 
				}
			} else {
				//$A.get('e.force:refreshView').fire();
        		$A.get("e.force:closeQuickAction").fire();
			}
		});
		$A.enqueueAction(callAction);
	},
	
	cancel : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
})
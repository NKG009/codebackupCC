({
	handleHelperMethod : function(component) {
       component.set("v.processingStatus", false);
       var callAction = component.get("c.sendcall");
		callAction.setParams({"ConID": component.get("v.recordId")});
		// Configure response handler
		callAction.setCallback(this, function(response) {
			var state = response.getState();
            console.log('+++state+++'+state);
            var storeResponseVal = response.getReturnValue();
			if(state === "SUCCESS") {				
                console.log('+++storeResponseVal+++'+storeResponseVal);
				if(storeResponseVal == 'Created' || storeResponseVal == 'Updated' || storeResponseVal == 'Duplicate'){
                    var action = component.get("c.updateContact");
					action.setParams({"contactId": component.get("v.recordId")});
					// Configure response handler
					action.setCallback(this, function(response) {
						var state = response.getState();
						if(state === "SUCCESS") {
							var responseVal = response.getReturnValue();
                             console.log('+++responseVal+++'+responseVal);
							if(responseVal == 'Contact Updated'){
								component.set("v.displayMessage", true);
                                component.set("v.processingStatus", false);
                                component.set("v.displayConfirmMessage",false);
                                $A.get('e.force:refreshView').fire();
        						$A.get("e.force:closeQuickAction").fire();                    
							}
							else{
								component.set("v.displayErrorMessage", true);
                                component.set("v.processingStatus", false);
								component.set("v.callresult", responseVal);
                                $A.get('e.force:refreshView').fire();
        						$A.get("e.force:closeQuickAction").fire();
							}
						} else {
							component.set("v.displayErrorMessage", true);
							component.set("v.callresult", storeResponseVal);
                            $A.get('e.force:refreshView').fire();
        					$A.get("e.force:closeQuickAction").fire();
						}
					});
					$A.enqueueAction(action);					
				}
                else if(storeResponseVal == 'Email Address Not Valid'){
                    component.set("v.displayErrorMessage", true);
					component.set("v.callresult", 'Email Address is not Valid');
                }
                else if(storeResponseVal == 'Email blank'){
                    component.set("v.displayErrorMessage", true);
					component.set("v.callresult", 'Email is blank');
                }
				else{
					component.set("v.displayErrorMessage", true);
					component.set("v.callresult", storeResponseVal);
                    $A.get('e.force:refreshView').fire();
        			$A.get("e.force:closeQuickAction").fire();
				}
			}
			else{
				component.set("v.displayErrorMessage", true);
				component.set("v.callresult", storeResponseVal);
			}
		});
		$A.enqueueAction(callAction);
	}
})
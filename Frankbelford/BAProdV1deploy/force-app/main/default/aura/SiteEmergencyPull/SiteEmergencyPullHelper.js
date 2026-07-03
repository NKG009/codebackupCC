({
	siteDetailsUpdate : function(component) {
		var action = component.get("c.siteDetailsUpdate");
		action.setParams({"siteId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				console.log('++++++++++result+++++ '+result);
                if(result=='recruiterUser'){
                    component.set("v.messageDisplay",'Permission restricted to Payroll Department.');
                	component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);
                }else if(result=='successMessage'){
                    component.set("v.messageDisplay",'Records Flagged');
                    component.set("v.errorMessage",false);
                    component.set("v.successMessage",true);
                    component.set("v.processingText",false);
                    $A.get('e.force:refreshView').fire();
        			$A.get("e.force:closeQuickAction").fire();
                }
                else{
                    component.set("v.messageDisplay",result);
                    component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);
                }
			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.errorMessage",true);
                component.set("v.successMessage",false);
				component.set("v.processingText",false);
            }
        });
        $A.enqueueAction(action);
	}
})
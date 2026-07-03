({
	getCertificationLapsed : function(component) {
		var action = component.get("c.getCertificationLapsed");
		action.setParams({"certificationId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {
                if(result=='Certification lapsed successfully.'){
                    component.set("v.messageDisplay",result);
                    component.set("v.successMessage",true);
                    component.set("v.processingText",false);
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    component.set("v.messageDisplay",result);
                    component.set("v.errorMessage",true);
                    component.set("v.processingText",false);
                }
			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.errorMessage",true);
				component.set("v.processingText",false);
            }
        });
        $A.enqueueAction(action);
	},
})
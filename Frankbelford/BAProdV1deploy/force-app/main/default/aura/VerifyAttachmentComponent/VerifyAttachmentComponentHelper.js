({
	getCertificationAttachment : function(component) {
		var action = component.get("c.getCertificationAttachment");
		action.setParams({"certificationId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				console.log('++++++++++result+++++ '+result);
                if(result=='true'){
                    component.set("v.processingText",false);
                    component.set("v.verifyCheckbox",true);
                    component.set("v.verifiedRecord",true);
                }
                else if(result=='verifiedFalse'){
                    component.set("v.processingText",false);
                    component.set("v.verifyCheckbox",true);
                    component.set("v.verifiedRecord",false);
                }
                else if(result=='false'){
                    component.set("v.processingText",false);
                    component.set("v.runVerifyCheck",true);
                }
                else if(result=='attachmentNotExist'){
                    component.set("v.messageDisplay",'Missing attachment.');
                    component.set("v.processingText",false);
                    component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                }
                else{
                    component.set("v.messageDisplay",result);
                    component.set("v.errorMessage",true);
                    component.set("v.processingText",false);
                    component.set("v.runVerifyCheck",false);
                    component.set("v.verifyCheckbox",false);
                }
			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.errorMessage",true);
				component.set("v.processingText",false);
                component.set("v.runVerifyCheck",false);
                component.set("v.verifyCheckbox",false);
            }
        });
        $A.enqueueAction(action);
	},
    
    updateCertificationRecord : function(component,isChecked) {
        console.log('++++++++++isChecked+++++ '+isChecked);
		var action = component.get("c.updateCertificationRecord");
		action.setParams(
            {
                "certificationId": component.get("v.recordId"),
                "isChecked": isChecked
            }
       );
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {
                if(result=='true'){
                   $A.get('e.force:refreshView').fire();
                   $A.get("e.force:closeQuickAction").fire();
                }
                else{
                    component.set("v.messageDisplay",result);
                    component.set("v.errorMessage",true);
                    component.set("v.processingText",false);
                    component.set("v.runVerifyCheck",false);
                    component.set("v.verifyCheckbox",false);
                }
			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.errorMessage",true);
                component.set("v.processingText",false);
                component.set("v.runVerifyCheck",false);
                component.set("v.verifyCheckbox",false);
            }
        });
        $A.enqueueAction(action);
	}
})
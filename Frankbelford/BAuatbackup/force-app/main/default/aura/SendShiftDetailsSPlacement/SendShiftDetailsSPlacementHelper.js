({
	getSPlacementDetail : function(component) {
		var action = component.get("c.getSPlacementDetail");
		action.setParams({"splacementId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
            console.log('+++result+++'+result);
			if(state === "SUCCESS") {				
				if(result == 'true'){
					component.set("v.messageDisplay",'Email sent successfully.');
					component.set("v.processingText",false);
					 component.set("v.successMessage",true);
					$A.get('e.force:refreshView').fire();
       				 $A.get("e.force:closeQuickAction").fire();
				}
				else if(result == 'false'){
					component.set("v.messageDisplay",'Error occurred in sending email. Your admin has been notified.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
				else if(result == 'placementnotactive'){
					component.set("v.messageDisplay",'Placement should be active before sending the details.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
				else if(result == 'candidateEmailBlank'){
					component.set("v.messageDisplay",'Candidate Email is blank.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
                else if(result == 'shift_details_already_sent'){
					component.set("v.messageDisplay",'Shift details already sent.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
			}
            else{
                console.log('1111111111111111');
				component.set("v.messageDisplay",result);
				component.set("v.processingText",false);
				component.set("v.errorMessage",true);
            }
        });
        $A.enqueueAction(action);
	}
})
({
	siteDetailsUpdate : function(component) {
		var action = component.get("c.getSiteDetail");
		action.setParams({"siteId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				if(result == 'true'){
					component.set("v.messageDisplay",'Email sent successfully.');
					component.set("v.processingText",false);
					component.set("v.successMessage",true);
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
					/*setTimeout(function(){
                        window.location.reload(); 
                    }, 1500);*/
				}
				else if(result == 'false'){
					component.set("v.messageDisplay",'Error occurred in sending email. Your admin has been notified.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
				else if(result == 'errorMessage'){
					component.set("v.messageDisplay",'The site is not marked for sending the Shift details.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
				else if(result == 'candidateEmailBlank'){
					component.set("v.messageDisplay",'Candidate Email is blank.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
			}
            else{
				component.set("v.messageDisplay",result);
				component.set("v.processingText",false);
				component.set("v.errorMessage",true);
            }
        });
        $A.enqueueAction(action);
	}
})
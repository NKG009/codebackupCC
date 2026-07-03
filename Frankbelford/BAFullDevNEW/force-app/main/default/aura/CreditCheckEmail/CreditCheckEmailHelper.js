({
	accountDetailsUpdate : function(component) {
		var action = component.get("c.getAccountDetail");
		action.setParams({"accountId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				if(result == 'true'){
                    component.set("v.Creditvalue",false);
					component.set("v.processingText",false);
					component.set("v.successMessage",true);
                  //  $A.get('e.force:refreshView').fire();
                  //  $A.get("e.force:closeQuickAction").fire();
					/*setTimeout(function(){
                        window.location.reload(); 
                    }, 1500);*/
				}
				else if(result == 'false'){
					component.set("v.messageDisplay",'Error occurred in sending email. Your admin has been notified.');
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
				}
				else if(result == 'requireddetailsmissing'){
					component.set("v.Creditvalue",false);
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
	},
    accvaluefalse : function(component)
    {
       var action = component.get("c.accountsetfalse");
		action.setParams({"accountId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++263'+state);
			if(state === "SUCCESS") {				
				console.log('Success');
                 window.location.reload();    
            }
        });
        $A.enqueueAction(action); 
    },
    accountonLoad : function(component) {
		var action = component.get("c.getcreditvalue");
		action.setParams({"accountId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				if(result == 'true'){
					component.set("v.Creditvalue",true);
                }
                else{
                   component.set("v.Creditvalue",false); 
                }
                    
            }
        });
        $A.enqueueAction(action);
    }                                 
})
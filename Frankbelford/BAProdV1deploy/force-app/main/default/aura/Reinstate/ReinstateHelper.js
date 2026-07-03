({
	getPayProfileInfo : function(component) {        
		var action = component.get("c.getPayProfileDetail");
		action.setParams({"payProfileId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
            console.log('+++result+++'+result);
            console.log('+++result.IP_Status__c+++'+result.IP_Status__c);
			if(state === "SUCCESS") {				
				if(result.IP_Status__c == 'Active'){
                    component.set("v.processingText",false);
                    component.set("v.displayConfirmMessage",true);
				}
                else if(result.IP_Status__c == 'Inactive'){					
                    this.handleHelperMethod(component);
				}
			}
            else{
				component.set("v.messageDisplay",result);
				component.set("v.errorMessage",true);
            }
        });
        $A.enqueueAction(action);
	},
    handleHelperMethod : function(component) {
		var action = component.get("c.updatedata");
		action.setParams({"payProfileId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state1111+++'+state);
            console.log('+++result1111+++'+result);
			if(state === "SUCCESS") {				
				if(result == $A.get("$Label.c.Reinstate_Success")){
                    component.set("v.processingText",false);
					component.set("v.messageDisplay",$A.get("$Label.c.Reinstate_Success"));
                    component.set("v.successMessage",true);
                    component.set("v.displayConfirmMessage",false);
                    $A.get('e.force:refreshView').fire();
                    //$A.get("e.force:closeQuickAction").fire();
                    /*setTimeout(function(){
                        window.location.reload(); 
                    }, 2500);*/
				}
				else {
					component.set("v.messageDisplay","An unexpected Error has Occurred. "+result);
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);
                    component.set("v.displayConfirmMessage",false);
				}
			}
            else{
				component.set("v.messageDisplay","An unexpected Error has Occurred. "+result);
                component.set("v.processingText",false);
                component.set("v.displayConfirmMessage",false);
                component.set("v.errorMessage",true);
            }
        });
        $A.enqueueAction(action);
	}
})
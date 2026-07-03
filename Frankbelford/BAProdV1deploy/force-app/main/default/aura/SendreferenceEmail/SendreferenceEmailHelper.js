({
	getReferenceInfo : function(component) {
		var action = component.get("c.getreferenceDetail");
		action.setParams({"referenceid": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {	                
                if(result.ts2__Email__c == '' || result.ts2__Email__c == null)
                {
                   component.set("v.processingText",false);
                    component.set("v.missingrefreeemail",true); 
                    component.set("v.messageDisplay",'Please provide referee email');
                     console.log('check result in if 1');
                }
                else {
                    console.log('check result in else if 2');
					component.set("v.processingText",false);
                    this.handleHelperMethod(component);
                     
				}
			}
            else{
				component.set("v.messageDisplay",result);
				component.set("v.processingText",false);
				component.set("v.errorMessage",true);
                 console.log('check result in else');
            }
        });
        $A.enqueueAction(action);
	},
    handleHelperMethod : function(component) {
		var action = component.get("c.sendemail");
		action.setParams({"referenceid": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++123'+state);
			if(state === "SUCCESS") {				
				if(result == 'Email Sent'){
					component.set("v.messageDisplay",'Email Sent');
                    component.set("v.successMessage",true);                  
                    setTimeout(function(){
                       $A.get('e.force:refreshView').fire();
        			$A.get("e.force:closeQuickAction").fire();  
                    }, 2500);
				}
				else {
					component.set("v.messageDisplay",result);
					component.set("v.processingText",false);
					component.set("v.errorMessage",true);                 
				}
			}
            else{
				component.set("v.messageDisplay","An unexpected Error has Occurred. "+result);
                component.set("v.processingText",false);               
                component.set("v.errorMessage",true);
            }
        });
        $A.enqueueAction(action);
	}
})
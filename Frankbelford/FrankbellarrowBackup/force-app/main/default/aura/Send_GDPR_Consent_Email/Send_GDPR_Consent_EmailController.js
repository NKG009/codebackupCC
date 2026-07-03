({
	doInit : function(component, event, helper) {
        //component.set("v.processingStatus", true);
        var action = component.get("c.getContact");
        action.setParams({"contactId": component.get("v.recordId")});
        
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
				var records = response.getReturnValue();
				component.set("v.singleRec", records);
                var requestdate = component.get("v.singleRec.IP_Last_Consent_Requested__c");
                console.log('+++requestdate+++'+requestdate);
				var requestby = component.get("v.singleRec.IP_Last_Consent_Requested_By__c");
				console.log('+++requestby+++'+requestby);
				var checktime = new Date(requestdate); 
				var checkdate = checktime.toLocaleDateString(); 
				var checktime = checktime.toLocaleTimeString(); 
				var requestdateformula = checkdate + ' ' + checktime;
                console.log('+++requestdateformula+++'+requestdateformula);
                console.log('+++checkdate+++'+checkdate);
                console.log('+++checktime+++'+checktime);
				component.set("v.datecheck", requestdateformula);
				component.set("v.requestBy", requestby);
				if((requestdate ==  null || requestdate == undefined) && (requestby == null || requestby == undefined)){
					component.set("v.processingStatus", true);
					helper.handleHelperMethod(component);
				}
				else{
                    component.set("v.processingStatus", false);
					component.set("v.displayConfirmMessage", true);
				}
            } else {
                
            }
        });
        $A.enqueueAction(action);
	},
	
	handleClick : function(component, event, helper) {
        component.set("v.processingStatus", false);
		helper.handleHelperMethod(component, event, helper);        
	},
	
	cancel : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
})
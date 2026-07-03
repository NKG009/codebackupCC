({
	doInit : function(component, event, helper) {
        console.log(component.get("v.recordId"));
		var action = component.get('c.updateOwnershipNameByAccountId'); 
        action.setParams({
            "accountId" : component.get("v.recordId")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var responseMsg = response.getReturnValue();
                var toastType = responseMsg.includes('Success') ? 'success' : 'error';
                helper.showToast(toastType, responseMsg);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else {
                helper.showToast('error', response.getError()[0].message);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
	}

})
({
	ResetButton : function(component) {
        
        var action = component.get("c.resetButtonMethod");
        action.setParams({"BatchId": component.get("v.recordId")});
		action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
			if(state === "SUCCESS") {	
            component.set("v.processingText",false);
            component.set("v.processingBatch",true);
            component.set("v.Messagefromapx",result);
            }
            });
         $A.enqueueAction(action);
        
	}
   
})
({
	 getTimesheetLines : function(component) {
        var action = component.get("c.getTimesheetLines");
		action.setParams({"contactId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {
				var result = response.getReturnValue();
				console.log('++++++++++result+++++ '+result);
				component.set("v.timesheetLinesList",result);
				
			}
        });
        $A.enqueueAction(action);
    },
	
	getShifts : function(component) {
        var action = component.get("c.getShifts");
		action.setParams({"contactId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {
				var result = response.getReturnValue();
				console.log('++++++++++result+++++ '+result);
				component.set("v.shiftsList",result);
				console.log('++++++++++component.set("v.shiftsList",result);+++++ '+component.get("v.shiftsList"));
			}
        });
        $A.enqueueAction(action);
    }
})
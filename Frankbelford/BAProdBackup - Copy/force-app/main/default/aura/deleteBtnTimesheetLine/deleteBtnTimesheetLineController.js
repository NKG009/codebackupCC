({
	doInit : function(component, event, helper) {
        component.set("v.ConfirmMessage",true);
        
	},
    SubmitBtn : function(component, event, helper) {
        
        component.set("v.ConfirmMessage",false);
        component.set("v.processingText",true);
        var action = component.get("c.deletemethod");
        
        action.setParams({"Iddel": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                component.set("v.Message",result);
                if(result=='Successfully Deleted'){
                    window.open('/lightning/o/sirenum__Timesheet_Line__c/home','_self');
                }
            }
             });
        $A.enqueueAction(action);
        
        
	},
    cancelAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
	}
})
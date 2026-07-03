({
	doInit : function(component, event, helper) {
		component.set("v.processingText",true);
		helper.getPayProfileInfo(component);
	},
    handleClick : function(component, event, helper) {
        component.set("v.processingText", false);
		helper.handleHelperMethod(component);        
	},
	
	cancel : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
    
})
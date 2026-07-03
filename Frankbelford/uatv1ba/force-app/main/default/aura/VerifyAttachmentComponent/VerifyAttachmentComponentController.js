({
	doInit : function(component, event, helper) {
        component.set("v.processingText",true);
		helper.getCertificationAttachment(component);
	},
    
    cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    handleCheck : function(component, event, helper) {
        var isChecked = component.find("verify").get("v.checked");
        console.log('++++++++++isChecked+++++ '+isChecked);
        //component.set("v.DisclaimerValue", isChecked);
    },
    
    handleClick : function(component, event, helper) {
        var isChecked = component.find("verify").get("v.checked");
        helper.updateCertificationRecord(component,isChecked);
    }
})
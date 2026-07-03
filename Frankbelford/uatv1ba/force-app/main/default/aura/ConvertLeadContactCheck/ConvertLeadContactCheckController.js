({
	doInit : function(component, event, helper) {        
        helper.getMatchingContactList(component);
	},
    
    cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    ConvertNewContact : function(component, event, helper) {
        helper.ConvertNewContact(component);
	},
    
    onCheck : function(component, event, helper) {
        var selectedCheckbox = event.getSource().get("v.value");
        component.set("v.createNewContactCheckbox", selectedCheckbox);
	},
})
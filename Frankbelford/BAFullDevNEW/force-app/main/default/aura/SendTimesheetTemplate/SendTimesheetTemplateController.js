({
	doInit : function(component, event, helper) {
        component.set("v.processingText",true);
		helper.sPlacementGetDetails(component);
	},
    cancelClick : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
	},
    doSave : function(component, event, helper) {
        console.log('Save Clicked');
        helper.sPlacementSaveDetails(component);
	},
    doPrint : function(component, event, helper) {
        console.log('Print Clicked');
        helper.sPlacementPrintDetails(component, event);
	}
})
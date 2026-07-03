({
	doInit : function(component, event, helper) {
        component.set("v.processingText",true);
		helper.payProfileDetailsUpdate(component);
	}
})
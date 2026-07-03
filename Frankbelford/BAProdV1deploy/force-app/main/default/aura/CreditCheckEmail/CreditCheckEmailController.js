({
	doInit : function(component, event, helper) {
        component.set("v.processingText",false);
		helper.accountonLoad(component);
	},
    sendemail : function(component, event, helper) {
        component.set("v.Creditvalue",false);
        component.set("v.processingText",false);
		helper.accountDetailsUpdate(component);
    },
    handleCloseModal: function(component, event, helper) {
        //For Close Modal, Set the "openModal" attribute to "fasle"  
        component.set("v.Creditvalue", false);
        helper.accvaluefalse(component);
    }
})
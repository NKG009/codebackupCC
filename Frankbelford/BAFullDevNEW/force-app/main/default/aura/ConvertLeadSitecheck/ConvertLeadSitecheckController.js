({
	doInit : function(component, event, helper) {
		component.set("v.displayConvertLeadSiteCheckScreen",true);
        helper.getMatchingSiteList(component);
	},
    
    convertToNewSite: function(component, event, helper) {
        helper.convertToNewSite(component, event);
    },
    
    convertToSelectedSite: function(component, event, helper) {
        helper.convertToSelectedSite(component, event);
    },
    
    cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    onCheck: function(component, event) {
		var selectedCheckbox = event.getSource().get("v.value");
        var getAllCheckboxes = component.find("taskCheckBox"); 
        var counter = 0;
		var selectedSite = [];
        console.log('+++++++getAllCheckboxes++'+getAllCheckboxes);
        console.log('+++++++getAllCheckboxes.length++'+getAllCheckboxes.length); 
        console.log('+++++++val++'+event.getSource().get("v.value"));
		console.log('+++++++text++'+event.getSource().get("v.text"));
        if (getAllCheckboxes.length == undefined && selectedCheckbox == true) {
            component.set("v.selectedSiteIds",event.getSource().get("v.text"));
            counter = 1;
            component.set("v.checkboxSelected",counter);            
        } else {
            for (var i = 0; i < getAllCheckboxes.length; i++) {
                console.log('+++++++getAllCheckboxes++'+getAllCheckboxes[i].get("v.value")); 
                console.log('+++++++getAllCheckboxes++'+getAllCheckboxes.length); 
                if (getAllCheckboxes[i].get("v.value") == true) {
                    selectedSite.push(getAllCheckboxes[i].get("v.text"));
                    console.log('++++++getAllCheckboxes++++++'+getAllCheckboxes[i].get("v.text"));
                    counter = counter + 1;
                }
            }
            component.set("v.checkboxSelected",counter);
            component.set("v.selectedSiteIds",selectedSite);
            console.log('+++++++++selectedSiteIds++++++++++'+component.get("v.selectedSiteIds"));
        }
	 }
})
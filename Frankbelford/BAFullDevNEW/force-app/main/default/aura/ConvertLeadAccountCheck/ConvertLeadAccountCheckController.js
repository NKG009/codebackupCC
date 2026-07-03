({
	doInit: function(component, event, helper) {
        component.set("v.displayConvertLeadAccountCheckScreen",true);
        helper.getMatchingAccountList(component);
    },
    
    cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    convertToSelectedAccount: function(component, event, helper) {
        helper.convertToSelectedAccount(component, event);
    },
    
    convertToNewAccount: function(component, event, helper) {
        helper.convertToNewAccount(component, event);
    },
    
    onCheck: function(component, event) {
		var selectedCheckbox = event.getSource().get("v.value");
        var getAllCheckboxes = component.find("taskCheckBox");
        var counter = 0;
		var selectedAccount = [];
        if (getAllCheckboxes.length == undefined && selectedCheckbox == true){
            component.set("v.selectedAccountIds",event.getSource().get("v.text"));
            counter = 1;
            component.set("v.checkboxSelected",counter); 
        }
        else{
            for (var i = 0; i < getAllCheckboxes.length; i++) {
                if (getAllCheckboxes[i].get("v.value") == true) {
                    selectedAccount.push(getAllCheckboxes[i].get("v.text"));
                    console.log('++++++getAllCheckboxes++++++'+getAllCheckboxes[i].get("v.text"));
                    counter = counter + 1;
                }
            }
            component.set("v.checkboxSelected",counter);
        	component.set("v.selectedAccountIds",selectedAccount);
        }
	 }
})
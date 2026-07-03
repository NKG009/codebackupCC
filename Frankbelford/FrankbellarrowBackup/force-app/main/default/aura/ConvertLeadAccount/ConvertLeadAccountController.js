({
	doInit: function(component, event, helper) {
        component.set("v.displayConvertLeadAccountScreen",true);
        helper.getAccountPicklist(component, event);        
    },
    
    cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    handleAccountOnChange : function(component, event, helper) {
        var selectedAccount = event.getSource().get("v.value");
        component.set("v.selectedAccountValue",selectedAccount);
	},
    
    continueClick : function(component, event, helper) {
        var selectedAccountId = component.get("v.selectedValue");
        if(selectedAccountId=='--None--' || selectedAccountId==undefined  || selectedAccountId==''){
            alert('Please specify account');
        }
        else if(selectedAccountId=='Create New Account:'){
        	component.set("v.displayConvertLeadAccountScreen",false);
            component.set("v.displayConvertLeadAccountCheckScreen",true);
        }
        else{
            component.set("v.displayConvertLeadAccountScreen",false);
            component.set("v.displayConvertLeadSiteCheckScreen",true);    
        }
	},
    
    openAccountInformation : function(component, event, helper) {        
        helper.openSelectedAccountpage(component ,event);
	},
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
       console.log('++++++selectedAccountGetFromEvent+++++++++++'+selectedAccountGetFromEvent);
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent);
       console.log('++++++handleComponentEvent+++++++++++'+component.get("v.selectedRecord"));
	   helper.getAccountFromLookUp(component ,event);
    },
})
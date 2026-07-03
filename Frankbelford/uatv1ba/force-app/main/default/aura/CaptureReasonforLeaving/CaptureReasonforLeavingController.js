({
	cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    oKClick : function(component, event, helper) {
		$A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
	},
    
    handleClick : function(component, event, helper) {
        var selectedleavingreason = component.find("mygroup").get("v.value");
        console.log('+++++++++'+component.get("v.selectedContact"));
        console.log('+++++selectedleavingreason++++'+selectedleavingreason);
		var action = component.get("c.processprofiles");
        action.setParams({"selectedleavingreason": selectedleavingreason,"contactId": component.get("v.selectedContact")});
		        
        // Configure response handler 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
				console.log('++++storeResponse+++++'+storeResponse);
                if(storeResponse == "ConfirmMessage"){
					component.set("v.message",$A.get("$Label.c.P45B2Ferror9"));
					component.set("v.colorOfMessageConfirm",true);
                     component.set("v.colorOfMessageError",false);
                    component.set("v.displayOkButton", true);
                    component.set("v.displayContinueCancelButtons", false); 
                }
                else if(storeResponse == "LeavingReaseonBlank"){
					component.set("v.message",$A.get("$Label.c.P45B2Ferror10"));
					component.set("v.colorOfMessageError",true);
                    component.set("v.colorOfMessageConfirm",false);
                }
				else if(storeResponse == "ConfirmMessageSecond"){
					component.set("v.message",$A.get("$Label.c.P45B2Ferror8"));
					component.set("v.colorOfMessageConfirm",true);
                    component.set("v.colorOfMessageError",false);
                    component.set("v.displayOkButton", true); 
                    component.set("v.displayContinueCancelButtons", false); 
				}
				else{
					component.set("v.message",storeResponse);
					component.set("v.colorOfMessageError",true);
                    component.set("v.colorOfMessageConfirm",false);
                    setTimeout(function(){
                        window.location.reload(); 
                    }, 1500);
				}
            } else {
				component.set("v.message",storeResponse);
				component.set("v.colorOfMessageError",true);
                component.set("v.colorOfMessageConfirm",false);
            }
        });
        $A.enqueueAction(action);
	},
    
    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");
    },
    
    doInit : function(component, event, helper) {
        var action = component.get("c.buttonsDisplayed");
        console.log('+++srgddgrdgrd++++++'+component.get("v.selectedContact"));
        // Configure response handler 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse == 'Both Null'){
					component.set("v.displayContinueCancelButtons", true); 
                }
                else{
					component.set("v.displayOkButton", true); 
                }
            } else {
                //window.location.reload();
            }
        });
        $A.enqueueAction(action);
	},
})
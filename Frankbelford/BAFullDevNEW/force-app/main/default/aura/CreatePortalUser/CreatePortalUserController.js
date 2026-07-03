({	
    doInit : function(component, event, helper) {
        var clientUserProfileName = $A.get("$Label.c.Client_Portal_User_Profile");
        component.set("v.clientUserProfileName", clientUserProfileName);
        alert("clientUserProfileName::> " + clientUserProfileName);

        console.log('++++++++++contact id+++++'+component.get("v.recordId"));
        helper.doInitCallToServer(component);
	},
    
    doSuccess : function(component, event, helper) {
        console.log('++++++++++success id+++++');
        component.set("v.disabled", true);  
        component.set("v.showSpinner", true); 
    },
    
    doError : function(component, event, helper) {
        console.log('++++++++++error id+++++');
		component.set("v.disabled", false);  
        component.set("v.showSpinner", false);       
    },
    cancelClick : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},
    saveUserDetails: function(component, event, helper) { 
        console.log('++++++++++inside submit id+++++');
        event.preventDefault();//stops the default save from happening.
        component.set("v.disabled",true);
        helper.submitUserData(component, event, helper);         
    },
})
({
	handleClick : function(component, event, helper) {
		var leavingoptions = component.find("mygroup").get("v.value");
        console.log('+++++leavingoptions++++'+leavingoptions);
        var listPayProfiles = component.get("v.listPayProfiles");
        
        console.log('+++++listPayProfiles++++'+listPayProfiles);
        //To check if list is not empty or null
		
		var action = component.get("c.checkandproceed");
            
		var payProfileRecords = JSON.stringify(listPayProfiles);
		console.log('+++++payProfileRecords++++'+payProfileRecords);
		if(leavingoptions == 'Leaving'){
			action.setParams({payProfileRecords : null,"leavingoptions": leavingoptions,"contactId": component.get("v.selectedContact")});
		}
		else{
			action.setParams({payProfileRecords : payProfileRecords,"leavingoptions": leavingoptions,"contactId": component.get("v.selectedContact")});
		}
		
		action.setCallback(this,function(a){
			//get the response state
			var state = a.getState();
			console.log('+++++state'+state);
			//check if result is successful
			if(state == "SUCCESS"){
				var result = a.getReturnValue();
				if(result == 'openCaptureReasonforLeaving'){
					component.set("v.openCaptureReasonforLeaving",true);
                    component.set("v.sectionCandidateP45Action",false);
					component.set("v.displayOkButton", false);
				}
				else if(result == 'Please select a Pay Profile to close.'){
					component.set("v.displayOkButton", false);
					component.set("v.redColorMessage", true);
					component.set("v.displayMessage", result);
				}
				else if(result == $A.get("$Label.c.P45B2Ferror8") || result == $A.get("$Label.c.P45B2Ferror9")){
					component.set("v.greenColorMessage", true);
					component.set("v.displayMessage", result);
					component.set("v.displayOkButton", true);
                    component.set("v.displayContinueCancelButtons", false);
				}
				else if(result == $A.get("$Label.c.P45B2Ferror6")){
					component.set("v.blackColorMessage", true);
					component.set("v.displayMessage", result);
					component.set("v.displayOkButton", true);
                    component.set("v.displayContinueCancelButtons", false);
				}
				else{
					component.set("v.redColorMessage", true);
					component.set("v.displayMessage", result);
					component.set("v.displayOkButton", true);
                    component.set("v.displayContinueCancelButtons", false);
				}
				console.log('+++++++result++'+result);
			} else if(state == "ERROR"){
				console.log('+++++Error in calling server side action');
				alert('Error in calling server side action');
			}
		});
		
		//adds the server-side action to the queue  		
		$A.enqueueAction(action);
	},
    
    handleChange: function (component, event) {
       component.set("v.displayMessage", '');
      var changeValue = event.getParam("value");
        console.log('+++++changeValue++++'+changeValue);
        var action = component.get("c.checkSelectedValue");
        action.setParams({"leavingoptions": changeValue,"contactId": component.get("v.selectedContact")});
		console.log('+++++++++'+component.get("v.selectedContact"));
        
         //Setting the Callback
		action.setCallback(this,function(a){
			//get the response state
			var state = a.getState();
			
			//check if result is successful
			if(state == "SUCCESS"){
				var result = a.getReturnValue();
				if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
					component.set("v.listPayProfiles",result);
					component.set("v.displayTable",true);
				}
				else{
					component.set("v.displayTable",false);
				}
				console.log('+++++++result++'+result);
			} else if(state == "ERROR"){
				alert('Error in calling server side action');
			}
		});
		
		//adds the server-side action to the queue        
		$A.enqueueAction(action);
    },
    
    cancelClick : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},
    
    oKClick : function(component, event, helper) {
		$A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
	},
    
    doInit : function(component, event, helper) {
        var action = component.get("c.buttonsDisplayed");
        
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
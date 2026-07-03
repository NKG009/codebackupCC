({
	convertToNewAccount : function(component, event) {
        if(component.get("v.checkboxSelected")>0){
            alert('Please unselect existing account.');
        }
        else{
            var action = component.get("c.ConvertToNewAccount");
            action.setParams({"newBusinessLeadId": component.get("v.selectedNewBusinessLead")});
             
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                console.log('+++state+++'+state);
                if(state === "SUCCESS") {				
                    console.log('++++++++++result+++++ '+result);
                    if(result =='InquiryUpdated'){
                        $A.get('e.force:refreshView').fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        /*var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                          "recordId": component.get("v.selectedNewBusinessLead"),
                          "slideDevName": "detail"
                        });
                        navEvt.fire();*/
                    }else {
                        component.set("v.messageDisplay",result);
                        component.set("v.errorMessage",true);            
                    }
                }
                else{
                    component.set("v.messageDisplay",result);
                    component.set("v.errorMessage",true);
                }
            });
            $A.enqueueAction(action);
    	}
	},
    
    convertToSelectedAccount : function(component, event) {
        console.log('+++++++++convertToSelectedAccount++++++++++'+component.get("v.checkboxSelected"));
        if(component.get("v.checkboxSelected")==0 || 
           	component.get("v.checkboxSelected")==undefined){
            alert('Please select an existing account.');
        }
        else if(component.get("v.checkboxSelected")>1){
            alert('Please select only one account.');
        }
        else {
            var obj=component.get('v.selectedAccountIds');
            console.log('+++++++++obj++++++++++'+obj);
            for(var i=0;i<obj.length;i++){
                component.set("v.selectedAccountValue",obj[i]);
            }
            console.log('+++++++++component.set(selectedAccountValue,obj[i])++++++++++'+component.get("v.selectedAccountValue"));
            component.set("v.displayConvertLeadAccountCheckScreen",false);
            component.set("v.displayConvertLeadSiteCheckScreen",true);
        }
    },
    
    getMatchingAccountList : function(component, event) {
		var action = component.get("c.getMatchingAccountList");
		action.setParams({"newBusinessLeadId": component.get("v.selectedNewBusinessLead")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++statevalue+++'+state);
			if(state === "SUCCESS") {
                console.log('+++resultvalue+++'+result);
				if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    console.log('+++11111111111+++');
					component.set("v.listMatchingAccounts",result);
					component.set("v.displayTable",true);
				}
				else{
					component.set("v.displayTable",false);
				}
				console.log('+++++++result++'+result);
			}
            else{
                
            }
        });
        $A.enqueueAction(action);        
    },
})
({
	getMatchingContactList : function(component, event) {
        var action = component.get("c.getMatchingContactList");
		action.setParams({"newBusinessLeadId": component.get("v.selectedNewBusinessLead")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++statevalue+++'+state);
			if(state === "SUCCESS") {
                console.log('+++resultvalue+++'+result);
				if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
					component.set("v.listMatchingContacts",result);
					component.set("v.displayTable",true);
				}
				else{
					component.set("v.displayTable",false);
				}
			}
            else{
                
            }
        });
        $A.enqueueAction(action);        
    },
    
    ConvertNewContact : function(component, event) {
        var action = component.get("c.convertNewContact");        
        action.setParams({
            "newBusinessLeadId": component.get("v.selectedNewBusinessLead"),
            "selectedAccountId": component.get("v.selectedAccountId"),
            "checboxSelected": component.get("v.createNewContactCheckbox"),
            "siteId": component.get("v.selectedSiteId")
        });
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++response+++'+response);
            console.log('+++ConvertNewContactstate+++'+state);
            console.log('+++ConvertNewContactresult+++'+result);
            if(state == "SUCCESS") {
                if(result =='InquiryUpdated' || result =='ContactInsertedInquiryUpdated'){
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
        			dismissActionPanel.fire();
                    /*var sObectEvent = $A.get("e.force:navigateToSObject");
                        sObectEvent .setParams({
                        "recordId": component.get("v.selectedNewBusinessLead") ,
                        "slideDevName": "detail"
                      });
          			sObectEvent.fire();*/
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
})
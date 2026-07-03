({
	getSiteContactLink : function(component,result) {
		var action = component.get("c.getSiteContactLink");
		action.setParams({"contactId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {
                component.find('accountId').set('v.value', result.AccountId);
			}
            else{
            }
        });
        $A.enqueueAction(action);
	},
    
    populateSiteContactData : function (component, event,helper) {
        console.log('++++++++++inside payload+++++ ');
        var payload = event.getParam("fields");
		//var contactId = component.get("v.recordId");
        var contactId = component.get("v.recordId");
        var site_Contact_Data = {
            "IP_Contact__c" : contactId,
            "IP_PortalType__c" : payload["IP_PortalType__c"],
            "IP_Site__c" : payload["IP_Site__c"],
            "Account__c" : payload["Account__c"]
        };
        return site_Contact_Data;
    },
    
    submitSiteContactData : function(component, event, helper) { 
        var site_Contact_Data = this.populateSiteContactData(component, event,helper);
		console.log('++++++++++inside payload+++++ '+site_Contact_Data.IP_Site__c);
		if(component.get("v.selectedLookUpRecord").Id == '' || component.get("v.selectedLookUpRecord").Id == null || component.get("v.selectedLookUpRecord").Id == undefined){
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				 type: 'error',
				 message: 'Site cannot be blank'
			});
			toastEvent.fire();
		}
		else if(site_Contact_Data.IP_Contact__c == '' || site_Contact_Data.IP_Contact__c == null || site_Contact_Data.IP_Contact__c == undefined){
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				 type: 'error',
				 message: 'Contact cannot be blank'
			});
			toastEvent.fire();
		}
		else if(site_Contact_Data.Account__c == '' || site_Contact_Data.Account__c == null || site_Contact_Data.Account__c == undefined){
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				 type: 'error',
				 message: 'Account cannot be blank'
			});
			toastEvent.fire();
		}
		else{
            var siteId = component.get("v.selectedLookUpRecord").Id;
			console.log('++++++++++site_Contact_Data id+++++ '+site_Contact_Data.IP_Contact__c);
			var action = component.get("c.saveNewRecord");
            action.setParams({"siteContactData": site_Contact_Data,"siteId":siteId});
			action.setCallback(this, function(response) {
				var state = response.getState();
				var result = response.getReturnValue();
				console.log('+++state+++'+state);
                console.log('+++result+++'+result);
				if(state === "SUCCESS") {				
					if(result.includes("success")){
                       result = result.slice(0,-7);
						var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
						  "recordId": result
						});
						navEvt.fire();
                        var delayInMilliseconds = 500;
                            window.setTimeout(
                            $A.getCallback(function() {
                             window.location.reload();
                                 }), delayInMilliseconds
                        );
					}
					else{
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							 type: 'error',
							 message: result
						});
						toastEvent.fire();
					}
				}else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						 type: 'error',
						 message: result
					});
					toastEvent.fire();
				}
			});
			$A.enqueueAction(action);
		}
    }
})
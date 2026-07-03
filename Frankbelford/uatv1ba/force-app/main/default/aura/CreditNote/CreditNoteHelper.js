({
	getplacementInfo : function(component) {
		var action = component.get("c.getplacementDetail");
		action.setParams({"placeid": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {	                
                if(result.IP_LastPassedToTempest__c == '' || result.IP_LastPassedToTempest__c == null || result.IP_InvoiceNumber__c == '' || result.IP_InvoiceNumber__c == null || result.IP_InvoiceDate__c == '' || result.IP_InvoiceDate__c == null)
                {
                   component.set("v.processingText",false);
                    component.set("v.missingdetails",true); 
                    component.set("v.messageDisplay",'This placement has not yet passed to Tempest and is not invoiced');
                     console.log('check result in if 1');
                }
                else {
                    console.log('check result in else if 2');
					component.set("v.processingText",false);
                    this.handleHelperMethod(component);
                     
				}
			}
            else{
				component.set("v.messageDisplay",result);
				component.set("v.processingText",false);
				component.set("v.errorMessage",true);
                 console.log('check result in else');
            }
        });
        $A.enqueueAction(action);
	},
        handleHelperMethod : function(component) {
		 var recordId = component.get("v.recordId");
        var url = '/apex/CreditCalculation?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
        }
})
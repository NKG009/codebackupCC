({
	getNewBusinessDetails : function(component) {
		var action = component.get("c.getNewBusinessDetails");
		action.setParams({"newBusinessLeadId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				console.log('++++++++++result+++++ '+JSON.stringify(result));
                if(result.Business_Type__c=='' || result.Business_Type__c==null){
                    component.set("v.messageDisplay",'Business Type is mandatory at conversion.');
                	component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);
                }else if((result.Contact_First_Name__c=='' || result.Contact_First_Name__c==null)
                        || (result.Contact_Last_Name__c=='' || result.Contact_Last_Name__c==null)){
                    component.set("v.messageDisplay",'First Name and Last Name are mandatory.');
                    component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);             
                }
                else if(result.Converted__c){
                    component.set("v.messageDisplay",'This contact has already been converted.');
                    component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);               
                }
                else{
                    component.set("v.displayConvertLeadAccountScreen",true);
                    component.set("v.errorMessage",false);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);
                }
			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.errorMessage",true);
                component.set("v.successMessage",false);
				component.set("v.processingText",false);
            }
        });
        $A.enqueueAction(action);
	}
})
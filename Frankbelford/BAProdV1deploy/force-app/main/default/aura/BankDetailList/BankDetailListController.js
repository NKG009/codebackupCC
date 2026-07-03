({
    doInit: function(component, event, helper) 
    {
        var action = component.get("c.getDefaultBankDetail");
        
        action.setCallback(this, function(response) {
            var records = response.getReturnValue();
            component.set("v.AccountList", records);
            console.log('recorsd---'+records);
        });
        $A.enqueueAction(action); 
        
        var action = component.get("c.getPaymentType");
        action.setCallback(this, function(response) {
            var records = response.getReturnValue();
            component.set("v.PaymentType", records);
        });
        $A.enqueueAction(action); 
    },
    
    
    getPaymentTypeList:function(component, event, helper) 
    {
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('record ids--'+ids);
        var action = component.get("c.BankDetail");
        action.setParams({ 'recordId': ids });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (response.getReturnValue().length == 0) {
                component.set("v.Message", true);
            } else {
                component.set("v.Message", false);
            }
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.AccountList",response.getReturnValue());        
            }else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBankDetails:function(component, event, helper) 
    {
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('record ids--'+ids);
        var action = component.get("c.BankDetail");
        action.setParams({ 'recordId': ids });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (response.getReturnValue().length == 0) {
                component.set("v.Message", true);
            } else {
                component.set("v.Message", false);
            }
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.AccountList",response.getReturnValue());        
            }else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    /*
    Save: function(component, event, helper) 
    {		
        var action = component.get("c.savePP");        
        var formvalues = component.get("v.AccountList");
       
         console.log('000000--'+event.getSource().get("v.value"));
        
        action.setParams({ 'lstAccount': component.get("v.AccountList") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Update',
                    message: 'record(s) updated successfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky'
                });
                toastEvent.fire();   
                
                var storeResponse = response.getReturnValue();              
                component.set("v.AccountList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
            }else{
                component.set("v.showSaveCancelBtn",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    cancel : function(component,event,helper){
        // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },*/
    backtomydetails: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/my-details" });
        urlEvent.fire();
    },
})
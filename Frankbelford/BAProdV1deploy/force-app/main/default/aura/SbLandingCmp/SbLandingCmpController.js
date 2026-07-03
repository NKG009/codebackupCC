({
    //**********************************************
	onInit : function(component, event, helper) {
        
        helper.prepareComponent( component );
		component.set("v.showSpinner", false);
        var action = component.get("c.getPageLayoutFields");
        action.setParams({ objectType: component.get("v.objectType") });
		action.setCallback(this, function(response) {
            var state = response.getState();
            
			if (state === "SUCCESS") {
                component.set("v.layoutSections", response.getReturnValue() );
                component.set("v.showSpinner", false);
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE: ' + response);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log( 'ERROR: getPageLayoutFields', errors );
            }
        });

        $A.enqueueAction(action);
    },

    //**********************************************
    handleOnload : function(component, event, helper) {
         if (!$A.util.isEmpty(component.get("v.sourceId"))) {
            component.find("sourceLookup").set("v.value", component.get("v.sourceId")); // requires inputFields to have aura:id
         }

         helper.autocompleteFields(component);
    },

    //**********************************************
    handleCancel : function(component, event, helper) {
        console.log('Closing, with recordId: ', component.get("v.recordId"));
        let inLexApp = component.get("v.inLexApp");
        if (inLexApp==false){
        	$A.get("e.force:closeQuickAction").fire();
        }
        let redirectURL = component.get("v.recordId");
        if (inLexApp==false && (redirectURL == null || redirectURL == '')){
            redirectURL = 'lightning/page/home';
        }
        else if (inLexApp==true && (redirectURL == null || redirectURL == '')){
            redirectURL = '/home/home.jsp';
        }
        helper.navigateToUrl(redirectURL, component);
    },

    //**********************************************
    handleSubmit : function(component, event, helper) {
        let createMode = component.get("v.inCreateMode");
        let inLexApp = component.get("v.inLexApp");
        
        //If in 'modal' mode (Lightning)
        if (createMode && !inLexApp) {
            component.find("formCreateModal").submit();
        }
        else if (!createMode && !inLexApp){
            component.find("formUpdateModal").submit();
        }
        //If in Lex App (Classic)
        else if(createMode && inLexApp){
            component.find("formCreateApp").submit();
        }
        else if(!createMode && inLexApp){
            component.find("formUpdateApp").submit();
        }
        
    },
    
    //**********************************************
    handleOnSuccess : function(component, event, helper) {
        
        let toast = $A.get("e.force:showToast");
        let inLexApp = component.get("v.inLexApp");
        let inCreateMode = component.get("v.inCreateMode");
        let record = event.getParam("response");
        
        let actionType;
        if (inCreateMode){
            actionType = 'CREATE';
        }
        else{
            actionType = 'UPDATE';
        }

        console.log('About to call SB: ' + component.get("v.sbNotify") + ' objectType: ' + component.get("v.objectType"));
        //Invoke SB Notify via Controller
        var action = component.get("c.notifySourceBreaker");    
        action.setParams({ 
            recordId: record.id,
            sbNotice: component.get("v.sbNotify"),
            objectType: component.get("v.objectType"),
            action: actionType,
            callOutURL: component.get("v.callOutURL")
         });
		action.setCallback(this, function(response) {
            var state = response.getState();
            
			if (state === "SUCCESS") {
                //continue
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE: ' + response);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log( 'ERROR: ', errors );
            }
        });

        $A.enqueueAction(action);

        //then present back to user
        if (toast && inLexApp==false){
        	helper.navigateToUrl(record.id, component);
            //fire the toast event in Salesforce app and Lightning Experience
            if (component.get("v.inCreateMode")==true){
                toast.setParams({
                	"title": "Saved",
                	"message": "Record created.",
                	"type": "success",
            	});
            }
            else{
                toast.setParams({
                	"title": "Saved",
                	"message": "Record updated.",
                	"type": "success",
            	});
            }
            toast.fire();
        }else{
            console.log('navigating url and inLexapp==true');
            component.set("v.recordId", record.id);
        	helper.navigateToUrl(record.id, component);
        }
        component.set("v.saved", true);
    },
    
    handleOnError: function(component, event, helper) {
        let params = event.getParams(); 
        let toast = $A.get("e.force:showToast");
        let inLexApp = component.get("v.inLexApp");
        if (toast && inLexApp==false){
            //fire the toast event in Salesforce app and Lightning Experience
            toast.setParams({
                "title": params.message,
                "message": "\n " + params.detail,
                "type": "error"
            });
            toast.fire();
        }
        else{
            var description = event.getParams().description;
        	component.set("v.error", description);
        }
    }
    
})
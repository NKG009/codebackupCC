({
    prepareComponent : function(component){

        let inputParam = component.get('v.inputParam'); 
        let jsonObject;
        let debugShow = true; 
         
        if(inputParam == ""){
            console.log("embeddedInApp = false");
            let pageRef = component.get('v.pageReference');
            try {            
                //store base64encoded JSON input, and decode via atob() function
                jsonObject = JSON.parse(atob(pageRef.state['c__inputParam']));
                let inputPage = pageRef.state['c__inputPage'];
                if (inputPage.toLowerCase() == 'update'){
                    component.set('v.inCreateMode', false);
                }
                else if (inputPage.toLowerCase() == 'create'){
                    component.set('v.inCreateMode', true);
                }
                
                if(debugShow) console.log('jsonObject: ', jsonObject);
            } catch (e) {
                console.error('ERROR: ' + e.name + ', ' +  e.message);
            } 
        }else{
            
            console.log("embeddedInApp = true");
            //store base64encoded JSON input, and decode via atob() function
            if(debugShow) console.log('inputParam: ', component.get("v.inputParam"));
            try{
                jsonObject = JSON.parse(atob(component.get("v.inputParam")));
                //jsonObject = jsonObject[0];
                console.log('jsonObject ', jsonObject);
            }catch(e) {
                console.error('ERROR: ' + e.name + ', ' +  e.message);
            }
        }
        
        //Assign the record ID
        if (!$A.util.isEmpty(jsonObject.Id)) {
            component.set("v.recordId", jsonObject.Id);
            if(debugShow) console.log('Set: Id = ' + component.get('v.recordId'));
        }
        
        //Assign the recordType ID
        if (!$A.util.isEmpty(jsonObject.RecordTypeId)) {
            component.set("v.RecordTypeId", jsonObject['RecordTypeId']);
            if(debugShow) console.log('Set: RecordTypeId = ' + component.get('v.RecordTypeId'));
        }
        
        //Assign the object type, used by the Apex controller
        if (!$A.util.isEmpty(jsonObject.attributes.type)) {
            component.set("v.objectType", jsonObject.attributes.type);
            if(debugShow) console.log('Set: Object = ' + component.get('v.objectType'));
        }
        
        if (!$A.util.isEmpty( jsonObject.candidateData )){ //Populate the SbNotice variable for candidate
            let accessToken = jsonObject.access_token;
            if (accessToken === null) accessToken = '';
            let accessTokenObject = '{\"access_token\":\"'+ accessToken + '\",\"candidateData\":' + JSON.stringify(jsonObject.candidateData) + '}';
            component.set("v.sbNotify", accessTokenObject);
        }

        if (!$A.util.isEmpty( jsonObject.leadData )){ //Populate the SbNotice variable for leads
            let accessToken = jsonObject.access_token;
            if (accessToken === null) accessToken = '';
            let accessTokenObject = '{\"access_token\":\"'+ accessToken + '\",\"leadData\":' + JSON.stringify(jsonObject.leadData) + '}';
            component.set("v.sbNotify", accessTokenObject);
        }

        //if in Create Mode && Lex App
        let createMode = component.get("v.inCreateMode");
        let inLexApp = component.get("v.inLexApp");
        if (createMode){
            if(jsonObject.attributes.type == "TR1__Job_Leads__c"){
                component.set("v.cardTitle", "Create New Job Lead");
            }else{
                component.set("v.cardTitle", "Create New " + jsonObject.attributes.type);
            }
            component.set("v.cardIcon", "standard:record_create");
        }
        else if (!createMode){
            if(jsonObject.attributes.type == "TR1__Job_Leads__c"){
                component.set("v.cardTitle", "Update Job Lead");
            }else{
                component.set("v.cardTitle", "Update " + jsonObject.attributes.type);
            }
            component.set("v.cardIcon", "standard:record_update");
        }
            
        component.set("v.jsonObject", jsonObject);
    },
    
    isFormValid : function (component, event, helper) {
        
        //https://salesforce.stackexchange.com/questions/213804/how-can-one-validate-recordeditform-fields-before-submitting-them-to-the-platf
    
    },
    
    autocompleteFields: function (component) {
        
        //now trying to extract from jsonObject variable
		let jsonObject = component.get("v.jsonObject");
        
        try {
            component.find('customSectionFields').forEach(function (f) {
                let fieldName = f.get('v.fieldName');
                
                //if name/address, handle the 'special' fields (ie first name vs last name)
                if (fieldName === 'Name') {
                    let name = f.get('v.value');
                    if (!$A.util.isEmpty( jsonObject.FirstName)) { //test if in jsonObject and not empty, instead of looping
                        name.FirstName = jsonObject.FirstName;
                    }
                    if (!$A.util.isEmpty( jsonObject.LastName)) {
                        name.LastName = jsonObject.LastName;
                    }
                    if (!$A.util.isEmpty( jsonObject.Salutation)) {
                        name.Salutation = jsonObject.Salutation;
                    }
                    f.set('v.value', name);
                }
                else if (fieldName === 'MailingAddress') {
                    let address = f.get('v.value');
                    if (!$A.util.isEmpty( jsonObject.MailingStreet)) { //test if in jsonObject and not empty, instead of looping
                        address.MailingStreet = jsonObject.MailingStreet;
                    }
                    if (!$A.util.isEmpty( jsonObject.MailingCity)) {
                        address.MailingCity = jsonObject.MailingCity;
                    }
                    if (!$A.util.isEmpty( jsonObject.MailingPostalCode)) {
                        address.MailingPostalCode = jsonObject.MailingPostalCode;
                    }
                    if (!$A.util.isEmpty( jsonObject.MailingState)) {
                        address.MailingState = jsonObject.MailingState;
                    }
                    if (!$A.util.isEmpty( jsonObject.MailingCountry)) {
                        address.MailingCountry = jsonObject.MailingCountry;
                    }
                    f.set('v.value', address);
                }
                //otherwise, if in the map of fields displayed then populate the value
                else if (jsonObject.hasOwnProperty(fieldName)){
                    let fieldValue = jsonObject[fieldName];
                    f.set("v.value", fieldValue);
                }
                
            });
            
        } catch (e) {

            if(!e.message.includes('Cannot read property \'forEach\' of undefined')){
                console.log('ERROR: ' + e.name + ', ' +  e.message);
            }
        }
    },
    
    navigateToUrl: function (recordId, component) {
        
        console.log('navigating to url', recordId);
        let tempUrl = "/" + recordId;
        if (!$A.util.isEmpty(recordId) && component.get("v.inLexApp")==false) {
            
            $A.get('e.force:navigateToURL').setParams({'url': tempUrl}).fire();
        }
        else{
            let baseUrl = window.location.protocol+'//'+window.location.host ;
       		baseUrl = baseUrl.replace(".lightning.force.com",".my.salesforce.com");
            window.open(baseUrl + tempUrl, "_self");
        }
        //find the recordId that was created and the use in redirect.  for lexApp, strip out the recordId
        //https://salesforce.stackexchange.com/questions/273734/lightning-component-redirecting-to-record-it-is-creating

    },

    enqueueAction: function (component, actionName, params, options) {
        
        let helper = this;
        
        return new Promise(function (resolve, reject) {
            
            component.set('v.showSpinner', true);
            
            let action = component.get(actionName);
            
            if (params) {
                action.setParams(params);
            }
            
            if (options) {
                if (options.background) {
                    action.setBackground();
                }
                if (options.storable) {
                    action.setStorable();
                }
            }
            
            action.setCallback(helper, function (response) {
                
                component.set('v.showSpinner', false);
                
                if (component.isValid() && response.getState() === 'SUCCESS') {
                    
                    resolve(response.getReturnValue());
                    
                } else {
                    
                    console.error('Error calling action "' + actionName + '" with state: ' + response.getState());
                    
                    helper.logActionErrors(response.getError());
                    
                    reject(response.getError());
                    
                }
            });
            
            $A.enqueueAction(action);
            
        });
    },
    
    
    logActionErrors: function (errors) {
        //need to add in additional error handling and display for the user
        //https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/container_handling_errors.htm
        if (errors) {
            if (errors.length > 0) {
                for (let i = 0; i < errors.length; i++) {
                    console.error('Error: ' + errors.message);
                }
            } else {
                console.error('Error: ' + errors);
            }
        } else {
            console.error('Unknown error');
        }
    }
});
({
    doSave: function(component, event, helper) {
        if(component.find("fileId").get("v.files")== null){
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Please upload any image');
            return;
        }
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
            var recordId = component.get("v.recordId");
            event.preventDefault();
            var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofileedit"+'?site='+component.find("siteId").get("v.value");
            window.location.replace(urlRedirect);
            return false;
        } else {
            //alert('Please Select a Valid File');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected...';
        component.set("v.messageinred",false);
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            component.set("v.messageinred",true);
        }
        component.set("v.fileName", fileName);
    },
    doInit : function(component, event, helper) {        
       var componentList = component.find('fileId');
       var componentLabels = componentList.get('v.label');
        var action = component.get("c.fetchUserDetail");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.oUser', res);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);	
    },
    myprofileEditNavigate  : function(component,event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile"+'?site='+component.get("v.recordId");
        window.location.replace(urlRedirect);
        return false;
    },

})
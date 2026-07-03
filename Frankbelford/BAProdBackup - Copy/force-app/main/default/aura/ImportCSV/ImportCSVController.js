({
    siterecords: function (component, event, helper) {
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        //console.log('++++++selectedAccountGetFromEvent+++++++++++' + selectedAccountGetFromEvent);

        component.set("v.selectedRecord", selectedAccountGetFromEvent);
        var sitesList = component.get('c.getsitesList');
        sitesList.setParams({ 'jsonString': JSON.stringify(selectedAccountGetFromEvent) });
        sitesList.setCallback(this, function (response) {
            var optSites = [];
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                optSites.push({
                    label: "Select Site",
                    value: ""
                });
                var siteArray = response.getReturnValue();
                //console.log('siteArray >>> ' + JSON.stringify(siteArray));
                for (var i = 0; i < siteArray.length; i++) {
                    optSites.push({
                        label: siteArray[i].Brand__c === '' ? siteArray[i].Name : siteArray[i].Name + ' - ' + siteArray[i].Brand__c,
                        value: siteArray[i].Id
                    });
                }
            } else {
                //console.log("No site found");
            }
            component.set("v.siteList", optSites);
        });
        $A.enqueueAction(sitesList);
    },

    handleFilesChange: function (component, event, helper) {
        var fileName = 'No File Selected..';
        var toastEvent = $A.get("e.force:showToast");
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            ////console.log('inside if');

            //CHECK WHETHER THE FILE WAS UPLOADED ALREADY BY FILE NAME
            var action = component.get("c.checkDuplicateFileLoad");
            action.setParams({
                "fileName" : fileName
            });
            action.setCallback(this, function(response){
                //console.log(">> making call");
                var state = response.getState();
                if(state === "SUCCESS") {
                    //console.log("response >>> " + response.getReturnValue());
                    var result = response.getReturnValue();
                    if(result === 0){
                        component.set("v.fileName", fileName);
                        component.set("v.isDisabled", "false");
                        component.set("v.isUploaded", "false");
                    } else if(result === 1) {
                        toastEvent.setParams({
                            "type":"error",
                            "message": "Cannot upload selected file '" + fileName + "'. \n\n It was uploaded in the past. \n Please try with a new file"
                        });
                        toastEvent.fire();
                        component.set("v.isUploaded", "false");
                    } else {
                        toastEvent.setParams({
                            "type":"error",
                            "message": "Unknown Error Cannot upload selected file '" + fileName + "'. \n\n Please check the file before uploading"
                        });
                        toastEvent.fire();
                        component.set("v.isUploaded", "false");
                    }
                } else {
                    //console.log("Something went wrong response >>> " + JSON.Stringify(response));
                }
            });
            $A.enqueueAction(action);
        } else {
            //console.log('inside else');
            fileName = 'No File Selected..';
            component.set("v.fileName", fileName);
        }
        component.set("v.fileName", fileName);
        //console.log('inside if ' + component.get("v.fileName"));
    },

    CreateRecord: function (component, event, helper) {
        var getSelectedAccountFromLookUp = component.get("v.selectedRecord");
        var getCheckVal = component.find("checkboxmulti").get("v.value");
        var selectedSite = component.find("siteId").get("v.value");

        if (getSelectedAccountFromLookUp == null || getSelectedAccountFromLookUp == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Account is mandatory for CSV processing"
            });
            toastEvent.fire();
        } else if (getCheckVal === true && (selectedSite !== null && selectedSite !== "")) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "You can either select a site or tick Multi Site"
            });
            toastEvent.fire();
        } else if (getCheckVal === false && (selectedSite === null || selectedSite === "")) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Either check multi-site or select a site from drop down"
            });
            toastEvent.fire();
        } else {
            var fileInput = component.find("file").get("v.files");
            var file = fileInput[0];
            if (file) {
                component.set("v.isDisabled","true"); //DISABLE THE SUBMIT BUTTON ONCE FILE IS BEING PROCESSED
                ////console.log("File");
                var toastEvent = $A.get("e.force:showToast");
                var reader = new FileReader();
                reader.readAsText(file, "UTF-8");
                reader.onload = function (evt) {
                    var csv = evt.target.result;
                    var result = helper.CSV2JSON(component, csv);
                    toastEvent.setParams({
                        "type": "info",
                        "message": "Processing..."
                    });
                    toastEvent.fire();
                    var delayInMilliseconds = 5000;
                    window.setTimeout(
                        $A.getCallback(function () {
                            helper.CreateBatches(component, result);
                        }), delayInMilliseconds
                    );
                }
                reader.onerror = function (evt) {
                    //console.log("error reading file");
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "message": "Please upload the file before submitting"
                });
                toastEvent.fire();
            }
        }
    }

})
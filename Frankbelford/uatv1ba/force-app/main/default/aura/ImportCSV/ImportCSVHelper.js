({
    CSV2JSON: function (component,csv) {
        var arr = []; 
        arr =  csv.split('\n'); 
        arr.pop();
        //console.log('check array'+arr);
        var jsonObj = [];
        var headers = arr[0].split(',');
        //console.log('check array length'+arr.length);
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
            }
             //console.log('check json'+obj);
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
         //console.log('check json -->'+json);
        return json;

    },
    
    CreateBatches: function (component, jsonstr) {
        var selectedSitefrompage = component.find("siteId").get("v.value");
        var getSelectedAccountFromLookUp = component.get("v.selectedRecord");
        var fileName = component.get("v.fileName");
        var action = component.get("c.insertData");
        action.setParams({
                    strfromlex: jsonstr,
                    jsonString1: JSON.stringify(getSelectedAccountFromLookUp),
                    ClientRef: selectedSitefrompage,
                    fileName: fileName
                });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "message": "Batch header created successfully"
                });
                toastEvent.fire();
                component.set("v.isUploaded", true);
                component.set("v.isDisabled", true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var sMsg = 'Error in creating batch header \n';
                        sMsg += errors[0].message;
                        //console.log("Error message: " + errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Error",
                            "message": sMsg
                        });
                        toastEvent.fire();
                        //  window.location.reload();
                    }
                } else {
                    //console.log("Unknown error");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "message": 'Unknown Exception'
                    });
                    toastEvent.fire();
                    // window.location.reload();
                }
            }
        });
        $A.enqueueAction(action);
    }
})
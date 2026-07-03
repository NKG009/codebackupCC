/**
 * Created by mrahman on 2020-11-28.
 */
({
    doInit: function (component, event, helper) {
        //console.log("doInit in AddressFinderCmp");
        var action = component.get("c.getServiceDetails");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var serConfig = response.getReturnValue();
                component.set("v.serConfig", serConfig);
                component.set("v.showSpinner", false);
            }else {
                helper.showError("Connect Error! Please Contact your consultant to add/update your address");
            }
        });
        $A.enqueueAction(action);
        helper.getCurrentAddress(component, event);
    },
    
    resetAll: function (component, event, helper) {
        //console.log("reset all values");
        component.set("v.options", []);
        component.set("v.displayOptions", false);
        component.set("v.result", {});
        component.set("v.counter", 0);
    },

    handleAddressFinderEvent: function (cmp, event, helper) {
        //console.log(" >>>>> Event Handler <<<<<<");
        var result = cmp.get("v.result");
        for (var i = 0; i < event.getParam("size"); i++) {
            helper.findAddressX(cmp, event);
        }
    },
    doFindAddress: function (component, event, helper) {
        component.set("v.showSpinner",true);
        var c = component.get("v.counter");
        var result = component.get("v.result");
        //console.log("before load result :: " + result);

        if (result != null && result.Type === "Address") {
            component.set("v.isLoading",false);
            //console.log("Will call the retrieveAddress ");
        } else {
            helper.findAddressX(component, event);
        }

        result = component.get("v.result");
        component.set("v.counter", c + 1);
    },

    enterSearch: function (component, event, helper) {
        //console.log("in Enter Search");
        if (event.keyCode == 5) {
            //console.log("it is working....");
            helper.findAddressX(component, event);
        }
    },

    doRetrieveAddress: function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        helper.retrieveAddress(component, event);
    }, 

    saveAddressHandler : function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var adrDetails = component.get("v.addressDetails");
        component.set("v.showSpinner",true);
        //alert("this is just a dummy update..." + adrDetails);
        if(recordId === undefined){
            helper.showError('Cannot update address due to mandatory information missing! \n Please contact your consultant');
            component.set("v.showSpinner",false);
            return;
        }
        var action = component.get("c.updateAddress");
        action.setParams({recordId : recordId, addressJSON : adrDetails});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showSuccess('Address Updated');
                var saEvent = component.getEvent("hasAddressEvent");
                //console.log("eventFired >>> " + JSON.stringify(saEvent));
                saEvent.setParams({ "size": 0, "canProceed": true, "msg": "" });
                saEvent.fire();
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                          errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                console.log('error:: ' + JSON.stringify(state));
                helper.showError('Something went wrong! \n Please contact your consultant');
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    }
})
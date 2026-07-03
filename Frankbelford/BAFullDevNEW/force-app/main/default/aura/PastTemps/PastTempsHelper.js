({
    getShifts : function(component) {
        var action = component.get("c.getAllShiftsPast");
        action.setParams({
            "site" : component.get("v.selectedSite"),
            "contact" : component.get("v.selectedcandidate"),
            "jobrole" : component.get("v.selectedJobRole"),
            "filter": component.get("v.filter")
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.allshifts", result);
            
            var currentList;
            if(result.length>0){
                currentList = result.slice(0,10);
            }
            else{
                currentList = result;
                 var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": "No passed temps available for this Site"
               
            });
            toastEvent.fire();
            }
            component.set("v.shifts", currentList);
            component.set("v.pageNumber", 1);
            component.set("v.maxPage", Math.floor((result.length+9)/10)); 
        });
        $A.enqueueAction(action);
    },
    submitRating : function(component) {
        var action = component.get("c.submitRating");
        action.setParams({
            "shiftID": component.get("v.feedbackshift").Id,
            "selectedRating": component.get("v.selectedRating")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('result');
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
                else if (state === "INCOMPLETE") {
                    console.log('incomplete');
                }
        });
        $A.enqueueAction(action);
    }
})
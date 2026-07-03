({
 renderPage: function(component) {
		var records = component.get("v.allshifts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecords '+pageNumber);
        component.set("v.currentList", pageRecords);
	},
     renderPage2: function(component) {
		var records = component.get("v.allshifts"),
            pageNumber = 1,
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecords '+pageNumber);
        component.set("v.currentList", pageRecords);
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
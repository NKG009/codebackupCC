({
    getShifts : function(component) {
        var action = component.get("c.getAllShifts");
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
                var filtval = component.get("v.Filtervalue");
                console.log('## filter '+filtval);
                if(filtval == 'appfilter')
                {
                  var toastEvent1 = $A.get("e.force:showToast");
          		  toastEvent1.setParams({
                'message': 'No booked temps found',
                      'type' : 'Info',
                      'Duration': '1000'
               
            });
            toastEvent1.fire(); 
                }
               else
               {
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
          
                'message': 'No booked temps available for this Site',
                    
                      'Duration': '1000'
            });
            toastEvent.fire();
               }
            }
            component.set("v.shifts", currentList);
            component.set("v.pageNumber", 1);
            component.set("v.maxPage", Math.floor((result.length+9)/10)); 
        });
        $A.enqueueAction(action);
    }
})
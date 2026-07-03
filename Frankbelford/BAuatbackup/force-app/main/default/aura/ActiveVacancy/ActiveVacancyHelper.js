({
    getShifts : function(component) {
        var action = component.get("c.getAllShifts");
        action.setParams({
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
            }
            component.set("v.shifts", currentList);
            component.set("v.pageNumber", 1);
            component.set("v.maxPage", Math.floor((result.length+9)/10)); 
        });
        $A.enqueueAction(action);
    }
})
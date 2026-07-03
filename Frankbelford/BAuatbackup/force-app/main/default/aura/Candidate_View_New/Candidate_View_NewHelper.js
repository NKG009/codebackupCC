({
	helperMethod : function() {
		
	},
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    dosearch : function(component){
        console.log('cand '+component.get("v.CandidateName"));
         component.set("v.truly",false); 
        var action = component.get("c.getAllShiftsForCandidate");
        
        action.setParams({
            "contact": component.get("v.CandidateName"),
            "site":component.get("v.selectedSite")
        });
       
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.ShiftList", result);
            component.set("v.truly",true);    
        });
        $A.enqueueAction(action); 
        
        
    }
})
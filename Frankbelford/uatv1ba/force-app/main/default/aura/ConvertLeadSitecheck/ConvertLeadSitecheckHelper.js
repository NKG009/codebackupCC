({
	getMatchingSiteList : function(component, event) {
		var action = component.get("c.getMatchingSitesList");
		action.setParams({"selectedAccountId": component.get("v.selectedAccountId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++statevalue+++'+state);
            console.log('+++component.get("v.selectedAccountId")+++'+component.get("v.selectedAccountId"));
			if(state === "SUCCESS") {
                console.log('+++resultvalue+++'+result);
				if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    console.log('+++listMatchingSites+++'+JSON.stringify(result[0]["site"]["Name"]));
                    component.set("v.displayTable",true);
					component.set("v.listMatchingSites",result);				
				}
				else{
					component.set("v.displayTable",false);
				}
				console.log('+++++++result++'+result);
			}
            else{
                
            }
        });
        $A.enqueueAction(action);        
    },
    
    convertToNewSite : function(component, event) {
        console.log('+++++++++convertToSelectedSite++++++++++'+component.get("v.checkboxSelected"));
        if(component.get("v.checkboxSelected")>0){
            alert('Please unselect existing site.');
        }
        else{
            var action = component.get("c.ConvertToNewSite");
            action.setParams({
                "newBusinessLeadId": component.get("v.selectedNewBusinessLead"),
                "selectedAccountId": component.get("v.selectedAccountId")
            });
             
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                console.log('+++state+++'+state);
                if(state === "SUCCESS") {				
                    console.log('++++++++++result+++++ '+result);
                    component.set("v.selectedSiteValue",result.Id);
                    component.set("v.displayConvertLeadSiteCheckScreen",false);
                    component.set("v.displayConvertLeadContactCheckScreen",true);
                    console.log('+++++++++component.set(selectedSiteValue)++++++++++'+component.get("v.selectedSiteValue"));
                }
                else{
                    component.set("v.messageDisplay",result);
                    component.set("v.errorMessage",true);
                }
            });
            $A.enqueueAction(action);
    	}
	},
    
    convertToSelectedSite : function(component, event) {
        console.log('+++++++++convertToSelectedSite++++++++++'+component.get("v.checkboxSelected"));
        if(component.get("v.checkboxSelected")==0 || 
           	component.get("v.checkboxSelected")==undefined){
            alert('Please select an existing site.');
        }
        else if(component.get("v.checkboxSelected")>1){
            alert('Please select only one site.');
        }
        else {
            var obj=component.get('v.selectedSiteIds');
            console.log('+++++++++selectedSiteIdsobj++++++++++'+obj);
            for(var i=0;i<obj.length;i++){
                component.set("v.selectedSiteValue",obj[i]);
    		}
			component.set("v.displayConvertLeadSiteCheckScreen",false);
            component.set("v.displayConvertLeadContactCheckScreen",true);
        }
    },
})
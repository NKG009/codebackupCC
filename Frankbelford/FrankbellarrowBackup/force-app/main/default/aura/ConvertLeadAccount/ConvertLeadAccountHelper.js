({
	getAccountPicklist : function(component, event) {
        var action = component.get("c.getAccountOptionValues");
        action.setParams({"newBusinessLeadId": component.get("v.selectedNewBusinessLead")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.industryMap", industryMap);
                console.log('+++++++1111111++++++++'+industryMap);                
            }
        });
        $A.enqueueAction(action);        
    },
    
    getAccountFromLookUp : function(component, event) {
        var getSelectedAccountFromLookUp = component.get("v.selectedRecord");
        //var accountRecordParse = JSON.stringify(getSelectedAccountFromLookUp);
        var action = component.get("c.addAccountIdFromLookup");
        action.setParams({"newBusinessLeadId": component.get("v.selectedNewBusinessLead"),
                         'jsonString': JSON.stringify(getSelectedAccountFromLookUp)});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.industryMap", industryMap);
                console.log('+++++++++++++++'+industryMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    openSelectedAccountpage : function(component, event) {
		var selectedAccountId = component.get("v.selectedValue");
        if(selectedAccountId=='--None--' || selectedAccountId=='' || 
           selectedAccountId==null || selectedAccountId==undefined || 
           selectedAccountId=='Create New Account:'){
            alert('Please select an existing account to view details.');
        }
        else{            
            /*var sObectEvent = $A.get("e.force:navigateToSObject");
            sObectEvent .setParams({
            "recordId": selectedAccountId ,
            "slideDevName": "detail"
          });
          sObectEvent.fire();*/
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/'+selectedAccountId+'/p'
            });
            urlEvent.fire();
        }
    },
})
({
    doInit: function(component, event, helper) {
        var query = location.search.substr(1);
        console.log('query++++'+query);
        var result ;
        query.split("?").forEach(function(part) {
            var item = part.split("=");
            console.log('item++++'+item);
            //result[item[0]] = decodeURIComponent(item[1]);
            result = item[1];
                       
        });
        console.log('result++++'+result);
        component.set("v.recordId",result);
        helper.getSiteContactLink(component,result);
    },
    
    saveSiteContactDetails: function(component, event, helper) { 
        console.log('++++++++++inside submit id+++++');
        event.preventDefault();//stops the default save from happening.
        helper.submitSiteContactData(component, event, helper);         
    },
    
    cancelClick : function(component, event, helper) {
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
	},
});
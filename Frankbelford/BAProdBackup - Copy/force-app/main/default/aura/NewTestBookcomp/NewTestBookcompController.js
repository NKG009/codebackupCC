({
    redirectBookTemp : function(component, event, helper) {
       var finalsite = component.get("v.site");
        
        if(finalsite == '' || finalsite == null)
        {
            finalsite = helper.getJsonFromUrl().site;
        }
         console.log('finalsite '+finalsite);
    var searchResult = component.get("c.getAllShifts");
         searchResult.setParams({
            "site" : finalsite
             
        });  
        console.log('booked temnew '+finalsite);
         console.log('action '+searchResult);
        searchResult.setCallback(this, function(response) {
                    console.log('in callback method:'); 
                    var state = response.getState();
        });
   },
    
    redirectBookTempas: function(component, event, helper)
    {
        event.preventDefault();
         var param = component.get("v.site");
        //var param = component.find('select').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newbookedtemps?site="+param;
        //alert('profile');
        window.location.replace(urlRedirect);
        return false;
    },
})
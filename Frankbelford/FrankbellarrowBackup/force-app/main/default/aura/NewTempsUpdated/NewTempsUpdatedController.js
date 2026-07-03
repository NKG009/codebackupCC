({	
    bookedTempsNavigate: function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        var pageUrl = "/newbookedtemps?site="+cmp.get("v.site");
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
    },

    reInit : function(cmp, event, helper){
        console.log('Trying to reload data');
        helper.loadData(cmp, event);
    },

    ctr : function(component, event, helper) { 
        helper.loadData(component, event);
    }
})
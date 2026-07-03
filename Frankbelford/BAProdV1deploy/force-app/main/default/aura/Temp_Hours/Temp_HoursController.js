({
	doInit : function(component, event, helper) {
        helper.loadData(component, event);
    },
    reInit : function(component, event, helper){
        console.log('Trying to reload data');
        helper.loadData(component, event);
    },
    pastTempsNavigate: function(component, event, helper) {
        helper.doCommPageNav("approved-timeSheets-new", component, event);
    }
})
({
    doInit: function (component, event, helper) {
        helper.loadData(component, event);
    },
    reInit : function(component, event, helper){
        console.log('Trying to reload data');
        helper.loadData(component, event);
    },
    redirectBookTemp: function (component, event, helper) {
        helper.goToUrl("/newbookedtemps", component, event);
    },

    fetchCompetencies: function (component, event, helper) {
        var Id = event.target.id;
        helper.CompetenciesDetailsHelper(component, Id, helper);
    },

})
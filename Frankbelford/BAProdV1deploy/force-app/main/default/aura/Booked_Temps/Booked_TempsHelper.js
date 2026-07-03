({
    loadData : function(component, event){
        var action = component.get("c.getAllShifts");
        action.setParams({
            "site": component.get("v.site")
        });
        //alert(component.get("v.site"));
        action.setCallback(this, function (response) {
            console.log('action ' + action);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('state ' + state);
                //  console.log('state: '+state);
                var result = response.getReturnValue();
                component.set("v.allshifts", result);

            }
        });
        $A.enqueueAction(action);
    }, 
    CompetenciesDetailsHelper: function (component, Id, helper) {
        var selectedShift = Id;
        var compresult = component.get("c.getContactCompetencies");
        compresult.setParams({
            "shiftId": selectedShift
        });

        compresult.setCallback(this, function (response) {
            var result = response.getReturnValue();
            if (result.length > 0) {
                console.log('in helper result ' + result);
                component.set("v.CompetenciesList", result);
                component.set("v.checkCompetencies", true);
            } else {
                component.set("v.checkCompetencies", false);
                console.log('in helper 0 result ' + result);
            }
        });
        $A.enqueueAction(compresult);
    },

    goToUrl: function (pageUrl, cmp, event) {
        event.preventDefault();
        var urlEvent = $A.get("e.force:navigateToURL");
        pageUrl = pageUrl + "?site=" + cmp.get("v.site");
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
        console.log('pageUrl >> ' + pageUrl);
    }
})
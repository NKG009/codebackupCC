({
    getJsonFromUrl: function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function (part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },

    doSearch: function (component) {
        var param = component.get("v.selectedSite");
        //console.log('param >>> ' + param);
        if (param === null) {
            param = this.getJsonFromUrl().site;
        }
        //console.log('test search');
        component.find("childC").destroy();
        component.set("v.SearchBtn", true);
        component.set("v.truly", false);
        // alert('In search');
        var Candidate = component.get("v.CandidateSelected");
        // var site= component.get("v.SiteSelected");
        var dt = component.find("timePeriod").getElement().value;
        component.set("v.DateSelected", dt);
        //  component.set("v.selectedSite", component.find("site").get("v.value"));
        var action = component.get("c.getAllShifts");
        //console.log('component.get("v.selectedSite") ' + component.get("v.selectedSite") + Candidate);
        action.setParams({
            "site": param,//component.get("v.SiteSelected"),
            "role": component.get("v.roleSelected"),
            "contact": component.get("v.CandidateSelected"),
            "DateRange": component.get("v.DateSelected")
        });

        action.setCallback(this, function (response) {
            var result = response.getReturnValue();
            //console.log('response.getReturnValue() >> '+ JSON.stringify(response.getReturnValue()));
            //$A.get('e.force:refreshView').fire();
            component.set("v.shifts", result);
            component.set("v.truly", true);

        });

        // myEvent.fire();
        $A.enqueueAction(action);
        var sitechange = component.get("v.checktrue");
        //console.log('sitechange ' + sitechange);
        if (sitechange == true) {
            var RoleCand = component.get("c.getRolesAndCandidate");
            RoleCand.setParams({
                "site": component.get("v.selectedSite")

            });
            RoleCand.setCallback(this, function (response) {
                var state = response.getState();
                var optsSite = [];
                if (component.isValid() && state == "SUCCESS") {
                    var SiteArray = response.getReturnValue().Role;
                    optsSite.push({
                        class: "optionClass",
                        label: "Select Role Name ",
                        value: ""
                    });
                    for (var i = 0; i < SiteArray.length; i++) {
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                        });
                    }
                    component.set("v.roleList", optsSite);

                    var optsCandi = [];
                    var condidateList = response.getReturnValue().Candidate;
                    optsCandi.push({
                        class: "optionClass",
                        label: "Select Temp Name ",
                        value: ""
                    });
                    for (var i = 0; i < condidateList.length; i++) {
                        optsCandi.push({
                            class: "optionClass",
                            label: condidateList[i].sirenum__Contact__r.Name,
                            value: condidateList[i].sirenum__Contact__r.Id
                        });
                    }
                    component.set("v.CandidateList", optsCandi);
                }
            });
            $A.enqueueAction(RoleCand);
        }
    },

    doGetRolesAndCandidates: function(component, event) {
        var RoleCand = component.get("c.getRolesAndCandidate");
        RoleCand.setParams({"site": component.get("v.site")});
        RoleCand.setCallback(this, function (response) {
            var state = response.getState();
            var optsSite = [];
            if (component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue().Role;
                optsSite.push({
                    class: "optionClass",
                    label: "Select Role Name ",
                    value: ""
                });
                for (var i = 0; i < SiteArray.length; i++) {
                    optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                    });
                }
                component.set("v.roleList", optsSite);

                var optsCandi = [];
                var condidateList = response.getReturnValue().Candidate;
                optsCandi.push({
                    class: "optionClass",
                    label: "Select Temp Name ",
                    value: ""
                });
                for (var i = 0; i < condidateList.length; i++) {
                    optsCandi.push({
                        class: "optionClass",
                        label: condidateList[i].sirenum__Contact__r.Name,
                        value: condidateList[i].sirenum__Contact__r.Id
                    });
                }
                component.set("v.CandidateList", optsCandi);
                console.log("optsCandi >>>>> " + JSON.stringify(optsCandi));
            } else {
                console.error("Unable to get Roles and Candidates");
            }
        });
        $A.enqueueAction(RoleCand);
    }
})
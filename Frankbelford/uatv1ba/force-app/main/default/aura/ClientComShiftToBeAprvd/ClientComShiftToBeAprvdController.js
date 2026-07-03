({
    doInit: function (component, event, helper) {
        //console.log('>>>> doInit - load <<<<');
        $A.get('e.force:refreshView').fire();
        var idParam = helper.getJsonFromUrl().site;
        //console.log('load ' + idParam);
        component.set("v.site", idParam);
        component.set("v.truly", false);

        var action = component.get("c.getAllShifts");
        action.setParams({
            "site": idParam,
            "role": component.get("v.roleSelected"),
            "contact": component.get("v.CandidateSelected"),
            "DateRange": component.get("v.DateSelected")
        });
        ////console.log('action '+action);
        action.setCallback(this, function (response) {
            ////console.log('getAllshifts call >>> '+ response.getState());
            var result = response.getReturnValue();
            component.set("v.shifts", result);
            setTimeout(function () {
            }, 100);
            component.set("v.truly", true);
            ////console.log('callback end >>> getAllShifts');
        });

        var RoleCand = component.get("c.getRolesAndCandidate");
        RoleCand.setParams({"site": idParam});
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

        var siteListOnly = component.get("c.getSites");
        siteListOnly.setCallback(this, function (response) {
            var state = response.getState();
            var optsSite = [];

            if (component.isValid() && state == "SUCCESS") {

                var SiteArray = response.getReturnValue();

                var idParam = helper.getJsonFromUrl().site;
                ////console.log('site id'+SiteArray[0].Name);
                var equalFlag = false;
                for (var i = 0; i < SiteArray.length; i++) {
                    if (SiteArray[i].Id == idParam) {
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                        equalFlag = true;
                    } else {
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                        });
                    }
                }

                if (equalFlag === true) {
                    component.set('v.selectedSite', idParam);
                    //component.find("site").set("v.value", idParam);
                }
                else {
                    //component.find("site").set("v.value", optsSite[0].value);
                    component.set('v.selectedSite', optsSite[0].value);
                }
                component.set("v.SiteList1", optsSite);
            }
        });

        var action1 = component.get("c.fetchUser");
        action1.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.Name", storeResponse);
            }
        });

        var fetchUserName = component.get("c.getUserInformation");
        fetchUserName.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });

        $A.enqueueAction(fetchUserName);

        $A.enqueueAction(action1);
        $A.enqueueAction(RoleCand);
        $A.enqueueAction(siteListOnly);
        // $A.enqueueAction(siteList);
        $A.enqueueAction(action);
    },

    dashboardNavigate: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var pageUrl = pageUrl + "?site=" + cmp.get("v.site");
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
    },

    candidateView: function (component, event, helper) {
        // var param = component.find('site').get('v.value');
        var param = helper.getJsonFromUrl().site;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/candidateview?site=' + param
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },

    onChangeCandidateVal: function (component, event, helper) {
        //alert("Candidate selected ");
        var Candidate = event.getSource().get('v.value')
        component.set("v.CandidateSelected", Candidate);
    },

    onChangeRoleVal: function (component, event, helper) {
        //console.log("Role Selected ");
        var site = event.getSource().get('v.value');
        component.set("v.roleSelected", site);
    },

    onSiteChange: function (cmp, evt, helper) {
        var selectedSite = evt.getParam("selectedSiteId");
        //console.log('Current Site >> ' + cmp.get('v.site') + " change handler newly selected site >> " + selectedSite);
        cmp.set("v.site", selectedSite);
        cmp.set('v.selectedSite', selectedSite);
        cmp.set("v.CandidateSelected", null);
        helper.doSearch(cmp);
        helper.doGetRolesAndCandidates(cmp, evt);
    },

    search: function (component, event, helper) {
        //console.log("searching...");
        var site1 = component.find("site1").get("v.value");
        var site2 = component.find("site2").get("v.value");;
        component.set("v.checktrue", false);
        helper.doSearch(component);
    },

    Matched: function (component, event, helper) {
        //var a = component.find("match").get("v.checked");
        if (component.get("v.Match") == true) {
            component.set("v.Match", false);
        }
        else {
            component.set("v.Match", true);
        }

        var shifts = component.get("v.shifts");
        component.set("v.shifts", shifts);
    },

    scriptsLoaded: function (component, event, helper) {
        component.set("v.Spinner", true);
    },

    resetAllValues: function (component, event, helper) {
        if (component.get("v.roleSelected") != null || component.get("v.DateSelected") != null || component.get("v.CandidateSelected") != null) {
            component.set("v.roleSelected", null);
            component.set("v.DateSelected", null);
            document.getElementById("timePeriod").value = null;
            component.set("v.CandidateSelected", null);

            helper.doSearch(component);
        }
    },

    handleOnClick: function (component, event, helper) {
        event.preventDefault();
        return false;
    },

    handleKeyPress: function (component, event, helper) {
        event.preventDefault();
        return false;
    },

    handleMouseEnter: function (component, event, helper) {
        event.preventDefault();
        return false;
    },

    handleMouseLeave : function (component, event, helper) {
        event.preventDefault();
        return false;
    },

    handleThemeEvent : function(cmp, event, helper){
        var site = event.getParam("selectedSiteId");
        cmp.set("v.site", site);
        //alert("site changed");
        cmp.set('v.selectedSite', site);
        cmp.set("v.CandidateSelected", null);

        helper.doSearch(cmp);
        helper.doGetRolesAndCandidates(cmp, event);
    },

    /*testing only*/


    doSomething : function(cmp, event, helper){
        //console.log('testing');
        var selectedItem = cmp.find("selectItem").get("v.value");
        //console.log('selectedItem >> ' + selectedItem);
        cmp.set('v.selectedItem', selectedItem);
    },

    doTryMe : function(cmp, event, helper){
        var selectedItem = cmp.find("selectItem").get("v.value");
        //console.log('selectedItem >> ' + selectedItem);
    }
})
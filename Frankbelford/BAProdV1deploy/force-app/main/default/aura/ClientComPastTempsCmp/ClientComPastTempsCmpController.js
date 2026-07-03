({
    doInit: function (component, event, helper) {
        //console.log('==Enter==');
        helper.getSiteList(component);
        helper.getLoggedInUserInformation(component);
        helper.JobRoleList(component)
        helper.SiteCandidatesHelper(component);
        helper.getShiftsOnLoad(component);
    },

    dashboardNavigate: function (component, event, helper) {
        event.preventDefault();
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/")) + "/s/";
        var param = component.get('v.site');
        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = baseURL + '?site=' + param;
        //console.log("urlRedirect " + urlRedirect);
        window.location.replace(urlRedirect);
        return false;
    },

    handleThemeEvent : function(cmp, event, helper) {

        var site = event.getParam("selectedSiteId");
        cmp.set("v.site", site);
        cmp.set("v.selectedSite", site);
        cmp.set("v.checkSearch", false);

        helper.JobRoleList(cmp)
        helper.SiteCandidatesHelper(cmp);

        //cmp.set("v.shifts", undefined);
        $('#tableId').DataTable().destroy();
        helper.getShiftsOnLoad(cmp);
    },

    searchShifts: function (component, event, helper) {
        component.set("v.checkSearch", true)
        helper.searchShiftsHelper(component, event, helper);
    },

    feedback: function (component, event, helper) {
        var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        //console.log('in help fire ' + appEvent);
        var buttonName = event.target.id;
        component.set("v.selectedRating", 1);
        //   var target = event.getSource();
        var idToBeCancelled = buttonName;
        var shiftList = component.get("v.shifts");
        for (var i = 0; i < shiftList.length; i++) {
            if (shiftList[i].Id == idToBeCancelled) {
                component.set("v.feedbackshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
            }
        }
    },

    selectRating: function (component, event, helper) {
        component.set("v.Spinner", false);
        var selectedRating = event.getParam("rating");
        component.set("v.selectedRating", selectedRating);
    },

    submitRating: function (component, event, helper) {
        var shift = component.get("v.feedbackshift");
        var action = component.get("c.submitRatings");
        var selectedRating = component.get("v.selectedRating");
        //helper.submitRating(component);
        if (selectedRating == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please select Rating',
                mode: 'pester'
            });
            toastEvent.fire();
            component.set("v.Spinner", false);
        } else {
            var siteIdvalue = component.get('v.site');
            action.setParams({
                "shiftID": component.get("v.feedbackshift").Id,
                "selectedRating": component.get("v.selectedRating"),
                "siteId": siteIdvalue,
                "jobRoleId": component.find("jobRoleId").get("v.value"),
                "candidateId": component.find("candidateId").get("v.value"),
                "timePeriod": document.getElementById("timePeriod").value
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: '',
                        message: 'Thank you for your feedback',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $("#overlay").show();
                    var elements = document.getElementsByClassName("feedbackSpnId1");
                    var cmpTarget = component.find('feedbackSpnId1');
                    $A.util.addClass(elements, 'disablebutton');
                    component.set("v.selectedRating", 1);
                    component.set("v.Spinner", false);
                    $A.get('e.force:refreshView').fire();
                    /*table*/
                    component.set("v.shifts", result);
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();
                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: []
                        });

                        $("#overlay").hide();
                    }, 1000);
                    //var button = component.find("rating");
                    var button = event.getParam("rating");
                    for (var i = 0; i < button.length; i++) {
                        // $A.util.removeClass(button[i], 'slds-button_brand');
                        $A.util.removeClass(button[i], 'slds-button_success');
                    }
                    $A.util.addClass(target, 'slds-button_success');
                    component.set("v.selectedRating", 1);
                    /* . end*/
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'There is some issues while submitting rating. Please contact your consultant'
                    });
                    toastEvent.fire();
                    component.set("v.Spinner", false);
                }
            });

            var appEvent = $A.get("e.c:RatingAppEvent");
            appEvent.fire();

            $A.enqueueAction(action);
            // $A.enqueueAction(action2);
            component.set("v.checkSearch", true)
            component.set("v.Spinner", false);
            //helper.searchShiftsHelper(component);
        }
    },

    scriptsLoaded: function (component, event, helper) {
        //console.log('in ');
        helper.helperscriptload(component, event, helper);
        //console.log('in asscript');
    },

    closeModalWindowOnCancel: function (component, event, helper) {
        helper.helpercloseModelCancel(component, event, helper);
    },

    resetAllValues: function (component, event, helper) {
        //console.log('reset ');
        if (component.get("v.selectedjobrole") != null || component.get("v.timeperiodselected") != null || component.find("candidateId").get("v.value") != null) {
            component.set("v.selectedjobrole", null);
            component.set("v.timeperiodselected", null);
            component.find("jobRoleId").set("v.value", null);
            component.find("candidateId").set("v.value", null);
            document.getElementById("timePeriod").value = null;
            component.set("v.checkSearch", true);
            helper.getShiftsOnLoad(component);
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

    handleMouseLeave: function (component, event, helper) {
        event.preventDefault();
        return false;
    },

    cancel: function (component, event, helper) {
        helper.handleCancel(component, event, helper);
    }

})
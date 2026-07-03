({
    doInit: function (component, event, helper) {
        console.log('in previous shift');
        helper.getSiteJobRole(component);
        helper.getShifts(component);
    },
    onChange : function (component, event, helper) {
        console.log('Site change captured - loading data...');
        var selectedSite = event.getParam("selectedSiteId");
        console.log('Current Site >> ' + component.get('v.site') + " change handler newly selected site >> " + selectedSite);
        component.set("v.site", selectedSite);
        component.set("v.selectedSite", selectedSite);

        component.set("v.checkparam", false);
        helper.getShifts(component);

        var dataTable = $('#tableId').DataTable();
        dataTable.show();
        $('.dataTables_paginate').show();
        $('.dataTables_info').show();
    },
    renderPage: function (component, event, helper) {
        //   helper.renderPage(component);
    },
    myrates: function (component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "rateinfo?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    searchShifts: function (component, event, helper) {
        component.set("v.checkSearch", true);
        component.set("v.selectedSite", component.get("v.site"));
        // component.set("v.site", component.find("site").get("v.value"));
        component.set("v.selectedjobrole", component.find("jobRole").get("v.value"));
        var x = document.getElementById("timePeriod").value;
        component.set("v.timeperiodselected", x);
        helper.getShifts(component);
        helper.getsitejobroleonSiteChange(component, event, helper);
    },
    feedback: function (component, event, helper) {
        var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        var buttonName = event.target.id;
        component.set("v.selectedRating", 1);
        var idToBeCancelled = buttonName;
        var shiftList = component.get("v.allshifts");
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
    closeModelCancel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.isOpenCancel", false);
        component.set("v.selectedRating", null);
    },
    submitRating: function (component, event, helper) {
        //  console.log('rate');
        component.set("v.Spinner", false);
        var shift = component.get("v.feedbackshift");
        //   console.log("shift feedback"+shift.Id);
        var action = component.get("c.submitRatings");
        var selectedRating = component.get("v.selectedRating");
        //   console.log("selectedRating"+selectedRating);

        //helper.submitRating(component);
        if (selectedRating == null) {
            component.set("v.Spinner", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please select Rating',
                mode: 'pester'
            });
            toastEvent.fire();
        } else {
            var siteRecId = helper.getJsonFromUrl().site;
            // var siteIdvalue = component.find("site").get("v.value");
            var siteIdvalue = component.get("v.site");
            if (siteIdvalue == undefined || siteIdvalue == "") {
                siteIdvalue = siteRecId;
            }
            action.setParams({
                "shiftID": component.get("v.feedbackshift").Id,
                "selectedRating": component.get("v.selectedRating"),
                "siteId": siteIdvalue,
                "jobRoleId": component.find("jobRole").get("v.value"),
                "timePeriod": document.getElementById("timePeriod").value
            });
            action.setCallback(this, function (response) {
                //     console.log('actionasd 2@@');
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
                    var elements = document.getElementsByClassName("feedbackSpnId1");
                    var cmpTarget = component.find('feedbackSpnId1');
                    $A.util.addClass(elements, 'disablebutton');
                    component.set("v.selectedRating", 1);
                    component.set("v.Spinner", false);
                    $A.get('e.force:refreshView').fire();
                    component.set("v.shifts", result);
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();
                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: [],
                            columnDefs: [
                                { "orderable": false, "targets": [6] },

                            ]
                        });

                    }, 500);
                    var button = event.getParam("rating");
                    for (var i = 0; i < button.length; i++) {
                        $A.util.removeClass(button[i], 'slds-button_success');
                    }
                    $A.util.addClass(target, 'slds-button_success');
                    component.set("v.selectedRating", 1);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'There is some issues while submitting rating. Please contact your consultant',
                    });
                    toastEvent.fire();
                }
            });

            var appEvent = $A.get("e.c:RatingAppEvent");
            appEvent.fire();
            $A.enqueueAction(action);
            component.set("v.checkSearch", true);
        }
    },
    dashboardNavigate: function (component, event, helper) {
        /*event.preventDefault();
        var param = component.find('site').get('v.value');
        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + '?site=' + param;
        window.location.replace(urlRedirect);
        return false;*/
        event.preventDefault();
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        var urlRedirect = baseURL + '?site=' + component.get("v.site");
        window.location.replace(urlRedirect);
        return false;
    },
    pastVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'testpastvacancynew?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    myProfileNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "myprofile?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    siteManagementNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "sitemanagement?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "fastbooking?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testnewvacancy?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "newbookedtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'pasttemps?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'newcontactus?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "approved-timeSheets-new?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function (component, event, helper) {

        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/shiftdateview?site=' + param
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();

        /*  event.preventDefault();
          var param = component.find('site').get('v.value');

          if(param == null)
          {
             param = helper.getJsonFromUrl().site;
          }
          var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shiftdateview?site="+param;
          window.location.replace(urlRedirect);
          return false; */
    },
    candidateView: function (component, event, helper) {
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/candidateview?site=' + param
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();

        /*   event.preventDefault();
           var param = component.find('site').get('v.value');

           if(param == null)
           {
              param = helper.getJsonFromUrl().site;
           }
           var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidateview?site="+param;
           window.location.replace(urlRedirect);
           return false; */
    },

    activeVacancy: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },

    logout: function (component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "login/?startURL=%2Fclient%2Fs%2F&ec=302";
        window.location.replace(urlRedirect);
        return false;
    },

    // this function automatic call by aura:waiting event
    scriptsLoaded: function (component, event, helper) {//alert('2222');
        // make Spinner attribute true for display loading spinner
        helper.helperscriptload(component, event, helper);
    },
    // this function automatic call by aura:waiting event
    showSpinner: function (component, event, helper) {//alert('2222');
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    },

    resetAllValues: function (component, event, helper) {
        //   console.log('reset '+component.find("jobRole").get("v.value") +document.getElementById("timePeriod").value);
        if (component.get("v.selectedjobrole") != null || component.get("v.timeperiodselected") != null) {
            component.set("v.selectedjobrole", null);

            component.set("v.timeperiodselected", null);
            //    console.log('no');
            component.find("jobRole").set("v.value", null);
            //    console.log('no2');
            document.getElementById("timePeriod").value = null;
            component.set("v.checkSearch", true)

            helper.getShifts(component);
        }
    },

    cancel: function (component, event, helper) {
        helper.helpercancel(component, event, helper);
    }
})
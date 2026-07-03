({
    doInit: function (component, event, helper) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        console.log('siteRecId: ' + siteRecId);
        component.set("v.site", siteRecId);
        var siteID;
        var flag = 0;
        var sitesList = component.get('c.getsitesList');
        sitesList.setCallback(this, function (response) {
            console.log('response from fast booking:', response.getReturnValue(), response.getState() + ' ' + component.isValid());
            var optsSite = [];
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                var SiteArray = response.getReturnValue();
                for (var i = 0; i < SiteArray.length; i++) {
                    if (SiteArray[i].Id == siteRecId) {
                        flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                        siteID = siteRecId;
                    } else {
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id

                        });
                    }
                }
                if (flag == 0) {
                    console.log('flag: ' + flag + ' optsSite[0].Id: ' + optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }
            }

            component.set("v.siteList", optsSite);

        });

        var jobsites = component.get('c.getJobRoleList');
        jobsites.setCallback(this, function (response) {
            var OptsjobSites = [];
            var jobSitesArray = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                OptsjobSites.push({
                    label: "Select Job Role",
                    value: ""
                });
                var siteArray = response.getReturnValue();
                for (var i = 0; i < jobSitesArray.length; i++) {
                    OptsjobSites.push({
                        label: jobSitesArray[i].Name,
                        value: jobSitesArray[i].Id
                    });
                }
            } else {
                console.log("Cannot get the Job Roles. Error >> " + response.getMessage());
            }
            component.set("v.jobSiteList", OptsjobSites);
            console.log('OptsjobSites >>> ' + OptsjobSites);
        });
        helper.getLoggedInUserInformation(component);
        $A.enqueueAction(sitesList);
        $A.enqueueAction(jobsites);
    },
    scriptsLoaded: function (cmp, evt, helper) {
        console.log('test');
        $("#requiredStaff").on("keypress", function (evt) {
            var keycode = evt.charCode || evt.keyCode;
            if (keycode == 46) {
                console.log('test2');
                return false;
            }
        });
    },
    createNewShift: function (component, event, helper) {
        let button = event.getSource();
        button.set('v.disabled', true);

        var noOfReqStaff = $("#requiredStaff").val();
        var regexpIntegerOnly = /^[0-9]$/;
        var toastEvent = $A.get("e.force:showToast");
        var isvalid = true;
        component.set("v.isSiteEmpty", false);
        component.set("v.isJobRoleEmpty", false);
        component.set("v.isStaffEmpty", false);
        component.set("v.isStartDateEmpty", false);
        component.set("v.isEndDateEmpty", false);
        component.set("v.isStartTimeEmpty", false);
        component.set("v.isEndTimeEmpty", false);
        var selectedSite = component.find("siteId").get("v.value");

        if (selectedSite == null) {
            selectedSite = helper.getJsonFromUrl().site;
        }
        console.log('selectedSite:', selectedSite);
        var selectedjobrole = component.find("jobRoleId").get("v.value");
        console.log('selectedjobrole:', selectedjobrole);

        var staffreq = document.getElementById("requiredStaff").value;//component.find("requiredStaff").get("v.value");
        console.log('staffreq:', staffreq);
        var startDate = document.getElementById("startDate").value;//component.find("startDate").get("v.value");
        console.log('startDate:', startDate);
        //var startDate1 = new Date(startDate);

        var stDateFormat = startDate.split("/");
        var startDate1 = new Date(stDateFormat[1] + "/" + stDateFormat[0] + "/" + stDateFormat[2]);
        console.log('startDate1:', startDate1);

        var startTime = document.getElementById("startTime").value;
        console.log('startTime:', startTime);

        var endDate = document.getElementById("endDate").value;//component.find("endDate").get("v.value");
        console.log('endDate:', endDate);
        var endDateFormat = endDate.split("/");
        var endDate1 = new Date(endDateFormat[1] + "/" + endDateFormat[0] + "/" + endDateFormat[2]);
        console.log('endDate1:', endDate1);
        var endTime = document.getElementById("endTime").value;//component.find("endTime").get("v.value");
        console.log('endTime:', endTime);
        var InvoicePO = document.getElementById("InvoicePO").value;

        var message = '';
        if (selectedSite === "") {
            button.set('v.disabled', false);
            component.set("v.isSiteEmpty", true);
        }
        if (selectedjobrole === "") {
            button.set('v.disabled', false);
            component.set("v.isJobRoleEmpty", true);
            isvalid = false;
            toastEvent.setParams({
                "message": "Please select Job Role"
            });
            toastEvent.fire();
        }
        if (startDate == undefined || startDate == "") {
            button.set('v.disabled', false);
            isvalid = false;
            component.set("v.isStartDateEmpty", true);
            toastEvent.setParams({
                "message": "Please select Start Date"
            });
            toastEvent.fire();
        }
        if (endDate == undefined || endDate == "") {
            button.set('v.disabled', false);
            isvalid = false;
            component.set("v.isEndDateEmpty", true);
            toastEvent.setParams({
                "message": "Please select End Date"
            });
            toastEvent.fire();
        }
        if (startTime == null || startTime == "") {
            button.set('v.disabled', false);
            isvalid = false;
            component.set("v.isStartTimeEmpty", true);
            toastEvent.setParams({
                "message": "Please select Start Time"
            });
            toastEvent.fire();
        }
        if (endTime == null || endTime == "") {
            button.set('v.disabled', false);
            isvalid = false;
            component.set("v.isEndTimeEmpty", true);
            toastEvent.setParams({
                "message": "Please select End Time"
            });
            toastEvent.fire();
        }
        if (staffreq == null || staffreq === "") {
            button.set('v.disabled', false);
            isvalid = false;
            component.set("v.isStaffEmpty", true);
            toastEvent.setParams({
                "message": "Please select No. of Required Staff"
            });
            toastEvent.fire();
        }
        if (startDate1 > endDate1) {
            button.set('v.disabled', false);
            isvalid = false;
            toastEvent.setParams({
                "message": "Start Date cannot be greater than End Date",
                duration: ' 1000',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        //  console.log('@@ '+noOfReqStaff+regexpIntegerOnly + ' %% ' +noOfReqStaff.match(regexpIntegerOnly));
        if (noOfReqStaff > 500) {
            button.set('v.disabled', false);
            isvalid = false;
            toastEvent.setParams({
                "message": "No. of Required Staff must be less than or equal to 500",
                duration: ' 1000',
                mode: 'pester'
            });
            toastEvent.fire();
        }


        if (isvalid == true) {
            var startDateFormat = startDate.split("/");
            startDateFormat = startDateFormat[1] + "/" + startDateFormat[0] + "/" + startDateFormat[2];
            var startDateTime = new Date(startDateFormat + ' ' + startTime);
            console.log('startDateTime:', startDateTime);
            var endDateFormat = endDate.split("/");
            endDateFormat = endDateFormat[1] + "/" + endDateFormat[0] + "/" + endDateFormat[2];
            var endDateTime = new Date(endDateFormat + ' ' + endTime);
            console.log('endDateTime:', endDateTime);
            var diff = (endDateTime.getTime() - startDateTime.getTime()) / (60000 * 60);
            console.log('diff:', diff);

            if (startDate == endDate && diff > 13) {
                button.set('v.disabled', false);
                message = 'End Date cannot be later than 13 hours after Start Date';
                toastEvent.setParams({


                    "message": "End Date cannot be later than 13 hours after Start Date",
                    duration: ' 2000',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else if (diff < 0) {
                button.set('v.disabled', false);
                message = 'End Time should be greater than Start time';
                toastEvent.setParams({


                    "message": "End Time should be greater than Start time",
                    duration: ' 2000',
                    mode: 'pester'

                });
                toastEvent.fire();
            } else {
                var createShift = component.get('c.CreateNewShift');
                createShift.setParams({
                    siteId: selectedSite,
                    jobRoleId: selectedjobrole,
                    startTime: startTime,
                    endTime: endTime,
                    startDate: startDate,
                    endDate: endDate,
                    staffNumber: staffreq,
                    InvoicePO: InvoicePO
                });
                createShift.setCallback(this, function (response) {
                    if (component.isValid() && response.getState() == 'SUCCESS') {
                        //added
                        button.set('v.disabled', false);
                        console.log('In success');
                        message = response.getReturnValue();
                        console.log('message:', message);
                        component.set("v.message", message);
                        component.set("v.isOpen", true);
                        var toastEvent = $A.get("e.force:showToast");
                        if (startDateTime == 'Invalid Date' || endDateTime == 'Invalid Date') {
                            toastEvent.setParams({
                                message: message,
                                messageTemplate: message,

                                mode: 'pester'

                            });
                        }
                        else {
                            toastEvent.setParams({
                                title: 'Success Message',
                                message: message,
                                messageTemplate: message,
                                duration: ' 1000',
                                type: 'success',
                                mode: 'pester'
                            });
                        }
                        toastEvent.fire();
                        component.find("jobRoleId").set("v.value", '');
                        document.getElementById("requiredStaff").value = null;
                        document.getElementById("startDate").value = null;
                        document.getElementById("startTime").value = '00:00';
                        document.getElementById("endDate").value = null;
                        document.getElementById("endTime").value = '00:00';
                        document.getElementById("requiredStaff").value = null;
                        document.getElementById("InvoicePO").value = '';

                    } else {
                        button.set('v.disabled', false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({

                            message: 'Your message can not be sent! Please contact your Consultant',
                            messageTemplate: '',

                            mode: 'pester'

                        });
                        toastEvent.fire();
                    }
                });
            }
        }
        $A.enqueueAction(createShift);

    },

    dashboardnavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + '?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    myrates: function (component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "rateinfo?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'testpastvacancynew?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    myProfileNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "myprofile?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    siteManagementNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "sitemanagement?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "fastbooking?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testnewvacancy?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "newbookedtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'pasttemps?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'newcontactus?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "approved-timeSheets-new?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "shiftdateview?site=" + param;
        window.location.assign(urlRedirect);
        return false;

        $A.get('e.force:refreshView').fire();


    },
    candidateView: function (component, event, helper) {
        var param = component.find('siteId').get('v.value');

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
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },


    logout: function (component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL") + "secur/logout.jsp?retUrl=" + $A.get("$Label.c.Lightning_CommunityLogout_URL") + "CommunitiesLanding";
        window.location.replace(urlRedirect);
        return false;
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


})
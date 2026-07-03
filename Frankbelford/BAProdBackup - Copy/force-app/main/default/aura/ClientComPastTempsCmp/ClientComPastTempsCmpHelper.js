({
    handleCancel: function (component, event, helper) {
        var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        //console.log('fire ' + appEvent);
    },

    helperscriptload: function (component, event, helper) {
        setTimeout(function () {
            $('.searchDetail_table').on('click', '.bluecolor', function () {
                //console.log('tr@@ 12');
                var tr = $(this).closest('tr');
                if ($(tr).hasClass('child')) {
                    var Id = $(this).attr('id');
                    //console.log(Id);
                    helper.helperfeedback(component, Id, event, helper);
                }
            });
        }, 1000);
    },

    helperfeedback: function (component, Id, event, helper) {
        //console.log('in help');
        //console.log('buttonName ' + event + Id);
        var buttonName = Id;
        component.set("v.selectedRating", 1);
        
        var idToBeCancelled = buttonName;
        var shiftList = component.get("v.shifts");

        for (var i = 0; i < shiftList.length; i++) {
            if (shiftList[i].Id == idToBeCancelled) {
                component.set("v.feedbackshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
                //console.log('shift ' + idToBeCancelled);
            }
        }
    },

    helpercloseModelCancel: function (component, event, helper) {
        var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        //console.log('fire');
    },

    getJsonFromUrl: function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function (part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },

    getSiteList: function (component) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        component.set("v.site", siteRecId);
        var sitesList = component.get('c.getSitesOfLoggedInUser');
        var getDefaultSiteId;
        sitesList.setCallback(this, function (response) {
            var state = response.getState();
            //console.log('check state' + state);
            var optsSite = [];
            var siteID;
            var flag = 0;
            if (component.isValid() && state == "SUCCESS") {
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
                    //console.log('flag: ' + flag + ' optsSite[0].Id: ' + optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }
            }
            component.set("v.siteList", optsSite);
            getDefaultSiteId = siteID;
        });
        $A.enqueueAction(sitesList);

        var candidateList = component.get('c.getCandidateListLoggedInUser');
        candidateList.setParams({
            "siteId": getDefaultSiteId,
        });
        candidateList.setCallback(this, function (response) {
            var optCandidate = [];
            //console.log('11111111111 ' + getDefaultSiteId);
            var siteCandidateArray = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                optCandidate.push({
                    label: "Select Temp",
                    value: ""
                });
                for (var i = 0; i < siteCandidateArray.length; i++) {
                    optCandidate.push({
                        label: siteCandidateArray[i].Name,
                        value: siteCandidateArray[i].Id
                    });
                }
            } else {
                //('errror');
            }
            //console.log('==optCandidate=' + optCandidate);
            component.set("v.candidateNameList", optCandidate);
        });
        $A.enqueueAction(candidateList);
    },

    getLoggedInUserInformation: function (component) {
        var fetchUserName = component.get("c.fetchUserInformation");
        fetchUserName.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },

    JobRoleList: function (component) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        var selectedsite = component.get("v.selectedSite");
        var sendSite;
        if (selectedsite == null || selectedsite == undefined) {
            sendSite = siteRecId;
        } else {
            sendSite = selectedsite;
        }
        var jobsites = component.get('c.getJobRoleList');
        jobsites.setParams({
            "siteId": sendSite
        });
        jobsites.setCallback(this, function (response) {
            var OptsjobSites = [];
            var jobSitesArray = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                OptsjobSites.push({
                    label: "Select JobRole",
                    value: ""
                });
                var siteArray = response.getReturnValue();
                for (var i = 0; i < jobSitesArray.length; i++) {
                    OptsjobSites.push({
                        label: jobSitesArray[i].Name,
                        value: jobSitesArray[i].Id
                    });
                }
            }
            component.set("v.jobSiteList", OptsjobSites);
        });

        $A.enqueueAction(jobsites);
    },

    SiteCandidatesHelper: function (component, event, helper) {
        var candidateList = component.get('c.getCandidateListLoggedInUser');
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        var siteIdvalue = component.get("v.selectedSite");

        if (siteIdvalue == undefined || siteIdvalue == "") {
            siteIdvalue = siteRecId;
        }
        candidateList.setParams({
            "siteId": siteIdvalue,
        });
        candidateList.setCallback(this, function (response) {
            var optCandidate = [];
            var siteCandidateArray = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                optCandidate.push({
                    label: "Select Temp",
                    value: ""
                });
                for (var i = 0; i < siteCandidateArray.length; i++) {
                    optCandidate.push({
                        label: siteCandidateArray[i].Name,
                        value: siteCandidateArray[i].Id
                    });
                }
            } else {
                //alert('errror');
            }
            //console.log('==optCandidate=' + optCandidate);
            component.set("v.candidateNameList", optCandidate);
        });
        $A.enqueueAction(candidateList);
        var checkval = component.get("v.checkSearch");
        if (checkval == true) {
            this.getShiftsOnLoad(component);
        }
    },

    searchShiftsHelper: function (component, event, helper) {
        var siteIdvalue = component.get('v.site');
        var selectedjobRoleIdValue = component.find("jobRoleId").get("v.value");

        var selectedcandidateIdValue = component.find("candidateId").get("v.value");
        var selectedTimePeriodValue = document.getElementById("timePeriod").value;//component.find("timePeriod").get("v.value");

        console.log("siteIdvalue >> " +siteIdvalue);
        console.log("selectedjobRoleIdValue >> " +selectedjobRoleIdValue);
        console.log("selectedcandidateIdValue >> " +selectedcandidateIdValue);
        console.log("selectedTimePeriodValue >> " +selectedTimePeriodValue);


        if (selectedTimePeriodValue == '') {
            selectedTimePeriodValue = "lastmonth";
        }
        var searchAllPastShifts = component.get("c.getAllPastShifts");
        searchAllPastShifts.setParams({
            "siteId": siteIdvalue,
            "jobRoleId": selectedjobRoleIdValue,
            "candidateId": selectedcandidateIdValue,
            "timePeriod": selectedTimePeriodValue,
        });
        searchAllPastShifts.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state >> " + state);
            var result = response.getReturnValue();
            console.log("response >> " + JSON.stringify(response));
            var currentList;

            currentList = result;
            var checkval = component.get("v.checkSearch");
            component.set("v.shifts", currentList);
            if (result.length > 0) {
                $("#overlay").show();
                if (checkval == true) {
                    component.set("v.Spinner", false);
                    component.set("v.checkparam", false);
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();
                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: [],
                        });

                        $("#overlay").hide();
                    }, 1000);
                }
                else {

                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: [],
                        });

                        $("#overlay").hide();
                    }, 1000);
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({

                    'message': 'No shifts available for this search',

                    'Duration': '500'
                });

                toastEvent.fire();
                component.set("v.checkparam", true);

                var dataTable = $('#tableId').DataTable();
                $('.dataTables_paginate').hide();
                $('.dataTables_info').hide();
            }
        });
        $A.enqueueAction(searchAllPastShifts);
    },
    renderPage: function (component) {

    },

    getShiftsOnLoad: function (component) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];

        var selectedsite = component.get("v.selectedSite");
        var finalsite;
        if (selectedsite == null) {
            if (siteRecId == null) {
                finalsite = null;
            } else {
                finalsite = siteRecId;
            }
        } else {
            finalsite = selectedsite;
        }

        var searchAllPastShifts = component.get("c.getAllPastShifts");
        searchAllPastShifts.setParams({
            "siteId": finalsite,
            "jobRoleId": null,
            "candidateId": null,
            "timePeriod": "lastmonth"
        });
        searchAllPastShifts.setCallback(this, function (response) {
            var result = response.getReturnValue();
            var currentList;
            currentList = result;

            var checkval = component.get("v.checkSearch");

            component.set("v.shifts", currentList);
            if (result.length > 0) {
                $("#overlay").show();
                if (checkval == true) {
                    component.set("v.checkparam", false);

                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();

                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: [],
                            "bInfo": false,
                        });

                        $("#overlay").hide();
                    }, 1000);
                } else {
                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: [],
                        });

                        $("#overlay").hide();
                    }, 1000);
                }
            } else {
                component.set("v.Spinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'message': 'No shifts available for this search',
                    'Duration': '500'
                });
                toastEvent.fire();
                component.set("v.checkparam", true);

                var dataTable = $('#tableId').DataTable();
                $('.dataTables_paginate').hide();
                $('.dataTables_info').hide();
            }
        });
        $A.enqueueAction(searchAllPastShifts);
    }
})
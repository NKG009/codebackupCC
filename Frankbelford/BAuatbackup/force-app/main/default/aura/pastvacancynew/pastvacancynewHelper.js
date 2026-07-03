({
    helpercancel: function (component, event, helper) {
        var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        console.log('fire ' + appEvent);
    },

    helperscriptload: function (component, event, helper) {
        setTimeout(function () {
            $('.searchDetail_table').on('click', '.bluecolor', function () {
                console.log('tr@@ 12');
                var tr = $(this).closest('tr');
                if ($(tr).hasClass('child')) {
                    var Id = $(this).attr('id');
                    console.log(Id);
                    helper.helperfeedback(component, Id, event, helper);
                }

            });
        }, 600);
    },

    helperfeedback: function (component, Id, event, helper) {
        //debugger;
        console.log('in help');
        console.log('buttonName ' + event + Id);
        var buttonName = Id;
        component.set("v.selectedRating", 1);
        //   var target = event.getSource();
        var idToBeCancelled = buttonName;
        var shiftList = component.get("v.shifts");

        for (var i = 0; i < shiftList.length; i++) {
            if (shiftList[i].Id == idToBeCancelled) {
                component.set("v.feedbackshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
                console.log('shift ' + idToBeCancelled);
            }
        }
        //   debugger;
    },
    helpercloseModelCancel: function (component, event, helper) {
        var appEvent = $A.get("e.c:RatingAppEvent");
        appEvent.fire();
        console.log('fire');
    },

    getsitejobroleonSiteChange: function (component, event, helper) {
        var sitechange = component.get("v.checkSearch");
        if (sitechange == true) {

            var selectedsite = component.get("v.selectedSite");
            var jobRole = component.get("c.getJobRoles");
            jobRole.setParams({
                "siteId": selectedsite
            });
            jobRole.setCallback(this, function (response) {
                var state = response.getState();
                var optsJob = [];
                if (component.isValid() && state == "SUCCESS") {
                    var jobrolearray = response.getReturnValue();
                    optsJob.push({
                        class: "optionClass",
                        label: "Select Job Role",
                        value: ""
                    });
                    if (jobrolearray.length > 0 && jobrolearray != null) {
                        for (var i = 0; i < jobrolearray.length; i++) {
                            optsJob.push({
                                class: "optionClass",
                                label: jobrolearray[i].Name,
                                value: jobrolearray[i].Id

                            });
                        }

                    }

                    component.set("v.JobroleList", optsJob);
                }

            });
            $A.enqueueAction(jobRole);

        }
    },

    getsitejobrole: function (component) {
        var idParam = this.getJsonFromUrl().site;
        //console.log('idParam: ' + idParam);
        var selectedsite = component.get("v.selectedSite");

        var sendSite;
        if (selectedsite == null) {
            sendSite = idParam;
        } else {
            sendSite = selectedsite;
        }

        var jobRole = component.get("c.getJobRoles");
        jobRole.setParams({
            "siteId": sendSite
        });

        jobRole.setCallback(this, function (response) {
            var state = response.getState();
            var optsJob = [];

            if (component.isValid() && state == "SUCCESS") {
                var jobrolearray = response.getReturnValue();
                optsJob.push({
                    class: "optionClass",
                    label: "Select Job Role",
                    value: ""
                });
                for (var i = 0; i < jobrolearray.length; i++) {
                    optsJob.push({
                        class: "optionClass",
                        label: jobrolearray[i].Name,
                        value: jobrolearray[i].Id
                    });
                }
                component.set("v.JobroleList", optsJob);
            }
        });

        var siteID;

        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        var idParam = this.getJsonFromUrl().site;
        component.set("v.site", idParam);
        var siteList = component.get("c.getSites");
        siteList.setCallback(this, function (response) {
            var state = response.getState();
            console.log('check state '+state);
            console.log('response >> ' + JSON.stringify(response.getReturnValue()));
            var optsSite = [];
            if (component.isValid() && state == "SUCCESS") {
                var flag = 0;
                var SiteArray = response.getReturnValue();
                console.log('siteArray >> ' + SiteArray.length);
                /*for(var site in SiteArray){
                    console.log('idParam ');
                    if (site.Id === idParam) {
                        flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: site.Name,
                            value: site.Id,
                            selected: true
                        });
                        siteID = idParam;
                    } else {
                        optsSite.push({
                            class: "optionClass",
                            label: site.Name,
                            value: site.Id
                        });
                    }
                }*/
                //if(SiteArray.length !== 0) {
                    for (var i = 0; i < SiteArray.length; i++) {
                        if (SiteArray[i].Id === idParam) {
                            flag = 1;
                            optsSite.push({
                                class: "optionClass",
                                label: SiteArray[i].Name,
                                value: SiteArray[i].Id,
                                selected: true
                            });
                            siteID = idParam;
                        } else {
                            optsSite.push({
                                class: "optionClass",
                                label: SiteArray[i].Name,
                                value: SiteArray[i].Id
                            });
                        }
                    }
                //}

                if (flag === 0) {
                    console.log('idParam ');
                    console.log('flag: '+flag+' optsSite[0].Id: '+optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }

                component.set("v.selectedSite", idParam);
                component.set("v.SiteList", optsSite);
            }
        });

        var action1 = component.get("c.fetchUser");
        action1.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action1);
        $A.enqueueAction(siteList);
        $A.enqueueAction(jobRole);
    },

    getShifts: function (component) {
        var idParam = this.getJsonFromUrl().site;
        var selectedsite = component.get("v.selectedSite");
        var jobrole;
        var timeframe;
        var sendSite;
        if (selectedsite == null) {
            sendSite = idParam;
        }
        else {
            sendSite = selectedsite;
        }

        if (component.get("v.selectedjobrole") == null || component.get("v.selectedjobrole") == '') {
            jobrole = null;
        } else {
            jobrole = component.get("v.selectedjobrole");
        }

        if (component.get("v.timeperiodselected") == null || component.get("v.timeperiodselected") == '') {
            timeframe = null;
        } else {
            timeframe = component.get("v.timeperiodselected");
        }

        var action = component.get("c.getShiftshistory");
        action.setParams({
            "site": sendSite,
            "jobrole": component.get("v.selectedjobrole"),
            "timeframe": component.get("v.timeperiodselected")
        });
        console.log('sendSite > ' + sendSite);
        console.log('component.get("v.selectedjobrole") = ' + component.get("v.selectedjobrole"));
        console.log('component.get("v.timeperiodselected") = ' + component.get("v.timeperiodselected"));
        action.setCallback(this, function (response) {
            var currentList;
            var result = response.getReturnValue();
            var checkval = component.get("v.checkSearch");
            currentList = result;
            component.set("v.allshifts", currentList);
            component.set("v.shifts", currentList);
            console.log('response >>> ' + JSON.stringify(response));
            if (result.length > 0) {
                $("#overlay").show();
                console.log('working...');
                if (checkval == true) {
                    component.set("v.Spinner", false);
                    component.set("v.checkparam", false);
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();

                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            "aaSorting": [],
                        });
                        $("#overlay").hide();
                    }, 500);
                } else {
                    component.set("v.Spinner", false);
                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            "aaSorting": []
                        });

                        $("#overlay").hide();
                    }, 500);
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
                $('.dataTables_empty').hide();
            }
        });
        $A.enqueueAction(action);
    },

    renderPage: function (component) {
        var records = component.get("v.shifts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 10, pageNumber * 10);

        component.set("v.currentList", pageRecords);
        var resultrec = component.get("v.shifts");
        if (resultrec.length > 0) {
            setTimeout(function () {
                $('#tableId').DataTable({ responsive: true });
            }, 50);
        }
    },

    getJsonFromUrl: function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function (part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    }
})
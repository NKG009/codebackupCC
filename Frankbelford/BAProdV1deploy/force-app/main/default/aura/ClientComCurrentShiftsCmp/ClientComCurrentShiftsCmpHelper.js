({
    getLoggedInUserName: function (component) {
        var fetchUserName = component.get("c.getUserInformation");
        fetchUserName.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },

    getsitejobroleonSiteChange: function (component, event) {
        var sitechange = component.get("v.checkSearch");
        if (sitechange == true) {
            var selectedsite = component.get("v.selectedSite");
            var jobRole = component.get("c.getJobRoleList");
            jobRole.setParams({
                "siteId": selectedsite
            });
            jobRole.setCallback(this, function (response) {
                var state = response.getState();
                var optsJob = [];
                if (component.isValid() && state == "SUCCESS") {
                    var jobrolearray = response.getReturnValue();
                    console.log('check site array' + jobrolearray);
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
            $A.enqueueAction(jobRole);
        }
    },

    getsitejobrole: function (component) {
        console.log(' in getsite ');
        var idParam = this.getJsonFromUrl().site;
        var selectedsite = component.get("v.selectedSite");
        var sendSite;
        if (selectedsite == null) {
            sendSite = idParam;
        } else {
            sendSite = selectedsite;
        }

        var jobRole = component.get("c.getJobRoleList");
        jobRole.setParams({
            "siteId": sendSite
        });
        jobRole.setCallback(this, function (response) {
            var state = response.getState();
            var optsJob = [];
            if (component.isValid() && state == "SUCCESS") {
                var jobrolearray = response.getReturnValue();
                console.log('check site array' + jobrolearray);
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

        var idParam = this.getJsonFromUrl().site;
        // var url_String = document.URL;
        //   var url = new URL(url_String);
        //    var siteRecId = url.searchParams.get('site');
        // alert('=='+siteRecId);
        var siteList = component.get("c.getSites");
        var siteID;
        siteList.setCallback(this, function (response) {
            var state = response.getState();
            var flag = 0;
            console.log('check state' + state);
            var optsSite = [];
            if (component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();
                for (var i = 0; i < SiteArray.length; i++) {
                    if (SiteArray[i].Id == idParam) {
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
                if (flag == 0) {
                    console.log('flag: ' + flag + ' optsSite[0].Id: ' + optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }

            }
            console.log('idParam' + idParam);
            component.set("v.site", idParam);
            component.set("v.selectedSite", idParam);
            component.set("v.SiteList", optsSite);
            console.log('SiteList ' + optsSite);




        });


        $A.enqueueAction(jobRole);
        $A.enqueueAction(siteList);


    },

    getShifts: function (component, event) {
        console.log(">>>>>getShifts<<<<<<<");
        var idParam = this.getJsonFromUrl().site;
        var selectedsite = component.get("v.selectedSite");
        var jobrole;
        var timeframe;
        var sendSite;
        if (selectedsite == null) {
            sendSite = idParam;
        } else {
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
        console.log('sendSite ' + sendSite + jobrole + timeframe);
        var action = component.get("c.getAllShifts");
        console.log('sendSite = '+ sendSite + ' jobrole='+jobrole+' timeframe='+timeframe);
        action.setParams({
            "site": sendSite,
            "jobrole": jobrole,
            "timeframe": timeframe
        });

        action.setCallback(this, function (response) {
            var currentList;
            var result = response.getReturnValue();
            console.log('length ' + result.length);
            currentList = result;
            var checkval = component.get("v.checkSearch");
            var nodata = component.get("v.nodata");
            console.log('checkval ' + checkval);
            console.log('nodata ' + nodata);
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
                        });
                        $("#overlay").hide();
                    }, 1000);

                } else {
                    console.log("loading data..");
                    setTimeout(function () {
                        $('#tableId').DataTable({
                            responsive: true,
                            aaSorting: []
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
                console.log('no returned');
                component.set("v.checkparam", true);
                var dataTable = $('#tableId').DataTable();
                $('.dataTables_paginate').hide();
                $('.dataTables_info').hide();
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
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

    doCommPageNav: function (cmmPageName, cmp, event) {
        console.log('Url updated');
        event.preventDefault();
        var navService = cmp.find("navService");
        var pageReference = {
            type: "comm__namedPage",
            attributes: {
                pageName: cmmPageName
            },
            state: {
                site: cmp.get("v.site")
            }
        };
        navService.navigate(pageReference);
        console.log('Url updated');
    }

})
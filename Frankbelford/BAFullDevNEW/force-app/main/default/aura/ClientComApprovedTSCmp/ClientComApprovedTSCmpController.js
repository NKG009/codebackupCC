({
    myrates: function (component, event, helper) {

        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "rateinfo?site=" + param;
        window.location.replace(urlRedirect);
        return false;

    },
    updatePO: function (component, event, helper) {


        var target = event.target.id;
        var tarValue = document.getElementById(target).value;
        console.log('target ' + target + tarValue);

        var action = component.get("c.UpdateInvoicePO");
        action.setParams({
            "timeId": target,
            "InvoicePO": tarValue
        });

        action.setCallback(this, function (response) {
            var result = response.getReturnValue();
            console.log('result ' + result);
            //  var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (result == "SUCCESS") {
                Console.log('Success');
            }
            else { Console.log('Error'); }
        });

        $A.enqueueAction(action);
    },
    dashboardnavigate: function (component, event, helper) {
        /*event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "?site=" + param;
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
        var param = helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testpastvacancynew?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    MyProfileNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "myprofile?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    SiteManagementNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "sitemanagement?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "fastbooking?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testnewvacancy?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "newbookedtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "pasttemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "newcontactus?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "approved-timeSheets-new?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function (component, event, helper) {
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/shiftdateview?site=' + param
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();

        /*   event.preventDefault();
        var param = helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shiftdateview?site="+param;;
        window.location.replace(urlRedirect);
        return false;*/
    },
    candidateView: function (component, event, helper) {
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/candidateview?site=' + param
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();

        /*  event.preventDefault();
        var param = helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidateview?site="+param;;
        window.location.replace(urlRedirect);
        return false; */
    },
    handleSelectAllTimesheet: function (component, event, helper) {
        var getID = component.get("v.currentList");
        var checkvalue = component.find("selectAll").get("v.value");
        var checkTimesheet = component.find("checkTimesheet");
        console.log('checkTimesheet' + checkTimesheet)
        if (!Array.isArray(checkTimesheet)) {
            checkTimesheet = [checkTimesheet];
        }
        if (checkvalue == true) {
            console.log('inside 1st if' + checkTimesheet.length);
            for (var i = 0; i < checkTimesheet.length; i++) {
                checkTimesheet[i].set("v.value", true);
                console.log('inside 1st for');
            }
        }
        else {
            for (var i = 0; i < checkTimesheet.length; i++) {
                checkTimesheet[i].set("v.value", false);
            }
        }
    },
    BulkPOUpload: function (component, event, helper) {
        var selectedTimesheets = [];
        var checkvalue = component.find("checkTimesheet");
        var ponumberbulk = component.find("PONumber").get("v.value");
        console.log('InvoicePO-->' + ponumberbulk);
        if (!Array.isArray(checkvalue)) {
            if (checkvalue.get("v.value") == true) {
                selectedTimesheets.push(checkvalue.get("v.text"));
            }
        } else {
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedTimesheets.push(checkvalue[i].get("v.text"));
                }
            }
        }
        component.set("v.selectedtimesheetIds", selectedTimesheets);
        console.log('selectedtimesheets--' + selectedTimesheets);
        if ((ponumberbulk == null || ponumberbulk == '' || ponumberbulk == 'undefined') || (selectedTimesheets == '' || selectedTimesheets == null)) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                'message': 'Please ensure you select a timesheet and enter a PO number to apply',
                'Duration': '300'
            });
            toastEvent.fire();
        }
        else {
            var action = component.get("c.UpdateBulkPO");
            action.setParams({
                "Ponumber": ponumberbulk,
                "Timesheetlist": selectedTimesheets
            });

            action.setCallback(this, function (response) {
                var result = response.getReturnValue();
                console.log('result ' + result);
                //  var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();
                if (result == "SUCCESS") {
                    //  Console.log('Success');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        'message': 'PO Number has been successfully updated',
                        'type': 'success',
                        'Duration': '1500'
                    });
                    toastEvent.fire();
                    var delayInMilliseconds = 2000;
                    window.setTimeout(
                        $A.getCallback(function () {
                            window.location.reload();
                        }), delayInMilliseconds
                    );
                    //  window.location.reload();
                }
                else {
                    Console.log('Error');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        'message': 'An error occured in updating PO',
                        'Duration': '1500'
                    });
                    toastEvent.fire();
                }
            });

            $A.enqueueAction(action);
        }
    },
    activeVacancy: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('select').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testtemps?site=" + param;;
        window.location.replace(urlRedirect);
        return false;
    },
    Candidate: function (component, event, helper) {
        component.set("v.isTimesheetApprovalOpen", false);
        component.set("v.isCurrentVacancies", false);
        component.set("v.isDashboardOpen", false);
        component.set("v.isCandidateOpen", true);
    },
    Dashboard: function (component, event, helper) {
        component.set("v.isTimesheetApprovalOpen", false);
        component.set("v.isCurrentVacancies", false);
        component.set("v.isCandidateOpen", false);
        component.set("v.isDashboardOpen", true);
    },
    ApproveTimesheets: function (component, event, helper) {
        component.set("v.isCurrentVacancies", false);
        component.set("v.isDashboardOpen", false);
        component.set("v.isCandidateOpen", false);
        component.set("v.isTimesheetApprovalOpen", true);
        $A.get('e.force:refreshView').fire();

    },
    CurrentVacancies: function (component, event, helper) {
        component.set("v.isTimesheetApprovalOpen", false);
        component.set("v.isDashboardOpen", false);
        component.set("v.isCandidateOpen", false);
        component.set("v.isCurrentVacancies", true);
    },

    doInit: function (cmp, evt, helper) {
        var siteID;
        var idParam = helper.getJsonFromUrl().site;
        var siteList = cmp.get("c.getSites");

        siteList.setCallback(this, function (response) {
            var state = response.getState();
            var optsSite = [];
            var flag = 0;
            if (cmp.isValid() && state == "SUCCESS") {
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
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }
                console.log('@@@ ' + optsSite);
                $A.get('e.force:refreshView').fire();
                cmp.set("v.site", siteID);
                cmp.set("v.SiteList", optsSite);
                console.log('siteID parent ' + siteID);

                var searchResult = cmp.get("c.getsearchResult");
                var srchList;

                if (idParam != null) {
                    var selectedSite = idParam;
                } else {
                    var selectedSite = siteID;
                }

                var selectedCandidate = null;
                var selectedTimeSheet = null;
                var selectedWeekEndDate = null;

                searchResult.setParams({ siteId: selectedSite, candidateId: selectedCandidate, timeSheetId: selectedTimeSheet, weekEndDate: selectedWeekEndDate });
                searchResult.setCallback(this, function (response) {
                    //     console.log('in callback method:');
                    var state = response.getState();
                    //     console.log('state:',state);
                    if (cmp.isValid() && state == "SUCCESS") {
                        srchList = response.getReturnValue();
                        //console.log('srchList:',srchList);

                        $("#overlay").show();
                        if (srchList.length > 0) {
                            //  console.log('in if');
                            cmp.set("v.TimeSheets", srchList);
                            cmp.set("v.currentList", srchList);
                            setTimeout(function () {
                                $('#tableId').DataTable({
                                    responsive: true,
                                    aaSorting: [],
                                    columnDefs: [{ "orderable": false, "targets": [6] },]
                                });
                                $("#overlay").hide();
                            }, 3000);
                        } else {
                            cmp.set("v.Spinner", false);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                'message': 'No Timesheet available for this search',
                                'Duration': '500'
                            });
                            toastEvent.fire();
                            $("#overlay").hide();
                            event.preventDefault();
                            var dataTable = $('#tableId').DataTable();
                            $('.dataTables_paginate').hide();
                            $('.dataTables_info').hide();
                            $('tbody').hide();
                            dataTable.clear();
                        }
                    }
                });
                $A.enqueueAction(searchResult);
            }
        });
        $A.enqueueAction(siteList);

        var action1 = cmp.get("c.fetchUser");
        action1.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.Name", storeResponse);
            }
        });
        $A.enqueueAction(action1);

        var fetchUserName = cmp.get("c.getUserInformation");
        fetchUserName.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },

    onChange: function (cmp, evt, helper) {

        helper.helperscriptload(cmp, evt, helper);
        cmp.set("v.site", "");
        //cmp.set("v.site", cmp.find('select').get('v.value'));
        console.log("Site change handler");
        cmp.set("v.site", evt.getParam("selectedSiteId"));
        cmp.set("v.currentList", "");
        var searchResult = cmp.get("c.getsearchResult");
        var srchList;
        var selectedSite = cmp.get("v.site");//component.find("SiteId").get("v.value");

        searchResult.setParams({ siteId: selectedSite, candidateId: null, timeSheetId: null, weekEndDate: null });
        searchResult.setCallback(this, function (response) {

            var state = response.getState();

            if (cmp.isValid() && state == "SUCCESS") {
                srchList = response.getReturnValue();

                if (srchList.length > 0) {
                    $("#overlay").show();
                    cmp.set("v.TimeSheets", srchList);
                    cmp.set("v.currentList", srchList);

                    helper.renderPage(cmp);
                } else {
                    cmp.set("v.Spinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        'message': 'No Timesheet available for this search',
                        'Duration': '200'
                    });
                    toastEvent.fire();
                    $("#overlay").hide();
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_paginate').hide();
                    $('.dataTables_info').hide();
                    $('tbody').hide();
                    dataTable.clear();
                }

            }
        });
        $A.enqueueAction(searchResult);

    },

    addChild: function (cmp, evt, helper) {
        var toggleText = cmp.find(cmp.find('widget').get('v.value'));
        $A.util.removeClass(toggleText, "hide");
        $A.util.toggleClass(toggleText, "toggle");
    },

    hideShift_Approval: function (cmp, evt, helper) {
        var toggleText = cmp.find('Shift_Approval');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
    },

    hideContact: function (cmp, evt, helper) {
        var toggleText = cmp.find('My_Blue_Arrow_Contact');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
    },

    hideMyTemps: function (cmp, evt, helper) {
        var toggleText = cmp.find('My_Temps');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
    },

    hideBookedTemps: function (cmp, evt, helper) {
        var toggleText = cmp.find('Booked_Temps');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
    },

    hideInvoice: function (cmp, evt, helper) {
        var toggleText = cmp.find('Invoice_Details');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
    },

    hideTempHours: function (cmp, evt, helper) {
        var toggleText = cmp.find('Temp_Hours');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
    },

    ActiveVacancy: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/testtemps" });
        urlEvent.fire();
    },

    renderPage: function (component, event, helper) {
        //   helper.renderPage(component);
    },

    handleSearchEvent: function (cmp, event, helper) {
        helper.helperscriptload(cmp, event, helper);
        var srcList = event.getParam("SearchList");
        var msg = '';

        cmp.set("v.TimeSheets", srcList);

        cmp.set("v.maxPage", Math.floor((srcList.length + 5) / 6));

        var pageNumber = cmp.get("v.pageNumber");

        if (pageNumber != null) {
            var pageRecords = srcList.slice((pageNumber - 1) * 6, pageNumber * 6);
        }

        cmp.set("v.currentList", srcList);
        if (srcList.length == 0) {
            msg = 'No records Found!';
            var dataTable = $('#tableId').DataTable();
            $('.dataTables_paginate').hide();
            dataTable.clear();
            cmp.set("v.recordsNotFoundMsg", msg);
        }
        else {
            $("#overlay").show();
            var dataTable = $('#tableId').DataTable();
            $('.dataTables_empty').hide();
            dataTable.destroy();

            setTimeout(function () {
                $('#tableId').DataTable(
                    {
                        responsive: true,
                        aaSorting: [],
                    }

                );

                $("#overlay").hide();
            }, 3000);
        }

    },

    getTimeSheetLines: function (component, event, helper) {
        //   console.log('TimeSheetId:');
        component.set("v.isOpen", true);
        var idName = event.target.id;
        var idAndName = idName.split('|');
        //   console.log('idAndName:',idAndName);
        var timeSheetLines = component.get("c.fetchTimeSheetLines");
        timeSheetLines.setParams({ "timeSheetId": idAndName[0] });
        timeSheetLines.setCallback(this, function (result) {
            var lineRecords = result.getReturnValue();
            //      console.log('lineRecords:',lineRecords);
            component.set("v.timeSheetId", idAndName[1]);
            if (lineRecords.length > 0) {
                component.set("v.timeSheetLines", lineRecords);
                component.set("v.errMsg", '');
                //component.set("v.showError",false);
            } else {
                component.set("v.timeSheetLines", lineRecords);
                component.set("v.errMsg", 'No TimeSheet Lines found');
                //component.set("v.showError",true);
            }
        });
        $A.enqueueAction(timeSheetLines);
    },

    navigateBack: function (component, event, helper) {
        var address = '/client-approved-timesheets';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address,
        });
        urlEvent.fire();
    },

    closeModel: function (component, event, helper) {
        component.set("v.isOpen", false);
    },

    logout: function (component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL") + "secur/logout.jsp?retUrl=" + $A.get("$Label.c.Lightning_CommunityLogout_URL") + "CommunitiesLanding";
        window.location.replace(urlRedirect);
        return false;
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

    scriptsLoaded: function (cmp, evt, helper) {
        console.log('in ');
        helper.helperscriptload(cmp, evt, helper);
        console.log('in asscript');
    },

    downloadCsv: function (component, event, helper) {
        //console.log("in downloadCsv");
        var selectedSiteId = component.get("v.site");
        var action = component.get("c.getTimesheetsToDownload");
        action.setParams({ "siteId": selectedSiteId });
        action.setCallback(this, function (response) {
            //console.log("getting TS >> " + response.getState());
            if (response.getState() === "SUCCESS") {
                var stockData = response.getReturnValue();
                console.log("stockData Retrieved")
                if (stockData.length > 0) {
                    helper.showToast(component, event, "success", "Found " + stockData.length + " Timesheet records. Please hold tight while downloading!");
                    var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
                    if (csv == null) { return; }
                    if (navigator.msSaveBlob) { // IE 10+
                        console.log('navigator');
                        var blob = new Blob([csv], {
                            "type": "text/csv;charset=utf8;"
                        });
                        navigator.msSaveBlob(blob, 'ExportData.csv');
                    } else {
                        var hiddenElement = document.createElement('a');
                        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                        hiddenElement.target = '_self';
                        hiddenElement.download = 'ExportData.csv';
                        document.body.appendChild(hiddenElement);
                        hiddenElement.click();
                    }
                } else {
                    helper.showToast(component, event, "info", "No Record available for export");
                }
            } else {
                helper.showToast(component, event, "error", "Unable to retrieve Timesheets to download. Please contact your branch!");
            }
        });
        $A.enqueueAction(action);
    },

    handleThemeEvent : function(component, event, helper) {
        console.log("handling Theme Event");
        var selectedSiteId = event.getParam("selectedSiteId");
        component.set("v.site", selectedSiteId);
    }

})
({
    scriptsLoaded: function (cmp, evt, helper) {

    },
    clearAll: function (component, event, helper) {
        if (component.find("contact") != null || component.find("timesheetno").getElement().value != null || component.find("weekEndDate").getElement().value != null) {
            component.find("contact").set("v.value", 'Select Candidate Name');
            component.find("timesheetno").getElement().value = "";
            component.find("weekEndDate").getElement().value = "";


            var searchResult = component.get("c.getsearchResult");
            var srchList;
            var selectedSite = component.get("v.site");//component.find("SiteId").get("v.value");


            var selectedCandidate = component.find("contact").get("v.value");
            var selectedTimeSheet = component.find("timesheetno").getElement().value;
            var selectedWeekEndDate = component.find("weekEndDate").getElement().value;

            if (selectedCandidate == "Select Candidate Name") {
                selectedCandidate = null;
            }

            if (selectedTimeSheet == "") {
                selectedTimeSheet = null;
            }

            if (selectedWeekEndDate == "") {
                selectedWeekEndDate = null;
            }
            //   console.log('selectedSite:',selectedSite);
            //   console.log('selectedTimeSheet:',selectedTimeSheet);
            //   console.log('selectedCandidate:',selectedCandidate);
            //  console.log('selectedWeekEndDate:',selectedWeekEndDate);


            searchResult.setParams({ siteId: selectedSite, candidateId: selectedCandidate, timeSheetId: selectedTimeSheet, weekEndDate: selectedWeekEndDate });
            searchResult.setCallback(this, function (response) {
                //   console.log('in callback method:');
                var state = response.getState();
                //     console.log('state:',state);
                if (component.isValid() && state == "SUCCESS") {
                    //       console.log('callback reponse:',response.getReturnValue());
                    srchList = response.getReturnValue();
                    //       console.log('srchList45:',srchList);
                    var msg = '';

                    if (srchList.length == 0) {
                        //    msg = 'No records found';


                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "message": "No Timesheet available for this search"

                        });
                        toastEvent.fire();

                    }

                    var cmpEvent = component.getEvent("searchEvent");
                    cmpEvent.setParams({
                        "SearchList": srchList
                    });
                    cmpEvent.fire();
                }
            });
            $A.enqueueAction(searchResult);
        }

        /*
        var searchResult = component.get("c.getsearchResult");
        var srchList;
        var selectedSite = null;
        var selectedCandidate = null;
        var selectedTimeSheet = null;
        var selectedWeekEndDate = null;

        searchResult.setParams({siteId:selectedSite,candidateId : selectedCandidate,timeSheetId : selectedTimeSheet, weekEndDate : selectedWeekEndDate});
        searchResult.setCallback(this, function(response) {
            console.log('in callback method:');
            var state = response.getState();
            console.log('state:',state);
            if(component.isValid() && state == "SUCCESS"){
                console.log('callback reponse:',response.getReturnValue());
                srchList = response.getReturnValue();
                console.log('srchList:',srchList);
                var msg='';

                if(srchList.length == 0){
                    //    msg = 'No records found';


                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "No Approved Timesheets for this Site"

                    });
                    toastEvent.fire();

                }

                var cmpEvent = component.getEvent("searchEvent");
                cmpEvent.setParams({
                    "SearchList" : srchList});
                cmpEvent.fire();
            }
        });
        $A.enqueueAction(searchResult);
        */
    },
    itemsChange: function (component, event, helper) {
        var siteSelected = component.get('v.site');

        //   console.log('siteSelected:',siteSelected);
        if (siteSelected != null && siteSelected != '') {
            var siteContactMap = component.get('v.SiteContactMap');
            var contactArray = siteContactMap[siteSelected];
            //      console.log('contactArray:',contactArray);
            let unique_array = []
            var optionsContact = [];
            if (contactArray != undefined && contactArray.length != 0) {
                for (let i = 0; i < contactArray.length; i++) {
                    if (unique_array.indexOf(contactArray[i]) == -1) {
                        unique_array.push(contactArray[i])
                    }
                }
                //        console.log('unique_array127:',unique_array);
                for (var i = 0; i < contactArray.length; i++) {
                    optionsContact.push({
                        label: contactArray[i].Name,
                        value: contactArray[i].Id
                    });
                }
            } else {
                optionsContact = [];
            }
            //    console.log('optionsContact:',optionsContact);
            component.set("v.ContactList", optionsContact);
        } else {
            component.set("v.ContactList", component.get('v.OriginalContactList'));
        }

    },
    candidateView: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/candidate-view"
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    shiftsToBeApprovedDataView: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/shifts-to-be-approved-data-view"
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    gotoDashboard: function (component, event, helper) {
        event.preventDefault();
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        var urlRedirect = baseURL + '?site=' + component.get("v.site");
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/approved-timeSheets-new"
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
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
    doInit: function (component, event, helper) {
        var idParam = helper.getJsonFromUrl().site;
        var siteList = component.get("c.getsitesList");
        siteList.setCallback(this, function (response) {
            var state = response.getState();
            var optsSite = [];
            if (component.isValid() && state == "SUCCESS") {
                //     console.log('response:',response.getReturnValue());
                var SiteArray = response.getReturnValue();
                optsSite.push({
                    label: "Select Site",
                    value: ""
                });
                //     console.log('SiteArray:',SiteArray);
                for (var i = 0; i < SiteArray.length; i++) {
                    optsSite.push({
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                    });
                }
                component.set("v.sitelist", optsSite);
                //      console.log('optsSite:'+optsSite[1].value);
                //component.find("SiteList").set("v.options", optsSite);
            }
        });

        var contactList = component.get("c.getsiteContactMap");
        contactList.setParams({ sitesId: idParam });
        contactList.setCallback(this, function (response) {
            var state = response.getState();
            var optsCont = [];
            if (component.isValid() && state == "SUCCESS") {
                var Contactlist = response.getReturnValue();

                for (var i = 0; i < Contactlist.length; i++) {
                    console.log('ContactlistI' + Contactlist[i].Name);
                    optsCont.push({

                        label: Contactlist[i].Name,
                        value: Contactlist[i].Id
                    });
                }
                console.log('optsCont:' + optsCont);
                component.set('v.ContactList', optsCont);
                component.set('v.OriginalContactList', optsCont);
                //    component.set('v.SiteContactMap',optsCont);
            }
        });

        var siteContactMap = component.get("c.getsiteconmap");
        siteContactMap.setParams({ sitesId: idParam });

        siteContactMap.setCallback(this, function (response) {
            var state = response.getState();
            //     console.log('State siteContactMap '+state);
            if (component.isValid() && state == "SUCCESS") {
                //        console.log(response.getReturnValue());
                var siteContactMap = response.getReturnValue();
                component.set('v.SiteContactMap', siteContactMap);

            }
        });

        var ContactTimeSheetMap = component.get("c.getContactTimeSheetMap");
        ContactTimeSheetMap.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS") {
                //       console.log(response.getReturnValue());
                var ContactTimeSheetMap = response.getReturnValue();
                component.set('v.ContactTimeSheetMap', ContactTimeSheetMap);
            }
        });


        var selectedSite = idParam;
        console.log('selectedSitechil ' + selectedSite);
        var timeSheets = component.get("c.getTimeSheets");
        timeSheets.setParams({ siteId: selectedSite });
        timeSheets.setCallback(this, function (response) {
            var state = response.getState();
            var optstimesheets = [];
            if (component.isValid() && state == "SUCCESS") {
                //     console.log('response:',response.getReturnValue());
                var timeSheetArray = response.getReturnValue();
                /* optstimesheets.push({
                    label: "Select TimeSheet",
                    value: ""
                });*/
                //     console.log('timeSheetArray:',timeSheetArray);
                for (var i = 0; i < timeSheetArray.length; i++) {
                    optstimesheets.push({
                        label: timeSheetArray[i].Name,
                        value: timeSheetArray[i].Id
                    });
                }
                //      console.log('optstimesheets:',optstimesheets);
                component.set("v.timehsheetList", optstimesheets);
                component.set("v.OriginalTimeSheetList", optstimesheets)
            }
        });

        $A.enqueueAction(siteList);
        $A.enqueueAction(contactList);
        $A.enqueueAction(siteContactMap);

        $A.enqueueAction(timeSheets);
        $A.enqueueAction(ContactTimeSheetMap);
    },
    nullify: function (component, event, helper) {
        var dp = component.find('weekEndDate');
        dp.set('v.value', '');
    },
    siteChanged: function (component, event, helper) {
        var siteSelected = helper.getJsonFromUrl().site;
        //     console.log('siteSelected:',siteSelected);
        if (siteSelected != null && siteSelected != '') {
            var siteContactMap = component.get('v.SiteContactMap');
            var contactArray = siteContactMap[siteSelected];
            //      console.log('contactArray:',contactArray);
            let unique_array = []
            var optionsContact = [];
            if (contactArray != undefined && contactArray.length != 0) {
                for (let i = 0; i < contactArray.length; i++) {
                    if (unique_array.indexOf(contactArray[i]) == -1) {
                        unique_array.push(contactArray[i])
                    }
                }
                //        console.log('unique_array:',unique_array);
                for (var i = 0; i < contactArray.length; i++) {
                    optionsContact.push({
                        label: contactArray[i].Name,
                        value: contactArray[i].Id
                    });
                }
            } else {
                optionsContact = [];
            }
            //        console.log('optionsContact:',optionsContact);
            component.set("v.ContactList", optionsContact);
        } else {
            component.set("v.ContactList", component.get('v.OriginalContactList'));
        }
    },

    candidateChanged: function (component, event, helper) {
        var candidateSelected = component.find("contact").get("v.value");
        //     console.log('candidateSelected:',candidateSelected);
        //     console.log('Inside IF.....');
        var ContactTimeSheetMap = component.get('v.ContactTimeSheetMap');
        var timeSheetArray = ContactTimeSheetMap[candidateSelected];
        //        console.log('timeSheetArray:',timeSheetArray);
        var optionsTimeSheet = [];
        /* optionsTimeSheet.push({
                label: "Select TimeSheet",
                value: ""
            });*/
        if (timeSheetArray != null) {
            for (var i = 0; i < timeSheetArray.length; i++) {
                optionsTimeSheet.push({
                    label: timeSheetArray[i].Name,
                    value: timeSheetArray[i].Id
                });
            }
        }
        //   console.log('optionsTimeSheet:',optionsTimeSheet);
        component.set("v.timehsheetList", optionsTimeSheet);
        /*else{
           var siteSelectedForTS = component.find("SiteId").get("v.value");
           console.log('siteSelectedForTS:',siteSelectedForTS);
             if(siteSelectedForTS != null && siteSelectedForTS != ''){
                 var siteContactMap = component.get('v.SiteContactMap');
                 console.log('siteContactMap in else:',siteContactMap);
                 var contactTimeSheetMap = component.get('v.ContactTimeSheetMap');
                 console.log('contactTimeSheetMap in else:',contactTimeSheetMap);
                 var contactArray = siteContactMap[siteSelectedForTS];
                 console.log('contactArray in else:',contactArray);
                 var timsSheetopts = [];
                 for(var i=0;i<contactArray.length;i++){
                     var SiteTimeSheetsArray = contactTimeSheetMap[contactArray[i].Id];
                     console.log('SiteTimeSheetsArray:',SiteTimeSheetsArray);
                     for(var j=0;j<SiteTimeSheetsArray.length;j++){
                         timsSheetopts.push({
                             label:SiteTimeSheetsArray[j].Name,
                             value:SiteTimeSheetsArray[j].Id
                         });
                     }
                 }
                 component.set("v.timehsheetList", timsSheetopts);
             }else{
                 component.set("v.timehsheetList",component.get('v.OriginalTimeSheetList'));
             }

         }*/
    },

    fireSearchEvent: function (component, event) {
        var searchResult = component.get("c.getsearchResult");
        var srchList;
        var selectedSite = component.get("v.site");//component.find("SiteId").get("v.value");


        var selectedCandidate = component.find("contact").get("v.value");
        var selectedTimeSheet = component.find("timesheetno").getElement().value;
        var selectedWeekEndDate = component.find("weekEndDate").getElement().value;

        if (selectedCandidate == "Select Candidate Name") {
            selectedCandidate = null;
        }

        if (selectedTimeSheet == "") {
            selectedTimeSheet = null;
        }

        if (selectedWeekEndDate == "") {
            selectedWeekEndDate = null;
        }
        //    console.log('selectedSite:',selectedSite);
        //     console.log('selectedTimeSheet:',selectedTimeSheet);
        //     console.log('selectedCandidate:',selectedCandidate);
        //     console.log('selectedWeekEndDate:',selectedWeekEndDate);


        searchResult.setParams({ siteId: selectedSite, candidateId: selectedCandidate, timeSheetId: selectedTimeSheet, weekEndDate: selectedWeekEndDate });
        searchResult.setCallback(this, function (response) {
            //       console.log('in callback method:');
            var state = response.getState();
            //       console.log('state:',state);
            if (component.isValid() && state == "SUCCESS") {
                //          console.log('callback reponse:',response.getReturnValue());
                srchList = response.getReturnValue();
                //         console.log('srchList:',srchList);
                var msg = '';

                if (srchList.length == 0) {
                    //    msg = 'No records found';


                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "No Timesheet available for this search"

                    });
                    toastEvent.fire();

                }

                var cmpEvent = component.getEvent("searchEvent");
                cmpEvent.setParams({
                    "SearchList": srchList
                });
                cmpEvent.fire();
            }
        });
        $A.enqueueAction(searchResult);
    },

    SiteSearch: function (component, event, helper) {
        helper.SitePredictiveSearch(component, event);
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
})
({
    handleOnClick: function (component, event, helper) {
        $A.util.toggleClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseLeave: function (component, event, helper) {
        $A.util.addClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseEnter: function (component, event, helper) {
        $A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    handleOnClick1: function (component, event, helper) {
        $A.util.toggleClass(component.find("divHelp1"), 'slds-hide');
    },
    handleMouseLeave1: function (component, event, helper) {
        $A.util.addClass(component.find("divHelp1"), 'slds-hide');
    },
    handleMouseEnter1: function (component, event, helper) {
        $A.util.removeClass(component.find("divHelp1"), 'slds-hide');
    },
    handleOnClick2: function (component, event, helper) {
        $A.util.toggleClass(component.find("divHelp2"), 'slds-hide');
    },
    handleMouseLeave2: function (component, event, helper) {
        $A.util.addClass(component.find("divHelp2"), 'slds-hide');
    },
    handleMouseEnter2: function (component, event, helper) {
        $A.util.removeClass(component.find("divHelp2"), 'slds-hide');
    },
    doInit: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
        console.log('datatable load');
        var result = component.get("v.shifts");

        var selectedSiteid = component.get("v.site");
        if (selectedSiteid == undefined) {
            var url = window.location.href.slice(window.location.href.indexOf('?') + 1);

            var selectedSiteid = url.split("site=")[1];
            /*var url_String = document.URL;
            var url = new URL(url_String);
            selectedSiteid = url.searchParams.get('site');*/

        }

        helper.checkpermissionForAction(component, event, helper, selectedSiteid);// JPC-1919
        console.log('here' + result);
        //   alert(component.get("v.ActionPermissionView"));
        component.set("v.Paginationshifts", result);
        if (result.length > 0) {
            $("#overlay").show();
            var checkBreakLength = [];
            /* for(var i=0; i< result.length; i++){
                 if(result[i].Break_Length__c =='00:00'){
                     checkBreakLength.push(i);
                 }
             }

             if(checkBreakLength.length == result.length){

                 var dataTable = $('#tableId').DataTable();
                 dataTable.destroy();
                 dataTable.clear();
                 setTimeout(function () {
                     $('#tableId').DataTable({
                         responsive: true,
                         aaSorting: [],
                         columnDefs: [{
                                 "targets": [6],
                                 "visible" : false
                             },

                         ]
                     });

                     $("#overlay").hide();
                 }, 500);
             }

             else if (component.get("v.Search") == true && (checkBreakLength.length !==result.length) ) {

                 $("#overlay").show();
                 var dataTable = $('#tableId').DataTable();
                 dataTable.destroy();
                 dataTable.clear();
                 setTimeout(function () {
                     $('#tableId').DataTable({
                         responsive: true,
                         aaSorting: [],
                         columnDefs: [{
                                 "orderable": false,
                                 "targets": [0, 4, 5, 8]
                             },

                         ]
                     });

                     $("#overlay").hide();
                 }, 500);


             } else {
                 // alert(2);

                 $("#overlay").show();
                 setTimeout(function () {
                     $('#tableId').DataTable({
                         responsive: true,
                         aaSorting: [],
                         columnDefs: [{
                                 "orderable": false,
                                 "targets": [0, 4, 5, 8]
                             },

                         ]
                     });

                     $("#overlay").hide();
                 }, 500);

             }*/
            if (component.get("v.Search") == true) {

                $("#overlay").show();
                var dataTable = $('#tableId').DataTable();
                dataTable.destroy();
                dataTable.clear();
                setTimeout(function () {
                    $('#tableId').DataTable({
                        responsive: true,
                        aaSorting: [],
                        columnDefs: [{
                            "orderable": false,
                            "targets": [0, 4, 5, 8]
                        },

                        ]
                    });

                    $("#overlay").hide();
                }, 500);


            } else {
                console.log('result in else 143');

                $("#overlay").show();
                setTimeout(function () {
                    $('#tableId').DataTable({
                        responsive: true,
                        bPaginate: true,
                        paging: true,
                        info: true,
                        aaSorting: [],
                        columnDefs: [{
                            "orderable": false,
                            "targets": [0, 4, 5, 8]
                        },

                        ]
                    });

                    $("#overlay").hide();
                }, 500);

            }

        } else {


            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                'message': 'No shifts available for this search',

                'Duration': '1000'
            });
            toastEvent.fire();
            console.log('no data ');
            var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
            console.log('isMobile ' + isMobile);
            $("#overlay").show();
            var dataTable = $('#tableId').DataTable();
            dataTable.destroy();
            dataTable.clear();
            if (isMobile) {
                setTimeout(function () {
                    $('#tableId').DataTable({

                        bPaginate: false,
                        paging: false,
                        info: false,
                        columnDefs: [{
                            "visible": false,
                            "targets": [0, 3, 4, 5, 6, 7, 8]
                        },

                        ]
                    });

                    $("#overlay").hide();
                }, 1000);

            }
            else {
                setTimeout(function () {
                    $('#tableId').DataTable({
                        responsive: true,
                        bPaginate: false,
                        paging: false,
                        info: false,
                        aaSorting: [],
                        columnDefs: [{
                            "orderable": false,
                            "targets": [0, 4, 5, 8]
                        },

                        ]
                    });

                    $("#overlay").hide();
                }, 1000);
            }


        }


        //console.log('===result=='+result[0].Break_Length__c);


        // component.set("v.maxPage", Math.floor((result.length+9)/10));
        // helper.renderPage(component);
    },

    /*page refresh after data save*/
    scriptsLoadedfirst: function (component, event, helper) {
        // alert('@@@ help');
        console.log('timeout ');
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if (isMobile) {
            setTimeout(function () {

                $('.searchDetail_table').on('click', '.accept', function () {
                    var Id = $(this).attr('id');
                    console.log('&& sc ' + Id);
                    var shifttIds = [];
                    shifttIds.push(Id);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        'message': 'Your shift approval request has been received, the below screen will update shortly',
                        'mode': 'pester',
                        'Duration': '10',
                        'type': 'Success'
                    });
                    toastEvent.fire();
                    console.log('@@@ in click 2nd ');

                    helper.getShiftsFromIDs(component, event, shifttIds);
                    helper.approveshifts(component, helper);

                });
                $('.searchDetail_table').on('click', '.decline', function () {

                    var idToBeCancelled = $(this).attr('id');
                    console.log('idreject ' + idToBeCancelled);
                    var shiftList = component.get("v.shifts");
                    for (var i = 0; i < shiftList.length; i++) {
                        if (shiftList[i].Id == idToBeCancelled) {

                            component.set("v.cancelledshift", shiftList[i]);
                            //  component.set("v.isOpenCancel", true);
                        }
                    }

                });




            }, 1000);
        }
    },

    approve: function (component, event, helper) {
        console.log('approve called');
        component.set("v.approvestatus", false);
        component.set("v.timingblank", false);
        var target = event.target.id;
        //alert(target);
        var shifttIds = [];
        shifttIds.push(target);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({

            'message': 'Your shift approval request has been received, the below screen will update shortly',
            'mode': 'pester',
            'Duration': '50',
            'type': 'Success'
        });
        toastEvent.fire();
        component.set("v.approveAll", false);
        helper.getShiftsFromIDs(component, event, shifttIds);
        helper.approveshifts(component, helper);

    },

    reject: function (component, event, helper) {
        // alert('\nCandidate--'+component.get("v.contact"));
        // var target = event.target.id;
        var idToBeCancelled = event.target.id;

        var shiftList = component.get("v.shifts");
        for (var i = 0; i < shiftList.length; i++) {
            if (shiftList[i].Id == idToBeCancelled) {

                component.set("v.cancelledshift", shiftList[i]);
                //  component.set("v.isOpenCancel", true);
            }
        }
        //$A.get('e.force:refreshView').fire();
    },
    closeModelCancel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.isOpenCancel", false);
        //  helper.getShifts(component, event, helper);
    },
    submitReject: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.isOpenCancel", false);
        var action = component.get("c.SendRejectionToOwner");
        var comments = component.find("Query").get("v.value");
        var shift = component.get("v.cancelledshift")[0];
        var id = shift.Id;
        var combinedComment = 'Shift Number- ' + shift.Name + ' Site-' + shift.sirenum__Site__r.Name + ' Job Role-' + shift.sirenum__Team__r.Name;
        action.setParams({ 'shiftID': id, 'comments': comments, 'combinedComment': combinedComment });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //alert('success');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "Rejection complete",
                    "type": "Success"
                });
                toastEvent.fire();
                component.set("v.isOpenQuery", false);
            } else {

                component.set("v.isOpenQuery", false);
            }
        });
        $A.enqueueAction(action);

        var shifttIds = [];
        shifttIds.push(id);
        helper.getShifts(component, event, helper);
    },

    UpdateActualTimes: function (component, event, helper) {
        component.set("v.HourStatus", false);
        var shifts = component.get("v.shifts");
        var recordId = event.getParam("recordID");
        var start = event.getParam("start");
        var end = event.getParam("end");
        component.set("v.starthour", start);
        component.set("v.endhour", end);
        console.log('@@ ' + start + end);
        if (start != '' && end != '') {
            component.set("v.HourStatus", true);
        }
        if (start == '' || end == '') {
            component.set("v.isError", true);
        } else {
            component.set("v.isError", false);
            component.set("v.shifts", shifts);
        }
        console.log('testactual ' + component.get("v.HourStatus"));
    },


    ShiftSearchEvent: function (component, event, helper) {
        // alert('Contact'+event.getParam("contact")+'\nsite'+event.getParam("site"));
        component.set("v.site", event.getParam("site"));
        component.set("v.role", event.getParam("role"));
        component.set("v.contact", event.getParam("contact"));
        component.set("v.DateRange", event.getParam("DateRange"));

    },
    checkboxSelect: function (cmp, event, helper) {

    },
    Selectclicked: function (component, event, helper) {

        var checkboxes = component.find("select");

        var selectedRec = event.getSource();
        //     console.log('selectedRec '+selectedRec);
        var check = selectedRec.get("v.value");
        //  console.log('check '+check);
        var checkarray = [];

        var tr = component.find('tr');
        //     console.log('tr '+tr);
        for (var i = 0; i < checkboxes.length; i++) {

            if (checkboxes[i] == selectedRec) {

                if (check == true) {

                    //     console.log('tr[i] '+tr[i]);
                    checkarray.push(selectedRec);

                    //  $A.util.addClass(tr[i],"Red");
                }
                else {

                    //	$A.util.removeClass(tr[i],"Red");

                }

            }
        }

    },

    SelectclickedAll: function (component, event, helper) {
        var selectedRec = event.getSource();
        var check = selectedRec.get("v.checked");
        var n = selectedRec.get("v.name");

        var appl = [];
        appl = component.get("v.AllAppList");
        if (appl.includes(n) == true && check == false) {
            // alert(1);
            for (var i = 0; i < appl.length; i++) {
                if (appl[i] == n) {
                    appl.splice(i, 1);
                    break;
                }
            }
        }
        else if (appl.includes(n) == false && check == true) {
            // alert(2);
            appl.push(n);

        }

        // var checkboxes = component.find("select");
        component.set("v.AllAppList", appl);
        // alert('iii'+appl.length);
    },
    ApproveAll: function (component, event, helper) {
        console.log('approveAll was called')
        var checkboxes = component.find("select");
        const chkbox = (checkboxes.length == null) ? [checkboxes] : checkboxes
        console.log('chkbox: ' + chkbox.length);
        var shiftIDS = component.get("v.AllAppList");
        console.log('shiftIDSAll: ' + shiftIDS);
        //  console.log('len '+checkboxes.length);
        component.set("v.AllAppList", []);
        for (var i = 0; i < chkbox.length; i++) {

            if (chkbox[i].get("v.value")) {
                //   console.log('check');
                shiftIDS.push(chkbox[i].get("v.name"));

            }
        }
        console.log('shiftIDS.length: ' + shiftIDS.length);
        if (shiftIDS.length > 0) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                'message': 'Your shift approval request has been received, the below screen will update shortly',
                'mode': 'pester',
                'Duration': '5000',
                'type': 'Success'
            });
            toastEvent.fire();
        }
        console.log('shiftIDS ALL approve ' + shiftIDS);
        component.set("v.approveAll", true);
        component.set("v.timingblank", false);
        helper.getShiftsFromIDs(component, event, shiftIDS);
        helper.approveshifts(component, helper);



    },
    save: function (component, event, helper) {
        console.log('this : ');
        console.log('changesMade: ' + component.get('v.checkforchange'));
        component.set("v.approvestatus", false);
        var target = event.target.id;
        console.log('target : ' + target);
        var shifttIds = [];
        shifttIds.push(target);
        if (component.get('v.checkforchange') == false) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                'message': 'No changes have been made to this shift, please update before selecting save',
                'mode': 'pester',
                'Duration': '5000'

            });
            toastEvent.fire();
        }
        else {
            console.log('shifttIds : ' + shifttIds);
            helper.getShiftsFromIDsforSave(component, event, shifttIds);
            //  helper.saveShifts(component,helper);
            if (component.get('v.startendBlank') == false) {
                helper.saveShifts(component, helper);
            }
        }


    },
    saveAll: function (component, event, helper) {
        var checkboxes = component.find("select");
        //console.log('checkboxes: '+checkboxes);
        var shiftIDS = component.get("v.AllAppList");
        console.log('shiftIDS: ' + shiftIDS);
        //console.log('len '+checkboxes.length);
        component.set("v.AllAppList", []);
        for (var i = 0; i < checkboxes.length; i++) {

            if (checkboxes[i].get("v.value")) {
                //   console.log('check');
                shiftIDS.push(checkboxes[i].get("v.name"));
                //console.log('shiftIDS1: '+shiftIDS);
            }
        }
        //console.log('shiftIDSssssssssss: '+shiftIDS);
        var xyz = shiftIDS;
        if (component.get('v.checkforchange') == true) {

            helper.getShiftsFromIDsforSave(component, event, shiftIDS);
            if (component.get('v.startendBlank') == false) {
                helper.saveShifts(component, helper);
            }

        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                'message': 'No changes have been made to this shift, please update before selecting save',
                'mode': 'pester',
                'Duration': '5000'

            });
            toastEvent.fire();
        }

    },
    handleIfChangesMade: function (component, event, helper) {
        console.log('this was called ');
        //console.log('checkforchange 472: '+component.get('checkforchange'));
        var isChanged = event.getParam("isChanged");
        console.log('isChanged 474: ' + isChanged);
        if (isChanged == undefined) {
            console.log('in if ');
            component.set('v.checkforchange', false);
            var thisvar = component.get('v.checkforchange');
            console.log('checkforchange: ' + thisvar);
        }
        else {
            console.log('in else ');
            component.set('v.checkforchange', isChanged);
        }


    }

})
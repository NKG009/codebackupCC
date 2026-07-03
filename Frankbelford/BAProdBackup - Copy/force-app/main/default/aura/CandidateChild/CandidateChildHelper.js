({



    next: function(component, event, sObjectList, end, start, pageSize) {
        var Paginationlist = [];
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (sObjectList.length > i) {
                Paginationlist.push(sObjectList[i]);
            }
            counter++;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', Paginationlist);
    },
    // navigate to previous pagination record set   
    previous: function(component, event, sObjectList, end, start, pageSize) {
        var Paginationlist = [];
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                Paginationlist.push(sObjectList[i]);
                counter++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', Paginationlist);
    },


    getShifts: function(component) {

    },

    approveshifts: function(component, helper) {
        var getCmpName = component.getName();
        console.log('getCmpName: '+getCmpName);
        var shiftActualTime = component.get("v.shiftsToBeApproved");
        console.log('shiftActualTime: '+shiftActualTime);
        console.log(shiftActualTime[0].Starttime__c+'==startTimeVal98888==' + shiftActualTime[0].sirenum__Actual_Start_Time__c);
        console.log(shiftActualTime[0].endtime__c+'==startTimeVal98888==' + shiftActualTime[0].sirenum__Actual_End_Time__c);
        var check = component.get("v.isError");
        var checkStartShiftactualTime = false;
        var checkEndShiftactualTime = false;
      //  console.log('check ' + check);

        var checkStartHour = component.get("v.starthour");
        console.log('checkStartHour: '+checkStartHour);
        var checkEndHour = component.get("v.endhour");
        console.log('checkEndHour: '+checkEndHour);
        if(shiftActualTime[0].sirenum__Actual_Start_Time__c == undefined && checkStartHour == undefined){
            checkStartShiftactualTime = true;
        }
        if(shiftActualTime[0].sirenum__Actual_End_Time__c == undefined && checkEndHour == undefined){
            checkEndShiftactualTime = true;
        }
        
        if (component.get("v.shiftsToBeApproved").length < 1) {
            //alert('IN IF approve');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                "message": "Please select atleast one shift to approve"
            });
            toastEvent.fire();
        } else if (check == true && (checkStartShiftactualTime == true || checkEndShiftactualTime == true)) {
          console.log('IN IF 1');
            console.log('check: '+check);
            console.log('checkStartShiftactualTime: '+checkStartShiftactualTime);
            console.log('checkEndShiftactualTime: '+checkEndShiftactualTime);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": "Please ensure you have entered a start and end time for the shifts below"
            });
            toastEvent.fire();
        } else {

            var action = component.get("c.getshift");
            action.setParams({
                "JSONSHIFT": JSON.stringify(component.get("v.shiftsToBeApproved"))
            });

            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                //      console.log(result+'result');
                var state = response.getState();
                if (result == "Success") {

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                       "message": "Shift Approved",
                                'mode':'pester',
                                'Duration': '50',
                                'type':'Success'
                                });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.starthour",null);
                    component.set("v.endhour",null);
                    helper.GetAllShift(component, event, helper);
                    

                } else {
                    //        console.log('IN ERROR '); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "There are some issues with the shift, please contact consultant",
                        "mode": "pester",
                        "Duration": "5000"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.starthour",null);
                    component.set("v.endhour",null);
                }

            });
            $A.enqueueAction(action);

            //this.getShifts(component);


        }
    },

    getShiftsFromIDs: function(component, shiftIDs) {
        var shiftToBeApproved = [];
        for (var k = 1; k < shiftIDs.length; k++) {
            var arr = shiftIDs[k].split('-');
            var candidate = component.get("v.PaginationList");
            console.log('candidate from: '+JSON.stringify(candidate));
            var allShifts;

            for (var j = 0; j < candidate.length; j++) {
				if (candidate[j].CandidateId == arr[1]) {
                    allShifts = candidate[j].shiftInfo;
                    break;
                }
            }

            if (allShifts != null) {
                for (var i = 0; i < allShifts.length; i++) {
               
                    
                    
                    if (arr[0] == allShifts[i].Id) {
                        if (component.get("v.HourStatus") == true) {
                            allShifts[i].Starttime__c = component.get("v.starthour");
                            allShifts[i].EndTime__c = component.get("v.endhour");
                            component.set("v.HourStatus", false);

                        } else {
                            allShifts[i].Starttime__c = allShifts[i].Starttime__c;
                            allShifts[i].EndTime__c = allShifts[i].EndTime__c;

                        }
                        shiftToBeApproved.push(allShifts[i]);
                    }
                }
           
            }
        }
        component.set("v.shiftsToBeApproved", shiftToBeApproved);

    },
    
   getShiftsCalledFromApploveAllCandidate: function(component, target) {
        var shiftToBeApproved = [];
        
            var candidate = component.get("v.PaginationList");
       console.log('candidate list: '+JSON.stringify(candidate));
            var allShifts;
           
            for (var j = 0; j < candidate.length; j++) {
                if (candidate[j].CandidateId == target) {
                    allShifts = candidate[j].shiftInfo;
                    break;
                }
            }
            if (allShifts != null) {
                for (var i = 0; i < allShifts.length; i++) {
                    if (allShifts[i].Id!=null) {
                      if (component.get("v.HourStatus") == true) {
                        var start = $("#inputTimemob").attr("value");
                        var end = $("#inputTime1mob").attr("value");
                        console.log('start + end ' + start + end);
                        console.log('IN IF TIME ' + allShifts[i].Starttime__c);
                        if (start == null || start == '' || start == undefined) {
                            console.log('IN IF start@ TIME ');
                            console.log('component.get("v.starthour"):  '+component.get("v.starthour"));
                            console.log('component.get("v.endhour"): '+component.get("v.endhour"));
                            allShifts[i].Starttime__c = component.get("v.starthour");
                            allShifts[i].EndTime__c = component.get("v.endhour");

                        } else {
                            console.log('IN else start# TIME ');
                            allShifts[i].Starttime__c = start;
                            allShifts[i].EndTime__c = end;
                        }
                        component.set("v.HourStatus", false);

                        console.log('HourStatus in IF' + component.get("v.HourStatus"));
                    } else {
                        
                        var start = $("#inputTimemob").attr("value");
                       
                        var end = $("#inputTime1mob").attr("value");
                        console.log('IN ELSE TIME ');
                        console.log('HourStatus in ELSE' + component.get("v.HourStatus"));

                        if (typeof start != undefined && start != null && start != '' ) {
                            
                            console.log('IN IF start TIME ');
                            allShifts[i].Starttime__c = start;
                            allShifts[i].EndTime__c = end;
                        } else {
                            
                            console.log('IN else start TIME ');
                            allShifts[i].Starttime__c = allShifts[i].Starttime__c;
                            allShifts[i].EndTime__c = allShifts[i].EndTime__c;
                        }
                    }


                    console.log("matchediD" + allShifts[i].Id);
                    shiftToBeApproved.push(allShifts[i]);
                    }
                }
            }
       //console.log('shiftToBeApproved: '+JSON.stringify(shiftToBeApproved));
	   component.set("v.shiftsToBeApproved", shiftToBeApproved);
console.log('v.shiftsToBeApproved: '+JSON.stringify(component.get('v.shiftsToBeApproved')));
    },
    
   approveAllCandidateshifts: function(component, helper, page) {

        var shiftActualTime = component.get("v.shiftsToBeApproved");
        console.log('==startTimeVal98888==' + shiftActualTime[0].sirenum__Actual_Start_Time__c +shiftActualTime[1].sirenum__Actual_Start_Time__c);
        var check = component.get("v.isError");
        var checkStartShiftactualTime = false;
        var checkEndShiftactualTime = false;
        console.log('check253 ' + check);

        for (var i = 0; i < shiftActualTime.length; i++) {
        /*    if ( shiftActualTime[i].sirenum__Actual_Start_Time__c = true){
                shiftActualTime[i].sirenum__Actual_Start_Time__c ='';
            }
            if(shiftActualTime[i].sirenum__Actual_End_Time__c = true){
                shiftActualTime[i].sirenum__Actual_End_Time__c = '';
            }*/
            if (  shiftActualTime[i].sirenum__Actual_Start_Time__c == null ||
                shiftActualTime[i].sirenum__Actual_Start_Time__c == undefined || shiftActualTime[i].sirenum__Actual_Start_Time__c == '') {
                checkStartShiftactualTime = true;
            }
            if ( shiftActualTime[i].sirenum__Actual_End_Time__c == null ||
                shiftActualTime[i].sirenum__Actual_End_Time__c == undefined || shiftActualTime[i].sirenum__Actual_End_Time__c == '' ) {
                checkEndShiftactualTime = true;
            }
        }

        if (component.get("v.shiftsToBeApproved").length < 1) {
            console.log('IN IF approve');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                "message": "Please select atleast one shift to approve"
            });
            toastEvent.fire();
        } else if (check == true && (checkStartShiftactualTime == true || checkEndShiftactualTime == true)) {
            console.log('IN IF ');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
			      "message": "Please ensure you have entered a start and end time for the shifts below",          
                 'mode':'pester',
              	'Duration': '50'
            });
            toastEvent.fire();
        } else {

            console.log('in ELSE');

            console.log('component.get("v.shiftsToBeApproved") ' + component.get("v.shiftsToBeApproved"));
            var action = component.get("c.getshift");
            action.setParams({
                "JSONSHIFT": JSON.stringify(component.get("v.shiftsToBeApproved"))
            });

            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                //      console.log(result+'result');
                var state = response.getState();

                if (result == "Success") {



                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "Your shift approval request has been received, the below screen will update shortly",
                        'mode': 'pester',
                        'Duration': '5000',
                        'type': 'Success'
                    });
                    toastEvent.fire();
                    //alert('comp');
                   helper.GetAllShift(component, event, helper);

                } else if (result == "Error") {
                    //        console.log('IN ERROR '); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "There are some issues with the shift, please contact consultant",
                        "mode": "pester",
                        "Duration": "5000"

                    });
                    toastEvent.fire();
                } else if (state === "INCOMPLETE") {
                    console.log('incomplete');
                }
            });
            $A.enqueueAction(action);
            console.log('approvestatus ' + component.get("v.approvestatus"));
            helper.getShifts(component, event, helper);

        }
    },

    GetAllShift: function(component, event, helper) {
        var siteid = component.get("v.site");
        console.log('site ' + siteid);
        var action = component.get("c.getAllShiftsForCandidate");
        // alert('wgeugs');
        action.setParams({
            "contact": component.get("v.contact"),
            "site": siteid
        });

        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.ShiftList", result);


            var oRes = component.get("v.ShiftList");
            if (oRes == null) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "No Record Available"
                });
                toastEvent.fire();
                component.set("v.maxPage", Math.floor((result.length + 9) / 10));
                component.set("v.Pagination", false);
                // helper.renderPage(component);
            } else {

                component.set("v.totalPages", Math.ceil(result.length / component.get("v.pageSize")));
                component.set("v.currentPageNumber", 1);

                component.set("v.Pagination", true);
                if (component.get("v.totalPages") > 1) {
                    component.set("v.OnePage", true);
                } else {
                    component.set("v.OnePage", false);
                }


                helper.buildData(component, helper);

                /*  if(oRes.length > 0)
                        {
                           var pageSize = component.get("v.pageSize");
                           var totalRecordsList = oRes;
                           var totalLength = totalRecordsList.length ;
                           component.set("v.totalRecordsCount", totalLength);
                           component.set("v.startPage",0);
                           component.set("v.endPage",pageSize-1);
                                
                           var PaginationLst = [];
                           for(var i=0; i < pageSize; i++)
                           {
                            if(component.get("v.ShiftList").length > i)
                            {
                              PaginationLst.push(oRes[i]);    
                            } 
                           }
                           component.set('v.PaginationList', PaginationLst);
                           component.set("v.selectedCount" , 0);
                           component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));    
                         }
                         else
                         {
                           component.set("v.bNoRecordsFound" , true);
                         }*/
                component.set("v.maxPage", Math.floor((result.length + 9) / 10));
                // helper.renderPage(component);
            }


        });
        $A.enqueueAction(action);
    },


    renderPage: function(component) {

        var records = component.get("v.ShiftList"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 10, pageNumber * 10);
        $("#overlay").show();
        component.set("v.PaginationList", pageRecords);
        setTimeout(function() {
            $('.tableId').DataTable();
            responsive: true
            $("#overlay").hide();
        }, 2000);
    },




    buildData: function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.ShiftList");
        var x = (pageNumber - 1) * pageSize;
        $("#overlay").show();
        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            if (allData[x]) {
              //  console.log('allData[x] '+allData[x].id);
                data.push(allData[x]);
            }
        }
  console.log('###lendata '+data.length);
      
        var selectedSiteid = component.get("v.site");
        if (selectedSiteid == undefined) {
            var url_String = document.URL;
            var url = new URL(url_String);
            selectedSiteid = url.searchParams.get('site');
        }
        //var result = component.get("v.ShiftList");
        helper.checkpermissionForAction(component, event, helper, selectedSiteid); 
        component.set("v.PaginationList", data);
        
        var candidate = component.get("v.ShiftList");
            var allShifts;
           var testcheck = false;
            for (var j = 0; j < candidate.length; j++) {
                console.log('###1'+candidate[j].shiftInfo);
                    allShifts = candidate[j].shiftInfo;
               // testcheck = allShifts[j].Break_Length__c;
              // console.log('###brkou '+allShifts[j].Break_Length__c);
               for(var i = 0; i < allShifts.length; i++)
               {
                  console.log('###brkou '+allShifts[i].Break_Length__c + allShifts[i].Id); 
                   if(allShifts[i].Break_Length__c != '00:00')
                   {
                       testcheck = true;
                   }
               }
                        
            }


     if(testcheck == false){
           
             setTimeout(function() {
            $('.tableId').DataTable({
                		pageLength: 1000,
						responsive: true,
						aaSorting: [],
						columnDefs: [{
								"targets": [3],
                                "visible" : true
							},

						]
					});
            $("#overlay").hide();
        }, 2000);
                    
            }
     else{ 
        setTimeout(function() {
            $('.tableId').DataTable();
            responsive: true
            $("#overlay").hide();
        }, 2000);
                                     }
        helper.generatePageList(component, pageNumber);
    },

    /*
     * this function generate page list
     * */
    generatePageList: function(component, pageNumber) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        console.log(totalPages);
        if (totalPages > 1) {
            if (totalPages <= 10) {
                var counter = 1;
                for (; counter <= (totalPages); counter++) {
                    console.log('+counter ' + counter);
                    pageList.push(counter);
                }
            } else {
                if (pageNumber < 5) {
                    pageList.push(1, 2, 3, 4, 5);
                } else {
                    if (pageNumber > (totalPages - 5)) {
                        pageList.push(totalPages - 5, totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1);
                    } else {
                        pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
                    }
                }
            }
        }
        //console.log(pageList.length);
        component.set("v.pageList", pageList);
    },

    checkpermissionForAction: function(component, event, helper, selectedSiteid) {
        console.log('this was called');
        var action = component.get("c.checkPermissionToViewAction");
        action.setParams({
            "siteId": selectedSiteid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respResult = response.getReturnValue();

                if (respResult[0].IP_PortalType__c.includes("Hours Approver")) {
                    //console.log('not hide');
                    //   $('th[id="headeraction"]').attr("class","hideclass");
                    $('td[id="Consultant"]').attr("class", "hideclass");
                } 
                else if(respResult[0].IP_PortalType__c == 'Consultant'){
                    $('td[id="lastcol"]').attr("class", "hideclass");
                    component.set('v.isConsultant',true);
                    
                }
                else {
                  //  console.log(' hide');
                    $('th[id="headeraction"]').attr("class", "hideclass");
                    $('td[id="lastcol"]').attr("class", "hideclass");
                    $('td[id="Consultant"]').attr("class", "hideclass");
                    $('th[id="headeraction1"]').attr("class", "hideclass");
                    $('td[id="lastcol1"]').attr("class", "hideclass");
                }
            }
        });

        $A.enqueueAction(action);
    },
saveShifts: function(component, helper) {
        var shiftActualTime = component.get("v.shiftsToBeApproved");
      //  console.log(shiftActualTime[0].Starttime__c+'==startTimeVal98888==' + shiftActualTime[0].sirenum__Actual_Start_Time__c);
        var check = component.get("v.isError");
        var checkStartShiftactualTime = false;
        var checkEndShiftactualTime = false;
      //  console.log('check ' + check);

        var checkStartHour = component.get("v.starthour");
        
        var checkEndHour = component.get("v.endhour");
        if(checkStartHour =='' || checkStartHour == undefined || checkStartHour == null){
            checkStartShiftactualTime = true;
        }
        if(checkEndHour =='' || checkEndHour == undefined || checkEndHour == null){
            checkEndShiftactualTime = true;
        }
        

        if (component.get("v.shiftsToBeApproved").length < 1) {
            //alert('IN IF approve');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({

                "message": "Please select atleast one shift to approve"
            });
            toastEvent.fire();
        } else if ( checkStartShiftactualTime == true || checkEndShiftactualTime == true) {
          //console.log('IN IF ');
            //console.log('check: '+check);
            //console.log('checkStartShiftactualTime: '+checkStartShiftactualTime);
            //console.log('checkEndShiftactualTime: '+checkEndShiftactualTime);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": "Please ensure you have entered a start and end time for the shifts below"
            });
            toastEvent.fire();
        } else {

            var action = component.get("c.CallSaveShiftDB");
            action.setParams({
                "JSONSHIFT": JSON.stringify(component.get("v.shiftsToBeApproved"))
            });

            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                //      console.log(result+'result');
                var state = response.getState();
                if (result == "Success") {

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "Shift saved",
                        'mode': 'pester',
                        'Duration': '5000',
                        'type': 'Success'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.starthour",null);
                    component.set("v.endhour",null);
                    helper.GetAllShift(component, event, helper);
                    

                } else {
                    //        console.log('IN ERROR '); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "There are some issues with the shift, please contact consultant",
                        "mode": "pester",
                        "Duration": "5000"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.starthour",null);
                    component.set("v.endhour",null);
                }

            });
            $A.enqueueAction(action);

            //this.getShifts(component);


        }
    },
        saveAllShiftsForAcandidate: function(component, helper) {
component.set('v.startendBlank',false);
        var shiftActualTime = component.get("v.shiftsToBeApproved");

        if (component.get("v.shiftsToBeApproved").length < 1) {
            console.log('IN IF approve');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                

                "message": "Please select atleast one shift to approve"
            });
            toastEvent.fire();
        } 
            else {

            console.log('in ELSE');

            console.log('component.get("v.shiftsToBeApproved") ' + component.get("v.shiftsToBeApproved"));
            var action = component.get("c.CallSaveShiftDB");
            action.setParams({
                "JSONSHIFT": JSON.stringify(component.get("v.shiftsToBeApproved"))
            });

            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                //      console.log(result+'result');
                var state = response.getState();

                if (result == "Success") {



                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "Shift saved",
                        'mode': 'pester',
                        'Duration': '5000',
                        'type': 'Success'
                    });
                    toastEvent.fire();
                    component.set('v.checkforchange',false);
                   helper.GetAllShift(component, event, helper);

                } else if (result == "Error") {
                    //        console.log('IN ERROR '); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "There are some issues with the shift, please contact consultant",
                        "mode": "pester",
                        "Duration": "5000"

                    });
                    toastEvent.fire();
                } else if (state === "INCOMPLETE") {
                    console.log('incomplete');
                }
            });
            $A.enqueueAction(action);
            console.log('approvestatus ' + component.get("v.approvestatus"));
            helper.getShifts(component, event, helper);

       }
    },
        getAllShiftsForACandidate: function(component, target) {
            var shiftToBeApproved = [];
            
            var candidate = component.get("v.PaginationList");
            //console.log('candidate list: '+JSON.stringify(candidate));
            var allShifts;
            
            for (var j = 0; j < candidate.length; j++) {
                if (candidate[j].CandidateId == target) {
                    allShifts = candidate[j].shiftInfo;
                    break;
                }
            }
            console.log("752");
            if (allShifts != null) {
                for (var i = 0; i < allShifts.length; i++) {
                    if (allShifts[i].Id!=null) {
                        var shiftId=allShifts[i].Id;
                        console.log("actualStart"+shiftId);
                        console.log("counter"+i);
                        var startTime = document.getElementById("actualStart"+shiftId).innerText; 
                        console.log("startTime "+startTime);
                        var endTime = document.getElementById("actualEnd"+shiftId).innerText; 
                        console.log("endTime "+endTime);
                        
                        if(startTime == '' || endTime == ''){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                
                                "message": "Please ensure you have entered a start and end time for the shifts below"
                            });
                            toastEvent.fire();
                            component.set('v.startendBlank',true);
                            break;
                        }
                        else{
                            allShifts[i].Starttime__c = startTime;
                            allShifts[i].EndTime__c = endTime;
                            component.set('v.startendBlank',false);
                            shiftToBeApproved.push(allShifts[i]);
                        }
                        
                    }
                }
                
                
            }
            //console.log('shiftToBeApproved: '+JSON.stringify(shiftToBeApproved));
            component.set("v.shiftsToBeApproved", shiftToBeApproved);
            //console.log('v.shiftsToBeApproved: '+JSON.stringify(component.get('v.shiftsToBeApproved')));
        },



})
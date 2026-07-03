({
    scriptsLoaded: function (component, event, helper) {
        console.log('in script');
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if (isMobile) {
            $(document).ready(function () {
                console.log("ready!");
                helper.helperscriptload(component, event, helper);
            });
        }

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

    doInit: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
        if (window.location.href.indexOf("shiftdateview") > -1) {
            component.set("v.HideChargabelValue", false);
        } else {
            component.set("v.HideChargabelValue", true);
        }

        var record = component.get("v.record");
        component.set("v.EndBreaks", record.Break_Length__c);

        var scheduleStart = record.sirenum__Scheduled_Start_Time__c;
        var scheduleEnd = record.sirenum__Scheduled_End_Time__c;
        if (record.sirenum__Actual_Start_Time__c != null) {
            component.set("v.starthour", record.Starttime__c);
            component.set("v.chrgstarthour", record.Starttime__c);
        } else {

            component.set("v.starthour", '');
            component.set("v.chrgstarthour", record.Starttime__c);
        }

        if (record.sirenum__Actual_End_Time__c != null) {
            component.set("v.endhour", record.EndTime__c);
            component.set("v.chrgendhour", record.EndTime__c);
        } else {
            component.set("v.endhour", '');
            component.set("v.chrgendhour", record.EndTime__c);
        }
        //component.set("v.starthour",record.Starttime__c);
        //component.set("v.endhour",record.EndTime__c);

        helper.calculateChargableHours(component);
        component.set("v.SchStartHours", scheduleStart.substring(17, 19));
        component.set("v.SchStartMinutes", scheduleStart.substring(20, 22));
        component.set("v.SchEndHours", scheduleEnd.substring(17, 19));
        component.set("v.SchEndMinutes", scheduleEnd.substring(20, 22));
        helper.getJsonFromUrlhelp(component);


        var val = component.get("v.record.Id");
        var action = component.get("c.getBookedTimes");
        action.setParams({ "shiftId": val });
        action.setCallback(this, function (a) {
            var shifts = a.getReturnValue();
            console.log('shifts: ' + shifts);
            component.set("v.shiftsBookedTimes", shifts);
        });
        $A.enqueueAction(action);
    },

    inlineEditStartTime: function (component, event, helper) {
        component.set("v.StartTimeEditMode", true);
        setTimeout(function () {
            document.getElementById('inputTime').focus();
        }, 100);
    },
    closeStartTimeEdit: function (component, event, helper) {
        component.set("v.StartTimeEditMode", false);
        var getvalstart = event.target.value;
        component.set("v.starthour", getvalstart);
        component.set('v.CalculateBreakOnEndClick', true);
        var shiftId1 = component.get('v.record').Id;
        console.log('shiftid1 from here' + shiftId1);

        var breakOnClick = document.getElementById("unpaidBreak" + shiftId1).innerHTML;
        component.set('v.BreakOnEndClick', breakOnClick);
        helper.calculateChargableHours(component);
        var myEvent = $A.get("e.c:ShiftUpdateActualTimes");
        myEvent.setParams({ "recordID": component.get("v.record").Id });
        myEvent.setParams({ "start": getvalstart });
        myEvent.setParams({ "end": component.get("v.endhour") });
        myEvent.fire();
        var myEvent1 = $A.get("e.c:ChangesWereMadeBeforeSave");
        myEvent1.setParams({ "isChanged": true });
        var xyz = myEvent1.getParams({ "isChanged": true });
        console.log('xyz: ' + JSON.stringify(xyz));
        myEvent1.fire();
    },

    updateStartTime: function(component, event, helper) {
        console.log('working');
    },

    inlineEditEndTime: function (component, event, helper) {
        component.set("v.EndTimeEditMode", true);

        setTimeout(function () {
            document.getElementById('inputTime1').focus();
        }, 100);
    },

    closeEndTimeEdit: function (component, event, helper) {
        component.set("v.EndTimeEditMode", false);
        component.set("v.changesMade", false);
        component.set('v.CalculateBreakOnEndClick', true);
        var shiftId1 = component.get('v.record').Id;
        console.log('shiftid1 from here' + shiftId1);
        console.log('## docs ' + document.getElementById("unpaidBreak" + shiftId1));
        var breakOnClick = document.getElementById("unpaidBreak" + shiftId1).innerHTML;
        component.set('v.BreakOnEndClick', breakOnClick);

        var getvalend = event.target.value;
        component.set("v.endhour", event.target.value);

        helper.calculateChargableHours(component);
        var myEvent = $A.get("e.c:ShiftUpdateActualTimes");
        myEvent.setParams({ "recordId": component.get("v.record").Id });
        myEvent.setParams({ "start": component.get("v.starthour") });
        myEvent.setParams({ "end": getvalend });
        myEvent.fire();
        var myEvent1 = $A.get("e.c:ChangesWereMadeBeforeSave");
        myEvent1.setParams({ "isChanged": true });
        var xyz = myEvent1.getParams({ "isChanged": true });
        console.log('xyz: ' + JSON.stringify(xyz));
        myEvent1.fire();

    },
    getAllBreak: function (component, event, helper) {
        console.log('getAllBreak Loaded');
        helper.helperGetAllBreaks(component, event, helper);
    },
    deleteBreak: function (component, event, helper) {
        //alert('called');
        var brkId = event.target.id;
        //alert('fhh=='+brkId);
        //var brkIdn = event.target.Id;
        //alert(brkIdn);
        var shiftid = component.get('v.currentShiftBreak');
        var action = component.get('c.deleteBreaksDB');
        action.setParams({ brkId: brkId, shiftid: shiftid });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var errors = response.getError();
            console.log("--error delete--" + errors);
            var result = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Break", result);
                helper.totalUnpaidBreak(component);
            }

        });
        $A.enqueueAction(action);
    },
    closeModelCancels: function (component, event, helper) {
        component.set("v.isOpenCancel", false);
    },
    addrow: function (component, event, helper) {
        var addRowInList = component.get("v.Break");
        console.log('@@addRowInList ' + addRowInList);
        var BreakObj = new Object();
        addRowInList.push(BreakObj);
        console.log('@@addRowInList ' + addRowInList);
        console.log('@@count ' + addRowInList.length);
        component.set("v.Break", addRowInList);
        component.set("v.RowCount", addRowInList.length);

    },

    testMethod: function (component, event, helper) {
        var shiftId = component.get("v.currentShiftBreak");
        var breakRecord = component.get("v.Break");
        console.log('break' + breakRecord.length);
        var tableLength = document.getElementById("breakTable" + shiftId).rows.length;
        console.log('tableLength' + tableLength);
        console.log('tableLength 2 ' + component.get("v.RowCount"));
        var count = component.get("v.RowCount");
        var tabledata = [];
        for (var i = 0; i < count; i++) {
            //alert('in loop');
            var serial = document.getElementById("filterIndex" + i + shiftId).innerText;
            var duration = document.getElementById("duration" + i + shiftId).value;
            //var paidBreak = document.getElementById("break"+i+shiftId).innerHTML;
            console.log('duration 2 ' + duration);
            var breakId;
            if (breakRecord[i].Id == undefined) {
                breakId = 'New Record';
            }
            else {
                breakId = breakRecord[i].Id;
            }
            console.log('breakId' + i + breakId);
            //tabledata.push({serial:serial,Duration:duration,paidBreak:paidBreak,breakId:breakId});
            tabledata.push({ serial: serial, Duration: duration, breakId: breakId });

        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({

            'message': 'Your Break request has been received, the below screen will update shortly',
            'mode': 'pester',
            'Duration': '10',
            'type': 'Success'
        });
        toastEvent.fire();
        console.log('tabledata' + JSON.stringify(tabledata));
        var action = component.get('c.testMethod1');
        //action.setParams({ breakData : JSON.stringify(tabledata)});
        action.setParams({ breakData: tabledata, shiftid: shiftId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state: ' + state);
            var errors = response.getError();
            console.log('errors: ' + JSON.stringify(errors));
            var result = response.getReturnValue();
            console.log('no messaage here type' + typeof result);
            console.log('result: ' + result);
            if (component.isValid() && state === "SUCCESS") {
                console.log('testResult: ' + JSON.stringify(result));
                console.log("in success");
                //component.set("v.Break",result);
                component.set("v.Break", result);
                helper.totalUnpaidBreak(component);
                console.log('totalUnpaidBreak' + component.get("v.TunpaidBreak"));

                //to populate break in table again

                var shiftId1 = component.get('v.currentShiftBreak');
                var unpaidBreak1 = component.get("v.TunpaidBreak");
                var hoursCalc = Math.floor(unpaidBreak1 / 60);
                var hours;
                if (hoursCalc < 10) {
                    hours = '0' + hoursCalc;
                }
                else {
                    hours = hoursCalc;
                }
                var minutesCalc = unpaidBreak1 % 60;
                var minutes;
                if (minutesCalc < 10) {
                    minutes = '0' + minutesCalc;
                }
                else {
                    minutes = minutesCalc;
                }
                var totalUnpaidBreak1 = hours + ':' + minutes;
                var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
                if (!isMobile || component.get("v.MobileCandView") == true) {
                    document.getElementById('unpaidBreak' + shiftId1).innerHTML = totalUnpaidBreak1;
                }
                //To close the popup
                component.set("v.isOpenCancel", false);
                console.log('himanshu totalUnpaidBreak1 ' + totalUnpaidBreak1);

                //chargeable hours
                //handle negative differences
                var actstarthour = component.get("v.starthour");
                console.log('actstarthour' + actstarthour);
                var actendhour = component.get('v.endhour');
                var timeStart = new Date("01/01/2007 " + actstarthour).getTime();
                var timeEnd = new Date("01/01/2007 " + actendhour).getTime();

                var chargeableHoursInMinutes = (timeEnd - timeStart) / (60 * 1000);
                var chargeableHoursCalc = chargeableHoursInMinutes - unpaidBreak1;
                console.log('chargeableHoursCalc:   ' + chargeableHoursCalc);
                var chargeableHours;
                if (chargeableHoursCalc < 0) {
                    chargeableHours = '00:00';
                }
                else {
                    var CHhoursCalc = Math.floor(chargeableHoursCalc / 60);
                    console.log('CHhoursCalc:   ' + CHhoursCalc);
                    var CHhours;
                    if (CHhoursCalc < 10) {
                        CHhours = '0' + CHhoursCalc;
                    }
                    else {
                        CHhours = CHhoursCalc;
                    }
                    if (CHhours == 0) {
                        CHhours = '00';
                    }

                    var CHminutesCalc = chargeableHoursCalc % 60;
                    var CHminutes;
                    if (CHminutesCalc < 10) {
                        CHminutes = '0' + CHminutesCalc;
                    }
                    else {
                        CHminutes = CHminutesCalc;
                    }
                    if (CHminutes == 0) {
                        CHminutes = '00';
                    }
                    chargeableHours = CHhours + ':' + CHminutes;
                }


                console.log('duration' + chargeableHours);
                component.set("v.chargableTime", chargeableHours);

                $('input[id="outcharge' + shiftId1 + '"]').attr("value", chargeableHours);
                document.getElementById("chargeableHours" + shiftId1).innerHTML = chargeableHours;


                var myEvent1 = $A.get("e.c:ChangesWereMadeBeforeSave");
                myEvent1.setParams({ "isChanged": true });
                myEvent1.fire();

                //For sucessfull message
                if (result.length > 0) {
                    console.log('no messaage here');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "Breaks saved successfully",
                        "mode": "pester",
                        "Duration": "5000",
                        'type': 'Success'

                    });
                    toastEvent.fire();
                    component.set("v.EndBreaks", totalUnpaidBreak1);
                    $('input[id="breakcol' + shiftId1 + '"]').attr("value", totalUnpaidBreak1);

                }

            }

        });
        $A.enqueueAction(action);

    },
    removeElement: function (component, event, helper) {
        var breaks = component.get("v.Break");
        console.log('breaks' + JSON.stringify(breaks));
        var index = event.target.id;
        console.log('index' + index + ' && ' + $(this).attr('id'));
        breaks.splice(index, 1);
        console.log('@@count ' + breaks.length);
        component.set("v.RowCount", breaks.length);
        component.set("v.Break", breaks);
        console.log('@@countBreak ' + component.get("v.Break"));
        var xyz = component.get('v.Break');
        console.log('breaksAfterRemoval' + JSON.stringify(xyz));
    },

    /*onClickCheckBox : function(component, event, helper) {
        var val = component.get("v.record.Id");
        var action =component.get("c.getBookedTimes");
        action.setParams({"shiftId":val});
		action.setCallback(this,function(a){
        	var shifts = a.getReturnValue();
            console.log('shifts: '+shifts);
            component.set("v.shiftsBookedTimes",shifts);
    	});
        $A.enqueueAction(action);
        var checkBoxV = component.find("checkBoxId").get("v.checked");
        component.set("v.CheckboxValue", checkBoxV);
        var cb = component.get("v.CheckboxValue");
        var schStarthrs=component.get("v.shiftsBookedTimes.Scheduled_Start_Time_Text__c");
        var schEndhrs=component.get("v.shiftsBookedTimes.Scheduled_End_Time_Text__c");
        console.log('schStarthrs: '+schStarthrs);
        if(cb==true) {
            component.set("v.starthour",schStarthrs);
            component.set("v.endhour",schEndhrs);
        }
        else{
            component.set("v.starthour","");
            component.set("v.endhour","");
        }
    }*/
})
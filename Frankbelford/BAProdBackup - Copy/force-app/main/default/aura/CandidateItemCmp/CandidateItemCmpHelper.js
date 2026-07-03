({
  getJsonFromUrlhelp: function (component) {
    var query = location.pathname;
    //   console.log('URL '+query);
    if (query.includes("candidateview")) {
      component.set("v.MobileCandView", true);

      //    console.log('pathname');
    }
  },

  helperscriptload: function (component, event, helper) {
    //console.log('seatrch');

    var endhour;
    setTimeout(function () {
      $(".searchDetail_table").on("click", ".tdcentermob", function () {
        //    $('input[id="breakedit"]').attr("value",  component.get("v.EndBreaks"));
        var tr = $(this).closest("tr");
        if ($(tr).hasClass("parent")) {
          var Id = $(this).attr("id");
          console.log("&& sc " + Id);
          var record = component.get("v.record");
          component.set("v.currentShiftBreak", record.Id);

          if (record.Id == Id) {
            console.log("&& ## ");

            $('input[id="outcharge' + record.Id + '"]').attr("value", "00:00");
            $('input[id="inputTimemob' + record.Id + '"]').attr("value", "");
            $('input[id="inputTime1mob' + record.Id + '"]').attr("value", "");
            $('input[id="breakcol' + record.Id + '"]').attr("value", "00:00");
            component.set("v.starthour", "");
            component.set("v.endhour", "");

            var endbreak = component.get("v.EndBreaks");
            $('input[id="breakcol' + record.Id + '"]').attr("value", endbreak);

            var valstart = $("#inputTimemob" + record.Id).attr("value");
            var valend = $("#inputTime1mob" + record.Id).attr("value");

            component.set("v.BreakLength", record.Break_from_Brekdef__c);
            $('input[id="outcharge2' + record.Id + '"]').attr(
              "value",
              record.Break_from_Brekdef__c +
                "&" +
                record.Break_Length__c +
                "&" +
                record.Id
            );

            if (
              component.get("v.starthour") == "" ||
              component.get("v.starthour") == null ||
              component.get("v.starthour") == "undefined"
            ) {
              //              console.log('in if for record.sirenum__Actual_Start_Time__c@@ '+record.sirenum__Actual_Start_Time__c);
              if (
                (typeof record.sirenum__Actual_Start_Time__c == "undefined" ||
                  record.sirenum__Actual_Start_Time__c == "") &&
                (typeof record.sirenum__Actual_End_Time__c == "undefined" ||
                  record.sirenum__Actual_End_Time__c == "")
              ) {
                //           console.log('in if for starthour@@');
                component.set("v.starthour", "");
                component.set("v.endhour", "");
                //  endhour = record.EndTime__c;
              } else {
                // console.log('in else for starthour@@');
                component.set("v.starthour", record.Starttime__c);
                component.set("v.endhour", record.EndTime__c);
              }
            }

            if (valstart == "" || valstart == "undefined" || valstart == null) {
              //         console.log('&& IN IF ');
              //   document.getElementById('inputTimemob'+Id).value = component.get("v.starthour");
              $('input[id="inputTimemob' + record.Id + '"]').attr(
                "value",
                component.get("v.starthour")
              );
            } else {
              // $('input[id="inputTimemob"]').attr("value",valstart);
              $('input[id="inputTimemob' + record.Id + '"]').attr(
                "value",
                valstart
              );
            }
            if (valend == "" || valend == "undefined" || valend == null) {
              $('input[id="inputTime1mob' + record.Id + '"]').attr(
                "value",
                component.get("v.endhour")
              );
              //  $('input[id="inputTime1mob"]').attr("value", component.get("v.endhour"));
            } else {
              //$('input[id="inputTime1mob"]').attr("value", valend)
              $('input[id="inputTime1mob' + record.Id + '"]').attr(
                "value",
                component.get("v.valend")
              );
            }
            //        console.log(component.get("v.starthour") +' Start time '+  $('input[id="inputTimemob'+record.Id+'"]').attr("value"));
            //      console.log(component.get("v.endhour")+' End time '+  $('input[id="inputTime1mob'+record.Id+'"]').attr("value"));
            helper.mobilecalculateChargableHours(component);
          }
        }

        //   $('input[id="endtext"]').attr("value", component.get("v.endhour"));
      });
      $(".searchDetail_table").on("change", ".time-blockTime", function () {
        //                console.log('test');
        var Id = component.get("v.currentShiftBreak");
        var tr = $(this).closest("tr");
        if ($(tr).hasClass("child")) {
          //     console.log('in if');
          var valId = $(this).attr("id");
          var valstart;
          var valend;
          if (valId == "inputTimemob" + Id) {
            valstart = $(this).val();
            valend = $("#inputTime1mob" + Id).attr("value");
          } else if (valId == "inputTime1mob" + Id) {
            valstart = $("#inputTimemob" + Id).attr("value");
            valend = $(this).val();
          }
          $('input[id="inputTimemob' + Id + '"]').attr("value", valstart);
          $('input[id="inputTime1mob' + Id + '"]').attr("value", valend);
          component.set("v.starthour", $("#inputTimemob" + Id).attr("value"));
          component.set("v.endhour", $("#inputTime1mob" + Id).attr("value"));
          //       console.log('in valstart '+valstart+valend);
          helper.mobilecalculateChargableHours(component);
          //      helper.helpcloseStartTimeEdit(component,valstart,valend, event, helper);
          //      helper.helpercloseModelCancel(component, event, helper);
        }
      });

      $(".searchDetail_table").on("click", ".editBreakButton", function () {
        $A.get("e.force:refreshView").fire();
        //    console.log('in edit button'+ $(this).attr('id')  );
        var shiftId = $(this).attr("id");
        helper.helperGetAllBreaks(component, event, helper, shiftId);
      });
    }, 200);
  },
  helperGetAllBreaks: function (component, event, helper, shiftId) {
    //    console.log('getAllBreak Loaded');
    var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
    var ShiftId;
    if (isMobile) {
      ShiftId = shiftId;
    } else {
      ShiftId = event.target.id;
    }
    //   console.log('getAllBreak shiftId '+ShiftId);
    component.set("v.currentShiftBreak", ShiftId);
    var action = component.get("c.getAllBreaksDB");
    action.setParams({ shiftId: ShiftId });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var result = response.getReturnValue();
      //    console.log('result '+JSON.stringify(result));
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.Break", result);
        component.set("v.RowCount", result.length);
        var shiftid = component.get("v.Break");
        helper.totalUnpaidBreak(component);
        //       console.log('inallbreak'+component.get('v.currentShiftBreak'));
      }
    });
    $A.enqueueAction(action);
  },
  helpcloseStartTimeEdit: function (
    component,
    valstart,
    valend,
    event,
    helper
  ) {
    // component.set("v.StartTimeEditMode", false);
    //   console.log('in help '+valstart+valend);

    component.set("v.starthour", valstart);
    component.set("v.endhour", valend);
    $('input[id="inputTimemob"]').attr("value", valstart);
    $('input[id="inputTime1mob"]').attr("value", valend);
    helper.calculateChargableHours(component);
  },
  helpercloseModelCancel: function (component, event, helper) {
    var start = $("#inputTimemob").attr("value");
    var end = $("#inputTime1mob").attr("value");
    //   console.log('myEvent '+start+end);
    var myEvent = $A.get("e.c:ShiftUpdateActualTimes");
    myEvent.setParams({ recordID: component.get("v.record").Id });
    myEvent.setParams({ start: start });
    myEvent.setParams({ end: end });
    myEvent.fire();
    //   console.log('myEvent '+myEvent);
  },
  mobilecalculateChargableHours: function (component) {
    //new start

    var Id = component.get("v.currentShiftBreak");
    //   console.log('ID 184 '+ Id);
    var getstart = $("#inputTimemob" + Id).attr("value");
    var getend = $("#inputTime1mob" + Id).attr("value");

    //   console.log('timings '+getstart+getend);
    var start;
    var end;
    if (getstart == "undefined" || getstart == null || getstart == "") {
      //        console.log('timings in IF ');
      start = component.get("v.starthour");
      end = component.get("v.endhour");
    } else {
      //          console.log('timings in else ');
      start = getstart;
      end = getend;
    }
    var totalchar;
    if (start == "" || end == "") {
      //       console.log('timings in IF2 ');
      //       console.log('in if');
      totalchar = "00:00";
      component.set("v.chargableTime", totalchar);
    } else {
      //     console.log(' in else 2');
      var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
      //  var recordId =  component.get('v.currentShiftBreak');
      var brkmin;
      var brkdisp;
      var shiftid = component.get("v.record").Id;
      //   console.log(' inisMobile  else 2 '+shiftid  + Id);

      /*      if(isMobile){
                       var brkval =  $("#outcharge2").attr("value");
                         console.log(' in isMobile 2 ' +brkval);
                      var words = brkval.split('&');
                      if(shiftid == words[2] ){
                        brkmin = words[0];
                         brkdisp = words[1];
                      }

                  }
                  else
                  {
                       console.log(' in desktop else ');
                        brkmin = component.get("v.record").Break_from_Brekdef__c;
                        brkdisp = component.get("v.record").Break_Length__c;
                  }*/
      //     console.log('startend '+start+end);
      if (start != null && end != null) {
        //        console.log('line 130');
        var startTime = new Date();
        startTime.setHours(start.substr(0, start.indexOf(":")));
        startTime.setMinutes(start.substr(start.indexOf(":") + 1));

        var endTime = new Date();
        endTime.setHours(end.substr(0, end.indexOf(":")));
        endTime.setMinutes(end.substr(end.indexOf(":") + 1));
        var today = new Date();
        if (endTime < startTime) {
          endTime.setDate(today.getDate() + 1);
          endTime.setHours(end.substr(0, end.indexOf(":")));
          endTime.setMinutes(end.substr(end.indexOf(":") + 1));
        }
        var duration = endTime.getTime() - startTime.getTime();
        var durtime = Math.ceil(
          (endTime.getTime() - startTime.getTime()) / (1000 * 60)
        );
        var brkdur = brkmin * 60000;

        var diff;
        var brkmin1;
        var brkminDB;
        var brkdisp1;
        if (isMobile) {
          //        console.log('@@@ outcharge2 257 '+$('input[id="outcharge2'+Id+'"]').attr("value"));
          var brkval = $("#outcharge2" + Id).attr("value");
          //  		 console.log(' in isMobile 2 ' +brkval);
          var words = brkval.split("&");
          //        console.log(Id+' in isMobile 241 ' +words[0]+words[1]+words[2]);
          if (Id == words[2]) {
            brkminDB = words[0];
            brkdisp1 = words[1];
          }
        } else {
          //        console.log(' in desktop else ');
          brkminDB = component.get("v.record").Break_from_Brekdef__c;
          brkdisp1 = component.get("v.record").Break_Length__c;
        }

        var endEditClicked = component.get("v.CalculateBreakOnEndClick");
        var BreakOnEndClick = component.get("v.BreakOnEndClick");
        //        console.log('breakdef '+brkminDB+' ** '+brkdisp1);
        if (endEditClicked == true) {
          //          console.log('line 156');
          var BreaksOnClicks = BreakOnEndClick.split(":");
          var hoursInBreak = BreaksOnClicks[0];
          var MinInBreak = BreaksOnClicks[1];
          //         console.log('hoursInBreak: '+hoursInBreak +"  " + 'MinInBreak: '+MinInBreak);
          brkmin1 = parseInt(hoursInBreak) * 60 + parseInt(MinInBreak);
          //         console.log('--brkmin1 endEditClicked--'+brkmin1);
        } else {
          //        console.log('line 165');
          brkmin1 = brkminDB;
          //           console.log('--brkmin1 endEditClicked--'+brkmin1);
        }
        if (brkmin1 > 0 && durtime >= brkmin1) {
          //          console.log(brkmin1+'--durtime --'+durtime);
          diff = durtime - brkmin1;
          //         console.log('diff at 170'+diff);
        } else if (brkmin1 == 0) {
          diff = durtime;
          //        console.log('diff at 174'+diff);
        } else {
          diff = 0;
        }

        var hoursCalc = Math.floor(diff / 60);
        var hours;
        if (hoursCalc < 10) {
          hours = "0" + hoursCalc;
        } else {
          hours = hoursCalc;
        }
        var minutesCalc = diff % 60;
        var minutes;
        if (minutesCalc < 10) {
          minutes = "0" + minutesCalc;
        } else {
          minutes = minutesCalc;
        }

        totalchar = hours + ":" + minutes;
        //       console.log('totalchar 194'+totalchar);
        //    component.set("v.chargableTime", totalchar);

        component.set("v.CalculateBreakOnEndClick", false);
      }
    }
    $('input[id="outcharge' + Id + '"]').attr("value", totalchar);
  },
  calculateChargableHours: function (component) {
    //new start
    var Id = component.get("v.currentShiftBreak");
    var getstart = $("#inputTimemob" + Id).attr("value");
    var getend = $("#inputTime1mob" + Id).attr("value");
    var start;
    var end;
    if (getstart == "undefined" || getstart == null || getstart == "") {
      start = component.get("v.starthour");
      end = component.get("v.endhour");
    } else {
      start = getstart;
      end = getend;
    }

    var totalchar;
    if (start == "" || end == "") {
      //     console.log('in if');
      totalchar = "00:00";
      component.set("v.chargableTime", totalchar);
    } else {
      //    console.log('in else');
      var brkmin = component.get("v.record").Break_from_Brekdef__c;
      var brkdisp = component.get("v.record").Break_Length__c;
      var shiftid = component.get("v.record").Id;
      if (start != null && end != null) {
        //      console.log('line 130calculateChargableHours');
        var startTime = new Date();
        startTime.setHours(start.substr(0, start.indexOf(":")));
        startTime.setMinutes(start.substr(start.indexOf(":") + 1));

        var endTime = new Date();
        endTime.setHours(end.substr(0, end.indexOf(":")));
        endTime.setMinutes(end.substr(end.indexOf(":") + 1));
        var today = new Date();
        if (endTime < startTime) {
          endTime.setDate(today.getDate() + 1);
          endTime.setHours(end.substr(0, end.indexOf(":")));
          endTime.setMinutes(end.substr(end.indexOf(":") + 1));
        }
        var duration = endTime.getTime() - startTime.getTime();
        var durtime = Math.ceil(
          (endTime.getTime() - startTime.getTime()) / (1000 * 60)
        );
        var brkdur = brkmin * 60000;

        var diff;
        var brkmin1;
        var brkminDB = component.get("v.record").Break_from_Brekdef__c;
        var brkdisp1 = component.get("v.record").Break_Length__c;
        var endEditClicked = component.get("v.CalculateBreakOnEndClick");
        var BreakOnEndClick = component.get("v.BreakOnEndClick");

        if (endEditClicked == true) {
          //         console.log('line 156');
          var BreaksOnClicks = BreakOnEndClick.split(":");
          var hoursInBreak = BreaksOnClicks[0];
          var MinInBreak = BreaksOnClicks[1];
          //      console.log('hoursInBreak: '+hoursInBreak +"  " + 'MinInBreak: '+MinInBreak);
          brkmin1 = parseInt(hoursInBreak) * 60 + parseInt(MinInBreak);
          //        console.log('--brkmin1 endEditClicked--'+brkmin1);
        } else {
          //        console.log('line 165');
          brkmin1 = brkminDB;
        }

        if (brkmin1 > 0 && durtime >= brkmin1) {
          diff = durtime - brkmin1;
          //          console.log('diff at 170'+diff);
        } else if (brkmin1 == 0) {
          diff = durtime;
          //           console.log('diff at 174'+diff);
        } else {
          diff = 0;
        }

        var hoursCalc = Math.floor(diff / 60);
        var hours;
        if (hoursCalc < 10) {
          hours = "0" + hoursCalc;
        } else {
          hours = hoursCalc;
        }

        var minutesCalc = diff % 60;
        var minutes;
        if (minutesCalc < 10) {
          minutes = "0" + minutesCalc;
        } else {
          minutes = minutesCalc;
        }
        //        console.log('totalchar 194'+totalchar);
        totalchar = hours + ":" + minutes;
        component.set("v.chargableTime", totalchar);
        component.set("v.CalculateBreakOnEndClick", false);
      }
    }
    $('input[id="outcharge' + Id + '"]').attr("value", totalchar);
  },

  totalUnpaidBreak: function (component) {
    //    console.log('this called');
    var shiftBreaks = component.get("v.Break");
    //console.log('shiftBreaks'+JSON.stringify(shiftBreaks));
    var unpaidBreak = 0;
    for (var i = 0; i < shiftBreaks.length; i++) {
      if (shiftBreaks[i].sirenum__Paid_Break__c == false) {
        unpaidBreak = unpaidBreak + shiftBreaks[i].Duration_Long__c;
      }
    }
    //    console.log('unpaidBreak '+unpaidBreak);
    component.set("v.TunpaidBreak", unpaidBreak);
  }
});
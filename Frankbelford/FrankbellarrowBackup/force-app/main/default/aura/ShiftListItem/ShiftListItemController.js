({	
    doInit: function(component, event, helper) {
        
        var record = component.get("v.record"); 
        console.log('record '+record);
        var scheduleStart = record.sirenum__Scheduled_Start_Time__c;
        var scheduleEnd = record.sirenum__Scheduled_End_Time__c;
        component.set("v.starthour",record.Starttime__c);
        component.set("v.endhour",record.EndTime__c);
       
        helper.calculateChargableHours(component);
        component.set("v.SchStartHours", scheduleStart.substring(17, 19));
        component.set("v.SchStartMinutes", scheduleStart.substring(20, 22));
        component.set("v.SchEndHours", scheduleEnd.substring(17, 19));
        component.set("v.SchEndMinutes", scheduleEnd.substring(20, 22));
       // var check = component.get("v.selecthighlight");
       
    },
    SelectAllClicked: function(component, event, helper) {
        var args = event.getParam("arguments");
        var selectAllChecked = args.checkedAll;
        component.find("select").set("v.checked",selectAllChecked);
        
    },
    inlineEditStartTime : function(component,event,helper){   
        component.set("v.StartTimeEditMode", true); 
        setTimeout(function(){ 
           document.getElementById('inputTime').focus();
             
        }, 100);
    },
    closeStartTimeEdit : function (component, event, helper) {
        component.set("v.StartTimeEditMode", false);
          var getvalstart = event.target.value;
         component.set("v.starthour", getvalstart);
          
        helper.calculateChargableHours(component);
        var myEvent = $A.get("e.c:ShiftUpdateActualTimes");
        myEvent.setParams({ "recordID": component.get("v.record").Id});
        myEvent.setParams({ "start": getvalstart});
        myEvent.setParams({ "end": component.get("v.endhour")});
        myEvent.fire();
    },
    inlineEditEndTime : function(component,event,helper){   
          component.set("v.EndTimeEditMode", true); 
        setTimeout(function(){ 
            document.getElementById('inputTime1').focus();
        }, 100);
    },
    closeEndTimeEdit : function (component, event, helper) {
        component.set("v.EndTimeEditMode", false);
       
            var getvalend = event.target.value;
          component.set("v.endhour",event.target.value);
         console.log('END changed '+getvalend);
        helper.calculateChargableHours(component);
        var myEvent = $A.get("e.c:ShiftUpdateActualTimes");
        myEvent.setParams({ "recordId": component.get("v.record").Id});
        myEvent.setParams({ "start": component.get("v.starthour")});
        myEvent.setParams({ "end": getvalend});
        myEvent.fire();
        
    },
    HighlightRow : function(component,event,helper){   
        var record = component.get("v.record"); 
        if(event.getParam("MatchedOnly")){
            var SchStartHours = component.get("v.SchStartHours");
            var SchStartMinutes = component.get("v.SchStartMinutes");
            var SchEndHours = component.get("v.SchEndHours");
            var SchEndMinutes = component.get("v.SchEndMinutes");
            
            var scheduleStart = new Date(record.sirenum__Scheduled_Start_Time__c);
            var scheduleEnd = new Date(record.sirenum__Scheduled_End_Time__c);
            var actualStart = new Date("2011-04-20T"+record.Starttime__c+":00.0");
            var actualEnd = new Date("2011-04-20T"+record.EndTime__c+":00.0");
           
            if(scheduleStart.getHours() == actualStart.getHours() && scheduleStart.getMinutes() == actualStart.getMinutes() && scheduleEnd.getHours() == actualEnd.getHours() && scheduleEnd.getMinutes() == actualEnd.getMinutes()){
                var td = component.find("td");
                 
                for(var i=0;i<td.length;i++){ 
                    
                    $A.util.addClass(td[i], 'Red');
                    var myEvent = $A.get("e.c:ShiftMatchIdEvent");
                    myEvent.setParams({ "record": component.get("v.record").Id});
                    myEvent.setParams({ "select": true});
                    myEvent.fire();
                }
            }
        }
        else{
            var td = component.find("td");
            for(var i=0;i<td.length;i++){    
                $A.util.removeClass(td[i], 'Red');
                var myEvent = $A.get("e.c:ShiftMatchIdEvent");
                myEvent.setParams({ "record": component.get("v.record").Id});
                myEvent.setParams({ "select": false});
                myEvent.fire();
            }
        }
    }
})
({
    doInit: function(component, event, helper) {
        helper.getShifts(component);
    },
 Selectclicked: function(component, event, helper){ 
        var selectedRec = event.getSource();
        var check = selectedRec.get("v.checked");
        
   var checkboxes = component.find("select");
        var checkarray= [];
         
          var tr = component.find("tr");
       for(var i = 0; i < checkboxes.length; i++)
        {  console.log('check '+check);
            console.log('selectedRec '+selectedRec);
           console.log('checkboxesabc '+checkboxes[i]);
           if(checkboxes[i] == selectedRec)
           {
               if( check == true)
               {
               console.log('in IF');
               checkarray.push(selectedRec);
                   $A.util.addClass(tr[i], 'Red'); 
               }
                else
         			{
               			$A.util.removeClass(tr[i], 'Red');
                        var selectAllChecked = component.find("selectAll");
                        selectAllChecked.set("v.checked",false);
         			}
           }
        
        }
    	
        console.log('checkarray '+checkarray);
    },
    SelectAllClicked: function(component, event, helper) {
        
        var selectAllChecked = component.find("selectAll").get("v.checked");
          console.log('selectAllChecked '+selectAllChecked);
            var shifts = component.get("v.shifts");
        var checkboxes = component.find("select");
         var tr = component.find("tr");
        if(selectAllChecked == true){
        for (var i = 0; i < checkboxes.length; i++){
          console.log('IN IF');
            checkboxes[i].set("v.checked",selectAllChecked);
             $A.util.addClass(tr[i], 'Red'); 
         }  
        }
        else
        {
            console.log('IN else');
           for (var i = 0; i < checkboxes.length; i++){
             checkboxes[i].set("v.checked",selectAllChecked);
                 $A.util.removeClass(tr[i], 'Red');
           }
        }
        console.log('checkboxes '+checkboxes);
    },
    renderPage: function(component, event, helper) {
        var records = component.get("v.allshifts");
        console.log("-----------"+component.get("v.pageNumber"));
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.shifts", pageRecords);
    },
    ApproveAll: function(component,event,helper){
        
     /*   if(component.find("selectAll").get("v.checked")){
            var shifts = component.get("v.shifts");
            component.set("v.shiftsToBeApproved",shifts);
            helper.approveshifts(component);
        }
        else{*/
            var checkboxes = component.find("select");
            var shiftIDS = [];
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.checked")){
                    shiftIDS.push(checkboxes[i].get("v.name"));
                }
            }
            helper.getShiftsFromIDs(component,shiftIDS);
            helper.approveshifts(component);
            
   //     }
        component.find("selectAll").set("v.checked",false);
    },
    approve: function(component, event, helper) {
           component.set("v.approvestatus",false);
        var target = event.getSource();
        var shifttIds = [];
        shifttIds.push(component,target.get("v.value"));
        helper.getShiftsFromIDs(component,shifttIds);
        helper.approveshifts(component);
        
    },
    reject: function(component, event, helper) {
        var target = event.getSource();
        var idToBeCancelled = target.get("v.value");
        console.log("idToBeCancelled--"+idToBeCancelled);
        var shiftList = component.get("v.shifts");
        for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idToBeCancelled){
                console.log("matched--"+idToBeCancelled);
                component.set("v.cancelledshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
            }
        }
    },
    ShiftSearchEvent: function(component, event, helper) {
        component.find("selectAll").set("v.checked",false);
        component.set("v.site", event.getParam("site"));
        component.set("v.contact", event.getParam("contact"));
        component.set("v.startDate", event.getParam("startDate"));
        component.set("v.endDate", event.getParam("endDate"));
        component.set("v.approvestatus",true);
        helper.getShifts(component);
    },
     selecthighlight: function(component, event, helper) {
       
      	 component.set("v.selecthighlight",true);
               
     },
    UpdateActualTimes: function(component, event, helper) {
        var shifts = component.get("v.shifts");
        var recordId = event.getParam("recordID");
        var start = event.getParam("start");
        var end = event.getParam("end");
        component.set("v.starthour",start);
        component.set("v.endhour",end);
        component.set("v.HourStatus",true);
        if(start == '' || end== '')
        {
              component.set("v.isError",true);
            
        }
        else
        {
          
            component.set("v.isError",false);
          
       
        component.set("v.shifts",shifts);
        }
    },
    ShiftMatched: function(component, event, helper) {
        var checkboxes = component.find("select");
        var recordId = event.getParam("record");
        var select = event.getParam("select");
        for (var i = 0; i < checkboxes.length; i++){
            if(checkboxes[i].get("v.name") == recordId){
                checkboxes[i].set("v.checked",select);
            }
        }
    },
    closeModelCancel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenCancel", false);
    },
    submitReject:function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenCancel", false);
        var action = component.get("c.SendRejectionToOwner");
        var comments = component.find("Query").get("v.value");
        var shift = component.get("v.cancelledshift")[0]; 
        var id = shift.Id;
        var combinedComment = 'Shift Number- '+shift.Name+' Site-'+shift.sirenum__Site__r.Name+' Job Role-'+shift.sirenum__Team__r.Name;
        action.setParams({ 'shiftID': id, 'comments': comments, 'combinedComment': combinedComment });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                   "message": "Rejection complete"
                });
                toastEvent.fire();
                component.set("v.isOpenQuery", false);
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpenQuery", false);
            }
        });
        $A.enqueueAction(action);
         
        var shifttIds = [];
        shifttIds.push(id);
        helper.getShifts(component);
      

    },
    getBackscreen : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/client-approved-timesheets" });
        urlEvent.fire();
    }
})
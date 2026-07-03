({
     getShifts : function(component) {
        var action = component.get("c.getAllShifts");
        var checkstatus = component.get("v.approvestatus");
  /*     console.log('checkstatus '+checkstatus);
         */
         var site = component.get("v.site");
         var cont = component.get("v.contact");
         var startdate = component.get("v.startDate");
         var enddate = component.get("v.endDate");
         
           console.log('checkstatussite '+site);
           console.log('checkstatuscontact '+cont);
          console.log('checkstatusstartDate '+startdate);
          console.log('checkstatusendDate '+enddate); 
         
         if(startdate == '' || enddate == '')
         {
             startdate =  null;
             enddate = null;
         }
          console.log('2ndcheckstatusstartDate '+startdate);
          console.log('2ndcheckstatusendDate '+enddate); 
         
        action.setParams({
            "site": site,
            "contact": cont,
            "startDate": startdate,
            "endDate": enddate
        });
          console.log('action '+action);
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log('result '+result);
            component.set("v.allshifts", result);
             
            var currentList;
            if(result.length>0){
                
                currentList = result.slice(0,10);
            }
            else if(checkstatus == true){
                 console.log('checkstatusin else '+checkstatus);
                  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "No Shift to approve for this Site"});
                toastEvent.fire();
             }
            component.set("v.shifts", currentList);
            component.set("v.pageNumber", 1);
            component.set("v.maxPage", Math.floor((result.length+9)/10)); 
              
        });
        $A.enqueueAction(action);
    },
     approveshifts : function(component, page) {
       
        var check = component.get("v.isError");
     //   console.log('check '+check);
      
        if(component.get("v.shiftsToBeApproved").length <1){
            console.log('IN IF approve');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Please select atleast one shift to approve.",
                "message": "Error!"
            });
            toastEvent.fire();
        }
        else if(check == true){
           console.log('IN IF ');
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               
                "message": "Timings can not be blank"
            });
            toastEvent.fire();
        }
        else{
         
           console.log('in ELSE');
            
      		console.log('component.get("v.shiftsToBeApproved") '+ component.get("v.shiftsToBeApproved"));
            var action = component.get("c.getshift");
            action.setParams({
                "JSONSHIFT" : JSON.stringify(component.get("v.shiftsToBeApproved"))
            });
            
            action.setCallback(this, function(response) {
                 var result = response.getReturnValue();
          //      console.log(result+'result');
                var state = response.getState();
                
                if (result == "Success"){
           
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Shift Approved.",
                        "message": "Success!"
                    });
                    toastEvent.fire();
                    
                    
                }
                else if (result == "Error") {
           //        console.log('IN ERROR '); 
                     var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
              
                "message": "There are some issues with the shift, please contact consultant"
            });
            toastEvent.fire();
                }
                    else if (state === "INCOMPLETE") {
                        console.log('incomplete');
                    }
            });
            $A.enqueueAction(action);
            console.log('approvestatus '+component.get("v.approvestatus"));
            this.getShifts(component);
           
        }
    },
    getShiftsFromIDs : function(component, shiftIDs) {
        var allShifts = component.get("v.shifts");
        var shiftToBeApproved = [];
   /*     console.log('end hour variable '+ component.get("v.starthour"));
       console.log('end hour variable '+ component.get("v.endhour"));
         console.log('HourStatusOut '+component.get("v.HourStatus")); 
        console.log('allShifts '+allShifts.lenght);
        console.log('allShifts00StartTime__c '+allShifts[1].Starttime__c);
        console.log('allShifts00EndTime__c '+allShifts[1].EndTime__c); */
        for (var i = 0; i < allShifts.length; i++) {
            for (var j = 0; j < shiftIDs.length; j++) {
                if(shiftIDs[j] == allShifts[i].Id){
                     if(component.get("v.HourStatus") == true )
                  {
                      console.log('IN IF TIME '+allShifts[i].Starttime__c);
                      allShifts[i].Starttime__c = component.get("v.starthour"); 
                       allShifts[i].EndTime__c = component.get("v.endhour");
                      component.set("v.HourStatus",false); 
                      
                       console.log('HourStatus in IF'+component.get("v.HourStatus"));
                  }
				  else
                    {
                         console.log('IN ELSE TIME ');
                        console.log('HourStatus in ELSE'+component.get("v.HourStatus"));
                         allShifts[i].Starttime__c =allShifts[i].Starttime__c;
                      allShifts[i].EndTime__c =  allShifts[i].EndTime__c;
                        
                    }
                   
                 
                    console.log("matchediD"+allShifts[i].Id);         
                    shiftToBeApproved.push(allShifts[i]);
                }
            }
        }
         console.log('shiftToBeApproved '+ shiftToBeApproved[0].Starttime__c+' $$ ' +shiftToBeApproved[0].EndTime__c);
        component.set("v.shiftsToBeApproved",shiftToBeApproved);
    }  
})
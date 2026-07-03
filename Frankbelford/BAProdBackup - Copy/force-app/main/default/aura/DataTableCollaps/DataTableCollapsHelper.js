({
    getShifts : function(component, event, helper) {
        var action = component.get("c.getAllShifts");
     
       action.setParams({
            "site": component.get("v.site"),
            "role": component.get("v.role"),
            "contact": component.get("v.contact"),
            "DateRange": component.get("v.DateRange")
        });
          console.log('action '+action);
          action.setCallback(this, function(response) {
          var result = response.getReturnValue();
         
          component.set("v.shifts", result);
              component.set("v.Paginationshifts", result);
        // alert(3);
           if(result.length>0){
            console.log('len in if');
             var dataTable = $('#tableId').DataTable();
  	  					dataTable.destroy();
                         setTimeout(function(){ 
                         $('#tableId').DataTable(
                         {
                                 responsive:true,
                                order: [[ 1, "asc" ]],
                                 columnDefs: [
                                 { "orderable": false,"targets": [0,4,5,8] },
                                 
                             ]
                             }
                         );
                            
                            }, 800); 
           
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
          
                'message': 'No shifts available for this search',
                    
                      'Duration': '1000'
            });
            toastEvent.fire();
            }
        
       // component.set("v.maxPage", Math.floor((result.length+9)/10));
       // helper.renderPage(component);  
              
              
        });
        
         $A.enqueueAction(action); 
    },
	approveshifts : function(component,helper, page) {
       
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
                    //alert('comp');
                   // helper.getShifts(component, event, helper);
                    
                }
                else if (result == "Error") 	{
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
            helper.getShifts(component, event, helper);
           
        }
    },
    getShiftsFromIDs : function(component, shiftIDs) {
        
       // alert('shiftIDs'+shiftIDs.length);
    // alert('shiftIDs'+shiftIDs[0]);
        var allShifts = component.get("v.shifts");
        var shiftToBeApproved = [];
   
      for (var j = 0; j < shiftIDs.length; j++) {
        for (var i = 0; i < allShifts.length; i++) {
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
    },
    
    renderPage: function(component) {
         console.log('in render');
		var records = component.get("v.shifts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecordsmax page '+ component.get("v.maxPage"));
        component.set("v.Paginationshifts", pageRecords);
           setTimeout(function(){ 
                    $('#tableId').DataTable();
                    responsive: true
                },1000); 
	},
})
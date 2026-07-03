({
    
    doInit : function(component, event, helper) {
        
       var result = component.get("v.shifts");
        component.set("v.Paginationshifts", result);
        if(result.length>0){
           
           if(component.get("v.Search")==true)
           {
               var dataTable = $('#tableId').DataTable();
  	  					dataTable.destroy();
                        dataTable.clear(); 
                         setTimeout(function(){ 
                             $('#tableId').DataTable({
                                 responsive:true,
                                 aaSorting: [],
                                 columnDefs: [
                                 { "orderable": false,"targets": [0,4,5,8] },
                                 
                             ]
                             });
                             
                        }, 800);   
               
           }
            else
            {
               // alert(2);
               console.log('onload');
                  var dataTable = $('#tableId').DataTable({
                                 responsive:true,
                                     aaSorting: [],
                                 
                                 columnDefs: [
                                 { "orderable": false,"targets": [0,4,5,8] },
                                 
                             ]
                             });
  	  					//dataTable.destroy();
              /* setTimeout(function(){ 
                             $('#tableId').DataTable({
                                 responsive:true,
                                 
                             });
                             
                        }, 500);   */
               
                
            }
             
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
          
                'message': 'No shifts available for this search',
                    
                      'Duration': '1000'
            });
            toastEvent.fire();
                
                 var dataTable = $('#tableId').DataTable();
  	  					dataTable.destroy();
                        dataTable.clear(); 
                         
                 $('.dataTables_paginate').hide();
                $('.dataTables_info').hide();
               
            }
        
       // component.set("v.maxPage", Math.floor((result.length+9)/10));
       // helper.renderPage(component);
		
	},
      renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }, 
    /*page refresh after data save*/    
     scriptsLoaded: function (cmp, evt, helper) {
        
    },
     
    approve: function(component, event, helper) {
           component.set("v.approvestatus",false);
         var target = event.target.id;
        //alert(target);
        var shifttIds = [];
        shifttIds.push(target);
        helper.getShiftsFromIDs(component,shifttIds);
        helper.approveshifts(component,helper);
        
    },
    
    reject: function(component, event, helper) {
       // alert('\nCandidate--'+component.get("v.contact"));
       // var target = event.target.id;
        var idToBeCancelled = event.target.id;
        console.log("idToBeCancelled--"+idToBeCancelled);
        var shiftList = component.get("v.shifts");
        for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idToBeCancelled){
                console.log("matched--"+idToBeCancelled);
                component.set("v.cancelledshift", shiftList[i]);
              //  component.set("v.isOpenCancel", true);
            }
        }
        //$A.get('e.force:refreshView').fire();
    },
    closeModelCancel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenCancel", false);
      //  helper.getShifts(component, event, helper);
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
                //alert('success');
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
        helper.getShifts(component, event, helper);
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
    
    
    ShiftSearchEvent: function(component, event, helper) {
       // alert('Contact'+event.getParam("contact")+'\nsite'+event.getParam("site"));
        component.set("v.site", event.getParam("site"));
        component.set("v.role", event.getParam("role"));
        component.set("v.contact", event.getParam("contact"));
        component.set("v.DateRange", event.getParam("DateRange"));
      
    },
    checkboxSelect: function(cmp, event, helper) {
    console.log(event.getSource().get('v.checked'));
    console.log(event.getSource().get('v.value'));
},
    Selectclicked: function(component, event, helper){
    
        var checkboxes = component.find("select");
         console.log('clicked'+checkboxes);
        var selectedRec = event.getSource();
         console.log('selectedRec '+selectedRec);
        var check = selectedRec.get("v.value");
      console.log('check '+check);
             var checkarray= [];
         
          var tr = component.find('tr');
               console.log('tr '+tr);
       for(var i = 0; i < checkboxes.length; i++)
        {  
  
            if(checkboxes[i] == selectedRec)
           {
             
               if( check == true)
               {
              
                  
               checkarray.push(selectedRec);
      
              $A.util.addClass(tr[i],'Red'); 
               }
                else
         			{
                         
               			$A.util.removeClass(event.target.parentElement, 'Red');
                      
         			}
           
           }
        } 
   	
    },
    
   SelectclickedAll: function(component, event, helper){
        var selectedRec = event.getSource();
        var check = selectedRec.get("v.checked");
       var n = selectedRec.get("v.name");
       
       var appl = [];
       appl = component.get("v.AllAppList");
       if(appl.includes(n)==true&&check==false)
       {
          // alert(1);
           for( var i = 0; i < appl.length; i++){ 
           if ( appl[i] == n) {
             appl.splice(i, 1); 
             break;
           }
           }
        }
        else if(appl.includes(n)==false&&check==true)
       {
          // alert(2);
             appl.push(n);  

       }

      // var checkboxes = component.find("select");
      component.set("v.AllAppList",appl);
      // alert('iii'+appl.length);
   },
    ApproveAll: function(component, event, helper){
        
            var checkboxes = component.find("select");
      
            var shiftIDS = component.get("v.AllAppList");
        console.log('len '+checkboxes.length);
        component.set("v.AllAppList",[]);
            for (var i = 0; i < checkboxes.length; i++){
              
              if(checkboxes[i].get("v.checked")){
               console.log('check');
                  shiftIDS.push(checkboxes[i].get("v.name"));
               
              } 
            }
               /*
                    shiftIDS.push(checkboxes[i].get("v.name"));
                }else{
                    console.log('11: '+checkboxes[i].get("v.name"));
                }*/
           // }
        console.log('shiftIDS '+shiftIDS);
     //alert(shiftIDS[0]);
       // alert(shiftIDS[1]);
            helper.getShiftsFromIDs(component,shiftIDS);
            helper.approveshifts(component,helper);
            
   
       // component.find("selectAll").set("v.checked",false);
    },
    
     
   
})
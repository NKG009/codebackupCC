({
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    checkpermissionForAction : function(component,event,helper,selectedSiteid){
        console.log('getshifts permission');
        var action = component.get("c.checkPermissionToViewAction");
        action.setParams({
            "siteId": selectedSiteid
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state permission: '+JSON.stringify(state));
            if (state == "SUCCESS") {
                var respResult = response.getReturnValue();
                //    alert(respResult[0].IP_PortalType__c.includes("Hours Approver"));
                if(respResult[0].IP_PortalType__c.includes("Hours Approver")){
                       component.set('v.isConsultant',false);
                    console.log('Test false ');
              //      $('div[id="ConsultantOnDateScreen"]').attr("class","hideclass");
                //  $('div[id="SaveAllForConsultant"]').attr("style","hideclass");
                 $("#SaveAllForConsultant").hide();
                 //   document.getElementById("SaveAllForConsultant").style.display = "none"
                }
                else if(respResult[0].IP_PortalType__c == "Consultant"){
                      console.log('Test true ');
                       component.set('v.isConsultant',true);
               //     $('div[id="HoursApproverOnDateScreen"]').attr("class","hideclass");
                $("#approveAllForHoursApprover").hide();
                    document.getElementById("approveAllForHoursApprover").style.display = "none"
                }
                    else
                    {
                    $('th[id="actionHeaderOnDateScreen"]').attr("class","hideclass");
                     $('td[id="actionButtons"]').attr("class","hideclass");
                        //document.getElementById("approveAllForHoursApprover").style.display = "none"
                        //document.getElementById("SaveAllForConsultant").style.display = "none"
                    }
            }
        });
        
        $A.enqueueAction(action);
    },
    getShifts : function(component, event, helper) {
        var idparam = component.get("v.site");
        if(idparam == null || idparam == '')
        {
            idparam = this.getJsonFromUrl().site;
        }
        
        var action = component.get("c.getAllShifts");
        
        action.setParams({
            "site": idparam,
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
                $("#overlay").show();
                console.log('len in if');
                var dataTable = $('#tableId').DataTable();
                dataTable.destroy();
                setTimeout(function(){ 
                    $('#tableId').DataTable(
                        {
                            responsive:true,
                            aaSorting: [],
                            columnDefs: [
                                { "orderable": false,"targets": [0,4,5,8] },
                                
                            ]
                                }
                                );
                                
                                $("#overlay").hide(); }, 500); 
                                helper.checkpermissionForAction(component,event,helper,idparam);
                                
                                }
                                else
                                {
                                       console.log('len in ELSE');           
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                
                                'message': 'No shifts available for this search',
                                'mode' : 'pester',
                                'Duration': '50'
                                });
                                toastEvent.fire();
                              $("#overlay").show();
			   var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('isMobile '+isMobile);                             
			$("#overlay").show();
			var dataTable = $('#tableId').DataTable();
			dataTable.destroy();
			dataTable.clear();
            if (isMobile) {
                 setTimeout(function () {
				$('#tableId').DataTable({
					
					bPaginate: false,
                    paging : false, 
                    info : false,
					columnDefs: [{
							"visible": false,
							"targets": [0,3, 4, 5,6,7,8]
						},

					]
				});

				$("#overlay").hide();
			}, 1000);

                   }
                           else{
                        setTimeout(function () {
                            $('#tableId').DataTable({
                                responsive: true,
                                bPaginate: false,
                                paging : false, 
                                info : false,
                                aaSorting: [],
                                columnDefs: [{
                                        "orderable": false,
                                        "targets": [0, 4, 5,8]
                                    },
            
                                ]
                            });
            
                            $("#overlay").hide();
                        }, 1000);
                   }
                                }
                                
                                // component.set("v.maxPage", Math.floor((result.length+9)/10));
                                // helper.renderPage(component);  
                                
                                
                                });
                                
                                $A.enqueueAction(action); 
                                },
                                
                                
                    approveshifts : function(component,helper, page) {
                                
                                var check = component.get("v.isError");
                                   console.log('check '+check);
                                    console.log('check length: '+component.get("v.shiftsToBeApproved").length);
                            //     var shiftlist [] = component.get("v.shiftsToBeApproved");
                            //    console.log('list '+shiftlist);
                         		 var starttime ;
       							 var endtime ; 
                                             
            			
                        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
                              if(isMobile){
                           var record = component.get("v.shiftsToBeApproved");
                                 console.log('record# '+record[0].Id);
                          starttime =  $("#inputTimemob"+record[0].Id).attr("value");
       				      endtime =  $("#inputTime1mob"+record[0].Id).attr("value"); 
                          console.log('INstarttime endtime# '+starttime+endtime);  
                                             }
                                var timeblank =  component.get("v.timingblank");
                               console.log('IN timeblank#'+timeblank);          
                              if(component.get("v.shiftsToBeApproved").length <1){
                                //   console.log('IN IF approve');
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                
                                "message": "Please select atleast one shift to approve"
                                });
                                toastEvent.fire();
                                } 
                                else if( timeblank == true ||(isMobile && component.get("v.shiftsToBeApproved").length<2 && (starttime == '' || typeof starttime == 'undefined' || endtime == '' || typeof endtime == 'undefined'))){
                                 console.log('IN IF timings blank');
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                
                                "message": "Please ensure you have entered a start and end time for the shifts below",
                                'mode':'pester',
              					  'Duration': '50'
                                });
                                toastEvent.fire();
                                }
                                else{
                                
                                //    console.log('in ELSE');
                                
                                //		console.log('component.get("v.shiftsToBeApproved") '+ component.get("v.shiftsToBeApproved"));
                                var test = component.get("v.shiftsToBeApproved");
                                console.log('himanshu test'+JSON.stringify(test));
                                var action = component.get("c.getshift");
                                
                                action.setParams({
                                "JSONSHIFT" : JSON.stringify(component.get("v.shiftsToBeApproved"))
                                });
                                
                                action.setCallback(this, function(response) {
                                var result = response.getReturnValue();
                                console.log('himanshu result1: '+result);
                                var errors = response.getError();
                                console.log('errors: '+errors);
                                //      console.log(result+'result');
                                var state = response.getState();
                                
                                if (result == "Success"){
                                
                                
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                
                                "message": "Shift Approved",
                                'mode':'pester',
                                'Duration': '50',
                                'type':'Success'
                                });
                                toastEvent.fire();
                                //alert('comp');
                                // helper.getShifts(component, event, helper);
                                    if(isMobile){
                                        setTimeout(function(){ window.location.reload(); },5000);
                                      
                                       
                                    } 
                                }
                                else if (result == "Error") 	{
                                //        console.log('IN ERROR '); 
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                
                                "message": "There are some issues with the shift, please contact consultant",
                                "mode":"pester",
                                "Duration": "5000"
                                
                                });
                                toastEvent.fire();
                                }
                                else if (state === "INCOMPLETE") {
                                //     console.log('incomplete');
                                }
                                });
                                $A.enqueueAction(action);
                                //     console.log('approvestatus '+component.get("v.approvestatus"));
                                helper.getShifts(component, event, helper);
                                
                                }
                                },
                                
                                
                 getShiftsFromIDs : function(component,event, shiftIDs) {
                                
                                console.log('getShiftsFromIDs was called '+shiftIDs);
                                // alert('shiftIDs'+shiftIDs[0]);
                                var allShifts = component.get("v.shifts");
                                console.log('allShifts: '+allShifts);
                                var shiftToBeApproved = [];
                            var starthourList = component.get("v.starthour");
                            console.log('starthourList: '+starthourList);
                            var endhourList = component.get("v.endhour");
                            console.log('endhourList: '+endhourList);
                            
                            for (var j = 0; j < shiftIDs.length; j++) {
                            for (var i = 0; i < allShifts.length; i++) {
                            console.log('shiftIDs[j]: '+shiftIDs[j]);
                            console.log('allShifts[i].Id: '+allShifts[i].Id);
                            if(shiftIDs[j] == allShifts[i].Id){
                                 var starttime =  $("#inputTimemob"+allShifts[i].Id).attr("value");
       							 var endtime =  $("#inputTime1mob"+allShifts[i].Id).attr("value");  
            				  console.log('#### in starttime '+starttime); 
                              console.log('#### in endtime '+endtime);  
                               console.log('#### in component.get("v.HourStatus")  '+component.get("v.HourStatus") ); 
                               var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent); 
                            if(component.get("v.HourStatus") == true || ((starttime != component.get("v.starthour") || endtime != component.get("v.endhour")) && isMobile))
                            {
                              console.log('#### in starthour '+component.get("v.starthour")); 
                              console.log('#### in endhour '+component.get("v.endhour")); 
                       
                            if((component.get("v.starthour") == '' || typeof component.get("v.starthour") == 'undefined') && isMobile){
                            console.log('IN IF TIME ');
                                 allShifts[i].Starttime__c = starttime; 
                            allShifts[i].EndTime__c = endtime;
                             
                        
                        }
                            else{   console.log('IN else TIME ');
                           allShifts[i].Starttime__c = component.get("v.starthour"); 
                            allShifts[i].EndTime__c = component.get("v.endhour");
                             component.set("v.HourStatus",false); 
                        }
                           
                            
                         
                        }
                        else
                        {
                                   console.log('IN ELSE TIME '+component.get("v.approveAll"));
                       if((allShifts[i].sirenum__Actual_End_Time__c == '' || typeof allShifts[i].sirenum__Actual_End_Time__c == 'undefined' || allShifts[i].sirenum__Actual_Start_Time__c == '' || typeof allShifts[i].sirenum__Actual_Start_Time__c == 'undefined') && component.get("v.approveAll") == false){
                           console.log('IN timebalnk ');         
                           component.set("v.timingblank",true);  
                            }else{
                            allShifts[i].Starttime__c =allShifts[i].Starttime__c;
                      		allShifts[i].EndTime__c =  allShifts[i].EndTime__c;
                            }
                        }
                        
                        
                        //    console.log("matchediD"+allShifts[i].Id);         
                        shiftToBeApproved.push(allShifts[i]);
                }
                           }
                           }
                           //     console.log('shiftToBeApproved '+ shiftToBeApproved[0].Starttime__c+' $$ ' +shiftToBeApproved[0].EndTime__c);
                           component.set("v.shiftsToBeApproved",shiftToBeApproved);
                          // component.set("v.HourStatus",false); 

                console.log("v.shiftsToBeApproved: "+component.get('v.shiftsToBeApproved'));
            },
                saveShifts : function(component,helper, page) {
                    console.log('save shifts is called');
                    var check = component.get("v.isError");
                    if(component.get("v.shiftsToBeApproved").length <1){
                           console.log('IN IF approve');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            
                            "message": "Please select atleast one shift to save"
                        });
                        toastEvent.fire();
                    }
                    else if(check == true){
                        //  console.log('IN IF ');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            
                            "message": "Timings can not be blank"
                        });
                        toastEvent.fire();
                    }
                        else{
                            
                            //    console.log('in ELSE');
                            
                            //		console.log('component.get("v.shiftsToBeApproved") '+ component.get("v.shiftsToBeApproved"));
                            var test = component.get("v.shiftsToBeApproved");
                            console.log('himanshu test'+JSON.stringify(test));
                            var action = component.get("c.CallSaveShiftDB");
                            
                            action.setParams({
                                "JSONSHIFT" : JSON.stringify(component.get("v.shiftsToBeApproved"))
                            });
                            
                            action.setCallback(this, function(response) {
                                var result = response.getReturnValue();
                                console.log('himanshu result2: '+result);
                                var errors = response.getError();
                                console.log('errors: '+JSON.stringify(errors));
                                //      console.log(result+'result');
                                var state = response.getState();
                                
                                if (result == "Success"){
                                    
                                    
                                    
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        
                                        "message": "Shift saved",
                                        'mode':'pester',
                                        'Duration': '5000',
                                        'type':'Success'
                                    });
                                    toastEvent.fire();
                                    //alert('comp');
                                    // helper.getShifts(component, event, helper);
                                    
                                }
                                else if (result == "Error") 	{
                                    //        console.log('IN ERROR '); 
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        
                                        "message": "There are some issues with the shift, please contact consultant",
                                        "mode":"pester",
                                        "Duration": "5000"
                                        
                                    });
                                    toastEvent.fire();
                                }
                                    else if (state === "INCOMPLETE") {
                                        //     console.log('incomplete');
                                    }
                                component.set('v.checkforchange',false);
                            });
                            $A.enqueueAction(action);
                            //     console.log('approvestatus '+component.get("v.approvestatus"));
                            helper.getShifts(component, event, helper);
                            
                        }
                }   ,
                    getShiftsFromIDsforSave : function(component,event, shiftIDs) { 
                                 
                                console.log('getShiftsFromIDs was calledsave '+shiftIDs);
                       
                        // alert('shiftIDs'+shiftIDs[0]);
                                var allShifts = component.get("v.shifts");
                //  console.log(' shiftIDs '+shiftIDs.length+'  $ '+allShifts.length);
                   
                     //   console.log('allShifts: '+JSON.stringify(allShifts));
                     //   console.log('shiftIDs: '+JSON.stringify(shiftIDs));
                                var shiftToBeApproved = [];
                                   for (var j = 0; j < shiftIDs.length; j++) {
                            for (var i = 0; i < allShifts.length; i++) { 
                         console.log('getShiftsFromIDs shiftIDs '+shiftIDs[j].id+' '+allShifts[i].Id);
                            if(shiftIDs[j] == allShifts[i].Id){ 
                            var startTime = document.getElementById("actualStart"+shiftIDs[j]).innerText; 
                        console.log("startTime "+startTime);
                        var endTime = document.getElementById("actualEnd"+shiftIDs[j]).innerText; 
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
                        
                        //    console.log("matchediD"+allShifts[i].Id);         
                        
                }
                           }
                           }
                           //     console.log('shiftToBeApproved '+ shiftToBeApproved[0].Starttime__c+' $$ ' +shiftToBeApproved[0].EndTime__c);
                           component.set("v.shiftsToBeApproved",shiftToBeApproved);
               // console.log("v.shiftsToBeApproved: "+component.get('v.shiftsToBeApproved'));
            }
                     
            
        })
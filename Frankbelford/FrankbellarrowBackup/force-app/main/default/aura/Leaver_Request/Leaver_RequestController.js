({
	doInit : function(component, event, helper) {
        //component.set("v.processingStatus", true);
        component.set("v.selectedContactId",component.get("v.recordId"));
        console.log('+++tttttttttt+++'+component.get("v.selectedContactId"));
		helper.getTimesheetLines(component);
		helper.getShifts(component);
        var action = component.get("c.getContact");
        action.setParams({"contactId": component.get("v.recordId")});
		
		var shiftnames = []; 
		var timesheetnames = []; 
		var timeresults = [];
        
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
             console.log('+++state+++'+state);
            if(state === "SUCCESS") {
				var records = response.getReturnValue();
				component.set("v.singleRec", records);
                var suppreason = component.get("v.singleRec.P45_Suppression_Reason__c");
                var count = component.get("v.singleRec.IP_Allpayprofiles__c");
                console.log('+++suppreason+++'+suppreason);
                if(suppreason == 'Not Suppressed' || suppreason == '' || suppreason == undefined){
                    if(count>0){
                        if(count==1){                            
							var timesheetList = component.get("v.timesheetLinesList");
							console.log('+++timesheetList+++'+timesheetList+'+++++++++++++timesheetListLength+++++++++'+timesheetList.length);
							
							var shiftList = component.get("v.shiftsList");
							console.log('+++shiftList+++'+shiftList+'+++++++++++++shiftListLength+++++++++'+shiftList.length);
							
							if(shiftList.length > 0 || timesheetList.length >0){
								for(var i=0;i<shiftList.length;i++){
									var name = shiftList[i].Name;
									shiftnames.push(name); 
								}
								component.set("v.shiftnames", shiftnames);
								console.log('+++393939339+++'+component.get("v.shiftnames"));
								
								if(timesheetList.length == 1){
									for(var i=0;i<timesheetList.length;i++){ 
										var name1 = timesheetList[i].sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c; 

										timesheetnames.push(name1);
										timeresults.push(name1); 
									}
									component.set("v.timeresults", timeresults);
									console.log('+++484848448+++'+component.get("v.timeresults"));
								}
								else{
									for(var i=0;i<timesheetList.length;i++){ 
										var name1 = timesheetList[i].sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c;
										timesheetnames.push(name1);
									}	

									for (var i = 0; i <= timesheetnames.length - 1; i++) {
										if (timesheetnames[i + 1] != timesheetnames[i]) {
											timeresults.push(timesheetnames[i]);
										}
									}
									component.set("v.timeresults", timeresults);
									console.log('+++6363636336+++'+component.get("v.timeresults"));
								}
								
								if(shiftList.length>0 && timesheetList.length>0){
									component.set("v.pendingPayroll",true);
									component.set("v.pendingPayrollTimesheet",false);
									component.set("v.activeShift",false);
								}
								else if(shiftList.length>0){
									component.set("v.activeShift",true);
									component.set("v.pendingPayroll",false);
									component.set("v.pendingPayrollTimesheet",false);
								}
								else{
									component.set("v.pendingPayrollTimesheet",true);
									component.set("v.activeShift",false);
									component.set("v.pendingPayroll",false);
								}
							}
							else{
                                component.set("v.openCaptureReasonforLeaving",true);
								//window.open('/apex/CaptureReasonforLeaving?id={!v.recordId}', '_blank', 'height=550,width=800,resizable=yes,scrollbars=yes,toolbar=n??o,menubar=no');
							}							
                        }
                        else{
                            component.set("v.openCandidateP45Action",true);
                            //window.open('/apex/CandidateP45Action?id={!v.recordId}', '_blank', 'height=550,width=800,resizable=yes,scrollbars=yes,toolbar=n??o,menubar=no');
                        }
                    }
                    else{
                        component.set("v.payProfileNotActive",true);
                    }
                }
                else{
                    component.set("v.candidateSuppressed",true);
                }
                
            } else {
                
            }
        });
        $A.enqueueAction(action);
	}
})
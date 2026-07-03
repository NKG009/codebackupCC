({  
    doInit: function(component, event, helper) {
         var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if(isMobile){
            console.log('css mobile');
          $('.custom-accordian.panel-default:first-child').hide();
            $('.custom-accordian.panel-default:first-child').css('display','block');
      
        }
        var selectedSiteid = component.get("v.site");
        if (selectedSiteid == undefined) {
            var url_String = document.URL;
            var url = new URL(url_String);
            selectedSiteid = url.searchParams.get('site');
        }
        var result = component.get("v.ShiftList");
        //console.log('samasya ki jad: '+JSON.stringify(result));
        helper.checkpermissionForAction(component, event, helper, selectedSiteid); // JPC-1919
        if (result.length > 0) {
            
            component.set("v.totalPages", Math.ceil(result.length / component.get("v.pageSize")));
            component.set("v.currentPageNumber", 1);
            
            component.set("v.Pagination", true);
            if (component.get("v.totalPages") > 1) {
                component.set("v.OnePage", true);
            } else {
                component.set("v.OnePage", false);
            }
            helper.buildData(component, helper);
        } else {
            component.set("v.Pagination", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                
                'message': 'No shifts available for this search',
                
                'Duration': '1000'
            });
            toastEvent.fire();
            component.set("v.Paginationshifts", component.get("v.shifts"));
        /*    setTimeout(function() {
                $('.tableId').DataTable();
                responsive: true
                $("#overlay").hide();
            }, 2000);*/
            	setTimeout(function () {
					$('.tableId ').DataTable({
						responsive: true
					});

					$("#overlay").hide();
				}, 500);
            
        }
        
        /*component.set("v.Paginationshifts",component.get("v.shifts"));
         setTimeout(function(){ 
                    $('#tableId').DataTable();
                    responsive: true
                }, 500);*/
        
        component.set("v.maxPage", Math.floor((result.length + 9) / 10));
        // helper.renderPage(component);
        
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    
    ApproveAllCand: function(component, event, helper) {
        var target = event.target.id;
        var toastEvent = $A.get("e.force:showToast");
        var shiftCondtIdandShift = target.split('-');
        helper.getShiftsCalledFromApploveAllCandidate(component, target);
        helper.approveAllCandidateshifts(component, helper);
        
    },

    rejectAllShifts: function(component, event, helper) {
        component.set("v.isOpenCancel", true);
        var target = event.target.id;
        component.set("v.candidateIdForRejectAllFeature", target);
    },

    RejectAllCand: function(component, event, helper) {
        var rejectionComment = component.find("rejectAllQuery").get("v.value");
        if(!rejectionComment) {
            alert('Please provide rejection reason.');
            return;
        }

        var target = component.get("v.candidateIdForRejectAllFeature");
        
        var action = component.get("c.approveallshift");
        action.setParams({
            "candID": target,
            "state": "reject",
            "rejectionComments": rejectionComment
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (result == "Success") {
                toastEvent.setParams({
                    "type": "Success",                    
                    "message": "Shifts rejected successfully.",
                });
                
                toastEvent.fire();
                helper.GetAllShift(component, event, helper);
            } else {
                toastEvent.setParams({
                    "type": "error",
                    "mode": "sticky",
                    "message": result
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.ShiftList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        
        var whichBtn = event.getSource().get("v.name");
        
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        } else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
    
    approve: function(component, event, helper) {
        component.set("v.approvestatus", false);
        var target = event.target.id;
        console.log('target: '+target);
        var shifttIds = [];
        shifttIds.push(component, target);
         var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "message": "Your shift approval request has been received, the below screen will update shortly",
                        'mode': 'pester',
                        'Duration': '50',
                        'type': 'Success'
                    });
                    toastEvent.fire();
        helper.getShiftsFromIDs(component, shifttIds);
        helper.approveshifts(component, helper);
        
    },
    
    reject: function(component, event, helper) {
        var idToBeCancelled = event.target.id;
        var array = idToBeCancelled.split("-");
        var Candidatelist = component.get("v.ShiftList");
        
        var shiftList;
        
        for (var i = 0; i < Candidatelist.length; i++) {
            if (Candidatelist[i].CandidateId == array[1]) {
                shiftList = Candidatelist[i].shiftInfo;
                break;
            }
        }
        
        for (var i = 0; i < shiftList.length; i++) {
            if (shiftList[i].Id == array[0]) {
                
                component.set("v.cancelledshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
                break;
            }
        }
    },
    
    closeModelCancel: function(component, event, helper) {
        component.set("v.isOpenCancel", false);
    },
    
    submitReject: function(component, event, helper) {
        var rejectionComment = component.find("Query").get("v.value");
        if(!rejectionComment) {
            alert('Please provide rejection reason.');
            return;
        }

        component.set("v.isOpenCancel", false);
        var action = component.get("c.SendRejectionToOwner");
        var comments = component.find("Query").get("v.value");
        
        var shift = component.get("v.cancelledshift")[0];
        var id = shift.Id;
        var combinedComment = 'Shift Number- ' + shift.Name + ' Site-' + shift.sirenum__Site__r.Name + ' Job Role-' + shift.sirenum__Team__r.Name;
        
        action.setParams({
            'shiftID': id,
            'comments': comments,
            'combinedComment': combinedComment
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                //helper.GetAllShift(component, event, helper);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "Shift rejected successfully",
                    "type": "Success"
                });
                toastEvent.fire();
                component.set("v.isOpenQuery", false);
            } else {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "There is some issues while submitting. Please contact your consultant"
                });
                toastEvent.fire();
                component.set("v.isOpenQuery", false);
            }
        });
        $A.enqueueAction(action);
        console.log('component.get("v.site") ' + component.get("v.site"));
        var shifttIds = [];
        shifttIds.push(id);
        helper.GetAllShift(component, event, helper);
        
    },
    
    UpdateActualTimes: function(component, event, helper) {
        var shifts = component.get("v.shifts");
        var recordId = event.getParam("recordID");
        var start = event.getParam("start");
        console.log('start: '+start);
        var end = event.getParam("end");
        console.log('end: '+end);
        component.set("v.starthour", start);
        component.set("v.endhour", end);
       // component.set("v.HourStatus", true);
         if(start != '' && end != ''){
             component.set("v.HourStatus",true);
        }
        if (start == '' || end == '') {
            component.set("v.isError", true);
        } else {
            component.set("v.isError", false);
            component.set("v.shifts", shifts);
        }
        console.log('flag check error: '+component.get("v.isError"));
    },
    
    onNext: function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.buildData(component, helper);
    },
    
    onPrev: function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.buildData(component, helper);
    },
    
    processMe: function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    /*
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    */
    
    collapseTable : function(component, event, helper) {  
        var x = document.getElementById("shiftContent");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    },
    
    toggleCollapsedClass : function(component, event, helper){ 
        // var toggleText = component.find("togglePannelId");
        var toggleText = document.getElementById("togglePannelId");
        // alert('test=='+toggleText);{!'collapseOne'+(i)}
        $A.util.toggleClass(toggleText, "collapsed");
        alert('hi');
        var toggleClass = document.getElementById("collapseOne0");
        alert('==='+toggleClass);
        $A.util.toggleClass(toggleText, "in");
    },
    poSubmit : function(component, event, helper){ 
        // var sObjectList = component.get("v.InvoicePo");
        var ctarget = event.currentTarget;
        var shiftId = ctarget.dataset.value;
        var getCurrentRecId = event.target.id;
        
        var selectInvoicePoValue = document.getElementById(getCurrentRecId).value;
        console.log(shiftId);
        console.log(selectInvoicePoValue);
        var action = component.get('c.SubmitInvoicePODB');
        action.setParams({ shiftId : shiftId,
                          InvoicePO : selectInvoicePoValue});
        //window.alert('called');
        action.setCallback(this,function(response){
            var state = response.getState();
            var errorformat = response.getReturnValue();
            if(component.isValid() && state === "SUCCESS"){
                if(response.getReturnValue() === "success"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester',
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();
                    
                    //window.location.reload();
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Please enter Invoice PO in following format "+errorformat
                    });
                    toastEvent.fire();
                    document.getElementById(getCurrentRecId).value = "";
                    //window.location.reload();
                    //   setTimeout(function() { window.location=window.location;},2000);
                }
                
            }
            
        });
        component.set("v.spinner", true); 
        $A.enqueueAction(action);
        //window.refresh();
        
    },
    poReadonly : function(component, event, helper){ 
        var ctarget = event.currentTarget;
        var shiftId = ctarget.dataset.value;
        //document.getElementById(shiftId).removeAttribute("class");
    },
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        //component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    save: function(component, event, helper) {
        component.set("v.approvestatus", false);
        var target = event.target.id;
        console.log('target: '+target);
        var shifttIds = [];
        shifttIds.push(component, target);
        console.log('i was here '+component.get('v.checkforchange'));
        if(component.get('v.checkforchange') == false){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                
                'message': 'No changes have been made to this shift, please update before selecting save',
                'mode':'pester',
                'Duration': '5000',
                'type':'Error'
            });
            toastEvent.fire();
        }
        else{
            helper.getShiftsFromIDs(component, shifttIds);
            helper.saveShifts(component, helper);
            
        }
        
    },
    saveAllCand: function(component, event, helper) {
        var target = event.target.id;
        var toastEvent = $A.get("e.force:showToast");
        var shiftCondtIdandShift = target.split('-');
        console.log('shiftCondtIdandShift:  '+target)
        if(component.get('v.checkforchange') == true){
            helper.getAllShiftsForACandidate(component, target);
            console.log(component.get('v.startendBlank') );
            if(component.get('v.startendBlank') == false){
                helper.saveAllShiftsForAcandidate(component, helper); 
            }
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                
                'message': 'No changes have been made to this shift, please update before selecting save',
                'mode':'pester',
                'Duration': '5000',
                'type':'Error'
            });
            toastEvent.fire();
        }
        
        
        
    },
    handleIfChangesMade: function(component, event, helper) {
        console.log('this was called ');        
        //console.log('checkforchange 472: '+component.get('checkforchange'));
        var isChanged = event.getParam("isChanged");
        console.log('isChanged 474: '+isChanged);
        if(isChanged == undefined){
            console.log('in if ');
            component.set('v.checkforchange',false);
            var thisvar = component.get('v.checkforchange');
            console.log('checkforchange: '+thisvar);
        }
        else{
            console.log('in else ');
            component.set('v.checkforchange',isChanged);  
        }
        
        
    }
})
({
    helperscriptload : function(component,event,helper){
        setTimeout(function(){ 
            $('.searchDetail_table').on('click', '.edit_action', function () {
                console.log('tr@@ 12');
                var tr = $(this).closest('tr');
                if ( $(tr).hasClass('child') ) {
                    var Id=$(this).attr('id');
                    console.log(Id);
                    helper.CompetenciesDetailsHelper(component,Id);
                    helpercloseModelCancel(component, event, helper)
                }
                
            } );
            $('.searchDetail_table').on('click', '.action-button', function () {
                console.log('tr@@ 12');
                var tr = $(this).closest('tr');
                if ( $(tr).hasClass('child') ) {
                    var Id=$(this).attr('id');
                    console.log(Id);
                    helper.helperReject(component,Id,helper);
                    helpercloseModelCancel(component, event, helper)
                }
                
            } );
        },1000);
    }, 
    helperReject : function(component,Id,helper){
        
        var target = Id;
        var selectedContact = target;//.get("v.value");
        console.log('target in helper'+target);
        var action = component.get("c.rejectToGetPhoneEmail");
        action.setParams({"shiftId":selectedContact});
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            console.log(response.getState()+'==result=='+result.Phone__c);
            component.set("v.phoneNumber", result.Phone__c);
            component.set("v.emailAdd", result.Email__c);
        });
        $A.enqueueAction(action);
        
    },
    helpercloseModelCancel: function(component, event, helper) {
        
    },
    getSiteList :function(component) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
         component.set("v.site", siteRecId); 
        
        var sitesList = component.get('c.getSitesOfLoggedInUser');		
        sitesList.setCallback(this, function(response){
            var optsSite = [];
            var siteID;
            var flag = 0;
            var state = response.getState();
            if(component.isValid() && state == 'SUCCESS'){
                var SiteArray = response.getReturnValue();    
                for (var i = 0; i < SiteArray.length; i++) {
                    if(SiteArray[i].Id==siteRecId){
                        flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                        siteID = siteRecId;
                    }else{
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                            
                        });
                    }
                }
                if(flag==0){
                    console.log('flag: '+flag+' optsSite[0].Id: '+optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }
            }
            
            component.set("v.siteList",optsSite);
            component.set("v.selectedSite",selectId);
            
            
        });        
        $A.enqueueAction(sitesList);
    },
    
    getLoggedInUserName :function(component){
        var fetchUserName = component.get("c.fetchUser");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            console.log(' in state '+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },
    
    
    getsitejobrole: function(component){
        
        console.log(' in getsite ');
        var idParam = this.getJsonFromUrl().site;
        var selectedsite = component.get("v.selectedSite");
        var sendSite;
        if (selectedsite == null) {
            sendSite = idParam;
        } else {
            sendSite = selectedsite;
        }
        var jobRole = component.get("c.getJobRoleList");
        jobRole.setParams({
            "siteId": sendSite
        });
        jobRole.setCallback(this, function(response) {
            console.log('testingh'+response.getState());
            var state = response.getState();
            var optsJob = [];
            if(component.isValid() && state == "SUCCESS") {
                var jobrolearray = response.getReturnValue();
                console.log('check site array'+jobrolearray);
                optsJob.push({
                    class: "optionClass",
                    label: "Select Job Role",
                    value: ""
                });
                for (var i = 0; i < jobrolearray.length; i++) {
                    optsJob.push({
                        class: "optionClass",
                        label: jobrolearray[i].Name,
                        value: jobrolearray[i].Id
                        
                    });
                    
                }
                
                component.set("v.jobSiteList", optsJob);               
            }
        });
        console.log('jobRole'+jobRole);
        $A.enqueueAction(jobRole);
    },
    
    SiteCandidatesHelper : function(component) {
        console.log('Test contact');
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        var selectedsite = component.get("v.selectedSite");
        var finalsite;
        if(selectedsite == null){
            finalsite = siteRecId;
        }
        else{
            finalsite =  selectedsite;
        }
        console.log('=finalsite==='+finalsite);
        var candidateList = component.get('c.getCandidateListLoggedInUser');
        //  var defaultSiteSelected = component.find("siteId").get("v.value");
        candidateList.setParams({
            "siteId" : finalsite,
        });
        candidateList.setCallback(this,function(response){
            var optCandidate = [];
            var siteCandidateArray = response.getReturnValue();
            var state = response.getState();
            if(component.isValid() && state == 'SUCCESS'){
                optCandidate.push({
                    label:"Select Temp",
                    value:""
                });
                for(var i=0;i<siteCandidateArray.length;i++){
                    optCandidate.push({
                        label:siteCandidateArray[i].Name,
                        value:siteCandidateArray[i].Id
                    });
                }
            }else{
                alert('errror');
            }
            console.log('==optCandidate='+optCandidate);
            component.set("v.candidateNameList",optCandidate);
        });
        
        $A.enqueueAction(candidateList);
        
        // this.getShiftsOnLoad(component);
    },
    
    searchShiftsHelper :function(component) {
        var selectedsiteId =  component.get("v.selectedSite");
        if(selectedsiteId == '' || selectedsiteId == 'Undefined' || selectedsiteId ==null)
        {
            console.log('null');
            selectedsiteId = this.getJsonFromUrl().site;  
        }
        console.log('selectedsiteId'+selectedsiteId);
        var selectedjobRoleIdValue = component.find("jobRoleId").get("v.value");
        if(selectedjobRoleIdValue == '' || selectedjobRoleIdValue == 'Undefined')
        {
            selectedjobRoleIdValue = null;
        }
        var selectedcandidateIdValue = component.find("candidateId").get("v.value");
        if(selectedcandidateIdValue == '' || selectedcandidateIdValue == 'Undefined')
        {
            selectedcandidateIdValue = null;
        }
        var selectedTimePeriodValue = document.getElementById("timePeriod").value;//component.find("timePeriod").get("v.value");
        if(selectedTimePeriodValue == '' || selectedTimePeriodValue == 'Undefined')
        {
            selectedTimePeriodValue = null;
        }
        console.log('selectedjobRoleIdValue  '+selectedjobRoleIdValue);
        var searchAllPastShifts = component.get("c.getAllFutureShifts");
        searchAllPastShifts.setParams({
            "site" : selectedsiteId,
            "jobrole" : selectedjobRoleIdValue,
            "candidateId" : selectedcandidateIdValue,
            "timeframe" : selectedTimePeriodValue
        });
        searchAllPastShifts.setCallback(this,function(response){
            var result = response.getReturnValue();
            
            var currentList = result;
            console.log('result '+result.length);
            component.set("v.allshifts", currentList);
            component.set("v.shifts", currentList);
            var checkval = component.get("v.checkSearch");
            if(result.length>0){
                $("#overlay").show(); 
                if(checkval == true)
                {
                    component.set("v.checkparam",false);
                    
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();
                    
                    setTimeout(function(){ 
                        $('#tableId').DataTable({responsive: true,
                                                 aaSorting: [],
                                                 
                                                });
                        
                        $("#overlay").hide();    }, 600); 
                }
                else
                {
                    
                    setTimeout(function(){ 
                        $('#tableId').DataTable({responsive: true,
                                                 aaSorting: [],
                                                 
                                                });
                        
                        $("#overlay").hide();   }, 600); 
                }
                
                
            }
            else
            {
                component.set("v.Spinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    
                    'message': 'No shifts available for this search',
                    
                    'Duration': '500'
                });
                toastEvent.fire();
                console.log('no returned');
                component.set("v.checkparam",true);
                
                var dataTable = $('#tableId').DataTable();
                $('.dataTables_paginate').hide();
                $('.dataTables_info').hide();
                
                
                
            } 
            
        });
        $A.enqueueAction(searchAllPastShifts);
    },
    
    renderPage: function(component) {
        console.log('in render');
        var records = component.get("v.shifts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        console.log('pageRecordsmax page '+ component.get("v.maxPage"));
        component.set("v.currentList", pageRecords);
    },
    
    getShiftsOnLoad: function(component){
        console.log('get shift data ');
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        var selectedsite = component.get("v.selectedSite");
        var finalsite;
        if(selectedsite == null)
        {finalsite = siteRecId;
        }
        else
        {
            finalsite =  selectedsite;
        }
        
        var searchAllPastShifts = component.get("c.getAllFutureShifts");
        searchAllPastShifts.setParams({
            "site" : finalsite,
            "jobrole" : null,
            "candidateId" : null,
            "timeframe" : null
        });
        searchAllPastShifts.setCallback(this,function(response){
            var result = response.getReturnValue();
            
            var currentList;
            currentList = result;     
            
            console.log('result.length outer'+result.length);
            var checkval = component.get("v.checkSearch");
            component.set("v.maxPage", Math.floor((result.length+9)/10));
            console.log('++++++++++++'+Math.floor((result.length+9)/10));
            component.set("v.allshifts", currentList);
            component.set("v.shifts", currentList);
            if(result.length>0){
                $("#overlay").show(); 
                if(checkval == true)
                {
                    component.set("v.checkparam",false);
                    
                    var dataTable = $('#tableId').DataTable();
                    $('.dataTables_empty').hide();
                    dataTable.destroy();
                    
                    setTimeout(function(){ 
                        $('#tableId').DataTable({responsive: true,
                                                 "aaSorting": [],
                                                });
                        
                        $("#overlay").hide();  }, 600); 
                }
                else
                {
                    
                    setTimeout(function(){ 
                        $('#tableId').DataTable({responsive: true,
                                                 "aaSorting": [],
                                                });
                        
                        $("#overlay").hide();  }, 600); 
                }
                
                
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    
                    'message': 'No shifts available for this search',
                    
                    'Duration': '500'
                });
                toastEvent.fire();
                console.log('no returned');
                component.set("v.checkparam",true);
                
                var dataTable = $('#tableId').DataTable();
                $('.dataTables_paginate').hide();
                $('.dataTables_info').hide();
            } 
            
            
        });
        $A.enqueueAction(searchAllPastShifts);
    },
    
    CompetenciesDetailsHelper : function(component,Id,helper){
        //var selectedContact = Id;//target.get("v.value");
        var selectedShift = Id;
        //console.log('in helper class '+selectedContact);
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');
        var selectedsite = component.get("v.selectedSite");
        var finalsite;
        if(selectedsite == null){
            finalsite = siteRecId;
        }
        else{
            finalsite =  selectedsite;
        }*/
        var compresult = component.get("c.getContactCompetencies");        
        compresult.setParams({
            "shiftId" : selectedShift
        });   
        
        compresult.setCallback(this,function(response){
            
            var result = response.getReturnValue();
            if(result.length >0){  
                console.log('in helper result '+result);
                component.set("v.CompetenciesList", result);
                component.set("v.checkCompetencies", true);
            }else{
                component.set("v.checkCompetencies", false);
                console.log('in helper 0 result '+result); 
            }
            
            //component.set("v.CompetenciesList", result);
        });
        
        $A.enqueueAction(compresult);
        
        
        
        
    },
    
    
    RejectHelper : function(component,event){
        component.set("v.Spinner",false);
        var target = event.target.id;
        var selectedContact = target;//.get("v.value");
        var action = component.get('c.rejectToGetPhoneEmail');
        action.setParams({
            "contactId"      : selectedContact,
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            console.log(response.getState()+'==result=='+result);
            component.set("v.phoneNumber", result.Phone__c);
            component.set("v.emailAdd", result.Email__c);
        });
        $A.enqueueAction(action);
    },
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            //if (objectRecords == null) {
            return null;
        }
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['Temp Name','Job Role','Start Date','End Date','Start Time','End Time'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ; 
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                if(skey==='Temp Name') {
                    csvStringResult += '"'+ objectRecords[i]['sirenum__Contact__r']['Name']+'"';                     
                }
                if(skey=='Job Role'){
                    csvStringResult += '"'+ objectRecords[i]['sirenum__Team__r']['Name']+'"';
                }
                if(skey=='Start Date'){
                    csvStringResult += '"'+ objectRecords[i]['Scheduled_Start_Date_Text__c']+'"';
                }
                if(skey=='End Date'){
                    csvStringResult += '"'+ objectRecords[i]['Scheduled_End_Date_Text__c']+'"';
                }
                if(skey=='Start Time'){
                    csvStringResult += '"'+ objectRecords[i]['Scheduled_Start_Time_Text__c']+'"';
                }
                if(skey=='End Time'){
                    csvStringResult += '"'+ objectRecords[i]['Scheduled_End_Time_Text__c']+'"';
                }
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;        
    }
})
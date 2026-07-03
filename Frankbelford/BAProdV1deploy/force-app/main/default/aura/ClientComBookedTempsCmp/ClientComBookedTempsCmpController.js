({
    doInit : function(component, event, helper) {
        helper.getLoggedInUserName(component);
        helper.SiteCandidatesHelper(component);
        helper.getsitejobrole(component);
        helper.getShiftsOnLoad(component);   
        helper.getSiteList(component);		
        
    },
    onChange : function (component, event, helper) {
        console.log('Site change captured - loading data...');
        var selectedSite = event.getParam("selectedSiteId");
        console.log('Current Site >> ' + component.get('v.site') + " change handler newly selected site >> " + selectedSite);
        component.set("v.site", selectedSite);
        component.set("v.selectedSite", selectedSite);

        component.set("v.checkparam", false);
        helper.getShiftsOnLoad(component);

        var dataTable = $('#tableId').DataTable();
        dataTable.show();
        $('.dataTables_paginate').show();
        $('.dataTables_info').show();
    },
    myrates: function(component, event, helper){
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"rateinfo?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    resetAllValues : function(component,event,helper){
        console.log('reset ');
        if(component.get("v.selectedjobrole") != null || component.get("v.timeperiodselected") !=null || component.find("candidateId").get("v.value") != null) {
            component.set("v.selectedjobrole", null);
            component.set("v.timeperiodselected", null);

            component.find("jobRoleId").set("v.value",'');
            component.find("candidateId").set("v.value",'');
            document.getElementById("timePeriod").value =null;
            component.set("v.checkSearch",true)
            helper.getShiftsOnLoad(component);
        }
    },
    clearvalue :function(component, event, helper) {
        component.find("jobRoleId").set("v.value",null);
        component.find("candidateId").set("v.value",null);
        component.set("v.timeperiodselected",null);
        component.find("timePeriod").set("v.value",null);
    },
    siteChanged :function(component, event, helper) {
        component.set("v.checkSearch",true)
        component.set("v.selectedSite", component.find("siteId").get("v.value"));
        component.set("v.selectedjobrole", component.find("jobRoleId").get("v.value"));
        var x =  document.getElementById("timePeriod").value;
        component.set("v.timeperiodselected", x)
        component.set("v.site", component.find("siteId").get("v.value"));
        helper.SiteCandidatesHelper(component);
        helper.searchShiftsHelper(component);
        helper.getsitejobrole(component);
    },
    searchShifts : function(component, event, helper){
        console.log('search shift');
        component.set("v.checkSearch",true)
        helper.searchShiftsHelper(component, event, helper);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    
    closeModelCancel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        //   component.set("v.isOpenCancel", false);
        //   component.set("v.Spinner",false);
    },
    CompetenciesDetails : function(component, event, helper){
        component.set("v.Spinner",false);
        var Id = event.target.id;
        
        helper.CompetenciesDetailsHelper(component,Id,helper);
        
    },
    
    Reject : function(component, event, helper){
        component.set("v.Spinner",false);
        var Id = event.target.id;
        //  helper.RejectHelper(component, event);
        helper.helperReject(component,Id,helper);
    },
    dashboardNavigate: function(component, event, helper) {
        event.preventDefault();
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        var urlRedirect = baseURL + '?site=' + component.get("v.site");
        window.location.replace(urlRedirect);
        return false;
    },
    scriptsLoaded: function (component,event, helper) {
        console.log('in ');
        helper.helperscriptload(component,event,helper);
        console.log('in asscript'); 
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {//alert('2222');
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    handleOnClick : function(component, event, helper) {
        event.preventDefault();
        return false;
    }, 
    handleKeyPress : function(component, event, helper) {
        event.preventDefault();
        return false;
    },
    handleMouseEnter : function(component, event, helper) {
        event.preventDefault();
        return false;
    },   
    downloadCsv : function(component,event,helper){
        var stockData = component.get("v.shifts");
        if(stockData.length>0){
            var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
            if (csv == null){
                return;
            }
            if(navigator.msSaveBlob) { // IE 10+
                console.log('navigator');
                var blob = new Blob([csv], {
                    "type": "text/csv;charset=utf8;"          
                });
                navigator.msSaveBlob(blob, 'ExportData.csv');
            } else {
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                hiddenElement.target = '_self'; 
                hiddenElement.download = 'ExportData.csv'; 
                document.body.appendChild(hiddenElement); 
                hiddenElement.click();
        	}
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                'message': 'No Record available for export',
                'Duration': '200'
            });
            toastEvent.fire();
        }
    }
})
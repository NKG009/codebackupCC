({
    doInit: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
        var idParam = helper.getJsonFromUrl().site;
        component.set("v.site", idParam);
        component.set("v.selectedSite", idParam);
        
        helper.doGetAllShifts(component, event);
    },
    
    dashboardNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    
    keyCheck: function (component, event, helper) {
        if (event.which == 13) {
            event.preventDefault();
            var param = component.get('v.site');
            component.set("v.selectedSite", param);
            var cand = component.find('candinput').get('v.value');
            console.log('cand ' + cand);
            //  helper.dosearch(component);
        }
    },
    
    search: function (component, event, helper) {
        component.set("v.candidateId", component.find("selectedCandidate").get("v.value"));
        helper.doGetAllShifts(component, event);
        
    },
    
    resetAllValues: function (component, event, helper) {
        component.set("v.candidateId", undefined);
        helper.doGetAllShifts(component, event);
    },
    
    onNext: function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber") + 1;
        if(pageNumber <= component.get("v.totalPages")){
            component.set("v.currentPageNumber", pageNumber);
            helper.buildData(component, helper);
        }
    },
    
    onPrev: function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber") - 1;
        if(pageNumber >= 1) {
            component.set("v.currentPageNumber", pageNumber);
            helper.buildData(component, helper);
        }
    },
    
    processMe: function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onChange: function (component, event, helper) {
        var site = event.getParam("selectedSiteId");
        console.log('site ' + site);
        component.set("v.site", site);
        component.set("v.selectedSite", site);
        
        component.set("v.candidateId", undefined);
        helper.doGetAllShifts(component, event);
    },
    
    // this function automatic call by aura:waiting event
    showSpinner: function (component, event, helper) {//alert('2222');
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    },
    
    downloadCSV: function (component, event, helper) {
        var allShiftRecords = component.get("v.ShiftList");
        if(allShiftRecords.length > 0) {
            helper.showToast(component, event, "success", "Found " + allShiftRecords.length + " shift records. Please hold tight while downloading!");
            
            var csv = helper.convertArrayOfObjectsToCSV(component, allShiftRecords);
            if(csv == null) {
                return;
            }

            // IE 10+
            if(navigator.msSaveBlob) {
                console.log('navigator');
                var blob = new Blob([csv], {
                    "type": "text/csv;charset=utf8;"
                });
                navigator.msSaveBlob(blob, 'ExportData.csv');
            }
            else {
                var universalBOM = "\uFEFF";
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(universalBOM + csv);
                hiddenElement.target = '_self';
                hiddenElement.download = 'ExportData.csv';
                document.body.appendChild(hiddenElement);
                hiddenElement.click();
            }
        }
        else {
            helper.showToast(component, event, "info", "No shifts available for export.");
        }
    }
})
({
    doInit: function(component, event, helper) {
        var siteList = component.get("c.getSites");
        siteList.setCallback(this, function(response) {
            var state = response.getState();
            var optsSite = [];
            if(component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();
                optsSite.push({
                    class: "optionClass",
                    label: "Select Site",
                    value: ""
                });
                for (var i = 0; i < SiteArray.length; i++) {
                    optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                    });
                }
                component.set("v.SiteList", optsSite);
                var optionsContact = [];
                optionsContact.push({
                    class: "optionClass",
                    label: "Select Candidate",
                    value: ""
                });
                component.set("v.ContactList", optionsContact);
            }
        });
        
        var siteContactMap = component.get("c.getsiteContactMap");
        siteContactMap.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                var siteContactMap = response.getReturnValue();
                component.set('v.SiteContactMap',siteContactMap);
            }
        });
        var jobRole = component.get("c.getJobRoles");
        jobRole.setCallback(this, function(response) {
            var state = response.getState();
            var optsSite = [];
            if(component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();
                optsSite.push({
                    class: "optionClass",
                    label: "Select Job Role",
                    value: ""
                });
                for (var i = 0; i < SiteArray.length; i++) {
                    optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                    });
                }
                component.set("v.JobroleList", optsSite);               
            }
        });
        
        $A.enqueueAction(siteList);
        $A.enqueueAction(jobRole);
        $A.enqueueAction(siteContactMap);
        
        helper.getShifts(component);
    },
    renderPage: function(component, event, helper) {
        var records = component.get("v.allshifts");
        console.log("-----------"+component.get("v.pageNumber"));
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.shifts", pageRecords);
    },
    searchShifts: function(component, event, helper) {
        component.set("v.filter", null); 
        var button = component.find("filter");
        for(var i=0;i<button.length;i++){    
            $A.util.addClass(button[i], 'button');
            $A.util.removeClass(button[i], 'buttonRed');
        }
        component.set("v.selectedSite", component.find("site").get("v.value"));
        component.set("v.selectedcandidate", component.find("contact").get("v.value"));
        component.set("v.selectedJobRole", component.find("jobrole").get("v.value"));
        console.log('--On Search--');
        console.log(component.get("v.selectedSite"));
        console.log(component.get("v.selectedcandidate"));
        console.log(component.get("v.selectedJobRole"));
        helper.getShifts(component);
    },
    applyFilter: function(component, event, helper) {
        var target = event.getSource();
        var filter = target.get("v.value");
        console.log(filter);
        component.set("v.filter",filter);
        var button = component.find("filter");
        for(var i=0;i<button.length;i++){    
            $A.util.addClass(button[i], 'button');
            $A.util.removeClass(button[i], 'buttonRed');
        }
        $A.util.addClass(target, 'buttonRed');
        helper.getShifts(component);
    },
    siteChanged: function(component,event,helper){
        var siteSelected = component.find("site").get("v.value");
        var siteContactMap = component.get('v.SiteContactMap');
        var contactArray = siteContactMap[siteSelected];
        
        var optionsContact = [];
        optionsContact.push({
            class: "optionClass",
            label: "Select Candidate",
            value: ""
        });
        if(contactArray!=null){
            for (var i = 0; i < contactArray.length; i++) {
                optionsContact.push({
                    class: "optionClass",
                    label: contactArray[i].Name,
                    value: contactArray[i].Id
                });
            }
        }
        component.set("v.ContactList", optionsContact);
        component.find("contact").set("v.value","");
    },
    feedback: function(component, event, helper) {
        var target = event.getSource();
        var idToBeCancelled = target.get("v.value");
        console.log("id For Feedback --"+idToBeCancelled);
        var shiftList = component.get("v.shifts");
        for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idToBeCancelled){
                console.log("matched--"+idToBeCancelled);
                component.set("v.feedbackshift", shiftList[i]);
                component.set("v.isOpenCancel", true);
            }
        }
    },
    closeModelCancel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenCancel", false);
        component.set("v.selectedRating",null);
    },
    selectRating: function(component, event, helper) {
        var target = event.getSource();
        var selectedRating = target.get("v.value");
        console.log("selectedRating--->"+selectedRating);
        var button = component.find("rating");
        for(var i=0;i<button.length;i++){    
            $A.util.addClass(button[i], 'slds-button_brand');
            $A.util.removeClass(button[i], 'slds-button_success');
        }
        $A.util.addClass(target, 'slds-button_success');
        
        component.set("v.selectedRating",selectedRating);
    },
    submitRating: function(component, event, helper) {
        var action = component.get("c.submitRatings");
        var shift = component.get("v.feedbackshift");
        console.log("shift feedback"+shift.Id);
        var selectedRating = component.get("v.selectedRating");
        console.log("selectedRating"+selectedRating);
        
        //helper.submitRating(component);
        if(selectedRating==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Please select the rating.",
                "message": "Error!"
            });
            toastEvent.fire();
        }
        else{
            action.setParams({
                "shiftID": component.get("v.feedbackshift").Id,
                "selectedRating": component.get("v.selectedRating")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Thank you!!! Your rating is successfully submitted.",
                        "message": "Success!"
                    });
                    toastEvent.fire();
                    component.set("v.isOpenCancel", false);
                    component.set("v.selectedRating",null);
                }
                 else
                {
                    var toastEvent = $A.get("e.force:showToast");
          		  toastEvent.setParams({
                "title": "There is some issues while submitting rating. Please contact System Admin",
                "message": "Sorry!"
            });
            toastEvent.fire();
                    
                }
            });
            $A.enqueueAction(action);
            helper.getShifts(component);
        }
    },
    getBackscreen : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/my-temps" });
        urlEvent.fire();
    }
})
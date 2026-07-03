({
    doInit: function(component, event, helper) {
        var action = component.get("c.getTimesheets");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.allTimesheets", records);
            component.set("v.currentList", records);
            component.set("v.maxPage", Math.floor((records.length+9)/10)); //pagination
            helper.renderPage(component);
        });
        $A.enqueueAction(action);
    },
    
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    
    getTSLDetails : function(component, event, helper) {
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS'+ids);
        var action = component.get("c.getTimesheetLine");
        action.setParams({ 'TSLID': ids });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.timesheetDetails", response.getReturnValue());                 
                component.set("v.isOpen", true);
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpen", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getQuery: function(component, event, helper) {
        
        var ids = event.getSource().get("v.value");
        var action = component.get("c.getTimesheetQuery");
        action.setParams({ 'TimesheetId': ids });        
        action.setCallback(this, function(response){             
            var state = response.getState();
            if (state === "SUCCESS"){
                if(response.getReturnValue().length){
                    //console.log('currency data is:' + JSON.stringify(response.getReturnValue()));
                    component.set("v.allRecords", response.getReturnValue()[0]);                
                    component.set("v.isOpenQuery", true);
                }else{
                    component.set("v.isOpenQuery", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message:'No record(s) found',
                        messageTemplate: 'No record(s) found',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
        			toastEvent.fire();
                }                
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpenQuery", false);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    QueryToJSC : function(component, event, helper) {
        var action = component.get("c.SendQueryOwner");		
        var comments  			= component.find("Query");
        var commentsValue  		= comments.get("v.value");      
        var isValid        		= true; 
        if(commentsValue==null || commentsValue=='undefined' || commentsValue==''){
        	comments.set("v.errors", [{message:"Comment Required: "}]); 
            isValid = false; 
        }else{
          	comments.set("v.errors", null);  
            isValid = true; 
        }
		
        var Id = component.find("TimesheetId").get("v.value");    
        var combinedComment = 'Timesheet Number- '+component.find("QueryTimesheet").get("v.value")+' Site-'+component.find("QuerySite").get("v.value")+' Job Role-'+component.find("QueryJobRole").get("v.value");       
        if(isValid===true){
        action.setParams({ 'TSLID': Id, 'comments': commentsValue, 'combinedComment': combinedComment });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success Message',
                        message:'Your message has been sent successfully',
                        messageTemplate: 'Your message has been sent successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
        			toastEvent.fire();
                component.set("v.isOpenQuery", false);
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpenQuery", false);
            }
        });
        $A.enqueueAction(action);
        }
    }, 
    
    payntimesheet: function(component, event,helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/pay-and-timesheet" });
        urlEvent.fire();
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    }, 
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },   
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpenQuery", true);
    },  
    closeModelQuery: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenQuery", false);
    },
})
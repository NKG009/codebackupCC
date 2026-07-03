({
	doInit: function(component, event, helper) {
        var action = component.get("c.getSkills");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            console.log('records---'+records.length);
            if(records.length===0){
                component.set("v.recordCnt", true);
            }
            component.set("v.allTimesheets", records);
            component.set("v.currentList", records);
            component.set("v.maxPage", Math.floor((records.length+9)/10)); //pagination
            helper.renderPage(component);
        });
        $A.enqueueAction(action);
    },
    
    QueryToOwners: function(component, event, helper) {
        var action = component.get("c.sendQuery");   
        var comments  			= component.find("Query");
        var commentsValue  		= comments.get("v.value");        
        var isValid        		= true;  
        if(component.get("v.Query")==null || component.get("v.Query")=='undefined' || component.get("v.Query")==''){
        	comments.set("v.errors", [{message:"Comment Required: "}]); 
            isValid = false; 
        }else{
          	comments.set("v.errors", null);  
            isValid = true; 
        }
        
        if(isValid===true){
        console.log('commentsValue---'+commentsValue);  
        action.setParams({ 'comments2': commentsValue });
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
                component.set("v.isOpen", false);
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpen", true);
            }
        });
        $A.enqueueAction(action); 
        }
    },    
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    mydetails: function(component, event,helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/my-details" });
        urlEvent.fire();
    },
    
    QueryToSkills: function(component, event,helper) {
        component.set("v.isOpen", true);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    }, 
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },   
})
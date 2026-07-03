({
    doInit : function(component, event, helper) {
      helper.fetchPickListVal(component, 'Subject_Query__c', 'caseSubject');  
    },
     getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
 },
     onPicklistChange: function(component, event, helper) {
        // get the value of select option
       // alert(event.getSource().get("v.value"));
    },
    submitcase : function(component, event, helper){
        
        var getsub = component.find("caseSubject");
        var getsubValue = getsub.get("v.value");        
        var comments  			= component.find("Query");
        var commentsValue  		= comments.get("v.value");      
        var isValid        		= true; 
        var isValid1        		= true; 
        var isValid2        		= true; 
        console.log('isValid1---'+isValid);
         console.log('getsubValue---'+getsubValue);
        if(getsubValue==null || getsubValue=='undefined' || getsubValue==''){
            getsub.set("v.errors", [{message:"Subject Required: "}]); 
            isValid1 = false; 
        }else {
            getsub.set("v.errors", null);
            isValid1 = true; 
        }
      	if(commentsValue==null || commentsValue=='undefined' || commentsValue==''){
            comments.set("v.errors", [{message:"Comment Required: "}]); 
            isValid2 = false; 
        }else{            
            
            comments.set("v.errors", null);  
            isValid2 = true; 
        }
        
        
        if(isValid1===true && isValid2===true){
            var action = component.get("c.updatecase");
			action.setParams({'sub': getsubValue,'des' : commentsValue });	
			action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
              
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success Message',
                        message:'Your message has been sent successfully',
                        messageTemplate: 'Your message has been sent successfully',
                        duration:' 1000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
        			toastEvent.fire();     
              component.set("v.casesubject",'');
                component.set("v.casedescription",'');
            }else{
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : '',
                        message:'Your message can not be sent! Please contact your Consultant',
                        messageTemplate: '',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
        			toastEvent.fire();      
                console.log("Failed with state: " + state);               
            }
        });
        $A.enqueueAction(action);                        
        }
        
     }
})
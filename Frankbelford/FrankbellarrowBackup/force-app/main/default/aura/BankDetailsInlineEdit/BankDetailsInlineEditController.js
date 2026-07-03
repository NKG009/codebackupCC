({
    
    doInit: function(component, event, helper) {
      // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
      // method for get picklist values dynamic   
      //  helper.fetchPickListVal(component, 'Rating', 'ratingPicklistOpts');
    },
    
    inlineEditAccountName : function(component,event,helper){   
        
        component.set("v.AccountNameEditMode", true); 
        component.set("v.SortCodeEditMode", false); 
        component.set("v.AccountNumberEditMode", false); 
        component.set("v.BuildingSocietyNumberEditMode", false); 
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
    },
    onNameChange : function(component,event,helper){ 
        if(event.getSource().get("v.value").trim() != ''){            
            component.set("v.showSaveCancelBtn",true);
        }
    },
 	closeNameBox : function (component, event, helper) {
        component.set("v.AccountNameEditMode", false); 
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    
    
   inlineEditSortCode : function(component,event,helper){   
        component.set("v.SortCodeEditMode", true); 
         component.set("v.AccountNameEditMode", false); 
         component.set("v.AccountNumberEditMode", false); 
        component.set("v.BuildingSocietyNumberEditMode", false); 
        setTimeout(function(){ 
            component.find("inputId2").focus();
        }, 100);
    },
    onSortCodeChange : function(component,event,helper){ 
        if(isNaN(component.get("v.input"))){
            component.set("v.input","");
        }       
        
        if(event.getSource().get("v.value").trim() != ''){ 
            component.set("v.showSaveCancelBtn",true);
        }
    },
 	closeSortCodeBox : function (component, event, helper) {
        
        component.set("v.SortCodeEditMode", false); 
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    
    
    inlineEditAccountNumber : function(component,event,helper){   
        component.set("v.AccountNumberEditMode", true); 
          component.set("v.SortCodeEditMode", false); 
         component.set("v.AccountNameEditMode", false); 
         
        component.set("v.BuildingSocietyNumberEditMode", false); 
        setTimeout(function(){ 
            component.find("inputId3").focus();
        }, 100);
    },
    onAccountNumberChange : function(component,event,helper){ 
        if(event.getSource().get("v.value").trim() != ''){ 
            component.set("v.showSaveCancelBtn",true);
        }
    },
 	closeAccountNumberBox : function (component, event, helper) {
        component.set("v.AccountNumberEditMode", false); 
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
   
    
    inlineEditBuildingSocietyNumber : function(component,event,helper){   
        component.set("v.BuildingSocietyNumberEditMode", true);
          component.set("v.SortCodeEditMode", false); 
         component.set("v.AccountNameEditMode", false); 
         component.set("v.AccountNumberEditMode", false); 
       
        setTimeout(function(){ 
            component.find("inputId4").focus();
        }, 100);
    },
    onBuildingSocietyNumberChange : function(component,event,helper){ 
        if(event.getSource().get("v.value").trim() != ''){ 
            component.set("v.showSaveCancelBtn",true);
        }
    },
 	closeBuildingSocietyNumberBox : function (component, event, helper) {
        component.set("v.BuildingSocietyNumberEditMode", false); 
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    Save1 : function (component, event, helper) {
        
        var inputId      = component.find('inputId');
        var inputIdValue   = inputId.get('v.value');
        var isValid        = true;
		
       if(inputIdValue.trim().length ===0 ){
            inputId.set("v.errors", [{message:"Account Name should not be blank"}]);
            component.set("v.showErrorClass1",true);
            //component.set("v.SortCodeEditMode", false);
            isValid = false;
        }else{
            component.set("v.showErrorClass1",false);
            component.set("v.SortCodeEditMode", false);
            isValid = true;
        }
           
        if(isValid===true){
        var action = component.get("c.savePP");
        console.log(event.getSource().get("v.value"));
        console.log('inputId@@@'+component.find("inputId").get('v.value'));
        action.setParams({ 'Ids': event.getSource().get("v.value"),
                          'inputId' : component.find("inputId").get('v.value'),
                          'part' : 'ACCOUNTNAME'
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                   
                    message: 'Your Update has been initiated.Refresh the page to see the updates.',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 500',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky'
                });
                toastEvent.fire();   
                component.set("v.AccountNameEditMode", false); 
                var storeResponse = response.getReturnValue();              
                component.set("v.AccountList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
            }else{
                component.set("v.showSaveCancelBtn",false);
            }
        });
        $A.enqueueAction(action);
        }
    }, 
    cancel1 : function(component,event,helper){      
        //$A.get('e.force:refreshView').fire(); 
        component.set("v.AccountNameEditMode", false); 
    },
    Save2 : function (component, event, helper) {
        var inputId2      = component.find('inputId2');
        var inputId2Value   = inputId2.get('v.value');
        var isValid        = true;
		
       if(isNaN(inputId2Value)){
            inputId2.set("v.errors", [{message:"6 digit numbers only"}]);
            component.set("v.showErrorClass2",true);
            //component.set("v.SortCodeEditMode", false);
            isValid = false;
        }else if(inputId2Value.trim().length !=6 ){
            inputId2.set("v.errors", [{message:"6 digit numbers only"}]);
            component.set("v.showErrorClass2",true);
            //component.set("v.SortCodeEditMode", false);
            isValid = false;
        }else{
            component.set("v.showErrorClass2",false);
            component.set("v.SortCodeEditMode", false);
            isValid = true;
        }
           
       
        
        
        if(isValid===true){
        var action = component.get("c.savePP");
        action.setParams({ 'Ids': event.getSource().get("v.value"),
                          'inputId' : component.find("inputId2").get('v.value'),
                          'part' : 'SORTCODE'
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                   message: 'Your Update has been initiated.Refresh the page to see the updates.',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky'
                });
                toastEvent.fire();   
                component.set("v.SortCodeEditMode", false); 
                var storeResponse = response.getReturnValue();              
                component.set("v.AccountList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
            }else{
                component.set("v.showSaveCancelBtn",false);
            }
        });
        $A.enqueueAction(action);
        }
    },
    cancel2 : function(component,event,helper){        
        //$A.get('e.force:refreshView').fire(); 
        component.set("v.SortCodeEditMode", false);
    },
    Save3 : function (component, event, helper) {
        
        var inputId3      = component.find('inputId3');
        var inputId3Value   = inputId3.get('v.value');
        var isValid        = true;
		
       if(isNaN(inputId3Value)){
            inputId3.set("v.errors", [{message:"8 digit numbers only"}]);
            component.set("v.showErrorClass3",true);
            //component.set("v.SortCodeEditMode", false);
            isValid = false;
        }else if(inputId3Value.trim().length !=8 ){
            inputId3.set("v.errors", [{message:"8 digit numbers only"}]);
            component.set("v.showErrorClass3",true);
            //component.set("v.SortCodeEditMode", false);
            isValid = false;
        }else{
            component.set("v.showErrorClass3",false);
            component.set("v.SortCodeEditMode", false);
            isValid = true;
        }
        
        if(isValid===true){
        var action = component.get("c.savePP");
        action.setParams({ 'Ids': event.getSource().get("v.value"),
                          'inputId' : component.find("inputId3").get('v.value'),
                          'part' : 'ACCOUNTNUMBER'
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Your Update has been initiated.Refresh the page to see the updates.',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky'
                });
                toastEvent.fire(); 
                component.set("v.AccountNumberEditMode", false);
                
                var storeResponse = response.getReturnValue();              
                component.set("v.AccountList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
            }else{
                component.set("v.showSaveCancelBtn",false);
            }
        });
        $A.enqueueAction(action);
        }
    },
    cancel3 : function(component,event,helper){        
        //$A.get('e.force:refreshView').fire(); 
        component.set("v.AccountNumberEditMode", false);
    },
    Save4 : function (component, event, helper) {
        
        var action = component.get("c.savePP");
        action.setParams({ 'Ids': event.getSource().get("v.value"),
                          'inputId' : component.find("inputId4").get('v.value'),
                          'part' : 'BUILDINGSOCIETYREF'
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Your Update has been initiated.Refresh the page to see the updates.',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky'
                });
                toastEvent.fire();   
                component.set("v.BuildingSocietyNumberEditMode", false);
                var storeResponse = response.getReturnValue();              
                component.set("v.AccountList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
            }else{
                component.set("v.showSaveCancelBtn",false);
            }
        });
        $A.enqueueAction(action);
      
    },
    cancel4 : function(component,event,helper){        
        //$A.get('e.force:refreshView').fire(); 
         component.set("v.BuildingSocietyNumberEditMode", false);
    },
})
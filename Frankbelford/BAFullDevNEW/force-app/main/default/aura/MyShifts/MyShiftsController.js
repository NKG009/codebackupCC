({
 doInit: function(component, event, helper) {
     var urlString = window.location.href;
 	 var baseURL = urlString.substring(0, urlString.indexOf("/s"));
     console.log('baseURL::'+JSON.stringify(baseURL));
     var supCancelRsns = [
         {
            value: "--None--",
            label: "--None--"
        },
        {
            value: "Illness",
            label: "Illness"
        },
        {
            value: "Alternative Work",
            label: "Alternative Work"
        },
         {
            value: "Personal Circumstances",
            label: "Personal Circumstances"
        }
    ];
    component.set("v.supCancelRsns", supCancelRsns);
     component.set("v.supCancelRsns", supCancelRsns);
     if(!$A.util.isUndefinedOrNull(baseURL) && baseURL.includes('candidate')){
         component.set("v.isCandidateLogin",true); 
         component.set("v.cancelRsn","Cancelled by Worker"); 
     }else if(!$A.util.isUndefinedOrNull(baseURL) && baseURL.includes('client')){
         component.set("v.isClientLogin",true);
     	component.set("v.cancelRsn","Cancelled by Client"); 
     }
         
        var action = component.get("c.getShifts");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.allshifts", records);
            component.set("v.currentList", records);
            if(records.length>0){
                component.set("v.maxPage", Math.floor((records.length+9)/10));} //pagination
            helper.renderPage(component);
        });
        $A.enqueueAction(action);
	},
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }, 
       getList1: function(component, event, helper) {
         console.log(event);
       var href = event.srcElement.name;
       console.log(href);
     if(href=='Today')
     {
          component.set("v.hyperclick1",true);
    	  component.set("v.hyperclick2",false);
    	  component.set("v.hyperclick3",false);
          component.set("v.hyperclick4",false);                 
     }
           else if(href=='Tomorrow')
           {
          component.set("v.hyperclick1",false);
    	  component.set("v.hyperclick2",true);
    	  component.set("v.hyperclick3",false);
          component.set("v.hyperclick4",false);     
               
           }
           else if(href=='Next_7_days')
           {
          component.set("v.hyperclick1",false);
    	  component.set("v.hyperclick2",false);
    	  component.set("v.hyperclick3",true);
          component.set("v.hyperclick4",false);   
           }
           else 
           {
               component.set("v.hyperclick1",false);
    	  component.set("v.hyperclick2",false);
    	  component.set("v.hyperclick3",false);
          component.set("v.hyperclick4",true);   
               
           }
     var action = component.get("c.getShifts");
          action.setParams({
               'startdate': href
               
                  });
           
              action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                     
                    var storeResponse = response.getReturnValue();
                   component.set("v.currentList", storeResponse);
                   component.set("v.allshifts", storeResponse);    
                    if(storeResponse.length>0){
                    component.set("v.pageNumber",1);
                    component.set("v.maxPage", Math.floor((storeResponse.length+9)/10));
                     helper.renderPage2(component);
                    } 
                }
    			});
           
            $A.enqueueAction(action);
           
    },
    openModelCancel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
     
      component.set("v.isOpenCancle", true);
   
   },
    closeModelCancle: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenCancle", false);
     
    },
       getShiftDetails : function(component, event, helper) {
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS'+ids);
        var action = component.get("c.getCancleShifts");
        action.setParams({ 'recordID': ids });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
               	var testnow = new Date();
                console.log('testnow '+testnow);
                testnow.setHours(testnow.getHours() + 2);
                console.log('testnow2 '+testnow);
                component.set("v.CancleShiftList", response.getReturnValue());
                component.set("v.scheduletime",response.getReturnValue()[0].sirenum__Scheduled_Start_Time__c);
                var ab = component.get("v.scheduletime");
                console.log('response2field '+ab);
                var scheduletime = new Date(ab);

                if(testnow > scheduletime )
                {
                    component.set("v.OpenButton",false);
                    console.log('Inside IF ');
                    
                }
                else 
                { 
                     console.log('Inside else');
                    component.set("v.OpenButton",true);
                }
                
                component.set("v.isOpenCancle", true);
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpenCancle", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/myjobs" });
        urlEvent.fire();
 },
    
    cancleshift : function(component, event, helper){
		 var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        let supCancelRsn = component.get("v.selectedSupCancelRsn");
        var params = {
            'cancelRsn' : component.get("v.cancelRsn"),
            'supCancelRsn' : component.get("v.selectedSupCancelRsn")
        }
        console.log('IDS'+ids);
        var action = component.get("c.getcancleshift");
        action.setParams({ 'recordID': ids,'params' : params});
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success ');
                var toastEvent = $A.get("e.force:showToast");
					  toastEvent.setParams({
                          
                    "message": " Cancellation Process has been initiated"
                });

             toastEvent.fire();
            } 
        });
        if(!$A.util.isUndefinedOrNull(supCancelRsn) && supCancelRsn !== '--None--'){
            $A.enqueueAction(action);
            var action1 = component.get("c.getShifts");
        action1.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.allshifts", records);
            component.set("v.currentList", records);
            component.set("v.selectedSupCancelRsn", "");
            if(records.length>0){
                component.set("v.maxPage", Math.floor((records.length+9)/10));} //pagination
              helper.renderPage2(component);
        });
       
        $A.enqueueAction(action1);
        component.set("v.isOpenCancle",false);
        }
            
        else{
            var toastEvent = $A.get("e.force:showToast");
					  toastEvent.setParams({
                    "message": "Cancellation Reason is mandatory.Please provide the value."
                });

             toastEvent.fire();
        }
      
               
},
    
    handleCancelRsnChange : function(component,event,helper){
        var rsn = component.get("v.selectedSupCancelRsn");
        console.log('rsn::'+rsn);
    }
})
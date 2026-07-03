({
	 doInit: function(component, event, helper) {
        var action = component.get("c.getHolidays");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            
        console.log(records);
            component.set("v.allHolidays", records);
            component.set("v.currentList", records);
         
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    },
    
    getQuery: function(component, event, helper) {
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
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
  /*  nullify : function(component,event,helper)
{
    var dp = component.find('fromDate');
    console.log('fromdate'+dp);              
    var a = dp.charCodeAt(0);
    console.log('ASCII code'+a);
    if(a <= 48 && a >= 57 || a==46)
    {
    dp.set('v.value', '');
    }
},
     nullify2 : function(component,event,helper)
{
    var dp = component.find('toDate');
    dp.set('v.value', '');
},*/
    QueryTo : function(component, event, helper) {
        var comments = component.find("Query").get("v.value");
        console.log(comments);
        var action = component.get("c.HolidayReq");        
        action.setParams({ 'comments': comments });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('this is result--'+state);
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
                component.set("v.isOpen", false);
            }
        });
        $A.enqueueAction(action); 
    },
    backtomydetails: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/" });
        urlEvent.fire();
    },
    
    HolidayRequest: function(component, event,helper) 
    {
          var toastEvent = $A.get("e.force:showToast");
        var fromDate      = component.find('fromDate');
        var fromDateValue   = fromDate.get('v.value');
        var toDate      = component.find('toDate');
        var toDateValue   = toDate.get('v.value');
        var isValid        = true;
		
       if(fromDateValue.trim().length ===0 ){
            fromDate.set("v.errors", [{message:"From Date should not be blank"}]);                      
            isValid = false;
       }else {
           fromDate.set("v.errors", null);                      
           isValid = true;
       }
       if(toDateValue.trim().length ===0 ){
            toDate.set("v.errors", [{message:"To Date should not be blank"}]);                      
            isValid = false;
       }else{
            toDate.set("v.errors", null);
            isValid = true;
       }   
        if(fromDateValue>toDateValue)
        {
              toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "From date cannot be greater than To date"
                    
                });

             toastEvent.fire();
            isValid=false;
        }
        
       if(isValid===true)
       {        
       var action = component.get("c.HolidayReq");
       var fromDate = component.find("fromDate").get("v.value");
       var toDate = component.find("toDate").get("v.value");        
       action.setParams({ 'fromDate': fromDate, 'toDate': toDate });
       action.setCallback(this, function(response) { 
            var state = response.getState();            
            if (component.isValid() && state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Request sent successfully."
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
       }
    },
    
})
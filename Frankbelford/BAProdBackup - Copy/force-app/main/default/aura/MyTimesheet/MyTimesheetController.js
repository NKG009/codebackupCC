({ 

 doInit: function(component, event, helper) {
        var action = component.get("c.getplacement");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.allrecords", records);
            component.set("v.rec", records);
           
            
            if(records.length>0){
                component.set("v.maxPage", Math.floor((records.length+9)/10));
            
            //component.set("v.today",dt);
            } //pagination
        });
     
        $A.enqueueAction(action);
	},
 renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }, 

    
     getPlacementID : function(component, event, helper) {
         
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS'+ids);
         var action = component.get("c.fetchit");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.url", records);
        
         var str = component.get("v.url");
          console.log('str '+str);
     window.open(str+"/candidate/TmesheetdesignCommunity2?id="+ids,'_blank','height=600,width=650,resizable=yes,scrollbars=yes,toolbar=n‌o,menubar=no');
       
        });
        $A.enqueueAction(action);
      
     },
    
     getthisweek : function(component, event, helper) {
         
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS'+ids);
         var action = component.get("c.fetchit");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.url", records);
        
         var str = component.get("v.url");
          console.log('str '+str);
  window.open(str+"/candidate/TimesheetDesignCommunity?id="+ids,'_blank','height=600,width=650,resizable=yes,scrollbars=yes,toolbar=n‌o,menubar=no');
     
        });
        $A.enqueueAction(action);
      
     },
    
     getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
     urlEvent.setParams({ "url": "/pay-and-timesheet" });
     urlEvent.fire();
    
    
},
     
})
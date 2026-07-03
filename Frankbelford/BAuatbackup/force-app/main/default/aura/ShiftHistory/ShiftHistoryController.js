({
 doInit: function(component, event, helper) {
        var action = component.get("c.getShiftshistory");
  
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
     var action = component.get("c.getShiftshistory");
          action.setParams({
               'startdate': href
               
                  });
           
              action.setCallback(this, function(response) {
                  
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records = response.getReturnValue();
                   component.set("v.allshifts", records);
          		   component.set("v.currentList", records);
                    component.set("v.hyperclick1",true);
                     component.set("v.hyperclick2",false);
                    component.set("v.hyperclick3",false);
                     component.set("v.hyperclick4",false);
          		  if(records.length>0){
                    component.set("v.maxPage", Math.floor((records.length+9)/10));
                  	 helper.renderPage2(component);
                  } 
                }
    			});
            $A.enqueueAction(action);
           
    },
     getList2: function(component, event, helper) {
         console.log(event);
       var href = event.srcElement.name;
       console.log(href);
     var action = component.get("c.getShiftshistory");
          action.setParams({
               'startdate': href
               
                  });
           
              action.setCallback(this, function(response) {
                  
                var state = response.getState();
              if (state === "SUCCESS") {
                     console.log('SUCCESS ');
                    var records = response.getReturnValue();
                   component.set("v.allshifts", records);
          		   component.set("v.currentList", records);
                    component.set("v.hyperclick1",false);
                     component.set("v.hyperclick2",true);
                    component.set("v.hyperclick3",false);
                     component.set("v.hyperclick4",false);
          		  if(records.length>0){
                        component.set("v.pageNumber",1);
                    component.set("v.maxPage", Math.floor((records.length+9)/10));
                   helper.renderPage2(component);
                  } 
                }
    			});
            $A.enqueueAction(action);
           
    },
       getList3: function(component, event, helper) {
         console.log(event);
       var href = event.srcElement.name;
       console.log(href);
     var action = component.get("c.getShiftshistory");
          action.setParams({
               'startdate': href
               
                  });
           
              action.setCallback(this, function(response) {              
                var state = response.getState();
                  
                if (state === "SUCCESS") {
                     console.log('SUCCESS ');
                    var records = response.getReturnValue();
                   component.set("v.allshifts", records);
          		   component.set("v.currentList", records);
                     component.set("v.hyperclick1",false);
                     component.set("v.hyperclick2",false);
                    component.set("v.hyperclick3",true);
                     component.set("v.hyperclick4",false);
          		  if(records.length>0){
                    component.set("v.pageNumber",1);
                    component.set("v.maxPage", Math.floor((records.length+9)/10));
                   helper.renderPage2(component);
                  } 
                }
    			});
            $A.enqueueAction(action);
          
           
    },
    getList4: function(component, event, helper) {
         console.log(event);
       var href = event.srcElement.name;
       console.log(href);
     var action = component.get("c.getShiftshistory");
          action.setParams({
               'startdate': href
               
                  });
           
              action.setCallback(this, function(response) {              
                var state = response.getState();
                  
                if (state === "SUCCESS") {
                     console.log('SUCCESS ');
                    var records = response.getReturnValue();
                   component.set("v.allshifts", records);
          		   component.set("v.currentList", records);
                   component.set("v.hyperclick1",false);
                     component.set("v.hyperclick2",false);
                    component.set("v.hyperclick3",false);
                     component.set("v.hyperclick4",true);
          		  if(records.length>0){
                    component.set("v.pageNumber",1);
                    component.set("v.maxPage", Math.floor((records.length+9)/10));
                   helper.renderPage2(component);
                  } 
                }
    			});
            $A.enqueueAction(action);
          
           
    },
      getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/myjobs" });
        urlEvent.fire();
    
    
},
      feedback: function(component, event, helper) {
        var target = event.getSource();
        var idToBeCancelled = target.get("v.value");
        console.log("id For Feedback --"+idToBeCancelled);
        var shiftList = component.get("v.currentList");
        for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idToBeCancelled){
                console.log("matched--"+idToBeCancelled);
               
                component.set("v.feedbackshift", idToBeCancelled);
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
        console.log('submit');
     
        var shift = component.get("v.feedbackshift");
        console.log("shift feedback"+shift);
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
            var action = component.get("c.submitRatings");
            console.log('action '+action);
            console.log('shift @@ '+shift);
            console.log('selectedRating @@ '+selectedRating);
            action.setParams({
                "shiftID": shift,
                "selectedRating": selectedRating
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
                     component.set("v.storeRating",selectedRating);
                  component.set("v.selectedRating",null);
                }
                 else
                {
                    var toastEvent = $A.get("e.force:showToast");
          		  toastEvent.setParams({
                "title": "There is some issues while submitting rating. Please contact your Consultant",
                "message": "Sorry!"
            });
            toastEvent.fire();
                    
                }
            });
             var action2 = component.get("c.getShiftshistory");
  
        action2.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.allshifts", records);
            component.set("v.currentList", records);
            if(records.length>0){
                component.set("v.maxPage", Math.floor((records.length+9)/10));} //pagination
             helper.renderPage(component);
        });
            
            $A.enqueueAction(action);
             $A.enqueueAction(action2);
        }
    },

})
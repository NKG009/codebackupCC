({
	doInit : function(component, event, helper) {
	/*	 var page = component.get("v.page") || 1;
      // get the select option (drop-down) values.   
      var recordToDisply = 5;
      // call the helper function   
      helper.getSh(component, page, recordToDisply); */
         var action = component.get("c.getShifts");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.shifts", records);
           
            component.set("v.maxPage", Math.floor((records.length+9)/10));
            helper.renderPage(component);
        });
        $A.enqueueAction(action);
	},
    
    navigate: function(component, event, helper) {
      // this function call on click on the previous page button  
      var page = component.get("v.page") || 1;
      // get the previous button label  
      var direction = event.getSource().get("v.label");
      // get the select option (drop-down) values.  
      var recordToDisply = 5;
      // set the current page,(using ternary operator.)  
      page = direction === "Previous Page" ? (page - 1) : (page + 1);
      // call the helper function
      helper.getSh(component, page, recordToDisply);
 
   },
    onParentAttrChange: function(cmp, evt) {
        console.log("isParentOpen has changed");
        console.log("old value: " + evt.getParam("oldValue"));
        console.log("current value: " + evt.getParam("value"));
    }, 
  renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }, 
     getBackscreen : function(component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/pay-and-timesheet" });
        urlEvent.fire();
    
    
},
    
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
    
   },
 
      details: function(component, event, helper) {
          var target = event.getSource();
        var idfordetail = target.get("v.value");
        console.log("idfordetail--"+idfordetail);
     
            var action = component.get("c.getdetailShifts");
          action.setParams({
              "shiftId":idfordetail     });
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.detailshifts", records);
            console.log('records '+records);
            console.log('action '+action);
             var shiftList = component.get("v.detailshifts");
 			console.log('shiftList '+shiftList);
      
             for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idfordetail){
                console.log("matched--"+idfordetail);
                component.set("v.detailshift", shiftList[i]);
			}
			}
                
                  console.log('HOURS '+component.get("v.Hours"));
        var getvalend = component.get("v.detailshift[0].EndTime__c");
        var getvalstart = component.get("v.detailshift[0].Starttime__c");
        var breaklen =  component.get("v.detailshift[0].Break_Length__c");
          component.set("v.popouthour",getvalstart);
        component.set("v.popouthour2",getvalend);
       
       var shiftlen = component.get("v.detailshift[0].Shift_Length_from_Break__c");
        var totalbrk = component.get("v.detailshift[0].Total_Shift_BreakLength__c");
  	 	console.log('@@shiftlen '+shiftlen);
        console.log('@@totalbrk '+totalbrk);
          var len1;
          
          if(totalbrk != null)
          {
          len1 = shiftlen.split("&")[0];
          var len2 = shiftlen.split("&")[1];
          
          var brk1 = totalbrk.split("&")[0];
          var brk2 = totalbrk.split("&")[1];
          console.log('@@len1 '+len1);
          console.log('@@len2 '+len2);
          console.log('@@brk1 '+brk1);
          console.log('@@brk2 '+brk2); 
              
          }
          else
          {
              len1 = shiftlen;
          }
        
        
         console.log('@@getvalstart '+getvalstart);
        console.log('@@getvalend '+getvalend);
  
                
         var breaklen =  component.get("v.detailshift[0].Break_Length__c");
         var totalbreaklen =  component.get("v.detailshift[0].Break_from_Brekdef__c");
        var hours =  component.get("v.Hours"); 	
       if(getvalend == '' || getvalstart == '' ){ 
           var hrs = '00:00'; 
			component.set("v.Hours",hrs);      
          }
        else
        {
          
     var brkhr = breaklen.split(":")[0];
        var brkmin = breaklen.split(":")[1];
        var splitendhr = getvalend.split(":")[0];
        var splitendmin = getvalend.split(":")[1];
        var splitstarthr = getvalstart.split(":")[0];
        var splitstartmin = getvalstart.split(":")[1];
          var dend =  new Date();
          dend.setHours(splitendhr);
        dend.setMinutes(splitendmin);
 
          var today = new Date();
        
        var dstart =  new Date();
        dstart.setHours(splitstarthr);
        dstart.setMinutes(splitstartmin);
        
      if(dend<dstart)
        {
            dend.setDate(today.getDate() +1);
            dend.setHours(splitendhr);
            dend.setMinutes(splitendmin);
        }
		
          if(totalbrk == null)
          {
               var shiftmin1 = len1 * 60;  
          }
       else
       {
         var shiftmin1 = len1 * 60;  
          var shiftmin2 = len2 * 60;  
       }
       
        var caltime = ((dend - dstart)/(1000*60));
     //   var brkinsecong = totalbreaklen *60;   
              console.log('shiftmin '+shiftmin1);
               console.log('caltime '+caltime);
             console.log('shiftmin2 '+shiftmin2);
             console.log('totalbreaklen '+totalbreaklen);
        if(caltime<shiftmin1)
        {
            console.log('in IF');
            if(totalbrk == null)
            {
                 component.set("v.brktime",'00:00');  
            }
            else
            {
                if(caltime>=shiftmin2)
                {
                    caltime= caltime - brk2;
                    var frstbrk = "00:";
                    var res = frstbrk.concat(brk2);
                    console.log('in frstbrk '+frstbrk);
                    console.log('in res '+res);
                   component.set("v.brktime",res); 
                }
                else
                {
                component.set("v.brktime",'00:00'); 
                }
            }
        }
            else if(caltime>=shiftmin1)
            {
              caltime = caltime - totalbreaklen;
              console.log('in else if '+caltime);
              component.set("v.brktime",breaklen);   
              
            }
            else
            {
               component.set("v.brktime",null);  
            }
         
       var actualhrtimef = (caltime/60);
       var numtostring = actualhrtimef.toString();
       var removeextradec = numtostring.substring(0, 4);
   
       var removedec = removeextradec.split(".")[1];
  		var actualhrtime;
          if(removedec<=98){
             actualhrtime = Math.floor(actualhrtimef);
    
          }
       else
       {
            actualhrtime  = Math.ceil(actualhrtimef);
 
       }
     
       var actualmintime = Math.round(caltime%60);
    
            
    if(actualhrtime<10)
          {
              actualhrtime = '0'+actualhrtime;
          }
         if(actualmintime<10)
         {
             actualmintime = '0'+actualmintime;
         }
          else if(actualmintime == 60)
          {
              actualmintime = '00';
          }
          var chargetime = actualhrtime +':'+actualmintime;
      	          component.set("v.Hours",chargetime); 
              
         
            
              
        }
                
        
        });
           
          
        
            $A.enqueueAction(action);
        
                 component.set("v.isOpen", true); 
          
        
    },
    
      openModelQuery: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
       var target = event.getSource();
        var idfordetail = target.get("v.value");
        console.log("idfordetail--"+idfordetail);
           
     
        var shiftList = component.get("v.currentList");
 
        for (var i = 0; i < shiftList.length; i++) {
            if(shiftList[i].Id==idfordetail){
                console.log("matched--"+idfordetail);
                component.set("v.detailshift", shiftList[i]);
                 component.set("v.isOpenQuery", true);
            }
        }
     

   },
     SendQueryEmail: function(component, event, helper) {
       var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS'+ids);
          var comments  			= component.find("Query");
          
         var textarea =  comments.get("v.value"); 
         console.log('textarea '+textarea);
         var action = component.get("c.sendEmail");
        action.setParams({ 'recordId': ids,
                          'QueryData' : textarea
                         });

        action.setCallback(this, function(result) {
        var records = result.getReturnValue();
        console.log('@@ '+records);
        var toastEvent = $A.get("e.force:showToast");
        if(records == 'Success')
        {
            console.log('Sucess  ');
             toastEvent.setParams({
                    "title": "Success!",
                    "message": " Query sent successfully."
                });

             toastEvent.fire();
       component.set("v.isOpenQuery", false);
      component.set("v.childAttr", false);
        }
            else
            {
                toastEvent.setParams({
                    "title": "Error!",
                    "message": " There is some issue while sending query. Try after some time."
                });

             toastEvent.fire(); 
                
            }
        
        });
        $A.enqueueAction(action); 
     },

 closeModelQuery: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenQuery", false);

    },
 
})
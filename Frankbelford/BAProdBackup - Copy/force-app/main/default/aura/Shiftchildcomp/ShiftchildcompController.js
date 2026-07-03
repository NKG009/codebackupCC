({
	doInit : function(component, event, helper) {
	  console.log('HOURS '+component.get("v.Hours"));
        var getvalend = component.get("v.singleRec.EndTime__c");
        var getvalstart = component.get("v.singleRec.Starttime__c");
        var breaklen =  component.get("v.singleRec.Break_Length__c");
          component.set("v.popouthour",getvalstart);
        component.set("v.popouthour2",getvalend);
       
        var shiftlen = component.get("v.singleRec.Shift_Length_from_Break__c");
        var totalbrk = component.get("v.singleRec.Total_Shift_BreakLength__c");
  	 	    var totalbreaklen =  component.get("v.singleRec.Break_from_Brekdef__c");
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
        
          if(getvalend == null || getvalstart ==  null || breaklen == null){ 
     
          }
        else
        {
   
   var getvalendmin = new Date(component.get("v.singleRec.EndTime__c"));
        var getvalendmin1 = getvalendmin.getTime();
     
      
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
      
       var shiftmin = shiftlen * 60;  
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
                caltime= caltime - totalbreaklen;
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
          if(removedec<=98){
                var actualhrtime = Math.floor(actualhrtimef);
           }
       else
       {
             var actualhrtime = Math.ceil(actualhrtimef);
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
	},
       inlineEditName : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            document.getElementById('inputId').focus();
        }, 100);
    },
      closeNameBox : function (component, event, helper) {
      console.log('@@onchange ');
          var getvalend;
          console.log('component.get("v.popouthour2") '+component.get("v.popouthour2"));
          if(component.get("v.popouthour2")!=null || component.get("v.popouthour2")=='undefined' )
          {
            getvalend = component.get("v.popouthour2");
              console.log('@@IN IF '); 
          }
          else
          {
        getvalend = component.get("v.singleRec.EndTime__c");
               console.log('@@IN else '); 
          }
           var getvalstart = event.target.value;
           component.set("v.popouthour",getvalstart);
    //    var getvalstart = component.find("inputId").get("v.value");
        var getId = event.target.name;
        
      
        var shiftlen = component.get("v.singleRec.Shift_Length_from_Break__c");
        var totalbrk = component.get("v.singleRec.Total_Shift_BreakLength__c");
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
        
          console.log('@@getId '+getId);
          
         console.log('@@getvalstart '+getvalstart);
        console.log('@@getvalend '+getvalend);
  
                
         var breaklen =  component.get("v.singleRec.Break_Length__c");
         var totalbreaklen =  component.get("v.singleRec.Break_from_Brekdef__c");
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
         component.set("v.nameEditMode", false); 
         if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    /*        }
        }); 
           $A.enqueueAction(action); */
    }, 

    
     inlineEditTime : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.TimeEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
             document.getElementById('inputTime').focus();
        }, 100);
    },
      closeTimeBox : function (component, event, helper) {
         var Hours = component.get("v.Hours");
        console.log('@@ hrs '+ Hours);
        var getvalend = event.target.value;
         
        var getvalstart;
        console.log('component.get("v.popouthour") '+component.get("v.popouthour"));
          if(component.get("v.popouthour") !=null || component.get("v.popouthour") =='undefined' )
          {
            getvalstart = component.get("v.popouthour");
              console.log('@@IN IF '); 
          }
          else
          {
        getvalstart = component.get("v.singleRec.Starttime__c");
               console.log('@@IN else '); 
          }   
          
          
      //  var brkmin = component.get("v.singleRec.Break_from_Brekdef__c");
        var shiftlen = component.get("v.singleRec.Shift_Length_from_Break__c");
        var totalbrk = component.get("v.singleRec.Total_Shift_BreakLength__c");
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
          
          
          component.set("v.popouthour2",getvalend);
           var getId = event.target.name;
        console.log('@@getId '+getId);
        console.log('@@getvalstart '+getvalstart);
        console.log('@@getvalend '+getvalend);
          
         /*  var result;
        var action = component.get("c.getbreaks");
                  action.setParams({
                    "shiftid" : getId
                  });
        action.setCallback(this, function(response) {
                var state = response.getState(); 
            console.log('state '+state);
               result = response.getReturnValue();
            if(state == "SUCCESS")
            { */
          
        var breaklen =  component.get("v.singleRec.Break_Length__c");
        var totalbreaklen =  component.get("v.singleRec.Break_from_Brekdef__c");
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
           
              console.log('shiftmin '+shiftmin1);
               console.log('caltime '+caltime);
             console.log('caltime '+shiftmin2);
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
                caltime= caltime - totalbreaklen;
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
         if(removedec<=98){
                var actualhrtime = Math.floor(actualhrtimef);
           }
       else
       {
             var actualhrtime = Math.ceil(actualhrtimef);
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
        component.set("v.TimeEditMode", false); 
          if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
      /*                      }
        }); 
           $A.enqueueAction(action); */
    }, 

      Save: function(component, event, helper) {
          
      // Check required fields(Name) first in helper method which is return true/false
     var hrs = component.get("v.Hours");
          console.log('hrs '+hrs);
            var toastEvent = $A.get("e.force:showToast");
          if(hrs=='NaN:NaN' || hrs=='00:00')
          {
                toastEvent.setParams({
                  
                    "message": "Timings can not be blank",
                     "duration" :500
                });

             toastEvent.fire();
              
          }
        else {
              var action = component.get("c.updateshifts");
             console.log('action ' +action);
                  action.setParams({
                    'ushift': component.get("v.singleRec"),
                    'stime' : component.get("v.popouthour"),
                    'etime' : component.get("v.popouthour2"),
                    'chargehours' : component.get("v.Hours")
                  });
            action.setCallback(this, function(response) {
                var state = response.getState();
                 var toastEvent = $A.get("e.force:showToast");
                console.log('response ' +state);
                
                if (state === "SUCCESS") {
                    
                    var storeResponse = response.getReturnValue();
         			console.log('storeResponse '+storeResponse);
                    component.set("v.singleRec", storeResponse);
                    
                 toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your data submitted successfully."
                });

             toastEvent.fire();
                     component.set("v.stopedit", true);
                }
                         else  {
                            toastEvent.setParams({
                            "title": "Sorry!",
                            "message": " There is some issues while submitting. Please contact your consultant"
                });
                     toastEvent.fire();
            }

                          
            });
            
            $A.enqueueAction(action);
        } 
        
      
          
    },
    
openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
     
      component.set("v.isOpen", true);
    component.set("v.childAttr", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
        component.set("v.childAttr", false);
   },
 
   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      alert('thanks for like Us :)');
      component.set("v.isOpen", false);
   },
    onChildAttrChange: function(cmp, evt) {
        console.log("childAttr has changed");
        console.log("old value: " + evt.getParam("oldValue"));
        console.log("current value: " + evt.getParam("value"));
    },
    openModelQuery: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
     
      component.set("v.isOpenQuery", true);
    component.set("v.childAttr", true);
   },
     SendQueryEmail: function(component, event, helper) {
       var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS'+ids);
         var textarea =  document.getElementById("myTextarea").value;
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
      component.set("v.childAttr", false);
    },
    
    SendQuery: function(component, event, helper) {
        var comments = component.get("v.SendQuery1");
		console.log("comments: " + comments);
    },
   getQuery: function(component, event, helper) {
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS---'+ids);
        var action = component.get("c.getTimesheetDetails");
        action.setParams({ 'TimesheetId': ids });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.QueryTextBoxString", 'Timesheet:-'+response.getReturnValue()[0].Name+', Site:-'+response.getReturnValue()[0].sirenum__Site__r.Name+', Job Role:-'+response.getReturnValue()[0].sirenum__Team__r.Name);
                component.set("v.TimesheetID",response.getReturnValue()[0].ID);                
                component.set("v.isOpenQuery", true);
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpenQuery", false);
            }
        });
        $A.enqueueAction(action);
    },    
})
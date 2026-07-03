({
    calculateChargableHours : function(component) {
        
        var start=component.get("v.starthour");
        var end=component.get("v.endhour");
        
        var br=(component.get("v.record").sirenum__Break_Length__c)*60000;
       
        var brkmin = component.get("v.record").Break_from_Brekdef__c;
        var shiftlen = component.get("v.record").Shift_Length_from_Break__c;
        var brkdisp = component.get("v.record").Break_Length__c;
          var totalbrk = component.get("v.record").Total_Shift_BreakLength__c;
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
        
        
        
        var shiftid = component.get("v.record").Id;
     /*    var result;
    
            var action = component.get("c.getbreaks");
                  action.setParams({
                    "shiftid" : shiftid
                  });
        action.setCallback(this, function(response) {
                var state = response.getState(); 
     
               result = response.getReturnValue();
 
            if(state == 'SUCCESS')
            { */

        if(start!=null && end!=null){
            var startTime = new Date();
            startTime.setHours(start.substr(0,start.indexOf(":")));
            startTime.setMinutes(start.substr(start.indexOf(":")+1));	
            
            var endTime = new Date();
            endTime.setHours(end.substr(0,end.indexOf(":")));
            endTime.setMinutes(end.substr(end.indexOf(":")+1));	
              var today = new Date();
            if(endTime<startTime)
            {
                endTime.setDate(today.getDate() +1);
                endTime.setHours(end.substr(0,end.indexOf(":")));
                endTime.setMinutes(end.substr(end.indexOf(":")+1));	
            }
            var duration = endTime.getTime() - startTime.getTime();
            var durtime = Math.ceil((endTime.getTime() - startTime.getTime())/(1000*60)); 
          
            var brkdur = brkmin * 60000;
        
               if(totalbrk == null)
          {
               var shiftmin1 = len1 * 60;  
          }
       else
       {
         var shiftmin1 = len1 * 60;  
          var shiftmin2 = len2 * 60;  
       }
         
        if(durtime<shiftmin1)
        {
            console.log('in IF');
            if(totalbrk == null)
            {
                 component.set("v.brktime",'00:00');  
            }
            else
            {
                if(durtime>=shiftmin2)
                {
                    
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
            else if(durtime>=shiftmin1)
            {
              component.set("v.brktime",brkdisp);   
            }
            else
            {
               component.set("v.brktime",null);  
            }
            
           
            var diff;
         
            if(br>0 && durtime>=shiftmin1){
                diff = duration - brkdur;
            }
            else if(durtime>=shiftmin1)
            {
                diff = duration - brkdur;
            }
            else if(durtime<shiftmin1 && durtime>=shiftmin2){
               var secondbrk = brk2 * 60000;
                diff= duration - secondbrk;
            }
            else
            {
                 diff= duration;
            }
            
            var hours = Math.floor(diff / (1000 * 60 * 60));
            diff -= hours * (1000 * 60 * 60);
            
            var mins = Math.floor(diff / (1000 * 60));
            diff -= mins * (1000 * 60);
            if(mins<10){
                mins="0"+mins;
            }
            if(hours<10){
                hours="0"+hours;
            }
      
            component.set("v.chargableTime",hours + ":" + mins);
        }
     /*  }
        }); 
        $A.enqueueAction(action); */
    }
})
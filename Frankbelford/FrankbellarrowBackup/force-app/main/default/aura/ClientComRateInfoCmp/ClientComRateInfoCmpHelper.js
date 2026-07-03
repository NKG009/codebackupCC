({
    dosearch :function(component,event,helper) {
        console.log('test search ');
        var jobroleId =  component.get("v.selectedjobrole");
        console.log('test jobroleId '+jobroleId);
       var ratelist = component.get('c.getRateCardList');	
        ratelist.setParams({
                "jobrolId": jobroleId
            });
         console.log('test ratelist '+ratelist);
        ratelist.setCallback(this, function(response){
            var optsRate = [];
          
            var state = response.getState();
              console.log('test state '+state);
            if(component.isValid() && state == 'SUCCESS'){
                
                var rateArray = response.getReturnValue();    
                  console.log('test rateArray '+rateArray);
                for (var i = 0; i < rateArray.length; i++) {
                    component.set("v.selectedRating",rateArray[0].Id);
                      // component.set("v.selectedRateCode",rateArray[0].sirenum__Rate_Card__c);

                        optsRate.push({
                            class: "optionClass",
                            label: rateArray[i].Name,
                            value: rateArray[i].Id,
                            selected: true
                        });
                   
                }
                component.set("v.ratecardList",optsRate);
                
                
                   var el = document.getElementById('overlay');
        el.style.display = "block";
         setTimeout(function(){ 
                
        console.log('TEST## ' +component.get("v.selectedRating"));
              var rateId =  component.get("v.selectedRating");
            
            helper.doSearchRateModifier(component,event,helper,rateId,jobroleId);
            
            
               setTimeout(function(){ 
         var el = document.getElementById('overlay');
        el.style.display = "none";   
             },2000);       
         },1000);

            }
            else{  component.set("v.RateLine","");
                  component.set("v.ratecardList","");
                 component.set("v.Regular","");
                  component.set("v.SHour","");
          
                }
            
           
          
            
            
        });    
         
          
        $A.enqueueAction(ratelist);
               
       

        
    },
    doSearchRate :function(component,event,helper,rateId) {
        console.log('test searchrateline ');
       
        console.log('test rateId '+rateId);
       var rateline = component.get('c.getRateLneList2');	
        rateline.setParams({
                "ratecardId": rateId
            });
         console.log('test rateline '+rateline);
        rateline.setCallback(this, function(response){
            var optsRate = [];
          
            var state = response.getState();
              console.log('test rate state '+state);
            if(component.isValid() && state == 'SUCCESS'){
                
                var rateArray = response.getReturnValue();    
                if(rateArray.length >0){
                console.log('test rateArray '+rateArray.length +' $$ '+rateArray[0].sirenum__Start_Hour__c +' && '+rateArray[0].sirenum__End_Hour__c);
                  component.set("v.Regular","Regular");
               component.set("v.RateLine",rateArray);
                }
                else{
                    
                }
            }
            
            
            
            
        });        
        $A.enqueueAction(rateline);
         helper.doSearchRateModifier(component,event,helper,rateId);
        
    },
       doSearchRateModifier :function(component,event,helper,rateId) {
        console.log('test searchrateline ');
       
        console.log('test rateId '+rateId);
       var ratemodifier = component.get('c.getRateLneList');	
        ratemodifier.setParams({
                "ratecardId": rateId
            });
         console.log('test ratemodifier '+ratemodifier);
        ratemodifier.setCallback(this, function(response){
            var optsRate = [];
          
            var state = response.getState();
              console.log('test rate state '+state);
            
            if(component.isValid() && state == 'SUCCESS'){
                 
                var rateArray = response.getReturnValue();    
                     console.log('test RateModifier '+rateArray.length);
            
               component.set("v.RateModifier",rateArray);
       
            }
        
            
            
            
        });  
         var empty = $("td input").filter(function(){ 
            
             return this.value ==="" 
         }) 
    console.log('emp '+empty);
        $A.enqueueAction(ratemodifier);
             
        
    },
   
     getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
	   getLoggedInUserName :function(component){
        var fetchUserName = component.get("c.fetchUser");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            console.log(' in state '+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },
        getSiteList :function(component) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
            var selectsite=  component.get("v.site"); 
             console.log('selectsite&&selectsite '+selectsite);
            var siteRecId;
            if(selectsite == '' || typeof selectsite == 'undefined' ){
             siteRecId = url.split("site=")[1];
            }
            else
            {
                 siteRecId = selectsite;
            }
        
        console.log('siteRecId '+siteRecId);
          component.set("v.site", siteRecId); 
        var sitesList = component.get('c.getSitesOfLoggedInUser');		
        sitesList.setCallback(this, function(response){
            var optsSite = [];
            var siteID;
            var flag = 0;
            var state = response.getState();
            if(component.isValid() && state == 'SUCCESS'){
                var SiteArray = response.getReturnValue();    
                for (var i = 0; i < SiteArray.length; i++) {
                    if(SiteArray[i].Id==siteRecId){
                        flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                        siteID = siteRecId;
                    }else{
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                            
                        });
                    }
                }
                if(flag==0){
                    console.log('flag: '+flag+' optsSite[0].Id: '+optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }
            }
            
            component.set("v.siteList",optsSite);
            component.set("v.selectedSite",selectId);
            
            
        });        
        $A.enqueueAction(sitesList);
    },
    
    getsitejobrole: function(component){
        
        console.log(' in getsite ');
        /*  var idParam = this.getJsonFromUrl().site;
        var selectedsite = component.get("v.selectedSite");
        var sendSite;
        if (selectedsite == null) {
            sendSite = idParam;
        } else {
            sendSite = selectedsite;
        }
         console.log(' sendSite '+sendSite);
       
      jobRole.setParams({
            "siteId": sendSite
        });*/
         var jobRole = component.get('c.getJobRoleList');
        jobRole.setCallback(this, function(response) {
            console.log('testingh'+response.getState());
            var state = response.getState();
            var optsJob = [];
              console.log('state '+state);
            if(component.isValid() && state == "SUCCESS") {
                var jobrolearray = response.getReturnValue();
                console.log('check site array'+jobrolearray);
                optsJob.push({
                    class: "optionClass",
                    label: "Select Job Role",
                    value: ""
                });
                for (var i = 0; i < jobrolearray.length; i++) {
                    optsJob.push({
                        class: "optionClass",
                        label: jobrolearray[i].Name,
                        value: jobrolearray[i].Id
                        
                    });
                    
                }
                 console.log(' optsJob '+optsJob);
                component.set("v.jobSiteList", optsJob);               
            }
        });
        console.log('jobRole 22 '+jobRole);
        $A.enqueueAction(jobRole);
    },
       getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
})
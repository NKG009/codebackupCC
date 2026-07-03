({
    changecand :function(component, event, helper){
          console.log('@test12');
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
            
            component.set("v.SiteList",optsSite);
          
            
            
        });        
        $A.enqueueAction(sitesList);
    },
         getJobList :function(component) {
    
        var jobList = component.get('c.getJobRoleList');		
        jobList.setCallback(this, function(response){
            var optsSite = [];
            var conID;
            var flag = 0;
            var state = response.getState();
            console.log('state jobrole '+state);
            if(component.isValid() && state == 'SUCCESS'){
                
                 
                var conArray = response.getReturnValue(); 
                 console.log('state jobrole conArray '+conArray);
                if(conArray == null){
                    console.log('state jobrole conArrayelse ');  
                }
                else{
                   
                
                for (var i = 0; i < conArray.length; i++) {
                   
                     
                        optsSite.push({
                            class: "optionClass",
                            label: conArray[i].Name,
                            value: conArray[i].Id,
                            selected: true
                        });
                     
                }
                
                }
            }
          
            component.set("v.JobList",optsSite);
          
            
            
        });        
        $A.enqueueAction(jobList);
    },
         getContactList :function(component) {
    
        var conList = component.get('c.getContactList');		
        conList.setCallback(this, function(response){
            var optsSite = [];
            var conID;
            var flag = 0;
            var state = response.getState();
            console.log('state contact '+state);
            if(component.isValid() && state == 'SUCCESS'){
                var conArray = response.getReturnValue();  
                
                 
if(conArray == null){
                    console.log('state jobrole conArrayelse ');  
                }
                else{               
                for (var i = 0; i < conArray.length; i++) {
                   
                     
                        optsSite.push({
                            class: "optionClass",
                            label: conArray[i].Name,
                            value: conArray[i].Id,
                            selected: true
                        });
                     
                }
                }
            }
           
            component.set("v.ContactList",optsSite);
          
            
            
        });        
        $A.enqueueAction(conList);
    },
          getPlaceList :function(component, event, helper) {
    console.log('@@ contact ');
    var selectedcand =  component.get('v.CandidateSelected');	
   var selectedjob =  component.get('v.Jobroleselected');
              console.log('@@ contact '+selectedcand+' job '+selectedjob);
        var placeList = component.get('c.getPlaceList');	
               placeList.setParams({
            "CandId": selectedcand,
            "jobroleId": selectedjob
        });
        placeList.setCallback(this, function(response){
       
   var result = response.getReturnValue();
              var state = response.getState();
            if(state == 'SUCCESS'){
          console.log('@@resultplace '+result);   
            component.set("v.PlaceList", result);
     console.log('@@ '+result.length);
            // alert(3);
            if(result.length>0){
                var total =0;
                for(var i = 0;i<result.length;i++){
                  var count = parseFloat(result[i].TotalForecastValue__c); 
                  
                      console.log('Total count '+count);
                  total = total + count;
                }
             total = total.toFixed(2);
                console.log('Total  '+total );
                var str = String(total);
                     console.log('@@ str '+str);
                if(!str.includes("."))
                {
                    console.log('no decimal '+total);
                    str = str+'.00'
                }
                console.log('Total Cost '+str);
                component.set('v.TotalCost',str);
              		$("#overlay").show();
         
				setTimeout(function () {
					$('#tableId').DataTable({
						 responsive:true,
                            aaSorting: [],
                            columnDefs: [
                                { "orderable": false,"targets": [0,6] },
                                
                            ]
					
					});

					
			$("#overlay").hide();	}, 500);
                     }
                                else
                                {
                                $("#overlay").show();
         
				setTimeout(function () {
					$('#tableId').DataTable({
						 responsive:true,
                            aaSorting: [],
                            columnDefs: [
                                { "orderable": false,"targets": [0,6] },
                                
                            ]
					
					});

					
			$("#overlay").hide();	}, 500);
                                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                'message': 'No records available for this search',
                 'Duration': '20'
                 });
               toastEvent.fire();
                                }
             }
             else{
                        $("#overlay").show();
         
				setTimeout(function () {
					$('#tableId').DataTable({
						 responsive:true,
                            aaSorting: [],
                            columnDefs: [
                                { "orderable": false,"targets": [0,6] },
                                
                            ]
					
					});

					
			$("#overlay").hide();	}, 500);
                                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                'message': 'No records available for this search',
                 'Duration': '20'
                 });
               toastEvent.fire();          
                                
                 }
        });      
                                
        $A.enqueueAction(placeList);
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
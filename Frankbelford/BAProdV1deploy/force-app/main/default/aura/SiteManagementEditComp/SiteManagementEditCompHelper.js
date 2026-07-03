({
    getSiteList :function(component) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
           component.set("v.site", siteRecId); 
         console.log('optsSite ');
        var sitesList = component.get('c.getSitesOfLoggedInUser');		
        sitesList.setCallback(this, function(response){
             var state = response.getState();
           var optsSite = [];
         	var siteID;
             var flag = 0;
            if(component.isValid() && state == "SUCCESS") {
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
           
                component.set("v.siteList", optsSite);                
              
                        });        
        $A.enqueueAction(sitesList);
    },
    
    getLoggedInUserInformation :function(component){
        var fetchUserName = component.get("c.fetchUserInformation");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },
    
    SiteInformationToupdate : function(component,event){
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        
        var action = component.get("c.fetchSiteInformation");
        action.setParams({
            siteId : siteRecId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //alert('==storeResponse=='+storeResponse);
                component.set("v.SiteInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateSiteInfo : function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        var isValid = true;
        var siteId = component.find("siteId").get("v.value");
        
        var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');
        
        if(siteId == undefined || siteId == ""){            
            siteId = siteRecId;
        }
        
        var mainContactFirstName = component.find("mainContactFirstNameId").get("v.value");
        var mainContactLastName = component.find("mainContactLastNameId").get("v.value");
        var mainContactEmail = component.find("mainContactEmailId").get("v.value");
        var emgContactFirstName = component.find("emgConFirstNameId").get("v.value");
        var emgContactLastName = component.find("emgConLastNameId").get("v.value");
        var emgContactEmail = component.find("emgConEmailId").get("v.value");
		var street = component.find("streetId").get("v.value");
		var state = component.find("stateId").get("v.value");
		var city = component.find("cityId").get("v.value");
		var country = component.find("countryId").get("v.value");
		var postalCode = component.find("postalcodeId").get("v.value");
		var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		if(street == undefined || street == "" || street == null ){
			street = '';
		}
		if(state == undefined || state == "" || state == null ){
			state = '';
		}
		if(city == undefined || city == "" || city == null ){
			city = '';
		}
		if(country == undefined || country == "" || country == null ){
			country = '';
		}
		if(postalCode == undefined || postalCode == "" || postalCode == null ){
			postalCode = '';
		}
        if(mainContactFirstName == undefined || mainContactFirstName == "" || mainContactFirstName == null ){
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Please enter First Name of Main Contact"
                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(mainContactLastName == undefined || mainContactLastName == "" || mainContactLastName == null ){
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Please enter Last Name of Main Contact"
                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(mainContactEmail == undefined || mainContactEmail == "" || mainContactEmail == null ){
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Please enter Email of Main Contact"
                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(emgContactFirstName == undefined || emgContactFirstName == "" || emgContactFirstName == null ){
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Please enter First Name of Emergency Contact"
                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(emgContactLastName == undefined || emgContactLastName == "" || emgContactLastName == null ){
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Please enter Last Name of Emergency Contact"
                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(emgContactEmail == undefined || emgContactEmail == "" || emgContactEmail == null ){
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Please enter Email of Emergency Contact"
                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(!mainContactEmail.match(regExpEmailformat)){
            toastEvent.setParams({                  
                    "title" : "Error!!",
                    "message": "Please Enter a Valid Email Address of Main Contact"                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(!emgContactEmail.match(regExpEmailformat)){
            toastEvent.setParams({                  
                    "title" : "Error!!",
                    "message": "Please Enter a Valid Email Address of Emergency Contact"                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(isValid){
            var action = component.get("c.updateSitedetails");
            action.setParams({
                siteId : siteId,
                mainContactFirstName : mainContactFirstName,
				mainContactLastName : mainContactLastName,
				mainContactEmail : mainContactEmail,
				emgContactFirstName : emgContactFirstName,
				emgContactLastName : emgContactLastName,
				emgContactEmail : emgContactEmail,
				street : street,
				city : city,
				state : state,				
				country : country,
				postalCode : postalCode
            });
			// Add callback behavior for when response is received
			action.setCallback(this,function (response) {
					   var state = response.getState();
						if(component.isValid() && response.getState() == 'SUCCESS'){
							var message = response.getReturnValue(); 
							console.log('message11:',message);
							if(message == 'Success'){
                                component.set("v.displayPopup",true);
                                toastEvent.setParams({
									title : '',
                                    message: "Site contact information has been updated, please allow for a couple of minutes for the screen to update.",
                                    duration:' 500',
                                    key: 'info_alt',
                                    type: 'success',
                                    mode: 'pester'
								});
								toastEvent.fire();
                                this.goback(component);
                            }                            
							else if(message == "ForceTochangeEmailMainContact"){
                                toastEvent.setParams({
									title : '',
                                    message: "Please update the Email address of the main contact, as you have updated either the First Name or Last Name.",
                                    duration:' 1500',
                                    key: 'info_alt',
                                    mode: 'pester'
								});
								toastEvent.fire();
							}else if(message == "ForceTochangeEmailEmergencyContact"){
								toastEvent.setParams({
									title : '',
                                    message: "Please update the Email address of the escalation contact, as you have updated either the First Name or Last Name.",
                                    duration:' 1500',
                                    key: 'info_alt',
                                    mode: 'pester'
								});
								toastEvent.fire();
							}
                            else if(message == 'Error'){
								toastEvent.setParams({
                                    title : '',
                                    message: 'There is some issues while updating site information, please contact your consultant',
                                    duration:' 500',
                                    key: 'info_alt',
                                    mode: 'pester'
                                });
                                toastEvent.fire();
							}
						}
						else {
                            console.log('message222:',message);
							toastEvent.setParams({
                                title : '',
                                message: 'There is some issues while updating site information, please contact your consultant',
                                duration:' 500',
                                key: 'info_alt',
                                mode: 'pester'
							});
                            toastEvent.fire();
						}
				   });
            
        }
      $A.enqueueAction(action);
        
    },
    goback: function(component){
        var param = component.find('siteId').get('v.value');
        if(param == null || param == undefined || param == "")
        {
           param = this.getJsonFromUrl().site;
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/sitemanagement?site='+param
        });
        urlEvent.fire();
    },
     getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    }
    
})
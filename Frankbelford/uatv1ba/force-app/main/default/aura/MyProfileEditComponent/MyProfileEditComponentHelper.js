({
	getSiteList :function(component) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
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
            component.set("v.siteIdValue",siteID)
		
        });        
        $A.enqueueAction(sitesList);
    },
    submitLoggedInuserInfo :function(component,event){
        var toastEvent = $A.get("e.force:showToast");
        var firstname = $("#firstNameId").val();
        var lastname = $("#lastNameId").val();
        var email = $("#emailId").val();
        var mobilephone = $("#mobilephoneId").val();
        var phoneval = $("#phoneId").val();
		var sitevalue = component.find("siteId").get("v.value");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var isValid = true;
		var popupmessage = false;
        if(firstname == undefined || firstname == ""){
            toastEvent.setParams({
                    "message": "Please enter First Name"                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(lastname == undefined || lastname == ""){
            toastEvent.setParams({
                    "message": "Please enter Last Name"                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(email == undefined || email == ""){
            toastEvent.setParams({ 
                    "message": "Please enter Email"                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(!email.match(regExpEmailformat)){
            toastEvent.setParams({
                    "message": "Please Enter a Valid Email Address"                    
                });
			isValid = false;
            toastEvent.fire();
        }
        if(isNaN(mobilephone)){
            toastEvent.setParams({ 
                    "message": "Please enter valid Mobile Phone",              
                });
			isValid = false;
            toastEvent.fire();            
        }
        if(isNaN(phoneval)){
            toastEvent.setParams({   
                    "message": "Please enter valid Phone",             
                });
			isValid = false;
            toastEvent.fire();            
        }
        
		if(isValid == true){
			var updateUserInformation = component.get("c.updateUserInformation");
			updateUserInformation.setParams({
				firstname : $("#firstNameId").val(),
				lastname : $("#lastNameId").val(),
				title : $("#titleId").val(),
				email : $("#emailId").val(),
				mobilephone : $("#mobilephoneId").val(),
				phone : $("#phoneId").val(),
				street : $("#streetId").val(),
				addressline : $("#addressline2Id").val(),
				state : $("#stateId").val(),
				city : $("#cityId").val(),
				country : $("#countryId").val(),
				postalCode : $("#postalCodeId").val()
			});
			updateUserInformation.setCallback(this,function(response){
				var state = response.getState();
				if(component.isValid() && state == 'SUCCESS'){
					var storeResponse = response.getReturnValue();
					console.log('+++++++++++storeResponse++++++++++'+storeResponse);
					if(storeResponse=='User Updated Successfully'){
						toastEvent.setParams({
								"message": "Profile has been updated successfully!",
                            	'type': 'success',
							});
						toastEvent.fire();
                        var delayInMilliseconds = 2000;
                            window.setTimeout(
                            $A.getCallback(function() {
                            var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile"+'?site='+component.get("v.siteIdValue");
                            window.location.replace(urlRedirect);		
                            return false;
                                 }), delayInMilliseconds
                        );     
					}
					else if(storeResponse==$A.get("$Label.c.EmailAlreadyExist")){
						toastEvent.setParams({
								"message": $A.get("$Label.c.EmailAlreadyExist")                
							});
						toastEvent.fire();
					}
					else{
						toastEvent.setParams({
								"message": storeResponse                    
							});
						toastEvent.fire();
					}
				}
			});
		//component.set("v.displayPopup", false);
		$A.enqueueAction(updateUserInformation);		
		/*var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
			"url": "/myprofile"
		});
		urlEvent.fire();*/
		}
    },
    getLoggedInUserInformation :function(component){
        var fetchUserName = component.get("c.fetchUserInformation");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
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
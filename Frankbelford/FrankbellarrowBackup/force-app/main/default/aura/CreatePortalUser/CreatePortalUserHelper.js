({

    doInitCallToServer : function(component, event, helper) {      
        var action = component.get("c.getContact");
		action.setParams({"contactId": component.get("v.recordId")});
        component.set("v.ContactId",component.get("v.recordId"));
        component.set("v.roleId",$A.get("$Label.c.CustomerPortalRoleId"));         
		//component.set("v.profileId",$A.get("$Label.c.UserPortalId"));
		//console.log('++++++++++profileId id+++++ '+component.get("v.profileId"));
        component.set("v.licenseId",$A.get("$Label.c.CustomerPortalUserLicenseId"));		
        
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('++++++++++result+++++ '+result.Email);
			if(state === "SUCCESS") {				
                component.set("v.RecordType",result.RecordType.Name);
                var recordTypeValue =  component.get("v.RecordType");
                console.log('+++recordTypeValue+++'+recordTypeValue);
				component.find('firstNameField').set('v.value', result.FirstName);
				component.find('userRoleField').set('v.value', $A.get("$Label.c.CustomerPortalRoleId"));
				component.find('licenseId').set('v.value', $A.get("$Label.c.CustomerPortalUserLicenseId"));
                component.find('lastName').set('v.value', result.LastName);
				component.find('isActive').set('v.value', true);
				component.find('alias').set('v.value', result.IP_Alias__c);
				component.find('email').set('v.value', result.Email);                
				component.find('userName').set('v.value', result.Email);
				component.find('phone').set('v.value', result.Phone);
				component.find('mobilePhone').set('v.value', result.MobilePhone);
				component.find('contactId').set('v.value', result.id);
				component.find('street').set('v.value', result.MailingStreet);
				component.find('city').set('v.value', result.MailingCity);
				component.find('state').set('v.value', result.MailingState);
				component.find('postalCode').set('v.value', result.MailingPostalCode);
				component.find('country').set('v.value', result.MailingCountry);
				component.find('communityNickname').set('v.value', result.IP_Alias__c);
				component.find('niNumber').set('v.value', result.sirenum__National_Insurance__c);
				component.find('ipTempestDepartment').set('v.value', result.IP_TempestDepartment__c);
                console.log('++++++++++UserPortalId+++++ '+$A.get("$Label.c.UserPortalId"));
                console.log('++++++++++CustomerPortalManagerCustom+++++ '+$A.get("$Label.c.CustomerPortalManagerCustom"));
                /*if(recordTypeValue == 'Candidate'){
                    console.log('++++++++++inside Candidate+++++ ');
                	component.find('profileId').set('v.value', $A.get("$Label.c.UserPortalId"));
                	console.log('++++++++++recordTypeValue+++++ '+$A.get("$Label.c.UserPortalId"));
                }
                else if(recordTypeValue == 'Contact'){
                    console.log('++++++++++inside Contact+++++ '+component.find('profileId'));
                    component.find('profileId').set('v.value', $A.get("$Label.c.CustomerPortalManagerCustom"));
                	console.log('++++++++++recordTypeValue+++++ '+$A.get("$Label.c.CustomerPortalManagerCustom"));
                } */ 
                if(recordTypeValue == 'Candidate'){
                    console.log('++++++++++inside Candidate+++++ ');
                    component.set("v.profileId",$A.get("$Label.c.UserPortalId"));
                }
                else if(recordTypeValue == 'Contact'){
                    component.set("v.profileId",$A.get("$Label.c.CustomerPortalManagerCustom"));
                } 
			}
        });
        $A.enqueueAction(action);
    },
	populateUserData : function (component, event,helper) {
        var payload = event.getParam("fields");
		//var contactId = component.get("v.recordId");
        var contactId = component.get("v.ContactId");
		console.log('++++++++++inside payload+++++ '+contactId);
		console.log('++++++++++inside payload+++++ '+payload);
        var User_Data = {
            "FirstName" : payload["FirstName"],
            "UserRoleId" : payload["UserRoleId"],
            "MiddleName" : payload["MiddleName"],
            "Profile.UserLicenseId" : payload["Profile.UserLicenseId"],
            "LastName" : payload["LastName"],
            //"ProfileId" : payload["ProfileId"],
            "Alias" : payload["Alias"],
            "Suffix" : payload["Suffix"],
            "Email" : payload["Email"],
            "IsActive" : payload["IsActive"],
            "Username" : payload["Username"],
            "Phone" : payload["Phone"],
            "MobilePhone" : payload["MobilePhone"],
            "ContactId" : contactId,
            "Street" : payload["Street"],
            "City" : payload["City"],
            "State" : payload["State"],
            "PostalCode" : payload["PostalCode"],
            "Country" : payload["Country"],
            "CommunityNickname" : payload["CommunityNickname"],
            "NI_Number__c" : payload["NI_Number__c"],
            "IP_TempestDepartment__c" : payload["IP_TempestDepartment__c"]
        };
		//alert('User_Data>>>>'+User_Data.IP_TempestDepartment__c);
        return User_Data;
    },
    
	 submitUserData : function(component, event, helper) {	 
		var User_Data = this.populateUserData(component, event,helper);
        var action = component.get("c.insertPortalUser");
		console.log('++++++++++Profile iDddddddd+++++ '+component.get("v.profileId"));
         action.setParams({"portalUser": User_Data,"profileId":component.get("v.profileId")});        
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS" && result==='User Inserted Successfully') {				
                console.log('++++++++++result id+++++ '+result);
                component.set("v.responseDetails",result);
                component.set("v.responseExist",true);
                //$A.get("e.force:closeQuickAction").fire();
            }else{
                component.set("v.responseDetails",result);
                component.set("v.responseExist",true);                
                console.log('++++++++++error result+++++ '+result);
            }
            console.log('++++++++++result+++++ '+result);
        });
        $A.enqueueAction(action);
    }

})
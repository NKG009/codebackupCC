({
	doInit : function(component, event, helper) {
    var action = component.get("c.getUsernfo");
         action.setParams({
            "site" : component.get("v.site")
        });
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var storeResponse = response.getReturnValue()['User'];
                var siteResponse = response.getReturnValue()['site'];
                component.set("v.Consultant", siteResponse.Owner.Name); 
                
                var BranchRes = response.getReturnValue()['ShifTemp'];
                
                if(BranchRes!= null && BranchRes.IP_Site_Name__c !=null && BranchRes.IP_Site_Name__c !== "" && BranchRes.IP_Site_Name__c !== 'undefined')
                {
                    component.set("v.BranchName", BranchRes.IP_Site_Name__c );
                }
                
                if(BranchRes!= null && BranchRes.Email__c!=null && BranchRes.Email__c!=="" && BranchRes.Email__c!== 'undefined')
                {
                    component.set("v.BranchEmail", BranchRes.Email__c);
                }
   
                if(BranchRes!= null && BranchRes.Phone__c !=null && BranchRes.Phone__c !=="" && BranchRes.Phone__c !='undefined')
                {
                    component.set("v.BranchPhone", BranchRes.Phone__c );
                }
                 
               
               // set current user information on userInfo attribute
              
               var BranchAddress=null;
                
                if(BranchRes.Branch_Address__c!=null && BranchRes.Branch_Address__c!== "" && BranchRes.Branch_Address__c!='undefined')
                {
                    BranchAddress=BranchRes.Branch_Address__c;
                }
                console.log('==BranchAddress42@@@=='+BranchAddress);
                if((BranchRes.IP_Branch_City__c !=null && BranchRes.IP_Branch_City__c !=="" && BranchRes.IP_Branch_City__c !=='undefined') && (BranchAddress!=null && BranchRes.Branch_Address__c!=="" && BranchRes.Branch_Address__c!=='undefined'))
                {
                    BranchAddress=BranchAddress+', '+BranchRes.IP_Branch_City__c ;
                }
                else
                {
                    BranchAddress=BranchAddress ;
                }  
                console.log('==BranchAddress51@@@=='+BranchAddress);
                if((BranchRes.IP_Branch_County__c != null && BranchRes.IP_Branch_County__c !== "" && BranchRes.IP_Branch_County__c !== 'undefined') && (BranchAddress!=null && BranchRes.Branch_Address__c != "" && BranchRes.Branch_Address__c !== 'undefined'))
                {
                    console.log('==BranchAddressinsideif609@@@=='+BranchRes.IP_Branch_County__c);
					BranchAddress=BranchAddress+','+BranchRes.IP_Branch_County__c;
                }
                else
                {
                    console.log('==BranchAddressinsideelse609@@@=='+BranchAddress);
					BranchAddress=BranchAddress;
                }
                console.log('==BranchAddress609@@@=='+BranchRes.IP_Branch_County__c);
                if(BranchRes.IP_Branch_Country__c!=null && BranchRes.IP_Branch_Country__c!== "" && BranchRes.IP_Branch_Country__c!== 'undefined'  && BranchAddress!=null && BranchRes.Branch_Address__c != "" && BranchRes.Branch_Address__c !== 'undefined')
                {
                    BranchAddress=BranchAddress+','+BranchRes.IP_Branch_Country__c;
                }
                else
                {
                    BranchAddress=BranchAddress;
                }
                console.log('==BranchAddress69@@@=='+BranchAddress);
                if(BranchRes.IP_Branch_Postal_Code__c !=null && BranchRes.IP_Branch_Postal_Code__c !== "" && BranchRes.IP_Branch_Postal_Code__c !== 'undefined' && BranchAddress!=null && BranchRes.Branch_Address__c != "" && BranchRes.Branch_Address__c !== 'undefined')
                {
                    BranchAddress=BranchAddress+', '+BranchRes.IP_Branch_Postal_Code__c ;
                }
                else
                {
                    BranchAddress=BranchAddress ;
                }
                component.set("v.BranchAddress", BranchAddress);
               // component.set("v.userInfo", storeResponse);
               console.log('==BranchAdassadress@@@=='+BranchAddress);
            }
        });
        $A.enqueueAction(action);
    }
})
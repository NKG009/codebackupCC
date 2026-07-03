({ 
    
	 myAction : function(component, event, helper) {
     
        var action=component.get("c.ContactRoleData");
         action.setParams({
             accid:component.get("v.recordId")
         });
       
       
        action.setCallback(this, function(data){
            var incomingcontact = data.getReturnValue();
           
            console.log('Contact Name ', JSON.stringify(incomingcontact));
            console.log('Contact Name ', incomingcontact[0].roles[0].name);
             var arrayElement=[];
        for(var i in incomingcontact){
           console.log('insidefor');
            if(incomingcontact[i].roles[0].name == 'Property Manager' && incomingcontact[i].roles[0].property_management_contact == true){
            var data= new Object();
            data.FName=incomingcontact[i].first_name;
            data.LName=incomingcontact[i].last_name;
             data.ExtId=incomingcontact[i].id;
            data.Roles=incomingcontact[i].roles[0].name;
            arrayElement.push(data);
        }
        } 
           component.set("v.Account", arrayElement);
            component.set("v.rawdata", incomingcontact);
         /*     component.set("v.fname", accData[0].first_name);
             component.set("v.propertytreeExternalcontactid", accData[0].id);
            component.set("v.lname", accData[0].last_name);
            console.log('fname ', accData[0].first_name);
            console.log('lname ', accData[0].last_name);
            console.log('ID ', accData[0].id);*/
          
 		});
        $A.enqueueAction(action);
            },
    
    //onclick action on button update
     updateAcc : function(component, event, helper) {
    var upAcc=component.get("c.PropertyManagerDataupdate");
     
            console.log('rawdata 2 ', JSON.stringify(component.get("v.rawdata")));
         var datad=JSON.stringify(component.get("v.rawdata"));
         console.log('datad'+datad);
        upAcc.setParams({
             accid:component.get("v.recordId"),
            varre:datad        
            });
      
         
         upAcc.setCallback(this, function(data){
             console.log('state ', JSON.stringify(data.getState()));
           
             if(data.getState()=='SUCCESS'){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":'success',
                    "message": "The Propert Agent has been updated successfully."
                });
                toastEvent.fire();
             }
              var dismissActionPanel = $A.get("e.force:closeQuickAction");
              dismissActionPanel.fire();
             $A.get('e.force:refreshView').fire();
 		});
        $A.enqueueAction(upAcc);
             // $A.get('e.force:refreshView').fire();
            }

})
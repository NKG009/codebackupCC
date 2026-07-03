({
     MyProfileNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = helper.getJsonFromUrl().site; 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    SiteManagementNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = helper.getJsonFromUrl().site; 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
      logout: function(component, event, helper)
                    {
                        event.preventDefault();
                        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
                        window.location.replace(urlRedirect);
                        return false;
                    },
       BulkPOUpload: function(component, event, helper) {
        var selectedTimesheets = [];
        var checkvalue = component.find("checkTimesheet");
           var  ponumberbulk = document.getElementById("PONumber").value
       // var  ponumberbulk = component.find("PONumber").get("v.value");
        console.log('InvoicePO-->'+ponumberbulk+ ' && ' +checkvalue);
           if( typeof checkvalue == 'undefined' || checkvalue==''){
             
           }else{
                    if(!Array.isArray(checkvalue)){
                        if (checkvalue.get("v.value") == true) {
                            selectedTimesheets.push(checkvalue.get("v.text"));
                        }
                    }else{
                        for (var i = 0; i < checkvalue.length; i++) {
                            if (checkvalue[i].get("v.value") == true) {
                                selectedTimesheets.push(checkvalue[i].get("v.text"));
                            }
                        }
                    }
           }
        component.set("v.selectedtimesheetIds",selectedTimesheets);
        console.log('selectedtimesheets--'+ponumberbulk+' '+selectedTimesheets);
		if((ponumberbulk == null || ponumberbulk == '' || ponumberbulk == 'undefined') || (selectedTimesheets == '' || selectedTimesheets == null))
		{
			var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                'message': 'Please ensure you select a record and enter a PO number to apply',
                 'Duration': '300'
                 });
               toastEvent.fire();
		}
		else
		{
        var action = component.get("c.UpdateBulkPO");
        action.setParams({
            "Ponumber": ponumberbulk,
            "placelist": selectedTimesheets
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log('result '+result);
            //  var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (result == "SUCCESS") {
                 $("#overlay").show();
                 var dataTable = $('#tableId').DataTable();
       //  
         dataTable.destroy();
     // dataTable.clear();
      helper.getPlaceList(component, event, helper); 
             
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                'message': 'PO Number has been successfully updated',
                 'type': 'success',
                 'Duration': '300'
                 });
               toastEvent.fire();
                
           document.getElementById("PONumber").value = '';   
          component.find("selectAll").set("v.value",false); 
          /*   var delayInMilliseconds = 2000;
            window.setTimeout(
            $A.getCallback(function() {
            window.location.reload();
                 }), delayInMilliseconds
        );     */ 
           //  window.location.reload();
            }
            else{
                Console.log('Error');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                'message': 'An error occured in updating PO',
                 'Duration': '1500'
                 });
               toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
		}
    },
      getShift : function(component,event,helper){
                            //   console.log('TimeSheetId:');
                            component.set("v.isOpen", true);
                            var idName = event.target.id;
                           var payrollWeek = event.target.name;
                               console.log('idName: '+idName+payrollWeek);
                            var getallShifts = component.get("c.getShifts"); 
          getallShifts.setParams({"placeId":idName, "PayrollWeek":payrollWeek});
                            getallShifts.setCallback(this,function(result){
                               console.log('@@result '+result);
                                var lineRecords = result.getReturnValue();
                                 console.log('@@ '+lineRecords);
                                    component.set("v.vShifts",lineRecords);
                                   
                                
                            });
                            $A.enqueueAction(getallShifts);    
                        },
   dashboardnavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
        
        if(param == null)
        {
            param = helper.getJsonFromUrl().site;  
        }
        
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
  
    searchShifts : function(component, event, helper) {
        console.log('@test');
          $("#overlay").show();
         var dataTable = $('#tableId').DataTable();
        // dataTable.hide();
         dataTable.destroy();
      
      helper.getPlaceList(component, event, helper);
    },
     resetAllValues : function(component,event,helper){
      //   console.log('reset ');
        if(component.get("v.Jobroleselected") != null ||  component.get("v.CandidateSelected") != null )
        {
        component.set("v.Jobroleselected", null);
      
        component.set("v.CandidateSelected", null);
              $("#overlay").show();
    	var dataTable = $('#tableId').DataTable();
       
         dataTable.destroy();
          helper.getPlaceList(component, event, helper);
        }
    },
    onChangeCandidateVal: function(component,event,helper){
        console.log('Conchange');
        var Candidate = event.getSource().get('v.value')
           console.log('Candidate '+Candidate);
       component.set("v.CandidateSelected",Candidate);
        
    },
    onChangeRoleVal : function(component,event,helper){
        console.log('jobchange');
        var jobrole = event.getSource().get('v.value')
           console.log('jobrole '+jobrole);
       component.set("v.Jobroleselected",jobrole);
       
    },
  doInit : function(component, event, helper) {
   //  $("#overlay").show();
  
		helper.getLoggedInUserName(component);
        helper.getSiteList(component);	
        helper.getJobList(component);
       helper.getContactList(component);
    
        helper.getPlaceList(component, event, helper);
    	
	},
    
      handleSelectAllTimesheet: function(component, event, helper) {
           console.log('checkTimesheet@@@')  
        var getID = component.get("v.PlaceList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkTimesheet = component.find("checkTimesheet"); 
         console.log('checkTimesheet'+checkTimesheet)
         if (!Array.isArray(checkTimesheet)) {
    checkTimesheet = [checkTimesheet];
}
        if(checkvalue == true){
            console.log('inside 1st if'+checkTimesheet.length);
            for(var i=0; i<checkTimesheet.length; i++){
                checkTimesheet[i].set("v.value",true);
                console.log('inside 1st for');
            }
        }
        else{ 
            for(var i=0; i<checkTimesheet.length; i++){
                checkTimesheet[i].set("v.value",false);
            }
        }
    },
})
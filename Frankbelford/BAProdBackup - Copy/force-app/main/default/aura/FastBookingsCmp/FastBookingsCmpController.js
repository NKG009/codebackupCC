({
	doInit : function(component, event, helper){
        var sitesList = component.get('c.getsitesList');
        sitesList.setCallback(this, function(response){
            console.log('response from fast booking:' ,response.getReturnValue(),response.getState()+ ' '+component.isValid());
            var optSites = [];
        	var state = response.getState();
            if(component.isValid() && state == 'SUCCESS'){
                optSites.push({
                    label:"Select Site",
                    value:""
                });
                var siteArray = response.getReturnValue();
                for(var i=0;i<siteArray.length;i++){
                    optSites.push({
                        label:siteArray[i].Name,
                        value:siteArray[i].Id
                    });
                }
            }
            component.set("v.siteList",optSites);
        });
        
        var jobsites = component.get('c.getJobRoleList');
        jobsites.setCallback(this,function(response){
            var OptsjobSites = [];
            var jobSitesArray = response.getReturnValue();
            var state = response.getState();
            if(component.isValid() && state == 'SUCCESS'){
                OptsjobSites.push({
                    label:"Select JobRole",
                    value:""
                });
                var siteArray = response.getReturnValue();
                for(var i=0;i<jobSitesArray.length;i++){
                    OptsjobSites.push({
                        label:jobSitesArray[i].Name,
                        value:jobSitesArray[i].Id
                    });
                }
            }
            component.set("v.jobSiteList",OptsjobSites);
        });
        $A.enqueueAction(sitesList);
        $A.enqueueAction(jobsites);
	},
/* nullify : function(component,event,helper)
{
    var dp = component.find('startDate');
    dp.set('v.value', '');
},
     nullify2 : function(component,event,helper)
{
    var dp = component.find('endDate');
    dp.set('v.value', '');
},*/
    createNewShift: function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.isSiteEmpty",false);
        component.set("v.isJobRoleEmpty",false);
        component.set("v.isStaffEmpty",false);
        component.set("v.isStartDateEmpty",false);
        component.set("v.isEndDateEmpty",false);
        component.set("v.isStartTimeEmpty",false);
        component.set("v.isEndTimeEmpty",false);
        var selectedSite = component.find("siteId").get("v.value");
        console.log('selectedSite:',selectedSite);
        var selectedjobrole = component.find("jobRoleId").get("v.value");
        console.log('selectedjobrole:',selectedjobrole);
        var staffreq = component.find("requiredStaff").get("v.value");
        console.log('staffreq:',staffreq);
        var startDate = component.find("startDate").get("v.value");
        console.log('startDate:',startDate);
        //var startTime = component.get("v.startTime");//component.find("startTime").get("v.value");
        var startTime =  document.getElementById("startTime").value;
        console.log('startTime:',startTime);
        var endDate = component.find("endDate").get("v.value");
        console.log('endDate:',endDate);
        var endTime = document.getElementById("endTime").value;//component.find("endTime").get("v.value");
        console.log('endTime:',endTime);
        var message='';
        if(selectedSite === ""){   
            component.set("v.isSiteEmpty",true);
        }
         if(selectedjobrole === ""){   
            component.set("v.isJobRoleEmpty",true);
        }
        if(staffreq == null || staffreq === ""){
            component.set("v.isStaffEmpty",true);
        }
        if(startDate == undefined || startDate == ""){
            component.set("v.isStartDateEmpty",true);
        }
        if(endDate == undefined || endDate == ""){
            component.set("v.isEndDateEmpty",true);
        }
        if(startTime == null || startTime ==  ""){
            component.set("v.isStartTimeEmpty",true);
        }
        if(endTime == null || endTime == ""){
            component.set("v.isEndTimeEmpty",true);
        }
        if(startDate>endDate)
        {
            
                toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "From date cannot be greater than To date"
                    
                });

             toastEvent.fire();
        }
        else
        {
        if(selectedSite === "" || selectedjobrole === "" || staffreq == null || staffreq === "" || startDate == null || startDate == "" || startTime == null || startTime ==  "" || endDate == null || endDate == "" || endTime == null || endTime == ""){
            //message = 'Please enter values for all fields';
            //component.set("v.message",message);
            //component.set("v.isOpen", true);
        }else{
            var stDtStr = startDate+'T'+startTime;
            console.log('stDtStr:',stDtStr);
            var stDt = new Date(stDtStr);
            console.log('stDt:',stDt);
            var edDtStr = endDate+'T'+endTime;
            console.log('edDtStr:',edDtStr);
            var edDt = new Date(edDtStr);
            console.log('edDt:',edDt); 
            console.log('date diff:',stDt - edDt );
            var timeDiff = edDt - stDt;
            var totalDifference = timeDiff/3600000;
            console.log('totalDifference:',totalDifference );
           if(totalDifference > 13){
            message = 'End Date cannot be later then 13 hours after Start Date';
            component.set("v.message",message);
            component.set("v.isOpen", true);
            }else{
                var createShift = component.get('c.CreateNewShift');
                createShift.setParams({siteId:selectedSite,jobRoleId:selectedjobrole,startTime:startTime,endTime:endTime,startDate:startDate,endDate:endDate,staffNumber:staffreq});
                createShift.setCallback(this, function(response){
                    console.log('state:',response.getState());
                    console.log('return value:',response.getReturnValue());
                    console.log('response:',response);
                    if(component.isValid() && response.getState() == 'SUCCESS'){
                        message =   response.getReturnValue(); 
                        console.log('message:',message);
                        component.set("v.message",message);
                        component.set("v.isOpen", true);
                    }
                    
                });
            } 
        } 
        }
    $A.enqueueAction(createShift);
  },
    
    navigateBack : function(component, event, helper) {
	    var address = '/vacancies';
	    var urlEvent = $A.get("e.force:navigateToURL");
	    urlEvent.setParams({
	      "url": address,
	    });
	    urlEvent.fire();
	},
    
   closeModel: function(component, event, helper){
      component.set("v.isOpen", false);
   },
})
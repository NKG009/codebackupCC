({
	doInit : function(component, event, helper){
        helper.getLoggedInUserInformation(component);
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        component.set("v.selectedSite",siteRecId);
            component.set("v.site", siteRecId); 
        var sitesList = component.get('c.getsitesList');
        sitesList.setCallback(this, function(response){
            //console.log('response from fast booking:' ,response.getReturnValue(),response.getState()+ ' '+component.isValid());
            var optsSite = [];
             var flag = 0;
              var siteID;
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
        $A.get('e.force:refreshView').fire(); 
	},
    sendEmailToSiteOwner: function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        var isValid = true;
        var dateformat = /^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{2}$/;
        component.set("v.isSiteEmpty",false);
        component.set("v.isStartDateEmpty",false);
        component.set("v.isEndDateEmpty",false);
        var selectedSite = component.get("v.selectedSite");
        console.log('selectedSite:',selectedSite);
       // var selectedjobrole = component.find("jobRoleId").get("v.value");
        //console.log('selectedjobrole:',selectedjobrole);
        var startDate1 = $("#startDateTime").val();
        var dtStart = startDate1.split("/");
        console.log('startDate1:',startDate1);
        //var startDate = Date.parse(startDate1);
        var startDate = new Date(dtStart[1]+"/"+dtStart[0]+"/"+dtStart[2]);
        console.log('startDate:',startDate);
        var endDate1 = $("#endDateTime").val();
        console.log('endDate1:',endDate1);
        var dtEnd = endDate1.split("/");
        var endDate = new Date(dtEnd[1]+"/"+dtEnd[0]+"/"+dtEnd[2]);
        //var endDate = new Date(endDate1);
        console.log('endDate:',endDate);
        var textAreaVal = $("#description").val();
        console.log('textAreaVal:',textAreaVal);
        var message='';
        if(selectedSite === ""){   
            component.set("v.isSiteEmpty",true);
            toastEvent.setParams({
                  
                 
                    "message": "Please Select a Site"
                    
                });

            toastEvent.fire();
        }
        
        if(startDate1 == null || startDate1 == ""){
            component.set("v.isStartDateEmpty",true);
            toastEvent.setParams({                 
                    "message": "Please Select Start Date"                    
                });

            toastEvent.fire();
            isValid=false;
        }
        if(endDate1 == null || endDate1 == ""){
            component.set("v.isEndDateEmpty",true);
            toastEvent.setParams({                
                  
                    "message": "Please Select End Date"                    
                });

            toastEvent.fire();
            isValid=false;
        }
        if(textAreaVal == null || textAreaVal == ""){
            toastEvent.setParams({                  
                    "message": "Please enter Details of New Staff Requirement"
                    
                });

            toastEvent.fire();
            isValid=false;
        }
        if(!startDate1.match(dateformat)){
            toastEvent.setParams({
                    "message": "Please enter a valid Start Date"
                });

            toastEvent.fire();
            isValid=false;
        }
        if(!endDate1.match(dateformat)){
            toastEvent.setParams({
                    "message": "Please enter a valid End Date"
                });

            toastEvent.fire();
            isValid=false;
        }
        if(startDate>endDate)
        {	toastEvent.setParams({
                    "message": "From date cannot be greater than To date"
                });

            toastEvent.fire();
            isValid=false;
        }
        if(isValid==true){
          
			if(selectedSite != ""){
				var sendEmail = component.get('c.SendEmail');
				//sendEmail.setParams({siteId:selectedSite,jobRoleId:selectedjobrole,startTime:'00:00',endTime:'01:00',startDate:startDate1,endDate:endDate1,textAreaVal:textAreaVal});
				sendEmail.setParams({siteId:selectedSite,startTime:'00:00',endTime:'01:00',startDate:startDate1,endDate:endDate1,textAreaVal:textAreaVal});
                sendEmail.setCallback(this, function(response){
					console.log('state:',response.getState());
					console.log('return value:',response.getReturnValue());
					console.log('response:',response);
					if(component.isValid() && response.getState() == 'SUCCESS'){
						message = response.getReturnValue(); 
						console.log('message:',message);
						component.set("v.message",message);
						component.set("v.isOpen", true);
                        toastEvent.setParams({
                            title : 'Success Message',
                            message: message,
                            messageTemplate: message,
                            duration:' 1000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                         });                        
                        toastEvent.fire();
                        document.getElementById("startDateTime").value = null;
						document.getElementById("endDateTime").value = null;
						document.getElementById("description").value = null;
					}
                    else{
                        toastEvent.setParams({
                            title : 'Error Message',
                            message: 'Sorry, something went wrong. Please try again.',
                            duration:' 1000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                         });                        
                        toastEvent.fire();   
                    }
				});
			}
        }
   
	component.set("v.message",message);
    component.set("v.isOpen", true);
    $A.enqueueAction(sendEmail);
  },
    
   closeModel: function(component, event, helper){
      component.set("v.isOpen", false);
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
    pastVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
         var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'testpastvacancynew?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
     myrates: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.get("v.site"); 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"rateinfo?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    myProfileNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofile?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    siteManagementNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function(component, event, helper)
    {
        event.preventDefault();
       var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"fastbooking?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function(component, event, helper)
    {
        event.preventDefault();
      var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testnewvacancy?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function(component, event, helper){
        event.preventDefault();
       var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newbookedtemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function(component, event, helper)
    {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'pasttemps?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function(component, event, helper)
    {
        event.preventDefault();
      var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'newcontactus?site='+param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet  : function(component,event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"approved-timeSheets-new?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function(component,event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"shiftdateview?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    candidateView: function(component,event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"candidateview?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    
    activeVacancy: function(component, event,helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');
       
        if(param == null)
        {
           param = helper.getJsonFromUrl().site;  
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"testtemps?site="+param;
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
    handleOnClick : function(component, event, helper) {
        event.preventDefault();
        return false;
    }, 
    handleKeyPress : function(component, event, helper) {
        event.preventDefault();
        return false;
    },
    handleMouseEnter : function(component, event, helper) {
        event.preventDefault();
        return false;
    },
    
    siteChanged :function(component, event, helper) {

         component.set("v.site", component.find("siteId").get("v.value")); 
        component.set("v.selectedSite", component.find("siteId").get("v.value"));
        
    }
	
})
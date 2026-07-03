({
    getSiteList :function(component) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        
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
              }); 
        $A.enqueueAction(sitesList);
    },
    
    getLoggedInUserName :function(component){
        var fetchUserName = component.get("c.fetchUser");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(fetchUserName);
    },
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptionsClient");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    submitcaseHelper : function(component,event,helper){
     
        var siteIdPassToCtrl = component.find("siteId").get("v.value");
     
        var siteIdPassToCtrl1 = component.get("v.site");
      
        if(siteIdPassToCtrl==undefined) {
       //     var url_String = document.URL;
         
       //     var url = new URL(url_String);
           
         siteIdPassToCtrl = helper.getJsonFromUrl().site;  
           
        }
   
        var getsub = component.find("caseSubject");
        var getsubValue = getsub.get("v.value");        
        var comments  			= component.find("Query");
        var commentsValue  		= comments.get("v.value");      
        var isValid        		= true; 
        var isValid1        		= true; 
        var isValid2        		= true; 
      
        if(getsubValue==null || getsubValue=='undefined' || getsubValue==''){
            getsub.set("v.errors", [{message:"Subject Required"}]); 
            isValid1 = false; 
        }else{
            getsub.set("v.errors", null);
            isValid1 = true; 
        }
        if(commentsValue==null || commentsValue=='undefined' || commentsValue==''){
            comments.set("v.errors", [{message:"Comment Required"}]); 
            isValid2 = false; 
        }else{            
            comments.set("v.errors", null);  
            isValid2 = true; 
        }
        
       if(isValid1===true && isValid2===true){
            var action = component.get("c.caseInsertSendEmail");
           action.setParams({'sub': getsubValue,'des' : commentsValue,'siteId' :siteIdPassToCtrl });	
            action.setCallback(this, function(response) { 
                var state = response.getState();
                console.log('res'+JSON.stringify(response.getError()));
                if (component.isValid() && state === "SUCCESS") {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success Message',
                        message:'Your message has been sent successfully',
                        messageTemplate: 'Your message has been sent successfully',
                        duration:' 1000',
                        
                        type: 'success',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                    component.find("caseSubject").set("v.value",'')
                    component.set("v.casedescription",'');
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                       
                        message:'Your message can not be sent! Please contact your Consultant',
                        messageTemplate: '',
                        duration:' 2000',
                        mode: 'pester'
                    });
                    toastEvent.fire();      
                    console.log("Failed with state: " + state);               
                }
            });
            $A.enqueueAction(action);                        
        }
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
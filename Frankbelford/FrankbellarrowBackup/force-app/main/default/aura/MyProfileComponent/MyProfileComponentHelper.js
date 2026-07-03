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
        
        });        
        $A.enqueueAction(sitesList);
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
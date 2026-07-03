({
	getSiteList :function(component) {
        /*var url_String = document.URL;
        var url = new URL(url_String);
        var siteRecId = url.searchParams.get('site');*/
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
         component.set("v.site", siteRecId); 
        var sitedisplayid='';
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
              
                sitedisplayid = siteID;
        });        
        
        var fetchSiteInformation = component.get("c.fetchSiteInformation");
        fetchSiteInformation.setParams({
            siteId : siteRecId
        });
        fetchSiteInformation.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.siteInfo", storeResponse);
                component.set("v.Linksite", storeResponse.Contact_Site_links1__r);
                
                console.log('111111 '+JSON.stringify(storeResponse.Contact_Site_links1__r));
                 window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("siteId").set("v.value", siteRecId);
                }));
            }
        });
        $A.enqueueAction(sitesList);
        $A.enqueueAction(fetchSiteInformation);  
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
    
    getSiteInformation:function(component){
        var fetchSiteInformation = component.get("c.fetchSiteInformation");
        console.log('111111 '+component.find("siteId").get("v.value"));
        fetchSiteInformation.setParams({
            siteId : component.find("siteId").get("v.value")
        });
        fetchSiteInformation.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.siteInfo", storeResponse); 
                component.set("v.Linksite", storeResponse.Contact_Site_links1__r);
            }
        });
        component.set("v.selectedSite",component.find("siteId").get("v.value"));
         component.set("v.site", component.find("siteId").get("v.value"));
        console.log('selectedSite '+component.get("v.selectedSite"));
        $A.enqueueAction(fetchSiteInformation);        
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
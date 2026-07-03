/**
 * Created by mrahman on 2021-01-13.
 */
({
    getBrandDetails : function (component) {
        var brand = component.get("v.brand");
        var action = component.get("c.getBrandDetails");
        action.setParams({"brandName" : brand});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.brandDetails", response.getReturnValue());
            } else {
                console.error(state + " could not get Brand details " + JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    getSiteList :function(component) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        //console.log('siteRecId >> ' + siteRecId);
        if(siteRecId !== undefined) {
            component.set("v.site", siteRecId);
        }
        //console.log("site >> " + component.get('v.site'));
        var sitesList = component.get("c.getSitesOfLoggedInUser"); //component.get('c.getSitesOfLoggedInUser');
        sitesList.setCallback(this, function(response){
            var state = response.getState();
            var optsSite = [];
            var siteID;
            var flag = 0;

            //console.log('getSitesOfLoggedInUser callback state: ' + state);
            //if(component.isValid() && state == "SUCCESS") {
            if(state==="SUCCESS"){
                var SiteArray = response.getReturnValue();
                //console.log('SitesArray:>>> ' + JSON.stringify(SiteArray));
                //alert("SiteArray.length>> " + SiteArray.length);
                //if(SiteArray === "")
                for (var i = 0; i < SiteArray.length; i++) {
                    //console.log("SiteArray[i].Id= " + SiteArray[i].Id + " siteRecId= "+siteRecId);
                    if(SiteArray[i].Id==siteRecId){
                        flag = 1;
                        optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id,
                        selected: true
                        });
                        siteID = siteRecId;
                        //console.log("Site is selected");
                    } else{
                        //alert('in else part >> '+JSON.stringify(SiteArray[i]));
                        optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                        });
                    }
                }

                if(flag==0){
                    //alert('in "flag==0" part >> '+JSON.stringify(optsSite[0]));
                    //console.log('flag: '+flag+' optsSite[0].value: '+optsSite[0].value);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }
                component.set("v.site", siteID);
                component.set("v.siteList", optsSite);
            } else if(state === "ERROR"){
                 console.error("Something went wrong ");
            } else {
                console.error("Unhandled response:: "+JSON.stringify(response));
            }

        });
        $A.enqueueAction(sitesList);
    },

    getLoggedInUserInformation :function(component){
        //console.log("In getLoggedInUserInformation");
        var fetchUserName = component.get("c.fetchUserInformation");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("response.getReturnValue()>> " + JSON.stringify(response.getReturnValue()));
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            } else if(state === "ERROR"){
                //show a toast error message here
                var errorMsg="Error:";
                for(i=0;i<response.error.length; i++){
                    errorMsg+=response.error[i].message + "\n";
                }
                //console.log("Something went wrong:: "+JSON.stringify(errorMsg));
                rsToast.setParams({"title":"Error","message":"Something went wrong! " + errorMsg});
                rsToast.fire();
            } else {
                //console.log("Unhandled response:: "+JSON.stringify(response));
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
    },
    goToUrl : function(pageUrl, cmp, event){
        var urlEvent = $A.get("e.force:navigateToURL");
        pageUrl = pageUrl+"?site="+cmp.get("v.site");
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
        //console.log('pageUrl >> ' + pageUrl);
    }
})
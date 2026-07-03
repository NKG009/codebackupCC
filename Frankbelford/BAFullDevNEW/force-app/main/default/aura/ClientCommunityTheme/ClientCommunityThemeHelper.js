/**
 * Created by mrahman on 2020-08-21.
 */
({
    helperscriptload: function (component, event, helper) {
        //ADD STEPS IF ANYTHING NEEDS TO BE LOADED
    },

    getSiteList :function(component) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        console.log('siteRecId >> ' + siteRecId);
        component.set("v.site", siteRecId);

        var sitesList = component.get("c.getSitesOfLoggedInUser");
        sitesList.setCallback(this, function(response){
            var state = response.getState();
            var optsSite = [];
            var siteID;
            var flag = 0;

            console.log('getSitesOfLoggedInUser callback state: ' + state);
            if(state==="SUCCESS"){
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
                    } else{
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
            } else if(state === "ERROR"){
                 //show a toast error message here
                 console.log("Something went wrong ");
                 //rsToast.setParams({"title":"Error","message":"Something went wrong! " + errorMsg});
                 //rsToast.fire();
             } else {
                 console.log("Unhandled response:: "+JSON.stringify(response));
             }
            component.set("v.siteList", optsSite);
            //console.log('sitesList:::: ' + JSON.Stringify(optsSite));
            });
        $A.enqueueAction(sitesList);
    },

    getLoggedInUserInformation :function(component){
        console.log("In getLoggedInUserInformation");
        var fetchUserName = component.get("c.fetchUserInformation");
        fetchUserName.setCallback(this, function(response) {
            var state = response.getState();
            console.log('fetchUserInformation state: ' + state);
            if (state === "SUCCESS") {
                console.log("response.getReturnValue()>> " + JSON.stringify(response.getReturnValue()));
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            } else if(state === "ERROR"){
                //show a toast error message here
                var errorMsg="Error:";
                for(i=0;i<response.error.length; i++){
                    errorMsg+=response.error[i].message + "\n";
                }
                console.log("Something went wrong:: "+JSON.stringify(errorMsg));
                rsToast.setParams({"title":"Error","message":"Something went wrong! " + errorMsg});
                rsToast.fire();
            } else {
                console.log("Unhandled response:: "+JSON.stringify(response));
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
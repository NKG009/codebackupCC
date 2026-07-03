({
	helperMethod : function() {
		
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
    dashboardnavigate: function(component, event, helper)
    {	event.preventDefault();
        var param = component.get("v.site"); //helper.getJsonFromUrl().site; 
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },

    loadData : function(cmp, event){

        var siteID;
        var siteList = cmp.get("c.getSites");
        siteList.setCallback(this, function (response) {

            var idParam = cmp.get("v.site");//this.getJsonFromUrl().site !== undefined ? siteId : this.getJsonFromUrl().site;
            console.log("reloading data.... siteID == " +siteID);
            var state = response.getState();
            var optsSite = [];
            var flag = 0;

            if (cmp.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();

                for (var i = 0; i < SiteArray.length; i++) {
                    if (SiteArray[i].Id == idParam) {
                        flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });
                        siteID = idParam;
                    } else {
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                        });
                    }
                }
                if (flag == 0) {
                    console.log('flag: ' + flag + ' optsSite[0].Id: ' + optsSite[0].Id);
                    optsSite[0].selected = true;
                    siteID = optsSite[0].value;
                }

                console.log('siteID: ' + siteID);
                cmp.set("v.url", "/client/s/");
                cmp.set("v.site", siteID);
                console.log('optsSite: ' + optsSite);
                cmp.set("v.SiteList", optsSite);
                //console.log('cc: '+cmp.find('select').get('v.value'));

            }
        });
        $A.enqueueAction(siteList);

        var action1 = cmp.get("c.fetchUser");
        action1.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.Name", storeResponse);
                cmp.set("v.isTimesheetApprovalOpen", false);
                cmp.set("v.isCurrentVacancies", false);
                cmp.set("v.isCandidateOpen", false);
                cmp.set("v.isDashboardOpen", true);
            }
        });
        $A.enqueueAction(action1);


        var fetchUserName = cmp.get("c.getUserInformation");
        fetchUserName.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.userInfo", storeResponse);
                cmp.set("v.Hideshift", cmp.get("v.userInfo.Hide_Shift_Approval__c"));
                cmp.set("v.Hidecontact", cmp.get("v.userInfo.Hide_Contact__c"));
                cmp.set("v.Hidetemp", cmp.get("v.userInfo.Hide_temps__c"));
                cmp.set("v.Hidebookedtemp", cmp.get("v.userInfo.Hide_Booked_temps__c"));
                cmp.set("v.Hideinvoicedetails", cmp.get("v.userInfo.Hide_invoice_details__c"));
                cmp.set("v.Hidetemphours", cmp.get("v.userInfo.Hide_temp_hours__c"));
            }
        });
        $A.enqueueAction(fetchUserName);
        $A.get('e.force:refreshView').fire();
    },

    delayedRefresh : function(milliseconds){
        let ms = milliseconds || 500;
        console.log("Refresh will trigger in " + ms);
        window.setTimeout($A.getCallback(function(){
            $A.get('e.force:refreshView').fire();
        }),ms);
    }
})
({
    doInit: function (cmp, evt, helper) {
        console.log('do init called');
        var ua = window.navigator.userAgent;
        var msie = ua.indexOf('MSIE ');
        if (msie > 0) {
            // IE 10 or older, return version number
            var result = ('IE ' + parseInt(ua.substring(
                msie + 5, ua.indexOf('.', msie)), 10));
        }
        var trident = ua.indexOf('Trident/');
        if (trident > 0) {
            // IE 11, return version number
            var rv = ua.indexOf('rv:');
            var result = ('IE ' + parseInt(ua.substring(
                rv + 3, ua.indexOf('.', rv)), 10));
            cmp.set("v.checkBrowser", true);
        }

        window.dataLayer = window.dataLayer || [];
        function gtag() { dataLayer.push(arguments); }
        gtag('js', new Date());

        gtag('config', 'UA-142794757-1');

        //helper.loadData(cmp, event);
        var siteID;
        var siteList = cmp.get("c.getSites");
        siteList.setCallback(this, function (response) {
            var idParam = helper.getJsonFromUrl().site;
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
    reInit : function(cmp, evt, helper){
        $A.get('e.force:refreshView').fire();
        console.log('reInit also fired');
    },
    onChange: function (cmp, evt, helper) {
        cmp.set("v.doRender", false);
        var selectedSite = evt.getParam("selectedSiteId");
        console.log('Current Site >> ' + cmp.get('v.site') + " change handler newly selected site >> " + selectedSite);
        cmp.set("v.site", selectedSite);
        //cmp.set("v.checksearch", true);
        console.log('updated Site >> ' + cmp.get("v.site"));
        $A.get('e.force:refreshView').fire();
        //helper.loadData(cmp, evt);
        //var myPageRef = cmp.get("v.pageReference");
        console.log("cmp.get('v.doRender') >> " + cmp.get('v.doRender'));
        //helper.delayedRefresh(500);
        cmp.set("v.doRender", true);
    },
    addChild: function (cmp, evt, helper) {
        console.log('in add child');
        var toggleText = cmp.find('widget').get('v.value');
        console.log('in add val ' + toggleText);

        $A.util.removeClass(toggleText, "hide");
        $A.util.toggleClass(toggleText, "toggle");
        var action = cmp.get("c.updateuserwidget");
        var fieldupdate;
        if (toggleText == 'Shift_Approval') {
            fieldupdate = 'Hide_Shift_Approval__c';
            cmp.set("v.Hideshift", null);
        }
        else if (toggleText == 'My_Blue_Arrow_Contact') {
            fieldupdate = 'Hide_Contact__c';
            cmp.set("v.Hidecontact", null);
        }
        else if (toggleText == 'My_Temps') {
            fieldupdate = 'Hide_temps__c';
            cmp.set("v.Hidetemp", null);
        }
        else if (toggleText == 'Booked_Temps') {
            fieldupdate = 'Hide_Booked_temps__c';
            cmp.set("v.Hidebookedtemp", null);
        }
        else if (toggleText == 'Invoice_Details') {
            fieldupdate = 'Hide_invoice_details__c';
            cmp.set("v.Hideinvoicedetails", 'hide');
        }
        else {
            fieldupdate = 'Hide_temp_hours__c';
            cmp.set("v.Hidetemphours", null);
        }
        action.setParams({
            "fieldtoupdate": fieldupdate,
            "updatevalue": ''
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });



        $A.enqueueAction(action);

        //helper.dashboardnavigate(cmp, evt, helper);
    },
    hideShift_Approval: function (cmp, evt, helper) {
        console.log("hide shift approval");
        var toggleText = cmp.find('Shift_Approval');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
        cmp.set("v.Hideshift", 'hide');
        var action = cmp.get("c.updateuserwidget");
        action.setParams({
            "fieldtoupdate": 'Hide_Shift_Approval__c',
            "updatevalue": 'hide'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });
        $A.enqueueAction(action);

    },
    hideContact: function (cmp, evt, helper) {
        var toggleText = cmp.find('My_Blue_Arrow_Contact');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
        cmp.set("v.Hidecontact", 'hide');
        var action = cmp.get("c.updateuserwidget");
        action.setParams({
            "fieldtoupdate": 'Hide_Contact__c',
            "updatevalue": 'hide'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });
        $A.enqueueAction(action);

    },
    hideMyTemps: function (cmp, evt, helper) {
        var toggleText = cmp.find('My_Temps');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
        cmp.set("v.Hidetemp", 'hide');
        var action = cmp.get("c.updateuserwidget");
        action.setParams({
            "fieldtoupdate": 'Hide_temps__c',
            "updatevalue": 'hide'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });
        $A.enqueueAction(action);
    },
    hideBookedTemps: function (cmp, evt, helper) {
        var toggleText = cmp.find('Booked_Temps');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
        cmp.set("v.Hidebookedtemp", 'hide');
        var action = cmp.get("c.updateuserwidget");
        action.setParams({
            "fieldtoupdate": 'Hide_Booked_temps__c',
            "updatevalue": 'hide'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });
        $A.enqueueAction(action);
    },
    hideInvoice: function (cmp, evt, helper) {
        var toggleText = cmp.find('Invoice_Details');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
        cmp.set("v.Hideinvoicedetails", 'hide');
        var action = cmp.get("c.updateuserwidget");
        action.setParams({
            "fieldtoupdate": 'Hide_invoice_details__c',
            "updatevalue": 'hide'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });
        $A.enqueueAction(action);
    },
    hideTempHours: function (cmp, evt, helper) {
        var toggleText = cmp.find('Temp_Hours');
        $A.util.removeClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, "hide");
        cmp.set("v.Hidetemphours", 'hide');
        var action = cmp.get("c.updateuserwidget");
        action.setParams({
            "fieldtoupdate": 'Hide_temp_hours__c',
            "updatevalue": 'hide'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
        });
        $A.enqueueAction(action);
    },

    logout: function (component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL") + "secur/logout.jsp?retUrl=" + $A.get("$Label.c.Lightning_CommunityLogout_URL") + "CommunitiesLanding";
        window.location.replace(urlRedirect);
        return false;
    },

    /*MyProfileNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'myprofile?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    SiteManagementNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'sitemanagement?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },*/

    // this function automatic call by aura:waiting event
    //MR: THIS FUNCTION IS ADDED TO REMOVE THE ERROR BUT IT NOT FULLY BUILD
    scriptsLoaded: function (component, event, helper) {//alert('2222');
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    }
})
({
    keyCheck: function (component, event, helper) {
        if (event.which == 13) {
            event.preventDefault();
            var param = component.find('site').get('v.value');
            component.set("v.selectedSite", param);
            var cand = component.find('candinput').get('v.value');
            console.log('cand ' + cand);
            //  helper.doSearch(component);
        }
    },
    myrates: function (component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = component.get('v.baseURL') + "rateinfo?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    dashboardnavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "?site=" + param;
        console.log('urlRedirect >> ' + urlRedirect);
        window.location.replace(urlRedirect);
        return false;
    },
    pastVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "testpastvacancynew?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    MyProfileNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "myprofile?site=" + param;
        //alert('profile');
        window.location.replace(urlRedirect);
        return false;
    },
    SiteManagementNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "sitemanagement?site=" + param;
        // alert('site');
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "fastbooking?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "testnewvacancy?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "newbookedtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "pasttemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "newcontactus?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "approved-timeSheets-new?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function (component, event, helper) {
        /*       var param = component.find('site').get('v.value');
           var urlEvent = $A.get("e.force:navigateToURL");
           urlEvent.setParams({
               "url": '/shiftdateview?site='+param
           });
           urlEvent.fire();
            $A.get('e.force:refreshView').fire();  */
        event.preventDefault();
        // var param = component.find('site').get('v.value');
        var param = component.get("v.site");
        var urlRedirect = component.get('v.baseURL') + "shiftdateview?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    candidateView: function (component, event, helper) {
        var param = component.find('site').get('v.value');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/candidateview?site=' + param
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
        /*  event.preventDefault();
          var param = component.find('site').get('v.value');
          var urlRedirect = component.get('v.baseURL')+"candidateview?site="+param;
          window.location.replace(urlRedirect);
          return false; */
    },

    activeVacancy: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('site').get('v.value');
        var urlRedirect = component.get('v.baseURL') + "testtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },

    doInit: function (component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        component.set('v.baseURL', baseURL);
        $A.get('e.force:refreshView').fire();

        var theURL = new URL(window.location.href);
		var refreshView = theURL.searchParams.get("refreshView");
        if(refreshView) {
            var currentURL = window.location.href.replace("&refreshView=true", '');
            location.replace(currentURL);
        }

        var idParam = helper.getJsonFromUrl().site;
        component.set("v.site", idParam);
        var siteList = component.get("c.getSites");
        var siteID;
        siteList.setCallback(this, function (response) {
            var state = response.getState();

            var optsSite = [];
            var equalFlag = false;
            if (component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();
                for (var i = 0; i < SiteArray.length; i++) {

                    if (SiteArray[i].Id == idParam) {
                        //flag = 1;
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id,
                            selected: true
                        });

                        equalFlag = true
                    } else {
                        optsSite.push({
                            class: "optionClass",
                            label: SiteArray[i].Name,
                            value: SiteArray[i].Id
                        });
                        // var siteV =  component.find("site");
                        // siteV.set("v.value",optsSite[0].value);
                    }
                }

                if (equalFlag == true) {
                    component.find("site").set("v.value", idParam);
                }
                else {
                    component.find("site").set("v.value", optsSite[0].value);
                }
                siteID = optsSite[0].value;

                component.set("v.SiteList", optsSite);

                //component.set("v.selectedSite",siteID);
                // component.search(component,helper,event);
                //var a = component.get('c.search');
                //$A.enqueueAction(a);

            }
        });

        var action = component.get("c.getAllShiftsForCandidate");

        action.setParams({
            "contact": component.get("v.CandidateName"),
            "site": idParam//component.get("v.selectedSite")
        });

        action.setCallback(this, function (response) {
            var result = response.getReturnValue();
            component.set("v.ShiftList", result);
            component.set("v.truly", true);
        });


        var action1 = component.get("c.fetchUser");
        action1.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.Name", storeResponse);



            }
        });

        var fetchUserName = component.get("c.getUserInformation");

        fetchUserName.setCallback(this, function (response) {

            var state = response.getState();

            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }

        });

        /*************************************/
        // component.set("v.selectedSite",'a3e0Y000000tbkXQAQ');
        console.log('in else' + idParam);
        component.set("v.selectedSite", idParam);

        $A.enqueueAction(fetchUserName);
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
        $A.enqueueAction(siteList);

    },
    onChangeSiteVal: function (component, event, helper) {
        var site = event.getSource().get('v.value')
        console.log('site ' + site);
        component.set("v.site", site);
        component.set("v.selectedSite", site);

        component.set("v.CandidateName", null);
        helper.doSearch(component);
    },
    search: function (component, event, helper) {
        // alert(component.find("site").get("v.value"));
        // var param = component.find('site').get('v.value');
        var param = component.get("v.site");
        component.set("v.selectedSite", param);
        console.log(component.get("v.selectedSite"));
        helper.doSearch(component);

    },
    logout: function (component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL") + "secur/logout.jsp?retUrl=" + $A.get("$Label.c.Lightning_CommunityLogout_URL") + "CommunitiesLanding";
        window.location.replace(urlRedirect);
        return false;
    },
    // this function automatic call by aura:waiting event
    showSpinner: function (component, event, helper) {//alert('2222');
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    },
    resetAllValues: function (component, event, helper) {
        //  console.log('reset '+component.find("jobRole").get("v.value") +document.getElementById("timePeriod").value);
        if (component.get("v.CandidateName") != null) {
            component.set("v.CandidateName", null);


            helper.doSearch(component);
        }
    },

    onSiteChange: function (cmp, evt, helper) {
        console.log("Site change handler");
        var selectedSiteId = evt.getParam("selectedSiteId");
        cmp.set('v.site', selectedSiteId);
        cmp.set("v.selectedSite", selectedSiteId);
        cmp.set("v.CandidateName",null);
        helper.doSearch(cmp);
    }
})
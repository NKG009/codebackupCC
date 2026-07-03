({
    doInit: function (component, event, helper) {
        //  $("#overlay").show();
        helper.getLoggedInUserName(component);
        helper.getsitejobrole(component);
        helper.getSiteList(component);
    },
    onChangeSiteVal: function (component, event, helper) {
        var site = event.getSource().get('v.value');
        console.log('site ' + site);
        component.set("v.site", site);
        component.set("v.selectedSite", site);
        helper.getSiteList(component);
    },
    jobChanged: function (component, event, helper) {
        var jobrole = event.getSource().get('v.value')
        console.log('jobrole ' + jobrole);
        component.set("v.selectedjobrole", jobrole);

        helper.dosearch(component, event, helper);
    },
    rateChanged: function (component, event, helper) {
        var rateId = event.getSource().get('v.value')
        console.log('ratepage ' + rateId);

        helper.doSearchRate(component, event, helper, rateId);
        helper.doSearchRateModifier(component, event, helper, rateId);
    },
    dashboardNavigate: function (component, event, helper) {
        event.preventDefault();
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        var urlRedirect = baseURL + '?site=' + component.get("v.site");
        window.location.replace(urlRedirect);
        return false;
    }
    /*,
    myrates: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'rateinfo?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    dashboardnavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + '?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }

        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'testpastvacancynew?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    myProfileNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "myprofile?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    siteManagementNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "sitemanagement?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    fastBookingNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "fastbooking?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    newVacancyNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testnewvacancy?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    bookedTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "newbookedtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    pastTempsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'pasttemps?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    contactUsNavigate: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'newcontactus?site=' + param;
        window.location.replace(urlRedirect);
        return false;
    },
    gotoApprovedTimesheet: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "approved-timeSheets-new?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    shiftsToBeApprovedDataView: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "shiftdateview?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },
    candidateView: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "candidateview?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },

    activeVacancy: function (component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if (param == null) {
            param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + "testtemps?site=" + param;
        window.location.replace(urlRedirect);
        return false;
    },

    logout: function (component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL") + "secur/logout.jsp?retUrl=" + $A.get("$Label.c.Lightning_CommunityLogout_URL") + "CommunitiesLanding";
        window.location.replace(urlRedirect);
        return false;
    },*/
})
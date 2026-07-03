/**
 * Created by mrahman on 2020-08-21.
 */
({
    doInit : function(component, event, helper) {
            console.log('In doInit');
            helper.getLoggedInUserInformation(component);
            helper.getSiteList(component);
            //$A.get('e.force:refreshView').fire();
    },

    scriptsLoaded : function (cmp, evt, helper) {
        console.log('in ');
        helper.helperscriptload(cmp, evt, helper);
        console.log('in asscript');
    },

    publishSiteChanged : function(component, event, helper) {
        //console.log("Publishing theme attribute update");
        var siteId = component.find("siteId").get("v.value");
        //console.log("siteId >> " + siteId);
        var thEvent = $A.get("e.c:ClientCommunityThemeEvent");
        thEvent.setParams({"selectedSiteId" : siteId});
        thEvent.fire();
        console.log("Published theme attribute update");
    },

    myProfileNavigate: function(component, event, helper) {
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

    siteManagementNavigate: function(component, event, helper) {
        event.preventDefault();
        var param = component.find('siteId').get('v.value');

        if(param == null) {
           param = helper.getJsonFromUrl().site;
        }
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"sitemanagement?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },

    logout: function(component, event, helper) {
        event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_CommunityLogout_URL")+"secur/logout.jsp?retUrl="+$A.get("$Label.c.Lightning_CommunityLogout_URL")+"CommunitiesLanding";
        window.location.replace(urlRedirect);
        return false;
    }
})
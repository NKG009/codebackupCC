/**
 * Created by mrahman on 2021-01-13.
 */
({
    doInit : function(component, event, helper) {
        //console.log('In doInit');
        //console.log("site >> " + component.get('v.site'));
        helper.getLoggedInUserInformation(component);
        helper.getSiteList(component);
        helper.getBrandDetails(component, event);
        //$A.get('e.force:refreshView').fire();

        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        component.set('v.baseURL', baseURL);
    },

    publishSiteChanged : function(component, event, helper) {
        //console.log("Publishing theme attribute update");
        var siteId = component.find("siteId").get("v.value");
        component.set('v.site', siteId);
        //console.log("Published siteId >> " + siteId);
        var thEvent = $A.get("e.c:ClientCommunityThemeEvent");
        thEvent.setParams({"selectedSiteId" : siteId});
        thEvent.fire();
        //console.log("Published theme attribute update");
    },

    myProfileNavigate: function(component, event, helper) {
        helper.goToUrl("/myprofile", component, event);
    },

    siteManagementNavigate: function(component, event, helper) {
        helper.goToUrl("/sitemanagement", component, event);
    },

    logout: function(component, event, helper) {
        event.preventDefault();
        var logoutURL = component.get('v.baseURL').replace('s/','');
        var urlRedirect = logoutURL+"secur/logout.jsp?retUrl="+logoutURL+"CommunitiesLanding";
        //console.log('urlRedirect >> ' + urlRedirect);
        window.location.replace(urlRedirect);
        return false;
    },

    scriptsLoaded: function(component, event, helper){
        //console.log(">>>> Template Script load <<<<");
    }
})
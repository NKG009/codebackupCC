({
    doInit: function (component, event, helper) {
        helper.getSiteList(component);
        helper.getLoggedInUserName(component);
        helper.fetchPickListVal(component, 'Subject_Client_Query__c', 'caseSubject');
    },

    submitCase: function (component, event, helper) {
        helper.doCaseSubmit(component, event, helper);
    },

    dashboardNavigate: function (component, event, helper) {
        event.preventDefault();
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/")) + "/s/";
        var urlRedirect = baseURL + '?site=' + component.get('v.site');

        window.location.replace(urlRedirect);
        return false;
    },
})
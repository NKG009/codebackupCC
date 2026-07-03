/**
 * Created by mrahman on 2020-08-22.
 */
({
    goToDashboard: function(component, event, helper) {
        event.preventDefault();
        var param = component.get("v.site"); //helper.getJsonFromUrl().site;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL");

        if(param == null){
            var curUrl = window.location.href;
            param = curUrl.split('site=')[1];
        }

        if(param != 'undefined') {
            urlRedirect = urlRedirect+"?site="+param;
        }
        window.location.replace(urlRedirect);
        return false;
    }
})
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
    }
})
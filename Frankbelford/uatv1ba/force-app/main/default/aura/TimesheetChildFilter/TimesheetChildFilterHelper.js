({
	SitePredictiveSearch : function(component,event) {
        console.log('event.key:',event.keyCode);
		var searchStr = component.find("SiteId").get("v.text");
        console.log('searchStr:',searchStr);
        var siteArray = component.get("v.sitelist");
        var siteSearchedArray=[];
        for(var i = 0;i<siteArray.length;i++){
            var str = siteArray[i].label;
            if(str.startsWith(searchStr)){
                siteSearchedArray.push({
                    label:siteArray[i].label,
                    value:siteArray[i].value
                });
            }
        }
        $A.get('e.force:refreshView').fire();
        console.log('siteSearchedArray:'+siteSearchedArray);
        component.set("v.sitelist",siteSearchedArray);
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
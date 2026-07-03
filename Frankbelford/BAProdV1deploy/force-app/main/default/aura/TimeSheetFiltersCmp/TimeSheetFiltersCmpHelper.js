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
        console.log('siteSearchedArray:'+siteSearchedArray);
        component.set("v.sitelist",siteSearchedArray);
	}
})
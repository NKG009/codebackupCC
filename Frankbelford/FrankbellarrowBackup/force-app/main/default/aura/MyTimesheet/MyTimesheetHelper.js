({
 renderPage: function(component) {
		var records = component.get("v.allrecords"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecords '+pageNumber);
        component.set("v.rec", pageRecords);
	},
   
})
({
 renderPage: function(component) {
		var records = component.get("v.allshifts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecords '+pageNumber);
        component.set("v.currentList", pageRecords);
	},
     renderPage2: function(component) {
		var records = component.get("v.allshifts"),
            pageNumber = 1,
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecords '+pageNumber);
        component.set("v.currentList", pageRecords);
	},
     
   
})
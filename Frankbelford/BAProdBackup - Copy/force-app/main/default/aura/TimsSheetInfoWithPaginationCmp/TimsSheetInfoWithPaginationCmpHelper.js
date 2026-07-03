({

    renderPage: function(component) {
        var records = component.get("v.TimeSheets");
        var pageNumber = component.get("v.pageNumber");
        //var pageRecords;
        console.log('pageNumber:',pageNumber);
        if(pageNumber != null && records != null){    
        	var pageRecords = records.slice((pageNumber-1)*6, pageNumber*6);
            component.set("v.currentList", pageRecords);
         }
        console.log('pageRecords '+pageNumber);
        
    }

})
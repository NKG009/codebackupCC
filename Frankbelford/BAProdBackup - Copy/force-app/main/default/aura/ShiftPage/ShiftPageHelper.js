({
	 getSh: function(component, page, recordToDisply) {
         var action = component.get("c.getShifts");
      // set the parameters to method 
      action.setParams({
         "pageNumber": page,
         "recordToDisply": recordToDisply
      });
      // set a call back   
      action.setCallback(this, function(a) {
         // store the response return value (wrapper class insatance)  
         var result = a.getReturnValue();
         console.log('result ---->' + JSON.stringify(result));
         // set the component attributes value with wrapper class properties.   

         component.set("v.shifts", result.shifts);
         component.set("v.page", result.page);
        component.set("v.total", result.total);
         component.set("v.pages", Math.ceil(result.total / recordToDisply)); 
          
      });
      // enqueue the action 
      $A.enqueueAction(action);
   
  },
   
    
    renderPage: function(component) {
		var records = component.get("v.shifts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            console.log('pageRecords '+pageNumber);
        component.set("v.currentList", pageRecords);
	},
    
})
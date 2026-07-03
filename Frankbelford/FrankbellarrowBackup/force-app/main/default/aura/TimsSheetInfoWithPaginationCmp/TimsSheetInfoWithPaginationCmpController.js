({
	
   init: function(component, event, helper) {
        var action = component.get("c.fetchTimeSheets");
            action.setCallback(this, function(result) {
                var records = result.getReturnValue();
                console.log('records:',records);
                component.set("v.TimeSheets", records);
                component.set("v.currentList", records);
                if(records != null){
                	component.set("v.maxPage",Math.floor((records.length+5)/6));
                }
                helper.renderPage(component);
            });
        $A.enqueueAction(action);
		},
    
      renderPage: function(component, event, helper){
            helper.renderPage(component);
      },
    
    handleSearchEvent : function(cmp, event){
        var srcList = event.getParam("SearchList");
        var msg = '';
        console.log('srcList:',srcList.length); 
        if(srcList.length == 0){
            msg = 'No records Found!';
        }
        console.log('msg:',msg);
        cmp.set("v.TimeSheets", srcList);
        cmp.set("v.recordsNotFoundMsg",msg);
        cmp.set("v.maxPage",Math.floor((srcList.length+5)/6));
        //cmp.set("v.currentList",srcList);
        //var records = cmp.get("v.TimeSheets");
        var pageNumber = cmp.get("v.pageNumber");
        console.log('pageNumber:',pageNumber);
        if(pageNumber != null){
        	var pageRecords = srcList.slice((pageNumber-1)*6, pageNumber*6);
        }
        console.log('pageNumber '+pageNumber);
        cmp.set("v.currentList", pageRecords);
        
        //helper.renderPage(component);
    	//console.log('v.TimeSheets:',v.TimeSheets);
    },
    
    getTimeSheetLines : function(component,event,helper){
        console.log('TimeSheetId:',event.target.id);
        component.set("v.isOpen", true);
        var idName = event.target.id;
        var idAndName = idName.split('|');
        console.log('idAndName:',idAndName);
		var timeSheetLines = component.get("c.fetchTimeSheetLines"); 
        timeSheetLines.setParams({"timeSheetId":idAndName[0]});
        timeSheetLines.setCallback(this,function(result){
            var lineRecords = result.getReturnValue();
            console.log('lineRecords:',lineRecords);
            component.set("v.timeSheetId",idAndName[1]);
            if(lineRecords.length > 0){
                component.set("v.timeSheetLines",lineRecords);
                component.set("v.errMsg",'');
                //component.set("v.showError",false);
            }else{
                component.set("v.timeSheetLines",lineRecords);
                component.set("v.errMsg",'No TimeSheet Lines found!');
                //component.set("v.showError",true);
            }
        });
     $A.enqueueAction(timeSheetLines);    
    },
    
    navigateBack : function(component, event, helper) {
        var address = '/client-approved-timesheets';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address,
        });
        urlEvent.fire();
    },
    
    closeModel: function(component, event, helper){
      component.set("v.isOpen", false);
   }

})
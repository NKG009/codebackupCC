({
    doInit: function(component, event, helper) {
        helper.getShifts(component);
    },
    renderPage: function(component, event, helper) {
        var records = component.get("v.allshifts");
        console.log("-----------"+component.get("v.pageNumber"));
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.shifts", pageRecords);
    },
    applyFilter: function(component, event, helper) {
        var target = event.getSource();
        var filter = target.get("v.value");
        console.log(filter);
        component.set("v.filter",filter);
        var button = component.find("filter");
        for(var i=0;i<button.length;i++){    
            $A.util.addClass(button[i], 'button');
            $A.util.removeClass(button[i], 'buttonRed');
        }
        $A.util.addClass(target, 'buttonRed');
        helper.getShifts(component);
    },
    getBackscreen : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/vacancies" });
        urlEvent.fire();
    }
})
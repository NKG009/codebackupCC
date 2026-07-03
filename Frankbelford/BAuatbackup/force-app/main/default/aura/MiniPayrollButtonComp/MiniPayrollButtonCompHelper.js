({
    MiniPayroll : function(component, event, helper) {
        var action = component.get("c.MiniPayrollBtn");
        
        action.setParams({"RecId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                
                if(result==='Open Confirm Popup')
                {
                   
                    if(confirm('Timesheet lines have already been passed.Do you wish to re-send'))
                    {
                        var action1 = component.get("c.MiniPayrollBtn2");
                        action1.setParams({"RecId2": component.get("v.recordId")});
                        action1.setCallback(this, function(response) {
                            var state1 = response.getState();
                            var result1 = response.getReturnValue();
                            if(state1 === "SUCCESS") {
                                component.set("v.processingText",false);
                                component.set("v.processingBatch",true);
                                component.set("v.Messagefromapx",result1);
                                
                            }
                        });
                        
                    }
                    else
                    {
                        window.location.reload()  
                    }
                    $A.enqueueAction(action1);
                }
                else
                {
                    component.set("v.processingText",false);
                    component.set("v.processingBatch",true);
                    component.set("v.Messagefromapx",result);
                    
                    
                }
                
            }
        });
        $A.enqueueAction(action);
        
        
        
    }
})
({
    loadData : function(component, event) {
        var action = component.get("c.getTempshifts");
        action.setParams({
            "site" : component.get("v.site")
        });
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                var result = response.getReturnValue();
                var currentList;
                var detailList;
                var checksite = component.get("v.checksearchA");
                if(result.length>0){
                    currentList = result.slice(0,4);
                    detailList = result;
                    var availableUSers = 0;
                    var notAvailableUsers = 0;
                    var total = result.length;
                    console.log('total '+total);
                    for ( var i = 0; i < result.length; i++) {
                        if(result[i].sirenum__Actual_Start_Time__c != null){
                            availableUSers = availableUSers + 1;
                        }else{
                            notAvailableUsers = notAvailableUsers + 1;
                        }
                    }

                    var avus = ((availableUSers/total)*100).toFixed(2);
                    var unavus = ((notAvailableUsers/total)*100).toFixed(2);
                    avus = Math.round(avus);
                    unavus = Math.round(unavus);
                    console.log('avuscontrol '+avus +unavus);
                    component.set("v.shifts", currentList);
                    component.set("v.detailShifts", detailList);
                    component.set("v.availableUSers",avus);
                    component.set("v.notAvailableUsers",unavus);
                    this.createGraph(component, avus);
                    this.createGraph2(component,unavus);
                }
                else
                {
                     var avus = 0;
                    var unavus = 0;
                    component.set("v.shifts", currentList);
                    component.set("v.detailShifts", detailList);
                    component.set("v.availableUSers",avus);
                    component.set("v.notAvailableUsers",unavus);
                    this.createGraph(component, avus);
                    this.createGraph2(component,unavus);
                }
              }
            });
        $A.enqueueAction(action);
    },
    createGraph : function(component, avus) {
        
        avus = component.get("v.availableUSers");
        console.log('avus '+avus);
        
        var restGraph = 100 - avus;   
    
        var el = component.find('barChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'doughnut',
             tooltip: { enabled: false },
            data: {
                labels: ['',''],
                datasets: [
                    {
                        
                        backgroundColor: ["#a8d431"],
                        borderWidth: 8,
                        hoverBorderWidth: 0,
                        data: [avus,restGraph]
                    }
                ]
            },           
            options: {
                hover: {
                    mode: "none",
                  display: false,
                },
                legend: {
                    display: false,
                },
                  responsive: true,
            }
        });
    }, 
    createGraph2 : function(component, unavus) {
        unavus = component.get("v.notAvailableUsers");
        
        var restGraph = 100 - unavus;        
        var el = component.find('barChart1').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'doughnut',
             tooltip: { enabled: false },
            data: {
                labels: ['',''],
                datasets: [
                    {
                        label: "",
                        backgroundColor: ["#e4007d"],
                        borderWidth: 8,
                        hoverBorderWidth: 0,
                        data: [unavus,restGraph]
                    }
                ]
            },
            options: {
                 hover: {
                    mode: "none",
                  display: false,
                },
                legend: {
                    display: false,
                },
                
            }
        });
    },
    
    
})
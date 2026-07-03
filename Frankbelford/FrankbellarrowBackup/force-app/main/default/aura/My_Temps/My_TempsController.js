({
    bookedTempsNavigate: function(component, event, helper){
        
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"newbookedtemps?site="+param;
        window.location.replace(urlRedirect);
        return false;
    },
    doInit : function(component, event, helper) {
          $A.get('e.force:refreshView').fire(); 
        var action = component.get("c.getAllShifts");
        action.setParams({
            "site" : component.get("v.site"),
            "contact" : component.get("v.selectedcandidate"),
            "jobrole" : component.get("v.selectedJobRole"),
            "filter": "today"
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            //   var state = response.getState();
            var currentList;
            var detailList; 
            console.log('result.length: '+result.length);
            var checksite = component.get("v.checksearchA");
            console.log('out of lenght '+checksite);
              
            if(result.length>0){
              currentList = result.slice(0,4);
                //detailList = result;
                detailList = result;
            
            console.log('result '+result);
            var i;
            var availableUSers = 0;
            var notAvailableUsers = 0;
            var total = result.length;
            console.log('total '+total);
            for (i = 0; i < result.length; i++) { 
                if(result[i].sirenum__Actual_Start_Time__c != null){
                    availableUSers = availableUSers + 1;
                }else{
                    notAvailableUsers = notAvailableUsers + 1;
                }
            }
           var avus = ((availableUSers/total)*100).toFixed(2);
           var unavus = ((notAvailableUsers/total)*100).toFixed(2);
           
            component.set("v.availableUSers", avus);
            component.set("v.notAvailableUsers", unavus);    
            console.log('Test non temp1 '+component.get("v.notAvailableUsers"));    
             console.log('Test avail temp2 '+ component.get("v.availableUSers"));    
            console.log('TEst availableavus '+avus);
            console.log('TEst not availableunavus '+unavus);
                 component.set("v.shifts", currentList);
            component.set("v.detailShifts", detailList);
               
                console.log('checksite '+checksite);
              
                       if(checksite == true )
                {
                     console.log('checksite false '+checksite);
                     var dt= $('#demo-pie-1').pieChart();
                     var dt2= $('#demo-pie-2').pieChart();
                    dt.reload();
                    dt2.reload();
                      setTimeout(function(){ 
                         $('#demo-pie-1').pieChart()
                        
                                }, 500);
                setTimeout(function(){ 
                             $('#demo-pie-2').pieChart()
                            
                                }, 500); 
                }
                else
                {
                    console.log('checksite true '+checksite);
                       setTimeout(function(){ 
                                 $('#demo-pie-1').pieChart()
                                
                                    }, 500);
                    setTimeout(function(){ 
                                 $('#demo-pie-2').pieChart()
                                
                                    }, 500); 
                }
            
            }
            else
            {
                currentList = result;
                 detailList = result;
            component.set("v.shifts", currentList);
            component.set("v.detailShifts", detailList);
                console.log('no data '+result);
                console.log('no data length '+result.length);
              var avus = 0;
              var unavus = 0;
            component.set("v.availableUSers", avus);
            component.set("v.notAvailableUsers", unavus);
            console.log('Test non temp1 with no data '+component.get("v.notAvailableUsers"));    
             console.log('Test avail temp2 with no data '+ component.get("v.availableUSers")); 
               
                       if(checksite == true )
                {
                     console.log('checksite false '+checksite);
                     var dt= $('#demo-pie-1').pieChart();
                     var dt2= $('#demo-pie-2').pieChart();
                    dt.reload();
                    dt2.reload();
                      setTimeout(function(){ 
                         $('#demo-pie-1').pieChart()
                        
                                }, 500);
                setTimeout(function(){ 
                             $('#demo-pie-2').pieChart()
                            
                                }, 500); 
                }
                else
                {
                    console.log('checksite true '+checksite);
                       setTimeout(function(){ 
                                 $('#demo-pie-1').pieChart()
                                
                                    }, 500);
                    setTimeout(function(){ 
                                 $('#demo-pie-2').pieChart()
                                
                                    }, 500); 
                }
           
            }
               
           // $('#demo-pie-1').pieChart
          
        });
        $A.enqueueAction(action);
        
    },
    
    
})
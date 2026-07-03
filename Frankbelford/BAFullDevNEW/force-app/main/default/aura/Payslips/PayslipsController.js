({	
    doInit: function(component, event, helper) {
        var startdate = new Date();
		var checkdate1 = startdate.getDate();
        var check = startdate.getMonth() + 1;
        if(checkdate1<10)
		{
		checkdate1= '0'+checkdate1;	
		if(check<10)
        {
        check = '0'+check;
        var today = checkdate1+"/"+check+"/"+startdate.getFullYear();
        }
        else
        {
         var today = checkdate1+"/"+check+"/"+startdate.getFullYear();  
        }		
		}
		else
		{
		if(check<10)
        {
			check = '0'+check;
			var today = checkdate1+"/"+check+"/"+startdate.getFullYear();
        }
		else
		{
			var today = checkdate1+"/"+check+"/"+startdate.getFullYear();
		}
		}
        component.find("date2").set("v.value", today);
        
        var endDate = new Date();
        endDate.setDate(endDate.getDate() - 30);
		var checkdate2 = endDate.getDate();
        var check1 = endDate.getMonth() + 1;
		if(checkdate2<10)
		{
		checkdate2='0'+checkdate2;
        if(check1<10)
        {
         check1 = '0'+check1;   
         var endDateDisplay = checkdate2+"/"+check1+"/"+endDate.getFullYear();
        }
        else
        {
    	var endDateDisplay = checkdate2+"/"+check1+"/"+endDate.getFullYear();   
        }
		}
		else
		{
		if(check1<10)
        {
			check1 = '0'+check1;
			var endDateDisplay = checkdate2+"/"+check1+"/"+startdate.getFullYear();
        }
		else
		{
			var endDateDisplay = checkdate2+"/"+check1+"/"+startdate.getFullYear();
		}
		}
		
		
    	component.find("date1").set("v.value", endDateDisplay);
       
        
        var action = component.get("c.getPayslip");
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();         
            if (records.length == 0){
                component.set("v.Message", true);
            }else{
                component.set("v.Message", false);
            }
            component.set("v.allpayslips", records);  
            component.set("v.currentList", records);            
            component.set("v.Spinner", false);
            component.set("v.maxPage", Math.floor((records.length+9)/10)); //pagination
            helper.renderPage(component);
        });
        $A.enqueueAction(action);        
    },
     renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
 /*   nullify : function(component,event,helper)
{
    var dp = component.find('date1');
    dp.set('v.value', '');
},
     nullify2 : function(component,event,helper)
{
    var dp = component.find('date2');
    dp.set('v.value', '');
},*/
    SearchPaySlip: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        var action 		= component.get("c.PayslipLookup");
        var inputCmp1  	= component.find("date1");
        var inputCmp2 	= component.find("date2");
        var date1  		= inputCmp1.get("v.value");
        var date2 		= inputCmp2.get("v.value");
        var valid = true;
        if(date1==null || date2==null){
        	inputCmp1.set("v.errors", [{message:"From Date Required: " + date1}]); 
        }else{
          	inputCmp1.set("v.errors", null);  
        }
        if(date2==null){
        	inputCmp2.set("v.errors", [{message:"To Date Required: " + date2}]); 
        }else{
          	inputCmp2.set("v.errors", null);  
        }	
        var date123 = date2; 
        if(date123.includes("/"))
        {
        var arr1 = date123.split(' ');
        var arr2 = arr1[0].split('/');  
        var day = arr2[0];
        var month = arr2[1];
        var year = arr2[2];
        var datecheck1 = year +"-"+month+"-"+day;
        }
        else
        {
             var datecheck1 = date2;
        }
            
     
        var date456 = date1;
        if(date456.includes("/"))
        {
        var arr3 = date456.split(' ');
        var arr4 = arr3[0].split('/');  
        var day1 = arr4[0];
        var month1 = arr4[1];
        var year1 = arr4[2];
        var datecheck2 = year1 +"-"+month1+"-"+day1;
        }
        else
        {
            var datecheck2 = date1;
        }
        console.log('datecheck1----'+datecheck1);
        console.log('datecheck2----'+datecheck2);
        if(datecheck2>datecheck1)
        {
                toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "From date cannot be greater than To date"
                    
                });

             toastEvent.fire();  
            valid = false;
        }
        var futuredate = new Date();
       var checkfuture = futuredate.getMonth() + 1;
	   var checkfutturedate = futuredate.getDate();
        if(checkfutturedate<10)
		{
		checkfutturedate = '0'+checkfutturedate;	
		if(checkfuture<10)
        {
        checkfuture = '0'+checkfuture;
        var checktoday = futuredate.getFullYear()+"-"+checkfuture+"-"+checkfutturedate;
        }
        else
        {
         var checktoday = futuredate.getFullYear()+"-"+checkfuture+"-"+checkfutturedate;  
        }
		}
		else
		{
		if(checkfuture<10)
        {
        checkfuture = '0'+checkfuture;
        var checktoday = futuredate.getFullYear()+"-"+checkfuture+"-"+checkfutturedate;
        }
        else
        {
         var checktoday = futuredate.getFullYear()+"-"+checkfuture+"-"+checkfutturedate;  
        }	
		}
         if(datecheck1>checktoday)
        {
              
                toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "Future date cannot be entered"
                    
                });

             toastEvent.fire();
               valid = false;
          
        }    
      
        var todaydate = new Date(checktoday);
        var fromdatecheck = new Date(datecheck2);
        var diff = todaydate-fromdatecheck;
        var diff2 = diff/3600000;
        var monthcheck = diff2 * 0.001369;
        var comparecheck = Math.ceil(monthcheck);
        console.log('check4----'+comparecheck);
        if(comparecheck>24)
        {
            toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "From date cannot be beyond 24 months"
                    
                });

             toastEvent.fire();
             valid = false;
        }
      if( valid === true)
      {
        action.setParams({'fromdate': datecheck2, 'todate': datecheck1 });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", true);
                }else{
                    component.set("v.Message", false);
                }
                
                component.set("v.allpayslips", storeResponse); 
                component.set("v.currentList", storeResponse); 
                component.set("v.Spinner", false);
                component.set("v.maxPage", Math.floor((storeResponse.length+9)/10)); //pagination
                helper.renderPage(component);
            }
        }); 
        $A.enqueueAction(action);
      }
    },
    
    PayslipPrint: function(component, event, helper) {
        
        var chooseClick = event.getSource();
        var ids = chooseClick.get("v.value");
        console.log('IDS--'+ids);
        var action = component.get("c.PrintPayslip");
        action.setParams({ 'PAYSLIPID': ids });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //component.set("v.payslipDetails", response.getReturnValue());
                //component.set("v.isOpen", false);
                component.set("v.attachment", response.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({"url": response.getReturnValue()});
                urlEvent.setParams({"sandbox": "allow-popups allow-popups-to-escape-sandbox"});
                urlEvent.fire();
                
                console.log('pdf response---'+response.getReturnValue());
            }else{
                console.log("Failed with state: " + state);
                component.set("v.isOpen", false);
            }
        });
        $A.enqueueAction(action);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
     backtopayntimesheet: function(component, event,helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": "/pay-and-timesheet" });
        urlEvent.fire();
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    },
    desabledButton:function(component,event,helper){
         $A.util.addClass(getrecord, 'slds-visible');
    } 
    
})
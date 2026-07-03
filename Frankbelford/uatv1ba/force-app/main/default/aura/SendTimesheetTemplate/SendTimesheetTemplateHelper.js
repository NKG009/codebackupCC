({
	sPlacementGetDetails : function(component) {
		this.populateSelectWeekList(component);
		this.populateSelectYearList(component);
		var action = component.get("c.sPlacementGetDetails");
		action.setParams({"sPlacementId": component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				console.log('++++++++++result+++++ '+result);
                if(result.sirenum__Contact__r.Person_Status__c=='Active'){
                    component.set("v.pageDisplay",true);
                    component.set("v.processingText",false);
                    component.set("v.selectedWeekValue",result.Current_week__c);
                    component.set("v.selectedYearValue",result.Current_year__c);
                }
                else{
                    component.set("v.messageDisplay",'Candidate is inactive');
                    component.set("v.pageDisplay",false);
                    component.set("v.errorMessage",true);
                    component.set("v.successMessage",false);
                    component.set("v.processingText",false);
                }
			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.pageDisplay",false);
                component.set("v.errorMessage",true);
                component.set("v.successMessage",false);
				component.set("v.processingText",false);
            }
        });
        $A.enqueueAction(action);
	},
	populateSelectWeekList: function(component) {
    var objs = [];
    objs.push(this.createWeekObj('01','01'));
	objs.push(this.createWeekObj('02','02'));
	objs.push(this.createWeekObj('03','03'));
	objs.push(this.createWeekObj('04','04'));
	objs.push(this.createWeekObj('05','05'));
	objs.push(this.createWeekObj('06','06'));
	objs.push(this.createWeekObj('07','07'));
	objs.push(this.createWeekObj('08','08'));
	objs.push(this.createWeekObj('09','09'));
	for(var i=10;i<=53;i++){
		objs.push(this.createWeekObj(i, i));
		//objs.push(this.createWeekObj(String.valueOf(i), String.valueOf(i)));
	}
    component.set('v.weekOptions', objs);
	//console.log(''+component.find());
  },
	createWeekObj: function(weekLabel, weekValue) {
		var obj = new Object();
		obj.weekLabel = weekLabel;
		obj.weekValue = weekValue;
		return obj;
  },
  populateSelectYearList: function(component) {
	var today = new Date();
	var currentyear = today.getFullYear();
	var nextYear = today.getFullYear() + 1;
	var previousYear = today.getFullYear() - 1; 
    var objs = [];
    objs.push(this.createYearObj(previousYear,previousYear));
	objs.push(this.createYearObj(currentyear,currentyear));
	objs.push(this.createYearObj(nextYear,nextYear));
    component.set('v.yearOptions', objs);
  },
  createYearObj: function(yearLabel, yearValue) {
		var obj = new Object();
		obj.yearLabel = yearLabel;
		obj.yearValue = yearValue;
		return obj;
  },
  sPlacementSaveDetails : function(component) {
      console.log('++++++++++id+++++ '+component.get("v.recordId"));
      console.log('++++++++++week+++++ '+component.get("v.selectedWeekValue"));
      console.log('++++++++++year+++++ '+component.get("v.selectedYearValue"));
		var action = component.get("c.saveRecord");
        action.setParams({ "sPlacementId" : component.get("v.recordId") ,
                           "selectedpayrollweek" : component.get("v.selectedWeekValue"), 
                           "selectedpayrollyear" : component.get("v.selectedYearValue") }); 
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				console.log('++++++++++result+++++ '+result);
				component.set("v.messageDisplay",result);
                component.set("v.pageDisplay",false);
                component.set("v.errorMessage",false);
                component.set("v.successMessage",true);
                component.set("v.disabled",true);
				component.set("v.processingText",false);

			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.pageDisplay",false);
                component.set("v.errorMessage",true);
                component.set("v.successMessage",false);
				component.set("v.processingText",false);
            }
        });
        $A.enqueueAction(action);
	},
  sPlacementPrintDetails : function(component,event) {
      console.log('++++++++++id Print+++++ '+component.get("v.recordId"));
      console.log('++++++++++week+++++ '+component.get("v.selectedWeekValue"));
      console.log('++++++++++year+++++ '+component.get("v.selectedYearValue"));
		var action = component.get("c.printTimesheet");
        action.setParams({ "sPlacementId" : component.get("v.recordId") ,
                           "selectedpayrollweek" : component.get("v.selectedWeekValue"), 
                           "selectedpayrollyear" : component.get("v.selectedYearValue") }); 
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++'+state);
			if(state === "SUCCESS") {				
				console.log('++++++++++result+++++ '+result);
				component.set("v.messageDisplay",result);
                component.set("v.errorMessage",false);
                component.set("v.pageDisplay",false);
                component.set("v.successMessage",true);
                component.set("v.disabled",true);
				component.set("v.processingText",false);
				if(result === "Driving"){
					var urlEvent = $A.get("e.force:navigateToURL");
					urlEvent.setParams({
						"url":"/apex/Manual_Timesheet_Design?id="+component.get("v.recordId")
					});
					urlEvent.fire();
				}else{
					var urlEvent = $A.get("e.force:navigateToURL");
					urlEvent.setParams({
						"url":"/apex/Manual_TimeSheet_Design_2?id="+component.get("v.recordId")
					});
					urlEvent.fire();
				}

			}
            else{
                component.set("v.messageDisplay",result);
                component.set("v.errorMessage",true);
                component.set("v.pageDisplay",false);
                component.set("v.successMessage",false);
				component.set("v.processingText",false);
            }
        });
        $A.enqueueAction(action);
	}
})
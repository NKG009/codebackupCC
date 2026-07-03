({
	doGetAllShifts : function(component, event) {
	    component.set("v.spinner", true);
		var idParam = component.get("v.selectedSite");
		var action = component.get("c.getAllApprovedShifts");
		var selectedCandidate = component.get("v.candidateId");
		action.setParams({
		        siteId : idParam,
		        candidateId : selectedCandidate
        });
        //console.log("works >> " +idParam);
        action.setCallback(this, function (response) {
            //console.log('idParam ' + idParam);
            var result = response.getReturnValue();
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.ShiftList", result);
                component.set("v.shifts", result);
                component.set("v.truly", true);
                if(result.length > 0) {
                    component.set("v.noData", false);
                    //PAGINATION
                    component.set("v.totalPages", Math.ceil(result.length / component.get("v.pageSize")));
                    component.set("v.currentPageNumber", 1);
                    //component.set("v.Pagination", true);
                    if (component.get("v.totalPages") > 1) {
                        component.set("v.OnePage", true);
                    } else {
                        component.set("v.OnePage", false);
                    }
                } else {
                    component.set("v.noData", true);
                    component.set("v.totalPages", 0);
                    component.set("v.currentPageNumber", 1);
                    component.set("v.OnePage", false);
                }

                var tempNames = [];
                var shiftMap = this.getShiftMap(result);
                for( const k of shiftMap.keys()){
                    tempNames.push({
                        class: "optionClass",
                        label: shiftMap.get(k)[0].sirenum__Contact__r.Name + " ("+shiftMap.get(k).length+")",
                        value: k
                    });
                }
                console.log('tempNames.sort() >>>> ' + JSON.stringify(tempNames.sort()));

                tempNames.sort(function (a, b) {
                                 return a.label.localeCompare(b.label);
                               });
                if(selectedCandidate !== undefined) {
                    tempNames[0].selected = true;
                    //console.log("Setting selectedCandidate >> " + selectedCandidate);
                } else {
                    tempNames.unshift({
                        class: "optionClass",
                        label: "Select Temp Name ",
                        value: ""
                    });
                }
                component.set("v.candidateList", tempNames);
                component.set("v.ShiftList", result);
                //console.log('tempNames.sort() >>>> ' + JSON.stringify(tempNames.sort()));
                this.buildData(component);
            } else {
                console.error('Something went wrong. ' + JSON.stringify(result));
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
	},

	getShiftMap : function(result) {
	    var shiftMap = new Map();
	    for(const s of result){
	        if(shiftMap.has(s.sirenum__Contact__c)){
	            let sArray = shiftMap.get(s.sirenum__Contact__c);
	            sArray.push(s);
	            shiftMap.set(s.sirenum__Contact__c, sArray);
	        } else {
	            let nSArray = [s];
	            shiftMap.set(s.sirenum__Contact__c, nSArray);
	        }
        }
        return shiftMap;
    },

    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    /**
    * buildData AND generatePageList FUNCTIONS ARE USED FOR PAGINATION.
    * IDEALLY, PAGINATION SHOULD HAVE BEEN A CHILD COMPONENT
    * SINCE IT MAY NOT BE RE-USED IT IS KEPT WITH THIS COMPONENT
    */
    buildData: function (component) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.ShiftList");
        var x = (pageNumber - 1) * pageSize;
        //console.log("pageNumber >> "+ pageNumber);
        //console.log("pageSize >> "+ pageSize);
        //console.log("allData >> "+ JSON.stringify(allData));
        //console.log("x >> "+ x);

        for (; x < (pageNumber) * pageSize; x++) {
            if (allData[x]) {
                data.push(allData[x]);
            }
        }
        //console.log("data >> "+ JSON.stringify(data));
        //console.log('###lendata ' + data.length);
        component.set("v.shifts", data);

        this.generatePageList(component, pageNumber);
    },

    generatePageList: function(component, pageNumber) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        //console.log('totalPages >> '+totalPages);
        if (totalPages > 1) {
            if (totalPages <= 10) {
                var counter = 1;
                for (; counter <= (totalPages); counter++) {
                    //console.log('+counter ' + counter);
                    pageList.push(counter);
                }
            } else {
                if (pageNumber < 5) {
                    pageList.push(1, 2, 3, 4, 5);
                } else {
                    if (pageNumber > (totalPages - 5)) {
                        pageList.push(totalPages - 5, totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1);
                    } else {
                        pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
                    }
                }
            }
        }
        //console.log(pageList.length);
        component.set("v.pageList", pageList);
    },

	convertArrayOfObjectsToCSV: function (component, objectRecords) {
        if(objectRecords == null || !objectRecords.length) {
            return null;
        }

        var columnDivider = ',';
        var lineDivider = '\n';
        var keys = ['Temp Name', 'Job Role', 'Date', 'Start Time', 'End Time', 'Break',  'Total Hours', 'Charge'];

        var csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;

		var counter = 0;
        for(var i = 0; i < objectRecords.length; i++) {
            counter = 0;

            for(var sTempkey in keys) {
                var skey = keys[sTempkey];
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }

                if(skey == 'Temp Name') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Contact__r']['Name'] + '"';
                }
                else if(skey == 'Job Role') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Team__r']['Name'] + '"';
                }
                else if(skey == 'Date') {
					csvStringResult += '"' + objectRecords[i]['StartDate'] + '"';
                }
                else if(skey == 'Start Time') {
					csvStringResult += '"' + objectRecords[i]['Starttime__c'] + '"';
                }
                else if(skey == 'End Time') {
					csvStringResult += '"' + objectRecords[i]['EndTime__c'] + '"';
                }
                else if(skey == 'Break') {
					csvStringResult += '"' + objectRecords[i]['Break_from_Brekdef__c'] + '"';
                }
                else if(skey == 'Total Hours') {
					csvStringResult += '"' + objectRecords[i]['TotalHours'] + '"';
                }
                else if(skey == 'Charge') {
					csvStringResult += '"' + objectRecords[i]['ForecastCharge'] + '"';
                }

                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;
    },

    showToast: function (component, event, type, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type + "!",
            "message": msg
        });
        toastEvent.fire();
    }
})
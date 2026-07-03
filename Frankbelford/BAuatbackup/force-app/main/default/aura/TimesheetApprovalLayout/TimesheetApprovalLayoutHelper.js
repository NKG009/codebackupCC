({
    helperscriptload: function (component, event, helper) {
        setTimeout(function () {
            $('.searchDetail_table').on('click', 'span', function () {
                console.log('tr@@ 12');
                var tr = $(this).closest('tr');
                if ($(tr).hasClass('child')) {
                    var Id = $(this).attr('id');
                    console.log(Id);
                    helper.helperTimeSheetLines(component, Id, helper);
                }

            });
        }, 3000);
    },
    helperTimeSheetLines: function (component, Id, helper) {
        console.log('TimeSheetId:');

        var idName = Id;
        console.log('idName: ' + idName);
        var idAndName = idName.split('|');

        var timeSheetLines = component.get("c.fetchTimeSheetLines");
        timeSheetLines.setParams({ "timeSheetId": idAndName[0] });
        timeSheetLines.setCallback(this, function (result) {
            var lineRecords = result.getReturnValue();
            console.log('lineRecords:', lineRecords);
            component.set("v.timeSheetId", idAndName[1]);
            if (lineRecords.length > 0) {
                component.set("v.timeSheetLines", lineRecords);
                component.set("v.errMsg", '');
                //component.set("v.showError",false);
            } else {
                component.set("v.timeSheetLines", lineRecords);
                component.set("v.errMsg", 'No TimeSheet Lines found');
                //component.set("v.showError",true);
            }
        });
        $A.enqueueAction(timeSheetLines);
    },
    renderPage: function (component) {
        var records = component.get("v.TimeSheets");
        var pageNumber = component.get("v.pageNumber");
        //var pageRecords;
        console.log('pageNumber:', pageNumber);
        if (pageNumber != null && records != null) {
            var pageRecords = records.slice((pageNumber - 1) * 6, pageNumber * 6);
            //     component.set("v.currentList", pageRecords);

            setTimeout(function () {
                $('#tableId').DataTable(
                    {
                        responsive: true,
                        aaSorting: [],
                        columnDefs: [
                            { "orderable": false, "targets": [6] },

                        ]
                    }

                );

                $("#overlay").hide();
            }, 3000);

        }
        console.log('pageRecords ' + pageNumber);

    },
    getJsonFromUrl: function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function (part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['Temp Name', 'Job Role', 'Timesheet No.', 'Week Ending', 'Total Hours', 'Charge'];

        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;

        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;

            for (var sTempkey in keys) {
                var skey = keys[sTempkey];
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                //console.log('fddf '+objectRecords[i]['sirenum__Worker__r']['Name']);

                if (skey == 'Temp Name') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Worker__r']['Name'] + '"';
                }
                if (skey == 'Job Role') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Team__r']['Name'] + '"';
                }
                if (skey == 'Timesheet No.') {
                    if (objectRecords[i]['IP_StandardWeeklyNumberID__c'] === undefined) {
                        csvStringResult += '"' + ' ' + '"';
                    }
                    else {
                        csvStringResult += '"' + objectRecords[i]['IP_StandardWeeklyNumberID__c'] + '"';
                    }

                }
                if (skey == 'Week Ending') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Week_Ending__c'] + '"';
                }
                if (skey == 'Total Hours') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Total_Hours__c'] + '"';
                }
                if (skey == 'Charge') {
                    csvStringResult += '"' + objectRecords[i]['sirenum__Total_Charge__c'] + '"';
                }

                counter++;

            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;
    },

    showToast: function (component, event, type, msg) {
        //console.log("in showToast");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type + "!",
            "message": msg
        });
        toastEvent.fire();
    }
})
/**
 * Created by mrahman on 2020-09-26.
 */
({
    createChart : function (component) {
        var ready = component.get("v.ready");
        var reportId = component.get("v.reportId");
        if (ready === false) {
            return;
        }
        var chartCanvas = component.find("chart").getElement();

        //alert("loading chart data");
        var action = component.get("c.getDoughnutChart");
        action.setParams({"reportId" : reportId,});
        console.log(">>>>> loading chart data");
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {

                var reportResultData = JSON.parse(response.getReturnValue());
                var reportName = reportResultData.reportMetadata.name;
                component.set("v.reportName", reportName);

                var legendLabels = [];
                var chartData = [];
                var chartDataSet = [];
                var chartLabels = [];
                var revCount = reportResultData.groupingsDown.groupings.length-2;
                console.log('revCount='+revCount);
                console.log(">>>>> Construct chart <<<<<<<");

                var noOfLegendLabels = 3;
                //var legLabMap = new Map();
                //var rawDataSet = {};
                for(let rds=noOfLegendLabels-1; rds >=0; rds--){
                    var lKey = Object.keys(reportResultData.reportExtendedMetadata.detailColumnInfo)[rds];
                    legendLabels.push(reportResultData.reportExtendedMetadata.aggregateColumnInfo["s!"+lKey].label);
                    //Object.assign(rawDataSet,{Label : reportResultData.reportExtendedMetadata.aggregateColumnInfo["s!"+lKey].label});
                    var tmpData = [];
                    //legLabMap.set(reportResultData.reportExtendedMetadata.aggregateColumnInfo["s!"+lKey].label, tempData);
                }
                console.log("legendLabels");
                console.log(legendLabels);

                console.log(reportResultData.groupingsDown.groupings.length);
                //for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                for(var i=0; i < legendLabels.length; i++){
                    var tempCDS = {};
                    //Collect all labels for Chart.js data

                    console.log(legendLabels[i]);

                    var bgColor = [];
                    var dynamicBgColor = "#"+Math.floor(Math.random()*16777215).toString(16);
                    var tempCd = [];
                    for(var j=0; j < (reportResultData.groupingsDown.groupings.length); j++){

                        if(!chartLabels.includes(reportResultData.groupingsDown.groupings[i].label)){
                            chartLabels.push(reportResultData.groupingsDown.groupings[i].label);
                        }
                        console.log(j+"=" + reportResultData.factMap[j + '!T'].aggregates[i].value);

                        bgColor.push(dynamicBgColor);
                        //var keyTemp = reportResultData.groupingsDown.groupings[i].key;
                        //var labelTemp = reportResultData.groupingsDown.groupings[i].label;

                        //console.log("keyTemp>>> " + keyTemp);

                        //Collect all values for Chart.js data
                        tempCd.push(reportResultData.factMap[j + '!T'].aggregates[i].value);
                        //console.log()
                    }
                    //Object.assign(tempCDS, {label : tempLegendLabels, data : tempCd, backgroundColor: bgColor});
                    Object.assign(tempCDS, {label : legendLabels[i], data : tempCd, backgroundColor: bgColor});
                    chartDataSet.push(tempCDS);
                }
                console.log(">>> chartLabels <<<");
                console.log(chartLabels);
                console.log(">>> chartDataSet <<<");
                console.log(chartDataSet);

                //console.log("chartData" + JSON.stringify(chartData));
                //Construct chart

                var chart = new Chart(chartCanvas,{
                    type: 'bar',
                    data: {
                        labels: chartLabels,
                        datasets: chartDataSet
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        },
                        cutoutPercentage: 50,
                        maintainAspectRatio: false,
                        legend: {
                            display: true,
                            position:'right',
                            fullWidth:false,
                            reverse:true,
                            labels: {
                                fontColor: '#000',
                                fontSize:10,
                                fontFamily:"Salesforce Sans, Arial, sans-serif SANS_SERIF"
                            },
                            layout: {
                                padding: 100,
                            }
                        }
                    }
                });

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createReport: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } else {
                console.error("Chart was not loaded for Unknown");
            }
        });
        $A.enqueueAction(action);
    }
})
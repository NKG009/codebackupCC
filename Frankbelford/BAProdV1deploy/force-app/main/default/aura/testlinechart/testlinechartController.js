({
    afterScriptsLoaded  : function(component, event, helper)
    {
       
        var jsonData = component.get("v.Monthlist");       
        var dataObj = JSON.parse(jsonData);      
        var xAxisl = [];
       for(var i=0 ; i<dataObj.length ; i++)
       {
           xAxisl.push(dataObj[i].name);
       }
        component.set("v.xAxisCategories",xAxisl);
         //alert(xAxisl);
        new Highcharts.Chart({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                renderTo: component.find("linechart").getElement(),
                type: 'line'
            },
            xAxis: {
                categories: component.get("v.xAxisCategories"),
                crosshair: false
            },
            yAxis: {
                min: 0,
                title:
                {
                    text: component.get("v.yAxisParameter")
                }
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.y}</b>'
            },
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: false
                    },
                    enableMouseTracking: true
                }
            },
            series: [{
                name:'Week',
                data:dataObj
            }]
 
        });
     },
 
})
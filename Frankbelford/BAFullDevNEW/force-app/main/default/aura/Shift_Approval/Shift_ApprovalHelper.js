({
    loadData : function(cmp, event){
        var temp = [];
        var shiftsRequiringApproval;
        var totalShifts;
        var action = cmp.get("c.getAllShifts");
        console.log(cmp.get("v.site"));
        action.setParams({
            "site": cmp.get("v.site"),
            "contact": cmp.get("v.contact"),
            "startDate": cmp.get("v.startDate"),
            "endDate": cmp.get("v.endDate")
        });

        var currentList;
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp = response.getReturnValue();
                this.createGraph(cmp, temp);
                var res = Object.values(temp);
                cmp.set("v.shiftsRequiringApproval", res[0]);
                cmp.set("v.shiftsApproved", res[1]);
                cmp.set("v.totalShifts", res[2]);
            }
        });
        $A.enqueueAction(action);
    },
    createGraph : function(cmp, temp) {
        
        var dataMap = {"chartLabels": Object.keys(temp),
                       "chartData": Object.values(temp)
                      };
        
        var el = cmp.find('barChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "Payments History",
                        backgroundColor: ["#e4007d", "#a8d431", "#5b9bd5"], 
                        data: dataMap.chartData
                    }
                ]
            },
            options: { 
                legend: {
                    display: false,
                },
                tooltips: {
                    labelColor: function(tooltipItem, chart) {
                    return {
                        borderColor: 'rgb(255, 0, 0)',
                        backgroundColor: 'rgb(255, 0, 0)'
                    }
                },
                labelTextColor:function(tooltipItem, chart){
                    return '#543453';
                }
                }
            }
        });
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

    goToUrl : function(pageUrl, cmp, event){
        event.preventDefault();
        var urlEvent = $A.get("e.force:navigateToURL");
        pageUrl = pageUrl+"?site="+cmp.get("v.site")+"&refreshView=true";
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
        //console.log('pageUrl >> ' + pageUrl);
    }
})
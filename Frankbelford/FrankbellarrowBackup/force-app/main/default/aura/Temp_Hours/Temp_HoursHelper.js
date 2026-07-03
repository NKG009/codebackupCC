({
	loadData : function(component, event) {
		var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        component.set('v.baseURL', baseURL);

        var url = window.location.href.slice(window.location.href.indexOf('?') + 1);
        var siteRecId = url.split("site=")[1];
        var siteId = component.get("v.site");

        if(siteId == undefined || siteId == ""){
            siteId = siteRecId;
        }

        var actionGetShift = component.get("c.getAllShifts");
        actionGetShift.setParams({
            "site" : siteId,
            "filter" : "today"
        });
        console.log('==site@@@=='+siteId);
        console.log('==temphours@@@==');

        actionGetShift.setCallback(this, function(response){
            console.log('==temphours inside action==');
            console.log('==11111@@@=='+response.getReturnValue());
            console.log('==11111@@@=='+response.getState());
            var result = response.getReturnValue();

            console.log('==result@@@=='+result);
            // alert(result);
            if(result.length>0)
            {
                component.set("v.allshifts", result);
            }
        });

        var action1 = component.get("c.getAllShiftsHoursData");
        component.set("v.ActiveVacancyFlag",false);
        action1.setParams({
            "site" : siteId
        });

        action1.setCallback(this, function(response) {
            console.log('==11111@@@==return'+response.getReturnValue());
            console.log('==11111@@@==state'+response.getState());
            var result = response.getReturnValue();
            // alert(result);
            component.set("v.Monthlist",result);
            //alert(component.get("v.Monthlist"));
            component.set("v.ActiveVacancyFlag",true);
        });
        $A.enqueueAction(actionGetShift);
        $A.enqueueAction(action1);
	},

    //OLD WAY OF NAVIGATION
    //EXPECTED IN CONTROLLER helper.goToUrl("/approved-timeSheets-new", component, event);
	goToUrl : function(pageUrl, cmp, event){
        event.preventDefault();
        var urlEvent = $A.get("e.force:navigateToURL");
        pageUrl = pageUrl+"?site="+cmp.get("v.site");
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
        console.log('pageUrl >> ' + pageUrl);
    },

    //NEW WAY OF NAVIGATION
    doCommPageNav : function(cmmPageName, cmp, event){
        event.preventDefault();
        var navService = cmp.find( "navService" );
        var pageReference = {
            type: "comm__namedPage",
            attributes: {
                pageName: cmmPageName
            },
            state: { 
                site: cmp.get("v.site")
            }
        };
        navService.navigate(pageReference);
    }
})
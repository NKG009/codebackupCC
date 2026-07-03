/**
 * Created by mrahman on 2021-02-10.
 */
({
    //THIS IS MOST PREFERRED NAVIGATION OPTION DUE TO SMOOTHNESS.
    //HOWEVER IT MAY NOT WORK WITH HEAVILY CUSTOMISED JS SCRIPT DOM. FOR EXAMPLE: CUSTOM jQuery DATE PICKER
    //Expected code in controller helper.goToUrl("/pasttemps", component, event);
    goToUrl : function(pageUrl, cmp, event){
        var urlEvent = $A.get("e.force:navigateToURL");
		var refreshPage = '';
        if(pageUrl == '/candidateview') {
            refreshPage = '&refreshView=true';
        }
        pageUrl = pageUrl+"?site="+cmp.get("v.site") + refreshPage;
        urlEvent.setParams({ "url": pageUrl });
        urlEvent.fire();
        //console.log('pageUrl >> ' + pageUrl);
    },

    //THIS OLD WAY NAVIGATION USE goToUrl INSTEAD
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
    },
    //RELOADS THE WHOLE PAGE AND PAGE. THIS IS CLIENT SIDE RESOURCE INTENSIVE OPERATION. TRY TO AVOID IT AT ALL COST
    doWindowLocReplace : function(cmmPageName, component, event){
        event.preventDefault();
        var param = component.get("v.site");
        var urlRedirect = component.get('v.baseURL')+cmmPageName+"?site="+param;;
        window.location.replace(urlRedirect);
    }
})
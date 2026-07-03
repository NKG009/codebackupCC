({
    doInit : function(cmp, event, helper){
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        cmp.set('v.baseURL', baseURL);
    },
    reInit : function(cmp, event, helper){
        console.log('Trying to reload data');
        helper.loadData(cmp, event);
    },
    handleClick : function(cmp, event, helper) {
        helper.goToUrl("/candidateview", cmp, event);
    },

    ctr : function(cmp, event, helper) {
        helper.loadData(cmp, event);
    }
})
/**
 * Created by mrahman on 2020-12-08.
 */
({
    init : function(cmp, event, helper) {
        console.log("in parent flow Nav Init");
        // Figure out which buttons to display
        var availableActions = cmp.get('v.availableActions');
        console.log("availableActions >> " + availableActions);
        for (var i = 0; i < availableActions.length; i++) {
            if (availableActions[i] == "PAUSE") {
                cmp.set("v.canPause", true);
            } else if (availableActions[i] == "BACK") {
                cmp.set("v.canBack", true);
            } else if (availableActions[i] == "NEXT") {
                cmp.set("v.canNext", true);
            } else if (availableActions[i] == "FINISH") {
                cmp.set("v.canFinish", true);
            }
        }
    },
    handleNavigate: function(cmp, event) {
        console.log('handleNavigate - parent');
        var navigate = cmp.get("v.navigateFlow");
        navigate(event.getParam("action"));
    },

    handleAddressEvent: function(cmp, event, helper) {
        var canProceed = event.getParam("canProceed");
        var msg = event.getParam("msg");
        cmp.set("v.canProceed", canProceed);
        cmp.set("v.msg", msg);
        cmp.set("v.showError", false);
    }
})
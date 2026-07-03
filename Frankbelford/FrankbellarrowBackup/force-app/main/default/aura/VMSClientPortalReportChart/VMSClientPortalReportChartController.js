/**
 * Created by mrahman on 2020-09-26.
 */
({
    doInit: function(component, event, helper) {
        //alert("Report component");
        component.set("v.reportId", "00O3H000000OjaXUAS");
        //component.set("v.ready", true);
        //component.set("v.reportId", "00O3H000000OjaXUAS");
        //helper.createChart(component);
    },

    afterScriptsLoaded : function(component, event, helper) {
        console.log(">>>> Preparing to load VMS Charts <<<<<");
        component.set("v.ready", true);
        //component.set("v.reportId", "00O3H000000OjaXUAS");
        helper.createChart(component);
    }
})
({
    doInit : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.cbaseURL", baseURL);
    },
	navigateToIntegration : function(component, event, helper) {
		var action = component.get("c.sendEmail");
        var buttonLabel = event.currentTarget.dataset.id;
        action.setParams({ buttonLabel : buttonLabel});
        action.setCallback(this, function(response) {
            console.log('Email error'+response.getError());
            var baseURL = "https://full-ps360agents.cs114.force.com/Vantage360/s/integrations";
            if(buttonLabel.toLowerCase() == 'property tree') {
            	baseURL += "/property-tree";
            } else if(buttonLabel.toLowerCase() == 'property me') {
            	baseURL += "/propertyme";
            } else if(buttonLabel.toLowerCase() == 'console cloud') {
            	baseURL += "/console";
            } else if(buttonLabel.toLowerCase() == 'vault') {
            	baseURL += "/vault";
            }
            window.location.href = baseURL;
        });
        $A.enqueueAction(action);
	}
})
({
	
    showToast : function(toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : toastType,
            "title": toastType.includes('success') ? 'Success!' : 'Error!',
            "message": message
        });
        toastEvent.fire();
    }
})
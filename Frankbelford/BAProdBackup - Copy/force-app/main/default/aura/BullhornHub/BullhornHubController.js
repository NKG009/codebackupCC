({
	
     onInit : function(
        component, event, helper
    ) {
        
        console.log( 
            'Inside onInit'
        );
        let urlEvent = $A.get(
            "e.force:navigateToURL"
        );
        urlEvent.setParams( {
            "url": 'https://help.bullhorn.com'
        } );
        urlEvent.fire(); 
        
    }
    
} )
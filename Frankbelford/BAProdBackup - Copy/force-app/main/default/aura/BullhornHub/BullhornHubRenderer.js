({
	afterRender  : function( 
        component, helper
    ) {
        
        console.log( 
            'Inside afterRender Action' 
        );
        $A.get( 
            "e.force:closeQuickAction" 
        ).fire();
        
    }
})
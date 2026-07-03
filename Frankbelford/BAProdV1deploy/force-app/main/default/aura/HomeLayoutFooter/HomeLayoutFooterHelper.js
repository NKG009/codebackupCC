/**
 * Created by mrahman on 2021-02-25.
 */
({
    getBrandDetails : function (component, event) {

        var brand = component.get("v.brand");
        var action = component.get("c.getBrandDetails");

        action.setParams({
            brandName : brand
        });
        console.log("getting brand details -- 11 " + brand);
        action.setCallback(this, function(response){
            console.log("response.getState() >> " + JSON.stringify(response.getState()));

            var state = response.getState();

            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result >>> " + JSON.stringify(result));
                component.set("v.brandDetails", response.getReturnValue());
            } else {
                console.error(state + " could not get Brand details " + JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
        console.log('<<<< End of getBrandDetails >>>>');
    }
})
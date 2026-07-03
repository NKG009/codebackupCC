/**
 * Created by mrahman on 2021-03-23.
 */
({
    resetPasswordHelper: function (component, event, helpler) {
        var Username = component.find('resetUsername').getElement().value;
        //alert('=Username=' + Username);
        var usernameToReset = Username;
        var action = component.get("c.resetPassword");
        action.setParams({
            userName: usernameToReset
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            var rtnValue = response.getReturnValue();
            //alert('=rtnValue=' + rtnValue);
            console.log(rtnValue);
            if (rtnValue !== null) {
                if (rtnValue !== 'PasswordReseted') {
                    component.set("v.resetError", 'Check Your Username');
                }
            }
        });
        $A.enqueueAction(action);
    }
})
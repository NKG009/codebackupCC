/**
 * Created by mrahman on 2021-03-23.
 */
({
    doInit: function (cmp, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"))+"/s/";
        component.set('v.baseURL', baseURL);
    },

    getInput: function (component, event, helper) {
        component.set("v.mylabel1", "");
        // Get the Username from Component
        var user = component.find('uname').getElement().value;
        var Pass = component.find('pass').getElement().value;
        console.log(user + Pass);

        //Calling controller
        var action = component.get("c.checkPortal");
        action.setParams({
            username: user,
            password: Pass
        });
        action.setCallback(this,
            function (response) {
                var state = response.getState();
                var rtnValue = response.getReturnValue();
                console.log(rtnValue);
                if (rtnValue !== null) {
                    if (rtnValue === 'Your login attempt has failed. Make sure the username and password are correct.') {
                        component.set("v.mylabel", rtnValue);
                    } else if (rtnValue === "UserNameError") {
                        component.set("v.mylabel", "Please fill the username");
                    } else if (rtnValue === "PasswordError") {
                        component.set("v.mylabel", "Please fill the Password");
                    } else {
                        console.error("Login - unexpected response " + rtnValue);
                    }
                }
            });
        $A.enqueueAction(action);
    },

    /*This function is used to reset the password */
    resetPassword: function (component, event, helpler) {
        //var Username = component.find('resetUsername').getElement().value;
        var usernameToReset = component.find('resetUsername').getElement().value;
        var action = component.get("c.resetPasswordMethod");
        action.setParams({
            "userName": usernameToReset
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state >> " + state);
            var rtnValue = response.getReturnValue();
            console.log('===' + rtnValue);
            if(state === "SUCCESS") {
                if (rtnValue !== null) {
                    if (rtnValue === 'NotFound') {
                        component.set("v.resetError", 'Check Your username');
                    } else if (rtnValue === 'EnterUserName') {
                        component.set("v.resetError", 'Please enter username');
                    } else if (rtnValue === 'Reset') {
                        $A.get('e.force:refreshView').fire();
                        component.set("v.resetError", '');
                        component.set("v.isShowResetModal", false);
                        console.log('=isShowResetModal=' + component.get("v.isShowResetModal"));
                    }
                }
            } else {
                console.error("Could not reset password for " + usernameToReset);
            }
        });
        $A.enqueueAction(action);
    },

    //make Spinner attribute true for display loading spinner
    showSpinner: function (component, event, helper) {
        component.set("v.Spinner", true);
    },

    //this function automatic call by aura:doneWaiting event
    // make Spinner attribute to false for hide loading spinner
    hideSpinner: function (component, event, helper) {
        component.set("v.Spinner", false);
    },

    forgetPasswordNavigate: function (component, event, helper) {
        var param = component.get("v.site");
        //var urlRedirect = $A.get("$Label.c.Lightning_Component_URL") + 'ForgotPassword';
        var urlRedirect = component.get("v.baseURL") + 'ForgotPassword';
        window.location.replace(urlRedirect);
        return false;
    },

    callExpernalSite: function (component, event, helper) {
        window.location.replace(component.get("v.baseURL") + "myagencytemp");
        return false;
    },

    onClickForgotPassword: function (component, event, helper) {
        component.set("v.isShowResetModal", true);
        component.set("v.resetError", '');
        component.find('resetUsername').getElement().set("v.value", '');
    }
})
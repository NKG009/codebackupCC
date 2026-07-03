({
    getInput: function (component, event, helper) {
        component.set("v.mylabel1","");
        // Get the Username from Component
        var user = component.find('uname').getElement().value;
        var Pass = component.find('pass').getElement().value;
        console.log(user+Pass);
        //Calling controller
        // Create the action
        var action = component.get("c.checkPortal");
        
        action.setParams({
            username: user,
            password: Pass
        });
        // Add callback behavior for when response is received
        action.setCallback(this,
                           function (response) {
                               var state = response.getState();
                               var rtnValue = response.getReturnValue();
                               console.log(rtnValue);
                               if (rtnValue !== null) {
                                  if(rtnValue ==='Your login attempt has failed. Make sure the username and password are correct.'){
                                       component.set("v.mylabel",rtnValue);
                                   }else if(rtnValue ==="UserNameError"){
                                       component.set("v.mylabel","Please fill the username");
                                   }else if(rtnValue ==="PasswordError"){
                                       component.set("v.mylabel","Please fill the Password");
                                   }
                                   //component.set("v.showError",true);
                               }
                           });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
  
    /*This function is used to reset the password */
    resetPassword : function (component,event, helpler) {
        var Username = component.find('resetUsername').getElement().value;
        var usernameToReset = Username;
        var action = component.get("c.resetPasswordMethod");
        action.setParams({
            "userName": usernameToReset
        });
         // Add callback behavior for when response is received
        action.setCallback(this,function (response) {
                               var state = response.getState();
                               var rtnValue = response.getReturnValue();
                               console.log('==='+rtnValue);
                               if (rtnValue !== null) {
                                  if(rtnValue ==='NotFound'){
                                       component.set("v.resetError",'Check Your username');
                                  }else if(rtnValue === 'EnterUserName'){
                                      component.set("v.resetError",'Please enter username');
                                  }else if(rtnValue === 'Reset'){
                                      $A.get('e.force:refreshView').fire();
                                      component.set("v.resetError",'');
                                      component.set("v.isShowResetModal", false);
                                      
                                      console.log('=isShowResetModal='+component.get("v.isShowResetModal"));
                                    
                                  }
                                   
                               }
                           });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    }, 
    
    // this function automatic call by aura:waiting event
    showSpinner: function (component,event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner",true);
    },
    
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component,event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner",false);
    },
    
    
    forgetPasswordNavigate : function(component, event, helper){
        var param = component.get("v.site");
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+'ForgotPassword';
        window.location.replace(urlRedirect);
        return false;
    },
    
    callExpernalSite : function(component, event, helper){
        window.location.replace("https://www.bluearrow.co.uk/myagencytemp");
        return false;
	},
    
    onClickForgotPassword : function(component,event,helper){
        component.set("v.isShowResetModal", true);
        component.set("v.resetError",'');
        component.find('resetUsername').getElement().set("v.value",'');
    }
})
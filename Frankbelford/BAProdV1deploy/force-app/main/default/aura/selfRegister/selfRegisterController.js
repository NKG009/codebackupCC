({
  initialize: function (component, event, helper) {
    component.set("v.accountId", "a724J000000PiHNQA0");
    component.set("v.codeLabel", "Enter the code provided in the below box:-");
    $A.get("e.siteforce:registerQueryEventMap")
      .setParams({ qsToEvent: helper.qsToEventMap })
      .fire();
    component.set("v.extraFields", helper.getExtraFields(component, event));

    component.set("v.candidateId", helper.getUrlParameter("id"));
    helper.getCandidate(component);
  },

  handleSelfRegister: function (component, event, helper) {
    console.log("in handleSelfRegister");
    component.set("v.errorMessage", undefined);
    helper.handleSelfRegister(component, event);
  },

  setStartUrl: function (component, event, helper) {
    var startUrl = event.getParam("startURL");
    if (startUrl) {
      component.set("v.startUrl", startUrl);
    }
  },

  setExpPatern: function (component, event, helper) {
    helper.verifyPassword(component, event);
  },

  onKeyUp: function (component, event, helpler) {
    //checks for "enter" key
    if (event.getParam("keyCode") === 13) {
      helper.handleSelfRegister(component, event, helper);
    }
  },

  startVerification: function (component, event, helper) {
    component.set("v.showError", false);
    var checkPW = helper.verifyPassword(component, event);
    if (!checkPW) {
      return;
    }

    var accountId = component.get("v.accountId");
    var firstname = component.get("v.firstname");
    var lastname = component.get("v.lastname");
    var emailAddress = component.get("v.email");

    //jyothi.start
    var checkRadio = helper.verifyQuestion(component, event);
    if (!checkRadio) {
      return;
    }
    var valueUkROI = component.get("v.valueUkROI");
    var valueWorkInUk = component.get("v.valueWorkInUk");

    component.set("v.isROIValidation", false);
    if (valueUkROI == "No" || valueWorkInUk == "No") {
      component.set("v.isROIValidation", true);
      component.set("v.regStage", 3);
      var urlEvent = $A.get("e.force:navigateToURL");
      urlEvent.setParams({
        url: component.get("v.ROIPageURL")
      });
      urlEvent.fire();
      return;
    }
    //jyothi.stop

    var action = component.get("c.initVerification");
    action.setParams({
      fn: firstname,
      ln: lastname,
      em: emailAddress
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      console.log("startVerification state >> " + state);
      if (state === "SUCCESS") {
        component.set("v.regStage", 1);
        console.log(
          "Returned value:: " + JSON.stringify(response.getReturnValue())
        );
        component.set("v.vId", response.getReturnValue());
      } else if (state === "ERROR") {
        var msg =
          response.getReturnValue() === null
            ? "Error! Unable process your request. Please contact your branch."
            : "Oops!" +
              response.getReturnValue() +
              "Please contact your branch.";
        component.set("v.errorMessage", msg);
        component.set(
          "v.confMsgClass",
          "slds-text-heading_small slds-text-color_error imp_regerror"
        );
        component.set("v.showError", true);
        //alert('test>>>');
      } else {
        var msg =
          "Something went wrong. Cannot start registration process please contact your branch";
        console.log(
          "Something went wrong. Cannot start verification process. Error >> " +
            JSON.stringify(response.getReturnValue())
        );
        component.set("v.errorMessage", msg);
        component.set(
          "v.confMsgClass",
          "slds-text-heading_medium slds-text-color_error"
        );
        component.set("v.showError", true);
      }
    });
    $A.enqueueAction(action);
  },

  reSendVerification: function (component, event, helper) {
    helper.toggleSpinner(component, event);
    var accountId = component.get("v.accountId");
    var firstname = component.get("v.firstname");
    var lastname = component.get("v.lastname");
    var emailAddress = component.get("v.email");

    var action = component.get("c.initVerification");
    action.setParams({
      fn: firstname,
      ln: lastname,
      em: emailAddress
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      console.log("reSendVerification state >> " + state);
      if (state === "SUCCESS") {
        component.set("v.errorMessage", "");
        component.set("v.showError", false);
        component.set("v.vId", response.getReturnValue());
      } else {
        var msg =
          "Unable to issue new verification code. " +
          JSON.stringify(response.getReturnValue());
        component.set("v.errorMessage", msg);
        component.set("v.showError", true);
      }
      helper.toggleSpinner(component, event);
    });
    $A.enqueueAction(action);
  },

  confirmRedirect: function (component, event, helper) {
    var navEvt = $A.get("e.force:navigateToURL");
    navEvt.setParams({ url: "/" });
    navEvt.fire();
  }
});
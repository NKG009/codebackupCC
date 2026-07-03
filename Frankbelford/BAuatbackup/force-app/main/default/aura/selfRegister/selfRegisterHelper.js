({
  qsToEventMap: {
    startURL: "e.c:setStartUrl"
  },

  qsToEventMap2: {
    expid: "e.c:setExpId"
  },

  toggleSpinner: function (component, event) {
    var spinner = component.get("v.spinner");
    var isShowing = spinner ? false : true;
    component.set("v.spinner", isShowing);
  },

  handleSelfRegister: function (component, event) {
    var accountId = component.get("v.accountId");
    var regConfirmUrl = component.get("v.regConfirmUrl");
    var firstname = component.get("v.firstname");
    var lastname = component.get("v.lastname");
    var email = component.get("v.email");
    var includePassword = component.get("v.includePasswordField");
    var password = component.get("v.password");
    var confirmPassword = component.get("v.confirmPassword");
    var code = component.get("v.code");
    var id = component.get("v.vId");

    var extraFields = JSON.stringify(component.get("v.extraFields"));
    var startUrl = component.get("v.startUrl");
    this.toggleSpinner(component, event);
    var action = component.get("c.selfRegister");

    startUrl = decodeURIComponent(startUrl);

    action.setParams({
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      accountId: accountId,
      regConfirmUrl: regConfirmUrl,
      extraFields: extraFields,
      startUrl: startUrl,
      includePassword: includePassword,
      id: id,
      code: code
    });
    action.setCallback(this, function (response) {
      //alert("in response >> " + JSON.stringify(response));
      var state = response.getState();
      console.log("state : = " + JSON.stringify(response));
      if (state === "SUCCESS") {
        console.log("Successful");
        var rtnValue = response.getReturnValue();
        console.log("rtnValue >> " + JSON.stringify(response.getReturnValue()));
        for (var statusCode in rtnValue) {
          console.log("k = " + statusCode);
          console.log("v = " + rtnValue[statusCode]);
          var msg = rtnValue[statusCode];
        }
        console.log("statusCode = " + statusCode + " message = " + msg);
        if (statusCode === "-2") {
          component.set("v.errorMessage", msg);
          component.set(
            "v.confMsgClass",
            "slds-text-heading_medium slds-text-color_error"
          );
          component.set("v.showError", true);
        } else if (statusCode === "-1") {
          msg =
            "Oops! Something unexpected happened. Please contact your branch.";
          component.set("v.regStage", 2);
          component.set("v.confirmationMsg", msg);
          component.set(
            "v.confMsgClass",
            "slds-text-heading_medium slds-text-color_error"
          );
        } else if (statusCode === "1") {
          msg =
            "Looks like you have previously created an account. Click below to login.\n\n" +
            "If you have forgotten your password please use the forgotten password option on the login page to reset\n";
          component.set("v.regStage", 2);
          component.set("v.confirmationMsg", msg);
          component.set(
            "v.confMsgClass",
            "slds-text-heading_medium page-message"
          );
        } else if (statusCode === "0") {
          msg =
            "Verification complete!\n\nWe are now taking you to your portal to start your registration…\n";
          component.set("v.errorMessage", msg);
          component.set(
            "v.confMsgClass",
            "slds-text-heading_medium page-message"
          );
          component.set("v.showError", true);
          component.set("v.regStage", 99);
        } else {
          component.set("v.regStage", 2);
          component.set("v.confirmationMsg", msg);
          component.set("v.confMsgClass", "slds-text-heading_medium");
          console.log("in else");
        }
      } else if (state === "ERROR") {
        console.log("Error msg" + JSON.stringify(response.getError()));
        component.set("v.regStage", 2);
        component.set("v.confirmationMsg", response.getError());
        component.set("v.confirmation", true);
        component.set(
          "v.confMsgClass",
          "slds-text-heading_medium slds-text-color_error"
        );
      }
      console.log("post state : = " + JSON.stringify(response));
      this.toggleSpinner(component, event);
    });
    $A.enqueueAction(action);
  },

  //jyothi.start
  verifyQuestion: function (component, event) {
    var que1 = component.find("que1");
    var que2 = component.find("que2");

    que1.showHelpMessageIfInvalid();
    que2.showHelpMessageIfInvalid();

    var valueUkROI = component.get("v.valueUkROI");
    var valueWorkInUk = component.get("v.valueWorkInUk");

    var isVerify = true;
    if (valueUkROI == undefined || valueUkROI == null) {
      que1.showHelpMessageIfInvalid();
      isVerify = false;
    }
    if (valueWorkInUk == undefined || valueWorkInUk == null) {
      que2.showHelpMessageIfInvalid();
      isVerify = false;
    }
    return isVerify;
  },
  //jyothi.stop
  verifyPassword: function (component, event) {
    var exp = component.get("v.password");
    var actual = component.get("v.confirmPassword");
    var cpw = component.find("cpw");
    if (actual === undefined) {
      cpw.setCustomValidity("Confirm Password!");
      cpw.showHelpMessageIfInvalid();
    } else if (actual !== exp) {
      cpw.setCustomValidity("Password does not match!");
      cpw.showHelpMessageIfInvalid();
      return false;
    } else {
      cpw.setCustomValidity("");
      cpw.showHelpMessageIfInvalid();
      return true;
    }
  },

  getExtraFields: function (component, event) {
    var action = component.get("c.getExtraFields");
    action.setParam(
      "extraFieldsFieldSet",
      component.get("v.extraFieldsFieldSet")
    );
    action.setCallback(this, function (a) {
      var rtnValue = a.getReturnValue();
      if (rtnValue !== null) {
        component.set("v.extraFields", rtnValue);
      }
    });
    $A.enqueueAction(action);
  },

  getUrlParameter: function (sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
      sURLVariables = sPageURL.split("&"),
      sParameterName,
      i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split("=");

      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
      }
    }
    return undefined;
  },

  getCandidate: function (component) {
    var action = component.get("c.getCandidateFromId");
    action.setParam("id", component.get("v.candidateId"));
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var rtnValue = a.getReturnValue();
        if (rtnValue !== null) {
          component.set("v.candidateRecord", rtnValue);

          //Set email with candidate email
          component.set("v.email", rtnValue.Email);
        }
      } else if (state === "ERROR") {
        console.error(a.getError());
      }
    });
    $A.enqueueAction(action);
  }
});
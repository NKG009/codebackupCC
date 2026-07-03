import { LightningElement, api } from "lwc";

import forgottenPassword from "@salesforce/apex/LoginController.resetPasswordMethod";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

export default class PortalV2ForgotPassword extends LightningElement {
  @api
  emailLabel;

  successMessage = "Password reset email sent successfully.";

  email;
  successText;
  emailError;
  generalError;

  headerLogo = SITE_ASSETS + "/img/logo/logoPrimary.svg";

  emailChange(event) {
    const value = event.target.value;

    this.email = value;
  }

  async submit() {
    try {
      this.emailError = "";
      this.generalError = "";
      this.setHidden("email-error", true);
      this.setHidden("general-error", true);
      this.setHidden("general-success", true);

      if (this.validateInput()) {
        const response = await forgottenPassword({ userName: this.email });
        console.log(response);
        //success
        if (response === "Reset") {
          this.successText = this.successMessage;
          this.setHidden("general-success", false);
        }
        //error
        else {
          this.generalError =
            "Your username could not be found. Please ensure that your username is correct.";
          this.setHidden("general-error", false);
        }
      }
    } catch (e) {
      console.error(e);
    }
  }

  validateInput() {
    let hasError = false;
    //Email empty check
    if (!this.email) {
      this.emailError = this.emailErrorMessage;
      this.setHidden("email-error", false);
      hasError = true;
    }

    return !hasError;
  }

  setHidden(roleIdentifier, hide) {
    const element = this.template.querySelector(`[role=${roleIdentifier}]`);

    const isHidden = element.classList.contains("hidden");
    if (isHidden && !hide) {
      element.classList.remove("hidden");
    } else if (!isHidden && hide) {
      element.classList.add("hidden");
    }
  }
}
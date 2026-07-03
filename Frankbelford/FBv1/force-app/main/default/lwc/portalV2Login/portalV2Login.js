import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

import login from "@salesforce/apex/LoginController.checkPortal";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

export default class PortalV2Login extends NavigationMixin(LightningElement) {
  @api
  emailLabel;
  @api
  passwordLabel;
  @api
  homePageName;
  @api
  emailErrorMessage = "Please enter your email address.";
  @api
  passwordErrorMessage = "Please enter your password.";
  @api
  emailAndPasswordDontMatchMessage =
    "Your login attempt has failed. Make sure the username and password are correct.";

  email;
  password;
  emailError;
  passwordError;
  generalError;

  baLogoSmall = SITE_ASSETS + "/img/icons/ba-logo-small.png";
  facebookLogo = SITE_ASSETS + "/img/icons/facebook-logo.svg";
  headerLogo = SITE_ASSETS + "/img/logo/logoPrimary.svg";
  linkedInLogo = SITE_ASSETS + "/img/icons/linkedin-logo.svg";
  twitterLogo = SITE_ASSETS + "/img/icons/twitter-logo.svg";
  youtubeLogo = SITE_ASSETS + "/img/icons/youtube-logo.svg";

  emailChange(event) {
    const value = event.target.value;

    this.email = value;
  }
  passwordChange(event) {
    const value = event.target.value;

    this.password = value;
  }

  async loginClick() {
    try {
      this.emailError = "";
      this.passwordError = "";
      this.generalError = "";

      this.setHidden("email-error", true);
      this.setHidden("password-error", true);
      this.setHidden("general-error", true);

      if (this.validateInput()) {
        const redirectURL = await login({
          username: this.email,
          password: this.password
        });

        if (
          redirectURL === "login error" ||
          redirectURL ===
            "Your login attempt has failed. Make sure the username and password are correct."
        ) {
          this.generalError = this.emailAndPasswordDontMatchMessage;
          this.setHidden("general-error", false);
        } else if (!redirectURL.includes("error")) {
          window.location.replace(redirectURL);
        } else {
          this.generalError =
            "An unexpected error has occurred. Please try again later. ";
        }
      }
    } catch (e) {
      console.error(e);
    }
  }

  forgottenPasswordClick() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: "Forgot_Password"
      }
    });
  }

  validateInput() {
    let hasError = false;
    //Email empty check
    if (!this.email) {
      this.emailError = this.emailErrorMessage;
      this.setHidden("email-error", false);
      hasError = true;
    }

    //Password empty check
    if (!this.password) {
      this.passwordError = this.passwordErrorMessage;
      this.setHidden("password-error", false);
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
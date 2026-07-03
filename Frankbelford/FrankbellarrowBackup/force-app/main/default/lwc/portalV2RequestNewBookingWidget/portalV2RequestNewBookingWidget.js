import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

export default class PortalV2RequestNewBookingWidget extends NavigationMixin(
  LightningElement
) {
  @api
  navigationPageName;
  cardImage = SITE_ASSETS + "/img/dashboard/requestBG.jpg";

  renderedCallback() {
    this.initCSSVariables();
  }

  initCSSVariables() {
    var css = document.body.style;
    css.setProperty("--cardImage", `url(${this.cardImage})`);
  }

  navigate() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: this.navigationPageName
      }
    });
  }
}
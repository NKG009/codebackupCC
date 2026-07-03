import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import FORM_FACTOR from "@salesforce/client/formFactor";

import { fetchLoggedInUserSites, getCookie } from "c/portalV2Utility";
import { registerListener } from "c/pubsub";

export default class PortalV2SiteOnHoldBanner extends LightningElement {
  @api
  singleSiteOnHoldMessage =
    "{0} currently has a credit status of 'on hold'. Please contact your Blue Arrow consultant to resolve this issue.";
  @api
  allSitesSelectedOnHoldMessage =
    "More than one of your assigned sites currently have a credit status of 'on hold'. Please contact your Blue Arrow consultant to resolve this issue.";
  @api
  selectedSiteOnHoldMessage =
    "Your currently selected site has a credit status of 'on hold'. Please contact your Blue Arrow consultant to resolve this issue.";

  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }
  currentlySelectedSite;
  availableSites = [];

  async connectedCallback() {
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    this.availableSites = await fetchLoggedInUserSites();
    this.currentlySelectedSite = getCookie("siteSelectedByUser");
  }

  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.currentlySelectedSite = eventPayload;
    }
  }

  get message() {
    const selectedSite = this.availableSites.find(
      (site) => `["${site.value}"]` === this.currentlySelectedSite
    );
    if (this.currentlySelectedSite.includes(",")) {
      return this.allSitesSelectedOnHoldMessage;
    } else if (selectedSite.creditStatus === "Credit on Hold") {
      return this.selectedSiteOnHoldMessage;
    }
    const formattedMessage = this.singleSiteOnHoldMessage.replace(
      "{0}",
      selectedSite.label
    );
    return formattedMessage;
  }

  get display() {
    return (
      this.availableSites.filter(
        (item) => item.creditStatus === "Credit on Hold"
      ).length > 0 && FORM_FACTOR !== "Small"
    );
  }
}
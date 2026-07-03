import { api, wire, LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { CurrentPageReference } from "lightning/navigation";
import getPreferredCounts from "@salesforce/apex/PreferredWorkersController.getPreferredCounts";
import { registerListener } from "c/pubsub";

export default class PortalV2MyPreferredWorkers extends NavigationMixin(
  LightningElement
) {
  error;
  preferredWorker = 0;
  activeWorker = 0;
  loading = true;
  //siteId = 'All';
  @wire(CurrentPageReference) pageRef;

  actualSiteId;

  @api get siteId() {
    return this.actualSiteId;
  }

  set siteId(value) {
    this.actualSiteId = value;
  }

  connectedCallback() {
    if (this.siteId === undefined) {
      this.actualSiteId = "All";
    }
    this.getPreferredData();
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
  }
  handleSiteChangeEvent(eventPayload) {
    if (eventPayload) {
      let siteList = JSON.parse(eventPayload);
      this.actualSiteId = (siteList + "").indexOf(",") > -1 ? "All" : siteList;
    }
    this.getPreferredData();
  }
  async getPreferredData() {
    try {
      this.loading = true;
      console.log("##@@this.siteId:" + this.siteId);
      const result = await getPreferredCounts({
        siteId: JSON.stringify(this.siteId)
      });
      if (result) {
        this.preferredWorker = result.preferredCount;
        this.activeWorker = result.activeCount;
      }
      this.loading = false;
    } catch (error) {
      console.log("fetch data error: ", error);
      this.error = error;
      this.loading = false;
    }
  }

  get activeWorkerClass() {
    return "fulfilment filled stacked-grid";
  }

  navigate() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: "My_Preferred_Workers__c"
      }
    });
  }
}
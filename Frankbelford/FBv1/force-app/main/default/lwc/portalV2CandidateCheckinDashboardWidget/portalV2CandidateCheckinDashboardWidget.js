import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";
import { registerListener } from "c/pubsub";
import { createErrorLog } from "c/portalV2Utility";

import getShifts from "@salesforce/apex/portalV2CandidateCheckInController.getShiftsForSite";

import Id from "@salesforce/user/Id";
export default class PortalV2CandidateCheckinDashboardWidget extends NavigationMixin(
  LightningElement
) {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }
  @api
  siteId;
  @api
  navigationPageName;
  error;
  loading = true;
  localSiteId;
  numCheckedIn;
  numNotCheckedIn;

  async connectedCallback() {
    this.localSiteId = this.siteId;
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    await this.getShifts();
    this.loading = false;
  }

  async getShifts() {
    try {
      const retrievedShifts = await getShifts({
        siteIds: this.localSiteId
      });

      this.numCheckedIn = retrievedShifts.filter((shift) => {
        return shift.sirenum__Actual_Start_Time__c !== undefined;
      }).length;
      this.numNotCheckedIn = retrievedShifts.filter((shift) => {
        return shift.sirenum__Actual_Start_Time__c === undefined;
      }).length;
    } catch (error) {
      console.log(error);
      createErrorLog(Id, error, undefined);
      this.error = error;
    }
  }

  navigate() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: this.navigationPageName
      }
    });
  }

  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.localSiteId = eventPayload;
    }

    this.refreshData();
  }

  async refreshData() {
    this.loading = true;
    await this.getShifts();
    this.loading = false;
  }
}
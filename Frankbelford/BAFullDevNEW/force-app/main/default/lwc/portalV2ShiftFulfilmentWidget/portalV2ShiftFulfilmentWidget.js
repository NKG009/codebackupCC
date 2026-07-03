import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";
import { registerListener } from "c/pubsub";
import { createErrorLog } from "c/portalV2Utility";

import getShifts from "@salesforce/apex/ShiftPageApexController.getShiftsByUserAccount";

import Id from "@salesforce/user/Id";
export default class PortalV2ShiftFulfilmentWidget extends NavigationMixin(
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
  fulfilment;
  numShifts;
  fulfilmentClass;
  loading = true;
  localSiteId;

  async connectedCallback() {
    console.log('====>>>shiftfulfillemtn widegt ->>navigationPageName>>'+this.navigationPageName);
    this.localSiteId = this.siteId;
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    await this.getFulfilment();
    this.loading = false;
  }

  async getFulfilment() {
    try {
      const retrievedShifts = await getShifts({
        contactId: null,
        siteId: this.localSiteId
      });

      let totalRequested = 0;
      let numFilled = 0;
      retrievedShifts.forEach((shift) => {
        totalRequested += shift.sirenum__Broadcasts__c
          ? shift.sirenum__Broadcasts__c
          : 1;
        numFilled += shift.sirenum__Broadcasts__c
          ? shift.sirenum__Broadcasts__c - shift.Remaining_Shifts__c
          : shift.sirenum__Contact__r
          ? 1
          : 0;
      });
      this.numShifts = totalRequested;
      this.fulfilment = numFilled;
      switch (this.fulfilment) {
        case 0:
          this.fulfilmentClass = "fulfilment unfilled stacked-grid";
          break;
        case this.numShifts:
          this.fulfilmentClass = "fulfilment filled stacked-grid";
          break;
        default:
          this.fulfilmentClass = "fulfilment partial__fill stacked-grid";
          break;
      }
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
    await this.getFulfilment();
    this.loading = false;
  }
}
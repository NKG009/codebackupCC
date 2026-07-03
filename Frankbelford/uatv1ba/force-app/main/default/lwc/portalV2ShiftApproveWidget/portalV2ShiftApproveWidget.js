import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";
import getAllShiftRecords from "@salesforce/apex/PortalV2TimesheetsController.getAllShiftRecords";
import getAllShifts from "@salesforce/apex/ShiftApprovalTile.getAllShiftsFromSiteList";

import { registerListener } from "c/pubsub";
import { showMessageToUser } from "c/portalV2Utility";

export default class PortalV2ShiftApproveWidget extends NavigationMixin(
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
  @api
  hideNavButton = false;
  @api
  overrideStyle = "";
  error;
  shiftsToApprove;
  loading = true;

  localSiteId;

  connectedCallback() {
    this.localSiteId = this.siteId;
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    this.refreshData();
  }

  async shiftsToBeApproved() {
    try {
      return getAllShifts({
        site: this.localSiteId,
        contact: null,
        startDate: null,
        endDate: null
      });
    } catch (error) {
      console.log("Fetch Timesheet Records Error: ", error);
      this.error = error;
      return [];
    }
  }

  async refreshData() {
    this.loading = true;
    const searchResult = await this.getShiftRecords(); //await this.shiftsToBeApproved();

    this.shiftsToApprove = this.numberOfRecordsToApprove(searchResult);
    console.log(searchResult);
    this.loading = false;
  }

  numberOfRecordsToApprove(searchResult) {
    //filter start date
    let searchResultFiltered = searchResult.filter((row) => {
      //start of the date of the start date, end of the date of the end date
      const today = new Date();
      const twoWeeksAgo = new Date();
      twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
      const filterStart = new Date(
        `${twoWeeksAgo.getFullYear()}-${
          twoWeeksAgo.getMonth() + 1
        }-${twoWeeksAgo.getDate()}`
      ).setHours(23, 59, 59, 999);
      const filterEnd = new Date(
        `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`
      ).setHours(0, 0, 0, 0);
      const colValue = new Date(row.sirenum__Scheduled_Start_Time__c);
      return colValue >= filterStart && colValue <= filterEnd;
    });
    //then filter end date
    searchResultFiltered = searchResultFiltered.filter((row) => {
      //start of the date of the start date, end of the date of the end date
      const today = new Date();
      const twoWeeksAgo = new Date();
      twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
      const filterStart = new Date(
        `${twoWeeksAgo.getFullYear()}-${
          twoWeeksAgo.getMonth() + 1
        }-${twoWeeksAgo.getDate()}`
      ).setHours(23, 59, 59, 999);
      const filterEnd = new Date(
        `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`
      ).setHours(0, 0, 0, 0);
      const colValue = new Date(row.sirenum__Scheduled_End_Time__c);
      return colValue >= filterStart && colValue <= filterEnd;
    });

    //lastly filter status
    searchResultFiltered = searchResultFiltered.filter((row) => {
      return (
        row.IP_Status__c === "Not yet submitted" ||
        row.IP_Status__c === "Awaiting approval"
      );
    });
    return searchResultFiltered.length;
  }
  async getShiftRecords() {
    try {
      const results = await getAllShiftRecords({
        siteIds: this.localSiteId,
        shiftsToBeApproved: true
      });
      return results;
    } catch (error) {
      showMessageToUser(
        "error",
        "An internal error occurred while fetching shift records. Please contact System Administrator.",
        this
      );

      console.error("Fetch Shift Records Error: ", error);
    }
    return null;
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
}
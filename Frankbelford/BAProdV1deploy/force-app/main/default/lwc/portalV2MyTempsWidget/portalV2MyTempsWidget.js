import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";

import { registerListener } from "c/pubsub";

import getShifts from "@salesforce/apex/ShiftPageApexController.getShiftsByUserAccount";
export default class PortalV2MyTempsWidget extends NavigationMixin(
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
  siteId; //used only as an initialiser variable
  @api
  navigationPageName;
  shiftData;
  loading = true;

  columns = [
    { label: "Name", fieldName: "Name" },
    { label: "Job Role", fieldName: "jobRole" },
    { label: "Upcoming Shifts", fieldName: "Shifts" }
  ];

  localSiteId;

  connectedCallback() {
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    if (!this.siteId) return;
    this.localSiteId = this.siteId;

    this.refreshData();
  }

  async getShifts() {
    const shifts = await getShifts({
      contactId: null,
      siteId: this.localSiteId
    });
    return shifts;
  }

  flattenShifts(shifts) {
    //First we make a map to group shifts by contact
    const contactToShiftMap = {};
    const shiftData = [];

    //filter out any unfilled shifts
    const filledShifts = shifts.filter(
      (shift) => shift.sirenum__Contact__c || shift.sirenum__Shifts__r
    );

    filledShifts.forEach((shift) => {
      if (shift.sirenum__Contact__c) {
        this.processShift(shift, contactToShiftMap);
      } else if (shift.sirenum__Shifts__r) {
        shift.sirenum__Shifts__r.forEach((childShift) => {
          this.processShift(childShift, contactToShiftMap);
        });
      }
    });

    Object.keys(contactToShiftMap).forEach((contactId) => {
      const contact = contactToShiftMap[contactId].ContactName;
      Object.keys(contactToShiftMap[contactId]).forEach((jobRole) => {
        if (jobRole !== "ContactName") {
          const contactShifts = contactToShiftMap[contactId][jobRole];

          shiftData.push({
            Id: contactId,
            Name: contact,
            jobRole: jobRole,
            Shifts: contactShifts.length
          });
        }
      });
    });
    return shiftData;
  }

  processShift(shift, contactToShiftMap) {
    const jobTypeName = shift.sirenum__Team__r.sirenum__Job_Type__r.Name ?? "";

    if (!contactToShiftMap[shift.sirenum__Contact__c]) {
      contactToShiftMap[shift.sirenum__Contact__c] = [];
    }
    if (!contactToShiftMap[shift.sirenum__Contact__c][jobTypeName]) {
      contactToShiftMap[shift.sirenum__Contact__c][jobTypeName] = [];
    }
    contactToShiftMap[shift.sirenum__Contact__c][jobTypeName].push(shift);
    contactToShiftMap[shift.sirenum__Contact__c].ContactName =
      shift.sirenum__Contact__r.Name;
  }

  async refreshData() {
    try {
      const shifts = await this.getShifts();
      this.shiftData = this.flattenShifts(shifts);
      this.loading = false;
    } catch (error) {
      console.error(error);
      this.loading = false;
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
}
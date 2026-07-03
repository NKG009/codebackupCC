import { LightningElement, wire, api, track } from "lwc";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { CurrentPageReference } from "lightning/navigation";
import {
  deleteRecord,
  createRecord,
  updateRecord
} from "lightning/uiRecordApi";

import getSitesOfLoggedInUser from "@salesforce/apex/SiteManagementComponentController.getSitesOfLoggedInUser";
import getAllShiftRecords from "@salesforce/apex/PortalV2TimesheetsController.getAllShiftRecords";
import fetchAdjustableColumns from "@salesforce/apex/PortalV2TimesheetsController.fetchAdjustableColumns";
import updateIndividualPO from "@salesforce/apex/PortalV2TimesheetsController.updateIndividualPO";
import approveRejectTimesheets from "@salesforce/apex/TimeSheetInfoWithPagination.approveRejectTimesheetsWithRejectReason";
import getShiftBreaks from "@salesforce/apex/PortalV2DashboardController.getShiftBreaks";
import getShiftBreakStartTime from "@salesforce/apex/PortalV2DashboardController.getShiftBreakStartTime";
import updateShiftBreak from "@salesforce/apex/PortalV2DashboardController.updateShiftBreak";

import BREAK_OBJECT from "@salesforce/schema/sirenum__Shift_Break__c";
import BREAK_START_TIME_FIELD from "@salesforce/schema/sirenum__Shift_Break__c.sirenum__Start_Time__c";
import BREAK_END_TIME_FIELD from "@salesforce/schema/sirenum__Shift_Break__c.sirenum__End_Time__c";
import BREAK_PAID_BREAK_FIELD from "@salesforce/schema/sirenum__Shift_Break__c.sirenum__Paid_Break__c";
import BREAK_LINKED_SHIFT_FIELD from "@salesforce/schema/sirenum__Shift_Break__c.sirenum__Shift__c";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import {
  setCookie,
  getCookie,
  showMessageToUser,
  addHours
} from "c/portalV2Utility";
import { fireEvent } from "c/pubsub";
import { getLookupReferenceData } from "c/portalV2MyShiftsUtility";
import { addDays } from "c/dateUtility";
export default class PortalV2MobileShiftApproval extends LightningElement {
  @api
  shiftToBeApprovedValue = "Awaiting approval";

  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  blueArrowLogo = SITE_ASSETS + "/img/logo/logoPrimary.svg";

  widgetOverrideStyle = "height:15em; width:100%;";
  siteSelectedByUser;
  loggedInUserSites;
  isPicklistDisabled = false;

  adjustableColumnConfiguration = [];
  shiftRecords = [];
  currentShift;
  currentshiftId;
  rejectionReason = "";
  currentShiftBreakStartTime;
  showEditBreaksModal = false;
  showRejectModal = false;
  startTime;
  endTime;
  poNumber;
  loading = false;

  @track
  breaksModalData = [];
  initialBreaksModalData;

  //Form factor must be mobile in order to display this view
  get displayComponent() {
    return FORM_FACTOR === "Small";
  }

  async connectedCallback() {
    if (!this.displayComponent) return;

    await this.queryAdjustableColumns();
    await this.fetchLoggedInUserSites();
    await this.getShiftRecords();
    this.startTime = this.actualEndTime;
    this.endTime = this.actualEndTime;
    this.poNumber = this.actualPO;
  }

  /*
  Site picklist functionality
*/
  async fetchLoggedInUserSites() {
    let siteToSetAsDefault;
    try {
      const result = await getSitesOfLoggedInUser();

      const sites = [...result];

      if (result.length === 1) {
        result[0].Id = `"${result[0].Id}"`;
        siteToSetAsDefault = result[0];
      } else if (result.length > 1) {
        sites.forEach((site) => {
          site.Id = `"${site.Id}"`;
        });

        const siteIds = sites.map((site) => site.Id);
        const allSites = siteIds.join(",");
        sites.unshift({ Id: allSites, Name: "All Sites" });
        siteToSetAsDefault = sites[0];
      }
      this.initLoggedInUserSiteOptions(sites);
      this.isPicklistDisabled = false;
      console.log("Logged In User Sites: ", result);

      const siteSelectedCookie = getCookie("siteSelectedByUser");
      let cookieInSiteList = true;
      let cookieValid = true;
      try {
        cookieInSiteList =
          sites.filter((site) => site === JSON.parse(siteSelectedCookie)) !==
          [];
      } catch (e) {
        cookieValid = false;
      }
      if (siteSelectedCookie && cookieValid) {
        if (!cookieInSiteList) {
          this.setSiteAsDefault(siteSelectedCookie, true);
        } else {
          this.setSiteAsDefault(`[${siteToSetAsDefault.Id}]`);
        }
      } else if (siteToSetAsDefault && !cookieValid) {
        this.setSiteAsDefault(`[${siteToSetAsDefault.Id}]`);
      } else {
        this.isPicklistDisabled = true;
      }
    } catch (error) {
      this.isPicklistDisabled = true;
      showMessageToUser(
        "error",
        "An internal error occurred while fetching logged-in user sites.",
        this
      );

      console.log("Logged In User Sites Error As Object: ", error);
      console.log(
        "Logged In User Sites Error As String: ",
        JSON.stringify(error)
      );
    }
  }

  initLoggedInUserSiteOptions(sites) {
    //init logged in user sites
    this.loggedInUserSites = [];

    sites.forEach((site) => {
      this.loggedInUserSites.push({
        value: `[${site.Id}]`,
        label: site.Name
      });
    });
  }

  setSiteAsDefault(defaultSite) {
    this.siteSelectedByUser = defaultSite.replace(/\/g/, "");

    setCookie("siteSelectedByUser", this.siteSelectedByUser, 365);
    this.firePageChangeEvent();
  }

  selectionChangeHandler(event) {
    if (event.target.value) {
      this.siteSelectedByUser = event.target.value;

      console.log(this.siteSelectedByUser);
      setCookie("siteSelectedByUser", this.siteSelectedByUser, 365);
      this.firePageChangeEvent();
      console.log("Site Selected By User: ", this.siteSelectedByUser);
      this.getShiftRecords();
    }
  }
  firePageChangeEvent() {
    fireEvent(this.pageRef, "siteChangeEvent", this.siteSelectedByUser);
  }

  /*
    Get shifts
  */
  async getShiftRecords() {
    try {
      this.shiftRecords = [];
      this.currentShift = undefined;
      const results = await getAllShiftRecords({
        siteIds: this.siteSelectedByUser
      });
      if (results.length > 0) {
        this.parseShiftRecords(results);
      } else {
        this.theTableMessage = "No shift records found.";
      }
    } catch (error) {
      showMessageToUser(
        "error",
        "An internal error occurred while fetching shift records. Please contact System Administrator.",
        this
      );

      console.error("Fetch Shift Records Error: ", error);
    }
  }

  async queryAdjustableColumns() {
    const result = await fetchAdjustableColumns();

    //order the results by the mobile display order
    const orderedResults = result.sort((a, b) => {
      if (a.Mobile_Column_Order__c > b.Mobile_Column_Order__c) {
        return 1;
      } else if (a.Mobile_Column_Order__c < b.Mobile_Column_Order__c) {
        return -1;
      }
      return 0;
    });
    const filteredResults = orderedResults.filter(
      (column) => column.Display_In_Mobile__c
    );

    filteredResults.forEach((column) => {
      this.adjustableColumnConfiguration.push({
        columnName: column.MasterLabel,
        fieldAPIName: column.Field_API_Name__c,
        type: column.Field_Display_Type__c
      });
    });
  }

  async parseShiftRecords(results) {
    this.shiftRecords = [];
    results.forEach((result) => {
      let shift = {};
      let columns = [];
      if (this.shiftToBeApproved(result)) {
        this.adjustableColumnConfiguration.forEach((column) => {
          let value = result[column.fieldAPIName];

          if (column.fieldAPIName.includes("__r")) {
            value = getLookupReferenceData(result, column.fieldAPIName);
          }
          columns.push({
            label: column.columnName,
            value: value,
            isText: column.type === "Text",
            isDate: column.type === "Date",
            isTime: column.type === "Time",
            isNumber: column.type === "Number"
          });
        });
        shift.columns = columns;
        shift.id = result.Id;
        this.shiftRecords.push(shift);
      }
    });
    if (this.shiftRecords.length > 0) {
      //always default the current to the first shift in the list
      this.currentShift = this.shiftRecords[0].columns;
      this.currentShiftId = this.shiftRecords[0].id;
      console.log(this.currentShift);
      //initialize the current shift's break start time
      this.currentShiftBreakStartTime = await getShiftBreakStartTime({
        shiftId: this.currentShiftId
      });
    }
  }

  shiftToBeApproved(shift) {
    const twoWeeksAgo = new Date();
    twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
    const today = new Date();
    const statusMatch =
      shift.IP_Status__c === "Not yet submitted" ||
      shift.IP_Status__c === "Awaiting approval";
    const startDateMatch =
      new Date(shift.sirenum__Scheduled_Start_Time__c) >=
      new Date(
        `${twoWeeksAgo.getFullYear()}-${
          twoWeeksAgo.getMonth() + 1
        }-${twoWeeksAgo.getDate()}`
      ).setHours(0, 0, 0, 0);
    const endDateMatch =
      new Date(shift.sirenum__Scheduled_End_Time__c) <=
      new Date(
        `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`
      );

    return statusMatch && startDateMatch && endDateMatch;
  }

  async approveRejectShiftsForSelectedTimesheets(timesheetIds, state) {
    try {
      const result = await approveRejectTimesheets({
        shiftIds: timesheetIds,
        theState: state,
        rejectReason: this.rejectionReason
      });
      if (result === "success") {
        showMessageToUser(
          "success",
          "Successfully " +
            (state === "approve" ? "approved" : "rejected") +
            " the shift.",
          this
        );
        this.popCurrentShift();
        this.showRejectModal = false;
      } else if (result === "none") {
        showMessageToUser(
          "error",
          `An error occurred while ${
            state === "approve" ? "approving" : "rejecting"
          } the shift.`,
          this
        );
      } else {
        showMessageToUser(
          "error",
          "An internal error occurred while trying to " +
            state +
            " shifts. Please contact System Administrator.",
          this
        );
      }
    } catch (error) {
      showMessageToUser(
        "error",
        "An internal error occurred while trying to " +
          state +
          " shifts. Please contact System Administrator.",
        this
      );
      console.log("Timesheet Approve/Reject Process Error: ", error);
    }
  }

  approveSelectedTimesheets() {
    let timesheetIds = [this.currentShiftId];
    this.approveRejectShiftsForSelectedTimesheets(timesheetIds, "approve");
  }

  rejectSelectedTimesheets() {
    let timesheetIds = [this.currentShiftId];
    this.approveRejectShiftsForSelectedTimesheets(timesheetIds, "reject");
  }

  async popCurrentShift() {
    this.shiftRecords.shift();
    if (this.shiftRecords.length > 0) {
      this.currentShiftId = this.shiftRecords[0].id;
      this.currentShift = this.shiftRecords[0].columns;
      this.currentShiftBreakStartTime = await getShiftBreakStartTime({
        shiftId: this.currentShiftId
      });
    } else {
      this.currentShiftId = undefined;
      this.currentShift = undefined;
      this.currentShiftBreakStartTime = undefined;
    }
  }

  /* Breaks*/
  async openBreakModal() {
    this.showEditBreaksModal = true;

    this.breaksModalData = await getShiftBreaks({
      shiftId: this.currentShiftId
    });
    this.initialBreaksModalData = JSON.parse(
      JSON.stringify(this.breaksModalData)
    );
    console.log("Breaks: ", JSON.parse(JSON.stringify(this.breaksModalData)));
  }

  handleBreakModalClose() {
    this.breaksModalData = [];
    this.showEditBreaksModal = [];
    this.showEditBreaksModal = false;
  }

  handleRejectionReasonChange(event) {
    const value = event.target.value;
    this.rejectionReason = value;
  }

  toggleRejectModal() {
    this.showRejectModal = !this.showRejectModal;
  }

  addBreakRow() {
    this.breaksModalData.push({
      Id: `${Math.floor(
        Math.random() * (1 - Number.MAX_SAFE_INTEGER + 1) + 1
      )}`, //Generate a low quality UUID, as we are only using this for short term means, there should be a very low chance of a duplicate
      sirenum__Duration__c: 0,
      sirenum__Start_Time__c: this.currentShiftBreakStartTime,
      sirenum__End_Time__c: this.currentShiftBreakStartTime
    });
  }

  deleteBreakRow(event) {
    const id = event.currentTarget.dataset.id;
    const newRows = this.breaksModalData.filter((row) => row.Id !== id);
    this.breaksModalData = newRows;
    console.log(this.breaksModalData);
  }

  onRowEdit(event) {
    const id = event.currentTarget.dataset.id;
    const value = parseFloat(event.currentTarget.value);
    let selectedRow = this.breaksModalData.find((row) => row.Id === id);
    const duration = isNaN(value) ? 0 : value;
    const endTime = addHours(selectedRow.sirenum__Start_Time__c, duration);

    selectedRow.sirenum__End_Time__c = endTime;
    selectedRow.sirenum__Duration__c = value;
  }

  onStartTimeChange(event) {
    this.startTime = event.currentTarget.value;
  }
  onEndTimeChange(event) {
    this.endTime = event.currentTarget.value;
  }
  onPOChanged(event) {
    this.poNumber = event.currentTarget.value;
  }

  async saveBreaks() {
    try {
      this.loading = true;
      const recordsWithDuration = this.breaksModalData.filter(
        (row) => row.sirenum__Duration__c > 0
      );
      //a4Z is the Id prefix for the sirenum__Shift_Break__c object
      //We can use this to differentiate between new records and existing ones
      const newRecords = recordsWithDuration.filter(
        (row) => !row.Id.startsWith("a4Z")
      );
      console.log("New Records: ", JSON.parse(JSON.stringify(newRecords)));
      const newRecordOutput = this.insertRecords(newRecords);
      const updateRecords = recordsWithDuration.filter((row) =>
        row.Id.startsWith("a4Z")
      );
      console.log(
        "Update Records: ",
        JSON.parse(JSON.stringify(updateRecords))
      );
      const updateRecordOutput = this.updateRecords(updateRecords);

      const breakIds = recordsWithDuration.map((row) => row.Id);
      const deleteRecords = this.initialBreaksModalData.filter((row) => {
        return !breakIds.includes(row.Id) && row.Id.startsWith("a4Z");
      });
      console.log(
        "Delete Records: ",
        JSON.parse(JSON.stringify(deleteRecords))
      );
      const deleteRecordOutput = this.deleteRecords(deleteRecords);

      const promises = [
        ...newRecordOutput,
        ...updateRecordOutput,
        ...deleteRecordOutput
      ];

      const results = await Promise.all(promises);
      console.log(results);
      console.log("Success");
      this.loading = false;
      this.handleBreakModalClose();
      showMessageToUser(
        "success",
        "Success! Your break updates have been saved successfully.",
        this
      );
    } catch (error) {
      console.error("Rejected", error);
      this.loading = false;
      showMessageToUser(
        "error",
        "An internal error occurred while trying to save break updates. Please contact System Administrator.",
        this
      );
    }
  }

  async updateActualShiftHours() {
    let startDateTime = new Date(
      this.currentShift.find(
        (shift) => shift.label === "Scheduled Start Time"
      ).value
    );
    const startTimeSplit = this.startTime.split(":");
    startDateTime.setHours(startTimeSplit[0]);
    startDateTime.setMinutes(startTimeSplit[1]);

    let endDateTime = new Date(
      this.currentShift.find(
        (shift) => shift.label === "Scheduled End Time"
      ).value
    );

    const endTimeSplit = this.endTime.split(":");
    if (endDateTime.getHours() > endTimeSplit[0]) {
      endDateTime = addDays(endDateTime, 1);
    }
    endDateTime.setHours(endTimeSplit[0]);
    endDateTime.setMinutes(endTimeSplit[1]);

    if (endDateTime < startDateTime) {
      showMessageToUser(
        "error",
        "The actual end time cannot be before the actual start time.",
        this
      );
      return;
    }
    const fields = {
      Id: this.currentShiftId,
      sirenum__Actual_End_Time__c: endDateTime.toISOString(),
      sirenum__Actual_Start_Time__c: startDateTime.toISOString()
      // Invoice_PO_Optional__c: this.poNumber
    };

    const recordInput = {
      fields
    };
    try {
      this.loading = true;
      const result = await updateRecord(recordInput);
      await this.applyUpdateInvoicePO();
      console.log(result);
      this.loading = false;
      showMessageToUser(
        "success",
        "Shift actual hours successfully updated.",
        this
      );
      await this.getShiftRecords();
      this.handleBreakModalClose();
    } catch (e) {
      console.error(e);
      this.loading = false;
      showMessageToUser(
        "error",
        "An unexpected error has occured. Please try again.",
        this
      );
    }
  }

  insertRecords(records) {
    if (records.length === 0) return [];
    const promises = [];
    records.forEach((record) => {
      const fields = {};
      fields[BREAK_START_TIME_FIELD.fieldApiName] = new Date(
        record.sirenum__Start_Time__c.valueOf()
      );
      fields[BREAK_END_TIME_FIELD.fieldApiName] = record.sirenum__End_Time__c;
      fields[BREAK_PAID_BREAK_FIELD.fieldApiName] = false;
      fields[BREAK_LINKED_SHIFT_FIELD.fieldApiName] = this.currentShiftId;

      const recordInput = {
        apiName: BREAK_OBJECT.objectApiName,
        fields: fields
      };
      try {
        promises.push(createRecord(recordInput));
      } catch (error) {
        console.error(error);
        showMessageToUser(
          "error",
          "An internal error occurred while trying to save break updates. Please contact System Administrator.",
          this
        );
      }
    });
    return promises;
  }

  async applyUpdateInvoicePO() {
    let timesheetsToUpdate = [
      {
        sobjectType: "sirenum__Shift__c",
        Id: this.currentShiftId,
        Invoice_PO_Optional__c: this.poNumber
      }
    ];

    const result = await updateIndividualPO({
      updatedPONumbers: timesheetsToUpdate
    });
    console.log(result);
  }

  updateRecords(records) {
    if (records.length === 0) return [];
    const promises = [];

    records.forEach((record) => {
      try {
        promises.push(
          updateShiftBreak({
            breakId: record.Id,
            newEndTime: record.sirenum__End_Time__c
          })
        );
      } catch (error) {
        console.error(error);
        showMessageToUser(
          "error",
          "An internal error occurred while trying to save break updates. Please contact System Administrator.",
          this
        );
      }
    });

    return promises;
  }

  deleteRecords(records) {
    if (records.length === 0) return [];

    const promises = [];
    records.forEach((record) => {
      try {
        promises.push(deleteRecord(record.Id));
      } catch (error) {
        console.error(JSON.parse(JSON.stringify(error)));
        showMessageToUser(
          "error",
          "An internal error occurred while trying to save break updates. Please contact System Administrator.",
          this
        );
      }
    });
    return promises;
  }

  get hasRecords() {
    return this.currentShift !== undefined;
  }
  get actualStartTime() {
    if (this.currentShift) {
      const startTime = this.currentShift.find(
        (column) => column.label === "Actual Start Time"
      ).value;
      try {
        return startTime.split("T")[1];
      } catch (e) {
        return "";
      }
    }
    return undefined;
  }
  get actualEndTime() {
    if (this.currentShift) {
      const endTime = this.currentShift.find(
        (column) => column.label === "Actual End Time"
      ).value;
      try {
        return endTime.split("T")[1];
      } catch (e) {
        return "";
      }
    }
    return undefined;
  }

  get actualPO() {
    if (this.currentShift) {
      const poNumber = this.currentShift.find(
        (column) => column.label === "PO"
      ).value;
      return poNumber;
    }
    return undefined;
  }
}
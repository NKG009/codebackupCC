import { LightningElement, wire, track } from "lwc";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";

import getAllShiftRecords from "@salesforce/apex/PortalV2HoursSubmission.getAllShiftRecords";
import fetchAdjustableColumns from "@salesforce/apex/PortalV2HoursSubmission.fetchAdjustableColumns";
import approveRejectShifts from "@salesforce/apex/PortalV2TimesheetsController.approveRejectShifts";
import amendOneBreakToAllShifts from "@salesforce/apex/PortalV2TimesheetsController.amendOneBreakToAllShifts";
import applyAmendedBreakToAllShifts from "@salesforce/apex/PortalV2TimesheetsController.applyAmendedBreakToAllShifts";
import applyAmendedShiftHoursToAllShifts from "@salesforce/apex/PortalV2HoursSubmission.applyAmendedShiftHoursToAllShifts";

import { getCookie, isViewOnlyUser, createErrorLog } from "c/portalV2Utility";
import { registerListener } from "c/pubsub";

import SendRejectionToOwner from "@salesforce/apex/PortalV2TimesheetsController.SendRejectionToOwner";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import defaultPageSize from "@salesforce/label/c.Portal_V2_Default_Page_Size";
import Portal_V2_SM_Columns_Config_Error from "@salesforce/label/c.Portal_V2_SM_Columns_Config_Error";
import Portal_V2_SM_Fetch_Shifts_Error from "@salesforce/label/c.Portal_V2_SM_Fetch_Shifts_Error";
import Portal_V2_SM_Updating_Shifts_Message from "@salesforce/label/c.Portal_V2_SM_Updating_Shifts_Message";
import Portal_V2_SM_Approve_Reject_Success from "@salesforce/label/c.Portal_V2_SM_Approve_Reject_Success";
import Portal_V2_SM_Approve_Reject_Error from "@salesforce/label/c.Portal_V2_SM_Approve_Reject_Error";
import Portal_V2_SM_Export_Shifts_Error from "@salesforce/label/c.Portal_V2_SM_Export_Shifts_Error";
import Portal_V2_SM_Fetching_Shifts_Message from "@salesforce/label/c.Portal_V2_SM_Fetching_Shifts_Message";
import Portal_V2_SM_No_Shifts_Error from "@salesforce/label/c.Portal_V2_SM_No_Shifts_Error";
import Portal_V2_SM_No_Shifts_Selected_Error from "@salesforce/label/c.Portal_V2_SM_No_Shifts_Selected_Error";
import Portal_V2_SM_Amend_Breaks_Success from "@salesforce/label/c.Portal_V2_SM_Amend_Breaks_Success";
import Portal_V2_SM_Amend_Breaks_Error from "@salesforce/label/c.Portal_V2_SM_Amend_Breaks_Error";
import Portal_V2_SM_No_Rejection_Reason_Error from "@salesforce/label/c.Portal_V2_SM_No_Rejection_Reason_Error";
import TIME_ZONE from "@salesforce/i18n/timeZone";
import LOCALE from "@salesforce/i18n/locale";
import Id from "@salesforce/user/Id";


import getSitesOfLoggedInUser from "@salesforce/apex/SiteManagementComponentController.getSitesOfLoggedInUser";

export default class PortalV2HourSubmission extends NavigationMixin(
  LightningElement
) {
  //#region Variables
  timeZone = TIME_ZONE;
  textFilterIcon = SITE_ASSETS + "/img/icons/filter-dk-grey.svg";
  dateFilterIcon = SITE_ASSETS + "/img/icons/calendar-dk-grey.svg";

  openAdjustColumnsModal = false;
  openAmendShiftHoursModal = false;
  openAmendPONumberModal = false;
  openAmendBreakModal = false;
  openRejectModal = false;
  openApproveModal = false;
  openEndorseApproveModal = false;
  openAmendPONumberModalNew = false;

  @track
  openAmendShiftHoursModalData = [];
  @track
  timeSheetsData = [];
  @track
  activeFilterTerms = [];
  @track
  filteredShifts = [];

  hasRecords = false;
  // totalRecords = 0;
  // totalColumns = 0;
  activePage = 1;
  allTimesheetRecords = [];
  columnsConfiguration = [];
  theTableMessage = Portal_V2_SM_Fetching_Shifts_Message;
  adjustColumnsHasSecondaryTable = false;
  mainTableColumnStatus = [];
  openTextFilterModal = false;
  openDateFilterModal = false;
  filterClickType = "";
  filterColumnLabel = "";
  filterTerms = [];
  columnsDataMap = new Map();
  disableButtons = true;
  openAmendPONumberModalLoading = false;
  openApproveModalLoading = false;
  openApproveModalUserMessage = "";
  openApproveModalData = [];
  openRejectModalLoading = false;
  openRejectModalUserMessage = "";
  openRejectModalData = [];
  selectedSiteIds = [];
  masterLabelAndItsFieldAPIName = new Map();
  openAmendBreakModalLoading = false;
  openAmendBreakModalData = [];
  openAmendShiftHoursModalLoading = false;

  readOnlyUser = false;

  reasonOptions = [
    { label: 'Hours worked', value: 'Hours worked', selected: false }
    /*{ label: 'Holiday', value: 'Holiday', selected: false },
    { label: 'Sickness', value: 'Sickness', selected: false }*/
    ];



  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }
  //#endregion

  //#region getters

  get poButtonDisabled() {
    return this.selectedShiftRecords.length === 0;
  }

  get buttonsDisabled() {
    const selectedShifts = this.selectedShiftRecords;

    return (
      selectedShifts.length === 0 ||
      selectedShifts.filter(
        (record) =>
          (record !== undefined &&
            record?.columns.find((column) => column.key === "IP_Status__c")
              .value === "Approved & awaiting processing") ||
          record?.columns.find((column) => column.key === "IP_Status__c")
            .value === "Processed" ||
          record?.columns.find((column) => column.key === "IP_Status__c")
            .value === "Modified & awaiting processing"
      ).length > 0
    );
  }

  get totalRecords() {
    return this.filteredShifts.length;
  }
  get showPagination() {
    return this.totalRecords > defaultPageSize;
  }

  get selectedDateFilter() {
    return this.activeFilterTerms.find(
      (term) => term.column === this.filterColumnLabel
    );
  }

  get selectedShiftRecords() {
    return this.filteredShifts.filter((shift) => shift.isChecked === true);
  }

  get totalHoursSelected() {
    const totalHours = this.selectedShiftRecords.reduce(
      (previousValue, currentValue) =>
        previousValue + currentValue.sirenum__Scheduled_Shift_Length_Decimal__c,
      0
    );
    const intPart = Math.floor(totalHours);
    const decPart = totalHours % 1;

    const minutes = Math.floor(decPart * 60);

    return `${intPart === 0 ? "00" : intPart < 10 ? "0" + intPart : intPart}:${minutes === 0 ? "00" : minutes < 10 ? "0" + minutes : minutes
      }`;
  }
  get totalChargeSelected() {
    const totalHours = this.selectedShiftRecords.reduce(
      (previousValue, currentValue) =>
        previousValue + currentValue.Actual_Hours_minus_break__c,
      0
    );
    const intPart = Math.floor(totalHours);
    const decPart = totalHours % 1;

    const minutes = Math.floor(decPart * 60);

    return `${intPart === 0 ? "00" : intPart < 10 ? "0" + intPart : intPart}:${minutes === 0 ? "00" : minutes < 10 ? "0" + minutes : minutes
      }`;
  }

  get viewShiftsToBeApprovedFilterValue() {
    const twoWeeksAgo = new Date();
    twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
    const today = new Date();

    return [
      {
        column: "Start Date",
        filterTerms: {
          endDate: `${today.getFullYear()}-${today.getMonth() + 1
            }-${today.getDate()}`,
          startDate: `${twoWeeksAgo.getFullYear()}-${twoWeeksAgo.getMonth() + 1
            }-${twoWeeksAgo.getDate()}`
        }
      },
      {
        column: "End Date",
        filterTerms: {
          endDate: `${today.getFullYear()}-${today.getMonth() + 1
            }-${today.getDate()}`,
          startDate: `${twoWeeksAgo.getFullYear()}-${twoWeeksAgo.getMonth() + 1
            }-${twoWeeksAgo.getDate()}`
        }
      },
      {
        column: "IP_Status__c",
        filterTerms: ["Not Approved / Not Processed"]
      }
    ];
  }

  get viewAllShiftsVariation() {
    if (this.activeFilterTerms.length === 0) return "brand";

    return "neutral";
  }

  get clearFiltersVariation() {
    if (this.activeFilterTerms.length === 0) return "neutral";

    return "brand";
  }

  get viewShiftsToBeApprovedVariation() {
    if (
      JSON.stringify(this.activeFilterTerms) ===
      JSON.stringify(this.viewShiftsToBeApprovedFilterValue)
    )
      return "brand";

    return "neutral";
  }

  get totalColumns() {
    return this.mainTableColumnStatus.filter((column) => {
      return column.selected;
    }).length;
  }

  get hasRecordsToDisplay() {
    return !(
      this.timeSheetsData === undefined || this.timeSheetsData.length === 0
    );
  }

  get currentFilterSelectedTerms() {
    return this.activeFilterTerms.find(
      (filter) => filter.column === this.filterClickType
    )?.filterTerms;
  }

  //#endregion

  //#region event handlers
  handleSiteChangeEvent(eventPayload) {
    console.log("Received Site Change Event: ", eventPayload);
    if (eventPayload) {
      this.selectedSiteIds = eventPayload;
    }

    this.activePage = 1;
    this.clearFilters();
    this.fetchTimesheetRecords();
  }
  //#endregion

  //#region utilities
  formatLocaleDateTime(theDateTimeString) {
    let theDatePart = theDateTimeString
      .substr(0, theDateTimeString.indexOf(", "))
      .split("/");
    let theTimePart = theDateTimeString.substr(
      theDateTimeString.indexOf(", ") + 2,
      theDateTimeString.length
    );
    return (
      theDatePart[2] +
      "-" +
      theDatePart[1] +
      "-" +
      theDatePart[0] +
      "T" +
      theTimePart +
      ".000Z"
    );
  }

  getLookupReferenceData(theRecord, theField) {
    const fieldInfo = theField.split(".");
    let lookupObject = fieldInfo[0];
    let lookupField = fieldInfo[1];
    return theRecord && theRecord[lookupObject]
      ? theRecord[lookupObject][lookupField]
      : "";
  }
  getStatusColorClass(columnName, columnValue) {
    let statusClass = "";
    if (columnValue && columnName === "Status") {
      if (
        columnValue == "Awaiting approval" ||
        columnValue == "Not yet submitted"
      ) {
        statusClass = "status_box status_awaiting_approval";
      } else if (
        columnValue == "Modified & awaiting processing" ||
        columnValue == "Approved & awaiting processing"
      ) {
        statusClass = "status_box status_approved_and_awaiting_processing";
      } else if (columnValue == "Processed") {
        statusClass = "status_box status_processed";
      }
    }
    return statusClass;
  }
  getStatusColorSubClass(columnName, columnValue) {
    let statusSubClass = "";
    if (columnValue && columnName === "Status") {
      if (
        columnValue == "Awaiting approval" ||
        columnValue == "Not yet submitted"
      ) {
        statusSubClass = "status_box status_awaiting_approval_sub_class";
      } else if (
        columnValue == "Modified & awaiting processing" ||
        columnValue == "Approved & awaiting processing"
      ) {
        statusSubClass =
          "status_box status_approved_and_awaiting_processing_sub_class";
      } else if (columnValue == "Processed") {
        statusSubClass = "status_box status_processed_sub_class";
      }
    }
    return statusSubClass;
  }
  secondsToHoursMinutesSeconds(timeInSeconds) {
    timeInSeconds = Number(timeInSeconds);
    var hours = Math.floor(timeInSeconds / 3600);
    var minutes = Math.floor((timeInSeconds % 3600) / 60);

    var hoursDisplay = hours <= 9 ? "0" + hours : hours;
    var minutesDisplay = minutes <= 9 ? "0" + minutes : minutes;

    return hoursDisplay + ":" + minutesDisplay;
  }
  convertDecimalToTime(columnName, columnValue) {
    let chargeableTime = "";
    if (
      (columnName == "Chargeable Hours" ||
        columnName == "Booked Hours" ||
        columnName == "Actual Hours") &&
      columnValue
    ) {
      columnValue = Math.abs(columnValue);
      let decimalTimeString = columnValue.toString();
      let theDate = new Date(0, 0);
      theDate.setSeconds(+decimalTimeString * 60 * 60);

      let baseDate = new Date(1900, 0, 1, 0, 0, 0, 0);
      let secondsDifference = (theDate - baseDate) / 1000;

      chargeableTime = this.secondsToHoursMinutesSeconds(secondsDifference);
    }
    return chargeableTime;
  }
  formatLocaleDate(theDateString) {
    let theDateParts = theDateString.split("/");
    return theDateParts[2] + "-" + theDateParts[1] + "-" + theDateParts[0];
  }

  showProcessResult(result, error, defaultSuccessMessage, defaultErrorMessage) {
    this.openAmendPONumberModalLoading = false;
    this.openAmendBreakModalLoading = false;
    this.openAmendShiftHoursModalLoading = false;

    if (error) {
      let errorMessage = result.split("FIELD_CUSTOM_VALIDATION_EXCEPTION, ");
      if (errorMessage[1]) {
        let theError = errorMessage[1].split(": [");
        if (theError[0]) {
          if (
            theError[0] ===
            "There is missing detail on the placement for this shift therefore it cannot be processed for Pay and Charge"
          ) {
            this.showMessageToUser(
              "error",
              "sticky",
              theError[0] +
              " please contact your consultant so they can update this record's missing details."
            );
            createErrorLog(Id, theError[0], undefined);
          } else {
            this.showMessageToUser("error", "sticky", theError[0] + ".");
            createErrorLog(Id, theError[0], undefined);
          }
        }
      } else {
        this.showMessageToUser("error", "dismissible", defaultErrorMessage);
      }

      console.log("Error 1: ", error);
    } else if (result === "success") {
      this.openAmendPONumberModal = false;
      this.openAmendBreakModal = false;
      this.openAmendShiftHoursModal = false;

      this.theTableMessage = Portal_V2_SM_Updating_Shifts_Message;

      this.fetchTimesheetRecords();
      // this.resetDataTableDisplay();

      this.showMessageToUser("success", "dismissible", defaultSuccessMessage);
    } else {
      let errorMessage = result.split("FIELD_CUSTOM_VALIDATION_EXCEPTION, ");
      if (errorMessage[1]) {
        let theError = errorMessage[1].split(": [");
        if (theError[0]) {
          this.showMessageToUser("error", "sticky", theError[0] + ".");
        }
      } else {
        this.showMessageToUser("error", "dismissible", defaultErrorMessage);
      }

      console.log("Error 2: ", result);
    }
  }
  approveRejectProcessResults(state) {
    if (state === "approve") {
      this.openApproveModalLoading = false;
    } else {
      this.openRejectModalLoading = false;
    }
  }
  showMessageToUser(theVariant, theMode, theMessage) {
    const event = new ShowToastEvent({
      message: theMessage,
      variant: theVariant,
      mode: theMode
    });
    this.dispatchEvent(event);
  }
  convertStatusValue(statusValue) {
    if (
      statusValue === "Awaiting approval" ||
      statusValue === "Not yet submitted"
    ) {
      return "Not Approved / Not Processed";
    }
    if (
      statusValue === "Approved & awaiting processing" ||
      statusValue === "Modified & awaiting processing"
    ) {
      return "Approved / Not Processed";
    }
    if (statusValue === "Processed") {
      return "Approved / Processed";
    }
    return null;
  }

  handleShiftApproval() {
    this.openEndorseApproveModal = false;
    this.fetchTimesheetRecords();
  }
  //#endregion



  



  //#region reloading
  async connectedCallback() {
    this.fetchLoggedInUserSites();
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    this.readOnlyUser = await isViewOnlyUser();
    if (this.readOnlyUser) {
      this.disableButtons = true;
    }

    this.activeFilterTerms = this.viewShiftsToBeApprovedFilterValue;
    this.initialiseColumnConfig();
  }
  adjustColumnsConfigurations() {
    const shiftManagementColumnPreferences = localStorage.getItem(
      this.localStoragePrefix + "shiftManagementAllShiftsColumnPreferences"
    );
    const thePreferences = shiftManagementColumnPreferences
      ? JSON.parse(shiftManagementColumnPreferences)
      : [];
    const hasPreferences = thePreferences ? thePreferences.length > 0 : false;

    let theTimeColumnLabels = new Set([
      "Scheduled Start Time",
      "Scheduled End Time",
      "Actual Start Time",
      "Actual End Time",
      "Chargeable Hours",
      "Booked Hours"
    ]);
    let theIcon;
    this.mainTableColumnStatus = [];
    this.masterLabelAndItsFieldAPIName = new Map();
    this.columnsConfiguration.forEach((column) => {
      if (column.Filter_Type__c === "Date") {
        theIcon = this.dateFilterIcon;
      } else if (column.Filter_Type__c === "Text") {
        theIcon = this.textFilterIcon;
      } else {
        theIcon = "";
      }

      this.mainTableColumnStatus.push({
        column: column.MasterLabel,
        selected: hasPreferences
          ? thePreferences.includes(column.Field_API_Name__c)
          : column.Selected_By_Default__c,
        get filterable() {
          if (column.MasterLabel === "Status") {
            return !this.shiftsToBeApprovedView;
          }
          return column.Filterable__c;
        },
        filterType: column.Filter_Type__c,
        filterIcon: theIcon,
        fieldAPIName: column.Field_API_Name__c,
        fieldDisplayType: column.Field_Display_Type__c,
        isTimeColumn: theTimeColumnLabels.has(column.MasterLabel)
      });
      this.masterLabelAndItsFieldAPIName.set(
        column.MasterLabel,
        column.Field_API_Name__c
      );
    });
  }

  async fetchLoggedInUserSites() {
    try {
      const result = await getSitesOfLoggedInUser();
      console.log('========================================= result : ' + JSON.stringify(result));
        this.selectedSiteIds = result.map(site => `"${site.Id}"`);
    } catch (error) {
      showMessageToUser("error", "An internal error occurred while fetching logged-in user sites.",this);
      console.log("Logged In User Sites Error As Object: ", error);

    }
  }


  async fetchTimesheetRecords() {
    this.theTableMessage = Portal_V2_SM_Fetching_Shifts_Message;
    this.selectedSiteIds = getCookie("siteSelectedByUser");
    getAllShiftRecords({ siteIds: this.selectedSiteIds })
      .then((results) => {
        console.log('=========================this.selectedSiteIds' + this.selectedSiteIds);
        this.hasRecords = results.length > 0 ? true : false;
        if (this.hasRecords === true) {
          this.allTimesheetRecords = results;

          this.flattenShifts();
          this.filterRows();
          this.initPagination();
        } else {
          this.theTableMessage = Portal_V2_SM_No_Shifts_Error;
        }
      })
      .catch((error) => {
        this.hasRecords = false;
        this.theTableMessage = null;
        this.showMessageToUser(
          "error",
          "dismissible",
          Portal_V2_SM_Fetch_Shifts_Error
        );
        createErrorLog(Id, error, undefined);
        console.log("Fetch Timesheet Records Error: ", error);
      });
  }
  async initialiseColumnConfig() {
    try {
      const results = await fetchAdjustableColumns();
      this.columnsConfiguration = results;
      this.adjustColumnsConfigurations();
      this.fetchTimesheetRecords();
    } catch (error) {
      this.showMessageToUser(
        "error",
        "dismissible",
        Portal_V2_SM_Columns_Config_Error
      );
      createErrorLog(Id, error, undefined);
      console.log("Fetch Adjust Columns Configuration Error: ", error);
    }
  }
  flattenShifts() {
    let theTruncatedColumns = new Set([
      "Site",
      "Unit ID",
      "PO",
      "Job Role",
      "Candidate Name"
    ]);
    this.allTimesheetRecords.forEach((theTimesheetRecord) => {
      let columnsInfo = [];
      this.mainTableColumnStatus.forEach((theColumn) => {
        //get value for current column
        let theValue = theTimesheetRecord[theColumn.fieldAPIName];
        if (theColumn.fieldAPIName.includes("__r.")) {
          theValue = this.getLookupReferenceData(
            theTimesheetRecord,
            theColumn.fieldAPIName
          );
        }

        //init the object
        columnsInfo.push({
          display: theColumn.selected,
          key: theColumn.fieldAPIName,
          label: theColumn.column,
          value: theValue,
          isText: theColumn.fieldDisplayType === "Text",
          isNumber: theColumn.fieldDisplayType === "Number",
          isDate: theColumn.fieldDisplayType === "Date",
          isTime: theColumn.fieldDisplayType === "Time",
          isStatus: theColumn.column === "Status",
          isStatusAwaitingApproval:
            theValue === "Awaiting approval" ||
            // theValue == "Modified & awaiting processing" ||
            theValue === "Not yet submitted",
          isStatusApprovedAndAwaitingProcessing:
            theValue === "Approved & awaiting processing" ||
            theValue === "Modified & awaiting processing",
          isStatusProcessed: theValue === "Processed",
          isStatusRejected: theTimesheetRecord.IP_ClientRejected__c,
          statusColorClass: theTimesheetRecord.IP_ClientRejected__c
            ? "status_box status_rejected"
            : this.getStatusColorClass(theColumn.column, theValue),
          statusColorSubClass: theTimesheetRecord.IP_ClientRejected__c
            ? "status_box status_rejected_sub_class"
            : this.getStatusColorSubClass(theColumn.column, theValue),
          isChargeableHoursColumn: theColumn.column === "Chargeable Hours",
          chargeableHoursDisplayText: this.convertDecimalToTime(
            theColumn.column,
            theValue
          ),
          isBookedHoursColumn: theColumn.column === "Booked Hours",
          bookedHoursDisplayText: this.convertDecimalToTime(
            theColumn.column,
            theValue
          ),
          isActualHoursColumn: theColumn.column === "Actual Hours",
          actualHoursDisplayText: this.convertDecimalToTime(
            theColumn.column,
            theValue
          ),
          displayAsNumber:
            theColumn.column !== "Chargeable Hours" &&
            theColumn.column !== "Booked Hours" &&
            theColumn.column !== "Actual Hours",
          isTruncatedColumn: theTruncatedColumns.has(theColumn.column),
          theTruncatedText:
            theValue &&
              theTruncatedColumns.has(theColumn.column) &&
              theValue.length > 15
              ? theValue.substring(0, 15) + "..."
              : theValue
        });

        if (!this.columnsDataMap.has(theColumn.fieldAPIName)) {
          this.columnsDataMap.set(theColumn.fieldAPIName, new Set());
        }
        this.columnsDataMap.get(theColumn.fieldAPIName).add(theValue);
      });
      theTimesheetRecord.columns = columnsInfo;
    });
    console.log('timeSheetsData :' + this.timeSheetsData);
    console.log('JSON.stringify(this.allTimesheetRecords):' + JSON.stringify(this.allTimesheetRecords));
    this.filteredShifts = JSON.parse(JSON.stringify(this.allTimesheetRecords));
  }
  initPagination() {
    let paginatedResults = [];
    let page = [];
    let nextPageNumber = 1;
    const pageSize = parseInt(defaultPageSize, 10);
    //add to the appropriate page
    this.filteredShifts.forEach((record) => {
      page.push(record);

      //if we are at the end of the page, add it to the
      //paginated results, and move to the next page
      if (page.length >= pageSize) {
        paginatedResults.push({
          pageNum: nextPageNumber,
          content: page
        });
        nextPageNumber++;
        page = [];
      }
    });
    //handle a non full page
    if (page.length > 0) {
      paginatedResults.push({ pageNum: nextPageNumber, content: page });
    }
    this.paginatedResults = paginatedResults;

    this.loadSelectedPage({ detail: 1 });
  }

  loadSelectedPage(event) {
    this.activePage = event.detail;
    localStorage.setItem(
      this.localStoragePrefix + "activePage",
      this.activePage
    );
    this.timeSheetsData = this.paginatedResults.find(
      (iteratedPage) => iteratedPage.pageNum === event.detail
    )?.content;

    //all timesheets no data
    if (
      this.timeSheetsData === undefined ||
      (this.timeSheetsData.length === 0 &&
        this.viewAllShiftsVariation === "brand")
    ) {
      this.theTableMessage = "No shifts found";
    } else if (
      this.timeSheetsData === undefined ||
      (this.timeSheetsData.length === 0 &&
        this.viewAllShiftsVariation === "neutral")
    ) {
      this.theTableMessage = "No shifts to approve";
    }

    //check all selected on new page
    const selectAllCheckbox = this.template.querySelector(
      `input[data-id="all__checkbox"]`
    );
    if (this.timeSheetsData) {
      selectAllCheckbox.checked =
        this.timeSheetsData.filter((data) => data.isChecked === true).length ===
        this.timeSheetsData.length;

      const paginationComponent = this.template.querySelector(
        `c-portal-v2-pagination`
      );
      if (paginationComponent) {
        paginationComponent.computeTotalPages(this.totalRecords);
        paginationComponent.updateCurrentPage(this.activePage);
        paginationComponent.designLayout();
      }
    }
  }
  //#endregion

  //#region filtering

  handleColumnPickerFilter(event) {
    this.mainTableColumnStatus = [...event.detail.mainTable];

    let selectedTableColumns = [];
    this.mainTableColumnStatus.forEach((theColumn) => {
      if (theColumn.selected === true) {
        selectedTableColumns.push(theColumn.fieldAPIName);
      }
    });

    localStorage.setItem(
      this.localStoragePrefix + "shiftManagementAllShiftsColumnPreferences",
      JSON.stringify(selectedTableColumns)
    );

    this.flattenShifts();
    this.filterRows();
    // this.initPagination();
    this.openAdjustColumnsModal = false;
  }

  clearFilters() {
    this.activeFilterTerms = [];
    this.filterRows();
  }

  handleResetFilter(event) {
    console.log(JSON.stringify(event.detail));
    this.activeFilterTerms = this.activeFilterTerms.filter(
      (filter) => filter.column !== event.detail.column
    );

    this.filterRows();
    this.openDateFilterModal = false;
    this.openTextFilterModal = false;
  }

  handleApplyFilter(event) {
    console.log(JSON.parse(JSON.stringify(event.detail)));
    this.openTextFilterModal = false;
    this.openDateFilterModal = false;

    let currentFilter = this.activeFilterTerms.find(
      (col) => event.detail.column === col.column
    );

    if (currentFilter) {
      currentFilter.filterTerms = event.detail.filterTerms;
    } else {
      this.activeFilterTerms.push(event.detail);
    }

    console.log(
      `Active filters:`,
      JSON.parse(JSON.stringify(this.activeFilterTerms))
    );

    this.filterRows();
  }

  filterRows() {
    let filteredRows = this.allTimesheetRecords;
    this.activeFilterTerms.forEach((filter) => {
      filteredRows = filteredRows.filter((row) => {
        const currentColumn = row.columns.find(
          (col) => filter.column === col.key || filter.column === col.label
        );
        if (!currentColumn) return false;
        if (currentColumn.isText) {
          if (currentColumn.key === "IP_Status__c") {
            const statusValue = this.convertStatusValue(currentColumn.value);
            return filter.filterTerms.includes(statusValue);
          }

          return filter.filterTerms.includes(currentColumn.value);
        } else if (currentColumn.isDate) {
          //start of the date of the start date, end of the date of the end date
          const filterStart = new Date(filter.filterTerms.startDate).setHours(
            0,
            0,
            0,
            0
          );
          const filterEnd = new Date(filter.filterTerms.endDate).setHours(
            23,
            59,
            59,
            999
          );
          const colValue = new Date(currentColumn.value);
          return colValue >= filterStart && colValue <= filterEnd;
        }
        return false;
      });
    });
    this.filteredShifts = filteredRows;
    this.initPagination();
  }

  //#endregion

  //#region click handlers
  openAdjustColumnsModalBox() {
    this.openAdjustColumnsModal = true;
  }
  closeAdjustColumnsModalBox() {
    this.openAdjustColumnsModal = false;
  }
  closeAmendPONumberModalBoxNew() {
    this.fetchTimesheetRecords().then(() => {
      this.openAmendPONumberModalNew = false;
    });

    // this.fetchTimesheetRecords();
    // this.resetDataTableDisplay();
  }


  openAmendShiftHoursModalBox() {
    this.openAmendShiftHoursModal = true;
    this.openAmendShiftHoursModalLoading = true;

    this.openAmendShiftHoursModalData = [];
    if (this.selectedShiftRecords.length > 0) {
      this.selectedShiftRecords.forEach((value) => {
        //set the start time
        let theActualStartTime = "";
        //actual start time not blank
        if (value.sirenum__Actual_Start_Time__c) {
          theActualStartTime = new Date(
            value.sirenum__Actual_Start_Time__c
          ).toLocaleString(LOCALE, { timeZone: this.timeZone });
          theActualStartTime =
            theActualStartTime.toString().split(", ")[1] + ".000Z";
        }
        //if not, take scheduled start
        else if (value.sirenum__Scheduled_Start_Time__c) {
          theActualStartTime = new Date(
            value.sirenum__Scheduled_Start_Time__c
          ).toLocaleString(LOCALE, { timeZone: this.timeZone });
          theActualStartTime =
            theActualStartTime.toString().split(", ")[1] + ".000Z";
        }

        let theActualEndTime = "";
        //actual start time not blank
        if (value.sirenum__Actual_End_Time__c) {
          theActualEndTime = new Date(
            value.sirenum__Actual_End_Time__c
          ).toLocaleString(LOCALE, { timeZone: this.timeZone });
          theActualEndTime =
            theActualEndTime.toString().split(", ")[1] + ".000Z";
        }
        //otherwise take actual
        else if (value.sirenum__Scheduled_End_Time__c) {
          theActualEndTime = new Date(
            value.sirenum__Scheduled_End_Time__c
          ).toLocaleString(LOCALE, { timeZone: this.timeZone });
          theActualEndTime =
            theActualEndTime.toString().split(", ")[1] + ".000Z";
        }

        this.openAmendShiftHoursModalData.push({
          recordId: value.Id,
          candidateName: this.getLookupReferenceData(
            value,
            "sirenum__Contact__r.Name"
          ),
          startDate: value.sirenum__Scheduled_Start_Time__c,
          endDate: value.sirenum__Scheduled_End_Time__c,
          bookedStartTime: value.sirenum__Scheduled_Start_Time__c,
          bookedEndTime: value.sirenum__Scheduled_End_Time__c,
          submissionReason: value.Reason_for_non_submission_of_hours__c,
          selectedReason: this.reasonOptions.map((option) => {
            return { ...option, selected: option.value === value.Reason_for_non_submission_of_hours__c };
          }),
          actualStartTime: theActualStartTime,
          actualEndTime: theActualEndTime,
          formatLocaleDateTime: this.formatLocaleDateTime,
          secondsToHoursMinutesSeconds: this.secondsToHoursMinutesSeconds,
          get shiftHours() {
            let hours =
              Math.abs(
                new Date(
                  `${this.endDate.split("T")[0]}T${this.actualEndTime}`
                ) -
                new Date(
                  `${this.startDate.split("T")[0]}T${this.actualStartTime}`
                )
              ) / 36e5;

            const intPart = Math.floor(hours);
            const decPart = hours % 1;

            const minutes = Math.floor(decPart * 60);

            return `${intPart === 0 ? "00" : intPart < 10 ? "0" + intPart : intPart
              }:${minutes === 0 ? "00" : minutes < 10 ? "0" + minutes : minutes}`;
          }
        });
      });
      this.openAmendShiftHoursModalLoading = false;
    } else {
      this.openAmendShiftHoursModalUserMessage =
        Portal_V2_SM_No_Shifts_Selected_Error;
    }
  }

  closeAmendShiftHoursModalBox() {
    this.openAmendShiftHoursModal = false;
  }
  closeAmendPONumberModalBox() {
    this.openAmendPONumberModal = false;
  }
  openAmendBreakModalBox() {
    this.openAmendBreakModal = true;
    this.openAmendBreakModalLoading = true;

    this.openAmendBreakModalData = [];
    if (this.selectedShiftRecords.length > 0) {
      this.selectedShiftRecords.forEach((value) => {
        this.openAmendBreakModalData.push({
          recordId: value.Id,
          candidateName: this.getLookupReferenceData(
            value,
            "sirenum__Contact__r.Name"
          ),
          startDate: value.sirenum__Scheduled_Start_Time__c,
          currentBreaks: value.Break_Length__c,
          amendedBreaks: ""
        });
      });
      this.openAmendBreakModalLoading = false;
    } else {
      this.openAmendBreakModalUserMessage =
        Portal_V2_SM_No_Shifts_Selected_Error;
    }
  }
  closeAmendBreakModalBox() {
    this.openAmendBreakModal = false;
  }
  openRejectModalBox() {
    this.openRejectModal = true;
    this.openRejectModalLoading = true;

    this.openRejectModalData = [];
    if (this.selectedShiftRecords.length > 0) {
      this.selectedShiftRecords.forEach((value) => {
        this.openRejectModalData.push({
          recordId: value.Id,
          candidateName: this.getLookupReferenceData(
            value,
            "sirenum__Contact__r.Name"
          ),
          jobRole: this.getLookupReferenceData(value, "sirenum__Team__r.Name"),
          startDate: value.sirenum__Scheduled_Start_Time__c,
          actualHours: value.sirenum__Actual_Shift_Length_Decimal__c,
          chargeableHours: this.convertDecimalToTime(
            "Chargeable Hours",
            value.Actual_Hours_minus_break__c
          )
        });
      });
      this.openRejectModalLoading = false;
    } else {
      this.openRejectModalUserMessage = Portal_V2_SM_No_Shifts_Selected_Error;
    }
  }
  closeRejectModalBox() {
    this.openRejectModal = false;
  }
  handleFilterClick(event) {
    this.openTextFilterModal = false;
    this.openDateFilterModal = false;

    this.filterColumnLabel = event.target.title;
    this.filterClickType = event.target.name;

    let filterType = event.target.alt;

    if (filterType === "Date") {
      this.openDateFilterModal = true;
    } else if (filterType === "Text") {
      this.openTextFilterModal = true;
    }

    if (
      this.filterClickType === this.masterLabelAndItsFieldAPIName.get("Status")
    ) {
      this.filterTerms = [
        "Not Approved / Not Processed",
        "Approved / Not Processed",
        "Approved / Processed"
      ];
      // }
      //jyothi.stop
    } else {
      const columnMap = this.filteredShifts.map(
        (shift) =>
          shift.columns.find(
            (column) => column.label === this.filterColumnLabel
          ).value
      );
      this.filterTerms = columnMap;
    }
  }
  handleTextFilterModalClose() {
    this.openTextFilterModal = false;
  }
  handleDateFilterModalClose() {
    this.openDateFilterModal = false;
  }
  openEndorseApprovalModalBox() {
    this.openEndorseApproveModal = true;

    console.log(`here`, this.selectedShiftRecords);
    this.openApproveModalData = [];
    if (this.selectedShiftRecords.length > 0) {
      this.selectedShiftRecords.forEach((value) => {
        if (value) {
          this.openApproveModalData.push({
            recordId: value.Id,
            candidate: value.sirenum__Contact__r,
            jobRole: value.sirenum__Team__r,
            startDate: value.sirenum__Scheduled_Start_Time__c,
            endDate: value.sirenum__Scheduled_End_Time__c,
            actualHours: value.sirenum__Actual_Shift_Length_Decimal__c,
            chargeableHours: value.Actual_Hours_minus_break__c,
            site: value.sirenum__Site__r
          });
        }
      });
    }
  }
  closeEndorseApprovalModal() {
    this.openEndorseApproveModal = false;
  }
  openAmendPONumberModalBoxNew() {
    this.openAmendPONumberModalNew = true;

    console.log(this.selectedShiftRecords);
    this.openApproveModalData = [];
    if (this.selectedShiftRecords.length > 0) {
      this.selectedShiftRecords.forEach((value, key) => {
        const actualStartTime = value.columns.find(
          (col) => col.key === "sirenum__Actual_Start_Time__c"
        ).value;
        const actualEndTime = value.columns.find(
          (col) => col.key === "sirenum__Actual_End_Time__c"
        ).value;
        this.openApproveModalData.push({
          recordId: key,
          splacement: value.sirenum__Placement__r,
          candidate: value.sirenum__Contact__r,
          jobRole: value.sirenum__Team__r,
          startDate: actualStartTime
            ? actualStartTime
            : value.sirenum__Scheduled_Start_Time__c,
          endDate: actualEndTime
            ? actualEndTime
            : value.sirenum__Scheduled_End_Time__c,
          actualHours: value.sirenum__Actual_Shift_Length_Decimal__c,
          chargeableHours: value.Actual_Hours_minus_break__c,
          site: value.sirenum__Site__r,
          timesheet: value.sirenum__Timesheet_summaries__r
        });
      });
    }
  }
  applyViewShiftsToBeApprovedFilters() {
    this.activeFilterTerms = this.viewShiftsToBeApprovedFilterValue;
    this.filterRows();
  }
  //#endregion

  //#region page functions

  addToAllStart() {
    let addToAllStartShiftHours = this.template.querySelector(
      '[data-id="addToAllStartInputElement"]'
    ).value;

    this.openAmendShiftHoursModalData.forEach((row) => {
      row.actualStartTime = addToAllStartShiftHours;
    });

    this.template.querySelector('[data-id="addToAllStartInputElement"]').value =
      undefined;
  }
  addToAllEnd() {
    let addToAllEndShiftHours = this.template.querySelector(
      '[data-id="addToAllEndInputElement"]'
    ).value;

    this.openAmendShiftHoursModalData.forEach((row) => {
      row.actualEndTime = addToAllEndShiftHours;
    });

    this.template.querySelector('[data-id="addToAllEndInputElement"]').value =
      undefined;
  }
  amendAllShiftHours(event) {
    let shiftsToBeAmended = [];
    let amendedStartTime = null;
    let amendedEndTime = null;
    let amendedReason = null;
    let errorOccured = false;
    this.openAmendShiftHoursModalData.forEach((row) => {
      const amendedStartTimeElement = this.template.querySelector(
        `lightning-input[data-start-id="${row.recordId}"]`
      );
      const amendedEndTimeElement = this.template.querySelector(
        `lightning-input[data-end-id="${row.recordId}"]`
      );

      const amendedReasonElement = this.template.querySelector(
        `select[data-reason-id="${row.recordId}"]`
      );

      amendedStartTime = amendedStartTimeElement.value;
      amendedStartTime = amendedStartTime.length > 0 ? amendedStartTime : "";

      amendedEndTime = amendedEndTimeElement.value;
      amendedEndTime = amendedEndTime.length > 0 ? amendedEndTime : "";

      amendedReason = amendedReasonElement?.value || "";

      const isValidTime =
        new Date(row.endDate.split("T")[0] + "T" + amendedEndTime) -
        new Date(row.startDate.split("T")[0] + "T" + amendedStartTime) >
        0;
      const actualStartTimeBeforeScheduled =
        (new Date(row.startDate.split("T")[0] + "T" + amendedStartTime) -
          new Date(row.startDate)) /
        36e5 <
        -2;
      if (!isValidTime) {
        amendedStartTimeElement.setCustomValidity(
          "The shift end time cannot be before the start time."
        );
        amendedEndTimeElement.setCustomValidity(" .");
        errorOccured = true;
      } else if (actualStartTimeBeforeScheduled) {
        amendedStartTimeElement.setCustomValidity(
          "Actual Time must be within 2hr of Scheduled."
        );
        amendedEndTimeElement.setCustomValidity(" .");
        errorOccured = true;
      } else {
        amendedStartTimeElement.setCustomValidity(""); // if there was a custom error before, reset it
        amendedEndTimeElement.setCustomValidity(""); // if there was a custom error before, reset it
      }
      amendedStartTimeElement.reportValidity();
      amendedEndTimeElement.reportValidity();

      if (
        (isValidTime && amendedStartTime.length > 0) ||
        amendedEndTime.length > 0
      ) {
        shiftsToBeAmended.push({
          sobjectType: "sirenum__Shift__c",
          Id: row.recordId,
          Starttime__c: amendedStartTime,
          EndTime__c: amendedEndTime,
          Reason_for_non_submission_of_hours__c: amendedReason
        });
      }
    });

    console.log("@@@@shiftsToBeAmended:" + JSON.stringify(shiftsToBeAmended));

    if (shiftsToBeAmended.length > 0 && !errorOccured) {
      this.openAmendShiftHoursModalLoading = true;

      applyAmendedShiftHoursToAllShifts({
        toBeUpdatedShifts: shiftsToBeAmended
      })
        .then((result) => {
          console.log("@@@@result:" + JSON.stringify(result));
          if (result !== "success") {
            this.showProcessResult(
              "",
              result,
              Portal_V2_SM_Amend_Breaks_Success,
              Portal_V2_SM_Amend_Breaks_Error
            );
            createErrorLog(Id, result, undefined);
          } else {
            this.showProcessResult(
              "success",
              false,
              Portal_V2_SM_Amend_Breaks_Success,
              Portal_V2_SM_Amend_Breaks_Error
            );
          }
        })
        .catch((error) => {
          this.showProcessResult(
            "",
            error,
            Portal_V2_SM_Amend_Breaks_Success,
            Portal_V2_SM_Amend_Breaks_Error
          );
          createErrorLog(Id, error, undefined);
        });
      // .finally(() => {
      // this.maintainPageState(true);
      // });
    }
  }
  addOneToAllShiftBreaks(event) {
    let addToAllShiftBreaks = this.template.querySelector(
      '[data-id="addOneToAllShiftBreaksInputElement"]'
    ).value;
    if (addToAllShiftBreaks.length > 0) {
      this.openAmendBreakModalLoading = true;

      let shiftsToBeAmended = [];
      this.openAmendBreakModalData.forEach((row) => {
        shiftsToBeAmended.push(row.recordId);
      });

      amendOneBreakToAllShifts({
        theShiftIds: shiftsToBeAmended,
        amendedBreaks: addToAllShiftBreaks
      })
        .then((result) => {
          this.showProcessResult(
            result,
            false,
            Portal_V2_SM_Amend_Breaks_Success,
            Portal_V2_SM_Amend_Breaks_Error
          );
        })
        .catch((error) => {
          this.showProcessResult(
            "",
            error,
            Portal_V2_SM_Amend_Breaks_Success,
            Portal_V2_SM_Amend_Breaks_Error
          );
          createErrorLog(Id, error, undefined);
        })
        .finally(() => {
          // this.maintainPageState(true);
        });
    }
  }
  applyToAllShiftBreaks(event) {
    let shiftsToBeAmended = [];
    let amendedBreaks = null;
    this.openAmendBreakModalData.forEach((row) => {
      amendedBreaks = this.template.querySelector(
        `lightning-input[data-id="${row.recordId}"]`
      ).value;
      if (amendedBreaks.length > 0) {
        shiftsToBeAmended.push({
          sobjectType: "sirenum__Shift__c",
          Id: row.recordId,
          Invoice_PO_Optional__c: amendedBreaks
        });
      }
    });

    if (shiftsToBeAmended.length > 0) {
      this.openAmendBreakModalLoading = true;

      applyAmendedBreakToAllShifts({
        toBeUpdatedShifts: shiftsToBeAmended
      })
        .then((result) => {
          this.showProcessResult(
            result,
            false,
            Portal_V2_SM_Amend_Breaks_Success,
            Portal_V2_SM_Amend_Breaks_Error
          );
        })
        .catch((error) => {
          this.showProcessResult(
            "",
            error,
            Portal_V2_SM_Amend_Breaks_Success,
            Portal_V2_SM_Amend_Breaks_Error
          );
          createErrorLog(Id, error, undefined);
        })
        .finally(() => {
          // this.maintainPageState(true);
        });
    }
  }
  approveRejectShiftsForSelectedTimesheets(
    selectedShiftIds,
    state,
    cancellationReason
  ) {
    approveRejectShifts({
      theShiftIds: selectedShiftIds,
      theState: state,
      rejectionReason: cancellationReason
    })
      .then((result) => {
        console.log("####result:" + JSON.stringify(result));
        if (result === "success") {
          this.showMessageToUser(
            "success",
            "dismissible",
            Portal_V2_SM_Approve_Reject_Success.replace(
              "[STATE]",
              state === "approve" ? "approved" : "rejected"
            )
          );

          this.fetchTimesheetRecords();
          // this.resetDataTableDisplay();

          this.openRejectModal = false;
          this.openApproveModal = false;
        } else {
          this.showMessageToUser(
            "error",
            "dismissible",
            Portal_V2_SM_Approve_Reject_Error.replace("[STATE]", state)
          );
          console.log("Timesheet Approve/Reject Process Error: ", result);
        }

        this.approveRejectProcessResults(state);

        if (state.includes("reject")) {
          //Send Rejection message
          selectedShiftIds.forEach((shiftId) => {
            SendRejectionToOwner({
              shiftID: shiftId,
              comments: cancellationReason,
              combinedComment: ""
            });
          });
        }
      })
      .catch((error) => {
        this.approveRejectProcessResults(state);

        this.showMessageToUser(
          "error",
          "dismissible",
          Portal_V2_SM_Approve_Reject_Error.replace("[STATE]", state)
        );
        console.log("Timesheet Approve/Reject Process Error: ", error);
        createErrorLog(Id, error, undefined);
      })
      .finally(() => {
        // this.maintainPageState(true);
      });
  }
  rejectSelectedTimesheets(event) {
    let rejectionReason = this.template.querySelector(
      'lightning-textarea[data-id="rejectionReasonText"]'
    ).value;
    if (rejectionReason) {
      this.openRejectModalLoading = true;

      let selectedShiftIds = [];
      this.openRejectModalData.forEach((value) => {
        selectedShiftIds.push(value.recordId);
      });

      this.approveRejectShiftsForSelectedTimesheets(
        selectedShiftIds,
        "reject",
        rejectionReason
      );
    } else {
      this.showMessageToUser(
        "error",
        "dismissible",
        Portal_V2_SM_No_Rejection_Reason_Error
      );
    }
  }

  exportTimesheets(event) {
    const dateOptions = { year: "numeric", month: "numeric", day: "numeric" };
    const dateTimeOptions = {
      hour: "numeric",
      minute: "numeric"
    };

    try {
      let csvRows = [];

      let headerRow = [];
      this.mainTableColumnStatus.forEach((theColumn) => {
        if (theColumn.selected === true) {
          headerRow.push(theColumn.column);
        }
      });
      csvRows.push(headerRow);

      this.filteredShifts.forEach((theTimeSheet) => {
        let dataRow = [];
        theTimeSheet.columns.forEach((theColumn) => {
          if (theColumn.display === true) {
            let columnValue = theColumn.value;
            if (theColumn.isDate) {
              columnValue = new Date(columnValue).toLocaleDateString(
                "en-GB",
                dateOptions
              );
            } else if (theColumn.isTime) {
              if (columnValue !== undefined) {
                columnValue = new Date(columnValue).toLocaleTimeString(
                  "en-GB",
                  dateTimeOptions
                );
              } else {
                columnValue = "";
              }
            }
            dataRow.push(columnValue);
          }
        });
        csvRows.push(dataRow);
      });

      let csvContent = "";

      let theRow;
      csvRows.forEach(function (rowArray) {
        theRow = rowArray.join(",");
        csvContent += theRow + "\r\n";
      });

      let encodedURI = encodeURIComponent(csvContent);
      let theLink = document.createElement("a");
      theLink.setAttribute(
        "href",
        "data:text/csv;charset=utf-8,%EF%BB%BF" + encodedURI
      );
      theLink.setAttribute("download", "Shifts.csv");
      document.body.appendChild(theLink);
      theLink.click();
    } catch (error) {
      this.showMessageToUser(
        "error",
        "dismissible",
        Portal_V2_SM_Export_Shifts_Error
      );
      createErrorLog(Id, error, undefined);
      console.log("Export Feature Error: ", error);
    }
  }
  //#endregion

  //#region row selection

  selectSingleRow(event) {
    const { id } = event.target.dataset;
    console.log(JSON.parse(JSON.stringify(this.timeSheetsData)));
    const selectedItem = this.timeSheetsData.find((shift) => shift.Id === id);
    selectedItem.isChecked = event.target.checked;
    console.log(selectedItem);

    const allSelected =
      this.timeSheetsData.filter((shift) => shift.selected).length ===
      this.timeSheetsData.length;
    const selectallCheckbox = this.template.querySelector(
      'input[data-id="all__checkbox"]'
    );

    selectallCheckbox.checked = allSelected;

    console.log(
      JSON.parse(
        JSON.stringify(
          this.timeSheetsData.filter((shift) => shift.isChecked === true)
        )
      )
    );
  }
  selectAllRows(event) {
    const checkboxes = this.template.querySelectorAll(`input[type='checkbox]'`);

    checkboxes.forEach((checkbox) => {
      checkbox.checked = event.target.checked;
    });

    this.timeSheetsData.forEach((shift) => {
      shift.isChecked = event.target.checked;
    });

    console.log(
      JSON.parse(
        JSON.stringify(
          this.timeSheetsData.filter((shift) => shift.isChecked === true)
        )
      )
    );
  }
  //#endregion
}
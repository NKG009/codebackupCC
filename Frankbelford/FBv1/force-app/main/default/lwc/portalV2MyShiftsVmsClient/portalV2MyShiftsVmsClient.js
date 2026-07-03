import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";
import userId from "@salesforce/user/Id";

import {
  getCookie,
  showMessageToUser,
  parseSiteValue,
  isViewOnlyUser,
  createErrorLog
} from "c/portalV2Utility";
import { registerListener } from "c/pubsub";
import Id from "@salesforce/user/Id";

export default class PortalV2MyShiftsVmsClient extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  //!Component properties
  @api
  jobRoleViewGroupingColumnName = "Job Role";
  @api
  candidateViewGroupingColumnName = "Name";
  jobView = true;
  currentShiftView = true;
  requestShiftModalOpen = false;
  tempFeedbackModalOpen = false;
  rateCardModalOpen = false;
  cancelModalOpen = false;
  numberOfRecords;
  siteId;
  readOnlyUser;
	selectedSupCancelRsn = '';


  selectedTimePeriod = "1 week";
  timePeriodOptions = [
    {
      value: "1 week",
      label: "Last 1 Week"
    },
    {
      value: "1",
      label: "Last 1 Month"
    },
    {
      value: "3",
      label: "Last 3 Months"
    },
    {
      value: "6",
      label: "Last 6 Months"
    },
    {
      value: "120",
      label: "All Time"
    }
  ];

  async connectedCallback() {
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    this.populateFromCookie();
    try {
      this.readOnlyUser = await isViewOnlyUser();
    } catch (error) {
      createErrorLog(Id, error, undefined);
    }
    console.log(this.siteId);
  }

  populateFromCookie() {
    const cookie = getCookie("siteSelectedByUser");
    console.log(cookie);

    this.siteId = parseSiteValue(cookie);
  }
  parseRating(rating) {
    switch (rating) {
      case "Unsuitable":
        return 1;
      case "Bad":
        return 2;
      case "Average":
        return 3;
      case "Good":
        return 4;
      case "Excellent":
        return 5;
      default:
        return 0;
    }
  }

  async cancelShift(shift) {
    //if the start time has passed, throw an error
    const startDate = new Date(
      shift.columnInfo.find((col) => col.label === "Start Date").value
    );
    if (startDate < new Date()) {
      return Promise.reject(
        new Error("The start time for this shift has passed")
      );
    }
    const recordInput = {
      fields: {
        Id: shift.recordId,
        sirenum__CancellationReason__c: "Cancelled by Client",
				Supplementary_Cancellation_Reason__c : this.selectedSupCancelRsn,
        sirenum__Cancelled__c: true,
				Cancelled_By__c : userId,
				IP_CancellationTime__c : new Date()
      }
    };
    try {
      return await updateRecord(recordInput);
			console.log('recordInput:::'+JSON.stringify(recordInput))
    } catch (error) {
      console.error(error);
      createErrorLog(Id, error, undefined);
    }
    return undefined;
  }

  //!Getters
  get viewSwitchLabel() {
    return this.jobView ? "View by Worker" : "View by Job Role";
  }

  get timePeriodSwitchLabel() {
    return this.currentShiftView ? "View Past Shifts" : "View Current Shifts";
  }

  get hasRecords() {
    return this.numberOfRecords > 0;
  }

  get feedbackTargets() {
    const output = [];
    let selectedRows = [];
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      selectedRows = jobRoleView.subSelectedRows;
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      selectedRows = candidateView.subSelectedRows;
    }

    selectedRows.forEach((row) => {
      const columnInfo = row.columnInfo.filter(
        (column) => column.includeInRatingModal === true
      );

      if (row.name !== undefined) {
        output.push({
          id: row.recordId,
          contactId: row.contactId,
          name: row.name,
          rating: row.rating,
          ratingNumber: row.rating
            ? this.parseRating(row.rating.sirenum__Rank__c)
            : 0,
          columnInfo: columnInfo,
          site: row.site
        });
      }
    });
    console.log(output);
    return output;
  }

  get mainSelectedRows() {
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      return jobRoleView.mainSelectedRows;
    }
    const candidateView = this.template.querySelector(
      "c-portal-v2-my-shifts-candidate-view"
    );
    return candidateView.mainSelectedRows;
  }

  get reviewButtonDisabled() {
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      if (jobRoleView === null || this.readOnlyUser) {
        return true;
      }
      const selectedRows = jobRoleView.subSelectedRows;
      console.log(selectedRows);
      return selectedRows.length === 0 || this.currentShiftView;
    }
    const candidateView = this.template.querySelector(
      "c-portal-v2-my-shifts-candidate-view"
    );
    if (candidateView === null || this.readOnlyUser) {
      return true;
    }
    const selectedRows = candidateView.subSelectedRows;
    console.log(selectedRows);
    return selectedRows.length === 0 || this.currentShiftView;
  }

  get rateCardButtonDisabled() {
    const jobRoleView = this.template.querySelector(
      "c-portal-v2-my-shifts-job-role-view"
    );
    if (jobRoleView === null || this.readOnlyUser) {
      return true;
    }
    const selectedRows = jobRoleView.mainSelectedRows;
    console.log(selectedRows);
    return !this.jobView || selectedRows.length === 0;
  }

  get cancelButtonDisabled() {
    let hasRecords = false;

    if (this.readOnlyUser) {
      return true;
    }

    let selectedShifts = [];
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      if (jobRoleView) {
        selectedShifts = jobRoleView.subSelectedRows;
      }
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      if (candidateView) {
        selectedShifts = candidateView.subSelectedRows;
      }
    }

    if (selectedShifts.length > 0) {
      hasRecords = true;
    }
    return !this.currentShiftView || !hasRecords;
  }

  get requestShiftVacancyDisabled() {
    if (this.readOnlyUser) {
      return true;
    }
    return false;
  }

  get titleSummaryViewLabel() {
    return this.jobView ? "Job Role" : "Worker";
  }
  get titleTimePeriodLabel() {
    return this.currentShiftView ? "Current" : "Past";
  }

  //!Click handlers
  selectionChangeHandler(event) {
    if (event.target.value) {
      this.selectedTimePeriod = event.target.value;
    }
  }
  handleViewToggleClick() {
    this.jobView = !this.jobView;
    //Trigger a re-render/reset of the pagination component
    this.numberOfRecords = 0;
  }

  handleTimePeriodToggleClick() {
    this.currentShiftView = !this.currentShiftView;
    //Trigger a re-render/reset of the pagination component
    this.numberOfRecords = 0;
    //Call the method to re-initialise pagination on the child component
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      jobRoleView.toggleTimePeriod(this.currentShiftView);
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      candidateView.toggleTimePeriod(this.currentShiftView);
    }
  }

  handleShiftModalOpenClick() {
    this.requestShiftModalOpen = true;
  }
  handleTempFeedbackModalOpenClick() {
    this.tempFeedbackModalOpen = true;
  }
  handleRateCardModalOpenClick() {
    this.rateCardModalOpen = true;
  }
  handleCancelModalOpenClick() {
    this.cancelModalOpen = true;
  }

  clearFilter() {
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      jobRoleView.clearAllFilters();
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      candidateView.clearAllFilters();
    }
  }

  handleAdjustColumnClick() {
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      jobRoleView.openColumnSelectorModal();
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      candidateView.openColumnSelectorModal();
    }
  }

  handleExportClick() {
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      jobRoleView.exportData();
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      candidateView.exportData();
    }
  }

  async handleCancelShiftClick(evt) {
    let selectedShifts = [];
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      selectedShifts = jobRoleView.subSelectedRows;
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      selectedShifts = candidateView.subSelectedRows;
    }

    try {
			if(evt && evt.detail.selectedsupcancelrsn !== null && evt.detail.selectedsupcancelrsn !== undefined){
					this.selectedSupCancelRsn = evt.detail.selectedsupcancelrsn;
					console.log('this.selectedSupCancelRsn:::'+this.selectedSupCancelRsn);
			}
      this.cancelModalOpen = false;
      let promises = [];
      selectedShifts.forEach((shift) => {
        promises.push(this.cancelShift(shift));
      });

      await Promise.all(promises);
      showMessageToUser(
        "success",
        "Your cancel request has now been submitted.",
        this
      );

      this.refreshData();
    } catch (error) {
      console.error(error);
      createErrorLog(Id, error, undefined);
      if (error === "The start time for this shift has passed") {
        showMessageToUser(
          "error",
          "The start date for one or more selected shifts has passed and can no longer be cancelled Please contact your consultant.",
          this
        );
      } else {
        showMessageToUser(
          "error",
          "An unexpected error has occurred. Please contact your System Administrator.",
          this
        );
      }
    }
  }

  refreshData() {
    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      jobRoleView.refreshData();
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      candidateView.refreshData();
    }
  }

  //!Event handlers

  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.siteId = eventPayload;
    }
  }
  handleNumRecordChange(event) {
    const numRecords = event.detail;
    this.numberOfRecords = numRecords;
    console.log(this.numberOfRecords);
  }

  handleRowsSelected(event) {
    const selectedRows = event.detail;

    this.rowsSelected = selectedRows.length > 0;
  }
  handlePageSelected(event) {
    const pageNumber = event.detail;

    if (this.jobView) {
      const jobRoleView = this.template.querySelector(
        "c-portal-v2-my-shifts-job-role-view"
      );
      jobRoleView.changePages(pageNumber);
    } else {
      const candidateView = this.template.querySelector(
        "c-portal-v2-my-shifts-candidate-view"
      );
      candidateView.changePages(pageNumber);
    }
  }
  handleShiftRequestModalCloseEvent() {
    this.requestShiftModalOpen = false;
    this.refreshData();
  }
  handleTempFeedbackModalCloseEvent() {
    this.tempFeedbackModalOpen = false;
    this.refreshData();
  }
  handleRateCardModalCloseEvent() {
    this.rateCardModalOpen = false;
  }
  handleTempModalClose() {
    this.cancelModalOpen = false;
  }

  

}
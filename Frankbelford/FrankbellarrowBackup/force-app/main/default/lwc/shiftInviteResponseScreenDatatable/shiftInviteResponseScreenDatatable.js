/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import getUnfilledShiftShiftInvitations from "@salesforce/apex/shiftInviteResponseController.getUnfilledShiftShiftInvitations";

import SHIFT_ID_FIELD from "@salesforce/schema/sirenum__Shift__c.Id";
import PUBLISHED_FIELD from "@salesforce/schema/sirenum__Shift__c.sirenum__Published__c";
import SHIFT_INVITATION_ID_FIELD from "@salesforce/schema/sirenum__Shift_Invitation__c.Id";
import STATUS_FIELD from "@salesforce/schema/sirenum__Shift_Invitation__c.sirenum__Status__c";

import { getCookie, setCookie } from "c/utility";

export default class ShiftInviteResponseScreenDatatable extends NavigationMixin(
  LightningElement
) {
  @api
  cardTitle;
  @api
  cardIcon;
  @api
  confirmedStatus;
  @api
  failedStatus;
  @api
  shiftDemandRecordTypeId;
  @api
  daysSinceAcceptanceWarning;
  sortBy;
  sortDirection;

  @wire(getUnfilledShiftShiftInvitations)
  shiftInvitations(provisionedValue) {
    this.shiftInvitesProvisionedValue = provisionedValue;
    const { data, error } = provisionedValue;
    if (data) {
      this.loading = true;
      this.shiftInvites = data;
      this.flattenData();
      this.filterTable();
    } else if (error) {
      console.error(error);
    }
  }
  shiftInvites = [];
  shiftInvitesProvisionedValue;
  parsedData = [];
  filteredParsedData = [];
  loading = true;
  numRowsSelected; //Exists solely to force a re-render

  jobRoleFilter;
  shiftOwnerFilter;
  jobOfferOwnerFilter;
  branchCostCodeFilter;
  candidateFilter;

  filterFields = {
    shiftOwner: {
      fields: ["Name", "Brand__c"],
      displayFields: "Name, Brand__c"
    },
    jobRole: {
      fields: ["Name", "Job_Category_Text__c"],
      displayFields: "Name, Job_Category_Text__c"
    },
    jobOfferOwner: {
      fields: ["Name", "Brand__c"],
      displayFields: "Name, Brand__c"
    },
    branch: {
      fields: ["Name", "IP_BranchID__c"],
      displayFields: "Name, IP_BranchID__c"
    },
    candidate: {
      fields: ["Name", "MobilePhone"],
      displayFields: "Name, MobilePhone"
    }
  };

  columns = [
    {
      label: "Candidate Name",
      fieldName: "contactLink",
      type: "url",
      typeAttributes: { label: { fieldName: "name" }, target: "_blank" },
      sortable: "true"
    },
    {
      label: "Job Role",
      fieldName: "jobRoleLink",
      type: "url",
      typeAttributes: { label: { fieldName: "jobRoleName" }, target: "_blank" },
      sortable: "true"
    },
    {
      label: "Site",
      fieldName: "siteLink",
      type: "url",
      typeAttributes: { label: { fieldName: "siteName" }, target: "_blank" },
      sortable: "true"
    },
    {
      label: "Mobile",
      fieldName: "phone",
      type: "phone"
    },
    {
      label: "Shift Date",
      fieldName: "startDate",
      type: "date",
      typeAttributes: {
        day: "2-digit",
        month: "2-digit",
        year: "numeric"
      },
      sortable: "true"
    },
    {
      label: "Start Time",
      fieldName: "startDate",
      type: "date",
      typeAttributes: {
        hour: "2-digit",
        minute: "2-digit"
      }
    },
    {
      label: "End Time",
      fieldName: "endDate",
      type: "date",
      typeAttributes: {
        hour: "2-digit",
        minute: "2-digit"
      }
    },
    {
      label: "Shift Owner",
      fieldName: "ownerName",
      type: "string",
      sortable: "true"
    },
    {
      label: "General Compliance Status",
      fieldName: "complianceStatus",
      type: "string",
      sortable: "true"
    },
    {
      label: "Days since acceptance",
      fieldName: "daysSinceAcceptance",
      type: "string",
      cellAttributes: {
        iconName: {
          fieldName: "daysSinceAcceptanceIcon"
        },
        iconPosition: "right"
      }
    }
  ];

  connectedCallback() {
    const jobOfferOwnerFilterCookie = getCookie("jobOfferOwnerFilter");
    const shiftOwnerFilterCookie = getCookie("shiftOwnerFilter");
    const jobRoleFilterFilterCookie = getCookie("jobRoleFilter");
    const branchCostCodeFilterCookie = getCookie("branchCostCodeFilter");
    const candidateFilterCookie = getCookie("candidateFilter");

    this.jobOfferOwnerFilter =
      jobOfferOwnerFilterCookie !== ""
        ? JSON.parse(jobOfferOwnerFilterCookie)
        : undefined;
    this.shiftOwnerFilter =
      shiftOwnerFilterCookie !== ""
        ? JSON.parse(shiftOwnerFilterCookie)
        : undefined;
    this.jobRoleFilter =
      jobRoleFilterFilterCookie !== ""
        ? JSON.parse(jobRoleFilterFilterCookie)
        : undefined;
    this.branchCostCodeFilter =
      branchCostCodeFilterCookie !== ""
        ? JSON.parse(branchCostCodeFilterCookie)
        : undefined;
    this.candidateFilter =
      candidateFilterCookie !== ""
        ? JSON.parse(candidateFilterCookie)
        : undefined;
  }
  filterTable() {
    this.filteredParsedData = [...this.parsedData];
    if (this.jobOfferOwnerFilter !== undefined) {
      this.filteredParsedData = this.filteredParsedData.filter((record) => {
        return record.jobOfferOwner === this.jobOfferOwnerFilter.Id;
      });
    }
    if (this.shiftOwnerFilter !== undefined) {
      this.filteredParsedData = this.filteredParsedData.filter((record) => {
        return record.shiftOwner === this.shiftOwnerFilter.Id;
      });
    }
    if (this.jobRoleFilter) {
      this.filteredParsedData = this.filteredParsedData.filter((record) => {
        return record.jobRole === this.jobRoleFilter.Id;
      });
    }
    if (this.branchCostCodeFilter) {
      this.filteredParsedData = this.filteredParsedData.filter((record) => {
        return (
          record.branchCostCode === this.branchCostCodeFilter.IP_BranchID__c
        );
      });
    }
    if (this.candidateFilter) {
      this.filteredParsedData = this.filteredParsedData.filter((record) => {
        return record.contactId === this.candidateFilter.Id;
      });
    }
  }

  updateRecord(status, shiftId, shiftInviteId, publish, isShiftDemand) {
    const shiftInviteFields = {};
    shiftInviteFields[SHIFT_INVITATION_ID_FIELD.fieldApiName] = shiftInviteId;
    shiftInviteFields[STATUS_FIELD.fieldApiName] = status;

    const shiftFields = {};
    shiftFields[SHIFT_ID_FIELD.fieldApiName] = shiftId;
    shiftFields[PUBLISHED_FIELD.fieldApiName] = true;

    updateRecord({ fields: shiftInviteFields })
      .then(() => {
        if (publish && !isShiftDemand) {
          updateRecord({ fields: shiftFields }).then(() => {
            this.refreshData();

            this.showToast(
              "Success!",
              "Job offer(s) successfully confirmed!",
              "success"
            );
          });
        } else if (publish && isShiftDemand) {
          this.refreshData();

          this.showToast(
            "Success!",
            "Job offer(s) successfully confirmed!",
            "success"
          );
        } else {
          this.refreshData();
          this.showToast(
            "Success!",
            "Job offer(s) successfully rejected!",
            "success"
          );
        }
      })
      .catch((err) => {
        console.log(err);
        this.loading = false;
        this.refreshData();
      });
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  //!Getters
  get shiftOwnerFields() {
    return this.filterFields.shiftOwner.fields;
  }

  get shiftOwnerDisplayFields() {
    return this.filterFields.shiftOwner.displayFields;
  }

  get jobOfferOwnerFields() {
    return this.filterFields.jobOfferOwner.fields;
  }

  get jobOfferOwnerDisplayFields() {
    return this.filterFields.jobOfferOwner.displayFields;
  }

  get jobRoleFields() {
    return this.filterFields.jobRole.fields;
  }

  get jobRoleDisplayFields() {
    return this.filterFields.jobRole.displayFields;
  }

  get branchFields() {
    return this.filterFields.branch.fields;
  }

  get branchDisplayFields() {
    return this.filterFields.branch.displayFields;
  }

  get candidateFields() {
    return this.filterFields.candidate.fields;
  }

  get candidateDisplayFields() {
    return this.filterFields.candidate.displayFields;
  }

  get noRowsSelected() {
    return !this.numRowsSelected;
  }
  get acceptDisabled() {
    const datatable = this.template.querySelector("lightning-datatable");

    if (!datatable) return true;
    const selectedRows = datatable.selectedRows;
    return (
      this.noRowsSelected ||
      (selectedRows.length > 0 &&
        selectedRows.filter((row) => {
          const matchingRecord = this.parsedData.find(
            (record) => record.id === row
          );
          return matchingRecord?.complianceStatus !== "Compliant";
        }).length > 0)
    );
  }

  //!Click handlers
  acceptRows() {
    const datatable = this.template.querySelector("lightning-datatable");
    const selectedRows = datatable.selectedRows;
    const parsedData = [...this.parsedData];

    const filteredRows = parsedData.filter((row) =>
      selectedRows.includes(row.id)
    );
    this.loading = true;
    filteredRows.forEach((record) => {
      this.updateRecord(
        this.confirmedStatus,
        record.shiftId,
        record.id,
        true,
        record.isShiftDemand
      );
    });
  }

  rejectRows() {
    const datatable = this.template.querySelector("lightning-datatable");
    const selectedRows = datatable.selectedRows;
    const parsedData = [...this.parsedData];
    this.loading = true;

    const filteredRows = parsedData.filter((row) =>
      selectedRows.includes(row.id)
    );

    filteredRows.forEach((record) => {
      this.updateRecord(
        this.failedStatus,
        record.shiftId,
        record.id,
        false,
        record.isShiftDemand
      );
    });

    this.parsedData = parsedData;
  }

  refreshData() {
    try {
      refreshApex(this.shiftInvitesProvisionedValue);
    } catch (e) {
      console.error(e);
    }
  }

  //!Event handlers

  flattenData() {
    const outputData = [];

    this.shiftInvites.forEach((record) => {
      console.log(record);
      let flattenedRecord = {
        id: record.Id,
        shiftId: record.sirenum__Shift__c,
        name: record.Contact_Name__c,
        complianceStatus: record.sirenum__Contact__r.Compliance_Status__c,
        jobRoleName: record.sirenum__Shift__r?.sirenum__Team__r.Name,
        siteName: record.sirenum__Shift__r?.sirenum__Site__r.Name,
        jobOfferOwner: record.CreatedById,
        ownerName: record.sirenum__Shift__r?.Owner.Name,
        jobRole: record.sirenum__Shift__r?.sirenum__Team__c,
        shiftOwner: record.sirenum__Shift__r?.OwnerId,
        branchCostCode: record?.sirenum__Shift__r?.Owners_Branch_Id__c,
        contactId: record.sirenum__Contact__c,
        contactLink: `${window.location.origin}/${record.sirenum__Contact__c}`,
        jobRoleLink: `${window.location.origin}/${record.sirenum__Shift__r?.sirenum__Team__c}`,
        siteLink: `${window.location.origin}/${record.sirenum__Shift__r?.sirenum__Site__c}`,
        startDate: record.Scheduled_Start_Time__c,
        endDate: record.Scheduled_End_Time__c,
        phone: record.sirenum__Contact__r.MobilePhone,
        isShiftDemand: record.sirenum__Shift__r?.sirenum__IsShiftDemand__c,
        daysSinceAcceptance: record.Days_since_acceptance__c,
        daysSinceAcceptanceIcon:
          record.Days_since_acceptance__c > this.daysSinceAcceptanceWarning
            ? "utility:warning"
            : ""
      };

      outputData.push(flattenedRecord);
    });

    this.parsedData = outputData;
    this.filteredParsedData = outputData;
    this.loading = false;
  }

  handleSortEvent(event) {
    this.sortBy = event.detail.fieldName;

    if (this.sortBy === "contactLink") {
      this.sortBy = "name";
    }
    this.sortDirection = event.detail.sortDirection;

    this.sortData();
    this.sortBy = event.detail.fieldName;
  }

  sortData() {
    let data = JSON.parse(JSON.stringify(this.filteredParsedData));
    console.log("This is the sort value of nameurl ", this.sortBy);
    //function to return the value stored in the field
    let key = (a) => a[this.sortBy];
    //console.log('This is key value ',key);
    let reverse = this.sortDirection === "asc" ? 1 : -1;
    data.sort((a, b) => {
      let valueA = key(a) ? key(a).toLowerCase() : "";
      let valueB = key(b) ? key(b).toLowerCase() : "";

      return reverse * ((valueA > valueB) - (valueB > valueA));
    });
    this.filteredParsedData = data;
  }

  handleShiftOwnerLookup(event) {
    if (event.detail.data === undefined) {
      setCookie("shiftOwnerFilter", "", 1000);

      this.shiftOwnerFilter = undefined;
      this.filterTable();
      return;
    }
    const { record } = event.detail?.data;
    this.shiftOwnerFilter = record;
    setCookie("shiftOwnerFilter", JSON.stringify(record), 1000);
    this.filterTable();
  }
  handleShiftInviteOwnerLookup(event) {
    if (event.detail.data === undefined) {
      setCookie("jobOfferOwnerFilter", "", 1000);

      this.jobOfferOwnerFilter = undefined;
      this.filterTable();
      return;
    }
    const { record } = event.detail?.data;
    this.jobOfferOwnerFilter = record;
    setCookie("jobOfferOwnerFilter", JSON.stringify(record), 1000);
    this.filterTable();
  }
  handleJobRoleLookup(event) {
    if (event.detail.data === undefined) {
      setCookie("jobRoleFilter", "", 1000);

      this.jobRoleFilter = undefined;
      this.filterTable();
      return;
    }
    const { record } = event.detail?.data;
    this.jobRoleFilter = record;
    setCookie("jobRoleFilter", JSON.stringify(record), 1000);
    this.filterTable();
  }
  handleBranchLookup(event) {
    if (event.detail.data === undefined) {
      setCookie("branchCostCodeFilter", "", 1000);

      this.branchCostCodeFilter = undefined;
      this.filterTable();
      return;
    }
    const { record } = event.detail?.data;
    this.branchCostCodeFilter = record;
    setCookie("branchCostCodeFilter", JSON.stringify(record), 1000);
    this.filterTable();
  }
  handleCandidateLookup(event) {
    if (event.detail.data === undefined) {
      setCookie("candidateFilter", "", 1000);

      this.candidateFilter = undefined;
      this.filterTable();
      return;
    }
    const { record } = event.detail?.data;
    this.candidateFilter = record;
    setCookie("candidateFilter", JSON.stringify(record), 1000);
    this.filterTable();
  }
  handleRowSelected(event) {
    const selectedRows = event.detail.selectedRows;
    this.numRowsSelected = selectedRows.length;
  }
}
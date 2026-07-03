import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";

import getAllJobOrders from "@salesforce/apex/PortalV2MyJobOrdersController.getAllJobOrders";
import fetchAdjustableColumns from "@salesforce/apex/PortalV2MyJobOrdersController.fetchAdjustableColumns";
//import getallratecards from "@salesforce/apex/PortalV2MyJobOrdersController.getJobOrderratecard";
import getworkschedules from "@salesforce/apex/PortalV2MyJobOrdersController.getJobOrderWorkschedule";
import getsubmittedcandidates from "@salesforce/apex/PortalV2MyJobOrdersController.getJobOrderCandidates";
import getallcandidatesunderaccount from "@salesforce/apex/PortalV2MyJobOrdersController.getallcandidatesunderaccount";
import getCompetencyconditions from "@salesforce/apex/PortalV2MyJobOrdersController.getJobOrderCompConditions";
import generateCompliancePDF from "@salesforce/apex/PortalV2MyJobOrdersController.generateCompliancePDF";
import deletecreatedcandidate from "@salesforce/apex/PortalV2MyJobOrdersController.deletecreatedcandidate";
import createCompetencyRecords from "@salesforce/apex/PortalV2MyJobOrdersController.createCompetencyRecords";
import createCandidateRecord from "@salesforce/apex/PortalV2MyJobOrdersController.createCandidateRecord";
import getJobOrderComments from "@salesforce/apex/PortalV2MyJobOrdersController.getJobOrderComments";
import getFilesRelatedToJobOrder from '@salesforce/apex/PortalV2MyJobOrdersController.getFilesRelatedToJobOrder';
import sendJobOrderDeclineEmail from '@salesforce/apex/PortalV2MyJobOrdersController.sendJobOrderDeclineEmail';
import getCurrentCommunityUrl from '@salesforce/apex/PortalV2MyJobOrdersController.getCommunityBaseUrl';
import TIER_2_CANDIDATE_OWNER_ID from '@salesforce/label/c.Tier_2_Candidate_Owner_Id';




import { refreshApex } from '@salesforce/apex';
import { createRecord } from 'lightning/uiRecordApi';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import JOB_ORDER_COMMENT_OBJECT from '@salesforce/schema/Job_Order_Comments__c';
import COMMENT_TEXT_FIELD from '@salesforce/schema/Job_Order_Comments__c.Comment_Text__c';
import COMMENT_TYPE_FIELD from '@salesforce/schema/Job_Order_Comments__c.Comment_Type__c';
import JOB_ORDER_FIELD from '@salesforce/schema/Job_Order_Comments__c.Job_Order__c';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import CONTACT_RECORDTYPEID from '@salesforce/schema/Contact.RecordTypeId';
import STREET_FIELD from '@salesforce/schema/Contact.MailingStreet';
import CITY_FIELD from '@salesforce/schema/Contact.MailingCity';
import POSTCODE_FIELD from '@salesforce/schema/Contact.MailingPostalCode';
import COUNTRY_FIELD from '@salesforce/schema/Contact.MailingCountry';
import NOEMAILOUT_FIELD from '@salesforce/schema/Contact.HasOptedOutOfEmail';
import COMPLIANCE_STATUS_FIELD from '@salesforce/schema/Contact.Compliance_Status__c';
import SMS_OPT_OUT_FIELD from '@salesforce/schema/Contact.smagicinteract__SMSOptOut__c';
import REASON_FOR_REGISTRATION_FIELD from '@salesforce/schema/Contact.IP_ReasonForRegistration__c';
import IP_MAILING_FIELD from '@salesforce/schema/Contact.IP_MailingAddressLine1__c';
import TS2_MAILINGSTREET_FIELD from '@salesforce/schema/Contact.ts2__MailingStateText__c';
import TS2_MAILINGCOUNTRY_FIELD from '@salesforce/schema/Contact.ts2__MailingCountryText__c';
import LOOK_AFTER_BY_FIELD from '@salesforce/schema/Contact.Looked_After_By__c';
import PERSON_STATUS_FIELD from '@salesforce/schema/Contact.Person_Status__c';
import OWNER_FIELD from '@salesforce/schema/Account.OwnerId';
import ACCOUNTID_FIELD from '@salesforce/schema/Contact.AccountId';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';
import { getCookie, isViewOnlyUser, createErrorLog } from "c/portalV2Utility";
import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import USER_ID from "@salesforce/user/Id";


import { registerListener } from "c/pubsub";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import Id from "@salesforce/user/Id";



export default class PortalV2MyJobOrders extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }


  contactRecord;
  accountRecord;
  tier2OwnerId = TIER_2_CANDIDATE_OWNER_ID;
  @track mainTableColumnStatus = [];
  hasRecords = false;
  hasRateCardRecords = false;
  theTableMessage = '';
  @track allJobOrderRecords = [];
  @track joborderdetaildata;
  @track filteredShifts = [];
  openTextFilterModal = false;
  openDateFilterModal = false;
  filterClickType = "";
  filterColumnLabel = "";
  filterTerms = [];
  @track activeFilterTerms = [];
  columnsDataMap = new Map();
  openAdjustColumnsModal = false;
  showjoborderdetail = false;
  @track allWorkScheduleRecords = [];
  hasWorkScheduleRecords = false;
  @track allRateCardRecords = [];
  @track allSubmittedCandidateRecords = [];
  @track allCompetencyConditionRecords = [];
  // newcandidaterecid = '003Qz00000LFgnUIAT';
  newcandidaterecid;
  @track files = [];
  @track contactAddress = {
    street: '',
    city: '',
    postcode: '',
    country: ''
  };

  @track selectedView = 'search';
  @track showAddForm = false;
  @track showSearchForm = true;
  showcandidatecrepage1 = true;
  showcandidatecrepage2 = false;
  showcandidatecrepage3 = false;
  @track proofOfWork = false;
  @track references = false;
  @track paidvia = false;
  @track isSubmitDisabled = true;
  @track isloadingcreatecandidate = false;
  @track isloadingcompetencycondition = false;
  Showtoggleoption = true;
  candidateRecordTypeId;
  @track isDropdownVisible = false;
  @track searchTerm = '';
  @track filteredCandidates = [];
  @track all2ndtierCandidatesRecords = [];
  @track selected2ndTierCandidatedata;
  show2ndTierCandidatedetail = false;
  @track unmatchedCompetencyRecords = [];
  Searchcandidatescreenmsg = [];
  @track searchscreenerrormsg = false;
  @track alteredCompetencyRecords = [];
  @track showfatalerror = false;
  @track allCommentRecords = [];
  @track newComment = '';
  @track allFiles = [];
  communityBaseUrl = '';
  @track cvuploadshow;
  @track cvfilename = '';
  @track showfileuploaderror = false;


  @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
  objectInfo({ data, error }) {
    if (data) {

      const recordTypeInfos = data.recordTypeInfos;
      console.log('Data received: ', JSON.stringify(recordTypeInfos));
      this.candidateRecordTypeId = Object.keys(recordTypeInfos)
        .find(rt => recordTypeInfos[rt].name === '2nd Tier Candidate');

      console.log(' this.candidateRecordTypeId:' + this.candidateRecordTypeId);
    } else if (error) {
      console.error('Error fetching record types: ', error);
    }
  }



  @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
  user;



  get contactId() {
    return getFieldValue(this.user.data, CONTACT_ID_FIELD);
  }

  @wire(getRecord, {
    recordId: "$contactId",
    fields: [ACCOUNTID_FIELD]
  })
  contact(data, error) {
    if (data) {
      this.contactRecord = data;
      console.log('contactRecord:' + JSON.stringify(this.contactRecord));

    } else if (error) {
      console.error(error);
    }
  }

  get accountId() {
    return getFieldValue(this.contactRecord.data, ACCOUNTID_FIELD);
  }

  @wire(getRecord, {
    recordId: "$accountId",
    fields: [OWNER_FIELD]
  })
  async account(data, error) {
    if (data) {
      this.accountRecord = data;
      console.log(' this.accountRecord :' + JSON.stringify(this.accountRecord));
    } else if (error) {
      console.error(error);
    }
  }







  filescolumns = [
    {
      label: 'File Name',
      fieldName: 'viewUrl',
      type: 'url',
      typeAttributes: {
        label: { fieldName: 'Title' },
        target: '_blank'
      }
    }
  ];

  async getFilesRelatedToJobOrder() {
    getFilesRelatedToJobOrder({ jobOrderId: this.joborderdetaildata.Id })
      .then(data => {
        console.log(
          "**************getFilesRelatedToJobOrder**************: " + JSON.stringify(data));
        this.allFiles = data.map(file => {
          return {
            ...file,
            // ContentSize: (file.ContentSize / 1024).toFixed(2), // Convert size to KB
            viewUrl: `${this.communityBaseUrl}/sfc/servlet.shepherd/document/download/${file.Id}`
          };
        });
      })
      .catch(error => {
        console.error('Error fetching files: ', error);
      });
  }

  getCommunityBaseURL() {
    getCurrentCommunityUrl()
      .then(result => {
        this.communityBaseUrl = result;
      })
      .catch(error => {
        console.error('Error fetching current community URL:', error);
      });
  }

  handleCommentChange(event) {
    this.newComment = event.target.value;
  }

  handleSubmitNewComment() {
    if (this.newComment.trim() !== '') {
      const newChatMessage = {
        Comment_Text__c: this.newComment,
        Comment_Type__c: 'External',
        Job_Order__c: this.joborderdetaildata.Id,
        CreatedDate: new Date().toISOString()
      };
      const fields = {};
      fields[COMMENT_TEXT_FIELD.fieldApiName] = newChatMessage.Comment_Text__c;
      fields[COMMENT_TYPE_FIELD.fieldApiName] = newChatMessage.Comment_Type__c;
      fields[JOB_ORDER_FIELD.fieldApiName] = newChatMessage.Job_Order__c;

      const recordInput = { apiName: JOB_ORDER_COMMENT_OBJECT.objectApiName, fields };

      createRecord(recordInput)
        .then(result => {
          newChatMessage.Id = result.id;
          this.allCommentRecords = [...this.allCommentRecords, newChatMessage];

          this.newComment = '';
          this.scrollToLastComment();
          console.log('Comment successfully added: ', result.id);
        })
        .catch(error => {
          console.error('Error creating comment: ', error);

        });
    }
  }

  scrollToLastComment() {
    setTimeout(() => {
      const commentElements = this.template.querySelectorAll('[data-id]');
      if (commentElements.length > 0) {
        const lastCommentElement = commentElements[commentElements.length - 1];
        lastCommentElement.scrollIntoView({ behavior: 'smooth', block: 'end' });
      }
    }, 0);
  }


  getJobOrderComments() {
    getJobOrderComments({ jobOrderId: this.joborderdetaildata.Id })
      .then((results) => {
        console.log(
          "getJobOrderComments: " + JSON.stringify(results));
        this.allCommentRecords = results;

      })
      .catch((error) => {
        console.log("Fetch Comments Error: ", error);
      });
  }




  get yesNoOptions() {
    return [
      { label: 'Yes', value: 'Yes' },
      { label: 'No', value: 'No' }
    ];
  }


  toggleOptions = [
    { label: 'Search', value: 'search' },
    { label: 'Add New Candidate', value: 'add' }
  ];

  handleToggleChange(event) {
    this.selectedView = event.detail.value;
    this.selected2ndTierCandidatedata = '';
    this.show2ndTierCandidatedetail = false;
    this.searchscreenerrormsg = false;
    this.showSearchForm = true;
    this.showcandidatecrepage1 = true;
    this.showcandidatecrepage2 = false;
    this.showcandidatecrepage3 = false;

    this.showAddForm = this.selectedView === 'add';
    if (this.showAddForm == true) {
      this.alteredCompetencyRecords = [...this.allCompetencyConditionRecords];
      this.isloadingcreatecandidate = true;
      setTimeout(() => {
        this.isloadingcreatecandidate = false;
      }, 5000);
    }
    this.showSearchForm = this.selectedView === 'search';

  }



  isJobTitleColumn() {
    return columnKey === 'Name';
  }
  get rateCard() {
    return this.joborderdetaildata?.sirenum__RateCard__r?.Name || '';
  }



  competencyconditioncolumns = [
    { label: 'Skill', fieldName: 'skill', sortable: true },
    { label: 'Severity', fieldName: 'severity', sortable: true }
  ];

  rateCardColumns = [{ "column": "Rate Name", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Standard_Rate_Name__c", "type": "Text" },
  { "column": "Rate Type", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Unit__c", "type": "Text" },
  { "column": "Pay Rate", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Pay_Rate__c", "type": "Number" },
  { "column": "Supplier Charge Rate", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Charge_Rate__c", "type": "Number" },
  { "column": "Break Length", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Break_Length__c", "type": "Text" },
  { "column": "Paid Break", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Paid_Break__c", "type": "Text" },
  { "column": "Standard Daily Hours", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Standard_Daily_Hours__c", "type": "Text" },
  { "column": "Standard Weekly Hours", "selected": true, "filterable": false, "filterIcon": "", "fieldAPIName": "sirenum__Standard_Weekly_Hours__c", "type": "Text" }
  ];


  daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  SubmittedCandidatecolumns = [
    { label: 'Name', fieldName: 'ContactName', type: 'text' },
    { label: 'Mobile', fieldName: 'ContactMobilePhone', type: 'phone' },
    { label: 'Email', fieldName: 'ContactEmail', type: 'email' },
    { label: 'Date Submitted', fieldName: 'CreatedDate', type: 'date' },
    { label: 'Status', fieldName: 'Status__c', type: 'text', cellAttributes: { class: { fieldName: 'statusColor' } } }
  ];



  filterIcon = SITE_ASSETS + "/img/icons/filter-dk-grey.svg";
  calendarIcon = SITE_ASSETS + "/img/icons/calendar-dk-grey.svg";

  get hasRecordsToDisplay() {
    return !(
      this.timeSheetsData === undefined || this.timeSheetsData.length === 0
    );
  }

  async connectedCallback() {

    try {
      const adjustableColumnConfig = await fetchAdjustableColumns();
      this.adjustColumnsConfigurations(adjustableColumnConfig);
      this.fetchJobOrderRecords();
      this.getCommunityBaseURL();

      this.loading = false;
    } catch (e) {
      console.error(e);
      createErrorLog(Id, e, undefined);
      this.loading = false;
    }
  }


  adjustColumnsConfigurations(adjustableColumnConfig) {
    this.mainTableColumnStatus = [];
    console.log('jobordr columnbrf:' + JSON.stringify(adjustableColumnConfig));
    let theIcon;

    adjustableColumnConfig.forEach((column) => {
      if (column.Filter_Type__c === "Date") {
        theIcon = this.calendarIcon;
      } else if (column.Filter_Type__c === "Text") {
        theIcon = this.filterIcon;
      } else {
        theIcon = "";
      }
      this.mainTableColumnStatus.push({
        column: column.MasterLabel,
        selected: column.Selected_By_Default__c,
        filterable: column.Filterable__c,
        filterType: column.Filter_Type__c,
        filterIcon: theIcon,
        fieldAPIName: column.Field_API_Name__c,
        type: column.Field_Display_Type__c
      });
    });


    //console.log('jobordr column:' + JSON.stringify(this.mainTableColumnStatus));
  }

  async fetchJobOrderRecords() {
   
    getAllJobOrders()
      .then((results) => {

        console.log(
          "fetchJobOrderRecords: " + JSON.stringify(results));
        this.hasRecords = results.length > 0 ? true : false;
        if (this.hasRecords === true) {
          this.allJobOrderRecords = results.map(jorec =>{
            return {
              ...jorec,
              showJODecline:jorec.Job_Order_Decline_Details__r !=undefined 
  
            };
          });
          this.flattenShifts();
          this.filterRows();
          // this.initPagination();
        } else {
          this.theTableMessage = 'No Job Order Records found.';
        }
      })
      .catch((error) => {
        this.hasRecords = false;
        this.theTableMessage = null;
        createErrorLog(Id, error, undefined);
        console.log("Fetch Job Order Records Error: ", error);
      });
  }


  getLookupReferenceData(theRecord, theField) {
    const fieldInfo = theField.split(".");
    let lookupObject = fieldInfo[0];
    let lookupField = fieldInfo[1];
    return theRecord && theRecord[lookupObject]
      ? theRecord[lookupObject][lookupField]
      : "";
  }

  flattenShifts() {
    try {
      console.log('here in flattenShifts' + this.allJobOrderRecords);

      // Create a deep copy of allJobOrderRecords to avoid mutation issues
      const jobOrderRecordsCopy = JSON.parse(JSON.stringify(this.allJobOrderRecords));

      jobOrderRecordsCopy.forEach((jobOrder) => {
        let columnsInfo = [];
        let startdate = this.formatDate(jobOrder.sirenum__StartDate__c);
        let enddate = this.formatDate(jobOrder.sirenum__StartDate__c);
        jobOrder.sirenum__StartDate__c = startdate;
        jobOrder.sirenum__EndDate__c = enddate;
        this.mainTableColumnStatus.forEach((theColumn) => {
          // Get value for current column
          let theValue = jobOrder[theColumn.fieldAPIName];

          // Handle lookup references (e.g., related fields like Account Name, Site Name)
          if (theColumn.fieldAPIName.includes('__r')) {
            theValue = this.getLookupReferenceData(jobOrder, theColumn.fieldAPIName);
          }

          // Initialize the object for each column
          columnsInfo.push({
            display: theColumn.selected,
            key: theColumn.fieldAPIName,
            label: theColumn.column,
            value: theValue,
            isText: theColumn.type === "Text",
            isDate: theColumn.type === "Date",
            isNumber: theColumn.type === "Number",
            isJobTitle: theColumn.fieldAPIName == 'Name' ? true : false
          });
        });

        // Assign the processed columns to each job order record
        jobOrder.columns = columnsInfo;
      });

      // Assign the modified records back to the original array
      this.allJobOrderRecords = jobOrderRecordsCopy;

      console.log('this.allJobOrderRecords: ', JSON.stringify(this.allJobOrderRecords));

      // Clone the processed job order records
      this.filteredShifts = JSON.parse(JSON.stringify(this.allJobOrderRecords));
    } catch (error) {
      console.error('Error while flattening shifts: ', error);
      console.error('Error message: ', error.message);
      console.error('Error stack: ', error.stack);
    }
  }

  formatDate(dateString) {
    if (!dateString) return ''; // Handle null/undefined values
    let dateObj = new Date(dateString);
    let day = String(dateObj.getDate()).padStart(2, '0'); // Ensures two-digit day
    let month = String(dateObj.getMonth() + 1).padStart(2, '0'); // Month is 0-based
    let year = dateObj.getFullYear();
    return `${day}-${month}-${year}`;
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

    const columnMap = this.filteredShifts.map(
      (shift) =>
        shift.columns.find(
          (column) => column.label === this.filterColumnLabel
        ).value
    );
    this.filterTerms = columnMap;

  }
  handleTextFilterModalClose() {
    this.openTextFilterModal = false;
  }
  handleDateFilterModalClose() {
    this.openDateFilterModal = false;
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

  filterRows() {
    let filteredRows = this.allJobOrderRecords;
    this.activeFilterTerms.forEach((filter) => {
      filteredRows = filteredRows.filter((row) => {
        const currentColumn = row.columns.find(
          (col) => filter.column === col.key || filter.column === col.label
        );
        if (!currentColumn) return false;
        if (currentColumn.isText) {

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
    // this.initPagination();
  }

  get currentFilterSelectedTerms() {
    return this.activeFilterTerms.find(
      (filter) => filter.column === this.filterClickType
    )?.filterTerms;
  }

  get selectedDateFilter() {
    return this.activeFilterTerms.find(
      (term) => term.column === this.filterColumnLabel
    );
  }




  openAdjustColumnsModalBox() {
    this.openAdjustColumnsModal = true;
  }
  closeAdjustColumnsModalBox() {
    this.openAdjustColumnsModal = false;
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
      theLink.setAttribute("download", "Job Orders.csv");
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
    //this.filterRows();
    // this.initPagination();
    this.openAdjustColumnsModal = false;
  }

  handlebacktojobOrdersClick(event) {
    this.showjoborderdetail = false;
    this.joborderdetaildata = {};
  }

  handleSort(event) {
    const { fieldName: sortedBy, sortDirection } = event.detail;
    const cloneData = [...this.skillsList];

    cloneData.sort((a, b) => {
      const val1 = a[sortedBy] ? a[sortedBy].toLowerCase() : '';
      const val2 = b[sortedBy] ? b[sortedBy].toLowerCase() : '';
      return sortDirection === 'asc' ? val1.localeCompare(val2) : val2.localeCompare(val1);
    });

    this.sortedBy = sortedBy;
    this.sortedDirection = sortDirection;
    this.skillsList = cloneData;
  }

  handleRowClick(event) {
    event.preventDefault();
    const jobOrderId = event.target.getAttribute('data-id');
    // Handle the row click logic here, like navigation or fetching details
    console.log('Row clicked for JobOrder Id:', jobOrderId);
    this.joborderdetaildata = this.allJobOrderRecords.find(jobOrder => jobOrder.Id === jobOrderId);
    this.showjoborderdetail = true;

    console.log('Row clicked for this.joborderdetaildata:', this.joborderdetaildata);
    console.log('Row clicked ratecard:', this.joborderdetaildata.sirenum__RateCard__c);
    console.log('Row clicked Workschedule :', this.joborderdetaildata.sirenum__WorkSchedule__c);
    this.getCompetencyConditions();
    this.getallcandidatesunderaccount();
    this.getJobOrderComments();
    this.getFilesRelatedToJobOrder();
    /* if (this.joborderdetaildata.sirenum__RateCard__c != null && this.joborderdetaildata.sirenum__RateCard__c != 'undefined') {
       this.getratecards();
     }*/

    if (this.joborderdetaildata.sirenum__WorkSchedule__c != null && this.joborderdetaildata.sirenum__WorkSchedule__c != 'undefined') {
      this.getworkschedules();
    }
    this.getsubmittedcandidates();
  }



  async getCompetencyConditions() {
    this.isloadingcompetencycondition = true;
    getCompetencyconditions({ joborderid: this.joborderdetaildata.Id })
      .then((results) => {
        console.log(
          "getCompetencyconditions: " + JSON.stringify(results));
        this.allCompetencyConditionRecords = results.map(record => ({
          ...record,
          skill: record.sirenum__TicketType__r.Name,
          severity: record.sirenum__Severity__c
        }));
        console.log(' this.allCompetencyConditionRecords:' + JSON.stringify(this.allCompetencyConditionRecords));
        this.isloadingcompetencycondition = false;
      })
      .catch((error) => {
        console.log("Fetch Competency Conditions Records Error: ", error);
      });

  }
  getsubmittedcandidates() {

    getsubmittedcandidates({ joborderid: this.joborderdetaildata.Id })
      .then((results) => {
        console.log(
          "getsubmittedcandidates: " + JSON.stringify(results));



        this.allSubmittedCandidateRecords = results.map(record => ({
          ...record,
          ContactName: record.Contact__r.Name,
          ContactMobilePhone: record.Contact__r.MobilePhone,
          ContactEmail: record.Contact__r.Email,
          statusColor: this.getStatusColor(record.Status__c)
        }));



      })
      .catch((error) => {
        console.log("Fetch Submitted Candidate Records Error: ", error);
      });

  }

  getStatusColor(status) {
    switch (status) {
      case 'In Review':
        return 'slds-theme_warning';
      case 'Progressed':
        return 'slds-theme_success';
      case 'Submitted':
        return 'slds-theme_inverse';
      case 'Rejected':
        return 'slds-theme_error';
      case 'Accepted':
        return 'slds-theme_success';
      default:
        return '';
    }
  }

  async getallcandidatesunderaccount() {
    await getallcandidatesunderaccount()
      .then((results) => {
        console.log(
          "getallcandidatesunderaccount: " + JSON.stringify(results));
        this.all2ndtierCandidatesRecords = results;
        this.filteredCandidates = results;
      })
      .catch((error) => {
        console.log("Fetch All Candidates under Account Error: ", error);
      });
  }


  async getratecards() {

   /* getallratecards({ ratecardid: this.joborderdetaildata.sirenum__RateCard__c })
      .then((results) => {
        console.log(
          "getallratecards: " + JSON.stringify(results));

        this.hasRateCardRecords = results.length > 0 ? true : false;
        if (this.hasRateCardRecords === true) {
          this.allRateCardRecords = results;
          this.flattenratecards();
        }
        else {
          this.theTableMessage = 'No Records found.';
        }
      })
      .catch((error) => {
        console.log("Fetch Rate Card Records Error: ", error);
      });*/

  }

  flattenratecards() {
    try {
      console.log('************here in flattenratecards*************');

      // Create a deep copy of allJobOrderRecords to avoid mutation issues
      const allratecarddatacopy = JSON.parse(JSON.stringify(this.allRateCardRecords));

      allratecarddatacopy.forEach((ratecard) => {

        ratecard.sirenum__Rate_Lines__r.forEach((lines) => {

          let columnsInfo = [];
          this.rateCardColumns.forEach((theColumn) => {
            // Get value for current column
            let theValue = lines[theColumn.fieldAPIName];

            if (lines[theColumn.fieldAPIName] == null && this.joborderdetaildata.sirenum__RateCard__c != 'undefined') {
              theValue = '';
            }
            // Handle lookup references (e.g., related fields like Account Name, Site Name)
            if (theColumn.fieldAPIName.includes('__r')) {
              theValue = this.getLookupReferenceData(jobOrder, theColumn.fieldAPIName);
            }

            // Initialize the object for each column
            columnsInfo.push({
              display: theColumn.selected,
              key: theColumn.fieldAPIName,
              label: theColumn.column,
              value: theValue,
              isText: theColumn.type === "Text",
              isNum: theColumn.type === "Number",
            });
          });

          // Assign the processed columns to each job order record
          lines.columns = columnsInfo;
        });
      });

      // Assign the modified records back to the original array
      this.allRateCardRecords = allratecarddatacopy;

      console.log('allRateCardRecords: ', JSON.stringify(this.allRateCardRecords));

    } catch (error) {
      console.error('Error while Creating Rate card table data : ', error);
    }
  }
  async getworkschedules() {

    getworkschedules({ workschid: this.joborderdetaildata.sirenum__WorkSchedule__c })
      .then(results => {
        console.log(
          "getworkschedules: " + JSON.stringify(results));

        this.hasWorkScheduleRecords = results.length > 0 ? true : false;
        if (this.hasWorkScheduleRecords === true) {
          this.allWorkScheduleRecords = this.fillMissingDays(results);
          console.log('**********allWorkScheduleRecords: ', JSON.stringify(this.allWorkScheduleRecords));

        }
        else {
          this.theTableMessage = 'No Records found.';
        }
      })
      .catch(error => {
        console.error('Error while fetching work schedule records : ', error);
      });

  }


  formatTime(milliseconds) {
    const date = new Date(milliseconds);
    let hours = date.getUTCHours();
    const minutes = date.getUTCMinutes();
    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    const minutesStr = minutes < 10 ? '0' + minutes : minutes; // ensure two digits for minutes
    return `${hours}:${minutesStr} ${ampm}`;
  }

  fillMissingDays(data) {
    const dataMap = new Map(data.map(item => [item.sirenum__Offset__c, item]));

    // Ensure all days of the week are represented
    this.fullWeekData = this.daysOfWeek.map((day, index) => {
      if (dataMap.has(index)) {
        const existingItem = dataMap.get(index);
        return {
          ...existingItem,
          dayOfWeek: day,
          formattedStartTime: this.formatTime(existingItem.sirenum__Start__c),
          formattedEndTime: this.formatTime(existingItem.sirenum__End__c)
        };
      } else {
        return {
          Id: null,
          sirenum__Start__c: null,
          sirenum__End__c: null,
          sirenum__Offset__c: index,
          dayOfWeek: day,
          formattedStartTime: '-',
          formattedEndTime: '-'
        };
      }
    });

    return this.fullWeekData;
  }

  handleInputChange(event) {
    const field = event.target.dataset.id;
    this.contactAddress[field] = event.target.value;
  }

  handlecandidateSubmit(event) {

    event.preventDefault();
    this.isloadingcreatecandidate = true;
    const fields = event.detail.fields;
    console.log('accountid:' + this.contactRecord.data.fields.AccountId.value);
    console.log('usercontactid:' + this.contactRecord.data.id);

    fields[STREET_FIELD.fieldApiName] = this.contactAddress.street;
    fields[CITY_FIELD.fieldApiName] = this.contactAddress.city;
    fields[POSTCODE_FIELD.fieldApiName] = this.contactAddress.postcode;
    fields[COUNTRY_FIELD.fieldApiName] = this.contactAddress.country;
    fields[IP_MAILING_FIELD.fieldApiName] = this.contactAddress.street + ', ' + this.contactAddress.city + ', ' + this.contactAddress.country + ', ' + this.contactAddress.postcode;
    fields[TS2_MAILINGSTREET_FIELD.fieldApiName] = this.contactAddress.city;
    fields[TS2_MAILINGCOUNTRY_FIELD.fieldApiName] = this.contactAddress.country;
    fields[NOEMAILOUT_FIELD.fieldApiName] = true;
    fields[SMS_OPT_OUT_FIELD.fieldApiName] = true;
    fields[COMPLIANCE_STATUS_FIELD.fieldApiName] = 'Compliant';
    fields[REASON_FOR_REGISTRATION_FIELD.fieldApiName] = '2nd Tier Candidate Submission';
    fields[CONTACT_RECORDTYPEID.fieldApiName] = this.candidateRecordTypeId;
    fields[ACCOUNTID_FIELD.fieldApiName] = this.contactRecord.data.fields.AccountId.value;
    fields[PERSON_STATUS_FIELD.fieldApiName] = 'Active';
    fields[LOOK_AFTER_BY_FIELD.fieldApiName] = this.contactRecord.data.id;
    fields[OWNER_FIELD.fieldApiName] = this.tier2OwnerId;


    console.log('fields to be submitted :' + JSON.stringify(fields));
    this.template.querySelector('lightning-record-edit-form').submit(fields);
  }


  handlecandidateSuccess(event) {
    console.log('Contact created successfully with Id: ', event.detail.id);
    this.newcandidaterecid = event.detail.id;
    // this.showToast('Success', 'Candidate created successfully', 'success');



    this.showcandidatecrepage1 = false;
    this.showcandidatecrepage2 = true;
    this.showcandidatecrepage3 = false;
    this.isloadingcreatecandidate = false;
    this.Showtoggleoption = false;
    this.proofOfWork = false;
    this.references = false;
    this.isSubmitDisabled = true;
    this.alteredCompetencyRecords = [...this.allCompetencyConditionRecords];

    this.template.querySelector('lightning-record-edit-form').reset();

    /*if (this.files.length > 0 && this.newcandidaterecid !=null && this.newcandidaterecid !=undefined) {
        const uploadedFileNames = this.files.map(file => file.name).join(', ');

        this.showToast('Success', 'Files uploaded: ' + uploadedFileNames, 'success');
    }*/

  }

  handleError(event) {
    this.isloadingcreatecandidate = false;
    const error = event.detail;
    console.error('Error creating contact:', JSON.stringify(error));
    this.showToast('Error', 'An error occurred while creating the contact:' + error, 'error');
  }

  handleKeydown(event) {
    if (event.key === 'Enter') {
      event.preventDefault();
    }
  }
  handleUploadFinished(event) {

    const uploadedFiles = event.detail.files;
    this.files = [];
    this.files = uploadedFiles;
    console.log('handleUploadFinished:' + JSON.stringify(this.files));
    if (this.files.length > 0) {
      const uploadedFileNames = this.files.map(file => file.name).join(', ');
      this.cvfilename = uploadedFileNames;
      this.showToast('Success', 'Candidate CV Uploaded Successfully: ' + uploadedFileNames, 'success');
      this.cvuploadshow = true;
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  handleProofOfWorkChange(event) {
    this.proofOfWork = event.detail.checked;
    this.validateForm();
  }

  handleReferencesChange(event) {
    this.references = event.detail.checked;
    this.validateForm();
  }

  handlePaidViaChange(event) {
    this.paidvia = event.detail.checked;
    this.validateForm();
  }

  validateForm() {
    this.isSubmitDisabled = !(this.proofOfWork && this.references && this.paidvia);
  }

  handleCertificateSubmit() {
    this.isloadingcreatecandidate = true;

    if (this.newcandidaterecid != null) {
      this.showToast('Success', 'Candidate created successfully', 'success');


      generateCompliancePDF({
        contactId: this.newcandidaterecid
      })
        .then(() => {
          this.isloadingcreatecandidate = false;
          this.showcandidatecrepage1 = false;
          this.showcandidatecrepage2 = false;
          this.showcandidatecrepage3 = true;
          this.cvuploadshow = false;
          this.showToast('Success', 'Certificate Pdf generated and attached successfully', 'success');
        })
        .catch(error => {
          this.isloadingcreatecandidate = false;
          this.showToast('Error', error.body.message, 'error');
        });
    }
  }
  handleCertificateCancel() {
    this.Showtoggleoption = true;
    this.showcandidatecrepage1 = true;
    this.showcandidatecrepage2 = false;
    this.showcandidatecrepage3 = false;
    if (this.newcandidaterecid != null) {
      deletecreatedcandidate({
        contactId: this.newcandidaterecid
      })
        .then(() => {
        })
        .catch(error => { });
    }
  }

  handleRadioChangecompetencycreation(event) {
    console.log('here in handleRadioChangecompetencycreation' + event.detail.value);
    console.log(' alteredCompetencyRecordslength start handleRadioChangecompetencycreation :', this.alteredCompetencyRecords.length);

    const selectedValue = event.detail.value;
    const skillId = event.target.dataset.id;

    // Update the selected value and conditionally show file upload if "Yes" is selected and Requires Proof is true
    this.alteredCompetencyRecords = this.alteredCompetencyRecords.map(skill => {
      if (skill.Id === skillId) {
        return {
          ...skill,
          selectedValue,
          showFileUpload: selectedValue === 'Yes' && skill.sirenum__TicketType__r.sirenum__Requires_Proof__c,
          showValidtill: selectedValue === 'Yes' && skill.sirenum__TicketType__r.sirenum__Expires__c,
          isContainsFile: false
        };
      }
      return skill;
    });
    console.log(' alteredCompetencyRecordslength end handleRadioChangecompetencycreation :', this.alteredCompetencyRecords.length);

  }

  handleValiddateChangecompetencycreation(event) {
    const validDateValue = event.detail.value;
    const skillId = event.target.dataset.id;

    // Update the selected value and conditionally show file upload if "Yes" is selected and Requires Proof is true
    this.alteredCompetencyRecords = this.alteredCompetencyRecords.map(skill => {
      if (skill.Id === skillId) {
        return {
          ...skill,
          validDateValue
        };
      }
      return skill;
    });

  }

  handleSkillsFileUpload(event) {
    const uploadedFiles = event.detail.files;
    const skillId = event.target.dataset.id; // Get the skill ID related to the upload

    if (uploadedFiles.length > 0) {
      const fileId = uploadedFiles[0].documentId; // Get the file's ContentDocumentId

      // Update the relevant skill to contain the file and set 'isContainsFile' to 'Yes'
      this.alteredCompetencyRecords = this.alteredCompetencyRecords.map(skill => {
        if (skill.Id === skillId) {
          skill.isContainsFile = true;
          return {
            ...skill,
            fileId
            // isContainsFile: 'Yes'
          };
        }
        return skill;
      });
      this.showToast('Success', 'File has been uploaded successfully', 'success');
    }
  }
  handleCompetenciesSubmit() {
    this.showfatalerror = false;
    this.showfileuploaderror = false;
    console.log('**********************here in handleCompetenciesSubmit **********************' + this.showfatalerror);
    console.log(' alteredCompetencyRecordslength before createCompetencyRecords :', this.alteredCompetencyRecords.length);
    console.log('this.alteredCompetencyRecords:' + JSON.stringify(this.alteredCompetencyRecords));


    this.alteredCompetencyRecords.forEach(candidatecompetencyRecord => {
      console.log('candidatecompetencyRecord.isContainsFile:' + candidatecompetencyRecord.isContainsFile);
      if (candidatecompetencyRecord.sirenum__Severity__c == 'Fatal' && candidatecompetencyRecord.selectedValue != 'Yes') {
        this.showfatalerror = true;
      }
      if (candidatecompetencyRecord.sirenum__TicketType__r.sirenum__Requires_Proof__c == true) {
        if (candidatecompetencyRecord.isContainsFile == false) { this.showfileuploaderror = true; }

      }
      //

    });
    console.log('this.showfatalerror:' + this.showfatalerror);
    console.log('this.showfileuploaderror:' + this.showfileuploaderror);
    if (this.showfatalerror == true || this.showfileuploaderror == true) {
      if (this.showfatalerror == true) {
        LightningAlert.open({
          message: 'Fatal Skill missing. Please ensure your candidate has this required skill before submitting',
          theme: 'info',
          label: 'Error!',
        });
      }
      else if (this.showfileuploaderror == true) {
        LightningAlert.open({
          message: 'Please Upload all the necessary files before submitting',
          theme: 'info',
          label: 'Error!',
        });
      }
    }
    else {
      this.showfatalerror == false;
      this.isloadingcreatecandidate = true;
      let insmsg = '';

      if (this.searchscreenerrormsg == false) {
        insmsg = 'Both';
      }
      else {
        insmsg = 'Notboth';
      }
      createCompetencyRecords({
        contactId: this.newcandidaterecid,
        joborderid: this.joborderdetaildata.Id,
        competencyConditions: this.alteredCompetencyRecords,
        instype: insmsg
      })
        .then(() => {
          this.showToast('Success', 'Competency Records created successfully', 'success');
          this.alteredCompetencyRecords = [];
          this.getallcandidatesunderaccount();
          this.isloadingcreatecandidate = false;
          this.Showtoggleoption = true;
          if (this.searchscreenerrormsg == false) {
            this.showcandidatecrepage1 = true;
            this.showcandidatecrepage2 = false;
            this.showcandidatecrepage3 = false;
            this.getsubmittedcandidates();
            this.showToast('Success', 'Candidate Submitted successfully', 'success');
          }
          else {

            // this.show2ndTierCandidatedetail=false;
            //this.selected2ndTierCandidatedata=[];

            setTimeout(() => {
              this.sortingunmatchedcompetencies(this.newcandidaterecid);
            }, 2000);
            this.showcandidatecrepage3 = false;
            this.showSearchForm = true;
          }


        })
        .catch(error => {
          this.isloadingcreatecandidate = false;
          console.error('Error creating competency records: ', JSON.stringify(error));
          this.showToast('Error', error.body.message, 'error');
        });
    }
  }


  handleGotoAddSkills() {
    this.showcandidatecrepage3 = true;
    this.showSearchForm = false;
    this.show2ndTierCandidatedetail = false;
  }

  handleSearchChange(event) {
    this.searchTerm = event.target.value;

    if (this.searchTerm) {
      this.filteredCandidates = this.all2ndtierCandidatesRecords.filter(contact =>
        (contact.Name && contact.Name.toLowerCase().includes(this.searchTerm)) ||
        (contact.Email && contact.Email.toLowerCase().includes(this.searchTerm)) ||
        (contact.sirenum__National_Insurance__c && contact.sirenum__National_Insurance__c.toLowerCase().includes(this.searchTerm))

      );
    } else {
      this.filteredCandidates = [...this.all2ndtierCandidatesRecords];
    }

    this.isDropdownVisible = this.filteredCandidates.length > 0;
  }

  showDrop() {
    this.isDropdownVisible = this.filteredCandidates.length > 0;
  }

  hideDrop() {
    setTimeout(() => { this.isDropdownVisible = false; }, 200); // Delay to allow click event
  }

  handleSelect2ndTierCandidate(event) {
    const selectedId = event.currentTarget.dataset.id;

    if (selectedId) {
      console.log('======================if candidate');
      // this.selected2ndTierCandidatedata = this.all2ndtierCandidatesRecords.find(Candidate => Candidate.Id === selectedId);
      this.sortingunmatchedcompetencies(selectedId);

      // this.newcandidaterecid=this.selected2ndTierCandidatedata.Id;


    }

    this.isDropdownVisible = false;
  }

  sortingunmatchedcompetencies(selectedId) {
    this.selected2ndTierCandidatedata = '';
    this.selected2ndTierCandidatedata = this.all2ndtierCandidatesRecords.find(Candidate => Candidate.Id === selectedId);
    this.newcandidaterecid = this.selected2ndTierCandidatedata.Id;
    this.unmatchedCompetencyRecords = [];
    this.allCompetencyConditionRecords.forEach(competencyRecord => {
      let matchFound = false;

      if (this.selected2ndTierCandidatedata.sirenum__Tickets__r && this.selected2ndTierCandidatedata.sirenum__Tickets__r.length > 0) {
        this.selected2ndTierCandidatedata.sirenum__Tickets__r.forEach(candidatecompetencyRecord => {
          if (candidatecompetencyRecord.sirenum__TicketType__c === competencyRecord.sirenum__TicketType__c) {
            matchFound = true;
          }
        });
      }

      if (!matchFound) {
        if (competencyRecord.sirenum__Severity__c == 'Fatal' && this.showfatalerror == false) {
          this.showfatalerror = true;
        }
        this.unmatchedCompetencyRecords.push(competencyRecord);

      }
    });

    console.log('Unmatched Competency Records:', this.unmatchedCompetencyRecords.length);
    if (this.unmatchedCompetencyRecords.length > 0) {
      this.alteredCompetencyRecords = [...this.unmatchedCompetencyRecords];
      const unmatchedSkillsNames = this.unmatchedCompetencyRecords.map(ucr => {
        return {
          key: ucr.sirenum__TicketType__c,
          name: ucr.sirenum__TicketType__r.Name
        };
      });
      this.Searchcandidatescreenmsg = unmatchedSkillsNames;
      this.searchscreenerrormsg = true;

    }
    else {
      //this.Searchcandidatescreenmsg = '';
      this.searchscreenerrormsg = false;
    }
    this.show2ndTierCandidatedetail = true;
    console.log(' alteredCompetencyRecordslength after sortingunmatchedcompetencies :', this.alteredCompetencyRecords.length);
  }

  handleSubmitCandidate() {
    // this.showToast('Success', 'here in handleSubmitCandidate', 'success');
    if (this.showfatalerror == true) {
      LightningAlert.open({
        message: 'Fatal Skill missing. Please ensure your candidate has this required skill before submitting',
        theme: 'info',
        label: 'Error!',
      });
    }
    else {
      createCandidateRecord({
        contactId: this.newcandidaterecid,
        joborderId: this.joborderdetaildata.Id
      })
        .then(() => {
          this.showToast('Success', 'Candidate Submitted successfully', 'success');
          this.show2ndTierCandidatedetail = false;
          this.selected2ndTierCandidatedata = [];
          this.getsubmittedcandidates();
        })
        .catch((error) => {
          console.log("Candidate Submit Record Error: ", error);
          this.showToast('Error', 'Candidate Submitted Error', 'error');
        });
    }
  }

  handledeclinejoborder() {
    sendJobOrderDeclineEmail({ jobOrderId: this.joborderdetaildata.Id })
      .then(data => {
        this.showToast('Success', 'Job Order rejected successfully', 'success');
        window.location.reload();
      })
      .catch(error => {
        console.log('error: ', JSON.stringify(error));
        this.showToast('Error', 'Error on sending Email'+ error, 'error');
      });

  }


}
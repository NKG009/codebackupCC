import { LightningElement, api, wire, track } from "lwc";
import getAllJobOrders from "@salesforce/apex/portalV2VMSClientJobOrdercontroller.getAllJobOrders";
import fetchAdjustableColumns from "@salesforce/apex/portalV2VMSClientJobOrdercontroller.fetchAdjustableColumns";
import { getCookie, isViewOnlyUser, createErrorLog } from "c/portalV2Utility";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import PORTAL_TYPE_FIELD from "@salesforce/schema/Contact.Portal_Type__c";
import USER_ID from "@salesforce/user/Id";
import getCurrentCommunityUrl from '@salesforce/apex/PortalV2MyJobOrdersController.getCommunityBaseUrl';
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import { refreshApex } from "@salesforce/apex";



export default class PortalV2VMSClientJobOrder extends LightningElement {
    @track mainTableColumnStatus = [];
    hasRecords = false;
    @track allJobOrderRecords = [];
    @track filteredShifts = [];
    theTableMessage = '';
    shownewcreatebutton=false;
    communityBaseUrl = '';
    openTextFilterModal = false;
  openDateFilterModal = false;
  filterClickType = "";
  filterColumnLabel = "";
  filterTerms = [];
  @track activeFilterTerms = [];
  columnsDataMap = new Map();

    isModalOpen = false; 
    flowApiName = 'VMS_Client_Community_Create_Job_Order'; 
    filterIcon = SITE_ASSETS + "/img/icons/filter-dk-grey.svg";
    calendarIcon = SITE_ASSETS + "/img/icons/calendar-dk-grey.svg";

    @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
    user;

    contactRecord;
  
    get contactId() {
      return getFieldValue(this.user.data, CONTACT_ID_FIELD);
    }
    
    @wire(getRecord, {
      recordId: "$contactId",
      fields: [PORTAL_TYPE_FIELD]
    })
    contact(data, error) {
      if (data) {
        this.contactRecord = data;
        
       
      } else if (error) {
        console.error(error);
      }
    }

    // Open modal and run the flow
    openModal() {
        this.isModalOpen = true;
    }

    // Close modal
    async closeModal() {
        const vmsclientportaltype = this.contactRecord.data.fields.Portal_Type__c.value;
            if(vmsclientportaltype ==="VMS - Authorised Booker" || vmsclientportaltype ==null){
              this.shownewcreatebutton=true;
            }
          //this.fetchJobOrderRecords();
         await refreshApex(this.allJobOrderRecords);
          this.filterRows();
          this.isModalOpen = false;
    }

    // Handle flow status change, e.g., when the flow finishes
    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.closeModal(); 
        }
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


    async connectedCallback() {
             this.activeFilterTerms=[{"column":"sirenum__Status__c","filterTerms":["Ongoing"]}];
        try {
           this.getCommunityBaseURL(); 
          const adjustableColumnConfig = await fetchAdjustableColumns();
          this.adjustColumnsConfigurations(adjustableColumnConfig);
          this.fetchJobOrderRecords();
          
          if(this.contactRecord.data !=undefined){
            const vmsclientportaltype = this.contactRecord.data.fields.Portal_Type__c.value;
            if(vmsclientportaltype ==="VMS - Authorised Booker" || vmsclientportaltype ==null){
              this.shownewcreatebutton=true;
            }
          }
          else{
          setTimeout(async () => {
          const vmsclientportaltype = this.contactRecord.data.fields.Portal_Type__c.value;
            if(vmsclientportaltype ==="VMS - Authorised Booker" || vmsclientportaltype ==null){
              this.shownewcreatebutton=true;
            }
          },2000);
        }
    
          // this.loading = false;
        } catch (e) {
          console.error('connectedCallback error:'+ JSON.stringify(e));
          console.error('Error message: ', e.message);
          console.error('Error stack: ', e.stack);
        }
      }

      adjustColumnsConfigurations(adjustableColumnConfig) {
        this.mainTableColumnStatus = [];
        //console.log('jobordr columnbrf:' + JSON.stringify(adjustableColumnConfig));
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
        console.log('fetchJobOrderRecords brf: ');
        getAllJobOrders()
          .then((results) => {
    
            console.log(
              "fetchJobOrderRecords: " + JSON.stringify(results));
            this.hasRecords = results.length > 0 ? true : false;
            if (this.hasRecords === true) {
              this.allJobOrderRecords = results;
              this.flattenShifts();
               this.filterRows();
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
         
    
          const jobOrderRecordsCopy = JSON.parse(JSON.stringify(this.allJobOrderRecords));
    
          jobOrderRecordsCopy.forEach((jobOrder) => {
            let columnsInfo = [];
            this.mainTableColumnStatus.forEach((theColumn) => {
              let theValue = jobOrder[theColumn.fieldAPIName];
              let joLink
    
              if (theColumn.fieldAPIName.includes('__r')) {
                theValue = this.getLookupReferenceData(jobOrder, theColumn.fieldAPIName);
              }
              if(theColumn.fieldAPIName == 'Name'){
                 joLink= this.communityBaseUrl +'/s/joborder/' + jobOrder.Id;
              }
               
              columnsInfo.push({
                display: theColumn.selected,
                key: theColumn.fieldAPIName,
                label: theColumn.column,
                value: theValue,
                isText: theColumn.type === "Text",
                isDate: theColumn.type === "Date",
                isNumber: theColumn.type === "Number",
                isJobTitle: theColumn.fieldAPIName == 'Name' ? true : false,
                JobOrderLink:joLink
              });
            });
    
            jobOrder.columns = columnsInfo;
          });
    
          this.allJobOrderRecords = jobOrderRecordsCopy;
    
          console.log('this.allJobOrderRecords: ', JSON.stringify(this.allJobOrderRecords));
    
          this.filteredShifts = JSON.parse(JSON.stringify(this.allJobOrderRecords));
        } catch (error) {
          console.error('Error while flattening shifts: ', error);
          console.error('Error message: ', error.message);
          console.error('Error stack: ', error.stack);
        }
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
        console.log(
          '+++++Active filters:'+JSON.stringify(this.activeFilterTerms)
        );
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
    
    
     
}
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api, track } from "lwc";
import search from "@salesforce/apex/portalV2JobRoleLookupFilteredController.search";
import { getLookupReferenceData } from "c/portalV2MyShiftsUtility";
const DELAY = 300;
export default class portalV2JobRoleLookupFiltered extends LightningElement {
  @api valueId;
  @api valueName;
  @api objName = "sirenum__Team__c";
  @api iconName = "custom:custom47";
  @api labelName;
  @api readOnly = false;
  @api currentRecordId;
  @api placeholder = "Search";
  @api createRecord;
  @api fields = ["Name"];
  @api displayFields = "Name, Rating, AccountNumber";
  @api objectLabel = "Job Role";
  @api accountId;
  @track error;

  searchTerm = "";
  delayTimeout;

  searchRecords = [];
  selectedRecord;

  isLoading = false;
  isFocused = false;

  field;
  field1;
  field2;

  ICON_URL =
    "/apexpages/slds/latest/assets/icons/{0}-sprite/svg/symbols.svg#{1}";

  connectedCallback() {
    let icons = this.iconName.split(":");
    this.ICON_URL = this.ICON_URL.replace("{0}", icons[0]);
    this.ICON_URL = this.ICON_URL.replace("{1}", icons[1]);
    let fieldList;
    if (!Array.isArray(this.displayFields)) {
      fieldList = this.displayFields.split(",");
    } else {
      fieldList = this.displayFields;
    }

    this.field = fieldList[0].trim();
    if (fieldList.length > 1) {
      this.field1 = fieldList[1].trim();
    }
    if (fieldList.length > 2) {
      this.field2 = fieldList[2].trim();
    }
    let combinedFields = [];
    fieldList.forEach((field) => {
      if (!this.fields.includes(field.trim())) {
        combinedFields.push(field.trim());
      }
    });

    this.fields = combinedFields.concat(
      JSON.parse(JSON.stringify(this.fields))
    );
  }

  handleInputChange(event) {
    window.clearTimeout(this.delayTimeout);
    const searchKey = event.target.value;
    //this.isLoading = true;
    this.delayTimeout = setTimeout(() => {
      if (searchKey.length >= 2) {
        search({
          objectName: this.objName,
          fields: this.fields,
          searchTerm: searchKey,
          filterTerm: this.filterTerm
        })
          .then((result) => {
            let stringResult = JSON.stringify(result);
            let allResult = JSON.parse(stringResult);
            allResult.forEach((record) => {
              if (this.field.includes("__r")) {
                record.FIELD1 = getLookupReferenceData(record, this.field);
              } else {
                record.FIELD1 = record[this.field];
              }
              if (this.field1 && this.field1.includes("__r")) {
                record.FIELD2 = getLookupReferenceData(record, this.field1);
              } else {
                record.FIELD2 = record[this.field1];
              }
              if (this.field2 && this.field2.includes("__r")) {
                record.FIELD3 = getLookupReferenceData(record, this.field2);
              } else {
                record.FIELD3 = record[this.field1];
              }
            });
            this.searchRecords = allResult;
          })
          .catch((error) => {
            console.error("Error:", error);
          })
          .finally(() => {
            //this.isLoading = false;
          });
      }
    }, DELAY);
  }

  handleSelect(event) {
    let recordId = event.currentTarget.dataset.recordId;

    let selectRecord = this.searchRecords.find((item) => {
      return item.Id === recordId;
    });
    this.selectedRecord = selectRecord;

    const selectedEvent = new CustomEvent("lookup", {
      bubbles: true,
      composed: true,
      cancelable: true,
      detail: {
        data: {
          record: selectRecord,
          recordId: recordId,
          currentRecordId: this.currentRecordId
        }
      }
    });
    this.dispatchEvent(selectedEvent);
  }

  handleClose() {
    this.selectedRecord = undefined;
    this.searchRecords = [];
    const selectedEvent = new CustomEvent("lookup", {
      bubbles: true,
      composed: true,
      cancelable: true,
      detail: {
        record: undefined,
        recordId: undefined,
        currentRecordId: this.currentRecordId
      }
    });
    this.dispatchEvent(selectedEvent);
  }

  toggleFocus() {
    this.isFocused = !this.isFocused;
  }

  //! Getters
  get showDropdown() {
    return (
      !this.selectedRecord && this.searchRecords.length > 0 && this.isFocused
    );
  }
  get filterTerm() {
    return `Account__c='${this.accountId}'`;
  }
}
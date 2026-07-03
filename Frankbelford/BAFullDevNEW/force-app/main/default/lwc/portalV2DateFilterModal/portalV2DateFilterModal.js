import { LightningElement, api } from "lwc";

export default class PortalV2DateFilterModal extends LightningElement {
  @api
  defaultSelectedDate;
  @api
  column;
  @api
  dateRange;
  @api
  defaultSelectedValues;
  selectedStartDate;
  selectedEndDate;

  connectedCallback() {
    if (this.defaultSelectedDate !== undefined) {
      this.selectedStartDate = this.defaultSelectedDate;
    }
    if (this.defaultSelectedValues !== undefined) {
      this.selectedStartDate = this.defaultSelectedValues.filterTerms.startDate;
      this.selectedEndDate = this.defaultSelectedValues.filterTerms.endDate;
    }
  }

  get cardTitle() {
    return `Filter ${this.column}`;
  }

  handleStartDateSelection(event) {
    const detail = event.detail;
    this.selectedStartDate = detail;
    console.log(`Start date selected: ${this.selectedStartDate}`);
  }
  handleEndDateSelection(event) {
    const detail = event.detail;
    this.selectedEndDate = detail;
    console.log(`End date selected: ${this.selectedEndDate}`);
  }
  applyFilter() {
    this.dispatchEvent(
      new CustomEvent("applyfilter", {
        detail: {
          column: this.column,
          filterTerms: {
            startDate: this.selectedStartDate,
            endDate: this.selectedEndDate
          }
        }
      })
    );
  }

  clearFilter() {
    this.selectedStartDate = undefined;
    this.template.querySelector("c-standalone-date-picker").reset();

    this.dispatchEvent(
      new CustomEvent("resetfilter", {
        detail: { column: this.column, filterTerms: undefined }
      })
    );
  }
  closeHandler() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  get filterButtonDisabled() {
    if (this.dateRange) {
      console.log(`Start: ${this.selectedStartDate}`);
      console.log(`End: ${this.selectedEndDate}`);
      return !(this.selectedStartDate && this.selectedEndDate);
    }
    return !this.selectedStartDate;
  }
}
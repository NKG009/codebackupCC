import { LightningElement, api } from "lwc";

export default class PortalV2FilterModal extends LightningElement {
  //! Component properties
  actualFilterTerms = [];
  actualDefaultSelectedTerms = [];
  @api
  filterClickType = "";
  @api
  columnLabel = "";
  filterData = [];
  selectedRows = [];
  filterDataValues = [];

  @api
  get filterTerms() {
    return this.actualFilterTerms;
  }

  set filterTerms(value) {
    this.actualFilterTerms = [...value].sort();
    // this.actualFilterTerms = this.actualFilterTerms.sort();
    this.removeDuplicates();
  }

  @api
  get defaultSelectedValues() {
    return this.actualDefaultSelectedTerms;
  }

  set defaultSelectedValues(value) {
    this.actualDefaultSelectedTerms = value;
  }
  // connectedCallback() {
  //   this.removeDuplicates();
  // }

  filterArrayByTerm(event) {
    const filterTermCopy = [...this.filterData];
    let filteredData = [];

    //If the user has pressed backspace until the input is cleared, reset the filter
    if (event.target.value === "") {
      this.clearFilter();
      return;
    }

    filteredData = filterTermCopy.filter((value) => {
      console.log(value);
      return (
        value !== undefined &&
        value.valueToDisplay
          .toLowerCase()
          .includes(event.target.value.toLowerCase())
      );
    });

    this.filterData = filteredData;
    console.log(filteredData);
  }

  removeDuplicates() {
    const filterTermCopy = [...this.actualFilterTerms];
    let termsWithoutDupes = [];

    termsWithoutDupes = filterTermCopy.filter(
      (value, index, array) => array.findIndex((t) => t === value) === index
    );
    this.filterData = termsWithoutDupes;

    this.filterDataValues = [];
    this.filterData.forEach((value) => {
      this.filterDataValues.push({
        valueToDisplay: value,
        isChecked:
          this.defaultSelectedValues !== undefined
            ? this.defaultSelectedValues.includes(value)
            : false
      });
    });
    this.selectedRows = this.filterDataValues
      .filter((filter) => filter.isChecked === true)
      .map((row) => row.valueToDisplay);
    this.filterData = [...this.filterDataValues];
  }

  get columns() {
    let columns = [];

    columns = [{ label: this.columnLabel, fieldName: this.filterClickType }];

    return columns;
  }

  closeHandler() {
    this.dispatchEvent(new CustomEvent("close"));
  }
  handleRowSelected(event) {
    this.filterData.forEach((filter) => {
      if (filter.isChecked) {
        this.selectedRows.push(filter.valueToDisplay);
      }
    });

    const { filter } = event.target.dataset;
    const checked = event.target.checked;

    if (checked) {
      this.selectedRows.push(filter);
    } else {
      this.selectedRows = this.selectedRows.filter((row) => row !== filter);
    }
    console.log(this.selectedRows);
  }
  handleAllRowsSelected(event) {
    this.template.querySelectorAll("lightning-input").forEach((input) => {
      input.checked = event.target.checked;
    });
    this.filterData.forEach((filter) => {
      filter.isChecked = event.target.checked;
    });
    this.selectedRows = event.target.checked
      ? this.filterData.map((row) => row.valueToDisplay)
      : [];

    console.log(this.selectedRows);
  }
  clearFilter() {
    this.removeDuplicates();
    this.template.querySelector(`[data-id="searchBar"]`).value = "";
    this.selectedRows = [];
    this.template.querySelectorAll("lightning-input").forEach((element) => {
      element.checked = false;
      element.value = "";
    });
    //dispatch the message
    this.dispatchEvent(
      new CustomEvent("resetfilter", {
        detail: {
          column: this.filterClickType,
          filterTerms: [this.actualFilterTerms]
        }
      })
    );
  }

  applyFilter() {
    this.template.querySelectorAll("lightning-input").forEach((element) => {
      element.checked = false;
      element.value = "";
    });
    if (this.selectedRows.length > 0) {
      //dispatch the message
      this.dispatchEvent(
        new CustomEvent("applyfilter", {
          detail: {
            column: this.filterClickType,
            filterTerms: this.selectedRows
          }
        })
      );
      this.selectedRows = [];
    } else {
      this.clearFilter();
    }
  }
}
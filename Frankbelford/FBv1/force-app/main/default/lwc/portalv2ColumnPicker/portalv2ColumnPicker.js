import { LightningElement, api } from "lwc";

export default class Portalv2ColumnPicker extends LightningElement {
  @api
  mainTableColumnSelection = [];
  @api
  subTableColumnSelection = [];
  @api
  hasSecondaryTable = false;
  @api
  hideSectionHeaders = false;
  @api
  pickerTitle = "Adjust Columns";
  mainTableColumnStatus = [];
  subTableColumnStatus = [];

  connectedCallback() {
    //Making a copy because @api variables are readonly and we need to edit them.
    //Copy needs to be made by stringify+parse because spread operator does not deep clone.
    //All js objects will still be treated as being passed by reference.
    this.mainTableColumnStatus = JSON.parse(
      JSON.stringify(this.mainTableColumnSelection)
    );
    this.subTableColumnStatus = JSON.parse(
      JSON.stringify(this.subTableColumnSelection)
    );
  }

  //! Input change events

  handleMainTableCheckboxTick(event) {
    let foundColumn = this.mainTableColumnStatus.find((column) => {
      return column.column === event.target.name;
    });
    foundColumn.selected = event.target.checked;
  }

  handleSubTableCheckboxTick(event) {
    let foundColumn = this.subTableColumnStatus.find((column) => {
      return column.column === event.target.name;
    });
    foundColumn.selected = event.target.checked;
  }

  //! Click handlers

  closeHandler() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  resetToStandard() {
    //reset main table
    this.mainTableColumnStatus.forEach((item) => {
      item.selected = true;
      this.template.querySelector(
        `lightning-input[data-id='${item.column}']`
      ).checked = true;
    });
    //reset sub table
    this.subTableColumnStatus.forEach((item) => {
      this.template.querySelector(
        `lightning-input[data-id='${item.column}']`
      ).checked = true;
      item.selected = true;
    });
    this.applyFilter();
  }

  applyFilter() {
    this.dispatchEvent(
      new CustomEvent("applyfilters", {
        detail: {
          mainTable: this.mainTableColumnStatus,
          subTable: this.subTableColumnStatus
        }
      })
    );
  }
}
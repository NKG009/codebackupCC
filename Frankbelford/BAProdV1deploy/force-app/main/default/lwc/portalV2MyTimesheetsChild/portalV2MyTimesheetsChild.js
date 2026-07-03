import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import getShifts from "@salesforce/apex/TimesheetPageApexController.getShiftsByUserAccountSupplier";
import getPastShifts from "@salesforce/apex/TimesheetPageApexController.getPastShiftsByUserAccountSupplier";
import getRatings from "@salesforce/apex/ShiftPageApexController.getRatings";
import fetchAdjustableColumns from "@salesforce/apex/TimesheetPageApexController.fetchAdjustableColumns";
import defaultPageSize from "@salesforce/label/c.Portal_V2_Default_Page_Size";

import { registerListener } from "c/pubsub";
import { getCookie, setCookie, showMessageToUser } from "c/portalV2Utility";
import {
  generateRating,
  getLookupReferenceData
} from "c/portalV2MyShiftsUtility";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

export default class PortalV2MyTimesheetsChild extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  //! Assets
  filterIcon = SITE_ASSETS + "/img/icons/filter-dk-grey.svg";
  calendarIcon = SITE_ASSETS + "/img/icons/calendar-dk-grey.svg";
  paginationLeft = SITE_ASSETS + "/img/icons/left-dk-grey-caret.svg";
  paginationRight = SITE_ASSETS + "/img/icons/right-dk-grey-caret.svg";
  primaryAnchorCaret = SITE_ASSETS + "/img/icons/primary-anchor-caret.svg";
  primaryAnchorCaretOpen =
    SITE_ASSETS + "/img/icons/primary-anchor-caret-down.svg";

  //!Component properties
  @api
  siteId;
  @api
  groupingColumnName;
  @api
  defaultTimescale;

  currentShiftView = true;
  @track
  shifts = [];
  @track
  pastShifts = [];
  @track
  paginatedResults = [];
  @track
  filteredShifts = [];
  textFilterModalOpen = false;
  filterClickType = "";
  activeFilters = [];
  adjustColumnsModalOpen = false;
  mainTableColumnStatus = [];
  subTableColumnStatus = [];
  dateFilterModalOpen = false;
  filterColumnLabel;
  filterTerms;
  loading = true;

  currentLookbackTimescale = "1";

  localSiteId;

  //!Getters
  get defaultSelectedDate() {
    return new Date();
  }

  get currentFilterSelectedTerms() {
    return this.activeFilters.find(
      (filter) => filter.column === this.filterClickType
    )?.filterTerms;
  }

  @api
  get mainSelectedRows() {
    if (!this.filteredShifts) {
      return [];
    }
    return this.filteredShifts.filter((shift) => shift.selected);
  }

  @api
  get subSelectedRows() {
    if (!this.filteredShifts) {
      return [];
    }
    const selectedMainRows = this.filteredShifts.filter(
      (shift) => shift.selected
    );
    const selectedSubRows = [];

    selectedMainRows.forEach((shift) => {
      shift.shifts.forEach((subShift) => {
        if (subShift.selected) {
          selectedSubRows.push(subShift);
        }
      });
    });
    return selectedSubRows;
  }

  get mainTableColumnCount() {
    return (
      this.mainTableColumnStatus.filter((column) => column.selected).length + 1
    );
  }

  get subTableColumnCount() {
    return (
      this.subTableColumnStatus.filter((column) => column.selected).length + 2
    );
  }

  @api
  get lookbackTimescale() {
    return this.currentLookbackTimescale;
  }

  set lookbackTimescale(value) {
    this.currentLookbackTimescale = value;

    //Using .then syntax due to async setter syntax not existing
    this.loading = true;
    this.getPastShifts()
      .then(() => {
        this.numRecordsChanged();
        this.initPagination(this.shiftArray);
        this.loading = false;
      })
      .catch((error) => {
        console.error(error);
        this.loading = false;
        showMessageToUser(
          "error",
          "An unexpected error occurred. If this continues, please contact your system administrator.",
          this
        );
      });
  }

  get shiftArray() {
    return this.currentShiftView ? this.shifts : this.pastShifts;
  }

  async connectedCallback() {
    try {
      this.localSiteId = this.siteId;
      registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);

      const adjustableColumnConfig = await fetchAdjustableColumns();
      this.adjustColumnsConfigurations(adjustableColumnConfig);
      this.refreshData();
      this.getShifts();
      //on load default the timescale to the one specified at the parent level
      // this.toggleTimePeriod(this.defaultTimescale);
    } catch (e) {
      console.error(e);
      this.loading = false;
    }
  }

  adjustColumnsConfigurations(adjustableColumnConfig) {
    let theIcon;
    const cookie = getCookie("jobRoleColumnPreferences");
    const parsedCookie = cookie !== "" ? JSON.parse(cookie) : {};
    const hasCookie = cookie !== "";

    const mainTableFromCookie = parsedCookie.mainTable;
    const subTableFromCookie = parsedCookie.subTable;
    const mainTableColumns = adjustableColumnConfig.filter((column) => {
      return column.View__c === "Job Role" && column.Table_Type__c === "Main";
    });
    const subTableColumns = adjustableColumnConfig.filter((column) => {
      return column.View__c === "Job Role" && column.Table_Type__c === "Sub";
    });
    mainTableColumns.forEach((column) => {
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
        type: column.Type__c,
        dateFilterType: column.Date_filter_type__c,
        rollup: column.Rollup_from_children__c,
        rollupColumnName: column.Child_Column_Name__c,
        aggregateType: column.Aggregate_type__c
      });
      if (hasCookie) {
        // populate from cookie
        const columnFromCookie = mainTableFromCookie.find(
          (item) => item.column === column.MasterLabel
        );
        if (columnFromCookie) {
          this.mainTableColumnStatus[
            this.mainTableColumnStatus.length - 1
          ].selected = mainTableFromCookie.find(
            (item) => item.column === column.MasterLabel
          ).selected;
        }
      }
    });
    subTableColumns.forEach((column) => {
      if (column.Filter_Type__c === "Date") {
        theIcon = this.calendarIcon;
      } else if (column.Filter_Type__c === "Text") {
        theIcon = this.filterIcon;
      } else {
        theIcon = "";
      }
      this.subTableColumnStatus.push({
        column: column.MasterLabel,
        selected: column.Selected_By_Default__c,
        filterable: column.Filterable__c,
        filterType: column.Filter_Type__c,
        filterIcon: theIcon,
        fieldAPIName: column.Field_API_Name__c,
        type: column.Type__c,
        includeInRatingModal: column.Include_in_temp_feedback_modal__c
      });
      if (hasCookie) {
        // populate from cookie
        const columnFromCookie = subTableFromCookie.find(
          (item) => item.column === column.MasterLabel
        );
        if (columnFromCookie) {
          this.subTableColumnStatus[
            this.subTableColumnStatus.length - 1
          ].selected = subTableFromCookie.find(
            (item) => item.column === column.MasterLabel
          ).selected;
        }
      }
    });
  }

  async getShifts() {
    console.log('============================getShifts running');
    try {
      console.time("process");
      this.loading = true;
      //Get Shifts based on which view we are currently in
      const results = await Promise.all([
        new Promise((resolve) => resolve(this.getCurrentShifts())),
        new Promise((resolve) => resolve(this.getPastShifts()))
      ]);
      this.numRecordsChanged();
      this.initPagination(this.shiftArray);
      this.loading = false;
      console.timeEnd("process");
    } catch (e) {
      this.loading = false;
      console.error(e);
    }
  }

  async getCurrentShifts() { 
    const currentShifts = await getShifts({
      contactId: null
    });

    //Build a list of contacts for the shifts
    const contactIds = currentShifts.map((shift) => shift?.sirenum__Contact__c);

    //Get the ratings
    const retrievedCurrentRatings = await getRatings({
      contactIds: contactIds
    });

    this.shifts = this.flattenShifts(currentShifts, retrievedCurrentRatings);
    console.log('=======================&&&&& shifts '+JSON.stringify(this.shifts));
  }

  async getPastShifts() {
    const pastShifts = await getPastShifts({
      contactId: null,
      timescale: this.currentLookbackTimescale
    });

    const pastContactIds = pastShifts.map(
      (shift) => shift?.sirenum__Contact__c
    );

    const retrievedPastRatings = await getRatings({
      contactIds: pastContactIds
    });

    this.pastShifts = this.flattenShifts(pastShifts, retrievedPastRatings);
    console.log('=======================&&&& pastShifts '+JSON.stringify(this.pastShifts));
  }

  flattenShifts(retrievedShifts, retrievedRatings) {
    let sortedShifts = [];

    retrievedShifts.forEach((shift) => {
      //Generate ratings
      const ratings =
        retrievedRatings[shift.sirenum__Contact__c] !== undefined
          ? retrievedRatings[shift.sirenum__Contact__c].map(
            (rating) => rating.sirenum__Score__c
          )
          : [];

      // Find a match for the shifts
      const filteredShift = sortedShifts.find((sortedShift) => {
        //Get relevant column
        const column = sortedShift.columnInfo.find(
          (item) => item.column === 'Name'
        );
        if(column != undefined){
        const shiftValue = getLookupReferenceData(shift, column.key);
        return column.value === shiftValue;
        }
      });
      // if there is a match
      if (filteredShift !== undefined) {
        this.generateChildShift(shift, filteredShift, ratings);
      } else {
        const shiftObject = this.generateTopLevelShift(shift, ratings);
        sortedShifts.push(shiftObject);
      }
      
      // this.shifts = sortedShifts;
      // console.log(this.filteredShifts);
    });

    return sortedShifts;
    // this.numRecordsChanged();
    // this.initPagination(this.shifts);
  }

  generateTopLevelShift(shift, ratings) {
    const columnInfo = [];

    //Create the shift object
    const shiftObject = {
      Id: shift.Id,
      columnInfo: columnInfo,
      jobRoleId: shift.sirenum__Team__c,
      filled: shift.sirenum__Contact__r ? true : false,
      get fulfilmentClass() {
        const filled = this.numFilled;
        switch (filled) {
          case 0:
            return "fulfilment body-text red-button";
          case this.totalShifts:
            return "fulfilment body-text green-button";
          default:
            return "fulfilment body-text yellow-button";
        }
      },
      get numFilled() {
        //change to reduce
        return 0;
      },
      get fulfilment() {
        return `${this.numFilled} of ${this.totalShifts}`;
      },
      get totalShifts() {
        return 0;
      },
      hidden: true,
      shifts: []
    };
    //Loop through each column and init values
    this.mainTableColumnStatus.forEach((column) => {
      let value = shift[column.fieldAPIName];
      if (column.fieldAPIName.includes("__r.")) {
        value = getLookupReferenceData(shift, column.fieldAPIName);
      }

      const columnObj = {
        selected: column.selected,
        key: column.fieldAPIName,
        label: column.column,
        value: value,
        isText: column.type === "Text",
        isDate: column.type === "Date",
        isTime: column.type === "Time",
        isFulfilment: column.fieldAPIName === "Fulfilment",
        type: column.type,
        rollup: column.rollup,
        rollupColumnName: column.rollupColumnName,
        aggregateType: column.aggregateType
      };

      //Add in job role id if the field is job role
      if (
        column.fieldAPIName === "sirenum__Team__r.sirenum__Job_Type__r.Name"
      ) {
        columnObj.recordId = shift.sirenum__Team__c;
      }

      columnInfo.push(columnObj);
    });
    this.generateChildShift(shift, shiftObject, ratings);

    return shiftObject;
  }

  generateChildShift(shift, parent, ratings) {    
    const avgRating = generateRating(ratings);

    if (shift.sirenum__Timesheet_Lines__r) {
      shift.sirenum__Timesheet_Lines__r.forEach((demandChild) => {
          var columnInfo = [];
          const shiftObject = {
            parentId: parent.Id,
            hidden: true,
            filled: shift.sirenum__Contact__r ? true : false,
            recordId: shift.Id,
            contactId: shift?.sirenum__Contact__c,
            site: shift?.sirenum__Site__c,
            name: shift?.sirenum__Contact__r?.Name,
            rating: shift.Rankings__r ? shift.Rankings__r[0] : undefined,
            tempRating: Math.round(avgRating),
            tempRatingLength: ratings.length,
            totalRequested: shift.sirenum__Broadcasts__c ? shift.sirenum__Broadcasts__c: 1,
            numFilled: 0, 
            shifts: [],
            get hasRating() {
              return ratings.length > 0;
            },
            get fulfilmentClass() {
              const remaining = shift.sirenum__Broadcasts__c ? shift.Remaining_Shifts__c : shift.sirenum__Contact__r ? 0: 1;
              switch (remaining) {
                case 0:
                  return "fulfilment body-text green-button";
                case shift.sirenum__Broadcasts__c:
                  return "fulfilment body-text red-button";
                case 1:
                  return "fulfilment body-text red-button";
                default:
                  return "fulfilment body-text yellow-button";
              }
            },
            get fulfilment() {
              let fulfilmentString = "";
              if (shift.sirenum__Broadcasts__c) {
                fulfilmentString = `${shift.sirenum__AssignedShifts__c} of ${shift.sirenum__Broadcasts__c}`;
              } else {
                fulfilmentString = `${shift.sirenum__Contact__r ? 1 : 0} of 1`;
              }
              return fulfilmentString;
            },
            get displayTable() {
              return this.hidden === false && this.shifts.length > 0;
            },
            get showOpenCaret() {
              return this.hidden === false && this.shifts.length > 0;
            },
            get showClosedCaret() {
              return this.hidden === true && this.shifts.length > 0;
            },
            columnInfo: columnInfo
          };
          parent.shifts.push(shiftObject);

          this.subTableColumnStatus.forEach((column) => {
            if (column.fieldAPIName.includes("__r.")) {
              const fieldInfo = column.fieldAPIName.split(".");
              let lookupField = fieldInfo[1];
              let value = demandChild[lookupField];
              const columnObj = {
                selected: column.selected,
                key: column.fieldAPIName,
                label: column.column,
                value: value,
                isText: column.type === "Text",
                isDate: column.type === "Date",
                isTime: column.type === "Time",
                isRating: column.fieldAPIName === "Rating",
                isFulfilment: column.fieldAPIName === "Fulfilment",
                includeInRatingModal: column.includeInRatingModal
              };
              columnInfo.push(columnObj);
            }else{
              let value = shift[column.fieldAPIName];
              const columnObj = {   
                selected: column.selected,
                key: column.fieldAPIName,
                label: column.column,
                value: value,
                isText: column.type === "Text",
                isDate: column.type === "Date",
                isTime: column.type === "Time",
                isRating: column.fieldAPIName === "Rating",
                isFulfilment: column.fieldAPIName === "Fulfilment",
                includeInRatingModal: column.includeInRatingModal
              };
              columnInfo.push(columnObj);
            }
          });
      });
    }
    const rollupColumns = parent.columnInfo.filter((col) => col.rollup);
    rollupColumns.forEach((col) => {
      this.calculateRollupColumn(parent, col);
    });
  }

  calculateRollupColumn(parent, col) {
    const { rollupColumnName, aggregateType } = col;

    var value = 0;

    parent.shifts.forEach((shift) => {
      const column = shift.columnInfo.find(
        (item) => item.label === rollupColumnName
      );
      if (aggregateType === "Average") {
        value = value + column.value;
      } else if (aggregateType === "Lowest") {
        if (col.type === "Date") {
          const colValueAsDate = new Date(column.value);
          if (!(value instanceof Date)) {
            value = colValueAsDate;
          }
          if (value > colValueAsDate) {
            value = colValueAsDate;
          }
        } else if (value > column.value) {
          value = column.value;
        }
      } else if (aggregateType === "Highest") {
        if (col.type === "Date") {
          const colValueAsDate = new Date(column.value);
          if (!(value instanceof Date)) {
            value = colValueAsDate;
          }
          if (value < colValueAsDate) {
            value = colValueAsDate;
          }
        } else if (value < column.value) {
          value = column.value;
        }
      }
    });
    if (aggregateType === "Average") {
      value = value / parent.shifts.length;
    }

    col.value = value;
  }

  numRecordsChanged() {
    const numRecords = this.shiftArray.length;
    this.dispatchEvent(
      new CustomEvent("numrecordchanged", { detail: numRecords })
    );
  }

  initPagination(results) {
    let paginatedResults = [];
    let page = [];
    let nextPageNumber = 1;
    const pageSize = parseInt(defaultPageSize, 10);
    //add to the appropriate page
    results.forEach((record) => {
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
    //then default to the first page
    this.changePages(1);
  }
  //! Click handlers

  handleFilterClick(event) {
    this.dateFilterModalOpen = false;
    this.textFilterModalOpen = false;

    let filterType = event.target.alt;
    if (filterType === "Date") {
      this.dateFilterModalOpen = true;
    } else if (filterType === "Text") {
      this.textFilterModalOpen = true;
    }

    const filteredColumn = this.shiftArray.map((shift) => {
      return shift.columnInfo.filter((column) => {
        return column.key === event.target.name;
      });
    });

    this.filterTerms = Array.from(
      new Set([].concat.apply([], filteredColumn).map((term) => term.value))
    );
    this.filterColumnLabel = filteredColumn[0][0].label;
    this.filterClickType = filteredColumn[0][0].label;
  }

  toggleSubTableShow(event) {
    var shiftCopy = [...this.filteredShifts];
    const id = event.target.name;

    const record = shiftCopy.find((shift) => {
      return shift.Id.includes(id);
    });
    record.hidden = !record.hidden;
    record.shifts.forEach((shift) => {
      shift.selected = false;
    });

    //using a copy to force a re-render
    this.filteredShifts = shiftCopy;
  }

  toggleDemandTableShow(event) {
    var shiftCopy = [...this.filteredShifts];
    const parentId = event.target.name;
    const { id } = event.target.dataset;
    var shiftCopy = [...this.filteredShifts];

    const record = shiftCopy.find((shift) => {
      return shift.Id.includes(parentId);
    });
    const childRecord = record.shifts.find((shift) => {
      return shift.recordId === id;
    });
    childRecord.hidden = !childRecord.hidden;

    //using a copy to force a re-render
    this.filteredShifts = shiftCopy;
  }

  handleMainSelectAll(event) {
    const checkboxes = this.template.querySelectorAll(
      'lightning-input[data-role="main"]'
    );

    checkboxes.forEach((checkbox) => {
      checkbox.checked = event.target.checked;
    });

    this.filteredShifts.forEach((shift) => {
      shift.selected = event.target.checked;
    });
  }

  handleSubSelectAll(event) {
    const { parent } = event.target.dataset;

    const checkboxes = this.template.querySelectorAll(
      `lightning-input[data-role="sub"][data-parent="${parent}"]`
    );

    checkboxes.forEach((checkbox) => {
      checkbox.checked = event.target.checked;
    });

    const parentItem = this.filteredShifts.find((shift) => shift.Id === parent);
    parentItem.shifts.forEach((shift) => {
      shift.selected = event.target.checked;
    });
  }

  handleSingleSelection(event) {
    const { id } = event.target.dataset;
    //using a copy to force a re-render
    const filteredShifts = [...this.filteredShifts];
    const selectedItem = this.filteredShifts.find((shift) => shift.Id === id);
    selectedItem.selected = event.target.checked;

    const allSelected =
      this.filteredShifts.filter((shift) => shift.selected).length ===
      this.filteredShifts.length;
    const selectallCheckbox = this.template.querySelector(
      'lightning-input[data-id="all__checkbox"]'
    );
    if (allSelected) {
      selectallCheckbox.checked = true;
    } else {
      selectallCheckbox.checked = false;
    }
    this.filteredShifts = filteredShifts;
  }

  handleSubtableSingleSelection(event) {
    const { id, parent } = event.target.dataset;
    //using a copy to force a re-render
    const filteredShifts = [...this.filteredShifts];
    const selectedItem = filteredShifts.find((shift) => shift.Id === parent);
    const selectedSubItem = selectedItem.shifts.find(
      (shift) => shift.recordId === id
    );
    selectedSubItem.selected = event.target.checked;
    console.log(selectedSubItem.selected);
    const parentChecked =
      selectedItem.shifts.filter((shift) => shift.selected).length > 0;
    selectedItem.selected = parentChecked;

    const allSelected =
      selectedItem.shifts.filter((shift) => shift.selected).length ===
      selectedItem.shifts.length;
    const selectallCheckbox = this.template.querySelector(
      'lightning-input[data-id="selectAll"]'
    );
    if (allSelected) {
      selectallCheckbox.checked = true;
    } else {
      selectallCheckbox.checked = false;
    }
    this.filteredShifts = filteredShifts;
  }

  handleResetFilter(event) {
    console.log(JSON.stringify(event.detail));
    this.activeFilters = this.activeFilters.filter(
      (filter) => filter.column !== event.detail.column
    );
    if (this.textFilterModalOpen) {
      let eventDetail = event;
      eventDetail.detail.filterTerms = eventDetail.detail.filterTerms[0];
      this.handleApplyFilter(eventDetail);
    } else if (this.dateFilterModalOpen) {
      this.handleApplyFilter(event);
    }
    this.dateFilterModalOpen = false;
    this.textFilterModalOpen = false;
  }

  //! Event handlers
  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.localSiteId = eventPayload;
    }

    this.refreshData();
  }

  handleFilterModalClose() {
    this.textFilterModalOpen = false;
    this.dateFilterModalOpen = false;
    this.filterClickType = "";
  }

  handleDateFilterModalClose() {
    this.dateFilterModalOpen = false;
    this.filterClickType = "";
  }

  handleCloseColumnModal() {
    this.adjustColumnsModalOpen = false;
  }

  handleApplyFilter(event) {
    let filteredShifts = JSON.parse(JSON.stringify(this.shiftArray));
    let currentFilters = [...this.activeFilters];
    const eventDetail = event.detail;

    //reset the current column's filter
    let currentColumnFilter = currentFilters.find(
      (filter) => filter.column === eventDetail.column
    );

    if (!currentColumnFilter) {
      currentFilters.push({
        column: eventDetail.column,
        filterTerms: []
      });
      //get the newly pushed entry to the array
      currentColumnFilter = currentFilters[currentFilters.length - 1];
    }

    currentColumnFilter.filterTerms = eventDetail.filterTerms;
    this.activeFilters = currentFilters;
    this.activeFilters.forEach((filter) => {
      const filterColumn = this.mainTableColumnStatus.find(
        (col) => col.column === filter.column
      );
      if (filterColumn.filterType === "Text") {
        filteredShifts = filteredShifts.filter((value) => {
          //Get the relevant column for the value
          const column = value.columnInfo.find((item) => {
            return item.label === filter.column;
          });
          return filter.filterTerms.includes(column.value);
        });
      } else if (
        filterColumn.filterType === "Date" &&
        filter.filterTerms !== undefined
      ) {
        if (filterColumn.dateFilterType === "Greater than") {
          // if (filter.filterTerms !== undefined) {
          filteredShifts = filteredShifts.filter((value) => {
            const column = value.columnInfo.find((item) => {
              return item.label === filter.column;
            });
            return (
              new Date(column.value).setUTCHours(0, 0, 0, 0).valueOf() >=
              new Date(filter.filterTerms.startDate).valueOf()
            );
          });
          // }
        } else if (filterColumn.dateFilterType === "Less than") {
          filteredShifts = filteredShifts.filter((value) => {
            const column = value.columnInfo.find((item) => {
              return item.label === filter.column;
            });
            return (
              new Date(column.value).setUTCHours(0, 0, 0, 0) <=
              new Date(filter.filterTerms.startDate)
            );
          });
        }
      }
    });

    this.filteredShifts = filteredShifts;
    this.handleFilterModalClose();
  }

  handleColumPickerFilter(event) {
    const detail = event.detail;

    this.shiftArray.forEach((shift) => {
      const colInfo = shift.columnInfo;
      colInfo.forEach((col) => {
        const relevantCol = detail.mainTable.find(
          (item) => item.column === col.label
        );
        col.selected = relevantCol.selected;
      });

      shift.shifts.forEach((child) => {
        const childColInfo = child.columnInfo;
        childColInfo.forEach((col) => {
          const relevantCol = detail.subTable.find(
            (item) => item.column === col.label
          );
          col.selected = relevantCol.selected;
        });
      });
    });

    this.mainTableColumnStatus = detail.mainTable;
    this.subTableColumnStatus = detail.subTable;
    this.adjustColumnsModalOpen = false;
    //Set the cookie
    console.log("this.mainTableColumnStatus", JSON.stringify(this.mainTableColumnStatus));
    console.log("this.this.subTableColumnStatus", JSON.stringify(this.subTableColumnStatus));

    setCookie("jobRoleColumnPreferences", JSON.stringify(detail), 1000);
  }



  @api
  async refreshData() {    
    try {
      this.loading = true;
      //Blank out the shift lists to ensure a full refresh
      this.shifts = [];
      this.pastShifts = [];
      this.paginatedResults = [];
      this.filteredShifts = [];

      await this.getShifts();
      //on load default the timescale to the one specified at the parent level
      this.toggleTimePeriod(this.defaultTimescale);
    } catch (e) {
      console.error(e);
      this.loading = false;
    }
  }

  @api
  clearAllFilters() {
    this.activeFilters = [];
    this.filteredShifts = this.shiftArray;
  }

  @api
  openColumnSelectorModal() {
    this.adjustColumnsModalOpen = true;
  }

  @api
  changePages(pageNum) {
    this.filteredShifts = this.paginatedResults.find(
      (iteratedPage) => iteratedPage.pageNum === pageNum
    )?.content;
  }

  @api
  toggleTimePeriod(currentShiftView) {
    this.currentShiftView = currentShiftView;
    this.numRecordsChanged();
    this.initPagination(this.shiftArray);
  }

  @api
  exportData() {
    try {
      let csvRows = [];

      let headerRow = [];
      this.mainTableColumnStatus.forEach((column) => {
        if (column.selected === true) {
          headerRow.push(column.column);
        }
      });
      this.subTableColumnStatus.forEach((column) => {
        if (column.selected === true) {
          headerRow.push(column.column);
        }
      });

      //dedupe header row
      csvRows.push([...new Set(headerRow)]);

      //loop through and create array of columns which is composite between parent and child rows
      //then put that in the csv

      this.shiftArray.forEach((shift) => {
        let dataRowMap = {};
        shift.columnInfo.forEach((column) => {
          if(column.selected === true){
          if (column.key === "Fulfilment") {
            dataRowMap[column.label] = shift.fulfilment;
          } else {
            dataRowMap[column.label] = column.value;
          }
          }
        });
        shift.shifts.forEach((child) => {
          let dataRow = [];
          let childDataRowMap = { ...dataRowMap };
          child.columnInfo.forEach((column) => {
             if(column.selected === true){
            if (column.key === "Rating") {
              childDataRowMap[column.label] = child.tempRating;
            } else {
              childDataRowMap[column.label] = column.value;
            }
             }
          });
          Object.keys(childDataRowMap).forEach((key) => {
            dataRow.push(childDataRowMap[key]);
          });
          csvRows.push(dataRow);
        });
      });

      let csvContent = "data:text/csv;charset=utf-8,";

      csvRows.forEach((rowArray) => {
        let theRow = rowArray.join(",");
        csvContent += theRow + "\r\n";
      });

      let encodedURI = encodeURI(csvContent);
      let theLink = document.createElement("a");
      theLink.setAttribute("href", encodedURI);
      theLink.setAttribute("download", "Timesheets.csv");
      document.body.appendChild(theLink);
      theLink.click();
    } catch (error) {
      this.showMessageToUser(
        "error",
        "An internal error occurred while trying to export your data. Please contact System Administrator."
      );
      console.error("Export Feature Error: ", error);
    }
  }
}
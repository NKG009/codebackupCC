import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import getShifts from "@salesforce/apex/ShiftPageApexController.getShiftsByUserAccount";
import getPastShifts from "@salesforce/apex/ShiftPageApexController.getPastShiftsByUserAccount";
import getRatings from "@salesforce/apex/ShiftPageApexController.getRatings";
import fetchAdjustableColumns from "@salesforce/apex/ShiftPageApexController.fetchAdjustableColumns";
import defaultPageSize from "@salesforce/label/c.Portal_V2_Default_Page_Size";

import { registerListener } from "c/pubsub";
import {
  getCookie,
  setCookie,
  showMessageToUser,
  createErrorLog
} from "c/portalV2Utility";
import {
  generateRating,
  getLookupReferenceData
} from "c/portalV2MyShiftsUtility";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import Id from "@salesforce/user/Id";
export default class PortalV2MyShiftsCandidateView extends LightningElement {
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
  shifts = [];
  pastShifts = [];
  @track
  filteredShifts = [];
  textFilterModalOpen = false;
  dateFilterModalOpen = false;
  adjustColumnsModalOpen = false;
  filterClickType = "";
  filtercolumnLabel = "";
  activeFilters = [];
  filterTerms = [];
  mainTableColumnStatus = [];
  subTableColumnStatus = [];
  loading = true;
  localSiteId;
  currentLookbackTimescale = "1";
  async connectedCallback() {
    try {
      this.localSiteId = this.siteId;
      registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
      const adjustableColumnConfig = await fetchAdjustableColumns();
      this.adjustColumnsConfigurations(adjustableColumnConfig);

      this.refreshData();
      //await this.getShifts();
      //on load default the timescale to the one specified at the parent level
      //this.toggleTimePeriod(this.defaultTimescale);
      this.loading = false;
    } catch (e) {
      console.error(e);
      createErrorLog(Id, e, undefined);
      this.loading = false;
    }
  }

  adjustColumnsConfigurations(adjustableColumnConfig) {
    let theIcon;
    const cookie = getCookie("candidateColumnPreferences");
    const parsedCookie = cookie !== "" ? JSON.parse(cookie) : {};
    const hasCookie = cookie !== "";
    const mainTableFromCookie = parsedCookie.mainTable;
    const subTableFromCookie = parsedCookie.subTable;
    const mainTableColumns = adjustableColumnConfig.filter((column) => {
      return column.View__c === "Candidate" && column.Table_Type__c === "Main";
    });

    const subTableColumns = adjustableColumnConfig.filter((column) => {
      return column.View__c === "Candidate" && column.Table_Type__c === "Sub";
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

      // populate from cookie
      if (hasCookie) {
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

    console.log(this.mainTableColumnStatus);
  }

  async getShifts() {
    try {
      this.loading = true;
      //Get Shifts based on which view we are currently in
      const results = await Promise.all([
        new Promise((resolve) => resolve(this.getCurrentShifts())),
        new Promise((resolve) => resolve(this.getPastShifts()))
      ]);
      console.log(results);
      this.numRecordsChanged();
      this.initPagination(this.shiftArray);
      this.loading = false;
    } catch (e) {
      createErrorLog(Id, e, undefined);
      console.log(e);
    }
  }

  async getCurrentShifts() {
    try {
      const currentShifts = await getShifts({
        contactId: null,
        siteId: this.localSiteId
      });
      const contactIds = currentShifts.map(
        (shift) => shift?.sirenum__Contact__c
      );
      const retrievedCurrentRatings = await getRatings({
        contactIds: contactIds
      });
      this.shifts = this.flattenShifts(currentShifts, retrievedCurrentRatings);
    } catch (error) {
      createErrorLog(Id, error, undefined);
      console.error(error);
    }
  }
  async getPastShifts() {
    try {
      const pastShifts = await getPastShifts({
        contactId: null,
        siteId: this.localSiteId,
        timescale: this.currentLookbackTimescale
      });
      const pastContactIds = pastShifts.map(
        (shift) => shift?.sirenum__Contact__c
      );
      const retrievedPastRatings = await getRatings({
        contactIds: pastContactIds
      });
      this.pastShifts = this.flattenShifts(pastShifts, retrievedPastRatings);
    } catch (error) {
      createErrorLog(Id, error, undefined);
      console.error(error);
    }
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
          (item) => item.column === this.groupingColumnName
        );
        const shiftValue = getLookupReferenceData(shift, column.key);
        return column.value === shiftValue;
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
    const avgRating = generateRating(ratings);

    //Create the shift object
    const shiftObject = {
      Id: shift.Id,
      columnInfo: columnInfo,
      filled: shift.sirenum__Contact__r ? true : false,
      contactId: shift?.sirenum__Contact__c,
      name: shift.sirenum__Contact__r?.Name,
      tempRating: Math.round(avgRating),
      tempRatingLength: ratings.length,
      get hasRating() {
        return ratings.length > 0;
      },
      hidden: true,
      get currentShifts() {
        return this.shifts.length > 1
          ? `${this.shifts.length} shifts`
          : `${this.shifts.length} shift`;
      },
      shifts: []
    };
    //Loop through each column and init values
    this.mainTableColumnStatus.forEach((column) => {
      let value = shift[column.fieldAPIName];
      if (column.fieldAPIName.includes("__r.")) {
        value = getLookupReferenceData(shift, column.fieldAPIName);
      }
      console.log(value);

      const columnObj = {
        selected: column.selected,
        key: column.fieldAPIName,
        label: column.column,
        value: value,
        isText: column.type === "Text",
        isDate: column.type === "Date",
        isTime: column.type === "Time",
        isRating: column.fieldAPIName === "TempRating",
        isCurrentShift: column.fieldAPIName === "CurrentShifts",
        type: column.type,
        rollup: column.rollup,
        rollupColumnName: column.rollupColumnName,
        aggregateType: column.aggregateType
      };
      columnInfo.push(columnObj);
    });
    this.generateChildShift(shift, shiftObject);

    return shiftObject;
  }

  generateChildShift(shift, parent) {
    let columnInfo = [];

    const shiftObject = {
      parentId: parent.Id,
      filled: shift.sirenum__Contact__r ? true : false,
      contactId: shift?.sirenum__Contact__c,
      name: shift.sirenum__Contact__r?.Name,
      id: parent.shifts.length.toString(),
      recordId: shift.Id,
      rating: shift.Rankings__r ? shift.Rankings__r[0] : undefined,
      site: shift.sirenum__Site__c,
      columnInfo: columnInfo
    };
    parent.shifts.push(shiftObject);

    this.subTableColumnStatus.forEach((column) => {
      let value = shift[column.fieldAPIName];

      if (column.fieldAPIName.includes("__r.")) {
        value = getLookupReferenceData(shift, column.fieldAPIName);
      }
      console.log(value);

      const columnObj = {
        selected: column.selected,
        key: column.fieldAPIName,
        label: column.column,
        value: value,
        isText: column.type === "Text",
        isDate: column.type === "Date",
        isTime: column.type === "Time",
        includeInRatingModal: column.includeInRatingModal
      };
      columnInfo.push(columnObj);
    });

    const rollupColumns = parent.columnInfo.filter((col) => col.rollup);
    rollupColumns.forEach((col) => {
      this.calculateRollupColumn(parent, col);
    });
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
    console.log(paginatedResults);
  }

  numRecordsChanged() {
    const numRecords = this.shiftArray.length;
    this.dispatchEvent(
      new CustomEvent("numrecordchanged", { detail: numRecords })
    );
  }
  //! Button click events
  toggleSubTableShow(event) {
    var shiftCopy = [...this.filteredShifts];
    let id = event.target.name;

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
    console.log(this.filterTerms);
    this.filterColumnLabel = filteredColumn[0][0].label;
    this.filterClickType = filteredColumn[0][0].label;
  }

  handleMainSelectAll(event) {
    //using a copy to force a re-render
    const filteredShifts = this.filteredShifts;
    const checkboxes = this.template.querySelectorAll(
      'lightning-input[data-role="main"]'
    );

    checkboxes.forEach((checkbox) => {
      checkbox.checked = event.target.checked;
    });

    filteredShifts.forEach((shift) => {
      shift.selected = event.target.checked;
    });

    this.filteredShifts = filteredShifts;
  }

  handleSubSelectAll(event) {
    const { parent } = event.target.dataset;
    //using a copy to force a re-render

    const filteredShifts = this.filteredShifts;
    const checkboxes = this.template.querySelectorAll(
      `lightning-input[data-role="sub"][data-parent="${parent}"]`
    );
    const parentCheckbox = this.template.querySelector(
      `lightning-input[data-id="${parent}"]`
    );
    parentCheckbox.checked = event.target.checked;

    checkboxes.forEach((checkbox) => {
      checkbox.checked = event.target.checked;
    });

    const parentItem = filteredShifts.find((shift) => shift.Id === parent);
    parentItem.selected = event.target.checked;
    parentItem.shifts.forEach((shift) => {
      shift.selected = event.target.checked;
    });
    this.filteredShifts = filteredShifts;
  }

  handleSingleSelection(event) {
    const { id } = event.target.dataset;
    //using a copy to force a re-render
    const filteredShifts = [...this.filteredShifts];
    const selectedItem = this.filteredShifts.find((shift) => shift.id === id);
    selectedItem.selected = event.target.checked;
    console.log(selectedItem);

    const allSelected =
      filteredShifts.filter((shift) => shift.selected).length ===
      filteredShifts.length;
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
      (shift) => shift.id === id
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

  //!Getters
  get defaultSelectedDate() {
    return new Date();
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

  //!Event handlers

  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.localSiteId = eventPayload;
    }

    this.refreshData();
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
      console.log(filterColumn.filterType);
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
              new Date(filter.filterTerms).valueOf()
            );
          });
          // }
        } else if (filterColumn.dateFilterType === "Less than") {
          // if (filter.filterTerms !== undefined) {
          filteredShifts = filteredShifts.filter((value) => {
            const column = value.columnInfo.find((item) => {
              return item.label === filter.column;
            });
            return (
              new Date(column.value).setUTCHours(0, 0, 0, 0) <=
              new Date(filter.filterTerms)
            );
          });
          // }
        }
      }
    });

    this.filteredShifts = filteredShifts;
    this.handleFilterModalClose();
  }
  handleFilterModalClose() {
    this.textFilterModalOpen = false;
    this.dateFilterModalOpen = false;
    this.filterClickType = "";
  }

  handleCloseColumnModal() {
    this.adjustColumnsModalOpen = false;
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
    setCookie("candidateColumnPreferences", JSON.stringify(detail), 1000);
  }

  get shiftArray() {
    return this.currentShiftView ? this.shifts : this.pastShifts;
  }

  //! Publically available properties

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
      this.loading = false;
    } catch (e) {
      console.error(e);
      createErrorLog(Id, e, undefined);
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
          if (column.key === "TempRating") {
            dataRowMap[column.label] = shift.tempRating;
          } else if (column.key === "CurrentShifts") {
            dataRowMap[column.label] = shift.currentShifts;
          } else {
            dataRowMap[column.label] = column.value;
          }
        });
        shift.shifts.forEach((child) => {
          let dataRow = [];
          let childDataRowMap = { ...dataRowMap };
          child.columnInfo.forEach((column) => {
            childDataRowMap[column.label] = column.value;
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
      theLink.setAttribute("download", "Shifts.csv");
      document.body.appendChild(theLink);
      theLink.click();
    } catch (error) {
      this.showMessageToUser(
        "error",
        "An internal error occurred while trying to export your data. Please contact System Administrator."
      );
      console.log("Export Feature Error: ", error);
    }
  }
}
import { LightningElement, track, api } from "lwc";
import { updateRecord } from "lightning/uiRecordApi";

import UpdateInvoicePO from "@salesforce/apex/TimeSheetInfoWithPagination.UpdateInvoicePO";

import ID_FIELD from "@salesforce/schema/sirenum__Placement__c.Id";
import PO_NUMBER_FIELD from "@salesforce/schema/sirenum__Placement__c.IP_PurchaseOrderNumber__c";

import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import { addDays } from "c/dateUtility";
import { showMessageToUser } from "c/portalV2Utility";

export default class PortalV2AmendPOModal extends LightningElement {
  primaryAnchorCaret = SITE_ASSETS + "/img/icons/primary-anchor-caret.svg";
  primaryAnchorCaretOpen =
    SITE_ASSETS + "/img/icons/primary-anchor-caret-down.svg";

  @track
  shiftRecords = [];
  loading = true;

  @api
  get selectedShiftRecords() {
    return this.shiftRecords;
  }
  set selectedShiftRecords(value) {
    this.loading = true;
    let shifts = [];
    console.log(JSON.parse(JSON.stringify(value)));
    value.forEach((shift) => {
      const parentId =
        shift.timesheet !== undefined
          ? shift?.timesheet?.Id
          : shift?.splacement?.Id;
      const existingShiftGroup = shifts.find(
        (record) => record.id === parentId
      );
      let shiftObj = {
        id: shift.recordId,
        jobRole: shift.jobRole.Name,
        jobTypeId: shift.jobRole.sirenum__Job_Role__c,
        site: shift.site.Name,
        candidateName: shift.candidate.Name,
        get actualHours() {
          let hours = shift.actualHours;
          const intPart = Math.floor(hours);
          const decPart = hours % 1;

          const minutes = Math.floor(decPart * 60);

          return `${
            intPart === 0 ? "00" : intPart < 10 ? "0" + intPart : intPart
          }:${minutes === 0 ? "00" : minutes < 10 ? "0" + minutes : minutes}`;
        },
        get chargeableHours() {
          let hours = shift.chargeableHours;
          const intPart = Math.floor(hours);
          const decPart = hours % 1;

          const minutes = Math.floor(decPart * 60);

          return `${
            intPart === 0 ? "00" : intPart < 10 ? "0" + intPart : intPart
          }:${minutes === 0 ? "00" : minutes < 10 ? "0" + minutes : minutes}`;
        },
        startDate: shift.startDate,
        endDate: shift.endDate
      };

      if (existingShiftGroup) {
        existingShiftGroup.shifts.push(shiftObj);
      } else {
        shifts.push({
          // id: splacment,
          // startDate: new Date(shift.splacement.sirenum__Start_Date__c),
          // endDate: new Date(shift.splacement.sirenum__End_Date__c),
          jobRole: shiftObj.jobRole,
          site: shiftObj.site,
          candidate: shiftObj.candidateName,
          hidden: true,
          shifts: [shiftObj],
          timesheet: shift.timesheet !== undefined,
          placementStartDate: shift.startDate,
          placementEndDate: shift.endDate,
          timesheetEndDate: shift?.timesheet?.sirenum__Week_Ending__c,

          get startDate() {
            return this.timesheet
              ? this.timesheetStartDate
              : this.placementStartDate;
          },
          get endDate() {
            return this.timesheet
              ? this.timesheetEndDate
              : this.placementEndDate;
          },
          get id() {
            return this.timesheet ? shift.timesheet.Id : shift.splacement.Id;
          },
          get timesheetStartDate() {
            return this.timesheet
              ? addDays(shift?.timesheet?.sirenum__Week_Ending__c, -7)
              : undefined;
          }
        });
      }
    });
    this.shiftRecords = shifts;

    console.log(JSON.parse(JSON.stringify(this.shiftRecords)));
    this.loading = false;
  }

  updateRecords(record) {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = record.id;
    fields[PO_NUMBER_FIELD.fieldApiName] = record.poNumber;

    return updateRecord({ fields });
  }

  async handleApplyClicked() {
    this.loading = true;
    let updatedRecords = [];
    this.shiftRecords.forEach((record) => {
      if (record.timesheet) {
        updatedRecords.push(
          UpdateInvoicePO({
            timeId: record.id,
            InvoicePO: record.poNumber
          })
        );
      } else {
        updatedRecords.push(this.updateRecords(record));
      }
    });

    const result = await Promise.all(updatedRecords);
    console.log(result);
    this.loading = false;

    if (
      result.find((res) => res === "SUCCESS") ||
      result.find((res) => res.apiName === "sirenum__Placement__c")
    ) {
      showMessageToUser(
        "success",
        "Purchase Order has been successfully updated for all shifts for this week.",
        this
      );
    } else {
      showMessageToUser(
        "error",
        "An unexpected error has occurred. Please try again. If the problem persists please contact your consultant.",
        this
      );
    }

    this.closeClicked();
  }

  handlePONumberChange(event) {
    const { id } = event.target.dataset;

    const record = this.shiftRecords.find((shift) => shift.id === id);

    record.poNumber = event.target.value;
  }

  toggleSubTableShow(event) {
    const id = event.target.name;

    const record = this.shiftRecords.find((shift) => {
      return shift.id === id;
    });
    record.hidden = !record.hidden;
  }
  closeClicked() {
    this.dispatchEvent(new CustomEvent("close"));
  }
}
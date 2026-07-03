import { LightningElement, track, api, wire } from "lwc";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import approveRejectShifts from "@salesforce/apex/PortalV2TimesheetsController.approveRejectShifts";
import getEndorsements from "@salesforce/apex/PortalV2TimesheetsController.getEndorsements";
import { showMessageToUser, createErrorLog } from "c/portalV2Utility";
import {
  getRecord,
  deleteRecord,
  createRecord,
  getFieldValue
} from "lightning/uiRecordApi";
import Portal_V2_SM_Approve_Reject_Success from "@salesforce/label/c.Portal_V2_SM_Approve_Reject_Success";
import Portal_V2_SM_Approve_Reject_Error from "@salesforce/label/c.Portal_V2_SM_Approve_Reject_Error";

import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId";
import ACCOUNT_ENDORSEMENT_ENABLED_FIELD from "@salesforce/schema/Account.Enable_Worker_Endorsement__c";

import Id from "@salesforce/user/Id";
export default class PortalV2ApproveAndEndorse extends LightningElement {
  primaryAnchorCaret = SITE_ASSETS + "/img/icons/primary-anchor-caret.svg";
  primaryAnchorCaretOpen =
    SITE_ASSETS + "/img/icons/primary-anchor-caret-down.svg";
  userId = Id;
  @track
  shiftRecords = [];
  loading = true;

  contactRecord;
  accountRecord;
  @wire(getRecord, { recordId: "$userId", fields: [CONTACT_ID_FIELD] })
  user;
  @wire(getRecord, { recordId: "$contactId", fields: [ACCOUNT_ID_FIELD] })
  contact(data, error) {
    if (data) {
      this.contactRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getRecord, {
    recordId: "$accountId",
    fields: [ACCOUNT_ENDORSEMENT_ENABLED_FIELD]
  })
  account(data, error) {
    if (data) {
      this.accountRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  get contactId() {
    return getFieldValue(this.user.data, CONTACT_ID_FIELD);
  }
  get accountId() {
    return getFieldValue(this.contactRecord.data, ACCOUNT_ID_FIELD);
  }

  get endorsementEnabled() {
    return getFieldValue(
      this.accountRecord.data,
      ACCOUNT_ENDORSEMENT_ENABLED_FIELD
    );
  }

  get displayEndorsementColumn() {
    return this.endorsementEnabled;
  }

  get allShiftIds() {
    let shiftIds = [];

    this.shiftRecords.forEach((shift) => {
      let idList = shift.shifts.map((shiftRecord) => shiftRecord.id);
      shiftIds = [...shiftIds, ...idList];
    });

    return shiftIds;
  }
  @api
  get selectedShiftRecords() {
    return this.shiftRecords;
  }
  set selectedShiftRecords(value) {
    this.loading = true;
    let shifts = [];
    console.log(JSON.parse(JSON.stringify(value)));
    value.forEach((shift) => {
      const compositeId =
        shift.jobRole.sirenum__Job_Type__c + shift.candidate.Id + shift.site.Id;
      const existingShiftGroup = shifts.find(
        (record) => record.id === compositeId
      );
      let shiftObj = {
        id: shift.recordId,
        jobRole: shift.jobRole.Name,
        site: shift.site.Name,
        candidateName: shift.candidate.Name,
        actualHours: shift.actualHours ? shift.actualHours : 0,
        chargeableHours: shift.chargeableHours,
        startDate: shift.startDate,
        endDate: shift.endDate
      };
      if (existingShiftGroup) {
        existingShiftGroup.shifts.push(shiftObj);
      } else {
        shifts.push({
          id: compositeId,
          jobRole: shiftObj.jobRole,
          jobTypeId: shift.jobRole.sirenum__Job_Type__c,
          candidateId: shift.candidate.Id,
          siteId: shift.site.Id,
          site: shiftObj.site,
          candidate: shiftObj.candidateName,
          endorsed: false,
          hidden: true,
          shifts: [shiftObj],
          get totalHours() {
            return this.shifts.reduce(
              (previous, current) =>
                previous + (current.actualHours ? current.actualHours : 0),
              0
            );
          },
          get totalChargeableHours() {
            return this.shifts.reduce(
              (previous, current) =>
                previous +
                (current.chargeableHours ? current.chargeableHours : 0),
              0
            );
          },
          get preferredWorkerOptions() {
            return [
              { label: "Preferred", value: true },
              { label: "Not Preferred", value: true }
            ];
          }
        });
      }
    });
    this.shiftRecords = shifts;
    this.getEndorsements();
    console.log(this.shiftRecords);
    this.loading = false;
  }

  async getEndorsements() {
    try {
      const ids = this.shiftRecords.map((shift) => shift.id);
      const result = await getEndorsements({ compositeIds: ids });

      this.shiftRecords.forEach((shift) => {
        const output = result.find((item) => item.Composite_Id__c === shift.id);
        shift.endorsed = output ? true : false;
        if (output) {
          shift.endorsementId = output.Id;
        }
      });
      console.log(JSON.parse(JSON.stringify(this.shiftRecords)));
    } catch (error) {
      createErrorLog(Id, error, undefined);
      console.error(error);
    }
  }

  closeClicked() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  handleEndorsedChange(event) {
    const { id } = event.target.dataset;
    console.log(id);
    const record = this.shiftRecords.find(
      (shiftRecord) => shiftRecord.id === id
    );
    record.endorsed = !record.endorsed;
  }

  toggleSubTableShow(event) {
    const id = event.target.name;

    const record = this.shiftRecords.find((shift) => {
      return shift.id === id;
    });
    record.hidden = !record.hidden;
  }

  removeShift(event) {
    const { id, parent } = event.target.dataset;

    const parentShift = this.shiftRecords.find((shift) => shift.id === parent);

    for (let i = 0; i < parentShift.shifts.length; i++) {
      if (parentShift.shifts[i].id === id) {
        parentShift.shifts.splice(i, 1);
      }
    }
  }
  async approveClicked() {
    let output = [];

    try {
      output = await this.approveShifts();
    } catch (error) {
      createErrorLog(Id, error, undefined);
    }
    console.log(output);
    if (output === "success") {
      const endorsements = [];

      try {
        this.shiftRecords.forEach((shift) => {
          //if endorsed and one doesnt exist, make one
          if (shift.endorsed && !shift.endorsementId) {
            endorsements.push(this.createEndorsement(shift));
          }
          //if not endorsed and one exists, delete it
          else if (!shift.endorsed && shift.endorsementId) {
            endorsements.push(this.deleteEndorsement(shift));
          }
        });

        //success toast
        showMessageToUser(
          "success",
          Portal_V2_SM_Approve_Reject_Success.replace("[STATE]", "approved"),
          this
        );
      } catch (error) {
        let errorMessage = error.split("FIELD_CUSTOM_VALIDATION_EXCEPTION, ");
        if (errorMessage[1]) {
          let theError = errorMessage[1].split(": [");
          if (theError[0]) {
            showMessageToUser("error", theError[0] + ".", this);
          }
        } else {
          showMessageToUser(
            "error",
            Portal_V2_SM_Approve_Reject_Error.replace("[STATE]", "approve"),
            this
          );
        }
        //error toast

        createErrorLog(Id, error, undefined);
      }
      this.loading = false;
      this.dispatchEvent(new CustomEvent("shiftsapproved"));
    } else {
      //error toast
      let errorMessage = output.split("FIELD_CUSTOM_VALIDATION_EXCEPTION, ");
      if (errorMessage[1]) {
        let theError = errorMessage[1].split(": [");
        if (theError[0]) {
          showMessageToUser("error", theError[0] + ".", this);
        }
      } else {
        showMessageToUser(
          "error",
          Portal_V2_SM_Approve_Reject_Error.replace("[STATE]", "approve"),
          this
        );
        createErrorLog(Id, output, undefined);
      }
      this.loading = false;
      this.closeClicked();
    }
  }

  async approveShifts() {
    this.loading = true;
    return approveRejectShifts({
      theShiftIds: this.allShiftIds,
      theState: "approve",
      rejectionReason: null
    });
  }

  async deleteEndorsement(record) {
    return deleteRecord(record.endorsementId);
  }

  async createEndorsement(record) {
    const recordInput = {
      apiName: "Endorsement__c",
      fields: {
        Account__c: this.accountId,
        Candidate__c: record.candidateId,
        Endorsed_By__c: this.userId,
        Endorsement_Date__c: new Date(),
        Job_Category__c: record.jobTypeId,
        Site__c: record.siteId
      }
    };
    console.log(recordInput);
    return createRecord(recordInput);
  }
}
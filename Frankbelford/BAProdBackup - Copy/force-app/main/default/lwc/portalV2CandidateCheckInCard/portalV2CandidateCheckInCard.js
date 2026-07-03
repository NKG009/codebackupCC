import { api, LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";

import { fireEvent, registerListener } from "c/pubsub";
import { getTimeFromIsoString, getDateFromIsoString } from "c/portalV2Utility";

import SHIFT_ID_FIELD from "@salesforce/schema/sirenum__Shift__c.Id";
import SHIFT_ACTUAL_START_TIME_FIELD from "@salesforce/schema/sirenum__Shift__c.sirenum__Actual_Start_Time__c";
import SHIFT_ACTUAL_END_TIME_FIELD from "@salesforce/schema/sirenum__Shift__c.sirenum__Actual_End_Time__c";

export default class PortalV2CandidateCheckInCard extends LightningElement {
  static renderMode = "light"; // the default is 'shadow'
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }
  //String for candidate name
  @api
  shiftId;
  @api
  candidateName;
  //boolean for candidate started shift
  @api
  startedShift;
  //boolean for candidate finished shift
  @api
  finishedShift;

  //boolean for candidate confirmation
  @api
  candidateConfirmedAttendance;
  //scheduled shift start time
  @api
  scheduledStartTime;
  //scheduled shift end time
  @api
  scheduledEndTime;

  hour12 = true;
  startModalOpen = false;
  endModalOpen = false;

  actualShiftStartTime;
  actualShiftEndTime;

  connectedCallback() {
    registerListener(
      "closeCheckinModals",
      this.handleModalOpenedElsewhere,
      this
    );
  }

  //#region getters
  //time shift started
  set timeShiftStarted(value) {
    this.actualShiftStartTime = value;
  }
  @api
  get timeShiftStarted() {
    return this.actualShiftStartTime;
  }

  //time shift finished
  set timeShiftFinished(value) {
    this.actualShiftEndTime = value;
  }
  @api
  get timeShiftFinished() {
    return this.actualShiftEndTime;
  }

  get shiftStartedIcon() {
    return this.startedShift === true ? "action:approval" : "action:reject";
  }
  get shiftFinishedIcon() {
    return this.finishedShift === true ? "action:approval" : "action:reject";
  }
  get shiftStartedIconClassList() {
    return this.startedShift === true ? "accepted-icon" : "rejected-icon";
  }
  get shiftFinishedIconClassList() {
    return this.finishedShift === true ? "accepted-icon" : "rejected-icon";
  }
  get nameTextSize() {
    let nameLength = this.candidateName.length;
    if (nameLength <= 28) {
      return "title-text name-text-large";
    } else if (nameLength > 28 && nameLength <= 51) {
      return "title-text name-text-medium";
    }
    return "title-text";
  }
  get iconSize() {
    const windowSize = window.innerWidth;
    if (windowSize > 1921) {
      return "large";
    }
    return "small";
  }
  get startModalTimePrepopulatedValue() {
    return this.timeShiftStarted
      ? new Date(this.timeShiftStarted).toLocaleTimeString("en-GB")
      : new Date(this.scheduledStartTime).toLocaleTimeString("en-GB");
  }
  get finishModalTimePrepopulatedValue() {
    return this.timeShiftFinished
      ? new Date(this.timeShiftFinished).toLocaleTimeString("en-GB")
      : new Date(this.scheduledEndTime).toLocaleTimeString("en-GB");
  }

  //#endregion

  //#region Click handlers
  handleStartShiftClicked() {
    this.startModalOpen = !this.startModalOpen;
    fireEvent(this.pageRef, "closeCheckinModals", {
      shiftId: this.shiftId,
      start: true
    });
  }
  handleFinishShiftClicked() {
    this.endModalOpen = !this.endModalOpen;
    fireEvent(this.pageRef, "closeCheckinModals", {
      shiftId: this.shiftId,
      start: false
    });
  }
  async submitShiftChange() {
    const fields = {};
    fields[SHIFT_ID_FIELD.fieldApiName] = this.shiftId;
    if (!this.actualShiftStartTime && this.startModalOpen) {
      this.actualShiftStartTime = this.scheduledStartTime;
    }
    if (!this.actualShiftEndTime && this.endModalOpen) {
      this.actualShiftEndTime = this.scheduledEndTime;
    }

    if (this.actualShiftStartTime) {
      fields[SHIFT_ACTUAL_START_TIME_FIELD.fieldApiName] = new Date(
        this.actualShiftStartTime
      ).toISOString();
    }
    if (this.actualShiftEndTime) {
      fields[SHIFT_ACTUAL_END_TIME_FIELD.fieldApiName] = new Date(
        this.actualShiftEndTime
      ).toISOString();
    }
    const recordInput = { fields };
    try {
      //fire event for start of action
      fireEvent(this.pageRef, "actionStarted");
      const output = await updateRecord(recordInput);
      this.startModalOpen = false;
      this.endModalOpen = false;
      fireEvent(this.pageRef, "actionFinished");
      console.log(output);
    } catch (e) {
      fireEvent(this.pageRef, "errorOccurred", { error: e });
    }
  }
  //#endregion

  //#region event handlers
  handleModalOpenedElsewhere(payload) {
    const { shiftId, start } = payload;
    if (this.shiftId === shiftId) {
      if (start) {
        this.endModalOpen = false;
      } else {
        this.startModalOpen = false;
      }
      // return;
    } else {
      this.startModalOpen = false;
      this.endModalOpen = false;
    }
  }
  handleStartTimeChange(event) {
    const value = event.target.value;
    const dateFromIso = getDateFromIsoString(
      new Date(this.scheduledStartTime).toISOString()
    );
    this.actualShiftStartTime = `${dateFromIso}T${value}`;
  }
  handleEndTimeChange(event) {
    try {
      const value = event.target.value;
      const dateFromIso = getDateFromIsoString(
        new Date(this.scheduledEndTime).toISOString()
      );
      this.actualShiftEndTime = `${dateFromIso}T${value}`;
    } catch (e) {
      console.error(e);
    }
  }
  //#endregion
}
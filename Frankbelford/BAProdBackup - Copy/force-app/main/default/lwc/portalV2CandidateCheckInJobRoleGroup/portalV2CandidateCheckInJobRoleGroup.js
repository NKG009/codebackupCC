import { api, LightningElement } from "lwc";

export default class PortalV2CandidateCheckInJobRoleGroup extends LightningElement {
  static renderMode = "light"; // the default is 'shadow'
  @api
  shiftList;
  @api
  jobRoleName;
  @api
  cardType;
  @api
  startTime;
  @api
  endTime;

  //#region getters
  get signedInSummaryValue() {
    const signedInValue = this.shiftList.filter(
      (shift) => shift.startedShift === true
    ).length;
    return `${signedInValue} of ${this.shiftList.length}`;
  }
  get signedOutSummaryValue() {
    const signedOutValue = this.shiftList.filter(
      (shift) => shift.finishedShift === true
    ).length;
    return `${signedOutValue} of ${this.shiftList.length}`;
  }
  get signedInBackgroundClass() {
    const signedInValue = this.shiftList.filter(
      (shift) => shift.startedShift === true
    ).length;

    if (signedInValue === 0) {
      return "red-button summary-numbers";
    }
    if (signedInValue === this.shiftList.length) {
      return "green-button summary-numbers";
    }
    return "yellow-button summary-numbers";
  }
  get signedOutBackgroundClass() {
    const signedOutValue = this.shiftList.filter(
      (shift) => shift.finishedShift === true
    ).length;

    if (signedOutValue === 0) {
      return "red-button summary-numbers";
    }
    if (signedOutValue === this.shiftList.length) {
      return "green-button summary-numbers";
    }
    return "yellow-button summary-numbers";
  }
}
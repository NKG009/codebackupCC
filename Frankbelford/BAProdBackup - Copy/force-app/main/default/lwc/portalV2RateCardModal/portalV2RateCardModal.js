import { LightningElement, api } from "lwc";
import getRateCardList from "@salesforce/apex/RateInfoController.getRateCardList";
import getRateLneList from "@salesforce/apex/RateInfoController.getRateLneList";

export default class PortalV2RateCardModal extends LightningElement {
  @api
  shifts;
  jobRoleOptions;
  rateCardInfo = [];
  currentRateCardLines = [];

  async connectedCallback() {
    this.jobRoleOptions = this.getJobRoleOptions(this.shifts);

    if (this.singleJobRole) {
      const rateCardInfo = await getRateCardList({
        jobrolId: this.jobRoleOptions[0].value
      });

      this.rateCardInfo = rateCardInfo;
    }
  }

  get rateCardOptions() {
    let rateCardOptions = [];

    this.rateCardInfo.forEach((rateCard) => {
      rateCardOptions.push({
        label: rateCard.Name,
        value: rateCard.Id
      });
    });
    return rateCardOptions;
  }

  get rateCardDisabled() {
    return this.rateCardInfo.length === 0;
  }

  get hasRateCardLines() {
    return this.currentRateCardLines.length > 0;
  }

  get singleJobRole() {
    return this.jobRoleOptions.length === 1;
  }

  getJobRoleOptions(shifts) {
    let options = [];

    shifts.forEach((shift) => {
      const jobRole = shift.columnInfo.find(
        (column) => column.label === "Job Role"
      );
      options.push({
        label: jobRole.value,
        value: shift.jobRoleId
      });
    });
    return options;
  }

  async handleJobRoleChange(event) {
    const { value } = event.target;
    //Get Rate card info for the job role
    const rateCardInfo = await getRateCardList({ jobrolId: value });

    this.rateCardInfo = rateCardInfo;
    this.currentRateCardLines = [];
  }

  async handleRateCardChange(event) {
    const { value } = event.target;
    //Get Rate card info for the job role
    const rateCardLines = await getRateLneList({ ratecardId: value });

    this.currentRateCardLines = rateCardLines;
  }

  closeClicked() {
    this.dispatchEvent(new CustomEvent("close"));
  }
}
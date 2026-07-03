import { LightningElement, track } from "lwc";
import getselectOptionsClient from "@salesforce/apex/ContactUsController.getselectOptionsClient";
import caseInsertSendEmail from "@salesforce/apex/ContactUsController.caseInsertSendEmail";

import { fetchLoggedInUserSites, showMessageToUser } from "c/portalV2Utility";
export default class PortalV2ContactUs extends LightningElement {
  @track
  subjectOptions = [];
  subjectValue;
  descriptionValue;
  @track
  siteOptions = [];
  siteId;

  async connectedCallback() {
    this.getSubjectOptions();
    this.getSiteOptions();
  }

  async getSubjectOptions() {
    this.subjectOptions = [];
    const options = await getselectOptionsClient({
      objObject: "{sobjectType : 'Case'}",
      fld: "Subject_Client_Query__c"
    });
    console.log(options);

    options.forEach((option) => {
      this.subjectOptions = [
        ...this.subjectOptions,
        {
          label: option,
          value: option
        }
      ];
    });
  }
  async getSiteOptions() {
    this.siteOptions = [];
    this.siteOptions = await fetchLoggedInUserSites();
  }
  async submit() {
    try {
      const result = await caseInsertSendEmail({
        sub: this.subjectValue,
        des: this.descriptionValue,
        siteId: this.siteId
      });
      console.log(result);
      if (result === "Success") {
        showMessageToUser(
          "success",
          "Your query has been submitted successfully.",
          this
        );
      } else {
        showMessageToUser(
          "error",
          "An error occured while submitting the query, please try again and if this persists please contact your administrator.",
          this
        );
      }
    } catch (e) {
      console.error(e);
      showMessageToUser(
        "error",
        "An error occured while submitting the query, please try again and if this persists please contact your administrator.",
        this
      );
    }
  }

  onSubjectChange(event) {
    this.subjectValue = event.target.value;
  }
  onSiteChange(event) {
    this.siteId = event.target.value;
  }
  onDescriptionChange(event) {
    this.descriptionValue = event.target.value;
  }
}
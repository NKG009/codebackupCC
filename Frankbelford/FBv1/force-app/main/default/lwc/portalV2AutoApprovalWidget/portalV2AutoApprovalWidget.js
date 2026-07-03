import { LightningElement, api, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import { getRecord } from "lightning/uiRecordApi";

import SITE_AUTO_APPROVAL_FIELD from "@salesforce/schema/sirenum__Site__c.IP_ScheduledAutoApproval__c";

export default class PortalV2AutoApprovalWidget extends LightningElement {
  // @api
  // siteId;
  actualSiteId;
  @wire(getRecord, {
    recordId: "$actualSiteId",
    fields: [SITE_AUTO_APPROVAL_FIELD]
  })
  siteRecord;

  get autoApprovalText() {
    return this.autoApprovalStatus
      ? "Auto approval is on"
      : "Auto approval is off";
  }

  get backgroundClass() {
    return this.autoApprovalStatus
      ? "card positive-green"
      : "card negative-red";
  }

  get autoApprovalStatus() {
    return this.siteRecord.data
      ? this.siteRecord.data.fields.IP_ScheduledAutoApproval__c.value
      : false;
  }

  @api
  get siteId() {
    return this.siteId;
  }
  set siteId(value) {
    this.actualSiteId = value[0];
    refreshApex(this.siteRecord);
  }
}
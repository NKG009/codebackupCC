import { LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import getSiteInformation from "@salesforce/apex/SiteManagementComponentController.fetchSiteInformation";
import { getCookie, parseSiteValue, createErrorLog } from "c/portalV2Utility";
import { registerListener } from "c/pubsub";

//Contact fields
import NAME_FIELD from "@salesforce/schema/Contact.Name";
import JOB_TITLE_FIELD from "@salesforce/schema/Contact.Title";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import MOBILE_FIELD from "@salesforce/schema/Contact.MobilePhone";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import MAILING_ADDRESS_FIELD from "@salesforce/schema/Contact.MailingAddress";

//Site fields
import STREET_FIELD from "@salesforce/schema/sirenum__Site__c.sirenum__Street_Address__c";
import CITY_FIELD from "@salesforce/schema/sirenum__Site__c.sirenum__City__c";
import COUNTY_FIELD from "@salesforce/schema/sirenum__Site__c.sirenum__County__c";
import COUNTRY_FIELD from "@salesforce/schema/sirenum__Site__c.sirenum__Country__c";
import POSTAL_CODE_FIELD from "@salesforce/schema/sirenum__Site__c.sirenum__Postal_Code__c";

//User fields
import Id from "@salesforce/user/Id";
import CONTACTID_FIELD from "@salesforce/schema/User.ContactId";

export default class PortalV2Settings extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  contactFields = [
    NAME_FIELD,
    JOB_TITLE_FIELD,
    EMAIL_FIELD,
    MOBILE_FIELD,
    PHONE_FIELD,
    MAILING_ADDRESS_FIELD
  ];
  siteFields = [
    STREET_FIELD,
    CITY_FIELD,
    COUNTY_FIELD,
    COUNTRY_FIELD,
    POSTAL_CODE_FIELD
  ];
  nameField = NAME_FIELD;
  emailField = EMAIL_FIELD;

  siteContactDetailFields = [NAME_FIELD, EMAIL_FIELD];
  contactApiName = "Contact";
  siteRecordId;
  siteApiName = "sirenum__Site__c";

  @wire(getRecord, { recordId: Id, fields: [CONTACTID_FIELD] })
  userRecord;
  siteRecord;
  siteLinks;

  displayedSiteId;

  async connectedCallback() {
    this.siteRecordId = parseSiteValue(this.getSiteFromCookie());
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    this.refreshData();
  }

  getSiteFromCookie() {
    const cookie = getCookie("siteSelectedByUser");
    console.log(cookie);

    return cookie;
  }

  get contactRecordId() {
    return this.userRecord.data
      ? getFieldValue(this.userRecord.data, CONTACTID_FIELD)
      : "";
  }

  get hasMultipleSites() {
    return this.siteRecordId.length > 1;
  }

  get hasMainContact() {
    return this.siteRecord
      ? this.siteRecord.IP_MainContact__c !== undefined
      : false;
  }

  get hasEmergencyContact() {
    return this.siteRecord
      ? this.siteRecord.Emergency_Contact__c !== undefined
      : false;
  }

  handleSiteChangeEvent(eventPayload) {
    if (eventPayload) {
      this.siteRecordId = parseSiteValue(eventPayload);
    }
    this.refreshData();
  }

  async refreshData() {
    try {
      this.siteRecord = await getSiteInformation({
        siteId: this.siteRecordId[0]
      });
      this.displayedSiteId = this.siteRecordId[0];
      console.log(this.siteRecord);

      this.siteLinks =
        this.siteRecord && this.siteRecord.Contact_Site_links1__r
          ? this.siteRecord.Contact_Site_links1__r
          : [];
    } catch (error) {
      console.error(error);
      createErrorLog(Id, error, undefined);
    }
  }
}
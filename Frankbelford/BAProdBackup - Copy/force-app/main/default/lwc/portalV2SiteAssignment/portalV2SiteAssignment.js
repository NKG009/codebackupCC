/* eslint-disable no-await-in-loop */
import { LightningElement, wire } from "lwc";
import {
  getRecord,
  getFieldValue,
  createRecord,
  deleteRecord,
  updateRecord
} from "lightning/uiRecordApi";
import { getPicklistValues } from "lightning/uiObjectInfoApi";

import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId";
import PORTAL_SITE_MANAGEMENT_FIELD from "@salesforce/schema/Account.Portal_Site_Management__c";
import ACCOUNT_PORTAL_ADMIN_FIELD from "@salesforce/schema/Contact.Account_portal_admin__c";
import SITE_FIELD from "@salesforce/schema/Contact_Site_link__c.IP_Site__c";
import LINK_ACCOUNT_FIELD from "@salesforce/schema/Contact_Site_link__c.Account__c";
import CONTACT_FIELD from "@salesforce/schema/Contact_Site_link__c.IP_Contact__c";
import PORTAL_TYPE_FIELD from "@salesforce/schema/Contact_Site_link__c.IP_PortalType__c";
import CONTACT_SITE_LINK_ID from "@salesforce/schema/Contact_Site_link__c.Id";

import CONTACT_SITE_LINK_OBJECT from "@salesforce/schema/Contact_Site_link__c";

import { showMessageToUser, createErrorLog } from "c/portalV2Utility";

import getAccountContacts from "@salesforce/apex/PortalV2SiteAssignmentController.getAccountContacts";
import getAccountSites from "@salesforce/apex/PortalV2SiteAssignmentController.getAccountSites";
import getSiteAssignments from "@salesforce/apex/PortalV2SiteAssignmentController.getSiteAssignments";

// this gets you the logged in user
import USER_ID from "@salesforce/user/Id";

export default class PortalV2SiteAssignment extends LightningElement {
  @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
  user;

  contactRecord;
  accountRecord;

  @wire(getRecord, {
    recordId: "$contactId",
    fields: [ACCOUNT_ID_FIELD, ACCOUNT_PORTAL_ADMIN_FIELD]
  })
  contact(data, error) {
    if (data) {
      this.contactRecord = data;
      this.refreshData(true);
    } else if (error) {
      console.error(error);
      createErrorLog(USER_ID, error, undefined);
    }
  }

  @wire(getRecord, {
    recordId: "$accountId",
    fields: [PORTAL_SITE_MANAGEMENT_FIELD]
  })
  account(data, error) {
    if (data) {
      this.accountRecord = data;
      this.refreshData(true);
    } else if (error) {
      console.error(error);
      createErrorLog(USER_ID, error, undefined);
    }
  }
  @wire(getPicklistValues, {
    recordTypeId: "012000000000000AAA",
    fieldApiName: PORTAL_TYPE_FIELD
  })
  portalTypeFieldValues(response) {
    const { data, error } = response;

    if (data) {
      this.portalTypeOptions = [];

      data.values.forEach((value) => {
        if (value.label !== "Consultant") {
          this.portalTypeOptions.push({
            label: value.label,
            value: value.value
          });
        }
      });
      this.portalTypeOptions.push({ label: "None", value: "None" });
    } else if (error) {
      console.error(error);
      createErrorLog(USER_ID, error, undefined);
    }
  }

  portalTypeOptions = [];
  selectedPortalType;

  selectedUser;
  selectedSite;
  userOptions;
  siteOptions;
  contactSiteAssignmentMap;

  async refreshData(defaultOwnContact) {
    try {
      if (!this.accountId) return;
      const contacts = await getAccountContacts({ AccountId: this.accountId });
      const sites = await getAccountSites({ AccountId: this.accountId });
      const siteAssignments = await getSiteAssignments({
        contactIds: contacts.map((contact) => contact.Id)
      });
      this.initialiseUserOptions(contacts, defaultOwnContact, siteAssignments);
      this.initialiseSiteOptions(sites, siteAssignments);

      console.group("Site Assignment");
      console.log("AccountId: ", this.accountId);
      console.log("Contacts: ", contacts);
      console.log("Sites: ", sites);
      console.groupEnd();
      console.log(this.portalTypeFieldValues);
    } catch (error) {
      console.error(error);
      createErrorLog(USER_ID, error, undefined);
    }
  }

  initialiseUserOptions(contacts, defaultOwnContact, siteAssignments) {
    this.userOptions = [];
    const siteAssignmentContactsToExclude = siteAssignments
      .filter((contact) => contact.IP_PortalType__c === "Consultant")
      .map((assignment) => assignment.IP_Contact__c);
    const nonConsultantContacts = contacts.filter(
      (contact) => !siteAssignmentContactsToExclude.includes(contact.Id)
    );
    nonConsultantContacts.forEach((contact) => {
      this.userOptions.push({
        label: contact.Name,
        value: contact.Id
      });
    });

    if (defaultOwnContact) {
      //Finally default the first selected to themselves
      this.selectedUser = contacts.find(
        (contact) => contact.Id === this.contactId
      ).Id;
    }
  }
  initialiseSiteOptions(sites, siteAssignments) {
    this.siteOptions = [];
    sites.forEach((site) => {
      this.siteOptions.push({ label: site.Name, value: site.Id });
    });

    this.contactSiteAssignmentMap = this.buildAssignedSiteMap(siteAssignments);
  }

  buildAssignedSiteMap(siteAssignments) {
    const siteAssignmentMap = [];
    siteAssignments.forEach((siteAssignment) => {
      let existingEntry = siteAssignmentMap.find(
        (entry) => entry.IP_Contact__c === siteAssignment.IP_Contact__c
      );
      //Entry exists
      if (existingEntry) {
        existingEntry.assignments.push({
          id: siteAssignment.Id,
          site: siteAssignment.IP_Site__c,
          portalType: siteAssignment.IP_PortalType__c
        });
      }
      //Entry does not exist
      else {
        let mapObject = {
          IP_Contact__c: siteAssignment.IP_Contact__c,
          assignments: []
        };
        if (siteAssignment.IP_Site__c) {
          mapObject.assignments.push({
            id: siteAssignment.Id,
            site: siteAssignment.IP_Site__c,
            portalType: siteAssignment.IP_PortalType__c
          });
        }
        siteAssignmentMap.push(mapObject);
      }
    });
    return siteAssignmentMap;
  }

  async createRecord(siteId, contactId) {
    try {
      const fields = {};
      fields[SITE_FIELD.fieldApiName] = siteId;
      fields[CONTACT_FIELD.fieldApiName] = contactId;
      fields[PORTAL_TYPE_FIELD.fieldApiName] = this.selectedPortalType;
      fields[LINK_ACCOUNT_FIELD.fieldApiName] = this.accountId;
      const recordInput = {
        apiName: CONTACT_SITE_LINK_OBJECT.objectApiName,
        fields
      };
      return createRecord(recordInput);
    } catch (error) {
      console.error(error);
    }
    return undefined;
  }

  async updateRecord() {
    try {
      //Get the relevant record first
      const assignments = this.contactSiteAssignmentMap.find(
        (assignment) => assignment.IP_Contact__c === this.selectedUser
      );
      const selectedSite = assignments.assignments.find(
        (assignment) => assignment.site === this.selectedSite
      );

      const fields = {};
      fields[CONTACT_SITE_LINK_ID.fieldApiName] = selectedSite.id;
      fields[PORTAL_TYPE_FIELD.fieldApiName] = this.selectedPortalType;
      fields[LINK_ACCOUNT_FIELD.fieldApiName] = this.accountId;
      const recordInput = {
        fields
      };
      return updateRecord(recordInput);
    } catch (error) {
      console.error(error);
    }
    return undefined;
  }

  async deleteRecord(contactLinkId) {
    try {
      return deleteRecord(contactLinkId);
    } catch (error) {
      createErrorLog(USER_ID, error, undefined);
      console.error(error);
    }
    return undefined;
  }

  //! Event Handlers

  handleUserSelection(event) {
    this.selectedUser = event.target.value;
    console.log(this.defaultSites);
    this.getPortalType();
  }

  handleSiteChange(event) {
    this.selectedSite = event.detail.value;
    //update portal type radio buttons
    this.getPortalType();
  }

  handlePortalTypeChange(event) {
    this.selectedPortalType = event.detail.value;
  }

  getPortalType() {
    const assignments = this.contactSiteAssignmentMap.find(
      (assignment) => assignment.IP_Contact__c === this.selectedUser
    );
    if (assignments === undefined) {
      this.selectedPortalType = "None";
      return;
    }
    const selectedSite = assignments.assignments.find(
      (assignment) => assignment.site === this.selectedSite
    );
    if (selectedSite === undefined) {
      this.selectedPortalType = "None";
      return;
    }

    this.selectedPortalType = selectedSite.portalType;
    console.log(this.selectedPortalType);
  }

  async handleSaveClick() {
    try {
      //Find delta between user selection and existing
      const currentUserMapEntry = this.contactSiteAssignmentMap.find(
        (item) => item.IP_Contact__c === this.selectedUser
      );
      if (currentUserMapEntry) {
        const selectedSite = currentUserMapEntry.assignments.find(
          (assignment) => assignment.site === this.selectedSite
        );
        if (selectedSite) {
          if (this.selectedPortalType === "None") {
            //delete
            await this.deleteRecord(selectedSite.id);
          } else {
            //update
            await this.updateRecord();
          }
        } else {
          //create
          await this.createRecord(this.selectedSite, this.selectedUser);
        }
      } else {
        try {
          if (this.selectedPortalType !== "None") {
            const record = await this.createRecord(
              this.selectedSite,
              this.selectedUser
            );
            this.contactSiteAssignmentMap.push({
              IP_Contact__c: this.selectedUser,
              assignments: [
                {
                  id: record.Id,
                  portalType: this.selectedPortalType,
                  site: this.selectedSite
                }
              ]
            });
          }
        } catch (error) {
          console.error(error);
          createErrorLog(USER_ID, error, undefined);

          showMessageToUser("error", error.body.message, this);
        }
      }

      await this.refreshData();
      showMessageToUser("success", "Successfully saved site assignment!", this);
    } catch (error) {
      showMessageToUser("error", error.body.message, this);
      createErrorLog(USER_ID, error, undefined);
      console.error(error);
    }
  }
  //! Getters
  get contactId() {
    return getFieldValue(this.user.data, CONTACT_ID_FIELD);
  }

  get accountId() {
    return getFieldValue(this.contactRecord.data, ACCOUNT_ID_FIELD);
  }
  get portalAdmin() {
    return getFieldValue(this.contactRecord.data, ACCOUNT_PORTAL_ADMIN_FIELD);
  }
  get portalSiteManagement() {
    return getFieldValue(this.accountRecord.data, PORTAL_SITE_MANAGEMENT_FIELD);
  }
  get siteSelected() {
    return this.selectedSite !== undefined;
  }

  get display() {
    return this.portalAdmin && this.portalSiteManagement;
  }
}
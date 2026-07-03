import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord, createRecord, getFieldValue } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

import getSitesOfLoggedInUser from "@salesforce/apex/SiteManagementComponentController.getSitesOfLoggedInUser";
import SendEmail from "@salesforce/apex/SendEmailOnNewVacancy.SendEmailWithPO";
import WorkHoursCheck from "@salesforce/apex/WorkHoursCalculator.isInWorkHours";

import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId";
import SIRENUM_LINK_FIELD from "@salesforce/schema/sirenum__Team__c.sirenum__Account__c";

import SITE_OWNER_FIELD from "@salesforce/schema/sirenum__Site__c.OwnerId";

import USER_ID from "@salesforce/user/Id";

import { showMessageToUser } from "c/utility";
import { daysBetween, addDays } from "c/dateUtility";

import TIME_ZONE from "@salesforce/i18n/timeZone";

export default class RequestShiftVacancyModal extends LightningElement {
  //!Component properties
  timezone = TIME_ZONE;
  @api
  siteId;
  jobRole;
  jobRoleId;
  startDate;
  startTime;
  endDate;
  endTime;
  details;
  numWorkers;
  selectedSite;
  siteRecord;
  jobRoleRecord;
  availableSites = [];
  loading = true;
  isNewJobRole = false;
  requiresMultipleWorkers = false;
  lookupFields = ["Name", "sirenum__Job_Type__r.Name"];
  lookupDisplayFields = ["Name", "sirenum__Job_Type__r.Name"];
  isOutOfHours = false;

  @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
  user;

  contactRecord;

  @wire(getRecord, { recordId: "$contactId", fields: [ACCOUNT_ID_FIELD] })
  contact(data, error) {
    if (data) {
      this.contactRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getRecord, { recordId: "$jobRoleId", fields: [SIRENUM_LINK_FIELD] })
  jobRoleWire(data, error) {
    if (data) {
      this.jobRoleRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getRecord, { recordId: "$selectedSite", fields: [SITE_OWNER_FIELD] })
  siteWire(data, error) {
    if (data) {
      console.log("site record: ", JSON.stringify(data));
      this.siteRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  async fetchLoggedInUserSites() {
    try {
      const result = await getSitesOfLoggedInUser();

      //init logged in user sites
      this.availableSites = [];

      result.forEach((site) => {
        this.availableSites.push({
          value: site.Id,
          label: site.Name
        });
      });
      console.log("Logged In User Sites: ", result);
    } catch (error) {
      showMessageToUser(
        "error",
        "An internal error occurred while fetching logged-in user sites.",
        this
      );

      console.log("Logged In User Sites Error As Object: ", error);
      console.log(
        "Logged In User Sites Error As String: ",
        JSON.stringify(error)
      );
    }
  }

  async connectedCallback() {
    await this.fetchLoggedInUserSites();
  }
  //!Click handlers
  closeClicked() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  reset() {
    let fields = this.template.querySelectorAll(
      "lightning-input-field, lightning-input"
    );
    if (fields)
      fields.forEach((field) => {
        if (field.tagName === "LIGHTNING-INPUT-FIELD") {
          field.reset();
        } else {
          field.value = null;
        }

        console.log(field);
      });
  }

  //!Event handlers
  async onSubmit(event) {
    this.loading = true;
    event.preventDefault();
    console.log(this.siteId);

    //New email logic to go here for out of hours emails.

   

    
     if (this.validateInput()) {
       console.log('Email loop entered');
      const defaultFields = event.detail.fields;
    const salinatedStartDate = this.startDate.replaceAll("-", "/");
    const salinatedEndDate = this.endDate.replaceAll("-", "/");
    let fields = JSON.parse(JSON.stringify(defaultFields));
    fields.OwnerId = this.selectedSiteOwnerId;
    let startTimeSplit = this.startTime.split(":");
    let endTimeSplit = this.endTime.split(":");

    let startTime = `${startTimeSplit[0]}:${startTimeSplit[1]}`;
    let endTime = `${endTimeSplit[0]}:${endTimeSplit[1]}`;

    const result = await SendEmail({
        siteId: this.selectedSite,
        startTime: startTime,
        endTime: endTime,
        startDate: salinatedStartDate,
        endDate: salinatedEndDate,
        textAreaVal: this.details,
        poNumber: fields.Invoice_PO_Optional__c,
        isNewJobRole:this.isNewJobRole
    });
    console.log('Email Sent');
     console.log('result debug :',result);

   
     // const defaultFields = event.detail.fields;
      let newShifts = [];
      console.log('this.isNewJobRole: ' + this.isNewJobRole);
      if (!this.isNewJobRole) {
        console.log('inside if');
        try {
          const numberOfDays = daysBetween(this.startDate, this.endDate);
          if (numberOfDays === 0) {
            let fields = JSON.parse(JSON.stringify(defaultFields));
            fields.OwnerId = this.selectedSiteOwnerId;
            let startDate = new Date(`${this.startDate}T${this.startTime}`);
            //  addHours(
            //   addDays(this.startDate, i),
            //   timeToDecimal(this.startTime)
            // );
            let endDate = new Date(`${this.endDate}T${this.endTime}`);
            // addHours(
            //   addDays(this.startDate, i),
            //   timeToDecimal(this.endTime)
            // );
            fields.sirenum__Scheduled_Start_Time__c = startDate;
            fields.sirenum__Scheduled_End_Time__c = endDate;
            fields.sirenum__Site__c = this.selectedSite;
            fields.sirenum__Team__c = this.jobRole.Id;
            fields.sirenum__Broadcasts__c = this.numWorkers;
            fields.IP_Account__c = this.accountId;
            fields.sirenum__Contract__c = this.sirenumLinkId;
            fields.sirenum__AssignedShifts__c = 0;

            const recordInput = {
              apiName: "sirenum__Shift__c",
              fields: fields
            };

            newShifts.push(createRecord(recordInput));
          } else if (numberOfDays === 1) {
            let fields = JSON.parse(JSON.stringify(defaultFields));
            fields.OwnerId = this.selectedSiteOwnerId;
            const startDateTime = new Date(
              `${this.startDate}T${this.startTime}`
            );
            const endDateTime = new Date(`${this.startDate}T${this.endTime}`);

            let startDate = startDateTime;
            let endDate = endDateTime;

            if (startDate > endDate) {
              endDate = addDays(endDate, 1);

              fields.sirenum__Scheduled_Start_Time__c = startDate;
              fields.sirenum__Scheduled_End_Time__c = endDate;
              fields.sirenum__Site__c = this.selectedSite;
              fields.sirenum__Team__c = this.jobRole.Id;
              fields.sirenum__Broadcasts__c = this.numWorkers;
              fields.IP_Account__c = this.accountId;
              fields.sirenum__Contract__c = this.sirenumLinkId;
              fields.sirenum__AssignedShifts__c = 0;

              const recordInput = {
                apiName: "sirenum__Shift__c",
                fields: fields
              };

              newShifts.push(createRecord(recordInput));
            } else {
              for (let i = 0; i <= numberOfDays; i++) {
                startDate = addDays(startDateTime, i);

                endDate = addDays(endDateTime, i);

                fields.sirenum__Scheduled_Start_Time__c = startDate;
                fields.sirenum__Scheduled_End_Time__c = endDate;
                fields.sirenum__Site__c = this.selectedSite;
                fields.sirenum__Team__c = this.jobRole.Id;
                fields.sirenum__Broadcasts__c = this.numWorkers;
                fields.IP_Account__c = this.accountId;
                fields.sirenum__Contract__c = this.sirenumLinkId;
                fields.sirenum__AssignedShifts__c = 0;

                const recordInput = {
                  apiName: "sirenum__Shift__c",
                  fields: fields
                };

                newShifts.push(createRecord(recordInput));
              }
            }
          } else {
            for (let i = 0; i <= numberOfDays; i++) {
              let fields = JSON.parse(JSON.stringify(defaultFields));
              fields.OwnerId = this.selectedSiteOwnerId;
              let startDateTime = new Date(
                `${this.startDate}T${this.startTime}`
              );
              let endDateTime = new Date(`${this.startDate}T${this.endTime}`);

              let startDate = addDays(startDateTime, i);

              let endDate = addDays(endDateTime, i);

              //account for night shifts
              if (startDate > endDate) {
                endDate = addDays(endDate, 1);
              }

              fields.sirenum__Scheduled_Start_Time__c = startDate;
              fields.sirenum__Scheduled_End_Time__c = endDate;
              fields.sirenum__Site__c = this.selectedSite;
              fields.sirenum__Team__c = this.jobRole.Id;
              fields.sirenum__Broadcasts__c = this.numWorkers;
              fields.IP_Account__c = this.accountId;
              fields.sirenum__Contract__c = this.sirenumLinkId;
              fields.sirenum__AssignedShifts__c = 0;

              const recordInput = {
                apiName: "sirenum__Shift__c",
                fields: fields
              };

              newShifts.push(createRecord(recordInput));
            }
          }

          await Promise.all(newShifts);
          showMessageToUser("success", "Shifts requested successfully.", this);
          this.loading = false;
          this.closeClicked();
        } catch (err) {
          console.error(err);
          showMessageToUser(
            "error",
            "An unexpected error has occurred. Please contact your System Administrator.",
            this
          );
          this.loading = false;
        }
      } else {
         console.log('inside else' +this.selectedSiteOwnerId);
        try {
          const salinatedStartDate = this.startDate.replaceAll("-", "/");
          const salinatedEndDate = this.endDate.replaceAll("-", "/");
          let fields = JSON.parse(JSON.stringify(defaultFields));
          fields.OwnerId = this.selectedSiteOwnerId;
          let startTimeSplit = this.startTime.split(":");
          let endTimeSplit = this.endTime.split(":");

          let startTime = `${startTimeSplit[0]}:${startTimeSplit[1]}`;
          let endTime = `${endTimeSplit[0]}:${endTimeSplit[1]}`;

          /*const result = await SendEmail({
            siteId: this.selectedSite,
            startTime: startTime,
            endTime: endTime,
            startDate: salinatedStartDate,
            endDate: salinatedEndDate,
            textAreaVal: this.details,
            poNumber: fields.Invoice_PO_Optional__c
          }); */
          console.log(result);
          if (result === "Request Sent for Processing") {
            showMessageToUser(
              "success",
              "Your shift/vacancy request has been successfully created.",
              this
            );
            this.dispatchEvent(new CustomEvent("close"));
          } else {
            showMessageToUser(
              "error",
              "An unexpected error has occurred. Please contact your System Administrator.",
              this
            );
            console.error(result);
          }
          this.loading = false;
        } catch (e) {
          console.log('inside catch vlocb:'+JSON.stringify(e));
          showMessageToUser(
            "error",
            "An unexpected error has occurred. Please contact your System Administrator.",
            this
          );
          console.error(e);
          this.loading = false;
        }
      }
    } else {
      this.loading = false;
    }
  }
  

  validateInput() {
    const emptyFields = [];
    let hasError = false;
    //Job Role
    if (!this.isNewJobRole && this.jobRole === undefined) {
      emptyFields.push("Job Role");
    }
    //Site
    if (this.siteId === undefined) {
      emptyFields.push("Site");
    }
    //Start Date
    if (this.startDate === undefined) {
      emptyFields.push("Start Date");
    }
    //Start Time
    if (this.startTime === undefined) {
      emptyFields.push("Start Time");
    }
    //End Date
    if (this.endDate === undefined) {
      emptyFields.push("End Date");
    }
    //End Time
    if (this.endTime === undefined) {
      emptyFields.push("End Time");
    }
    //Number of workers
    if (this.requiresMultipleWorkers && this.numWorkers === undefined) {
      emptyFields.push("Number of Workers");
    }

    if (
      this.startDate &&
      this.endDate &&
      new Date(this.startDate) > new Date(this.endDate)
    ) {
      showMessageToUser(
        "error",
        "The selected start date cannot be after the end date.",
        this
      );
      hasError = true;
    }

    if (this.startDate && new Date() > new Date(this.startDate)) {
      showMessageToUser(
        "error",
        "The selected start date cannot be before today.",
        this
      );
      hasError = true;
    }

    if (emptyFields.length > 0) {
      showMessageToUser(
        "error",
        `The following fields ${emptyFields.join(
          ", "
        )} have not been completed. Please complete them to continue.`,
        this
      );
      hasError = true;
    }
    return !hasError;
  }

  onSuccess() {
    this.showToast();

    this.dispatchEvent(new CustomEvent("close"));
  }

  onLoad() {
    this.loading = false;
  }

  showToast() {
    const event = new ShowToastEvent({
      title: "Success!",
      message: "Your shift/vacancy request has been successfully created.",
      variant: "success"
    });
    this.dispatchEvent(event);
  }

  //! Field change handlers
  handleStartDateChange(event) {
    this.startDate = event.target.value;
  }
  handleStartTimeChange(event) {
    this.startTime = event.target.value;
  }
  handleEndDateChange(event) {
    this.endDate = event.target.value;
  }
  handleNumWorkersChange(event) {
    this.numWorkers = event.target.value;
  }
  handleEndTimeChange(event) {
    this.endTime = event.target.value;
  }
  handleNewJobRoleChange(event) {
    this.isNewJobRole = event.target.checked;
  }
  handleMultipleWorkersChange(event) {
    this.requiresMultipleWorkers = event.target.checked;
  }
  handleDetailChange(event) {
    this.details = event.target.value;
  }
  handleJobRoleChange(event) {
    if (event.detail.data === undefined) {
      this.jobRole = undefined;
      this.jobRoleId = undefined;
      return;
    }
    const { record } = event.detail?.data;
    this.jobRole = record;
    this.jobRoleId = record.Id;
    refreshApex(this.jobRoleRecord);
  }
  handleSiteChange(event) {
    this.selectedSite = event.target.value;
  }

  //!Getters
  get contactId() {
    return getFieldValue(this.user.data, CONTACT_ID_FIELD);
  }
  get accountId() {
    return getFieldValue(this.contactRecord.data, ACCOUNT_ID_FIELD);
  }
  get sirenumLinkId() {
    return getFieldValue(this.jobRoleRecord.data, SIRENUM_LINK_FIELD);
  }
  get selectedSiteOwnerId() {
    return getFieldValue(this.siteRecord.data, SITE_OWNER_FIELD);
  }

  get recordTypeId() {
    //Shift demand RT Id = 0124J000000UrHTQA0, Shift RT Id =  0124J000000UrHSQA0, these values should never change

     return this.requiresMultipleWorkers
      ? "012QH000001vqseYAA"
      : "012QH000001vqsdYAA";
  }
}
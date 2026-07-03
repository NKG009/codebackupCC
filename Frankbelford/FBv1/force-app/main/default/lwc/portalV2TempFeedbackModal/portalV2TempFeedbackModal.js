import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {
  createRecord,
  updateRecord,
  getRecord,
  getFieldValue,
  createErrorLog
} from "lightning/uiRecordApi";
import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import Id from "@salesforce/user/Id";
import { showMessageToUser } from "c/portalV2Utility";

export default class PortalV2TempFeedbackModal extends LightningElement {
  @api
  siteId;
  @track
  _selectedTemps;
  additionalColumns;
  currentUserId = Id;

  @wire(getRecord, { recordId: Id, fields: [CONTACT_ID_FIELD] })
  userRecord;

  calculateRating(rating) {
    switch (rating) {
      case 1:
        return "Unsuitable";
      case 2:
        return "Bad";
      case 3:
        return "Average";
      case 4:
        return "Good";
      default:
        return "Excellent";
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  //!Getters
  @api
  get selectedTemps() {
    return this._selectedTemps;
  }
  set selectedTemps(value) {
    this._selectedTemps = JSON.parse(
      JSON.stringify(value.filter((temp) => temp.columnInfo !== undefined))
    );
    if (this._selectedTemps.length === 0) {
      this.closeClicked();

      showMessageToUser(
        "error",
        "Unfilled shifts cannot be rated. Please select a filled shift.",
        this
      );
    } else {
      this.additionalColumns = this._selectedTemps.find(
        (temp) => temp.columnInfo !== undefined
      )?.columnInfo;
    }
  }

  get userContactId() {
    return getFieldValue(this.userRecord.data, CONTACT_ID_FIELD);
  }
  //!Click handlers
  closeClicked() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  clearClicked() {
    this.template.querySelector("c-portal-v2-star-rating").reset();
  }
  applyClicked() {
    let successfullyCreated = 0;
    const promises = [];
    this._selectedTemps.forEach((temp) => {
      const ratingExists = temp.rating !== undefined;
      if (ratingExists) {
        const recordInput = {
          fields: {
            Id: temp.rating.Id,
            sirenum__Ranked_by__c: this.userContactId,
            sirenum__Rank__c: this.calculateRating(temp.ratingNumber)
          }
        };
        promises.push(
          updateRecord(recordInput)
            .then((record) => {
              console.log(record);
              successfullyCreated++;
            })
            .catch((e) => {
              console.error(e);
            })
        );
      } else {
        const recordInput = {
          apiName: "sirenum__Ranking__c",
          fields: {
            sirenum__Contact__c: temp.contactId,
            sirenum__Ranked_by__c: this.userContactId,
            sirenum__Rank__c: this.calculateRating(temp.ratingNumber),//(temp.rating),
            Shift__c: temp.id,
            sirenum__Site__c: temp.site
          }
        };
        console.log(recordInput);
        promises.push(
          createRecord(recordInput)
            .then((record) => {
              console.log(record);
              successfullyCreated++;
            })
            .catch((e) => {
              console.error(e);
              createErrorLog(Id, e, undefined);
            })
        );
      }
    });
    Promise.all(promises).then(() => {
      if (successfullyCreated === 0) {
        this.showToast(
          "Error!",
          `An unexpected problem occurred. Please contact your administrator for more information.`,
          "error"
        );
      } else if (successfullyCreated === 1) {
        this.showToast(
          "Success!",
          `${successfullyCreated} rating has been applied.`,
          "success"
        );
      } else {
        this.showToast(
          "Success!",
          `${successfullyCreated} ratings has been applied.`,
          "success"
        );
      }
      this.closeClicked();
    });
  }

  //!event handlers
  handleStarChange(event) {
    const { id, rating } = event.detail;
    console.log(id, rating);
    try {
      let foundTemp = this._selectedTemps.find((temp) => temp.id === id);
      // foundTemp = { ...foundTemp, rating: rating };
      if (foundTemp) foundTemp.ratingNumber = rating;
    } catch (e) {
      console.error(e);
      createErrorLog(Id, e, undefined);
    }
  }
}
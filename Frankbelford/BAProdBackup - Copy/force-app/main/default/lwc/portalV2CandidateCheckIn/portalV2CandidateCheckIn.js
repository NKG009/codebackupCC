import { LightningElement, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

//Apex Functions
import GetShifts from "@salesforce/apex/portalV2CandidateCheckInController.getShiftsForSite";
//Helper Functions
import {
  getCookie,
  showMessageToUser,
  parseSiteValue,
  isViewOnlyUser,
  createErrorLog
} from "c/portalV2Utility";
import { registerListener } from "c/pubsub";
import Id from "@salesforce/user/Id";

export default class PortalV2CandidateCheckIn extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  getShiftsProvisionedValue;
  @wire(GetShifts, { siteIds: "$siteId" })
  getShifts(provisionedValue) {
    this.getShiftsProvisionedValue = provisionedValue;
    const { data, error } = provisionedValue;
    if (data) {
      this.loading = true;
      this.flattenData(data);
    } else if (error) {
      console.error(error);
      createErrorLog(Id, error, undefined);
    }
  }

  @track
  jobRoles = [];

  readOnlyUser;
  siteId;
  loading = true;

  //#region getters
  get hasResults() {
    return this.jobRoles.length > 0;
  }
  //#endregion

  async connectedCallback() {
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    registerListener("actionStarted", this.handleActionStarted, this);
    registerListener("actionFinished", this.handleActionFinished, this);
    registerListener("errorOccurred", this.handleError, this);
    this.populateFromCookie();
    try {
      this.readOnlyUser = await isViewOnlyUser();
    } catch (error) {
      createErrorLog(Id, error, undefined);
    }
  }

  populateFromCookie() {
    const cookie = getCookie("siteSelectedByUser");
    console.log(cookie);

    this.siteId = parseSiteValue(cookie);
  }

  flattenData(data) {
    console.log(data);
    this.jobRoles = [];

    data.forEach((shift) => {
      const jobRoleEntry = this.jobRoles.find(
        (role) =>
          role.id === shift.sirenum__Team__r.Id &&
          role.startTime === shift.sirenum__Scheduled_Start_Time__c &&
          role.endTime === shift.sirenum__Scheduled_End_Time__c
      );
      if (jobRoleEntry) {
        jobRoleEntry.shifts.push({
          id: shift.Id,
          candidate: shift.sirenum__Contact__r.Name,
          startedShift: shift.sirenum__Actual_Start_Time__c !== undefined,
          finishedShift: shift.sirenum__Actual_End_Time__c !== undefined,
          timeShiftStarted: shift.sirenum__Actual_Start_Time__c,
          timeShiftFinished: shift.sirenum__Actual_End_Time__c,
          candidateConfirmed: shift.sirenum__Accepted__c === 1 ? true : false,
          get sortValue() {
            let sortValue = this.startedShift ? 1 : 0;
            sortValue += this.finishedShift ? 1 : 0;
            return sortValue;
          }
        });
      } else {
        this.jobRoles.push({
          id: shift.sirenum__Team__r.Id,
          name: shift.sirenum__Team__r.Name,
          startTime: shift.sirenum__Scheduled_Start_Time__c,
          endTime: shift.sirenum__Scheduled_End_Time__c,
          get tileLayoutClass() {
            //get window width
            const screenWidth = window.innerWidth;
            if (screenWidth < 1025) {
              return this.shifts.length > 6 ? "full-tile" : "half-tile";
            }
            return this.shifts.length > 8 ? "full-tile" : "half-tile";
          },
          shifts: [
            {
              id: shift.Id,
              candidate: shift.sirenum__Contact__r.Name,
              startedShift: shift.sirenum__Actual_Start_Time__c !== undefined,
              finishedShift: shift.sirenum__Actual_End_Time__c !== undefined,
              timeShiftStarted: shift.sirenum__Actual_Start_Time__c,
              timeShiftFinished: shift.sirenum__Actual_End_Time__c,
              candidateConfirmed: shift.sirenum__Is_Confirmed__c,
              get sortValue() {
                let sortValue = this.startedShift ? 1 : 0;
                sortValue += this.finishedShift ? 1 : 0;
                console.log(sortValue);
                return sortValue;
              }
            }
          ]
        });
      }
    });
    this.jobRoles.sort((a, b) => {
      if (new Date(a.startTime) > new Date(b.startTime)) {
        return 1;
      }
      if (new Date(a.startTime) < new Date(b.startTime)) {
        return -1;
      }
      if (new Date(a.startTime) === new Date(b.startTime)) {
        return 0;
      }
      return 0;
    });
    this.jobRoles.forEach((jobRole) => {
      jobRole.shifts.sort((a, b) => {
        if (a.sortValue < b.sortValue) {
          return 1;
        }
        if (a.sortValue > b.sortValue) {
          return -1;
        }
        if (a.sortValue === b.sortValue) {
          return 0;
        }
        return 0;
      });
    });
    this.loading = false;
  }

  //#region event handlers
  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);
    this.loading = true;
    if (eventPayload) {
      this.siteId = eventPayload;
    }
  }
  handleActionStarted() {
    this.loading = true;
  }
  handleActionFinished() {
    refreshApex(this.getShiftsProvisionedValue);
  }
  handleError(eventPayload) {
    const { error } = eventPayload;
    createErrorLog(Id, error, undefined);

    const errorCodes = error.body.output.errors;
    const firstError = errorCodes[0];
    const payrollErrorList = [
      "The candidate does not have a pay-profile in the correct state. Either there is no OK to supply for their LTD/Umbrella pay-profile or no active PAYE profile",
      "There is missing detail on the placement for this shift therefore it cannot be processed for Pay and Charge"
    ];
    if (firstError?.errorCode === "FIELD_CUSTOM_VALIDATION_EXCEPTION") {
      if (payrollErrorList.includes(firstError.message)) {
        showMessageToUser(
          "error",
          "Unfortunately this candidate is missing payroll information. Please contact your consultant to resolve this issue.",
          this
        );
      }
    } else {
      showMessageToUser(
        "error",
        "An error has occurred, please try again later.",
        this
      );
    }

    console.error(error);
    this.loading = false;
  }
  //#endregion
}
import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import FORM_FACTOR from "@salesforce/client/formFactor";

import { registerListener } from "c/pubsub";
import { getCookie, setCookie, parseSiteValue } from "c/portalV2Utility";
// import getEnableWorkerEndorsement from "@salesforce/apex/PortalV2DashboardController.getEnableWorkerEndorsement"; //jyothi

import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId";
import ENABLE_WORKER_ENDORSEMENT_FIELD from "@salesforce/schema/Account.Enable_Worker_Endorsement__c";

// this gets you the logged in user
import USER_ID from "@salesforce/user/Id";

export default class PortalV2Dashboard extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  /*
  Determine whether user's account uses endorsement
*/

  @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
  user;

  contactRecord;
  accountRecord;

  @wire(getRecord, {
    recordId: "$contactId",
    fields: [ACCOUNT_ID_FIELD]
  })
  contact(data, error) {
    if (data) {
      this.contactRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getRecord, {
    recordId: "$accountId",
    fields: [ENABLE_WORKER_ENDORSEMENT_FIELD]
  })
  account(data, error) {
    if (data) {
      this.accountRecord = data;
    } else if (error) {
      console.error(error);
    }
  }

  siteId;

  @api
  timesheetPageName;
  @api
  myShiftsPageName;
  @api
  todaysWorkforcePageName;
  @api
  mIInfoPageName;
  @api
  jobRoleViewGroupingColumnName; //NOT IN USE

  widgetSelectorOpen = false;
  availableWidgets = [];

  connectedCallback() {
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    this.populateFromCookie();
    this.initColumnsFromCookie();
  }

  initColumnsFromCookie() {
    const cookie = getCookie("dashboardWidgetSelection");
    const parsedCookie = cookie === "" ? undefined : JSON.parse(cookie);

    if (cookie) {
      this.availableWidgets = parsedCookie;
      return;
    }
    this.availableWidgets = [
      {
        column: "Approve shifts",
        selected: true
      },
      {
        column: "Total cost per week",
        selected: true
      },
      {
        column: "Request new booking",
        selected: true
      },
      {
        column: "Shift fulfilment",
        selected: true
      },
      {
        column: "My temps",
        selected: true
      },
      {
        column: "Today's Workforce",
        selected: true
      }
    ];
  }

  populateFromCookie() {
    const cookie = getCookie("siteSelectedByUser");
    console.log(cookie);

    this.siteId = parseSiteValue(cookie);
  }

  toggleWidgetSelectorOpen() {
    this.widgetSelectorOpen = !this.widgetSelectorOpen;
  }

  handleWidgetFilter(event) {
    const detail = event.detail;

    this.availableWidgets = detail.mainTable;

    setCookie(
      "dashboardWidgetSelection",
      JSON.stringify(this.availableWidgets),
      1000
    );

    this.toggleWidgetSelectorOpen();
  }

  handleSiteChangeEvent(eventPayload) {
    // this.isEnableWorkerEndors = false;
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.siteId = JSON.parse(eventPayload);
    }
    // this.isEnableWorkerEndors = true;
  }

  //Widget getters
  get approveShiftsSelected() {
    return this.availableWidgets.find((c) => c.column === "Approve shifts")
      .selected;
  }
  get totalCostSelected() {
    return this.availableWidgets.find((c) => c.column === "Total cost per week")
      .selected;
  }
  get requestShiftsSelected() {
    return this.availableWidgets.find((c) => c.column === "Request new booking")
      .selected;
  }
  get shiftFulfilmentSelected() {
    return this.availableWidgets.find((c) => c.column === "Shift fulfilment")
      .selected;
  }
  get myTempsSelected() {
    return this.availableWidgets.find((c) => c.column === "My temps").selected;
  }
  get approvalStatusSelected() {
    return (
      this.availableWidgets.find((c) => c.column === "Auto approval status")
        .selected &&
      //Dont show if all sites selected
      this.siteId.length === 1
    );
  }
  get todaysWorkforceSelected() {
    return this.availableWidgets.find((c) => c.column === "Today's Workforce")
      .selected;
  }

  //Form factor must not be mobile in order to display this view
  get displayComponent() {
    return FORM_FACTOR !== "Small";
  }

  // async isEnableWorkerEndorsement() {
  //   this.isEnableWorkerEndors = await getEnableWorkerEndorsement();
  // }

  get contactId() {
    return getFieldValue(this.user.data, CONTACT_ID_FIELD);
  }

  get accountId() {
    return getFieldValue(this.contactRecord.data, ACCOUNT_ID_FIELD);
  }
  get enableWorkerEndorsement() {
    return getFieldValue(
      this.accountRecord.data,
      ENABLE_WORKER_ENDORSEMENT_FIELD
    );
  }
}
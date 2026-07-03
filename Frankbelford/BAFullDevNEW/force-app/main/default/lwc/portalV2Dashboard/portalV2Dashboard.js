import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import FORM_FACTOR from "@salesforce/client/formFactor";

import { registerListener } from "c/pubsub";
import { getCookie, setCookie, parseSiteValue } from "c/portalV2Utility";
// import getEnableWorkerEndorsement from "@salesforce/apex/PortalV2DashboardController.getEnableWorkerEndorsement"; //jyothi

import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId";
import ENABLE_WORKER_ENDORSEMENT_FIELD from "@salesforce/schema/Account.Enable_Worker_Endorsement__c";
import VMS_CONTACT_FIELD from "@salesforce/schema/Contact.VMS_Contact__c";
import VMS_CLIENT_CONTACT_FIELD from "@salesforce/schema/Contact.VMS_Client_Contact__c";
import PORTAL_TYPE_FIELD from "@salesforce/schema/Contact.Portal_Type__c";

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
    fields: [ACCOUNT_ID_FIELD, VMS_CONTACT_FIELD, VMS_CLIENT_CONTACT_FIELD, PORTAL_TYPE_FIELD]
  })
  contact(data, error) {
    if (data) {
      this.contactRecord = data;
      console.log(
        "contactRecord:",
        JSON.stringify(this.contactRecord));
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
  myShiftsVMSclientPageName;
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
     setTimeout(async () => { 
      this.initColumnsFromCookie();
    }, 4000);
    
  }

  initColumnsFromCookie() {

    if (this.vmsClientcontact) {
      
      if (this.portaltype == 'VMS - Authorised Booker') {
        const cookie = getCookie("dashboardWidgetSelectionvmsclientAuthorisedBooker");
        const parsedCookie = cookie === "" ? undefined : JSON.parse(cookie);


        if (cookie) {
          this.availableWidgets = parsedCookie;
          return;
        }

        this.availableWidgets = [
          {
            column: "Raise New Job Order",
            selected: true
          },
          {
            column: "Shift fulfilment",
            selected: true
          },
          {
            column: "My Workers",
            selected: true
          },
          {
            column: "Today's Workforce",
            selected: true
          }
        ];

      }
      else if (this.portaltype == 'VMS - Hours Approver') {
        const cookie = getCookie("dashboardWidgetSelectionvmsclientHoursApprover");
        const parsedCookie = cookie === "" ? undefined : JSON.parse(cookie);


        if (cookie) {
          this.availableWidgets = parsedCookie;
          return;
        }

        this.availableWidgets = [
          {
            column: "Hours Approval",
            selected: true
          },
          {
            column: "Total cost per week",
            selected: true
          }
        ];

      }
      else {
        const cookie = getCookie("dashboardWidgetSelectionvmsclient");
        const parsedCookie = cookie === "" ? undefined : JSON.parse(cookie);


        if (cookie) {
          this.availableWidgets = parsedCookie;
          return;
        }

        this.availableWidgets = [
          {
            column: "Hours Approval",
            selected: true
          },
          {
            column: "Total cost per week",
            selected: true
          },
          {
            column: "Raise New Job Order",
            selected: true
          },
          {
            column: "Shift fulfilment",
            selected: true
          },
          {
            column: "My Workers",
            selected: true
          },
          {
            column: "Today's Workforce",
            selected: true
          }
        ];
      }
    }
    else {

      const cookie = getCookie("dashboardWidgetSelection");
      const parsedCookie = cookie === "" ? undefined : JSON.parse(cookie);
      // console.log('VMS Contact:', this.vmsClientcontact);

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

  }

  populateFromCookie() {
    const cookie = getCookie("siteSelectedByUser");
    console.log(cookie);

    this.siteId = parseSiteValue(cookie);
  }

  toggleWidgetSelectorOpen() {

    this.initColumnsFromCookie();
    this.widgetSelectorOpen = !this.widgetSelectorOpen;
  }

  handleWidgetFilter(event) {
    const detail = event.detail;
    console.log("Widgets Filter Event: ", JSON.stringify(detail));
    this.availableWidgets = detail.mainTable;


    if (this.vmsClientcontact) {
      if (this.portaltype == 'VMS - Authorised Booker') {
        setCookie(
          "dashboardWidgetSelectionvmsclientAuthorisedBooker",
          JSON.stringify(this.availableWidgets),
          1000
        );
      }
      else if (this.portaltype == 'VMS - Hours Approver') {
        setCookie(
          "dashboardWidgetSelectionvmsclientHoursApprover",
          JSON.stringify(this.availableWidgets),
          1000
        );
      }
      else {
        setCookie(
          "dashboardWidgetSelectionvmsclient",
          JSON.stringify(this.availableWidgets),
          1000
        );
      }
    }
    else {
      setCookie(
        "dashboardWidgetSelection",
        JSON.stringify(this.availableWidgets),
        1000
      );
    }


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
    const widget = this.availableWidgets.find((c) => c.column === "Approve shifts" || c.column === "Hours Approval")
    return widget ? widget.selected : false;
  }
  get totalCostSelected() {
    const widget= this.availableWidgets.find((c) => c.column === "Total cost per week")
    return widget ? widget.selected : false;
  }
  get requestShiftsSelected() {
    const widget = this.availableWidgets.find((c) => c.column === "Request new booking" || c.column === "Raise New Job Order")
    return widget ? widget.selected : false;
  }
  get shiftFulfilmentSelected() {
     const widget =this.availableWidgets.find((c) => c.column === "Shift fulfilment")
     return widget ? widget.selected : false;
  }
  get myTempsSelected() {
    const widget = this.availableWidgets.find((c) => c.column === "My temps" || c.column === "My Workers");
    return widget ? widget.selected : false;
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
     const widget = this.availableWidgets.find((c) => c.column === "Today's Workforce")
     return widget ? widget.selected : false;
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

  get vmscontact() {
    return getFieldValue(this.contactRecord.data, VMS_CONTACT_FIELD);

  }

  get vmsClientcontact() {
    return getFieldValue(this.contactRecord.data, VMS_CLIENT_CONTACT_FIELD);


  }
  get portaltype() {
    return getFieldValue(this.contactRecord.data, PORTAL_TYPE_FIELD);

  }

  get enableWorkerEndorsement() {
    return getFieldValue(
      this.accountRecord.data,
      ENABLE_WORKER_ENDORSEMENT_FIELD
    );
  }
}
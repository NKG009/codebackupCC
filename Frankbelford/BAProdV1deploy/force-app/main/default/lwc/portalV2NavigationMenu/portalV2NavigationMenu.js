import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import basePath from "@salesforce/community/basePath";
import getNavigationMenuItems from "@salesforce/apex/CPV2_NavigationMenuItemsController.getNavigationMenuItems";
import isGuestUser from "@salesforce/user/isGuest";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId";
import VMS_CONTACT_FIELD from "@salesforce/schema/Contact.VMS_Contact__c";
import VMS_CLIENT_CONTACT_FIELD from "@salesforce/schema/Contact.VMS_Client_Contact__c";
import PORTAL_TYPE_FIELD from "@salesforce/schema/Contact.Portal_Type__c";
import ENABLE_WORKER_ENDORSEMENT_FIELD from "@salesforce/schema/Account.Enable_Worker_Endorsement__c";

import USER_ID from "@salesforce/user/Id";
export default class PortalV2NavigationMenu extends LightningElement {
  @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
  user;
  blueArrowLogo = SITE_ASSETS + "/img/logo/logoPrimary.svg";
  informationLogo = SITE_ASSETS + "/img/icons/cog-dk-grey.svg";
  theBasePath = basePath + "/";

  @api menuName;
  @api settingsPath = "/cpv2/s/settings";
  menuItems = [];
  isLoaded = false;
  error;

  publishedState;
  contactRecord;
  accountRecord;

  @wire(getRecord, {
    recordId: "$contactId",
    fields: [ACCOUNT_ID_FIELD,VMS_CONTACT_FIELD,VMS_CLIENT_CONTACT_FIELD,PORTAL_TYPE_FIELD]
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
  async account(data, error) {
    if (data) {
      this.accountRecord = data;
      if (this.accountRecord.data === undefined) {
        return;
      }
      const menuItemOutput = await getNavigationMenuItems({
        menuName: this.menuName,
        publishedState: this.publishedState
      });
      this.processMenuItems(menuItemOutput);
      console.log('menuitems:'+ JSON.stringify(menuItemOutput));
    } else if (error) {
      this.error = error;
      this.menuItems = [];
      this.isLoaded = true;
      console.log(`Navigation Menu Error: ${JSON.stringify(this.error)}`);
    }
  }

  @wire(CurrentPageReference)
  setCurrentPageReference(currentPageReference) {
    const app =
      currentPageReference &&
      currentPageReference.state &&
      currentPageReference.state.app;
    if (app === "commeditor") {
      this.publishedState = "Draft";
    } else {
      this.publishedState = "Live";
    }
  }

  processMenuItems(data) {
    
    const vmsContact = this.contactRecord.data.fields.VMS_Contact__c.value; 
    const vmsClientContact = this.contactRecord.data.fields.VMS_Client_Contact__c.value; 
    const vmsclientportaltype = this.contactRecord.data.fields.Portal_Type__c.value; 
    this.menuItems = data
      .map((item, index) => {
        const workerEndorsement = this.enableWorkerEndorsement;
        console.log(workerEndorsement);
        let showMenuItem = false;
        if (item.Label === "Dashboard" || item.Target === "/contact-us") {
          showMenuItem = true;
        }
        else if(( item.Label === 'Help' ||  item.Target === '/todays-workforce') && !vmsContact){
          showMenuItem = true;
        }
        else if (vmsContact) {
          const allowedItems = [
            "/my-timesheets",
            "/my-candidates",
            "/my-job-order",
            "/hour-submission"
          ];
          showMenuItem = allowedItems.includes(item.Target);
        }
    
       
        else if (vmsClientContact) {
          const allowedItems = [
            "/shift-approval-vms",
            "/timesheets-vms-client",
            "/job-order-vms-client",
            "/my-shifts-vms-client"
          ];
          showMenuItem = allowedItems.includes(item.Target);
          if(item.Target === "/job-order-vms-client" && vmsclientportaltype ==="VMS - Hours Approver"){
            showMenuItem = false;
          }
        }
    
        else {
          const defaultItems = [
            "/shift-management",
            "/my-shifts"
          ];
          showMenuItem = defaultItems.includes(item.Target);
          if (item.Target === "/my-preferred-workers") {
           showMenuItem = true && !(item.Target === "/my-preferred-workers" && !workerEndorsement);
          }
        }
        
        return {
          target: item.Target,
          id: index,
          label: item.Label,
          defaultListViewId: item.DefaultListViewId,
          type: item.Type,
          accessRestriction: item.AccessRestriction,
          showMenuItem: showMenuItem 
        };
      })
      .filter((item) => {
        // Only show "Public" items if guest user.
        return (
          item.accessRestriction === "None" ||
          (item.accessRestriction === "LoginRequired" && !isGuestUser)
        );
      });
    this.error = undefined;
    this.isLoaded = true;
    console.log(this.contactId);
  }

  handleMenuItemClick(event) {
    let selectedItemTarget = event.detail;

    this.template
      .querySelectorAll("c-portal-v2-navigation-menu-item")
      .forEach(function (theChildComponent) {
        theChildComponent.removeActiveClass();
      });

    this.template
      .querySelector(
        'c-portal-v2-navigation-menu-item[data-id="' + selectedItemTarget + '"]'
      )
      .addActiveClass();
  }

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
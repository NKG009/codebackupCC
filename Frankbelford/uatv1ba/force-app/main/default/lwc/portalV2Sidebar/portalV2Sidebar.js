import { LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import fetchUserInformation from "@salesforce/apex/SiteManagementComponentController.fetchUserInformation";
import fetchSelectedSiteOwnerInformation from "@salesforce/apex/SiteManagementComponentController.fetchSelectedSiteOwnerInformation";
import getSitesOfLoggedInUser from "@salesforce/apex/SiteManagementComponentController.getSitesOfLoggedInUser";
import { getCookie } from "c/portalV2Utility";
import { registerListener } from "c/pubsub";
import USER_ID from "@salesforce/user/Id";
import VMS_CONTACT_FIELD from "@salesforce/schema/Contact.VMS_Contact__c";
import CONTACT_ID_FIELD from "@salesforce/schema/User.ContactId";

export default class PortalV2Sidebar extends LightningElement {
  userIcon = SITE_ASSETS + "/img/dashboard/userIcon.svg";
  emailLogo = SITE_ASSETS + "/img/icons/primary-anchor-caret.svg";
  loggedInUserDetails = {};
  loggedInUserSites;
  hasEmailAddress = false;
  siteSelectedByUser;
  showSiteOwnerDetails = false;
  siteOwnerDetails = {};
  vmscontact;
  notshowsites=true;

  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }
  

  @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID_FIELD] })
  user;
  contactRecord;

  get contactId() {
    return getFieldValue(this.user.data, CONTACT_ID_FIELD);
  }

  @wire(getRecord, {
    recordId: "$contactId",
    fields: [VMS_CONTACT_FIELD]
  })
   contact(data, error) {
    if (data) {
    
      this.contactRecord = data;
      console.log('this.contactRecord'+ JSON.stringify(this.contactRecord));
      if (this.contactRecord.data === undefined) {
        return;
      }
      this.notshowsites=this.contactRecord.data.fields.VMS_Contact__c.value;
      
     
    } else if (error) {
      console.error(error);
    }
  }

  connectedCallback() {
    try{
    console.log("connectedCallback" );
    setTimeout(async () => {
      console.log("connectedCallback after 2 sec delay" );
   // this.vmscontact=this.contactRecord.data.fields.VMS_Contact__c.value; 
    // this.notshowsites =this.vmscontact;
    console.log("this.notshowsites"+ this.notshowsites);
    if( this.notshowsites==false){

    console.log("Site Selected By User: ", getCookie("siteSelectedByUser"));

    this.fetchLoggedInUserInformation();
    this.fetchLoggedInUserSites();

    this.showSiteOwnerDetails = false;
    }
		registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    }, 5000);
   
  } catch (error) {
    console.error("Error in connectedCallback:", error);
  }
  }

		 handleSiteChangeEvent(eventPayload) {
				 if (eventPayload) {
						var siteId = JSON.parse(eventPayload).toString();
						 if(siteId !== undefined && !siteId.includes(',')){
								 this.showSelectedSiteOwnerInformation(siteId)
						 } 
    }
  }

  fetchLoggedInUserSites() {
    getSitesOfLoggedInUser()
      .then((result) => {
        const sites = [...result];

        if (result.length === 1) {
          result[0].Id = `"${result[0].Id}"`;
        } else if (result.length > 1) {
          sites.forEach((site) => {
            site.Id = `"${site.Id}"`;
          });

          const siteIds = sites.map((site) => site.Id);
          const allSites = siteIds.join(",");
          sites.unshift({ Id: allSites, Name: "All Sites" });
        }

        this.initLoggedInUserSiteOptions(sites);
        console.log("Logged In User Sites: ", result);
      })
      .catch((error) => {
        this.showMessageToUser(
          "error",
          "An internal error occurred while fetching logged-in user sites."
        );

        console.log("Logged In User Sites Error As Object: ", error);
        console.log(
          "Logged In User Sites Error As String: ",
          JSON.stringify(error)
        );
      });
  }

  initLoggedInUserSiteOptions(sites) {
    // Init logged in user sites.
    this.loggedInUserSites = [];

    let defaultSiteId = undefined;
    sites.forEach((site) => {
      defaultSiteId = site.Id;
      this.loggedInUserSites.push({
        value: `[${site.Id}]`,
        label: site.Name
      });
    });

    if (this.loggedInUserSites.length == 1) {
      this.showSelectedSiteOwnerInformation(
        defaultSiteId.replace('"', "").replace('"', "")
      );
    }
  }

  fetchLoggedInUserInformation() {
    fetchUserInformation()
      .then((result) => {
        this.loggedInUserDetails = {
          name: result.Name,
          jobTitle: result.Title
        };
      })
      .catch((error) => {
        this.showMessageToUser(
          "error",
          "An internal error occurred while fetching logged-in user information."
        );

        console.log("Logged In User Information Error As Object: ", error);
        console.log(
          "Logged In User Information Error As String: ",
          JSON.stringify(error)
        );
      });
  }

  showSelectedSiteOwnerInformation(selectedSiteId) {
    fetchSelectedSiteOwnerInformation({
      theSiteId: selectedSiteId
    })
      .then((result) => {
        this.showSiteOwnerDetails = true;

        this.siteOwnerDetails = {
          name: result.FirstName + " " + result.LastName,
          title: result.Title,
          brand: result.Brand__c,
          phoneNumber: result.Phone,
          emailAddress: result.Email,
          emailAddressHref: "mailto:" + result.Email
        };

        this.hasEmailAddress = this.siteOwnerDetails.emailAddress
          ? true
          : false;
        console.log("Selected Site Owner Information: ", result);
      })
      .catch((error) => {
        this.showMessageToUser(
          "error",
          "An internal error occurred while fetching selected site owner information."
        );

        console.log("Selected Site Owner Information Error As Object: ", error);
        console.log(
          "Selected Site Owner Information Error As String: ",
          JSON.stringify(error)
        );
      });
  }

  showMessageToUser(theVariant, theMessage) {
    const event = new ShowToastEvent({
      message: theMessage,
      variant: theVariant
    });
    this.dispatchEvent(event);
  }
}
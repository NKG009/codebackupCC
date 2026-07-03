import { LightningElement, wire } from "lwc";
import getSitesOfLoggedInUser from "@salesforce/apex/SiteManagementComponentController.getSitesOfLoggedInUser";
import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import { setCookie, getCookie, showMessageToUser } from "c/portalV2Utility";
export default class PortalV2SiteSwitchWidget extends LightningElement {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  siteSelectedByUser;
  loggedInUserSites;

  async connectedCallback() {
    await this.fetchLoggedInUserSites();
  }

  async fetchLoggedInUserSites() {
    let siteToSetAsDefault;
    try {
      const result = await getSitesOfLoggedInUser();

      const sites = [...result];

      if (result.length === 1) {
        result[0].Id = `"${result[0].Id}"`;
        siteToSetAsDefault = result[0];
      } else if (result.length > 1) {
        sites.forEach((site) => {
          site.Id = `"${site.Id}"`;
        });

        const siteIds = sites.map((site) => site.Id);
        const allSites = siteIds.join(",");
        sites.unshift({ Id: allSites, Name: "All Sites" });
        siteToSetAsDefault = sites[0];
      }
      this.initLoggedInUserSiteOptions(sites);
      this.isPicklistDisabled = false;
      console.log("Logged In User Sites: ", result);

      const siteSelectedCookie = getCookie("siteSelectedByUser");
      let cookieInSiteList = true;
      let cookieValid = true;
      try {
        cookieInSiteList =
          sites.filter((site) => site === JSON.parse(siteSelectedCookie)) !==
          [];
      } catch (e) {
        cookieValid = false;
      }

      if (siteSelectedCookie && cookieValid) {
        if (!cookieInSiteList) {
          this.setSiteAsDefault(siteSelectedCookie, true);
        } else {
          this.setSiteAsDefault(`[${siteToSetAsDefault.Id}]`);
        }
      } else if (siteToSetAsDefault && !cookieValid) {
        this.setSiteAsDefault(`[${siteToSetAsDefault.Id}]`);
      } else {
        this.isPicklistDisabled = true;
      }
    } catch (error) {
      this.isPicklistDisabled = true;
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
      setCookie("siteSelectedByUser", "[]", 365);
    }
  }

  initLoggedInUserSiteOptions(sites) {
    //init logged in user sites
    this.loggedInUserSites = [];

    sites.forEach((site) => {
      this.loggedInUserSites.push({
        value: `[${site.Id}]`,
        label: site.Name
      });
    });
  }

  setSiteAsDefault(defaultSite) {
    this.siteSelectedByUser = defaultSite.replace(/\/g/, "");

    setCookie("siteSelectedByUser", this.siteSelectedByUser, 365);
    this.firePageChangeEvent();
  }

  selectionChangeHandler(event) {
    if (event.target.value) {
      this.siteSelectedByUser = event.target.value;

      console.log(this.siteSelectedByUser);
      setCookie("siteSelectedByUser", this.siteSelectedByUser, 365);
      this.firePageChangeEvent();
      console.log("Site Selected By User: ", this.siteSelectedByUser);
      this.getShiftRecords();
    }
  }
  firePageChangeEvent() {
    fireEvent(this.pageRef, "siteChangeEvent", this.siteSelectedByUser);
  }
}
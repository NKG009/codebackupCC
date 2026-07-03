import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import basePath from "@salesforce/community/basePath";

export default class PortalV2NavigationMenuItem extends NavigationMixin(
  LightningElement
) {
  /**
   * The NavigationMenuItem from the Apex controller, contains a label and a target.
   */
  @api item = {};
  activeClass = "navigation-link";
  href = "javascript:void(0);";

  /**
   * The PageReference object used by lightning/navigation.
   */
  pageReference;

  connectedCallback() {
    const { type, target, defaultListViewId } = this.item;

    // Get the correct PageReference object for the menu item type.
    if (type === "SalesforceObject") {
      // "Salesforce Object" menu item.
      this.pageReference = {
        type: "standard__objectPage",
        attributes: {
          objectApiName: target
        },
        state: {
          filterName: defaultListViewId
        }
      };
    } else if (type === "InternalLink") {
      // "Site Page" menu item.

      // WARNING: Normally you shouldn't use 'standard__webPage' for internal relative targets, but
      // we don't have a way of identifying the Page Reference type of an InternalLink URL.
      if (target === "/shift-management") {
        this.pageReference = {
          type: "standard__webPage",
          attributes: {
            url: basePath + target
          }
        };
      } else {
        this.pageReference = {
          type: "standard__webPage",
          attributes: {
            url: basePath + target
          }
        };
      }
    } else if (type === "ExternalLink") {
      // "External URL" menu item.
      this.pageReference = {
        type: "standard__webPage",
        attributes: {
          url: target
        }
      };
    }

    // Use the NavigationMixin from lightning/navigation to generate the URL for navigation.
    if (this.pageReference) {
      this[NavigationMixin.GenerateUrl](this.pageReference).then((url) => {
        this.href = url;
      });
    }
  }

  handleClick(event) {
    // Use the NavigationMixin from lightning/navigation to perform the navigation.
    event.stopPropagation();
    event.preventDefault();

    if (this.pageReference) {
      console.log(this.pageReference);
      this[NavigationMixin.Navigate](this.pageReference);
    } else {
      console.log(
        `Navigation menu type "${
          this.item.type
        }" not implemented for item ${JSON.stringify(this.item)}`
      );
    }

    this.dispatchEvent(
      new CustomEvent("menuitemclicked", {
        detail: this.item.target
      })
    );
  }

  @api removeActiveClass() {
    this.activeClass = "navigation-link";
  }

  @api addActiveClass() {
    this.activeClass = "bluearrow-brand-color navigation-link";
  }
}
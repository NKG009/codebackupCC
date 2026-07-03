import { LightningElement, api } from "lwc";
import defaultPageSize from "@salesforce/label/c.Portal_V2_Default_Page_Size";

export default class PortalV2Pagination extends LightningElement {
  @api totalrecords;
  @api currentPage;
  totalPages = 0;
  disablePrevious = false;
  disableNext = false;
  theLayout = {};

  connectedCallback() {
    this.computeTotalPages(this.totalrecords);
    this.designLayout();
  }

  @api
  computeTotalPages(theTotalRecords) {
    this.totalrecords = theTotalRecords;
    this.totalPages = Math.ceil(this.totalrecords / parseInt(defaultPageSize));
  }

  @api
  updateCurrentPage(theCurrentPage) {
    this.currentPage = theCurrentPage;
  }

  @api
  designLayout() {
    let previousTag = {
      tag: "previous",
      disabled: false
    };
    let nextTag = {
      tag: "next",
      disabled: false
    };
    if (this.currentPage === 1) {
      this.disablePrevious = true;
      previousTag.disabled = this.disablePrevious;
    } else if (this.currentPage === this.totalPages) {
      this.disableNext = true;
      nextTag.disabled = this.disableNext;
    }

    let thePages = [];
    if (this.totalPages > 6) {
      for (let index = 1; index <= 3; index++) {
        thePages.push({
          tag: index,
          rule:
            index === this.currentPage
              ? "slds-p-horizontal_small next-previous-button-disabled"
              : "slds-p-horizontal_small next-previous-button",
          variant: index === this.currentPage ? "brand" : "base",
          skip: false
        });
      }

      if (this.currentPage != 4) {
        thePages.push({
          tag: "...",
          rule: "slds-p-horizontal_small",
          variant: "base",
          skip: true
        });
      }

      if (this.currentPage > 3 && this.currentPage < this.totalPages - 2) {
        thePages.push({
          tag: this.currentPage,
          rule: "slds-p-horizontal_small next-previous-button-disabled",
          variant: "brand",
          skip: false
        });

        if (this.currentPage != this.totalPages - 3) {
          thePages.push({
            tag: "...",
            rule: "slds-p-horizontal_small",
            variant: "base",
            skip: true
          });
        }
      }

      for (let index = this.totalPages - 2; index <= this.totalPages; index++) {
        thePages.push({
          tag: index,
          rule:
            index === this.currentPage
              ? "slds-p-horizontal_small next-previous-button-disabled"
              : "slds-p-horizontal_small next-previous-button",
          variant: index === this.currentPage ? "brand" : "base",
          skip: false
        });
      }
    } else {
      for (let index = 1; index <= this.totalPages; index++) {
        thePages.push({
          tag: index,
          rule:
            index === this.currentPage
              ? "slds-p-horizontal_small next-previous-button-disabled"
              : "slds-p-horizontal_small next-previous-button",
          variant: index === this.currentPage ? "brand" : "base",
          skip: false
        });
      }
    }

    this.theLayout = {};
    this.theLayout.previous = previousTag;
    this.theLayout.pages = thePages;
    this.theLayout.next = nextTag;
  }

  pageSelectedByUser(event) {
    this.disablePrevious = false;
    this.disableNext = false;

    let pageSelected = event.target.dataset.page;
    if (pageSelected == "...") {
      return;
    }

    if (pageSelected === "next") {
      this.currentPage++;
    } else if (pageSelected === "previous") {
      this.currentPage--;
    } else {
      this.currentPage = parseInt(pageSelected);
    }

    if (this.currentPage < 1) {
      this.currentPage = 1;
      this.disablePrevious = true;
    } else if (this.currentPage > this.totalPages) {
      this.currentPage = this.totalPages;
      this.disableNext = true;
    }

    this.designLayout();
    this.dispatchEvent(
      new CustomEvent("pageselected", { detail: this.currentPage })
    );
  }
}
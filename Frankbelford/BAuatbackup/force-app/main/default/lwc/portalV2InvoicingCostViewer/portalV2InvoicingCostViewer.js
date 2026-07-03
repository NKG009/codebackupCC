import { LightningElement } from "lwc";

import getTimesheets from "@salesforce/apex/PortalV2SiteAssignmentController.getTimesheets";

export default class PortalV2InvoicingCostViewer extends LightningElement {
  results = [];

  PONumber; // = "ABCDE12345";
  unitId;

  async handleSearchClick() {
    const result = await getTimesheets({
      PONumber: this.PONumber,
      unitId: this.unitId
    });

    console.log(result);
    this.parseResult(result);
  }

  onPOChange(event) {
    this.PONumber = event.target.value;
  }

  onUnitIdChange(event) {
    this.unitId = event.target.value;
  }

  parseResult(result) {
    this.results = [];

    result.forEach((item) => {
      let matchingRecord = this.results.find((record) => {
        return (
          record.name === item.sirenum__Worker__r.Name &&
          record.poNumber === item.IP_Client_Invoice_PO__c &&
          record.unitId === item.sirenum__Site__r.Unit_ID__c
        );
      });

      if (matchingRecord) {
        matchingRecord.totalCharge += item.Formula_total_charge__c;
      } else {
        this.results.push({
          id: item.Id,
          name: item?.sirenum__Worker__r.Name,
          unitId: item?.sirenum__Site__r?.Unit_ID__c,
          site: item?.sirenum__Site__r.Name,
          poNumber: item.IP_Client_Invoice_PO__c,
          totalCharge: item.Formula_total_charge__c
        });
      }
    });
  }

  get totalCharge() {
    const result = this.results.reduce((previousValue, currentValue) => {
      return previousValue + currentValue.totalCharge;
    }, 0);
    console.log(result);
    return result;
  }
}
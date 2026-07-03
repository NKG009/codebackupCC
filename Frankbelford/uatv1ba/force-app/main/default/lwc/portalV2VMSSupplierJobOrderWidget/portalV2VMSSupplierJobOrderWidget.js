import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";
import getAllJobOrders from "@salesforce/apex/PortalV2MyJobOrdersController.getAllJobOrders";

export default class PortalV2VMSSupplierDashboard extends NavigationMixin(LightningElement) {
  joborderPagename='My_Job_Order__c';
  candidatePagename='My_Candidates__c';
  suptimesheetPageName='My_Timesheets__c';
  hourssubmissionPageName='Hour_Submission__c';

  loadingJobOrder=false;
  openJobOrders;
  loading=true;
  @api
  hideNavButton = false;
  @api
  overrideStyle = "";
  
  
  
  
  connectedCallback() {
    this.fetchJobOrderRecords();
  }

  async fetchJobOrderRecords() {
    console.log('fetchJobOrderRecords brf: ');
    getAllJobOrders()
      .then((results) => {
        console.log(
          "fetchJobOrderRecords: " + JSON.stringify(results));
        this.openJobOrders = results.length;
        this.loading=false;
        
      })
      .catch((error) => {
        console.log("Fetch Job Order Records Error: ", error);
      });
  }

  navigate() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: this.joborderPagename
      }
    });
  }
}
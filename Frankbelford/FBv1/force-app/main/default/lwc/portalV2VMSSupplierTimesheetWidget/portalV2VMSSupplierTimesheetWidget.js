import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";
import getAllJobOrders from "@salesforce/apex/PortalV2MyJobOrdersController.getAllJobOrders";

export default class PortalV2VMSSupplierDashboard extends NavigationMixin(LightningElement) {
 
  suptimesheetPageName='My_Timesheets__c';
 

  loadingJobOrder=false;
  openJobOrders;
  loading=false;
  
  
  
  
  

  navigate() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: this.suptimesheetPageName
      }
    });
  }
}
import { LightningElement, api, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";

import { registerListener } from "c/pubsub";
import { getMonday } from "c/portalV2Utility";

import getTotalCostPerWeek from "@salesforce/apex/PortalV2DashboardController.getTotalCostPerWeek";

export default class PortalV2TotalCostPerWeekWidget extends NavigationMixin(
  LightningElement
) {
  pageRef;
  @wire(CurrentPageReference)
  wirePageRef(data) {
    if (data) {
      this.pageRef = data;
      this.dispatchEvent(new CustomEvent("ready"));
    }
  }

  @api
  siteId;
  @api
  navigationPageName;
  totalCostPerWeekValues;
  hoursPerWeekValues;
  dataMap;
  xAxisValues;
  totalCostView = true;
  loading = true;

  connectedCallback() {
    registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
    if (!this.siteId) return;
    this.localSiteId = this.siteId;
    this.refreshData();
  }

  async refreshData() {
    //Cost per week
    const data = await getTotalCostPerWeek({
      siteId: this.localSiteId
    });
    this.compileDataMap(data);
    this.totalCostPerWeekValues = this.getTotalCostPerWeekValues();

    //Hours per week
    this.hoursPerWeekValues = this.getHoursPerWeekValues();
    this.loading = false;
  }

  compileDataMap(data) {
    let dataMap = {};
    data.forEach((val) => {
      const monday = getMonday(val?.sirenum__Week_Ending__c);
      const formattedDate = `${monday.getDate()}/${monday.getMonth() + 1}`;
      if (!dataMap[formattedDate]) {
        dataMap[formattedDate] = [];
      }
      dataMap[formattedDate].push(val);
    });
    this.dataMap = dataMap;
    this.xAxisValues = Object.keys(dataMap);
  }

  getHoursPerWeekValues() {
    let hoursValues = [];

    Object.keys(this.dataMap).forEach((val) => {
      if (this.dataMap[val].length === 0) {
					console.log(this.dataMap[val]);
					this.dataMap[val] = [{ sirenum__Client_Bill__c: 0 }];
        //this.dataMap[val] = [{ sirenum__Timesheet_summaries__r.sirenum__Total_Hours__c: 0 }];//Scheduled_hours_minus_break__c: 0 }];
        
      }
      hoursValues.push(
        this.dataMap[val]
          .reduce((total, currentValue) => {
							if(currentValue.sirenum__Total_Hours__c !== null && currentValue.sirenum__Total_Hours__c !== undefined) {
            			return total + currentValue.sirenum__Total_Hours__c;
							}else{
									return total;
							}
									
          }, 0)
          .toFixed(2)
      );
    });
    console.log(hoursValues);
    return hoursValues;
  }

  getTotalCostPerWeekValues() {
    let costValues = [];

    Object.keys(this.dataMap).forEach((val) => {
      if (this.dataMap[val].length === 0) {
			  console.log('this.dataMap[val]:::',this.dataMap[val]);
          this.dataMap[val] = [{ sirenum__Client_Bill__c: 0 }];
      }
      costValues.push(
        this.dataMap[val]
          .reduce((total, currentValue) => {
							if(currentValue.sirenum__Client_Bill__c !== null && currentValue.sirenum__Client_Bill__c !== undefined) {
            		return total + currentValue.sirenum__Client_Bill__c;
							}else{
									return total;
							}
          }, 0)
          .toFixed(2)
      );
    });
    console.log(costValues);
    return costValues;
  }

  get data() {
    return this.totalCostView
      ? this.totalCostPerWeekValues
      : this.hoursPerWeekValues;
  }

  get hasData() {
    if (this.totalCostView) {
      return (
        this.totalCostPerWeekValues !== undefined &&
        this.totalCostPerWeekValues.length > 0
      );
    }
    return (
      this.hoursPerWeekValues !== undefined &&
      this.hoursPerWeekValues.length > 0
    );
  }

  get toggleButtonLabel() {
    return this.totalCostView ? "View hours" : "View cost";
  }

  get title() {
    return this.totalCostView ? "Total cost per week" : "Total hours per week";
  }

  toggleTotalHoursView() {
    this.totalCostView = !this.totalCostView;
  }

  navigate() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: this.navigationPageName
      }
    });
  }

  handleSiteChangeEvent(eventPayload) {
    console.log("Recieved Site Change event:", eventPayload);

    if (eventPayload) {
      this.localSiteId = eventPayload;
    }

    this.refreshData();
  }
}
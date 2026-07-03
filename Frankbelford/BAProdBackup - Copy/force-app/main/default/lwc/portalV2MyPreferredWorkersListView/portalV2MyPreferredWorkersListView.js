import { LightningElement,wire,track } from 'lwc';
import { registerListener } from "c/pubsub";
import { getCookie, setCookie, parseSiteValue } from "c/portalV2Utility";
import { CurrentPageReference } from "lightning/navigation";

export default class PortalV2MyPreferredWorkersListView extends LightningElement {
    
    isPreferredWorker = true;
    loading = true;
    @track siteId;
    @wire(CurrentPageReference) pageRef;

    handleViewToggleClick(){
        this.isPreferredWorker = !this.isPreferredWorker;    
        this.loading = true;  
        setTimeout(() => {
            this.loading = false;
        }, 1000);  
    }

    get viewPreferred(){
        return (this.isPreferredWorker)?'Preferred Workers':'Recent Workers'
    }

    get viewSwitchLabel(){
        return (this.isPreferredWorker)?'View Recent Workers':'View Preferred Workers'
    }

    handleSiteChangeEvent(eventPayload) {
		console.log("Worker: Recieved Site Change event:", eventPayload);
        this.loading = true;
		if (eventPayload) {
		  var siteList = JSON.parse(eventPayload);
          this.siteId = ((siteList+'').indexOf(',') > -1)?'All':siteList;
		}

        setTimeout(() => {
            this.loading = false;
        }, 1000);
		
	}
	populateFromCookie() {
	    const cookie = getCookie("siteSelectedByUser");
        var siteList = parseSiteValue(cookie);
        this.siteId = ((siteList+'').indexOf(',') > -1)?'All':siteList;	
        this.loading = false;
		
	  }

  connectedCallback() {
        registerListener("siteChangeEvent", this.handleSiteChangeEvent, this);
        this.populateFromCookie();
  }
}
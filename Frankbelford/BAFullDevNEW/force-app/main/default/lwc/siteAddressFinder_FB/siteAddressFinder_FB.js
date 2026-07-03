import { LightningElement, api, track } from 'lwc';
export default class SiteAddressFinder_FB extends LightningElement {
    @api recordId;
    @track sObject;

    connectedCallback() {
        console.log('================= recordId : '+JSON.stringify(recordId));
        console.log('================= sObject : '+JSON.stringify(sObject));
    }


}
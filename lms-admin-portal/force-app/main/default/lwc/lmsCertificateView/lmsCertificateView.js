import { LightningElement, api } from 'lwc';
export default class LmsCertificateView extends LightningElement {
    @api cert = {};
    get formattedDate() { return this.cert?.Date_Issued__c ? new Date(this.cert.Date_Issued__c).toLocaleDateString() : ''; }
}

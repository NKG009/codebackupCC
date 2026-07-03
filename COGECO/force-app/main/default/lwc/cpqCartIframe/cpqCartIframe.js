import { LightningElement, api } from 'lwc';

export default class CpqCartIframe extends LightningElement {
    @api url;
    @api quoteId;
    @api recordId;

    connectedCallback() {
        if (this.quoteId) {
            this.recordId = this.quoteId;
        }

        this.url = "/apex/vlocity_cmt__hybridcpq?id=" + this.recordId;
    }
}
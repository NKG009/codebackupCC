import { LightningElement, api, track } from 'lwc';

export default class DocumentPreviewModal extends LightningElement {
    @api url;
    @api fileExtension;
    @api recordId;
    @track showFrame = false;
    @track showModal = false;

    @api
    show() {
        console.log('### File Extension:', this.fileExtension);
       // console.log('From Preview Component, Doc Public Link Is :' , this.url);
        
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }
}
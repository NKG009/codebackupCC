import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class NewQuoteOverride extends LightningElement {
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: 'Success!',
            message: 'Quote created with ID: ' + event.detail.id,
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
    }

    handleError(event) {
        // Error handling logic can go here if lightning-messages isn't enough
        console.error('Error creating record: ', event.detail.message);
    }

}
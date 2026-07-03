import { LightningElement, api } from 'lwc';
import generateAndEmailPdf from '@salesforce/apex/SendOrderAcknowledgementLWCController.generateAndEmailPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SendOrderAcknowledgementLWC extends LightningElement {

    @api recordId;
    isExecuted = false;

    connectedCallback() {
    console.log('connected recordId:', this.recordId);
}

    renderedCallback() {
        console.log('id:'+this.recordId);
        if (this.executed || !this.recordId) return;

        this.executed = true;
        // prevent double execution
        console.log('id:'+this.recordId);
       


        generateAndEmailPdf({ orderId: this.recordId })
            .then(() => {
                // Success toast
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Order acknowledgement sent successfully.',
                        variant: 'success'
                    })
                );

                // Close quick action after short delay
                setTimeout(() => {
                    this.dispatchEvent(new CloseActionScreenEvent());
                }, 1200);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body?.message || 'Failed to send order acknowledgement',
                        variant: 'error'
                    })
                );
            });
    }

}
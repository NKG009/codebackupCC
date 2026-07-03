import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';

export default class testNavigate extends NavigationMixin(LightningElement) {
    @api recordId = '';
    @api objectName = '';

    renderedCallback() {
        // Use renderedCallback to directly navigate to the record
        if (this.recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            });
        }
    }
}
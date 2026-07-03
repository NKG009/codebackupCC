import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import fetchRecordTypeId from '@salesforce/apex/AccountNewCustomCreationController.fetchRecordTypeId';
export default class AccountNewCustomCreation extends LightningElement {

    @api selectedRecordType;
    @track accountId;
    @track rId;
    @track showRTScreen = false;

    connectedCallback() {
        this.showRTScreen = true;
    }

    handleSuccess(event) {
        this.accountId = event.detail.id;
        this.showToast = true;

        // Show success message
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Account created successfully',
            variant: 'success'
        }));

        this.launchFlow();

    }

    launchFlow() {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: `/flow/Create_A_New_Account?accountId=${this.accountId}`
                }
            });
        }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.RecordTypeId  = this.fetchRecordTypeId();
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    fetchRecordTypeId() {
        fetchRecordTypeId({ 'recordTypeName': this.selectedRecordType }).then(data => {
            if (data) {
                this.rId = data;
            }
        });
    }

}
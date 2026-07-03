import { LightningElement, api, track,wire } from 'lwc';
import createOrAssignCommunityUser from '@salesforce/apex/CommunityUserProcessAutomationLWCCtlr.createOrAssignCommunityUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import { CurrentPageReference } from "lightning/navigation";
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
export default class CommunityUserProcessAutomationLWC extends LightningElement {

    @api recordId;
     @track isLoading = true;
    @track helpText = 'Provisioning Community User...';

   pageRefdata;


    hasExecuted = false;

    @wire(CurrentPageReference)
   getPageRef(pageRef) {
        if (pageRef && !this.hasExecuted) {
            this.pageRefdata = JSON.stringify(pageRef);
            console.log('Page Reference: ', this.pageRefdata);

            this.recordId = pageRef.state.recordId;

            if (this.recordId) {
                this.hasExecuted = true;
                this.processingCommunityUser();
            }
        }
    }

    

    //  connectedCallback() {
    //     console.log('Record ID: ', this.recordId);
    //     this.processingCommunityUser();
    // }

    processingCommunityUser() {
        this.isLoading = true;
        this.helpText = 'Processing Community User...';

        createOrAssignCommunityUser({ contactId: this.recordId })
            .then(result => {
                console.log(' Result: ', result);
                this.showToast('Success', result, 'success');

                 this.refreshView();
                getRecordNotifyChange([{ recordId: this.recordId }]);

                setTimeout(() => {
                    this.closeModal();
                }, 300);

            })
            .catch(error => {
                    console.error('Error: ', error);

                this.showToast(
                    'Error',
                    error.body ? error.body.message : error.message,
                    'error',
                    'sticky'
                );

            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    showToast(title, message, variant, mode = 'dismissable') {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant,
                mode
            })
        );
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    refreshView() {
        this.dispatchEvent(new RefreshEvent());
    }
}
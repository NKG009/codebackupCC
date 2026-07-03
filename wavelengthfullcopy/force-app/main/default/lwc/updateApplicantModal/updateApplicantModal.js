import { LightningElement, api } from 'lwc';
import updateApplicant from '@salesforce/apex/PlacementController.updateApplicant';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class UpdateApplicantModal extends LightningElement {
    @api recordId;  

    handleConfirm() {
        updateApplicant({ placementId: this.recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Credential Requirement updated successfully',
                        variant: 'success',
                    }),
                );
                 this.dispatchEvent(new CloseActionScreenEvent());
                 const recordPageUrl = `/lightning/r/AVTRRT__Placement__c/${this.recordId}/view`;
                window.location.href = recordPageUrl;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating Credential Requirement',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    handleCancel() {
       this.dispatchEvent(new CloseActionScreenEvent());
    }
}
import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { CloseActionScreenEvent } from "lightning/actions";

export default class NewQuote extends NavigationMixin(LightningElement) {
    
    objectApiName = 'SBQQ__Quote__c';
    newQuoteId;
    isLoading = true;
    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    /* handleSubmit(event) {
        event.preventDefault();
        
        
    } */
    handleLoad() {
		this.isLoading = false;
	}

    handleSuccess(event) {
        this.newQuoteId = event.detail.id;
        console.log('this.newQuoteId', this.newQuoteId);
        this.navigateToDuplicate();
        this.handleCancel();
    }

    navigateToDuplicate() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.newQuoteId,
                objectApiName: 'SBQQ__Quote__c',
                actionName: 'view'
            }
        });
    }
}
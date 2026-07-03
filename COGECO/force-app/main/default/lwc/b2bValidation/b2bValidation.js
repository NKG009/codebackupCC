import { LightningElement, wire, api, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

import validate from '@salesforce/apex/CustomerSignatureController.validate';

export default class B2bValidation extends NavigationMixin(LightningElement) {
    @track showCompletedComponent = false;
    @track showSignatureComponent = false;
    @track validationResults;
    @track decision;
    @track freshlyCompleted = false;
    @api p1;
    @api p2;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.p1 = currentPageReference.state.p1;
        this.p2 = currentPageReference.state.p2;
    }
 
    connectedCallback() {
        this.validate();     
    }

    validate() {
        validate({ approvalRecordId: this.p2, verificationCode : this.p1 })
        .then(result => {
            let resultDto = JSON.parse(result);
            
            if (resultDto.readyForSignature) {
                this.showSignatureComponent = true;
            } else {
                this.decision = resultDto.customerApprovalRecord.Status__c;
                this.showCompletedComponent = true;
            }
        }).catch(error => {
            this.navigate("comm__namedPage", "error");
        });
    }

    handleFormSubmitted(event) {
        this.decision = event.detail.decision;
        this.freshlyCompleted = true;

        this.showSignatureComponent = false;
        this.showCompletedComponent = true;
    }

    navigate(type, pageName, state) {
        this[NavigationMixin.Navigate]({
            type: type,
            attributes: {
                pageName: pageName
            },
            state: state
        });
    }
}
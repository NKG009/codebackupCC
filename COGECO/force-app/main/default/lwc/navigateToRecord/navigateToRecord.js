import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigateToRecord extends NavigationMixin(LightningElement) {
    @api opportunityId;
    @api objectApiName;

    connectedCallback() {
        if (!this.objectApiName ) {
            this.objectApiName = 'Opportunity';
        } 

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.opportunityId,
                objectApiName: this.objectApiName,
                actionName: 'view'
            },
        });
    }
}
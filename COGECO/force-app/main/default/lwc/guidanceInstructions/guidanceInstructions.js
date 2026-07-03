import { LightningElement, api, track } from 'lwc';
import getGuidanceInstructions from '@salesforce/apex/GuidanceInstructionsController.getGuidanceInstructions';
import Guidance_For_Success from '@salesforce/label/c.Guidance_For_Success';

export default class GuidanceInstructions extends LightningElement {
    @api recordId;
    @api sObjectTypeReference; 
    @api sObjectTarget;
    @track instructions;
    @track error;
    @track isAccordionActive = false; 
    @track isToggled1 = false; 
    guidanceInstructionsHeading = Guidance_For_Success;

    connectedCallback() {
        this.fetchInstructions();
    }

    fetchInstructions() {
        if (this.recordId && this.sObjectTypeReference && this.sObjectTarget) {
            getGuidanceInstructions({ 
                recordId: this.recordId, 
                sObjectTypeReference: this.sObjectTypeReference,
                sObjectTarget: this.sObjectTarget 
            })
            .then(result => {
                this.instructions = result;
                this.error = undefined;
            })
            .catch(error => {
                this.instructions = undefined;
                this.error = 'Error retrieving instructions: ' + error.body.message;
            });
        } else {
            this.error = 'RecordId, sObjectTypeReference, or sObjectTarget not available.';
        }
    }

    toggleAccordion() {
        this.isAccordionActive = !this.isAccordionActive;
        this.isToggled1 = !this.isToggled1; 
    }

    get buttonIconDown() {
        return this.isToggled1 ? 'utility:chevrondown' : 'utility:chevronup';
    }
}
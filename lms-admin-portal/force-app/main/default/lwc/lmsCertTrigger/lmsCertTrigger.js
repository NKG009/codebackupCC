import { LightningElement, api, track } from 'lwc';
import issueCertification from '@salesforce/apex/LMSGradingController.issueCertification';
export default class LmsCertTrigger extends LightningElement {
    @api attemptId;
    @api learnerName;
    @api disabled = false;
    @track showConfirm = false;
    handleClick() { this.showConfirm = true; }
    handleCancel() { this.showConfirm = false; }
    handleConfirm() {
        this.showConfirm = false;
        issueCertification({ attemptId: this.attemptId })
            .then(() => this.dispatchEvent(new CustomEvent('certified')));
    }
}

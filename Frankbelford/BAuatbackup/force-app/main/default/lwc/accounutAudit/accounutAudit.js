import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import createCandidateAuditRecord from '@salesforce/apex/AccountAuditController.createCandidateAuditRecord';
import AuditResult_FIELD from '@salesforce/schema/Account.Audit_Result__c';
import Note_FIELD from '@salesforce/schema/Account.Note__c';


export default class AccounutAudit extends LightningElement {

    AuditResult = AuditResult_FIELD;
    Notefield = Note_FIELD;

    @api recordId;
    @api objectApiName;

    @track auditToValue;
    @track noteValue;

    handleAuditResultChange(event) {
        this.auditToValue = event.target.value;
    }

    handleNoteChange(event) {
        this.noteValue = event.target.value;
    }

    handleSuccess() {
        console.log('==============recordId'+this.recordId);
        createCandidateAuditRecord({ 'recordId': this.recordId, auditTo: this.auditToValue , note: this.noteValue  }) // Fix the record ID reference
            .then(result => {
                if (result === 'Audited successfully') {
                    console.log('Audit successfully: ', result);
                    this.showToast('Success', 'Audit completed successfully!', 'success');
                } else {
                    this.showToast('Error', result, 'error');
                    console.error('Audit error: ', result);
                }
                this.closeModal();
            })
            .catch(error => {
                console.error('Error creating Audit: ', error);
                this.showToast('Error', 'Audit failed due to unexpected error', 'error');
                this.closeModal();
            });
    }

    handelCancelClick() {
        this.closeModal();
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

}
import { LightningElement, api } from 'lwc';
export default class LmsConfirmModal extends LightningElement {
    @api title = 'Are you sure?';
    @api message = 'This action cannot be undone.';
    handleConfirm() { this.dispatchEvent(new CustomEvent('confirm')); }
    handleCancel() { this.dispatchEvent(new CustomEvent('cancel')); }
}

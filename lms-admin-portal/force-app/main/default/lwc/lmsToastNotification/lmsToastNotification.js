import { LightningElement, api } from 'lwc';
export default class LmsToastNotification extends LightningElement {
    @api message;
    @api variant = 'success';
    get toastClass() { return `toast toast--${this.variant}`; }
    get iconName() { return this.variant === 'success' ? 'utility:success' : this.variant === 'error' ? 'utility:error' : 'utility:info'; }
    connectedCallback() { setTimeout(() => this.dispatchEvent(new CustomEvent('close')), 4000); }
    handleClose() { this.dispatchEvent(new CustomEvent('close')); }
}

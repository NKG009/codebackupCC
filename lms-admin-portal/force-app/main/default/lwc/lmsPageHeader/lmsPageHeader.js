import { LightningElement, api } from 'lwc';
export default class LmsPageHeader extends LightningElement {
    @api title;
    @api subtitle;
    @api showBack = false;
    handleBack() { this.dispatchEvent(new CustomEvent('back')); }
}

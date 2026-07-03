import { LightningElement, api, track } from 'lwc';
import togglePublish from '@salesforce/apex/LMSCourseController.togglePublish';
export default class LmsPublishToggle extends LightningElement {
    @api recordId;
    @api isPublished;
    @track saving = false;
    get label() { return this.isPublished ? 'Published' : 'Draft'; }
    get iconName() { return this.isPublished ? 'utility:check' : 'utility:close'; }
    get btnClass() { return `toggle-btn toggle-btn--${this.isPublished ? 'published' : 'draft'}${this.saving ? ' toggle-btn--saving' : ''}`; }
    handleToggle() {
        this.saving = true;
        togglePublish({ recordId: this.recordId, currentState: this.isPublished })
            .then(() => { this.dispatchEvent(new CustomEvent('publishchange')); })
            .finally(() => { this.saving = false; });
    }
}

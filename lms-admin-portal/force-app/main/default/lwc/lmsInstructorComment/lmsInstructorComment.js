import { LightningElement, api, track } from 'lwc';

export default class LmsInstructorComment extends LightningElement {
    @api answerId;
    @api existing = '';
    @track comment = '';

    connectedCallback() {
        this.comment = this.existing || '';
    }

    handleChange(event) {
        this.comment = event.target.value;
    }

    handleSave() {
        this.dispatchEvent(
            new CustomEvent('save', {
                detail: {
                    answerId: this.answerId,
                    comment: this.comment
                }
            })
        );
    }

    get isSaveDisabled() {
        return !this.comment || this.comment.trim().length === 0;
    }
}
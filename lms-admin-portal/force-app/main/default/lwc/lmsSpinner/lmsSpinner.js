import { LightningElement, api } from 'lwc';

// Reusable spinner overlay.
// Usage:
//   <c-lms-spinner is-visible={isSaving} label="Saving..."></c-lms-spinner>
//   <c-lms-spinner is-visible={isLoading} variant="inline"></c-lms-spinner>
//
// variant="overlay"  (default) — fixed full-screen dark overlay, spinner centred
// variant="inline"             — relative overlay covering just the parent container
// variant="local"              — small inline block spinner, no overlay

export default class LmsSpinner extends LightningElement {
    @api isVisible = false;
    @api label = '';
    @api variant = 'overlay'; // 'overlay' | 'inline' | 'local'

    get overlayClass() {
        return `spinner-overlay spinner-overlay--${this.variant}`;
    }
}

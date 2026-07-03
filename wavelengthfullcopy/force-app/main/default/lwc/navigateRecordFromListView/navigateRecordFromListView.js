import { LightningElement, api } from 'lwc';

export default class NavigateRecordFromListView extends LightningElement { 
    @api recordId;

    connectedCallback() {
        if (this.recordId) {
            window.top.location.href = `/lightning/r/${this.recordId}/view`;
        }
    }
}
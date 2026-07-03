import { LightningElement, api, track } from 'lwc';
import searchRecords from '@salesforce/apex/LMSCourseController.searchRecords';
export default class LmsRecordPicker extends LightningElement {
    @api label = 'Select record';
    @api objectApiName;
    @api value;
    @track searchTerm = '';
    @track results = [];
    @track selectedRecord = null;
    get hasResults() { return this.results.length > 0; }
    handleSearch(e) {
        this.searchTerm = e.target.value;
        if (this.searchTerm.length >= 2) {
            searchRecords({ objectName: this.objectApiName, searchTerm: this.searchTerm })
                .then(data => { this.results = data; });
        } else { this.results = []; }
    }
    handleSelect(e) {
        this.selectedRecord = { Id: e.currentTarget.dataset.id, Name: e.currentTarget.dataset.name };
        this.results = [];
        this.dispatchEvent(new CustomEvent('recordselected', { detail: { recordId: this.selectedRecord.Id } }));
    }
    handleClear() { this.selectedRecord = null; this.searchTerm = ''; this.dispatchEvent(new CustomEvent('recordselected', { detail: { recordId: null } })); }
}

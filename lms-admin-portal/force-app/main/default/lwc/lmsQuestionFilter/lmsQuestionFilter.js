import { LightningElement, track } from 'lwc';
const TYPE_OPTIONS = [
    { label: 'All types', value: '' }, { label: 'MCQ', value: 'MCQ' },
    { label: 'True/False', value: 'True/False' }, { label: 'Open-Ended', value: 'Open-Ended' }, { label: 'Upload', value: 'Upload' },
];
export default class LmsQuestionFilter extends LightningElement {
    @track qtype = ''; @track search = ''; @track activeOnly = true;
    typeOptions = TYPE_OPTIONS;
    emit() { this.dispatchEvent(new CustomEvent('filterchange', { detail: { qtype: this.qtype, search: this.search, activeOnly: this.activeOnly } })); }
    handleType(e) { this.qtype = e.detail.value; this.emit(); }
    handleSearch(e) { this.search = e.target.value; this.emit(); }
    handleActive(e) { this.activeOnly = e.target.checked; this.emit(); }
    handleClear() { this.qtype = ''; this.search = ''; this.activeOnly = true; this.emit(); }
}

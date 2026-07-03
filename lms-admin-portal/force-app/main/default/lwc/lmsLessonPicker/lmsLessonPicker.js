import { LightningElement, api, track } from 'lwc';
import searchLessons from '@salesforce/apex/LMSLessonController.searchLessons';
import addExistingLesson from '@salesforce/apex/LMSLessonController.addExistingLesson';
import createAndAddLesson from '@salesforce/apex/LMSLessonController.createAndAddLesson';

const TYPE_OPTIONS = [
    { label: 'Video', value: 'Video' }, { label: 'Article', value: 'Article' },
    { label: 'PDF', value: 'PDF' }, { label: 'Upload', value: 'Upload' },
];

export default class LmsLessonPicker extends LightningElement {
    @api contextClassId;
    @api courseId;
    @track activeTab = 'existing';
    @track searchTerm = '';
    @track results = [];
    @track selectedId = null;
    @track isLoading = false;
    @track newLesson = { Name: '', Content_Type__c: 'Video' };
    typeOptions = TYPE_OPTIONS;
    _searchTimeout;

    get isExisting() { return this.activeTab === 'existing'; }
    get isNew() { return this.activeTab === 'new'; }
    get noResults() { return !this.isLoading && this.results.length === 0 && this.searchTerm.length >= 2; }
    get cannotAdd() { return this.isExisting ? !this.selectedId : !this.newLesson.Name; }
    get addLabel() { return this.isExisting ? 'Add to course' : 'Create & add'; }
    get existingTabClass() {
    return this.activeTab === 'existing'
        ? 'modal-tab modal-tab--active'
        : 'modal-tab';
}

get newTabClass() {
    return this.activeTab === 'new'
        ? 'modal-tab modal-tab--active'
        : 'modal-tab';
}

    showExisting() { this.activeTab = 'existing'; }
    showNew() { this.activeTab = 'new'; }

    handleSearch(e) {
        this.searchTerm = e.target.value;
        clearTimeout(this._searchTimeout);
        if (this.searchTerm.length < 2) { this.results = []; return; }
        this.isLoading = true;
        this._searchTimeout = setTimeout(() => {
            searchLessons({ searchTerm: this.searchTerm })
                .then(data => {
                    this.results = (data || []).map(l => ({ ...l, selected: l.Id === this.selectedId, cssClass: `result-row${l.Id === this.selectedId ? ' result-row--selected' : ''}` }));
                })
                .finally(() => { this.isLoading = false; });
        }, 300);
    }

    handleSelect(e) {
        this.selectedId = e.currentTarget.dataset.id;
        this.results = this.results.map(l => ({ ...l, selected: l.Id === this.selectedId, cssClass: `result-row${l.Id === this.selectedId ? ' result-row--selected' : ''}` }));
    }

    handleNewField(e) { this.newLesson = { ...this.newLesson, [e.target.dataset.field]: e.target.value }; }

    handleAdd() {
        if (this.isExisting) {
            addExistingLesson({ lessonId: this.selectedId, classId: this.contextClassId, courseId: this.courseId })
                .then(() => this.dispatchEvent(new CustomEvent('lessonselected')));
        } else {
            createAndAddLesson({ lessonData: JSON.stringify(this.newLesson), classId: this.contextClassId, courseId: this.courseId })
                .then(() => this.dispatchEvent(new CustomEvent('lessonselected')));
        }
    }

    handleClose() { this.dispatchEvent(new CustomEvent('close')); }
}

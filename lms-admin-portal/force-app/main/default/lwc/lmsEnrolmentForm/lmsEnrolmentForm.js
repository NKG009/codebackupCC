import { LightningElement, track, wire } from 'lwc';
import getCourseOptions from '@salesforce/apex/LMSCourseController.getCourseOptions';
import searchUsers from '@salesforce/apex/LMSUserController.searchUsers';
import enrolLearner from '@salesforce/apex/LMSEnrolmentController.enrolLearner';

export default class LmsEnrolmentForm extends LightningElement {
    @track enrolment = { Enrolment_Date__c: new Date().toISOString().slice(0, 10), Status__c: 'Not Started' };
    @track learnerSearch = '';
    @track learnerResults = [];
    @track selectedLearnerId = null;
    @track selectedLearnerName = '';
    @track courseOptions = [];
    @track isSaving = false;

    @wire(getCourseOptions)
    wiredCourses({ data }) { if (data) this.courseOptions = data; }

    get cannotSave() { return !this.selectedLearnerId || !this.enrolment.LMS_Course__c; }

    handleLearnerSearch(e) {
        this.learnerSearch = e.target.value;
        if (this.learnerSearch.length >= 2) {
            searchUsers({ searchTerm: this.learnerSearch }).then(data => {
                this.learnerResults = (data || []).map(u => ({ ...u, cssClass: 'result-btn' }));
            });
        } else { this.learnerResults = []; }
    }

    handleSelectLearner(e) {
        this.selectedLearnerId = e.currentTarget.dataset.id;
        this.selectedLearnerName = e.currentTarget.dataset.name;
        this.enrolment = { ...this.enrolment, Learner__c: this.selectedLearnerId };
        this.learnerResults = [];
        this.learnerSearch = '';
    }

    clearLearner() {
        this.selectedLearnerId = null;
        this.selectedLearnerName = '';
        this.enrolment = { ...this.enrolment, Learner__c: null };
    }

    handleCourseSelect(e) { this.enrolment = { ...this.enrolment, LMS_Course__c: e.detail.value }; }
    handleField(e) { this.enrolment = { ...this.enrolment, [e.target.dataset.field]: e.target.value }; }

    handleSave() {
        this.isSaving = true;
        enrolLearner({ enrolmentData: JSON.stringify(this.enrolment) })
            .then(() => this.dispatchEvent(new CustomEvent('saved')))
            .finally(() => { this.isSaving = false; });
    }
    handleClose() { this.dispatchEvent(new CustomEvent('close')); }
}

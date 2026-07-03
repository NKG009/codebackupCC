import { LightningElement, track, wire } from 'lwc';
import getGradingQueue from '@salesforce/apex/LMSGradingController.getGradingQueue';
import getCourseOptions from '@salesforce/apex/LMSCourseController.getCourseOptions';

const STATUS_OPTIONS = [
    { label: 'Pending review', value: 'Pending Review' },
    { label: 'All', value: '' },
    { label: 'Graded', value: 'Graded' },
];

export default class LmsGradingQueue extends LightningElement {
    @track attempts = [];
    @track filterCourse = '';
    @track filterStatus = 'Pending Review';
    @track selectedAttemptId = null;
    @track courseOptions = [{ label: 'All courses', value: '' }];
    statusOptions = STATUS_OPTIONS;

    // getCourseOptions is read-only, cacheable=true, never mutated — @wire is fine
    @wire(getCourseOptions)
    wiredCourseOptions({ data }) {
        if (data) this.courseOptions = [{ label: 'All courses', value: '' }, ...data];
    }

    connectedCallback() {
        this.loadData();
    }

    loadData() {
        getGradingQueue({ courseId: this.filterCourse || null, status: this.filterStatus })
            .then(data => {
                this.attempts = (data || []).map(a => ({
                    ...a,
                    cssClass: `attempt-card${this.selectedAttemptId === a.Id ? ' attempt-card--selected' : ''}`,
                    learnerName: a.Learner__r?.Name,
                    courseName: a.LMS_Enrolment__r?.LMS_Course__r?.Name,
                    quizName: a.LMS_Quiz__r?.Name,
                    formattedDate: new Date(a.CreatedDate).toLocaleDateString(),
                }));
            })
            .catch(err => {
                console.error('getGradingQueue error', err);
            });
    }

    get filteredAttempts() { return this.attempts; }
    get hasAttempts() { return this.attempts.length > 0; }
    get pendingCount() { return this.attempts.filter(a => a.Grading_Status__c === 'Pending Review').length; }

    handleCourseFilter(e) { this.filterCourse = e.detail.value; this.selectedAttemptId = null; this.loadData(); }
    handleStatusFilter(e) { this.filterStatus = e.detail.value; this.selectedAttemptId = null; this.loadData(); }
    handleSelectAttempt(e) {
        this.selectedAttemptId = e.currentTarget.dataset.id;
        // Recompute cssClass on attempt rows to highlight selected
        this.attempts = this.attempts.map(a => ({
            ...a,
            cssClass: `attempt-card${this.selectedAttemptId === a.Id ? ' attempt-card--selected' : ''}`,
        }));
    }
    handleGraded() { this.loadData(); }
}

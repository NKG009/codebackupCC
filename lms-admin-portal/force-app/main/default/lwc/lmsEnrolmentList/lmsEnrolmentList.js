import { LightningElement, track, wire } from 'lwc';
import getEnrolments from '@salesforce/apex/LMSEnrolmentController.getEnrolmentList';
import getCourseOptions from '@salesforce/apex/LMSCourseController.getCourseOptions';
import withdrawLearner from '@salesforce/apex/LMSEnrolmentController.withdrawLearner';
import approveEnrolment from '@salesforce/apex/LMSEnrolmentController.approveEnrolment';

const STATUS_OPTIONS = [
    { label: 'All statuses', value: '' },
    { label: 'Pending approval', value: 'Pending Approval' },
    { label: 'Not started', value: 'Not Started' },
    { label: 'In progress', value: 'In Progress' },
    { label: 'Completed', value: 'Completed' },
    { label: 'Certified', value: 'Certified' },
    { label: 'Withdrawn', value: 'Withdrawn' },
];

export default class LmsEnrolmentList extends LightningElement {
    @track enrolments = [];
    @track searchTerm = '';
    @track filterStatus = '';
    @track filterCourse = '';
    @track isLoading = false;
    @track isActioning = false;
    @track actionLabel = '';
    @track showEnrolForm = false;
    @track showProgress = false;
    @track progressEnrolId = null;
    @track courseOptions = [{ label: 'All courses', value: '' }];
    statusOptions = STATUS_OPTIONS;

    @wire(getCourseOptions)
    wiredCourses({ data }) {
        if (data) this.courseOptions = [{ label: 'All courses', value: '' }, ...data];
    }

    connectedCallback() { this.loadData(); }

    loadData() {
        this.isLoading = true;
        getEnrolments({ courseId: this.filterCourse || null, status: this.filterStatus })
            .then(data => {
                this.enrolments = (data || []).map(e => ({
                    ...e,
                    learnerName: e.Learner__r?.Name,
                    courseName: e.LMS_Course__r?.Name,
                    formattedDate: e.Enrolment_Date__c ? new Date(e.Enrolment_Date__c).toLocaleDateString() : '—',
                    scoreDisplay: e.Overall_Score__c != null ? e.Overall_Score__c + '%' : '—',
                    isPendingApproval: e.Status__c === 'Pending Approval',
                }));
            })
            .catch(err => { console.error('getEnrolmentList error', err); })
            .finally(() => { this.isLoading = false; });
    }

    get filteredEnrolments() {
        const s = this.searchTerm.toLowerCase();
        if (!s) return this.enrolments;
        return this.enrolments.filter(e => e.learnerName?.toLowerCase().includes(s) || e.courseName?.toLowerCase().includes(s));
    }

    handleSearch(e) { this.searchTerm = e.target.value; }
    handleStatusFilter(e) { this.filterStatus = e.detail.value; this.loadData(); }
    handleCourseFilter(e) { this.filterCourse = e.detail.value; this.loadData(); }
    handleNew() { this.showEnrolForm = true; }
    handleFormClose() { this.showEnrolForm = false; }
    handleFormSaved() { this.showEnrolForm = false; this.loadData(); }
    handleViewProgress(e) { this.progressEnrolId = e.currentTarget.dataset.id; this.showProgress = true; }
    handleProgressClose() { this.showProgress = false; }
    handleWithdraw(e) {
        const enrolmentId = e.currentTarget.dataset.id;
        this.isActioning = true;
        this.actionLabel = 'Withdrawing learner...';
        withdrawLearner({ enrolmentId })
            .then(() => { this.loadData(); })
            .catch(err => { console.error('withdrawLearner error', err); })
            .finally(() => { this.isActioning = false; this.actionLabel = ''; });
    }

    handleApprove(e) {
        const enrolmentId = e.currentTarget.dataset.id;
        this.isActioning = true;
        this.actionLabel = 'Approving enrolment...';
        approveEnrolment({ enrolmentId })
            .then(() => { this.loadData(); })
            .catch(err => { console.error('approveEnrolment error', err); })
            .finally(() => { this.isActioning = false; this.actionLabel = ''; });
    }
}

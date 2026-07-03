import { LightningElement, api, track, wire } from 'lwc';
import getEnrolmentProgress from '@salesforce/apex/LMSEnrolmentController.getEnrolmentProgress';

export default class LmsProgressTracker extends LightningElement {
    @api enrolmentId;
    @track enrolment = {};
    @track lessonProgress = [];

    @wire(getEnrolmentProgress, { enrolmentId: '$enrolmentId' })
    wiredProgress({ data }) {
        if (data) {
            this.enrolment = {
                ...data.enrolment,
                learnerName: data.enrolment.Learner__r?.Name,
                courseName: data.enrolment.LMS_Course__r?.Name,
                formattedEnrol: data.enrolment.Enrolment_Date__c ? new Date(data.enrolment.Enrolment_Date__c).toLocaleDateString() : '—',
            };
            this.lessonProgress = (data.lessonProgress || []).map(lp => ({
                ...lp,
                lessonName: lp.Lesson__r?.Name,
                formattedDate: lp.Completed_Date__c ? new Date(lp.Completed_Date__c).toLocaleDateString() : 'Not started',
                icon: lp.Is_Complete__c ? 'utility:check' : 'utility:clock',
                iconClass: lp.Is_Complete__c ? 'icon-done' : 'icon-pending',
            }));
        }
    }

    get completedCount() { return this.lessonProgress.filter(l => l.Is_Complete__c).length; }
    get totalCount() { return this.lessonProgress.length; }
    get progressPct() { return this.totalCount ? Math.round((this.completedCount / this.totalCount) * 100) : 0; }
    get progressStyle() { return `width: ${this.progressPct}%`; }

    handleClose() { this.dispatchEvent(new CustomEvent('close')); }
}

import { LightningElement, wire, track } from 'lwc';
import getDashboardStats from '@salesforce/apex/LMSCourseController.getDashboardStats';

export default class LmsDashboardStats extends LightningElement {
    @track stats = [];
    @wire(getDashboardStats)
    wiredStats({ data, error }) {
        if (data) {
            this.stats = [
                { label: 'Published courses', value: data.publishedCourses, icon: 'utility:knowledge_base' },
                { label: 'Active learners', value: data.activeLearners, icon: 'utility:people' },
                { label: 'Questions in bank', value: data.totalQuestions, icon: 'utility:question' },
                { label: 'Certifications issued', value: data.certificationsIssued, icon: 'utility:ribbon' },
                { label: 'Pending grading', value: data.pendingGrading, icon: 'utility:check' },
                { label: 'Completion rate', value: data.completionRate + '%', icon: 'utility:chart' },
            ];
        }
    }
}

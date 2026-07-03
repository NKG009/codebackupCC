import { LightningElement, track, wire } from 'lwc';
import getGradingQueue from '@salesforce/apex/LMSGradingController.getGradingQueue';

export default class LmsPendingGradingWidget extends LightningElement {
    @track pendingItems = [];

    @wire(getGradingQueue, { courseId: '', status: 'Pending Review' })
    wiredQueue({ data }) {
        if (data) {
            this.pendingItems = data.slice(0, 5).map(a => ({
                ...a,
                learnerName: a.Learner__r?.Name,
                courseName: a.LMS_Enrolment__r?.LMS_Course__r?.Name,
                questionType: 'Pending',
                formattedDate: new Date(a.CreatedDate).toLocaleDateString(),
            }));
        }
    }

    get hasPending() { return this.pendingItems.length > 0; }
    get pendingCount() { return this.pendingItems.length; }
}

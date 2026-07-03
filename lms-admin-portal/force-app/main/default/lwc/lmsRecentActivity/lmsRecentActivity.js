import { LightningElement, track, wire } from 'lwc';
import getRecentActivity from '@salesforce/apex/LMSCourseController.getRecentActivity';

const DOT_COLORS = { certification: '#059669', enrolment: '#1589ee', grading: '#f59300', published: '#7c3aed', feedback: '#dc2626' };

export default class LmsRecentActivity extends LightningElement {
    @track activities = [];

    @wire(getRecentActivity)
    wiredActivity({ data }) {
        if (data) {
            this.activities = data.map(a => ({
                ...a,
                dotStyle: `background:${DOT_COLORS[a.type] || '#9ca3af'}`,
                timeAgo: this.getTimeAgo(a.timestamp),
            }));
        }
    }

    get hasActivities() { return this.activities.length > 0; }

    getTimeAgo(ts) {
        if (!ts) return '';
        const diff = Date.now() - new Date(ts).getTime();
        const mins = Math.floor(diff / 60000);
        if (mins < 60) return `${mins}m ago`;
        const hrs = Math.floor(mins / 60);
        if (hrs < 24) return `${hrs}h ago`;
        return `${Math.floor(hrs / 24)}d ago`;
    }
}

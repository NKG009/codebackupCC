import { LightningElement, track } from 'lwc';
import getCourseList from '@salesforce/apex/LMSCourseController.getCourseList';

export default class LmsPublishQueue extends LightningElement {
    @track courses = [];

    connectedCallback() {
        this.loadData();
    }

    loadData() {
        getCourseList()
            .then(data => {
                this.courses = data || [];
            })
            .catch(err => {
                console.error('getCourseList error', err);
            });
    }

    get draftCourses() { return this.courses.filter(c => !c.Is_Published__c); }
    get hasDrafts() { return this.draftCourses.length > 0; }
    handlePublishChange() { this.loadData(); }
}

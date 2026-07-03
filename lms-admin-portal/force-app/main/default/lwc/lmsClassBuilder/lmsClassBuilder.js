import { LightningElement, api, track, wire } from 'lwc';
import getClass from '@salesforce/apex/LMSLessonController.getClass';
import saveClass from '@salesforce/apex/LMSLessonController.saveClass';
import addClassToCourse from '@salesforce/apex/LMSCourseController.addClassToCourse';
// Note: no instructor field on LMS_Class__c — instructor is a system-level role
// enforced via Salesforce Profiles/Permission Sets, not a field on records.

export default class LmsClassBuilder extends LightningElement {
    @api recordId;
    @api courseId;
    @track cls = { Name: '', Is_Published__c: false };
    @track isSaving = false;

    @wire(getClass, { classId: '$recordId' })
    wiredClass({ data }) {
        if (data) this.cls = { ...data };
    }

    get title() { return this.recordId ? 'Edit class' : 'New class'; }

    handleField(e) {
        this.cls = { ...this.cls, [e.target.dataset.field]: e.target.value };
    }

    handlePublishToggle(e) {
        this.cls = { ...this.cls, Is_Published__c: e.target.checked };
    }

    handleSave() {
        this.isSaving = true;
        saveClass({ classData: JSON.stringify(this.cls) })
            .then(classId => {
                if (!this.recordId) {
                    return addClassToCourse({ courseId: this.courseId, classId });
                }
            })
            .then(() => this.dispatchEvent(new CustomEvent('saved')))
            .catch(e => console.error(e))
            .finally(() => { this.isSaving = false; });
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}

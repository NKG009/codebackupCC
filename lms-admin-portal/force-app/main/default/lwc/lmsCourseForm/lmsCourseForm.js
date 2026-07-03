import { LightningElement, api, track } from 'lwc';
import getCourseDetail from '@salesforce/apex/LMSCourseController.getCourseDetail';
import saveCourse from '@salesforce/apex/LMSCourseController.saveCourse';
import removeCourseClass from '@salesforce/apex/LMSCourseController.removeCourseClass';
import removeCourseLesson from '@salesforce/apex/LMSCourseController.removeCourseLesson';
import removeClassLesson from '@salesforce/apex/LMSCourseController.removeClassLesson';

// No @wire, no refreshApex.
// getCourseDetail is cacheable=false in Apex so every imperative call
// returns live data. loadDetail() is called on mount and after every mutation.

const CATEGORY_OPTIONS = [
    { label: 'HR', value: 'HR' },
    { label: 'Finance', value: 'Finance' },
    { label: 'Leadership', value: 'Leadership' },
    { label: 'Compliance', value: 'Compliance' },
    { label: 'Operations', value: 'Operations' },
];

export default class LmsCourseForm extends LightningElement {
    @api recordId;

    @track course = {
        Name: '',
        Is_Certification__c: false,
        Is_Published__c: false,
        Requires_Approval__c: false,
        Passing_Threshold__c: 70,
        allowTestOut: false
    };
    @track classes = [];
    @track directLessons = [];
    @track activeTab = 'details';
    @track isSaving = false;
    @track isLoading = false;
    @track showLessonPicker = false;
    @track showClassForm = false;
    @track pickerClassId = null;
    @track editingClassId = null;

    categoryOptions = CATEGORY_OPTIONS;

    // ── Lifecycle ─────────────────────────────────────────────────────────────
    connectedCallback() {
        this.loadDetail();
    }

    // ── Data fetch ────────────────────────────────────────────────────────────
    // getCourseDetail is cacheable=false so this always returns fresh data.
    loadDetail() {
        if (!this.recordId) return;
        this.isLoading = true;
        getCourseDetail({ courseId: this.recordId })
            .then(data => {
                this._applyDetail(data);
            })
            .catch(err => {
                console.error('getCourseDetail error', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    _applyDetail(data) {
        if (!data) return;
        console.log('getCourseDetail', JSON.stringify(data));
        this.course = {
            ...data.course,
            allowTestOut: !!data.course.Final_Quiz__c
        };
        // Assign new array references so @track detects the change
        this.classes = (data.classes || []).map(cls => ({
            ...cls,
            hasLessons: (cls.lessons || []).length > 0
        }));
        this.directLessons = [...(data.directLessons || [])];

        console.log('classes', JSON.stringify(this.classes));
        console.log('directLessons', JSON.stringify(this.directLessons));
    }

    // ── Getters ───────────────────────────────────────────────────────────────
    get formTitle() {
        return this.recordId ? `Edit: ${this.course.Name || ''}` : 'New course';
    }
    get hasDirectLessons() {
        return this.directLessons.length > 0;
    }
    get isTab() {
        return {
            details:   this.activeTab === 'details',
            structure: this.activeTab === 'structure',
            quiz:      this.activeTab === 'quiz',
            settings:  this.activeTab === 'settings'
        };
    }
    get detailsTabClass()   { return `tab-btn${this.activeTab === 'details'   ? ' tab-btn--active' : ''}`; }
    get structureTabClass() { return `tab-btn${this.activeTab === 'structure' ? ' tab-btn--active' : ''}`; }
    get quizTabClass()      { return `tab-btn${this.activeTab === 'quiz'      ? ' tab-btn--active' : ''}`; }
    get settingsTabClass()  { return `tab-btn${this.activeTab === 'settings'  ? ' tab-btn--active' : ''}`; }

    // ── Tab navigation ────────────────────────────────────────────────────────
    showDetails()   { this.activeTab = 'details'; }
    showStructure() { this.activeTab = 'structure'; }
    showQuiz()      { this.activeTab = 'quiz'; }
    showSettings()  { this.activeTab = 'settings'; }

    // ── Field bindings ────────────────────────────────────────────────────────
    handleField(evt) {
        this.course = { ...this.course, [evt.target.dataset.field]: evt.target.value };
    }
    handleCertToggle(evt) {
        this.course = { ...this.course, Is_Certification__c: evt.target.checked };
    }
    handleApprovalToggle(evt) {
        this.course = { ...this.course, Requires_Approval__c: evt.target.checked };
    }
    handlePublishToggle(evt) {
        this.course = { ...this.course, Is_Published__c: evt.target.checked };
    }
    handleTestOutToggle(evt) {
        this.course = { ...this.course, allowTestOut: evt.target.checked };
    }
    handleFinalQuizSelect(evt) {
        this.course = { ...this.course, Final_Quiz__c: evt.detail.recordId };
    }

    // ── Class management ──────────────────────────────────────────────────────
    handleAddClass() {
        this.editingClassId = null;
        this.showClassForm = true;
    }
    handleEditClass(evt) {
        this.editingClassId = evt.currentTarget.dataset.id;
        this.showClassForm = true;
    }
    handleClassSaved() {
        this.showClassForm = false;
        this.loadDetail();
    }
    handleClassFormClose() {
        this.showClassForm = false;
    }
    handleRemoveClass(evt) {
        // Read dataset synchronously BEFORE the async call —
        // evt.currentTarget is null inside .then()
        const junctionId = evt.currentTarget.dataset.id;
        removeCourseClass({ junctionId })
            .then(() => {
                this.loadDetail();
            })
            .catch(err => {
                console.error('removeCourseClass error', err);
            });
    }

    // ── Lesson management ─────────────────────────────────────────────────────
    handleAddLessonToClass(evt) {
        this.pickerClassId = evt.currentTarget.dataset.classId;
        this.showLessonPicker = true;
    }
    handleAddLessonDirect() {
        this.pickerClassId = null;
        this.showLessonPicker = true;
    }
    handleLessonSelected() {
        this.showLessonPicker = false;
        this.loadDetail();
    }
    handlePickerClose() {
        this.showLessonPicker = false;
    }
    handleRemoveLesson(evt) {
        // Read dataset synchronously BEFORE the async call
        console.log('handleRemoveLesson', JSON.stringify(evt.target.dataset));
        console.log('handleRemoveLesson', JSON.stringify(evt.currentTarget.dataset));
        const junctionId = evt.currentTarget.dataset.id;
        removeClassLesson({ junctionId })
            .then(() => {
                this.loadDetail();
            })
            .catch(err => {
                console.error('removeClassLesson error', err);
            });
    }
    handleRemoveDirectLesson(evt) {
        console.log('handleRemoveDirectLessoncurrentTarget', JSON.stringify(evt.target.dataset));
        console.log('handleRemoveDirectLesson', JSON.stringify(evt.currentTarget.dataset));
        const junctionId = evt.currentTarget.dataset.id;
        removeCourseLesson({ junctionId })
            .then(() => {
                this.loadDetail();
            })
            .catch(err => {
                console.error('removeCourseLesson error', err);
            });
    }

    // ── Save / back ───────────────────────────────────────────────────────────
    handleSave() {
        this.isSaving = true;
        saveCourse({ courseData: JSON.stringify(this.course) })
            .then(() => {
                this.dispatchEvent(new CustomEvent('saved', {
                    detail: { message: 'Course saved successfully.' }
                }));
            })
            .catch(err => {
                console.error('saveCourse error', err);
            })
            .finally(() => {
                this.isSaving = false;
            });
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}

import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

const PAGE_TITLES = {
    dashboard: 'Dashboard',
    courses: 'Courses',
    courseForm: 'Course editor',
    lessons: 'Lesson library',
    lessonForm: 'Lesson editor',
    questions: 'Question bank',
    questionForm: 'Question editor',
    quizzes: 'Quizzes',
    quizForm: 'Quiz builder',
    grading: 'Grading queue',
    enrolments: 'Enrolments',
    users: 'Users',
};

export default class LmsAdminShell extends LightningElement {
    @track currentPage = 'dashboard';
    @track selectedId = null;
    @track previousPage = null;
    @track showToast = false;
    @track toastMessage = '';
    @track toastVariant = 'success';
    userId = Id;

    @wire(getRecord, { recordId: '$userId', fields: [NAME_FIELD] })
    currentUser;

    get pageTitle() {
        return PAGE_TITLES[this.currentPage] || 'LMS Admin';
    }

    get isPage() {
        const p = this.currentPage;
        return {
            dashboard: p === 'dashboard',
            courses: p === 'courses',
            courseForm: p === 'courseForm',
            lessons: p === 'lessons',
            lessonForm: p === 'lessonForm',
            questions: p === 'questions',
            questionForm: p === 'questionForm',
            quizzes: p === 'quizzes',
            quizForm: p === 'quizForm',
            grading: p === 'grading',
            enrolments: p === 'enrolments',
            users: p === 'users',
        };
    }

    handleNavigate(event) {
        const { page, id } = event.detail;
        this.previousPage = this.currentPage;
        this.selectedId = id || null;
        this.currentPage = page;
    }

    handleBack() {
        this.currentPage = this.previousPage || 'dashboard';
        this.selectedId = null;
    }

    handleSaved(event) {
        const { message } = event.detail;
        this.currentPage = this.previousPage || 'dashboard';
        this.selectedId = null;
        this.showSuccessToast(message || 'Record saved successfully.');
    }

    showSuccessToast(message) {
        this.toastMessage = message;
        this.toastVariant = 'success';
        this.showToast = true;
    }

    handleToastClose() {
        this.showToast = false;
    }
}

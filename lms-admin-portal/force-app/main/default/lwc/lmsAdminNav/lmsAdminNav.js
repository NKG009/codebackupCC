import { LightningElement, api, track, wire } from 'lwc';
import getPendingGradingCount from '@salesforce/apex/LMSGradingController.getPendingCount';

const NAV_ITEMS = [
    { page: 'dashboard', label: 'Dashboard', icon: 'utility:home', section: 'main' },
    { page: 'courses', label: 'Courses', icon: 'utility:knowledge_base', section: 'content' },
    { page: 'lessons', label: 'Lesson library', icon: 'utility:video', section: 'content' },
    { page: 'questions', label: 'Question bank', icon: 'utility:question', section: 'content' },
    { page: 'quizzes', label: 'Quizzes', icon: 'utility:form', section: 'content' },
    { page: 'grading', label: 'Grading queue', icon: 'utility:check', section: 'work', hasBadge: true },
    { page: 'enrolments', label: 'Enrolments', icon: 'utility:people', section: 'manage' },
    { page: 'users', label: 'Users', icon: 'utility:user', section: 'manage' },
];

export default class LmsAdminNav extends LightningElement {
    @api currentPage;
    @track pendingCount = 0;

    @wire(getPendingGradingCount)
    wiredCount({ data, error }) {
        if (data !== undefined) this.pendingCount = data;
    }

    get navItems() {
        return NAV_ITEMS.map(item => ({
            ...item,
            badge: item.hasBadge && this.pendingCount > 0 ? this.pendingCount : null,
            cssClass: `nav__item${this.currentPage === item.page ? ' nav__item--active' : ''}`,
        }));
    }

    handleClick(event) {
        const page = event.currentTarget.dataset.page;
        this.dispatchEvent(new CustomEvent('navigate', { detail: { page } }));
    }
}

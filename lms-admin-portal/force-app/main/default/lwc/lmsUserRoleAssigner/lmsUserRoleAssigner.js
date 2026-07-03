import { LightningElement, api, track, wire } from 'lwc';
import getUser from '@salesforce/apex/LMSUserController.getUserDetail';
import updateUserRole from '@salesforce/apex/LMSUserController.updateUserRole';

const ROLES = [
    { value: 'Admin', label: 'Admin', icon: 'utility:shield', description: 'Full system configuration, user management, all reports, publish control.' },
    { value: 'Instructor', label: 'Instructor', icon: 'utility:edit', description: 'Create and edit courses, lessons, questions, quizzes. Grade open-ended answers.' },
    { value: 'Instructor-Student', label: 'Instructor-Student', icon: 'utility:people', description: 'All Instructor permissions plus ability to enrol and participate as a learner. No role toggling needed.' },
    { value: 'Student', label: 'Student', icon: 'utility:user', description: 'Browse and enrol in courses, take quizzes, view results, submit question feedback.' },
];

export default class LmsUserRoleAssigner extends LightningElement {
    @api userId;
    @track user = {};
    @track selectedRole = 'Student';
    @track isSaving = false;

    @wire(getUser, { userId: '$userId' })
    wiredUser({ data }) { if (data) { this.user = data; this.selectedRole = data.lmsRole || 'Student'; } }

    get roleOptions() {
        return ROLES.map(r => ({ ...r, selected: r.value === this.selectedRole, cssClass: `role-option${r.value === this.selectedRole ? ' role-option--selected' : ''}` }));
    }

    handleRoleSelect(e) { this.selectedRole = e.currentTarget.dataset.value; }

    handleSave() {
        this.isSaving = true;
        updateUserRole({ userId: this.userId, role: this.selectedRole })
            .then(() => this.dispatchEvent(new CustomEvent('saved')))
            .finally(() => { this.isSaving = false; });
    }
    handleClose() { this.dispatchEvent(new CustomEvent('close')); }
}

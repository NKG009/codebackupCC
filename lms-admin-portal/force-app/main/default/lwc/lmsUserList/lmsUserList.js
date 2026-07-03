import { LightningElement, track } from 'lwc';
import getLmsUsers from '@salesforce/apex/LMSUserController.getLmsUsers';

const ROLE_OPTIONS = [
    { label: 'All roles', value: '' },
    { label: 'Admin', value: 'Admin' },
    { label: 'Instructor', value: 'Instructor' },
    { label: 'Instructor-Student', value: 'Instructor-Student' },
    { label: 'Student', value: 'Student' },
];

export default class LmsUserList extends LightningElement {
    @track users = [];
    @track searchTerm = '';
    @track filterRole = '';
    @track showRoleAssigner = false;
    @track selectedUserId = null;
    roleOptions = ROLE_OPTIONS;

    connectedCallback() {
        this.loadData();
    }

    loadData() {
        getLmsUsers()
            .then(data => {
                // getLmsUsers returns lmsRole derived from Permission Sets — no LMS_Role__c field
                this.users = (data || []).map(u => ({
                    ...u,
                    initials: (u.Name || '??').split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase(),
                }));
            })
            .catch(err => {
                console.error('getLmsUsers error', err);
            });
    }

    get filteredUsers() {
        return this.users.filter(u => {
            const matchSearch = !this.searchTerm ||
                u.Name?.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
                u.Email?.toLowerCase().includes(this.searchTerm.toLowerCase());
            const matchRole = !this.filterRole || u.lmsRole === this.filterRole;
            return matchSearch && matchRole;
        });
    }

    handleSearch(e) { this.searchTerm = e.target.value; }
    handleRoleFilter(e) { this.filterRole = e.detail.value; }
    handleManageRole(e) { this.selectedUserId = e.currentTarget.dataset.id; this.showRoleAssigner = true; }
    handleRoleClose() { this.showRoleAssigner = false; }
    handleRoleSaved() { this.showRoleAssigner = false; this.loadData(); }
}

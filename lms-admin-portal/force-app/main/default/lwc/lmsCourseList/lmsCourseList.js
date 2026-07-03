import { LightningElement, track } from 'lwc';
import getCourses from '@salesforce/apex/LMSCourseController.getCourseList';
import deleteCourse from '@salesforce/apex/LMSCourseController.deleteCourse';

// No @wire, no refreshApex.
// getCourseList is cacheable=true so refreshApex would return stale data in LWR.
// loadData() calls imperatively — always fresh.

const STATUS_OPTIONS = [
    { label: 'All statuses', value: '' },
    { label: 'Published', value: 'true' },
    { label: 'Draft', value: 'false' },
];

const CATEGORY_OPTIONS = [
    { label: 'All categories', value: '' },
    { label: 'HR', value: 'HR' },
    { label: 'Finance', value: 'Finance' },
    { label: 'Leadership', value: 'Leadership' },
    { label: 'Compliance', value: 'Compliance' },
];

export default class LmsCourseList extends LightningElement {
    @track courses = [];
    @track searchTerm = '';
    @track filterCategory = '';
    @track filterStatus = '';
    @track isLoading = true;
    @track showConfirm = false;
    @track pendingDeleteId = null;

    statusOptions = STATUS_OPTIONS;
    categoryOptions = CATEGORY_OPTIONS;

    connectedCallback() {
        console.log('LmsCourseList connectedCallback called');
        this.loadData();
    }

    loadData() {
        this.isLoading = true;
        getCourses()
            .then(data => {
                this.courses = data || [];
                console.log('LmsCourseList loadData called');
                console.log('Courses:', JSON.stringify(this.courses));
            })
            .catch(err => {
                console.error('getCourseList error', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get filteredCourses() {
        return this.courses.filter(c => {
            const matchSearch = !this.searchTerm ||
                c.Name.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
                (c.Course_Code__c || '').toLowerCase().includes(this.searchTerm.toLowerCase());
            const matchCategory = !this.filterCategory || c.Category__c === this.filterCategory;
            const matchStatus = this.filterStatus === '' || String(c.Is_Published__c) === this.filterStatus;
            return matchSearch && matchCategory && matchStatus;
        });
    }

    get hasCourses() { return this.filteredCourses.length > 0; }

    handleSearch(e) { this.searchTerm = e.target.value; }
    handleCategoryFilter(e) { this.filterCategory = e.detail.value; }
    handleStatusFilter(e) { this.filterStatus = e.detail.value; }

    handleNew() {
        this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'courseForm', id: null } }));
    }
    handleEdit(e) {
        this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'courseForm', id: e.currentTarget.dataset.id } }));
    }
    handleOpenClasses(e) {
        this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'courseForm', id: e.currentTarget.dataset.id, tab: 'classes' } }));
    }
    handleDelete(e) {
        this.pendingDeleteId = e.currentTarget.dataset.id;
        this.showConfirm = true;
    }
    confirmDelete() {
        this.showConfirm = false;
        deleteCourse({ courseId: this.pendingDeleteId })
            .then(() => { this.loadData(); })
            .catch(err => { console.error('deleteCourse error', err); });
    }
    cancelDelete() { this.showConfirm = false; this.pendingDeleteId = null; }

    handlePublishChange() { this.loadData(); }
}

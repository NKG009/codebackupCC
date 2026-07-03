import { LightningElement, track } from 'lwc';
import getQuestions from '@salesforce/apex/LMSQuizController.getQuestionList';
import duplicateQuestion from '@salesforce/apex/LMSQuizController.duplicateQuestion';

const TYPE_OPTIONS = [
    { label: 'All types', value: '' },
    { label: 'MCQ', value: 'MCQ' },
    { label: 'True / False', value: 'True/False' },
    { label: 'Open-Ended', value: 'Open-Ended' },
    { label: 'Upload', value: 'Upload' },
];
const STATUS_OPTIONS = [
    { label: 'Active only', value: 'true' },
    { label: 'All questions', value: '' },
    { label: 'Archived only', value: 'false' },
];
const CATEGORY_OPTIONS = [
    { label: 'All categories', value: '' },
    { label: 'HR', value: 'HR' },
    { label: 'Payroll', value: 'Payroll' },
    { label: 'Revenue', value: 'Revenue' },
    { label: 'Sales', value: 'Sales' },
    { label: 'Service', value: 'Service' },
    { label: 'ADP', value: 'ADP' },
];

export default class LmsQuestionList extends LightningElement {
    @track questions = [];
    @track searchTerm = '';
    @track filterType = '';
    @track filterCategory = '';
    @track filterActive = 'true';
    @track isLoading = false;
    @track isActioning = false;
    @track actionLabel = '';
    typeOptions = TYPE_OPTIONS;
    statusOptions = STATUS_OPTIONS;
    categoryOptions = CATEGORY_OPTIONS;

    connectedCallback() { this.loadData(); }

    loadData() {
        this.isLoading = true;
        getQuestions({ questionType: this.filterType, searchTerm: this.searchTerm, activeOnly: this.filterActive === 'true', category: this.filterCategory })
            .then(data => {
                this.questions = (data || []).map(q => ({
                    ...q,
                    shortText: q.Question_Text__c?.length > 100 ? q.Question_Text__c.slice(0, 100) + '…' : q.Question_Text__c
                }));
            })
            .catch(err => { console.error('getQuestionList error', err); })
            .finally(() => { this.isLoading = false; });
    }

    get filteredQuestions() {
        if (!this.searchTerm) return this.questions;
        return this.questions.filter(q => q.Question_Text__c?.toLowerCase().includes(this.searchTerm.toLowerCase()));
    }
    get filteredCount() { return this.filteredQuestions.length; }
    get hasQuestions() { return this.filteredQuestions.length > 0; }

    handleSearch(e) { this.searchTerm = e.target.value; this.loadData(); }
    handleTypeFilter(e) { this.filterType = e.detail.value; this.loadData(); }
    handleStatusFilter(e) { this.filterActive = e.detail.value; this.loadData(); }
    handleCategoryFilter(e) { this.filterCategory = e.detail.value; this.loadData(); }
    clearFilters() { this.searchTerm = ''; this.filterType = ''; this.filterActive = 'true'; this.filterCategory = ''; this.loadData(); }

    handleNew() { this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'questionForm', id: null } })); }
    handleEdit(e) { this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'questionForm', id: e.currentTarget.dataset.id } })); }
    handleDuplicate(e) {
        const questionId = e.currentTarget.dataset.id;
        this.isActioning = true;
        this.actionLabel = 'Duplicating question...';
        duplicateQuestion({ questionId })
            .then(() => { this.loadData(); })
            .catch(err => { console.error('duplicateQuestion error', err); })
            .finally(() => { this.isActioning = false; this.actionLabel = ''; });
    }
}

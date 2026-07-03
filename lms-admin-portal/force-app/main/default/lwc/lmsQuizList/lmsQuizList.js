import { LightningElement, track } from 'lwc';
import getQuizzes from '@salesforce/apex/LMSQuizController.getQuizList';
import deleteQuiz from '@salesforce/apex/LMSQuizController.deleteQuiz';

export default class LmsQuizList extends LightningElement {
    @track quizzes = [];
    @track searchTerm = '';
    @track isLoading = true;
    @track showConfirm = false;
    @track pendingDeleteId = null;

    connectedCallback() {
        this.loadData();
    }

    loadData() {
        this.isLoading = true;
        getQuizzes()
            .then(data => {
                this.quizzes = data || [];
            })
            .catch(err => {
                console.error('getQuizList error', err);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get filteredQuizzes() {
        return this.quizzes.filter(q =>
            !this.searchTerm || q.Name.toLowerCase().includes(this.searchTerm.toLowerCase())
        );
    }

    handleSearch(e) { this.searchTerm = e.target.value; }
    handleNew() { this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'quizForm', id: null } })); }
    handleEdit(e) { this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'quizForm', id: e.currentTarget.dataset.id } })); }
    handleDelete(e) { this.pendingDeleteId = e.currentTarget.dataset.id; this.showConfirm = true; }
    confirmDelete() {
        this.showConfirm = false;
        deleteQuiz({ quizId: this.pendingDeleteId })
            .then(() => { this.loadData(); })
            .catch(err => { console.error('deleteQuiz error', err); });
    }
    cancelDelete() { this.showConfirm = false; }
}

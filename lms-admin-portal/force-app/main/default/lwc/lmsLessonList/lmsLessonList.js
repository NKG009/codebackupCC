import { LightningElement, track } from 'lwc';
import getLessons from '@salesforce/apex/LMSLessonController.getLessonList';
import deleteLesson from '@salesforce/apex/LMSLessonController.deleteLesson';

const TYPE_OPTIONS = [
    { label: 'All types', value: '' },
    { label: 'Video', value: 'Video' },
    { label: 'Text', value: 'Text' },
    { label: 'PDF', value: 'PDF' },
    { label: 'Knowledge Article', value: 'Knowledge Article' },
];

export default class LmsLessonList extends LightningElement {
    @track lessons = [];
    @track searchTerm = '';
    @track filterType = '';
    @track isLoading = false;
    @track isActioning = false;
    @track actionLabel = '';
    @track showConfirm = false;
    @track pendingDeleteId = null;
    typeOptions = TYPE_OPTIONS;

    connectedCallback() { this.loadData(); }

    loadData() {
        this.isLoading = true;
        getLessons()
            .then(data => {
                this.lessons = (data || []).map(l => ({
                    ...l,
                    // Split Content_Types__c into array of badge objects for template
                    typeBadges: (l.Content_Types__c || '').split(';').filter(Boolean).map(t => ({ label: t, key: t })),
                    durationDisplay: l.Duration_Mins__c ? l.Duration_Mins__c + ' min' : '—',
                    quizName: l.Quiz__r?.Name || '—',
                }));

                console.log('lessons:', JSON.stringify(this.lessons));
            })
            .catch(err => { console.error('getLessonList error', err); })
            .finally(() => { this.isLoading = false; });
    }

    get filteredLessons() {
        return this.lessons.filter(l => {
            const matchSearch = !this.searchTerm ||
                l.Name.toLowerCase().includes(this.searchTerm.toLowerCase());
            // Filter by type — check if Content_Types__c contains the selected type
            const matchType = !this.filterType ||
                (l.Content_Types__c || '').includes(this.filterType);
            return matchSearch && matchType;
        });
    }

    get hasLessons() { return this.filteredLessons.length > 0; }
    get lessonCount() { return this.filteredLessons.length; }

    handleSearch(e) { this.searchTerm = e.target.value; }
    handleTypeFilter(e) { this.filterType = e.detail.value; }

    handleNew() {
        this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'lessonForm', id: null } }));
    }
    handleEdit(e) {
        this.dispatchEvent(new CustomEvent('navigate', { detail: { page: 'lessonForm', id: e.currentTarget.dataset.id } }));
    }
    handleDelete(e) {
        this.pendingDeleteId = e.currentTarget.dataset.id;
        this.showConfirm = true;
    }
    confirmDelete() {
        this.showConfirm = false;
        this.isActioning = true;
        this.actionLabel = 'Deleting lesson...';
        deleteLesson({ lessonId: this.pendingDeleteId })
            .then(() => { this.loadData(); })
            .catch(err => { console.error('deleteLesson error', err); })
            .finally(() => { this.isActioning = false; this.actionLabel = ''; });
    }
    cancelDelete() { this.showConfirm = false; this.pendingDeleteId = null; }
}

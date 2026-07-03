import { LightningElement, api, track } from 'lwc';
import getLesson from '@salesforce/apex/LMSLessonController.getLesson';
import saveLesson from '@salesforce/apex/LMSLessonController.saveLesson';
import getQuizOptions from '@salesforce/apex/LMSQuizController.getQuizOptions';
import searchKnowledgeArticles from '@salesforce/apex/LMSLessonController.searchKnowledgeArticles';
import resolveAndSaveKnowledgeUrl from '@salesforce/apex/LMSLessonController.resolveAndSaveKnowledgeUrl';

const ALL_TYPES = [
    { label: 'Video',               value: 'Video',               icon: 'utility:video',          hint: 'YouTube, Vimeo, or direct video URL' },
    { label: 'Text',                value: 'Text',                icon: 'utility:text',           hint: 'Rich text content authored inline' },
    { label: 'PDF',                 value: 'PDF',                 icon: 'utility:pdf_ext',        hint: 'Upload or link a PDF document' },
    { label: 'Knowledge Article',   value: 'Knowledge Article',   icon: 'utility:knowledge_base', hint: 'Link to a Salesforce Knowledge article' },
];

const LESSON_FIELDS = [
    'Id', 'Name', 'Content_Types__c', 'Content_URL__c', 'Body_Text__c',
    'Knowledge_Article__c', 'Knowledge_Article_URL__c',
    'Duration_Mins__c', 'Allow_Test_Out__c', 'Quiz__c'
];

export default class LmsLessonForm extends LightningElement {
    @api recordId;
    @track lesson = { Name: '', Content_Types__c: '', Allow_Test_Out__c: false };
    @track isSaving = false;
    @track isLoading = false;
    @track isResolvingUrl = false;
    @track quizOptions = [{ label: 'None', value: '' }];

    // Knowledge article lookup
    @track kaSearch = '';
    @track kaResults = [];
    @track kaSearchLoading = false;
    @track selectedArticleTitle = '';
    _kaSearchTimeout;

    connectedCallback() {
        this.loadQuizOptions();
        if (this.recordId) this.loadDetail();
    }

    loadDetail() {
        this.isLoading = true;
        getLesson({ lessonId: this.recordId })
            .then(data => {
                if (data) {
                    const clean = {};
                    LESSON_FIELDS.forEach(f => { if (data[f] !== undefined) clean[f] = data[f]; });
                    this.lesson = clean;
                    if (data.Knowledge_Article__c) {
                        this.selectedArticleTitle = data.Knowledge_Article__r?.Title || 'Selected article';
                        // If URL not yet saved — resolve it now
                        if (!data.Knowledge_Article_URL__c) {
                            this.resolveUrl(data.Knowledge_Article__c);
                        }
                    }
                }
            })
            .catch(err => { console.error('getLesson error', err); })
            .finally(() => { this.isLoading = false; });
    }

    loadQuizOptions() {
        getQuizOptions()
            .then(data => { this.quizOptions = [{ label: 'None', value: '' }, ...(data || [])]; })
            .catch(err => { console.error('getQuizOptions error', err); });
    }

    // ── Getters ────────────────────────────────────────────────────────────────

    get formTitle() { return this.recordId ? `Edit: ${this.lesson.Name}` : 'New lesson'; }

    get selectedTypes() {
        return (this.lesson.Content_Types__c || '').split(';').filter(Boolean);
    }

    get typeOptions() {
        const sel = this.selectedTypes;
        return ALL_TYPES.map(t => ({
            ...t,
            selected: sel.includes(t.value),
            cssClass: `type-btn${sel.includes(t.value) ? ' type-btn--selected' : ''}`
        }));
    }

    get hasNoTypes()       { return this.selectedTypes.length === 0; }
    get showVideo()        { return this.selectedTypes.includes('Video'); }
    get showText()         { return this.selectedTypes.includes('Text'); }
    get showPDF()          { return this.selectedTypes.includes('PDF'); }
    get showKnowledge()    { return this.selectedTypes.includes('Knowledge Article'); }
    get showKaResults()    { return this.kaResults.length > 0; }
    get hasArticleSelected() { return !!this.lesson.Knowledge_Article__c; }
    get hasSavedUrl()      { return !!this.lesson.Knowledge_Article_URL__c; }

    // ── Type toggles ───────────────────────────────────────────────────────────

    handleTypeToggle(e) {
        const type = e.currentTarget.dataset.type;
        const current = this.selectedTypes;
        const updated = current.includes(type)
            ? current.filter(t => t !== type)
            : [...current, type];
        this.lesson = { ...this.lesson, Content_Types__c: updated.join(';') };
    }

    // ── Field handlers ─────────────────────────────────────────────────────────

    handleField(e) { this.lesson = { ...this.lesson, [e.target.dataset.field]: e.target.value }; }
    handleTestOutToggle(e) { this.lesson = { ...this.lesson, Allow_Test_Out__c: e.target.checked }; }
    handleUploaded(e) { this.lesson = { ...this.lesson, Content_URL__c: e.detail.url }; }
    handleQuizChange(e) { this.lesson = { ...this.lesson, Quiz__c: e.detail.value || null }; }

    // ── Knowledge article ──────────────────────────────────────────────────────

    handleKaSearch(e) {
        this.kaSearch = e.target.value;
        clearTimeout(this._kaSearchTimeout);
        if (!this.kaSearch || this.kaSearch.length < 2) { this.kaResults = []; return; }
        this.kaSearchLoading = true;
        this._kaSearchTimeout = setTimeout(() => {
            searchKnowledgeArticles({ searchTerm: this.kaSearch })
                .then(data => { this.kaResults = data || []; })
                .catch(err => { console.error('searchKnowledgeArticles error', err); })
                .finally(() => { this.kaSearchLoading = false; });
        }, 300);
    }

    handleArticleSelect(e) {
        const articleId = e.currentTarget.dataset.id;
        const title     = e.currentTarget.dataset.title;
        this.selectedArticleTitle = title;
        this.kaSearch   = '';
        this.kaResults  = [];
        // Store article lookup — clear any stale URL so it gets regenerated
        this.lesson = { ...this.lesson, Knowledge_Article__c: articleId, Knowledge_Article_URL__c: null };
        // Generate and save the public URL immediately
        this.resolveUrl(articleId);
    }

    clearArticle() {
        this.selectedArticleTitle = '';
        this.lesson = { ...this.lesson, Knowledge_Article__c: null, Knowledge_Article_URL__c: null };
    }

    resolveUrl(articleId) {
        this.isResolvingUrl = true;
        // Pass lessonId so Apex can save the URL directly on the record if it exists
        resolveAndSaveKnowledgeUrl({ articleId, lessonId: this.recordId || null })
            .then(url => {
                // Store URL in local state regardless of whether the lesson was saved yet
                this.lesson = { ...this.lesson, Knowledge_Article_URL__c: url };
            })
            .catch(err => { console.error('resolveAndSaveKnowledgeUrl error', err); })
            .finally(() => { this.isResolvingUrl = false; });
    }

    // ── Save ───────────────────────────────────────────────────────────────────

    handleSave() {
        if (this.hasNoTypes) { return; }
        this.isSaving = true;
        const payload = {};
        LESSON_FIELDS.forEach(f => { if (this.lesson[f] !== undefined) payload[f] = this.lesson[f]; });
        saveLesson({ lessonData: JSON.stringify(payload) })
            .then(() => {
                this.dispatchEvent(new CustomEvent('saved', { detail: { message: 'Lesson saved.' } }));
            })
            .catch(err => { console.error('saveLesson error', err); })
            .finally(() => { this.isSaving = false; });
    }

    handleBack() { this.dispatchEvent(new CustomEvent('back')); }
}

import { LightningElement, api, track } from 'lwc';
import getQuizDetail from '@salesforce/apex/LMSQuizController.getQuizDetail';
import getQuestionList from '@salesforce/apex/LMSQuizController.getQuestionList';
import addQuestionToQuiz from '@salesforce/apex/LMSQuizController.addQuestionToQuiz';
import removeQuizQuestion from '@salesforce/apex/LMSQuizController.removeQuizQuestion';
import updateQuestionPoints from '@salesforce/apex/LMSQuizController.updateQuestionPoints';

const CATEGORY_OPTIONS = [
    { label: 'All categories', value: '' },
    { label: 'HR', value: 'HR' },
    { label: 'Payroll', value: 'Payroll' },
    { label: 'Revenue', value: 'Revenue' },
    { label: 'Sales', value: 'Sales' },
    { label: 'Service', value: 'Service' },
    { label: 'ADP', value: 'ADP' },
];

export default class LmsQuizQuestionAdder extends LightningElement {
    @api quizId;
    @track questions = [];
    @track bankResults = [];
    @track bankSearch = '';
    @track bankCategory = '';
    @track isActioning = false;
    @track isBankLoading = false;
    categoryOptions = CATEGORY_OPTIONS;

    connectedCallback() {
        this.loadDetail();
        this.loadBank();
    }

    loadDetail() {
        if (!this.quizId) return;
        getQuizDetail({ quizId: this.quizId })
            .then(data => {
                if (data) {
                    this.questions = (data.questions || []).map(q => ({
                        ...q,
                        shortText: q.LMS_Question__r?.Question_Text__c?.slice(0, 80) + '…',
                        questionType: q.LMS_Question__r?.Question_Type__c,
                        questionCategory: q.LMS_Question__r?.Question_Category__c,
                        pointsValue: q.Points_Override__c ?? q.LMS_Question__r?.Default_Points__c,
                        junctionId: q.Id,
                    }));
                    this.loadBank();
                }
            })
            .catch(err => { console.error('getQuizDetail error', err); });
    }

    loadBank() {
        this.isBankLoading = true;
        getQuestionList({
            questionType: '',
            searchTerm: this.bankSearch,
            activeOnly: true,
            category: this.bankCategory
        })
            .then(data => {
                const inQuiz = new Set(this.questions.map(q => q.LMS_Question__c));
                this.bankResults = (data || [])
                    .filter(q => !inQuiz.has(q.Id))
                    .map(q => ({ ...q, shortText: q.Question_Text__c?.slice(0, 80) + '…' }));
            })
            .catch(err => { console.error('getQuestionList error', err); })
            .finally(() => { this.isBankLoading = false; });
    }

    get hasQuestions() { return this.questions.length > 0; }
    get questionCount() { return this.questions.length; }
    get noBankResults() { return !this.isBankLoading && this.bankResults.length === 0; }

    handleBankSearch(e) { this.bankSearch = e.target.value; this.loadBank(); }
    handleBankCategory(e) { this.bankCategory = e.detail.value; this.loadBank(); }

    handleAddQuestion(e) {
        const questionId = e.target.closest('[data-id]')?.dataset.id || e.currentTarget.dataset.id;
        const nextSeq = this.questions.length + 1;
        this.isActioning = true;
        addQuestionToQuiz({ quizId: this.quizId, questionId, sequenceNum: nextSeq })
            .then(() => { this.loadDetail(); this.dispatchEvent(new CustomEvent('changed')); })
            .catch(err => { console.error('addQuestionToQuiz error', err); })
            .finally(() => { this.isActioning = false; });
    }

    handleRemoveQuestion(e) {
        const junctionId = e.target.closest('[data-id]')?.dataset.id || e.currentTarget.dataset.id;
        this.isActioning = true;
        removeQuizQuestion({ junctionId })
            .then(() => { this.loadDetail(); this.dispatchEvent(new CustomEvent('changed')); })
            .catch(err => { console.error('removeQuizQuestion error', err); })
            .finally(() => { this.isActioning = false; });
    }

    handlePointsOverride(e) {
        const junctionId = e.target.dataset.id;
        const points = e.target.value;
        this.isActioning = true;
        updateQuestionPoints({ junctionId, points })
            .then(() => { this.loadDetail(); })
            .catch(err => { console.error('updateQuestionPoints error', err); })
            .finally(() => { this.isActioning = false; });
    }
}

import { LightningElement, api, track } from 'lwc';
import getQuestion from '@salesforce/apex/LMSQuizController.getQuestion';
import saveQuestion from '@salesforce/apex/LMSQuizController.saveQuestion';

const TYPE_OPTIONS = [
    { label: 'Multiple choice (MCQ)', value: 'MCQ' },
    { label: 'True / False', value: 'True/False' },
    { label: 'Open-ended', value: 'Open-Ended' },
    { label: 'Upload / assignment', value: 'Upload' },
];
const TF_OPTIONS = [
    { label: 'True', value: 'True' },
    { label: 'False', value: 'False' },
];
const CATEGORY_OPTIONS = [
    { label: '— Select category —', value: '' },
    { label: 'HR', value: 'HR' },
    { label: 'Payroll', value: 'Payroll' },
    { label: 'Revenue', value: 'Revenue' },
    { label: 'Sales', value: 'Sales' },
    { label: 'Service', value: 'Service' },
    { label: 'ADP', value: 'ADP' },
];

const QUESTION_FIELDS = [
    'Id', 'Name', 'Question_Text__c', 'Question_Type__c', 'Question_Category__c',
    'Option_A__c', 'Option_B__c', 'Option_C__c', 'Option_D__c',
    'Correct_Answer__c', 'Default_Points__c', 'Explanation__c', 'Is_Active__c'
];

export default class LmsQuestionForm extends LightningElement {
    @api recordId;
    @track question = { Question_Type__c: 'MCQ', Default_Points__c: 1, Is_Active__c: true, Question_Category__c: '' };
    @track isSaving = false;
    @track isLoading = false;
    typeOptions = TYPE_OPTIONS;
    tfOptions = TF_OPTIONS;
    categoryOptions = CATEGORY_OPTIONS;

    connectedCallback() { if (this.recordId) this.loadDetail(); }

    loadDetail() {
        this.isLoading = true;
        getQuestion({ questionId: this.recordId })
            .then(data => {
                if (data) {
                    const clean = {};
                    QUESTION_FIELDS.forEach(f => { if (data[f] !== undefined) clean[f] = data[f]; });
                    this.question = clean;
                }
            })
            .catch(err => { console.error('getQuestion error', err); })
            .finally(() => { this.isLoading = false; });
    }

    get formTitle() { return this.recordId ? 'Edit question' : 'New question'; }
    get isMCQ() { return this.question.Question_Type__c === 'MCQ'; }
    get isTrueFalse() { return this.question.Question_Type__c === 'True/False'; }
    get isOpenEnded() { return this.question.Question_Type__c === 'Open-Ended'; }
    get isUpload() { return this.question.Question_Type__c === 'Upload'; }
    get isOpenOrUpload() { return this.isOpenEnded || this.isUpload; }

    get mcqOptions() {
        return ['A', 'B', 'C', 'D'].map(k => ({
            key: k, value: this.question[`Option_${k}__c`] || '',
            isCorrect: this.question.Correct_Answer__c === k,
        }));
    }

    handleTypeChange(e) { this.question = { ...this.question, Question_Type__c: e.detail.value, Correct_Answer__c: null }; }
    handleCategoryChange(e) { this.question = { ...this.question, Question_Category__c: e.detail.value }; }
    handleField(e) { this.question = { ...this.question, [e.target.dataset.field]: e.target.value }; }
    handleActiveToggle(e) { this.question = { ...this.question, Is_Active__c: e.target.checked }; }
    handleCorrectAnswer(e) { this.question = { ...this.question, Correct_Answer__c: e.target.value }; }
    handleOptionText(e) {
        const field = `Option_${e.target.dataset.key}__c`;
        this.question = { ...this.question, [field]: e.target.value };
    }

    handleSave() {
        this.isSaving = true;
        const payload = {};
        QUESTION_FIELDS.forEach(f => { if (this.question[f] !== undefined) payload[f] = this.question[f]; });
        saveQuestion({ questionData: JSON.stringify(payload) })
            .then(() => { this.dispatchEvent(new CustomEvent('saved', { detail: { message: 'Question saved.' } })); })
            .catch(err => { console.error('saveQuestion error', err); })
            .finally(() => { this.isSaving = false; });
    }

    handleBack() { this.dispatchEvent(new CustomEvent('back')); }
}

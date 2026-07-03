import { LightningElement, api, track } from 'lwc';
import getQuizDetail from '@salesforce/apex/LMSQuizController.getQuizDetail';
import saveQuiz from '@salesforce/apex/LMSQuizController.saveQuiz';

export default class LmsQuizForm extends LightningElement {
    @api recordId;
    @track quiz = { Name: '', Passing_Score__c: 70 };
    @track isSaving = false;
    @track isLoading = false;

    connectedCallback() {
        if (this.recordId) this.loadDetail();
    }

    loadDetail() {
        this.isLoading = true;
        getQuizDetail({ quizId: this.recordId })
            .then(data => {
                if (data) this.quiz = { ...data.quiz };
            })
            .catch(err => { console.error('getQuizDetail error', err); })
            .finally(() => { this.isLoading = false; });
    }

    get formTitle() { return this.recordId ? `Edit: ${this.quiz.Name}` : 'New quiz'; }
    handleField(e) { this.quiz = { ...this.quiz, [e.target.dataset.field]: e.target.value }; }
    handleQuestionsChanged() {}

    handleSave() {
        this.isSaving = true;
        saveQuiz({ quizData: JSON.stringify(this.quiz) })
            .then(() => {
                const msg = this.recordId ? 'Quiz updated.' : 'Quiz created.';
                this.dispatchEvent(new CustomEvent('saved', { detail: { message: msg } }));
            })
            .catch(err => { console.error('saveQuiz error', err); })
            .finally(() => { this.isSaving = false; });
    }

    handleBack() { this.dispatchEvent(new CustomEvent('back')); }
}

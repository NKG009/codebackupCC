import { LightningElement, api, track } from 'lwc';
import saveQuiz from '@salesforce/apex/LMSQuizController.saveQuiz';
export default class LmsQuizSettings extends LightningElement {
    @api quizId;
    @api passingScore = 70;
    @track settings = { Passing_Score__c: 70, Max_Retakes__c: 0 };
    connectedCallback() { this.settings = { ...this.settings, Passing_Score__c: this.passingScore, Id: this.quizId }; }
    handleField(e) { this.settings = { ...this.settings, [e.target.dataset.field]: e.target.value }; }
    handleSave() { saveQuiz({ quizData: JSON.stringify(this.settings) }).then(() => this.dispatchEvent(new CustomEvent('saved'))); }
}

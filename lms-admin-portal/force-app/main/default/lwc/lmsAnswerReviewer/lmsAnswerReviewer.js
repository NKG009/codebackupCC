import { LightningElement, api, track, wire } from 'lwc';
import getAttemptDetail from '@salesforce/apex/LMSGradingController.getAttemptDetail';
import saveGrades from '@salesforce/apex/LMSGradingController.saveGrades';
import issueCertification from '@salesforce/apex/LMSGradingController.issueCertification';

const GRADING_OPTIONS = [
    { label: 'Correct', value: 'true' },
    { label: 'Incorrect', value: 'false' },
];

export default class LmsAnswerReviewer extends LightningElement {
    @api attemptId;
    @track attempt = {};
    @track answers = [];
    @track isLoading = true;
    @track isSaving = false;
    gradingOptions = GRADING_OPTIONS;

    @wire(getAttemptDetail, { attemptId: '$attemptId' })
    wiredDetail({ data, error }) {
        this.isLoading = false;
        if (data) {
            this.attempt = { ...data.attempt, formattedDate: new Date(data.attempt.CreatedDate).toLocaleDateString() };
            this.answers = (data.answers || []).map(a => ({
                ...a,
                questionText: a.Question__r?.Question_Text__c,
                questionType: a.Question__r?.Question_Type__c,
                maxPoints: a.Question__r?.Default_Points__c,
                needsGrading: a.Grading_Status__c === 'Pending Review' || a.Grading_Status__c === 'Graded',
                hasUpload: a.Upload_File__c,
                hasLearnerFeedback: !!a.Learner_Feedback__c,
                isCorrectStr: a.Is_Correct__c === null ? null : String(a.Is_Correct__c),
                cssClass: `answer-block answer-block--${a.Grading_Status__c?.toLowerCase().replace(' ', '-') || 'pending'}`,
            }));
        }
    }

    get canCertify() {
        return this.answers.length > 0 && this.answers.every(a => a.Grading_Status__c === 'Graded');
    }

    handlePointsChange(e) { this.answers = this.answers.map(a => a.Id === e.target.dataset.id ? { ...a, Points_Awarded__c: e.target.value } : a); }
    handleIsCorrect(e) { this.answers = this.answers.map(a => a.Id === e.target.dataset.id ? { ...a, Is_Correct__c: e.detail.value === 'true', isCorrectStr: e.detail.value } : a); }
    handleComment(e) { this.answers = this.answers.map(a => a.Id === e.target.dataset.id ? { ...a, Instructor_Comment__c: e.target.value } : a); }

    handleSaveGrades() {
        this.isSaving = true;
        saveGrades({ attemptId: this.attemptId, answers: JSON.stringify(this.answers) })
            .then(() => { this.dispatchEvent(new CustomEvent('graded')); })
            .finally(() => { this.isSaving = false; });
    }

    handleCertify() {
        this.isSaving = true;
        saveGrades({ attemptId: this.attemptId, answers: JSON.stringify(this.answers) })
            .then(() => issueCertification({ attemptId: this.attemptId }))
            .then(() => { this.dispatchEvent(new CustomEvent('graded')); })
            .finally(() => { this.isSaving = false; });
    }
}

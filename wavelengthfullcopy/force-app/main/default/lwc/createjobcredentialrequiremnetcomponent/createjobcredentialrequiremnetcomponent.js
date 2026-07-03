import { LightningElement, wire, api, track } from 'lwc';
import getActiveCredentialQuestions from '@salesforce/apex/CredentialRequirementController.getActiveCredentialQuestions';
import getCredentialRequirements from '@salesforce/apex/CredentialRequirementController.getCredentialRequirements';
import createCredentialRequirements from '@salesforce/apex/CredentialRequirementController.createCredentialRequirements';
import deleteCredentialRequirements from '@salesforce/apex/CredentialRequirementController.deleteCredentialRequirements';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import { refreshApex } from '@salesforce/apex';
// import { CloseActionScreenEvent } from 'lightning/actions';

export default class ManageRequirements extends LightningElement {
    @track searchKey = '';
    @track questions = [];
    @track selectedQuestions = [];
    @track requirements = [];
    @track selectedRequirements = [];
    @track searchKeyRemove = '';
    @track showTabs = false;
    @track activeTab = 'add'; // Track the active tab
questionsTest ;
      requirementsTest ;

    @api recordId

    @wire(getActiveCredentialQuestions, { searchKey: '$searchKey' })
    wiredQuestions(result) {
        this.questionsTest = result;
        const {data, error} = result;
        if (data) {
            this.questions = data;
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }
        @wire(getCredentialRequirements, { jobId: '$recordId', searchKey: '$searchKeyRemove' })
        wiredrequirements(result) {
            this.requirementsTest = result;
        const {data, error} = result;
        if (data) {
            this.requirements = data;
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearchKeyChangeRemove(event) {
        this.searchKeyRemove = event.target.value;
    }

    handleSelectQuestion(event) {
        const questionId = event.target.value;
        if (event.target.checked) {
            this.selectedQuestions.push(questionId);
        } else {
            this.selectedQuestions = this.selectedQuestions.filter(id => id !== questionId);
        }
    }

    handleSelectRequirement(event) {
        const requirementId = event.target.value;
        if (event.target.checked) {
            this.selectedRequirements.push(requirementId);
        } else {
            this.selectedRequirements = this.selectedRequirements.filter(id => id !== requirementId);
        }
    }

     handleCreateRequirements() {
        if (this.selectedQuestions.length > 0 && this.recordId) {
            createCredentialRequirements({ questionIds: this.selectedQuestions, jobId: this.recordId })
                .then(() => {
                    this.showToast('Success', 'Credential Requirements created successfully', 'success');
                    
                    //  this.dispatchEvent(new CloseActionScreenEvent());
                    // this.handleClose(); // Close modal after successful creation
                     this.dispatchEvent(new RefreshEvent());
                     this.searchKey = '';
                      return Promise.all([
                    refreshApex(this.questionsTest),
                    refreshApex(this.requirementsTest)
                ]);
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                });
        } else {
            this.showToast('Error', 'Please select Credential Masters to create Credentail Requirements', 'error');
        }
    }

    handleDeleteRequirements() {
        if (this.selectedRequirements.length > 0) {
            deleteCredentialRequirements({ requirementIds: this.selectedRequirements })
                .then(() => {
                    this.showToast('Success', 'Credential Requirements deleted successfully', 'success');
                    this.selectedRequirements = [];
                  
                    //  this.dispatchEvent(new CloseActionScreenEvent());
                    // this.handleClose(); // Close modal after successful deletion
                    this.dispatchEvent(new RefreshEvent());
                    this.searchKeyRemove = '';
                     return Promise.all([
                    refreshApex(this.questionsTest),
                    refreshApex(this.requirementsTest)
                ]);
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                });
        } else {
            this.showToast('Error', 'Please select Credential Requirements to delete', 'error');
        }
    }

    handleConfirmClick() {
        this.showTabs = true;
    }

    handleClose() {
        this.searchKeyRemove = '';
        this.searchKey = '';
        this.showTabs = false;
    }

    handleTabChange(event) {
        this.activeTab = event.target.value;
        console.log('Active Tab:', this.activeTab); // Debugging statement
    }

       showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }


    get hasQuestions() {
        return this.questions.length > 0;
    }

    get hasRequirements() {
        return this.requirements.length > 0;
    }

    get isAddTabActive() {
        console.log('isAddTabActive:', this.activeTab === 'add'); // Debugging statement
        return this.activeTab === 'add';
    }

    get isRemoveTabActive() {
        console.log('isRemoveTabActive:', this.activeTab === 'remove'); // Debugging statement
        return this.activeTab === 'remove';
    }
}
import { LightningElement, track } from 'lwc';
import getCustomerApprovalToAction from '@salesforce/apex/CustomerApprovalController.getCustomerApprovalToAction';
import submitApproval from '@salesforce/apex/CustomerApprovalController.submitApproval';
import Logofr from '@salesforce/resourceUrl/Cogeco911FrenchLogo';
import LogoEng from '@salesforce/resourceUrl/CogecoLogo911Eng';
import Engpdf from '@salesforce/resourceUrl/Cogeco_Consent_ENG';
import Frpdf from '@salesforce/resourceUrl/Cogeco_Consent_FR';

const SUCCESS_VARIANT = 'success';
const NEUTRAL_VARIANT = 'neutral';
const DESTRUCTIVE_VARIANT = 'destructive';

export default class Cogeco911Consent extends LightningElement {
    @track recordId;
    @track communicationLanguage;
    @track approvers = [];
    @track selectedContact = '';
    @track isChecked = false;
    @track selectedAction = '';
    @track isSubmitDisabled = true;

    @track approvalVariant = NEUTRAL_VARIANT;
    @track declineVariant = NEUTRAL_VARIANT;

    @track successMessage = '';
    @track statusMessage = ''; // message if form already submitted

    logoUrl;

    get isEnglish() {
        return this.communicationLanguage === 'English';
    }

    get checkboxLabel() {
        return this.isEnglish 
            ? 'I have read and acknowledged the terms and conditions of the 911 services'
            : 'J’ai lu et j’accepte les modalités des services 9-1-1.';
    }

    get showForm() {
        return !this.statusMessage; // form shows only if no status message
    }

    connectedCallback() {
        const urlParams = new URL(window.location.href).searchParams;
        this.recordId = urlParams.get('p2');
        this.communicationLanguage = urlParams.get('p3');

        this.logoUrl = this.isEnglish ? LogoEng : Logofr;

        this.loadCustomerApproval();
    }

    async loadCustomerApproval() {
        try {
            const result = await getCustomerApprovalToAction({ approvalRecordId: this.recordId });
            const resultDto = JSON.parse(result);

            // Check if Status__c is Approved or Rejected
            if (resultDto.Status__c === 'Approved' || resultDto.Status__c === 'Rejected') {
                this.statusMessage = this.isEnglish 
                    ? 'The form is already submitted.'
                    : 'Le formulaire a déjà été soumis.';
                return; // do not load form
            }

            this.approvers = resultDto.approvers.map(a => ({
                label: a.name,
                value: a.contactId
            }));

        } catch (error) {
            console.error('Error loading approvers:', error);
        }
    }

    handleContactChange(event) {
        this.selectedContact = event.detail.value;
        this.successMessage = '';
        this.updateSubmitState();
    }

    handleCheckboxChange(event) {
        this.isChecked = event.target.checked;
        this.successMessage = '';
        this.updateSubmitState();
    }

    handleDownloadPDF() {
    let pdfFileUrl;

    // Pick the correct PDF based on communication language
    if (this.communicationLanguage === 'English') {
        pdfFileUrl = Engpdf;
    } else {
        pdfFileUrl = Frpdf;
    }

    // Create a download link dynamically
    const link = document.createElement('a');
    link.href = pdfFileUrl;
    link.download = this.communicationLanguage === 'English'
        ? 'Cogeco_Consent_ENG.pdf'
        : 'Cogeco_Consent_FR.pdf';
    link.target = '_blank';
    link.click();
    }

    customerSelectionMade(event) {
        const selection = event.currentTarget.dataset.selection;
        this.approvalVariant = selection === 'Approved' ? SUCCESS_VARIANT : NEUTRAL_VARIANT;
        this.declineVariant = selection === 'Declined' ? DESTRUCTIVE_VARIANT : NEUTRAL_VARIANT;
        this.selectedAction = selection;
        this.successMessage = '';
        this.updateSubmitState();
    }

    updateSubmitState() {
        this.isSubmitDisabled = !(this.isChecked && this.selectedAction && this.selectedContact);
    }

    async handleSubmit() {
        if (!this.recordId || !this.selectedContact || !this.selectedAction || !this.isChecked) {
            return;
        }

        try {
            await submitApproval({
                recordId: this.recordId,
                selectedContactId: this.selectedContact,
                isAccepted: this.isChecked,
                action: this.selectedAction
            });

            this.successMessage = this.isEnglish 
                ? 'The form is submitted. Thank you!' 
                : 'Le formulaire a été soumis. Merci !';

            // Optionally, hide form after submit
            this.statusMessage = this.successMessage;
            this.selectedContact = '';
            this.isChecked = false;
            this.selectedAction = '';
            this.approvalVariant = NEUTRAL_VARIANT;
            this.declineVariant = NEUTRAL_VARIANT;
            this.updateSubmitState();

        } catch (error) {
            console.error('Submission error:', error);
        }
    }
}
import { LightningElement, api, track, wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import SIGNATURE_STYLES from '@salesforce/resourceUrl/ca_styles';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

import translate from '@salesforce/apex/CustomLabelTranslator.translate';
import getCustomerApprovalToAction from '@salesforce/apex/CustomerSignatureController.getCustomerApprovalToAction';
import save from '@salesforce/apex/CustomerSignatureController.save';
import is911FormSectionRequired from '@salesforce/apex/CustomerSignatureController.is911FormSectionRequired';

const SUCCESS_VARIANT = "success";
const DESTRUCTIVE_VARIANT = "destructive";
const NEUTRAL_VARIANT = "brand-outline";

const pageLabels = [
    "AdditionalFiles",
    "ActionHeader",
    "Approve",
    "ApproverPhysicalSignature",
    "ApproverSignature",
    "ContentTypeHeader",
    "CompleteThisField",
    "CustomerComments",
    "Decline",
    "DownloadButton",
    "FileNameHeader",
    "OrDropFiles",
    "PleaseSubmitYourDecision",
    "SelectAnOption",
    "SignatorysName",
    "Submit",
    "UploadFiles",
    "X911_Consent_Form",
    "TermsAndConditions",
    "CompleteThisCheckbox"
  ];

export default class B2bSignatureCapture extends NavigationMixin(LightningElement) {
    @api customerApprovalId;
    approvers = [];
    approver;
    customerApprovalDetails = {};
    responseDetails = {};
    fileDetails = [];
    downloadLink;
    fileData;
    fileData1;
    ipAddress;
    pageLabelsObj = {};


    @track is911FormRequired = false;
    @track loaded = false;
    @track approvalVariant = NEUTRAL_VARIANT;
    @track declineVariant = NEUTRAL_VARIANT;
    @track displayFullForm = false;
    @track isSubmitDisabled = true;
    @track checkApproval = false;
    @track checkConsent = false;
    @track isChecked = false;

    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
        this.loadSignatureStyles();
        this.retrieveAppropriateCustomLabel();
        this.getCustomerApprovalToAction();
        this.getPublicIPAddress((ipAddress) => {
            this.ipAddress = ipAddress;
        });

        this.displayFullForm = true;
    }

    loadSignatureStyles() {
        loadStyle(this, SIGNATURE_STYLES + '/b2b_styles/styles-customerconfirmation.css');
        loadStyle(this, SIGNATURE_STYLES + '/b2b_styles/styles-customerapproval.css');
    }

    getCustomerApprovalToAction() {
        getCustomerApprovalToAction({ approvalRecordId: this.customerApprovalId })
        .then((result) => {
            let resultDto = JSON.parse(result);

            this.customerApprovalDetails = resultDto;
            let approvers = [];

            for (let approver of resultDto.approvers) {
                approvers.push({ label: approver.name, value: approver.contactId })
            }

            this.approvers = approvers;
            this.loaded = true;
        }).catch(error => {
            this.navigate("comm__namedPage", "error");
        });
    }

    retrieveAppropriateCustomLabel() {
        let lang = this.currentPageReference.state.p3 == 'French' ? 'fr' : 'en';
        translate({ language: lang, labels: pageLabels })
        .then((result) => {
            this.pageLabelsObj = JSON.parse(result);
        }).catch(error => {
            this.navigate("comm__namedPage", "error");
        });
    }
    
    openfileUpload(event) {
        const file = event.target.files[0];
        let reader = new FileReader();

        reader.onload = () => {
            let base64 = reader.result.split(',')[1];

            this.fileData = {
                filename: "[Signature] " + file.name,
                base64: base64,
                recordId: this.customerApprovalId
            }
        }

        reader.readAsDataURL(file);
    }

    downloadAttachment() {
        let downloadUrl = this.customerApprovalDetails.downloadUrl;
        
        this.navigate(downloadUrl);
    }

    getBaseUrl() {
        return 'https://' + location.host + '/';
    }

    handleSave() {
        this.captureSignatureData();
    }

    getPublicIPAddress(callback) {
        let request = new XMLHttpRequest();
        request.open('GET', "https://api.ipify.org?format=jsonp=", true);
        request.onload = function () {
            if (request.status >= 200 && request.status < 400) {
                let ipAddress = request.responseText;

                if (callback) {
                    callback(ipAddress);
                }
            }
        }

        request.send();
    }

    captureSignatureData() {
        const approver = this.customerApprovalDetails.approvers.find(approver => approver.contactId === this.approver);
        const selectedSignatory = this.customerApprovalDetails.approvers.find(selectedSignatory => selectedSignatory.contactId === this.selectedSignatory);
        this.responseDetails.comments = this.template.querySelector(`textarea[data-comments]`).value;
        this.responseDetails.contactId = approver.contactId;
        this.responseDetails.approvedByEmail = approver.emailAddress;
        this.responseDetails.approvedBy = approver?.name;
        this.responseDetails.customerApprovalId = this.customerApprovalDetails.customerApproval.Id;
        this.responseDetails.ipAddress = this.ipAddress;
        this.responseDetails.consentedBy = selectedSignatory?.name;
        this.responseDetails.checkboxChecked = this.isChecked;   //updates by vivek singh

        let finalResult = JSON.stringify(this.responseDetails);

        if (this.fileData != null) {
            this.fileDetails.push({
                base64: this.fileData.base64,
                filename: this.fileData.filename
            });
        }
        
        if (this.fileData1 != null) {
            this.fileDetails.push({
                base64: this.fileData1.base64,
                filename: this.fileData1.filename
            });
        }
       

        let finalFile = JSON.stringify(this.fileDetails);

        save({ jsonData: finalResult, jsonFiles: finalFile, recordId: this.customerApprovalId })
            .then((result) => {
            let transformedDecision = this.responseDetails.status == "Approved" ? "approve" : "reject";

            this.dispatchEvent(new CustomEvent("formsubmitted", { detail: { decision: transformedDecision }}));
        }).catch(error => {
            this.navigate("comm__namedPage", "error");
        });
    }

    customerSelectionMade(event) {
        const checkbox = this.template.querySelector('[data-id="termsCheckbox"]');

            
            const isValid = checkbox.reportValidity();

            
        let selection = event.currentTarget.dataset.selection;

        if (selection == "Approved") {
            this.approvalVariant = SUCCESS_VARIANT;
            this.declineVariant = NEUTRAL_VARIANT;
        } else {
            this.approvalVariant = NEUTRAL_VARIANT;
            this.declineVariant = DESTRUCTIVE_VARIANT;
        }

        this.responseDetails.status = selection;

        //updates by vivek singh
        if ( this.isChecked) {
            this.isSubmitDisabled = false;
        }
        //this.isSubmitDisabled = false;

        if (!this.approver || (!this.selectedSignatory && this.is911FormRequired)) {
            this.isSubmitDisabled = true;
        }
    }

    handleSignatoryChange(event) {
        let selectionHasBeenMade = this.approvalVariant == SUCCESS_VARIANT || this.declineVariant == DESTRUCTIVE_VARIANT;
        this.approver = event.target.value;
        this.checkApproval = true;
        if (selectionHasBeenMade && (this.checkConsent || !this.is911FormRequired) && this.isChecked ) {
            this.isSubmitDisabled = false;
        }
    }

    navigate(url) {
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: url
            }
        }, false);
    }

 
    // Wire the Apex method to fetch the requirement status
    @wire(is911FormSectionRequired, { customerApprovalId: '$customerApprovalId' })
    wiredIs911FormRequired({ error, data }) {
        if (data) {
            this.is911FormRequired = data;
        } else if (error) {
            this.navigate("comm__namedPage", "error");
        }
    }
//A duplicate on change event for 911 Consent
    handleConsentChange(event) {
        let selectionHasBeenMade = this.approvalVariant == SUCCESS_VARIANT || this.declineVariant == DESTRUCTIVE_VARIANT;
        this.selectedSignatory = event.target.value;
        this.checkConsent = true;
        if (selectionHasBeenMade && this.checkApproval) {
            this.isSubmitDisabled = false;
        }
    }


//A duplicate file upload event for 911 Consent
openfileUpload1(event) {
    const file1 = event.target.files[0];
    let reader1 = new FileReader();

    reader1.onload = () => {
        let base64 = reader1.result.split(',')[1];

        this.fileData1 = {
            filename: "[Consent] " + file1.name,
            base64: base64,
            recordId: this.customerApprovalId
        }
    }

    reader1.readAsDataURL(file1);
}

//updates by vivek singh
handleTermsChange(event) {
    this.isChecked = event.target.checked;
    console.log('this.isChecked>>' + this.isChecked);
    event.target.reportValidity();

    let selectionHasBeenMade = this.approvalVariant === SUCCESS_VARIANT || this.declineVariant === DESTRUCTIVE_VARIANT;

    if (selectionHasBeenMade && this.checkApproval && this.isChecked) {
        this.isSubmitDisabled = false;
    } else {
        this.isSubmitDisabled = true;
    }
}

}
import { LightningElement, api, track } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { updateRecord } from 'lightning/uiRecordApi';

import recordDetails from '@salesforce/apex/CustomerAttachmentSelectionsController.getCustomerEmailAttachments';
import translate from '@salesforce/apex/CustomLabelTranslator.translate';

import NEXT from '@salesforce/label/vlocity_cmt.Next';
const ENGLISH = "English";
const FRENCH = "French";
const HYPHEN = "-";

import QUOTE_ID from '@salesforce/schema/Quote.Id';
import COMMUNICATION_LANGUAGE from '@salesforce/schema/Quote.Communication_Language__c';
import SELECTED_ATTACHMENTS from '@salesforce/schema/Quote.Selected_Attachments__c';

export default class CustomerAttachmentSelections extends LightningElement {
    @track options;
    @track communicationsLanguage;
    @track language;
    @track loading = true;
    @api recordId;
    @api availableActions = [ "NEXT" ];

    labels = {
        ENGLISH,
        FRENCH,
        NEXT
    }

    languageMatch = {
        EN: ENGLISH,
        FR: FRENCH
    }

    connectedCallback() {
        this.getRecordDetails();
    }

    retrieveAppropriateCustomLabel(labels) {
        translate({ labels: labels })
        .then((result) => {
            let options = this.options;
            let labels = JSON.parse(result);

            for (let option of options) {
                let attachmentLabel = labels[option.Presentation_Label__c];
                let attachmentDescription = labels[option.Attachment_Description__c];
                option.attachmentName = attachmentLabel;
                option.attachmentDescription = attachmentDescription;
            }

            this.options = options;
        }).catch(error => {
            console.log("Error: ", error);
        });
    }

    getRecordDetails() {
        recordDetails({ recordId: this.recordId })
        .then((data) => {
            this.options = JSON.parse(data);
            this.loading = false;
        });
    }

    handleNext() {
        if (this.availableActions.find(action => action === "NEXT")) {
            this.processNext();
        }
    }

    processNext() {
        this.toggleButton(true);

        let options = this.template.querySelectorAll("c-visual-picker-option");
        let selections = [];

        for (let option of options) {
            let response = option.getValue();
            
            if (response.selected) {
                selections.push(response.attachmentId);
            }
        }

        let selectionsFinal = selections.join(";");

        this.updateQuote(true, selectionsFinal);
    }

    toggleButton(disable) {
        let nextButton = this.template.querySelector("button.flow-button__NEXT");

        if (disable) {
            nextButton.disabled = true;
            return;
        }

        nextButton.disabled = false;
    }

    changeLanguage(event) {
        this.language = event.currentTarget.dataset.lang;
        let languageCommunicationKey = this.language.replace(HYPHEN, "");
        this.communicationsLanguage = this.languageMatch[languageCommunicationKey];

        this.updateQuote(false);
    }

    updateQuote(navigate, selections) {
        this.loading = true;
        this.toggleButton(true);

        const fields = {};
        fields[QUOTE_ID.fieldApiName] = this.recordId;
        fields[COMMUNICATION_LANGUAGE.fieldApiName] = this.communicationsLanguage;
        fields[SELECTED_ATTACHMENTS.fieldApiName] = selections;

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            if (navigate) {
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            } else {
                this.getRecordDetails();
                this.toggleButton(false);
            }
        })
        .catch((error) => {
            this.toggleButton(false);
            this.loading = false;
        });
    }
}
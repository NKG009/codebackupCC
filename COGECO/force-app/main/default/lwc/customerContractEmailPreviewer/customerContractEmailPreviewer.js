import { LightningElement, api, track, wire } from 'lwc';
import { FlowNavigationNextEvent, FlowNavigationBackEvent } from 'lightning/flowSupport';
import getEmailTemplateBasedOnLanguage from '@salesforce/apex/CustomerContractEmailPreviewerController.getEmailTemplateBasedOnLanguage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from "lightning/uiRecordApi";
import { updateRecord } from 'lightning/uiRecordApi';

import QUOTE_ID from '@salesforce/schema/Quote.Id';
import COMMUNICATION_LANGUAGE from '@salesforce/schema/Quote.Communication_Language__c';
import CONTROL_DOCUMENT_LINES_FIELD from '@salesforce/schema/Quote.Control_Document_Lines__c';

import English from '@salesforce/label/c.English';
import French from '@salesforce/label/c.French';
import Send from '@salesforce/label/vlocity_cmt.VlocityDocuSignSend';
import Back from '@salesforce/label/vlocity_cmt.Back';
import SendDocument from '@salesforce/label/c.Send_Document';
import SendDocumentToCustomerPreviewMessage from '@salesforce/label/c.Send_Document_to_Customer_Preview_Message';
import Preview from '@salesforce/label/vlocity_cmt.Preview';
import ShowDisconnections from '@salesforce/label/c.Show_Disconnections';
import HideDisconnections from '@salesforce/label/c.Hide_Disconnections';
import ShowExisting from '@salesforce/label/c.Show_Existing';
import HideExisting from '@salesforce/label/c.Hide_Existing';

const EN = "EN-";
const FR = "FR-";
const HYPHEN = "-";
const ENGLISH = "English";
const FRENCH = "French";

const FIELDS = ["Quote.Control_Document_Lines__c"];

export default class CustomerContractEmailPreviewer extends LightningElement {
    @track emailTemplate;
    @track currentLanguage;
    @api isPreview = false;
    @api isDisconnections = false;
    @api isExisting = false;
    @api templateId;
    @api orderId;
    @api language;
    @api communicationsLanguage;
    @api availableActions = [ "NEXT", "BACK" ];
    labels = {
        english: English,
        french: French,
        send: Send,
        back: Back,
        sendDocument: SendDocument,
        previewMessage: SendDocumentToCustomerPreviewMessage,
        preview: Preview,
        showDisconnections : ShowDisconnections,
        hideDisconnections : HideDisconnections,
        showExisting: ShowExisting,
        hideExisting: HideExisting
    }

    languageMatch = {
        EN: ENGLISH,
        FR: FRENCH
    }

    @wire(getRecord, { recordId: "$orderId", fields: FIELDS })
    wiredQuote({ error, data }) {
        if (data) {
            this.isDisconnections = data.fields.Control_Document_Lines__c.value?.includes("Disconnect");
            this.isExisting = data.fields.Control_Document_Lines__c.value?.includes("Existing");
        } else if (error) {
            
        }
    }

    connectedCallback() {
        this.getEmailTemplate();

        let languageCommunicationKey = this.language.replace(HYPHEN, "");
        this.communicationsLanguage = this.languageMatch[languageCommunicationKey];
    }

    getEmailTemplate() {
        getEmailTemplateBasedOnLanguage({ language: this.language })
        .then((results) => {
            this.emailTemplate = results;
            this.templateId = results.templateId;
        })
        .catch(error =>{
            this.showNotification('Error', 'Failed to load the email template for previewing. ' + error, 'error');
        })
    }
	
	showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    changeLanguage(event) {
        this.language = event.currentTarget.dataset.lang;
        let languageCommunicationKey = this.language.replace(HYPHEN, "");
        this.communicationsLanguage = this.languageMatch[languageCommunicationKey];

        this.updateQuote();
        this.getEmailTemplate();
    }

    handleSend() {
        this.isPreview = !this.isPreview;

        if (this.availableActions.find(action => action === "NEXT")) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    handleBack() {
        if (this.availableActions.find(action => action === "BACK")) {
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    toggleButton(disable) {
        let nextButton = this.template.querySelector("button.flow-button__NEXT");

        if (disable) {
            nextButton.disabled = true;
            return;
        }

        nextButton.disabled = false;
    }

    setIsPreview(event) {
        this.isPreview = !this.isPreview;
    }
    
    setIsDisconnections(event) {
        this.isDisconnections = event.target.checked;
        this.updateControlDocumentLinesField();
    }
    
    setIsExisting(event) {
        this.isExisting = event.target.checked;
        this.updateControlDocumentLinesField();
    }

    updateControlDocumentLinesField() {
        const controlDocumentLines = [];
        if (this.isDisconnections) {
            controlDocumentLines.push('Disconnect');
        }
        if (this.isExisting) {
            controlDocumentLines.push('Existing');
        }

        const fields = {};
        fields[QUOTE_ID.fieldApiName] = this.orderId;
        fields[CONTROL_DOCUMENT_LINES_FIELD.fieldApiName] = controlDocumentLines.join(';');

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            this.showNotification('Success', 'Quote updated successfully', 'success');
        })
        .catch((error) => {
            this.showNotification('Error', 'Failed to update the quote: ' + error.body.message, 'error');
        });
    }

    updateQuote() {
        this.toggleButton(true);

        const fields = {};
        fields[QUOTE_ID.fieldApiName] = this.orderId;
        fields[COMMUNICATION_LANGUAGE.fieldApiName] = this.communicationsLanguage;

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            this.toggleButton(false);
        })
        .catch((error) => {
            this.toggleButton(false);
        });
    }
}
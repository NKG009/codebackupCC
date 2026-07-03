import { LightningElement, api, track, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

import translate from '@salesforce/apex/CustomLabelTranslator.translate';

import { loadStyle } from 'lightning/platformResourceLoader';
import SIGNATURE_STYLES from '@salesforce/resourceUrl/ca_styles';

const FRESHLY_COMPLETED_LABEL = "Customer_Approval_Decision_Message";
const ALREADY_COMPLETED_LABEL = "Customer_Approval_Decision_Already_Captured";
const HEADER_LABEL = "Contract_Approval";
const DECISION = "{{DECISION}}";

export default class B2bSignatureCompleted extends NavigationMixin(LightningElement) {
    @api isSignatureCaptured = false;
    @api signatureDecision;
    @api isFreshlyCompleted = false;

    @track loaded = false;
    @track finalLabels = {};

    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
        this.retrieveAppropriateCustomLabel();
        this.loadSignatureStyles();

        this.loaded = true;
    }

    loadSignatureStyles() {
        loadStyle(this, SIGNATURE_STYLES + '/b2b_styles/styles-customerconfirmation.css');
        loadStyle(this, SIGNATURE_STYLES + '/b2b_styles/styles-customerapproval.css');
    }

    retrieveAppropriateCustomLabel() {
        let lang = this.currentPageReference.state.p3 == 'French' ? 'fr' : 'en';
        let translationSend = [];
        let translation = ALREADY_COMPLETED_LABEL;

        if (this.isFreshlyCompleted) {
            translation = FRESHLY_COMPLETED_LABEL;
        }

        translationSend.push(translation);
        translationSend.push(HEADER_LABEL);

        translate({ language: lang, labels: translationSend })
        .then((result) => {
            let results = JSON.parse(result);
            this.finalLabels.header = results[HEADER_LABEL].replace(DECISION, this.signatureDecision);
            this.finalLabels.content = results[translation].replace(DECISION, this.signatureDecision);
        }).catch(error => {
            console.log(error);
            //this.navigate("comm__namedPage", "error");
        });
    }

    navigate(url) {
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: url
            }
        }, false);
    }
}
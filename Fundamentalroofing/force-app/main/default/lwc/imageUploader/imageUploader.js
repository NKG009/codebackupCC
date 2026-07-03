import { LightningElement, api, wire } from 'lwc';
import getRichTextFields from '@salesforce/apex/saveImagesToOpportunity.getRichTextFields';
import savePdfToOpportunity from '@salesforce/apex/saveImagesToOpportunity.savePdfToOpportunity';
import { getRecord } from 'lightning/uiRecordApi';
import { loadScript } from 'lightning/platformResourceLoader';
import html2canvasResource from '@salesforce/resourceUrl/html2canvas';
import jsPDFResource from '@salesforce/resourceUrl/jspdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OpportunityPdfGenerator extends LightningElement {
    @api recordId;
    richText1 = '';
    richText2 = '';
    showPdfButton = false;

    html2canvasInitialized = false;
    jsPDFInitialized = false;
    richTextInserted = false;

    @wire(getRecord, { recordId: '$recordId', fields: ['Opportunity.StageName'] })
    oppRecord;

    get isClosedWon() {
        return this.oppRecord?.data?.fields?.StageName.value === 'Closed Won';
    }

    get isButtonDisabled() {
        return !this.html2canvasInitialized || !this.jsPDFInitialized;
    }

    connectedCallback() {
        getRichTextFields({ oppId: this.recordId })
            .then(data => {
                this.richText1 = data.rtf1 || '';
                this.richText2 = data.rtf2 || '';
                this.showPdfButton = true;
            });
    }

    renderedCallback() {
        // Insert Rich Text only once
        if (this.richTextInserted) return;

        const rtf1Div = this.template.querySelector('.rtf1');
        const rtf2Div = this.template.querySelector('.rtf2');

        if (rtf1Div && rtf2Div) {
            rtf1Div.innerHTML = this.richText1;
            rtf2Div.innerHTML = this.richText2;
            this.richTextInserted = true;
        }

        // Load libraries once
        if (!this.html2canvasInitialized || !this.jsPDFInitialized) {
            Promise.all([
                loadScript(this, html2canvasResource),
                loadScript(this, jsPDFResource)
            ])
            .then(() => {
                this.html2canvasInitialized = true;
                this.jsPDFInitialized = true;
            })
            .catch(error => console.error('Error loading scripts', error));
        }
    }

    async handleDownload() {
        if (!this.html2canvasInitialized || !this.jsPDFInitialized) {
            this.showToast('Error', 'Libraries not loaded yet', 'error');
            return;
        }

        const pdfDiv = this.template.querySelector('.pdf-content');
        if (!pdfDiv) {
            this.showToast('Error', 'PDF content not ready', 'error');
            return;
        }

        try {
            const canvas = await window.html2canvas(pdfDiv, {useCORS: true, allowTaint: true});
            const imgData = canvas.toDataURL('image/png');

            const pdf = new window.jspdf.jsPDF({orientation: "portrait", unit: "pt", format: "a4"});
            const pageWidth = pdf.internal.pageSize.getWidth();
            pdf.addImage(imgData, 'PNG', 0, 0, pageWidth, canvas.height * (pageWidth / canvas.width));

            const base64Pdf = pdf.output('datauristring').split(',')[1];

            // Save PDF to Salesforce
            await savePdfToOpportunity({ oppId: this.recordId, fileName: 'Opportunity.pdf', base64Data: base64Pdf });

            // Download for user
            pdf.save('Opportunity.pdf');

            this.showToast('Success', 'PDF generated and uploaded!', 'success');
        } catch (error) {
            this.showToast('Error', error.message || error, 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
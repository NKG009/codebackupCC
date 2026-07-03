import { LightningElement, api, track } from 'lwc';
export default class LmsContentUploader extends LightningElement {
    @api label = 'Upload file';
    @api accept = '.pdf,.mp4,.docx';
    @api recordId;
    @track uploadedUrl = null;
    @track fileName = '';

    handleUpload(e) {
        const file = e.detail.files[0];
        this.uploadedUrl = '/sfc/servlet.shepherd/version/download/' + file.contentVersionId;
        this.fileName = file.name;
        this.dispatchEvent(new CustomEvent('uploaded', { detail: { url: this.uploadedUrl, name: this.fileName } }));
    }
    clearFile() { this.uploadedUrl = null; this.fileName = ''; this.dispatchEvent(new CustomEvent('uploaded', { detail: { url: null } })); }
}

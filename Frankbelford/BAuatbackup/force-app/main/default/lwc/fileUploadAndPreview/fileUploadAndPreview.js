import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'
import getFiles from '@salesforce/apex/FileController.getFiles';
import deleteFile from '@salesforce/apex/FileController.deleteFile';

export default class FileUploadAndPreview extends NavigationMixin(LightningElement) {
    @api recordId;
    @track files = [];

    connectedCallback() {
        this.loadFiles();
    }

    loadFiles() {
        getFiles({ parentId: this.recordId })
            .then(result => {
                this.files = result.map(file => {
                    const fileType = file.FileExtension ? file.FileExtension.toLowerCase() : '';
                    let iconName = 'doctype:attachment'; // Default icon

                    switch (fileType) {
                        case 'pdf':
                            iconName = 'doctype:pdf';
                            break;
                        case 'doc':
                        case 'docx':
                            iconName = 'doctype:word';
                            break;
                        case 'xls':
                        case 'xlsx':
                            iconName = 'doctype:excel';
                            break;
                        case 'ppt':
                        case 'pptx':
                            iconName = 'doctype:ppt';
                            break;
                        case 'txt':
                            iconName = 'doctype:txt';
                            break;
                        case 'csv':
                            iconName = 'doctype:csv';
                            break;
                        case 'zip':
                            iconName = 'doctype:zip';
                            break;
                        case 'image':
                        case 'jpg':
                        case 'jpeg':
                        case 'png':
                        case 'gif':
                            iconName = 'doctype:image';
                            break;
                        default:
                            iconName = 'doctype:attachment';
                            break;
                    }

                    return { ...file, iconName };
                });
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    handleUploadFinished(event) {
        this.files = [];
        this.showToast('Success', 'File uploaded successfully', 'success');
        setTimeout(() => {
            this.loadFiles();
        }, 2000); 
    }

    handleViewFile(event) {
        const fileId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: fileId
            }
        });
    }

    handleDeleteFile(event) {
        const fileId = event.currentTarget.dataset.id;
        deleteFile({ contentDocumentId: fileId })
            .then(() => {
                this.showToast('Success', 'File deleted successfully', 'success');
                setTimeout(() => {
                    this.loadFiles();
                }, 2000); 
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(evt);
    }
}
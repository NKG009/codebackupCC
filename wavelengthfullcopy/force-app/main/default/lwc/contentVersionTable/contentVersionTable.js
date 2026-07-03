import { LightningElement, api, wire, track } from 'lwc';
import getContentVersions from '@salesforce/apex/ContentVersionController.getContentVersions';
import deleteContentDocument from '@salesforce/apex/ContentVersionController.deleteContentDocument';
import updateContentVersion from '@salesforce/apex/ContentVersionController.updateContentVersion';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ContentVersionTable extends LightningElement {
    @api recordId;
    @track contentVersions;
    @track error;
    @track draftValues = [];
    @track isModalOpen = false;
    @track contentDocumentIdToDelete = null;
    wiredContentVersionsResult;
    sortedBy;
    sortedDirection = 'asc';

    columns = [
        { label: 'Title', fieldName: 'Title', editable: true, sortable: true },
        { label: 'File size (KB)', fieldName: 'FileSize', sortable: true },
        // { label: 'Owner', fieldName: 'Owner.Name' },
        { label: 'View File', fieldName: 'CA_Image_Url_Link__c', type: 'url' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true  },
        {
            type: 'button',
            typeAttributes: {
                label: 'Delete',
                name: 'delete',
                variant: 'destructive',
                iconName: 'utility:delete',
                iconPosition: 'left',
                dataset: { id: { fieldName: 'ContentDocumentId' } }
            }
        }
    ];

    @wire(getContentVersions, { recordId: '$recordId' })
    wiredContentVersions(result) {
        this.wiredContentVersionsResult = result;
        const { data, error } = result;
        if (data) {
            console.log(data);
            //let filescParsedData = JSON.parse(JSON.stringify(data));
            //this.contentVersions = data;
            this.contentVersions = data.map(record => ({
                ...record,
                FileSize: record.ContentSize ? (record.ContentSize / 1024).toFixed(2)  : 0 // Convert to KB and format
            }));
            //console.log(this.contentVersions);
            //this.error = undefined;
        } else if (error) {
            this.error = result.error;
            this.contentVersions = [];
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        console.log(actionName);
        const row = event.detail.row;
        console.log(row);
        if (actionName === 'delete') {
            //this.handleDelete(row.ContentDocumentId);
            this.contentDocumentIdToDelete = row.ContentDocumentId;
            this.isModalOpen = true;
        }
    }



    handleSort(event) {
        // Capture the field and direction from the event
        const { fieldName: sortedBy } = event.detail;
        const sortDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc'; // Toggle direction
        const cloneData = [...this.contentVersions];

        // Sort the data based on the field and direction
        cloneData.sort((a, b) => {
            let aVal = a[sortedBy];
            let bVal = b[sortedBy];

            // Handle undefined or null values
            aVal = aVal === null || aVal === undefined ? '' : aVal;
            bVal = bVal === null || bVal === undefined ? '' : bVal;

            // Remove commas and check if the field is numeric
            const aIsNumeric = !isNaN(aVal) && !isNaN(parseFloat(aVal));
            const bIsNumeric = !isNaN(bVal) && !isNaN(parseFloat(bVal));

            if (aIsNumeric && bIsNumeric) {
                // Convert to numbers for proper comparison
                aVal = parseFloat(aVal);
                bVal = parseFloat(bVal);
                return sortDirection === 'asc' ? aVal - bVal : bVal - aVal;
            } else {
                // String sorting
                aVal = aVal.toString().toLowerCase();
                bVal = bVal.toString().toLowerCase();
                return sortDirection === 'asc' ? aVal.localeCompare(bVal) : bVal.localeCompare(aVal);
            }
        });

        // Update sorted data, direction, and field
        this.contentVersions = cloneData;
        this.sortedBy = sortedBy;
        this.sortedDirection = sortDirection; // Update the direction
    }

     closeModal() {
        // Close the modal and reset the ID
        this.isModalOpen = false;
        this.contentDocumentIdToDelete = null;
    }

    confirmDelete() {
        // Call handleDelete with the stored ContentDocumentId and close the modal
        this.handleDelete(this.contentDocumentIdToDelete);
        this.closeModal();
    }

    handleDelete(contentDocumentId) {
        console.log('contentDocumentId' + contentDocumentId);
        deleteContentDocument({ contentDocumentId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Content Document deleted successfully.',
                        variant: 'success',
                    })
                );
                return refreshApex(this.wiredContentVersionsResult);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting content',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }

    handleSave(event) {
        console.log(JSON.stringify(event.detail));
        const updatedFields = event.detail.draftValues;

        console.log(updatedFields);

        updateContentVersion({ data: updatedFields })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record updated successfully',
                        variant: 'success',
                    })
                );
                this.draftValues = [];
                return refreshApex(this.wiredContentVersionsResult);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }

   

     handleUploadFinished() {
        // Refresh the content versions list after a successful file upload
        return refreshApex(this.wiredContentVersionsResult)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Files uploaded successfully.',
                        variant: 'success',
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error refreshing content versions',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }
}
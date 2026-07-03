import { LightningElement, wire, track, api } from 'lwc';
import recordDetails from '@salesforce/apex/TombstoneController.getTombstoneData';

export default class AccountTombstone extends LightningElement {
    @track tombstone;
    @track error;
    @track fieldSetFields;
    @track loaded = false;
    @api recordId;
    @api objectApiName;
    @api spotlghtFieldApiName;
    @api highlightFieldUrl;
    @api subHighlightFieldUrl;

    connectedCallback() {
        recordDetails({ objectApiName: this.objectApiName, recordId : this.recordId, spotlghtFieldApiName: this.spotlghtFieldApiName, highlightPhotoUrl: this.highlightFieldUrl, subHighlightPhotoUrl: this.subHighlightFieldUrl })
        .then((data) => {
            console.log(data);

            for (let tombstoneSection of data.tombstoneSections) {
                for (let field of tombstoneSection.fields) {
                    if (field.fieldType == "STRING" || field.fieldType == null) {
                        field.isString = true;
                    } else if (field.fieldType == "DATE") {
                        field.isDate = true;
                    } else if (field.fieldType == "DOUBLE") {
                        field.isDouble = true;
                    }
                }
            }

            this.tombstone = data;
            this.loaded = true;
        })
    }
}
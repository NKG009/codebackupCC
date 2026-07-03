import { LightningElement, track, api } from 'lwc';

export default class InsuranceInvoicePhotos extends LightningElement {
    @api recordId; 
    
 @track replacementCost = 0;
    @track additionalPayment = 0;
    @track deductible = 0;
    @track firstCheck = 0;
    @track totalAcvNotCompleted = 0;
    @track lessDepNotCompleted = 0;
    @track permit = 0;
    @track supplement = 0;

    @track netClaim = 0;
    @track recoverableDep = 0;
    @track rcvLessNonRec = 0;
    @track totalAmountDue = 0;

    @track photoBlocks = [
        { id: 1, filename: '', fileurl: '', isfileuploaded: false }
    ];

    
     photoOptions = [
  { label: 'Overview of property front', value: 'Overview' },
  { label: 'Clear photo of address', value: 'Address' },
    { label: 'Front Elevation', value: 'Front' },
  { label: 'Right Elevation', value: 'Right' },
  { label: 'Rear Elevation', value: 'Rear' },
  { label: 'Left Elevation', value: 'Left' },
    { label: 'Photo of new ridge cap', value: 'RidgeCap' },
  { label: 'Photo of new ventilation', value: 'Ventilation' },
  { label: 'Photo of new plumbing vents (aka bullet boots)', value: 'PlumbingVents' },
  { label: 'New drip edge', value: 'DripEdge' },
    { label: 'Redeck (if applicable)', value: 'Redeck' },
  { label: 'Installation of underlayment over decking', value: 'Underlayment' },
  { label: 'Installation of shingles over underlayment', value: 'Shingles' },
    { label: 'Permit', value: 'Permit' },
  { label: 'First Insurance Check', value: 'InsuranceCheck' },
  { label: 'Proof of Deductible', value: 'DeductibleProof' }
];


    // Handle radio change
    handlePhotoChange(event) {
        const id = parseInt(event.target.dataset.id, 10);
        const value = event.detail.value;
        this.photoBlocks = this.photoBlocks.map(block =>
            block.id === id ? { ...block, filename: value } : block
        );
    }

    // Handle file upload
    handleFileUpload(event) {
        const id = parseInt(event.target.dataset.id, 10);
        const uploadedFiles = event.detail.files;

        if (uploadedFiles && uploadedFiles.length > 0) {
            const file = uploadedFiles[0];
            this.photoBlocks = this.photoBlocks.map(block =>
                block.id === id
                    ? {
                        ...block,
                        isfileuploaded: true,
                        filename: file.name,
                        fileurl: `/sfc/servlet.shepherd/document/download/${file.documentId}`
                    }
                    : block
            );
        }
    }
isLastBlock(id) {
    return id === this.photoBlocks[this.photoBlocks.length - 1].id;
}

    // Add a new photo block dynamically
    handleAddPhotoBlock() {
        const newId = this.photoBlocks.length
            ? Math.max(...this.photoBlocks.map(b => b.id)) + 1
            : 1;
        this.photoBlocks = [
            ...this.photoBlocks,
            { id: newId, filename: '', fileurl: '', isfileuploaded: false }
        ];
    }

     handleChange(event) {
        const label = event.target.label;
        const value = parseFloat(event.target.value) || 0;

        switch(label) {
            case 'Replacement Cost ($)': this.replacementCost = value; break;
            case 'Additional Payment ($)': this.additionalPayment = value; break;
            case 'Deductible ($)': this.deductible = value; break;
            case 'First Check ($)': this.firstCheck = value; break;
            case 'Total ACV of Work Not Completed ($)': this.totalAcvNotCompleted = value; break;
            case 'Less Depreciation Of Work Not Completed ($)': this.lessDepNotCompleted = value; break;
            case 'Permit ($)': this.permit = value; break;
            case 'Supplement ($)': this.supplement = value; break;
            default: break;
        }

        this.calculateTotals();
    }

    // Calculate all totals
    calculateTotals() {
        this.netClaim = (this.firstCheck || 0) + (this.totalAcvNotCompleted || 0);
        this.recoverableDep = (this.replacementCost || 0) - (this.netClaim || 0) - (this.additionalPayment || 0) - (this.deductible || 0);
        this.rcvLessNonRec = (this.recoverableDep || 0) - (this.lessDepNotCompleted || 0);
        this.totalAmountDue = (this.rcvLessNonRec || 0) + (this.permit || 0) + (this.supplement || 0);
    }

    // Remove a photo block
    handleRemovePhotoBlock(event) {
        const id = parseInt(event.target.dataset.id, 10);
        this.photoBlocks = this.photoBlocks.filter(block => block.id !== id);
    }
}
import { LightningElement, track } from 'lwc';

export default class ProjectManagerChecklistForm extends LightningElement {
    @track todayDate = new Date().toISOString().split('T')[0];

    // --------------------------
    // Pre-Installation Checklist
    // --------------------------
    @track preInstallation = {
        notifyHomeowner: false,
        verifyPermits: false,
        reviewMaterials: false,
        meetCrew: false,
        protectProperty: false,
        safetyCheck: false,
        tearOff: false,
        roofDecking: false,
        underlayment: false,
        photosCashJobs: false,
        shingleInstall: false,
        jobSiteClean: false,
        updateHomeowner: false
    };

    handlePreInstallChange(event) {
        const field = event.target.dataset.id;
        this.preInstallation = {
            ...this.preInstallation,
            [field]: event.target.checked
        };
    }

    // --------------------------
    // Material Checklist
    // --------------------------
    @track materials = [
        { name: 'Shingles', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Ridge', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Starter', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Nails', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Plastic Caps', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Underlayment', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Valley', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Drip Edge', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Bullet Boot', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Vent', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Paint', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Sealant', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Misc.', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Decking', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Deck Clips', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Split Boot', amount: false, brand: false, series: false, color: false, size: false, type: false },
        { name: 'Roof Jack', amount: false, brand: false, series: false, color: false, size: false, type: false }
    ];

    handleMaterialChange(event) {
        const index = event.target.dataset.index;
        const field = event.target.dataset.field;
        this.materials[index][field] = event.target.checked;
    }

    // --------------------------
    // Photo Blocks
    // --------------------------
    @track sitePhotoBlocks = [
    { id: 1, filename: '', isfileuploaded: false, fileurl: '' }
];

sitePhotoOptions = [ { label: 'Overview of property front.', value: 'Overview of property front.'}, 
    { label: 'Clear photo of address.', value: 'Clear photo of address.'},
     { label: 'Front Elevation', value: 'Front Elevation' }, 
     { label: 'Right Elevation', value: 'Right Elevation'},
      { label: 'Rear Elevation', value: 'Rear Elevation' }, 
      { label: 'Left Elevation', value: 'Left Elevation'}, 
      { label: 'Photo of new ridge cap.', value: 'Photo of new ridge cap.'},
       { label: 'Photo of new ventilation.', value: 'Photo of new ventilation.'}, 
       { label: 'Photo of new plumbing vents (aka bullet boots).', value: 'Photo of new plumbing vents (aka bullet boots).'},
        { label: 'Redeck (if applicable).', value: 'Redeck (if applicable).'}, 
        { label: 'New drip edge.', value: 'New drip edge.'}, 
        { label: 'Installation of underlayment over decking.', value: 'Installation of underlayment over decking.'}, 
        { label: 'Installation of shingles over underlayment.', value: 'Installation of shingles over underlayment.'}, 
        { label: 'Permit', value: 'Permit', checked: false }, { label: 'First Insurance Check', value: 'First Insurance Check' },
         { label: 'Proof of Deductible', value: 'Proof of Deductible'},
          { label: 'Other', value: 'Other' } 
        ];


addSitePhotoBlock() {
    const newId = this.sitePhotoBlocks.length + 1;
    this.sitePhotoBlocks = [
        ...this.sitePhotoBlocks,
        { id: newId, filename: '', isfileuploaded: false, fileurl: '' }
    ];
}

removeSitePhotoBlock(event) {
    const idToRemove = parseInt(event.currentTarget.dataset.id, 10);
    this.sitePhotoBlocks = this.sitePhotoBlocks.filter(b => b.id !== idToRemove);
}

handleSitePhotoChange(event) {
    const blockId = parseInt(event.target.dataset.id, 10);
    const selectedValue = event.target.value;
    const block = this.sitePhotoBlocks.find(b => b.id === blockId);
    if (block) block.filename = selectedValue;
}

handleSiteFileUpload(event) {
    const blockId = parseInt(event.target.dataset.id, 10);
    const uploadedFiles = event.detail.files;
    if (uploadedFiles.length > 0) {
        const block = this.sitePhotoBlocks.find(b => b.id === blockId);
        if (block) {
            block.isfileuploaded = true;
            block.fileurl = uploadedFiles[0].documentId
                ? `/sfc/servlet.shepherd/version/download/${uploadedFiles[0].documentId}`
                : '';
        }
    }
}


    // --------------------------
    // End of Day
    // --------------------------
    @track endOfDay = {
        inspectProgress: false,
        cleanUp: false,
        customerSatisfied: false,
        atticSafety: false,
        insuranceCheck: false,
        certificate: false,
        photosCashJobs: false
    };

    handleEndOfDayChange(event) {
        const field = event.target.dataset.id;
        this.endOfDay = {
            ...this.endOfDay,
            [field]: event.target.checked
        };
    }

    @track multiDayEndOfDay = {
        inspectProgress: false,
        cleanUp: false,
        customerSatisfied: false,
        atticSafety: false,
        insuranceCheck: false,
        certificate: false,
        crewStartNextDay: false,
        consultCrewEquipment: false,
        informHomeownerStartTime: false,
        confirmEquipmentOvernight: false,
        confirmCleanupOvernight: false,
        referDayOneProtocol: false
    };

    handleMultiDayEndOfDayChange(event) {
        const field = event.target.dataset.id;
        this.multiDayEndOfDay = {
            ...this.multiDayEndOfDay,
            [field]: event.target.checked
        };
    }

    @track docPhoto = {
    type: 'Permit',
    filename: '',
    fileurl: '',
    isfileuploaded: false
};

docPhotoOptions = [
    { label: 'Permit', value: 'Permit' },
    { label: 'Receipt Of Permit', value: 'Receipt Of Permit' },
    { label: 'Other', value: 'Other' }
];

handleDocTypeChange(event) {
    this.docPhoto.type = event.detail.value;
}

handleDocFileUpload(event) {
    const uploadedFiles = event.detail.files;
    if (uploadedFiles.length > 0) {
        this.docPhoto.fileurl = uploadedFiles[0].documentId;
        this.docPhoto.isfileuploaded = true;
    }
}


    
    handleSave() {
        console.log('Checklist saved:', {
            preInstallation: this.preInstallation,
            materials: this.materials,
            photoBlocks: this.photoBlocks,
            endOfDay: this.endOfDay,
            multiDayEndOfDay: this.multiDayEndOfDay
        });
    }

    handleReset() {
        // Reset preInstallation
        Object.keys(this.preInstallation).forEach(key => {
            this.preInstallation[key] = false;
        });

        // Reset materials
        this.materials = this.materials.map(mat => ({
            ...mat,
            amount: false,
            brand: false,
            series: false,
            color: false,
            size: false,
            type: false
        }));

        // Reset photo blocks
        this.photoBlocks = this.photoBlocks.map(block => ({
            ...block,
            filename: '',
            isfileuploaded: false,
            fileurl: ''
        }));

        // Reset end of day
        Object.keys(this.endOfDay).forEach(key => {
            this.endOfDay[key] = false;
        });

        // Reset multi-day end of day
        Object.keys(this.multiDayEndOfDay).forEach(key => {
            this.multiDayEndOfDay[key] = false;
        });

        // Reset photo options
        this.photoOptions = this.photoOptions.map(option => ({
            ...option,
            checked: false
        }));
    }
}
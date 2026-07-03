import { LightningElement, track, api } from 'lwc';

export default class RoofingForm extends LightningElement {
     @track repFirstName = '';
    @track repLastName = '';
    @track selectedManufacturer = '';
    @track selectedSeries = '';
    @track selectedColor = '';

    @track seriesOptions = [];
    @track colorOptions = [];
        @track otherColor = ''; 
        @track selectedDripEdge = '';
@track dripEdgeColor = '';
@track selectedColor = '';
@track selectedPlumbingVent = '';
@track selectedValley = '';
@track valleyColor = '';
@track isValleyColorVisible = false;
@track selectedVentilation = '';
@track ventilationColor = '';
@track acvTotal = 0; 

colorOptions = [
            { label: 'Weathered Wood', value: 'Weathered Wood' },
    { label: 'White', value: 'White' },
    { label: 'Black', value: 'Black' },
    { label: 'Brown', value: 'Brown' },
    { label: 'Almond', value: 'Almond' },
    { label: 'Milk', value: 'Milk' },
        { label: 'Gray', value: 'Gray' }
];


    today = new Date().toISOString().split('T')[0];
    @track secondaryRCVs = [{ id: 1, value: 0, isLast: true }];
    @track lnrPerInsurance = [{ id: 1, value: 0, isLast: true }];
    @track lnrWorkNotCompleted = [{ id: 1, value: 0, isLast: true }];
    @track acvWorkNotCompleted = [{ id: 1, value: 0, isLast: true }];
    @track additionalWork = [{ id: 1, value: '', isLast: true }];
    @track secondaryStructureACV = [{ id: 1, value: 0, isLast: true }];


    // Calculated totals
    @track rcvWithSecondary = 0;
    @track rcvLessLnr = 0;
    @track acvTotal = 0;
    @track additionalWorkTotal = 0;
        @track deductibleOwed = 0; 
        @track deductible = 0;
@track firstCheck = 0;
@track secondCheck = 0;
@track rcvTax = 0;
@track customerTotal = 0;
@track totalToBeCollected = 0;
@track recoverableDepMain = 0;
@track recoverableDepSecondary = 0;
@track permit = 0;
@track lnrTotal = 0;
@track mainDwellingACVCheck = 0;
@track secondaryStructureACVCheck = 0;


    nextId = 2;

    addField(event) {
        const fieldName = event.target.dataset.field;
        this[fieldName].forEach(item => item.isLast = false);
        this[fieldName] = [...this[fieldName], { id: this.nextId++, value: '', isLast: true }];
    }

  handleChange(event) {
    const fieldName = event.target.dataset.field;
    const value = event.target.type === 'number' ? parseFloat(event.target.value) || 0 : event.target.value;

    if (Array.isArray(this[fieldName])) {
        const id = parseInt(event.target.dataset.id, 10);
        this[fieldName] = this[fieldName].map(item =>
            item.id === id ? { ...item, value } : item
        );
    } else {
        this[fieldName] = value;
    }

    this.recalculateTotals();
}
handleInputChange(event) {
    const field = event.target.dataset.field;
    this[field] = event.target.value;
    this.recalculateTotals();
}

handleDeductibleChange(event) {
    this.deductible = parseFloat(event.target.value) || 0;
    this.recalculateTotals();
}
    handleRcvChange(event) {
        this.rcvTax = parseFloat(event.target.value) || 0;
        this.recalculateTotals();
    }

recalculateTotals() {
    const secSum = this.secondaryRCVs.reduce((sum, item) => sum + (parseFloat(item.value) || 0), 0);
    this.rcvWithSecondary = (this.rcvTax + secSum).toFixed(2);

    this.secondaryStructureACVCheck = this.secondaryStructureACV.reduce(
        (sum, item) => sum + (parseFloat(item.value) || 0), 0
    ).toFixed(2);

    const lnr1 = this.lnrPerInsurance.reduce((sum, item) => sum + (parseFloat(item.value) || 0), 0);
    const lnr2 = this.lnrWorkNotCompleted.reduce((sum, item) => sum + (parseFloat(item.value) || 0), 0);
    this.lnrTotal = (lnr1 + lnr2).toFixed(2);

    this.rcvLessLnr = (parseFloat(this.rcvWithSecondary) - parseFloat(this.lnrTotal)).toFixed(2);

    this.acvTotal = this.acvWorkNotCompleted.reduce((sum, item) => sum + (parseFloat(item.value) || 0), 0).toFixed(2);
    this.totalRecDepWNC = (parseFloat(this.lnrTotal) || 0).toFixed(2);

    this.additionalWorkTotal = this.additionalWork.reduce((sum, item) => {
        const val = parseFloat(item.value);
        return sum + (isNaN(val) ? 0 : val);
    }, 0).toFixed(2);

    this.deductibleOwed = ((parseFloat(this.deductible) || 0) - parseFloat(this.acvTotal)).toFixed(2);

    this.totalRec = (
        (parseFloat(this.deductible) || 0) +
        (parseFloat(this.mainDwellingACVCheck) || 0) +
        (parseFloat(this.recoverableDepMain) || 0) +
        (parseFloat(this.secondaryStructureACVCheck) || 0) +
        (parseFloat(this.additionalWorkTotal) || 0) +
        (parseFloat(this.permit) || 0)
    ).toFixed(2);

    this.customerTotal = (parseFloat(this.totalRec) - parseFloat(this.acvTotal) - parseFloat(this.totalRecDepWNC)).toFixed(2);

    this.secondCheck = (
        (parseFloat(this.recoverableDepMain) || 0) +
        (parseFloat(this.recoverableDepSecondary) || 0) +
        (parseFloat(this.permit) || 0) -
        (parseFloat(this.lnrTotal) || 0)
    ).toFixed(2);

    this.firstCheck = (
        (parseFloat(this.mainDwellingACVCheck) || 0) +
        (parseFloat(this.secondaryStructureACVCheck) || 0) -
        (parseFloat(this.acvTotal) || 0)
    ).toFixed(2);

    const first = Number(this.firstCheck) || 0;
    const second = Number(this.secondCheck) || 0;
    const deductible = Number(this.deductible) || 0;
    const additionalWork = Number(this.additionalWorkTotal) || 0;

    this.totalToBeCollected = (first + second + deductible + additionalWork).toFixed(2);
}

 
    // ✅ Manufacturer Options
    manufacturerOptions = [
        { label: 'CertainTeed', value: 'CertainTeed' },
        { label: 'Malarkey', value: 'Malarkey' },
        { label: 'Owens Corning', value: 'Owens Corning' }
    ];

    // ✅ Manufacturer → Series Mapping
    manufacturerSeriesMap = {
        'CertainTeed': [
            { label: 'Landmark', value: 'Landmark' },
            { label: 'Landmark Pro', value: 'Landmark Pro' },
            { label: 'Landmark Climate Flex', value: 'Landmark Climate Flex' },
            { label: 'Highland Slate', value: 'Highland Slate' },
            { label: 'Presidential Shake (TL)', value: 'Presidential Shake (TL)' },
            { label: 'Grand Manor', value: 'Grand Manor' },
            { label: 'Carriage House', value: 'Carriage House' },
            { label: 'XT-25 (3-tab)', value: 'XT-25 (3-tab)' }
        ],
        'Malarkey': [
            { label: 'Vista', value: 'Vista' },
            { label: 'Legacy', value: 'Legacy' },
             { label: 'Highlander', value: 'Highlander' },
            { label: 'Windsor', value: 'Windsor' },
             { label: 'Ecoasis', value: 'Ecoasis' }
        ],
        'Owens Corning': [
            { label: 'Duration', value: 'Duration' },
            { label: 'Duration Designer', value: 'Duration Designer' },
             { label: 'True Definition Duration Flex', value: 'True Definition Duration Flex' },
            { label: 'Oakridge', value: 'Oakridge' },
             { label: 'Berkshire', value: 'Berkshire' }
        ]
    };

    // ✅ Manufacturer+Series → Color Mapping
    manufacturerColorMap = {
        'CertainTeed': [
            { label: 'Weathered Wood', value: 'Weathered Wood' },
                        { label: 'Moire Black', value: 'Moire Black' },

            { label: 'Georgetown Gray', value: 'Georgetown Gray' },
            { label: 'Colonial Slate', value: 'Colonial Slate' },
            { label: 'Cobbelstone Gray', value: 'Cobbelstone Gray' },
            { label: 'Silver Birch', value: 'Silver Birch' },
            { label: 'Resawn Shake', value: 'Resawn Shake' },
            { label: 'Burnt Sienna', value: 'Burnt Sienna' },
            { label: 'Heather Blend', value: 'Heather Blend' }
        ],
        'Malarkey': [
            { label: 'Weathered Wood', value: 'Weathered Wood' },
            { label: 'Midnight Black', value: 'Midnight Black' },
            { label: 'Storm Gray', value: 'Storm Gray' },
             { label: 'Antique Brown', value: 'Antique Brown' },
            { label: 'Black Oak', value: 'Black Oak' },
             { label: 'Natural Wood', value: 'Natural Wood' },
            { label: 'Rainforest', value: 'Rainforest' },
            { label: 'Heather', value: 'Heather' },
             { label: 'Sienna Blend', value: 'Sienna Blend' },
            { label: 'Silver Wood', value: 'Silver Wood' }
        ],
        'Owens Corning': [
            { label: 'Driftwood', value: 'Driftwood' },
            { label: 'Onyx Black', value: 'Onyx Black' },
             { label: 'Estate Gray', value: 'Estate Gray' },
            { label: 'Brown Wood', value: 'Brown Wood' },
             { label: 'Colonial Slate', value: 'Colonial Slate' },
            { label: 'Teak', value: 'Teak' },
            { label: 'Desert Rose', value: 'Desert Rose' },
             { label: 'Williamsburg Gray', value: 'Williamsburg Gray' },
            { label: 'Aged Copper', value: 'Aged Copper' },
             { label: 'Black Sable', value: 'Black Sable' },
            { label: 'Bourbon', value: 'Bourbon' },
             { label: 'Merlot', value: 'Merlot' },
            { label: 'Storm Cloud', value: 'Storm Cloud' },
                        { label: 'Summer Harvest', value: 'Summer Harvest' }

        ]
    };

    // --- Event Handlers ---
   handleManufacturerChange(event) {
        this.selectedManufacturer = event.detail.value;

        // ✅ Populate Series
        this.seriesOptions = this.manufacturerSeriesMap[this.selectedManufacturer] || [];
        this.selectedSeries = '';

        // ✅ Populate Colors
        this.colorOptions = [
            ...(this.manufacturerColorMap[this.selectedManufacturer] || []),
            { label: 'Other', value: 'Other' } // always include "Other"
        ];
        this.selectedColor = '';
        this.otherColor = '';
    }

    handleSeriesChange(event) {
                this.selectedSeries = event.detail.value; // only store value, no color reset

    }

     handleColorChange(event) {
        this.selectedColor = event.detail.value;
        if (this.selectedColor !== 'Other') {
            this.otherColor = '';
        }
    }

    handleOtherColorChange(event) {
        this.otherColor = event.detail.value;
    }


    get isSeriesDisabled() {
        return this.selectedManufacturer === '';
    }

    get isColorDisabled() {
        return this.selectedManufacturer === '';
    }

    get isOtherColorSelected() {
        return this.selectedColor === 'Other';
    }
    initialWarrantyOptions = [
        { label: 'SureStart"/ 10 years non-prorated', value: '"SureStart"/ 10 years non-prorated' },
        { label: 'SureStart"/ 5 years non-prorated', value: '"SureStart"/ 5 years non-prorated' }
    ];
    fullWarrantyOptions = [
        { label: 'Lifetime Limited', value: 'Lifetime Limited'},
        { label: '25 Years', value: 'Georgetown Gray' }
    ];
    deckingOptions = [
        { label: 'Replace upto two pieces.Additional at $65 each with client approval.', values: 'Replace upto two pieces.Additional at $65 each with client approval.'},
        { label: '7/16" OSB', value: '7/16" OSB'},
        { label: '5/18" OSB', value: '5/18" OSB'},
        { label: '7/16" Radiant Barrier',value: '7/16" Radiant Barrier'},
        { label: '5/8" Radiant Barrier', value: '5/8" Radiant Barrier'}
    ];
    underlaymentOptions = [
        { label: 'TriBuilt Synthetic', value:'TriBuilt Synthetic'},
        { label: 'RoofRunner Synthetic', value:'RoofRunner Synthetic'},
        { label: 'DiamondDeck Synthetic', value:'DiamondDeck Synthetic'}
    ];
    dripEdgeOptions=[
        { label: 'Reuse due to gutter coverage.',value: 'Reuse due to gutter coverage'},
        { label: '2"*2" Aluminium', value: '2"*2" Aluminium'}
    ];

handleDripEdgeChange(event) {
    this.selectedDripEdge = event.detail.value;
    // reset color if user changes selection
    if (this.selectedDripEdge !== '2"*2" Aluminium') {
        this.dripEdgeColor = '';
    }
}

handleDripEdgeColorChange(event) {
    this.dripEdgeColor = event.detail.value;
}

// ✅ Show color picklist only when 2*2 Aluminium is selected
get isDripEdgeColorVisible() {
    return this.selectedDripEdge === '2"*2" Aluminium';
}
get dripEdgeClass() {
    // If 2*2 Aluminium selected, use half width, else full width
    return this.selectedDripEdge === '2"*2" Aluminium'
        ? 'slds-col slds-size_1-of-2'
        : 'slds-col slds-size_1-of-1';
}
    fastenerOptions=[
        { label: '1-1/4" Galvanized Coil Nails', value:'1-1/4" Galvanized Coil Nails'},
        { label: '1-1/2" Galvanized Coil Nails', value: '1-1/2" Galvanized Coil Nails'},
        { label: '7/8" Galvanized Coil Nails', value: '7/8" Galvanized Coil Nails'},
        {label: '2-1/2" Decking Nails', value:'2-1/2" Decking Nails'},
        {Label: 'Hand Nails', value: 'Hand Nails'},
        {label: 'Screws for Decking', value:'Screws for Decking'}
    ];
    ventilationOptions=[
        { label: 'Roof Louvers/ Box Vents', value:'Roof Louvers/ Box Vents'},
        { label: 'Static Domes', value:'Static Domes'},
        { label: 'Dryer Vent', value:'Dryer Vent'},
         { label: 'TriBuilt Ridge Vent', value:'TriBuilt Ridge Vent'},
        { label: 'Power Vent TOP ONLY', value:'Power Vent TOP ONLY'},
        { label: 'Power Vent WITH MOTOR', value:'Power Vent WITH MOTOR'},
        { label: 'Solar Power Vent', value:'Solar Power Vent'},
        { label: 'Turbine 12" Externally Braced', value:'Turbine 12" Externally Braced'},
        { label: 'Turbine 14" Externally Braced', value:'Turbine 14" Externally Braced'},
        { label: 'Turbine 12" Internally Braced', value:'Turbine 12" Internally Braced'},
        { label: 'Turbine 14" Internally Braced', value:'Turbine 14" Internally Braced'}
    ];
    handleVentilationChange(event) {
    this.selectedVentilation = event.detail.value;
}

handleVentilationColorChange(event) {
    this.ventilationColor = event.detail.value;
}
    valleyOptions=[
        { label: 'Self-adhesive Ice & Water Shield', value:'Self-adhesive Ice & Water Shield'},
        { label: '"W" metal', value:'"W" metal'}
        ];
        get valleyClass() {
    return this.isValleyColorVisible ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_1-of-1';
}

handleValleyChange(event) {
    this.selectedValley = event.detail.value;
    this.isValleyColorVisible = this.selectedValley === '"W" metal';
    if (!this.isValleyColorVisible) {
        this.valleyColor = ''; // reset color if not needed
    }
}

handleValleyColorChange(event) {
    this.valleyColor = event.detail.value;
}
    ridgeOptions=[
        { label: 'XT-25 (3-Tab)', value:'XT-25 (3-Tab)'},
        { label: 'RapidRidge', value:'RapidRidge'},
        { label: 'CedarCrest', value:'CedarCrest'},
         { label: 'ShangleRidge ', value:'ShangleRidge'},
        { label: 'MountainRidge ', value:'MountainRidge'},
        { label: 'ShadowRidge ', value: 'ShadowRidge'}
    ];
    plumbingVentOptions=[
        { label: 'Bullet Boot', value:'Bullet Boot'},
        { label: '3-in-1', value:'3-in-1'},
        { label: 'Lead Jack', value:'Lead Jack'}
    ];
    handleColorChange(event) {
    this.selectedColor = event.detail.value;
}

handlePlumbingVentChange(event) {
    this.selectedPlumbingVent = event.detail.value;
}

    hvacOptions=[
         { label: 'Replace CAP ONLY/Paint cap and stack to match roof color.', value:'TriBuilt Synthetic'},
        { label: 'Versa Cap 3050 (3"-5")', value:'Versa Cap 3050 (3"-5")'},
        { label: 'Versa Cap 5070 (5"-7")', value:'Versa Cap 5070 (5"-7")'},
        { label: 'Versa Cap 7090 (7"-9")', value:'Versa Cap 7090 (7"-9")'}

    ];
     flashingOptions = [
        { label: 'Replace as NEEDED/Paint to match roof color', value: 'Replace as NEEDED/Paint to match roof color' },
        { label: 'Step Flashing 4"*4"*8"', value: 'Step Flashing 4"*4"*8"' },
        { label: '20"*50"', value: '20"*50"'}
    ];
roofTypeOptions = [
        { label: 'Architectural', value: 'Architectural' },
        { label: 'Other', value: 'Other' }
    ];

   @track selectedRoofType;
@track isOtherRoofType = false;
@track otherRoofType = '';

   handleRoofTypeChange(event) {
        this.selectedRoofType = event.detail.value;
        this.isOtherRoofType = this.selectedRoofType === 'Other';
        if (!this.isOtherRoofType) {
            this.otherRoofType = '';
        }
    }

    handleOtherRoofTypeChange(event) {
        this.otherRoofType = event.detail.value;
    }

    // Getter for combobox div class
    get roofTypeClass() {
        return this.isOtherRoofType ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_1-of-1';
    }

    // Getter for “Other” input div class
    get otherRoofTypeClass() {
        return 'slds-col slds-size_1-of-2';
    }

    // Combined display text
    get roofTypeDisplay() {
        return this.isOtherRoofType && this.otherRoofType
            ? `Other: ${this.otherRoofType}`
            : this.selectedRoofType;
    }
    @track selectedLayer = '';
    @track otherLayer = '';
    @track isOtherLayer = false;
    layerOptions = [
        { label: '1', value: '1' },
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: '4', value: '4' },
        { label: 'Other', value: 'Other' }
    ];

    handleLayerChange(event) {
        this.selectedLayer = event.detail.value;
        this.isOtherLayer = this.selectedLayer === 'Other';
        if (!this.isOtherLayer) this.otherLayer = '';
    }

    handleOtherLayerChange(event) {
        this.otherLayer = event.detail.value;
    }

    get layerClass() {
        return this.isOtherLayer ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_1-of-1';
    }

    get otherLayerClass() {
        return 'slds-col slds-size_1-of-2';
    }

    get layerDisplay() {
        return this.isOtherLayer && this.otherLayer
            ? `Other: ${this.otherLayer}`
            : this.selectedLayer;
    }

handleRepFirstNameChange(event) {
    this.repFirstName = event.target.value;
}

handleRepLastNameChange(event) {
    this.repLastName = event.target.value;
}

  
    stateOptions = [
        { label: 'Texas', value: 'TX' },
        { label: 'New York', value: 'New York' },
        { label: 'Los Angeles', value: 'Los Angeles' }
    ];

@track selectedPitch = '';
    @track otherPitch = '';
    @track isOtherPitch = false;
    pitchOptions = [
        { label: '0-2', value: '0-2' },
        { label: '2-4', value: '2-4' },
        { label: '4-7', value: '4-7' },
        { label: '7-9', value: '7-9' },
        { label: '9-12', value: '9-12' },
        { label: 'Other', value: 'Other' }
    ];

    handlePitchChange(event) {
        this.selectedPitch = event.detail.value;
        this.isOtherPitch = this.selectedPitch === 'Other';
        if (!this.isOtherPitch) this.otherPitch = '';
    }

    handleOtherPitchChange(event) {
        this.otherPitch = event.detail.value;
    }

    get pitchClass() {
        return this.isOtherPitch ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_1-of-1';
    }

    get otherPitchClass() {
        return 'slds-col slds-size_1-of-2';
    }

    get pitchDisplay() {
        return this.isOtherPitch && this.otherPitch
            ? `Other: ${this.otherPitch}`
            : this.selectedPitch;
    }
     @track selectedStory = '';
    @track otherStory = '';
    @track isOtherStory = false;
    storyOptions = [
        { label: '1', value: '1' },
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: 'Other', value: 'Other' }
    ];

    handleStoryChange(event) {
        this.selectedStory = event.detail.value;
        this.isOtherStory = this.selectedStory === 'Other';
        if (!this.isOtherStory) this.otherStory = '';
    }

    handleOtherStoryChange(event) {
        this.otherStory = event.detail.value;
    }

    get storyClass() {
        return this.isOtherStory ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_1-of-1';
    }

    get otherStoryClass() {
        return 'slds-col slds-size_1-of-2';
    }

    get storyDisplay() {
        return this.isOtherStory && this.otherStory
            ? `Other: ${this.otherStory}`
            : this.selectedStory;
    }

// --- Additional Work ---
additionalWorkOptions = [
    { label: 'Gutter', value: 'Gutter' },
    { label: 'Fence', value: 'Fence' },
    { label: 'Screens', value: 'Screens' },
    { label: 'Windows', value: 'Windows' },
    { label: 'Beading', value: 'Beading' },
    { label: 'Cap', value: 'Cap' },
    { label: 'AC', value: 'AC' },
    { label: 'Paint', value: 'Paint' },
    { label: 'Colors in Notes', value: 'Fencing' }
];

@track selectedAdditionalWork = [];

handleAdditionalWorkChange(event) {
    this.selectedAdditionalWork = event.detail.value;
}



/*@api label = 'Additional Work';

    @track options = [
        { label: 'Gutter', value: 'Gutter', selected: false },
        { label: 'Fence', value: 'Fence', selected: false },
        { label: 'Screens', value: 'Screens', selected: false },
        { label: 'Windows', value: 'Windows', selected: false },
        { label: 'Beading', value: 'Beading', selected: false },
        { label: 'Cap', value: 'Cap', selected: false },
        { label: 'AC', value: 'AC', selected: false },
        { label: 'Paint', value: 'Paint', selected: false },
        { label: 'Colors in Notes', value: 'Colors in Notes', selected: false }
    ];

    @track selectedValues = [];
    @track isDropdownOpen = false;

    get dropdownClass() {
        return `slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ${this.isDropdownOpen ? 'slds-is-open' : ''}`;
    }

    get selectedValuesLabel() {
        return this.selectedValues.length > 0 ? this.selectedValues.join(', ') : 'Select options';
    }
    get chevronIcon() {
    return this.isDropdownOpen ? "utility:chevronup" : "utility:chevrondown";
}



    toggleDropdown() {
        this.isDropdownOpen = !this.isDropdownOpen;
    }

    handleSelection(event) {
        const value = event.target.dataset.value;
        const checked = event.target.checked;

        this.options = this.options.map(opt => {
            if (opt.value === value) {
                opt.selected = checked;
            }
            return opt;
        });

        this.selectedValues = this.options.filter(opt => opt.selected).map(opt => opt.value);

        // fire event to parent if needed
        const selectionEvent = new CustomEvent('change', {
            detail: { value: this.selectedValues }
        });
        this.dispatchEvent(selectionEvent);
    }*/



    handleSave() {
        // collect values and save to server (Apex or LDS)
        console.log('Form saved!');
    }

    handleReview() {
        // preview entered values before submission
        console.log('Reviewing answers...');
    }
}
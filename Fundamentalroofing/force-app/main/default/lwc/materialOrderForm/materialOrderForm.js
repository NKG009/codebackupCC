import { LightningElement, track } from 'lwc';

export default class RepairQuote extends LightningElement {
    @track formData = {};
    recordId;


    connectedCallback() {
        for (let i = 1; i <= 20; i++) {
            this.bundleOptions.push({ label: `${i} bundle${i > 1 ? 's' : ''}`, value: `${i}` });
        }
        for (let i = 16; i <= 120; i++) {
            this.quantityOptions.push({ label: `${i} squares`, value: i });
        }
        
    }

    // ----------------- Manufacturer / Series / Color -----------------
    @track selectedManufacturer = '';
    @track selectedSeries = '';
    @track selectedColor = '';
    @track otherColor = '';
    @track seriesOptions = [];
    @track colorOptions = [];

    get isOtherColorSelected() {
        return this.selectedColor === 'Other';
    }
    

    // ----------------- Valley -----------------
    @track selectedValley = '';
    @track selectedValleyQty = null;
    @track selectedValleyRoll = '';
    @track valleyOptions = [
        { label: 'Self-adhesive Ice & Water Shield (60 LF)', value: 'Self-adhesive' },
        { label: '"W" metal Valley (60 LF)', value: 'metal Valley' }   
    ];
    @track valleyRollOptions = [];
    generateValleyRollOptions() {
    let options = [];
    for (let i = 1; i <= 20; i++) {
        options.push({ 
            label: `${i} Roll${i > 1 ? 's' : ''}`, 
            value: `${i}` 
        });
    }
    this.valleyRollOptions = options;
}
    
    handleValleyChange(event) { this.selectedValley = event.detail.value; }
    handleValleyQtyChange(event) { this.selectedValleyQty = Number(event.detail.value); }
    handleValleyRollChange(event) { this.selectedValleyRoll = event.detail.value; }
   @track valleyHelpTextMap = {
    'Self-adhesive': 
        '• Standard roll: 1 roll = 36" wide × 66.7 ft long.\n' +
        '• Usually used for valleys, eaves, penetrations.',

    'metal Valley': 
        '• 1 roll = 20" x 50 linear feet.\n' +
        '• Sold individually.'
};

get valleyHelpText() {
    return this.valleyHelpTextMap[this.selectedValley] || '';
}



    // ----------------- Starter -----------------
    @track starterOptions = [
        { label: 'TribuiltStarter(100 LF)', value: 'TribuiltStarter' },
        { label: 'SwiftStartStarter(100 LF)', value: 'SwiftStartStarter' },
        { label: 'High-PerformanceStarter(100 LF)', value: 'High-PerformanceStarter' },
        { label: 'PresidentialStarter(100 LF)', value: 'PresidentialStarter' },
        { label: 'Private Label(100 LF)', value: 'Private Label' }
    ];

    // ----------------- Bundles & Quantities -----------------
    @track bundleOptions = [];
    @track quantityOptions = [];
    @track selectedQuantity;

    // ----------------- Ridge Rows -----------------
    @track ridgeCapRows = [
    { id: Date.now(), selectedRidgeCap: '', quantity: '', color: '', bundle: '', helpText: '' }
];

ridgeOptions = [
    { label: 'RapidRidge High Profile (20 LF)', value: 'rapidRidge_High_Profile' },
    { label: 'Credar Crest Mid Profile (20 LF)', value: 'credar_Crest_Mid_Profile' },
    { label: 'XT25 (33 LF)', value: 'xT25' },
    { label: 'Shadow Ridge Mid Profile (30 LF)', value: 'shadow_Ridge_Mid_Profile' },
    { label: 'Shangle Ridge (30 LF)', value: 'shangle_Ridge' }
];

ridgeColorOptions = [
    { label: 'Shingle Match', value: 'shingle_Match' }
];

// Help text map
ridgeHelpTextMap = {
    'rapidRidge_High_Profile': 
        '• High-profile ridge (Rapid Ridge): 1 bundle = 20 linear ft.' +
        '• Calculate: all hips + ridges ÷ 20 LF = bundles needed.' +
        '• Only on high profile add two bundles to your calculation after you get your total' +
        '• For non-standard hip/ridge, check with supply house before ordering.',

    'xT25': 
        '• Low-Profile ridge cap (3-tab): 1 bundle = 33 linear ft.',

    'shangle_Ridge': 
              '• Low-Profile ridge cap (3-tab): 1 bundle = 33 linear ft.',

};

// Handler
handleRidgeCapChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.ridgeCapRows.find(r => r.id == rowId);
    if (row) {
        row.selectedRidgeCap = event.detail.value;
        row.helpText = this.ridgeHelpTextMap[row.selectedRidgeCap] || '';
    }
}

handleRidgeQuantityChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.ridgeCapRows.find(r => r.id == rowId);
    if (row) row.quantity = Number(event.detail.value);
}

handleRidgeColorChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.ridgeCapRows.find(r => r.id == rowId);
    if (row) row.color = event.detail.value;
}

// Add new row
handleAddRidgeCap() {
    this.ridgeCapRows = [
        ...this.ridgeCapRows,
        { id: Date.now(), selectedRidgeCap: '', quantity: '', color: '', bundle: '', helpText: '' }
    ];
}



    // ----------------- Shingle Rows -----------------
    @track shingleRows = [
        { id: 1, starterName: '', quantity: '', bundle: '' }
    ];

    // ----------------- Manufacturer Options -----------------
    manufacturerOptions = [
        { label: 'CertainTeed', value: 'CertainTeed' },
        { label: 'Malarkey', value: 'Malarkey' },
        { label: 'Owens Corning', value: 'Owens Corning' }
    ];

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

    // ----------------- Underlayment -----------------
    @track selectedUnderlayment = '';
    @track selectedUnderlaymentQty = null;
    @track selectedUnderlaymentRoll = '';
    @track underlaymentOptions = [
        { label: 'Tribuilt Synthetic(10 squares per roll)', value: 'tribuiltSynthetic' },
        { label: 'Synthetic Underlayment(10 squares per roll)', value: 'syntheticUnderlayment' },
         { label: 'DiamondDeck Synthetic Underlayment(10 squares per roll)', value: 'diamondSynthetic' },
        { label: 'RoofRunner Synthetic Underlayment(10 squares per roll)', value: 'roofRunner' }
    ];
    @track underlaymentRollOptions = Array.from({ length: 20 }, (_, i) => {
    const roll = i + 1;
    return { 
        label: `${roll} Roll${roll > 1 ? 's' : ''}`, 
        value: `${roll}` 
    };
});

    handleUnderlaymentChange(event) { this.selectedUnderlayment = event.detail.value; }
    handleUnderlaymentQtyChange(event) { this.selectedUnderlaymentQty = Number(event.detail.value); }
    handleUnderlaymentRollChange(event) { this.selectedUnderlaymentRoll = event.detail.value; }


@track selectedVentilationType = '';
    @track selectedVentilationSize = '';
    @track selectedVentilationColor = '';

@track ventilationRows = [this.createNewRow()];

    createNewRow() {
        return {
            id: Date.now(),
            type: '',
            quantity: null,
            inches: null,
            color: null,
            brace: null,
            showColor: false,
            isDryerVent: false,
            showBrace: false,
            showQuantity: true,
            helpText: ''
        };
    }

    ventilationTypeOptions = [
        { label: 'Slant Backs', value: 'slantBacks' },
        { label: 'Static Domes', value: 'staticDomes' },
        { label: 'Dryer Vents', value: 'dryerVents' },
        { label: 'Ridge Vent (4ft sections)', value: 'ridgeVent' },
        { label: 'Power Vent COVER ONLY', value: 'powerVentCover' },
        { label: 'Power Vent WITH MOTOR', value: 'powerVentMotor' },
        { label: 'Solar power vents', value: 'solarPowerVents' },
        { label: 'Turbine', value: 'turbine' },
        { label: 'Eave Vent', value: 'eaveVent' }
    ];

    ventilationColorOptions = [
        { label: 'Weathered Wood', value: 'Weathered Wood' },
        { label: 'Black', value: 'Black' },
        { label: 'Brown', value: 'Brown' },
        { label: 'White', value: 'White' },
        { label: 'Mill', value: 'Mill' }
    ];

    ventilationSizeOptions = [
        { label: '4"', value: '4' },
        { label: '6"', value: '6' }
    ];

    braceOptions = [
        { label: '12" Internally Braced', value: '12" Internally Braced' },
        { label: '14" Internally Braced', value: '14" Internally Braced' },
        { label: '12" Externally Braced', value: '12" Externally Braced' },
        { label: '14" Externally Braced', value: '14" Externally Braced' }
    ];

    ventHelpMap = {
        slantBacks: '• One size',
        staticDomes: '• 1 size',
        dryerVents: '• 2 sizes (most common is 4”).\n• A vent with a damper is required when lint is present and the metal screen must be removed.',
        ridgeVent: '• Shingle-over vent: 1 piece = 4 linear ft. Available in both 9” and 12”.',
        powerVentCover: '• Only utilized in the event that the existing power vent cover has 3 bolts.',
        powerVentMotor: '• Order correct color.\n• Check with crew before rewiring unit.',
        turbine: '• 2 sizes and 2 configurations exist; most common is 12” externally braced.',
        eaveVent: '• Only used when no soffit vents or gable end vents are present.'
    };

    handleVentilationChange(event) {
        const rowId = event.target.dataset.id;
        const fieldName = event.target.name;
        const value = event.detail.value;

        this.ventilationRows = this.ventilationRows.map(row => {
            if (row.id == rowId) {
                const updatedRow = { ...row };

                if (fieldName === 'type') {
                    updatedRow.type = value;

                    updatedRow.showColor = ['slantBacks','staticDomes','powerVentCover','powerVentMotor','solarPowerVents','turbine'].includes(value);
                    updatedRow.isDryerVent = value === 'dryerVents';
                    updatedRow.showBrace = value === 'turbine';
                    updatedRow.showQuantity = !(updatedRow.isDryerVent || value === 'turbine');

                    updatedRow.helpText = this.ventHelpMap[value] || '';

                    if (!updatedRow.isDryerVent) updatedRow.inches = null;
                    if (updatedRow.isDryerVent) updatedRow.quantity = null;
                    if (!updatedRow.showColor) updatedRow.color = null;
                    if (!updatedRow.showBrace) updatedRow.brace = null;

                } else if (fieldName === 'quantity') {
                    updatedRow.quantity = value;
                } else if (fieldName === 'inches') {
                    updatedRow.inches = value;
                } else if (fieldName === 'color') {
                    updatedRow.color = value;
                } else if (fieldName === 'brace') {
                    updatedRow.brace = value;
                }

                return updatedRow;
            }
            return row;
        });

        // force reactivity
        this.ventilationRows = [...this.ventilationRows];
    }

    handleAddVentilation() {
        this.ventilationRows = [...this.ventilationRows, this.createNewRow()];
    }

    handleRemoveVentilation() {
        if (this.ventilationRows.length > 1) {
            this.ventilationRows = this.ventilationRows.slice(0, -1);
        }
    }


@track selectedDripEdgePiece = null;

handleDripEdgePieceChange(event) {
    this.selectedDripEdgePiece = event.detail.value;
}


    
    @track selectedDripEdgeMaterial = '';
@track selectedDripEdgeColor = ''; 
    @track selectedDripEdgeQty;
    @track selectedDripEdgeUnit = '';

    get dripEdgeMaterialOptions() {
        return [
            { label: '2" * 2" Aluminum (10 feet per stick)', value: 'aluminum' }
        ];
    }

    get dripEdgeColorOptions() {
    return [
        { label: 'Weathered Wood', value: 'weathered_wood' },
        { label: 'Black', value: 'black' },
        { label: 'Brown', value: 'brown' },
        { label: 'White', value: 'white' },
        { label: 'Almond', value: 'almond' },
        { label: 'Milk', value: 'milk' }
    ];
}
    get dripEdgeUnitOptions() {
        return [
            { label: 'Foot', value: 'foot' },
            { label: 'Piece', value: 'piece' },
            { label: 'Box', value: 'box' }
        ];
    }

    // Event Handlers
    handleDripEdgeMaterialChange(event) {
        this.selectedDripEdgeMaterial = event.detail.value;
        console.log('Drip Edge Material:', this.selectedDripEdgeMaterial);
    }

    handleDripEdgeColorChange(event) {
        this.selectedDripEdgeColor = event.detail.value;
        console.log('Drip Edge Color:', this.selectedDripEdgeColor);
    }

    handleDripEdgeQtyChange(event) {
        this.selectedDripEdgeQty = event.target.value;
        console.log('Drip Edge Quantity:', this.selectedDripEdgeQty);
    }

    handleDripEdgeUnitChange(event) {
        this.selectedDripEdgeUnit = event.detail.value;
        console.log('Drip Edge Unit:', this.selectedDripEdgeUnit);
    }

// ----------------- Bullet Boot -----------------
@track bulletBootRows = [
        { id: Date.now(), size: '', color: '', quantity: 0, piece: '' }
    ];

    // Size options
    get bulletBootSizeOptions() {
        return [
            { label: '1.5"', value: '1.5"' },
            { label: '2"', value: '2"' },
            { label: '3"', value: '3"' },
            { label: '4"', value: '4"' }
        ];
    }

    // ✅ Color options (camelCase properly)
    get bulletBootColorOptions() {
        return [
            { label: 'Weathered Wood', value: 'weathered_wood' },
            { label: 'Brown', value: 'brown' },
            { label: 'Black', value: 'black' },
            { label: 'White', value: 'white' },
            { label: 'Gray', value: 'gray' }
        ];
    }

    // Piece options
    get bulletBootPieceOptions() {
        return Array.from({ length: 20 }, (_, i) => {
            const piece = i + 1;
            return {
                label: `${piece} Piece${piece > 1 ? 's' : ''}`,
                value: `${piece}`
            };
        });
    }

    // Handle combobox/input changes
    handleBulletBootChange(event) {
        const rowId = event.target.dataset.id;
        const row = this.bulletBootRows.find(r => r.id == rowId);
        if (!row) return;

        const label = event.target.label.toLowerCase();
        const value = event.detail ? event.detail.value : event.target.value;

        if (label.includes('size')) row.size = value;
        else if (label.includes('color')) row.color = value;
        else if (label.includes('quantity')) row.quantity = value;
        else if (label.includes('piece')) row.piece = value;

        this.bulletBootRows = [...this.bulletBootRows]; // re-render trigger
        console.log(JSON.stringify(this.bulletBootRows));
    }

    // Add new row
    handleAddBulletBoot() {
        this.bulletBootRows = [
            ...this.bulletBootRows,
            { id: Date.now(), size: '', color: '', quantity: 0, piece: '' }
        ];
    }
handleRemoveBulletBoot(event) {
    if (this.bulletBootRows.length > 0) {
        this.bulletBootRows = this.bulletBootRows.slice(0, -1);

        if (this.bulletBootRows.length > 0) {
            this.bulletBootRows[this.bulletBootRows.length - 1].isLast = true;
        }
    }
}
// Handle changes
handleBulletBootChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.bulletBootRows.find(r => r.id == rowId);
    if (!row) return;

    const field = event.target.label.toLowerCase().includes('size') ? 'size' :
                  event.target.label.toLowerCase().includes('color') ? 'color' :
                  event.target.label.toLowerCase().includes('quantity') ? 'quantity' :
                  'piece';

    row[field] = field === 'quantity' ? event.target.value : event.detail.value;
}

// Add row
handleAddBulletBoot() {
    this.bulletBootRows = [
        ...this.bulletBootRows,
        { id: Date.now(), size: '', color: '', quantity: 0, piece: '' }
    ];
}

// ----------------- 3-in-1 -----------------
@track threeInOneRows = [
    { id: Date.now(), type: '', quantity: 0, piece: '' } // default first row
];

get threeInOneOptions() {
    return [
        { label: 'Standard', value: 'standard' },
        { label: '4"', value: '4"' }
    ];
}

get threeInOnePieceOptions() {
    let options = [];
    for (let i = 1; i <= 30; i++) {
        options.push({ label: `${i} Piece${i > 1 ? 's' : ''}`, value: i.toString() });
    }
    return options;
}

handleThreeInOneChangeRow(event) {
    const rowId = event.target.dataset.id;
    const row = this.threeInOneRows.find(r => r.id == rowId);
    if (!row) return;

    const field = event.target.label.toLowerCase().includes('type') ? 'type' :
                  event.target.label.toLowerCase().includes('quantity') ? 'quantity' :
                  'piece';

    row[field] = field === 'quantity' ? event.target.value : event.detail.value;
}

handleAddThreeInOne() {
    this.threeInOneRows = [
        ...this.threeInOneRows,
        { id: Date.now(), type: '', quantity: 0, piece: '' }
    ];
}
handleRemoveThreeInOne() {
    if (this.threeInOneRows.length > 0) {
        this.threeInOneRows = this.threeInOneRows.slice(0, -1);
        if (this.threeInOneRows.length > 0) {
            this.threeInOneRows[this.threeInOneRows.length - 1].isLast = true;
        }
    }
}

    // ----------------- Fasteners -----------------
    @track selectedFastener = '';
@track fastenerQty = '';

// Fasteners rows
@track fastenerRows = [
    { id: Date.now(), selectedFastener: '', boxQty: '' } 
];

// Fastener options
@track fastenerOptions = [
    { label: '1-1/4" Galvanized Coil Nails', value: '1-1/4"_Galvanized_Coil_Nails' },
    { label: '1-1/2" Galvanized Coil Nails', value: '1-1/2"_Galvanized_Coil_Nails' },
    { label: '7/8" Galvanized Coil Nails', value: '7/8"_Galvanized_Coil_Nails' },
    { label: '2-1/2" Galvanized Coil Nails', value: '2-1/2"_Galvanized_Coil_Nails' },
    { label: 'Hand Nails', value: 'handNails' }
];

get fastenerBoxOptions() {
    let options = [];
    for (let i = 1; i <= 20; i++) {
        options.push({ label: `${i} Box${i > 1 ? 'es' : ''}`, value: i.toString() });
    }
    return options;
}


@track fastenerRows = [
    { id: Date.now(), selectedFastener: '', boxQty: '', helpText: '' }
];

fastenerHelpTextMap = {
    '1-1/4"_Galvanized_Coil_Nails': 
        '• 1 box = ~7,200 nails / covers ~18 squares on a 6/12 or less pitch.\n' +
        'Pitch:\n7-9 : ~14 squares\n10+ : ~12 squares',

    '7/8"_Galvanized_Coil_Nails': 
        '• 1 box = ~7,200 nails / covers ~16–18 squares.\n' +
        '• To be used with exposed soffit or open ceiling pergola.',

    '1-1/2"_Galvanized_Coil_Nails': 
        '• 1 box = ~7,200 nails / covers ~16–18 squares.\n' +
        '• To be used with extra thick shingles or extra thick ridge.',

   /* '2-1/2"_Galvanized_Coil_Nails': 
        '• 1 box = ~7,200 nails (coverage varies depending on application).',

    'handNails': 
        '• Coverage varies depending on use.\n• Typically ordered per box as needed.'*/
};

// Handle Fastener type change
handleFastenerChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.fastenerRows.find(r => r.id == rowId);
    if (row) {
        row.selectedFastener = event.detail.value;
        row.helpText = this.fastenerHelpTextMap[row.selectedFastener] || '';
    }
}

// Handle Fastener box quantity change
handleFastenerQtyChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.fastenerRows.find(r => r.id == rowId);
    if (row) {
        row.boxQty = Number(event.detail.value); 
        
    }
}


// Add new Fastener row
handleAddFastener() {
    this.fastenerRows = [
        ...this.fastenerRows,
        { id: Date.now(), selectedFastener: '', boxQty: '', helpText: '' }
    ];
}

handleRemoveFastener() {
    if (this.fastenerRows.length > 0) {
        this.fastenerRows = this.fastenerRows.slice(0, -1);
        if (this.fastenerRows.length > 0) {
            this.fastenerRows[this.fastenerRows.length - 1].isLast = true;
        }
    }
}


 @track selectedCap = '';
@track capQty = '';

    get capOptions() {
        return [
            { label: 'Cap nails', value: 'cap_nails' },
            { label: 'Stringer cap nails', value: 'stringer_cap_nails' }
        ];
    }
    
get capBoxOptions() {
    let options = [];
    for (let i = 1; i <= 20; i++) {
        options.push({ label: `${i} Box${i > 1 ? 'es' : ''}`, value: i.toString() });
    }
    return options;
}


    handleCapChange(event) {
        this.selectedCap = event.detail.value;
        console.log('Selected Cap Type:', this.selectedCap);
    }

    
handleCapQtyChange(event) {
    this.capQty = event.detail.value;
}
capHelpTextMap = {
    cap_nails: '• 1 box = ~2,000 nails / covers ~22 squares',
    stringer_cap_nails: '• 1 box = ~2,000 nails / covers ~22 squares\n• Only used on steep pitch roofs.\n• Check with crew before ordering that their stinger installation tool is operable.'
};


get capHelpText() {
    return this.capHelpTextMap[this.selectedCap] || '';
}


@track selectedSealant = '';
    @track selectedSealantColor = '';
    @track sealantQty = '';


    get sealantOptions() {
        return [
            { label: 'Tri-Built Roof Sealant', value: 'tri-Built_Roof_Sealant' },
            { label: 'Private Label Roof Sealant', value: 'private_Label_Roof_Sealant' }
                ];
    }

    get sealantColorOptions() {
        return [
            { label: 'Clear', value: 'clear' },
            { label: 'Weathered Wood', value: 'weathered_Wood' },
            { label: 'Black', value: 'black' },
            { label: 'Brown', value: 'brown' },
            { label: 'White', value: 'white' },
            { label: 'Cedar', value: 'cedar' }
        ];
    }
    get tubeOptions() {
    let options = [];
    for (let i = 1; i <= 15; i++) {
        options.push({ label: `${i} Tube${i > 1 ? 's' : ''}`, value: i.toString() });
    }
    return options;
}

    // 3️⃣ Event Handlers
    handleSealantChange(event) {
        this.selectedSealant = event.detail.value;
        console.log('Selected Sealant:', this.selectedSealant);
    }

    handleSealantColorChange(event) {
        this.selectedSealantColor = event.detail.value;
        console.log('Selected Sealant Color:', this.selectedSealantColor);
    }

    handleSealantQtyChange(event) {
    this.sealantQty = Number(event.target.value);
}





    @track selectedSpray = '';
    @track selectedSprayColor = '';
@track sprayQty = '';

    // 2️⃣ Dropdown Options
    get sprayOptions() {
        return [
            { label: 'Tri-Built Roof Spray', value: 'primer' },
            { label: 'Private Label Spray Paint', value: 'gloss' }
       ];
    }

    get sprayColorOptions() {
        return [
            { label: 'Weathered Wood', value: 'red' },
            { label: 'Brown', value: 'blue' },
            { label: 'Black', value: 'black' },
            { label: 'White', value: 'white' },
            { label: 'Cedar', value: 'white' },

        ];
    }
    get canOptions() {
    let options = [];
    for (let i = 1; i <= 15; i++) {
        options.push({ label: `${i} Can${i > 1 ? 's' : ''}`, value: i.toString() });
    }
    return options;
}

    // 3️⃣ Event Handlers
   handleSprayChange(event) {
    this.selectedSpray = event.detail.value;
    
}


    handleSprayColorChange(event) {
        this.selectedSprayColor = event.detail.value;
        console.log('Selected Color:', this.selectedSprayColor);
    }
    

    handleSprayQtyChange(event) {
    this.sprayQty = event.detail.value;
}

@track flashingRows = [
    { id: Date.now(), selectedFlash: '', boxQty: '' } 
];

// Flashing options
flashingOptions = [
    { label: '4"*4"*8"', value: '4"*4"*8"' },
    { label: '20"*50"', value: '20"*50"' }
];

get flashBoxOptions() {
    let options = [];
    for (let i = 1; i <= 5; i++) {
        options.push({ label: `${i} Box${i > 1 ? 'es' : ''}`, value: i.toString() });
    }
    return options;
}

// Handle Flashing selection change
handleFlashChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.flashingRows.find(r => r.id == rowId);
    if (row) row.selectedFlash = event.detail.value;
}

// Handle Box quantity change
handleFlashBoxChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.flashingRows.find(r => r.id == rowId);
    if (row) row.boxQty = Number(event.target.value);
}

// Add new Flashing row
handleAddFlashing() {
    this.flashingRows = [
        ...this.flashingRows,
        { id: Date.now(), selectedFlash: '', boxQty: '' }
    ];
}

handleRemoveFlashing() {
    if (this.flashingRows.length > 0) {
        this.flashingRows = this.flashingRows.slice(0, -1);
        if (this.flashingRows.length > 0) {
            this.flashingRows[this.flashingRows.length - 1].isLast = true;
        }
    }
}
    @track selectedDecking = '';
    deckingOptions = [
        { label: '7/16" OSB', value: 'osb_7_16' },
            { label: '5/8" OSB', value: 'osb_5_8' },
            { label: '7/16" Radiant Barrier', value: 'radiantBarrier_7_16' },
            { label: '5/8" Radiant Barrier', value: 'radiantBarrier_5_8' }
    ];
    @track deckingQty = null;

    @track selectedDeckClips = '';
    deckingClipsOptions = [
        { label: 'Standard', value: 'standardclip' }
    ];
        handleDeckClipsChange(event) {
             this.selectedDeckClips = event.detail.value; }
@track deckingClipsQty ;

handleDeckingClipsQtyChange(event) {
    this.deckingClipsQty = event.target.value;
    console.log('Decking Clips Quantity:', this.deckingClipsQty);
}


    @track selectedSplitBoot = '';
    splitBootOptions = [
        { label: 'Standard', value: 'standardBoot' }
    ];
    @track pieceSplitBootQty= '';

get pieceSplitBootOptions() {
    let options= [];
    for (let i = 1; i <= 10; i++) {
        options.push({ label: `${i} Piece${i > 1 ? 's' : ''}`, value: i.toString() });
    }
    return options;
}

    handleSplitBootChange(event) {
         this.selectedSplitBoot = event.detail.value; }

handlePieceSplitBootChange(event) {
    this.pieceQty = event.detail.value;
}



    @track selectedHVAC = '';
    @track HvacPieceQty = '';
@track hvacRows = [
    { id: Date.now(), selectedHVAC: '', pieceQty: '' } 
];

    hvacOptions = [
        { label: 'Versa Cap 3050 (3"-5")', value: 'versa_Cap_3050' },
        { label: 'Versa Cap 5070 (5"-7")', value: 'versa_Cap_5070' },
        { label: 'Versa Cap 7090 (7"-9")', value: 'versa_Cap_7090' },
        { label: 'Roof Jacks', value: 'roof_Jacks'}
    ];

get hvacPieceOptions() {
    let options = [];
    for (let i = 1; i <= 6; i++) {
        options.push({ label: `${i} Piece${i > 1 ? 's' : ''}`, value: i.toString() });
    }
    return options;
}

handleHvacChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.hvacRows.find(r => r.id == rowId);
    if (row) row.selectedHVAC = event.detail.value;
}

handleHvacPieceChange(event) {
    const rowId = event.target.dataset.id;
    const row = this.hvacRows.find(r => r.id == rowId);
    if (row) row.pieceQty = Number(event.target.value);
}

handleAddHvac() {
    this.hvacRows = [
        ...this.hvacRows,
        { id: Date.now(), selectedHVAC: '', pieceQty: '' }
    ];
}
handleRemoveHvac() {
    if (this.hvacRows.length > 0) {
        this.hvacRows = this.hvacRows.slice(0, -1);
        if (this.hvacRows.length > 0) {
            this.hvacRows[this.hvacRows.length - 1].isLast = true;
        }
    }
}

    @track otherMaterials = '';
    @track notes = '';

    handleFlashingChange(event) { this.selectedFlashing = event.detail.value; }
    handleDeckingChange(event) { this.selectedDecking = event.detail.value; }
    handleDeckingQtyChange(event) { this.deckingQty = Number(event.detail.value); }
    handleOtherMaterialsChange(event) { this.otherMaterials = event.detail.value; }
    handleNotesChange(event) { this.notes = event.detail.value; }

    

    // ----------------- Manufacturer Handlers -----------------
    handleManufacturerChange(event) {
        this.selectedManufacturer = event.detail.value;
        this.seriesOptions = this.manufacturerSeriesMap[this.selectedManufacturer] || [];
        this.selectedSeries = '';
        this.colorOptions = [
            ...(this.manufacturerColorMap[this.selectedManufacturer] || []),
            { label: 'Other', value: 'Other' }
        ];
        this.selectedColor = '';
        this.otherColor = '';
    }
    handleSeriesChange(event) { 
        this.selectedSeries = event.detail.value; }

    handleColorChange(event) {
        this.selectedColor = event.detail.value;
        if (this.selectedColor !== 'Other') this.otherColor = '';
    }
    handleOtherColorChange(event) { 
        this.otherColor = event.target.value; }

    handleQuantityChange(event) { 
        this.selectedQuantity = event.detail.value; }

    handleStarterChange(event) {
        const id = event.target.dataset.id;
        const row = this.shingleRows.find(r => r.id == id);
        if (row) row.starterName = event.detail.value;
    }
    handleBundleChange(event) {
        const id = event.target.dataset.id;
        const row = this.shingleRows.find(r => r.id == id);
        if (row) row.bundle = event.detail.value;
    }
    handleRidgeChange(event) {
        const rowId = event.target.dataset.id;
        const field = event.target.dataset.field;
        const row = this.ridgeRows.find(r => r.id == rowId);
        if (row) row[field] = event.detail.value;
    }
     @track ridgeCapRows = [{ id: 1, selectedRidgeCap: '', quantity: '', color: '', isLast: true }];
nextId = 2;

handleAddRidgeCap(event) {
    this.ridgeCapRows.forEach(row => row.isLast = false);

    this.ridgeCapRows = [
        ...this.ridgeCapRows,
        { id: this.nextId++, selectedRidgeCap: '', quantity: '', color: '', isLast: true }
    ];
}
handleRemoveRidgeCap(event) {
    // Remove the last added row
    if (this.ridgeCapRows.length > 0) {
        // Remove last row
        this.ridgeCapRows = this.ridgeCapRows.slice(0, -1);
        
        // Mark the new last row as isLast = true (if any row remains)
        if (this.ridgeCapRows.length > 0) {
            this.ridgeCapRows[this.ridgeCapRows.length - 1].isLast = true;
        }
    }
}



    handleUploadFinished(event) {
        this.formData['uploadedFiles'] = event.detail.files;
    }

    handleSubmit() {
    }
}
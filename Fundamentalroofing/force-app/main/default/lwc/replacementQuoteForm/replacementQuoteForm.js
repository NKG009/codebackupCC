import { LightningElement, track } from 'lwc';

export default class ReplacementQuoteForm extends LightningElement {
        @track selectedManufacturer = '';
            @track selectedSeries = '';
            @track selectedColor = '';
        
            @track seriesOptions = [];
            @track colorOptions = [];
                @track otherColor = ''; 
   @track dynamicItems = []; 
   @track quoteDate;

   
    connectedCallback() {
        const today = new Date();
        this.quoteDate = today.toISOString().split('T')[0];
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
// Item 3
    @track item3Value = '';
    item3Options = [
        { label: 'Replacement of up to two pieces of damaged sheathing. Additional pieces at $65 each', value: 'sheathing' },
        { label: 'Install new decking with deck clips', value: 'decking' }
    ];

    // Item 7
    @track item7Value = '';
    item7Options = [
        { label: 'Reuse drip edge due to gutter coverage.', value: 'reuse' },
        { label: 'Replace drip edge with 2" x 2" in a color that compliments the shingles.', value: 'replace' }
    ];

    // Item 11 
    @track item11Value = '';
    @track item11OtherText = '';

    item11Options = [
        { label: 'One day installation based on size and complexity of roof.', value: 'onedayinstallation' },
        { label: 'Two day installation based on size and complexity of roof.', value: 'twodayinstallation' },
        { label: 'Three day installation based on size and complexity of roof.', value: 'threedayinstallation' },
        { label: 'Other', value: 'other' }
    ];

    get isItem11Other() {
        return this.item11Value === 'other';
    }

    handleItem11OtherChange(event) {
        this.item11OtherText = event.target.value;
    }

    // Handle radio group changes
    handleRadioChange(event) {
        const groupName = event.target.name;
        if (groupName === 'item3') {
            this.item3Value = event.detail.value;
        } else if (groupName === 'item7') {
            this.item7Value = event.detail.value;
        } else if (groupName === 'item11') {
            this.item11Value = event.detail.value;
        }
    }

    // Handle checkboxes
    handleCheckboxChange(event) {
        const field = event.target.dataset.id;
        if (field === '5a') {
            this.item5First = event.target.checked;
        } else if (field === '5b') {
            this.item5Second = event.target.checked;
        }
    }

    handleRateChange(event) {
        console.log('Rate Changed:', event.target.dataset.id, event.target.value);
    }
handleDynamicItemChange(event) {
        const id = event.target.dataset.id;
        const newValue = event.target.value;
        this.dynamicItems = this.dynamicItems.map(item =>
            item.id === id ? { ...item, value: newValue } : item
        );
    }

    handleAddDynamicItem() {
        const nextId = Date.now().toString(); // unique id for each new line
        this.dynamicItems = [...this.dynamicItems, { id: nextId, value: '' }];

        // Optional: scroll to bottom so new input is visible
        /*setTimeout(() => {
            const list = this.template.querySelector('.custom-numbered-list');
            if (list) list.scrollIntoView({ behavior: 'smooth', block: 'end' });
        }, 50);*/
    }

    handleRemoveDynamicItem(event) {
        const id = event.currentTarget.dataset.id;
        this.dynamicItems = this.dynamicItems.filter(item => item.id !== id);
    }

}
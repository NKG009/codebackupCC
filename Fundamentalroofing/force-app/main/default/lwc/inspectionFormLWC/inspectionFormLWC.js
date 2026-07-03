import { LightningElement, track ,api,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getallpicklistvalues from '@salesforce/apex/InspectionFormLWCController.getallpicklistvalues';
import getrepairitemlist from '@salesforce/apex/InspectionFormLWCController.getrepairitemlist';
import getContentVersion from '@salesforce/apex/InspectionFormLWCController.getContentVersion';
import getformJSON from  '@salesforce/apex/InspectionFormLWCController.getformJSON';
import createupdateFormRecord from  '@salesforce/apex/InspectionFormLWCController.createupdateFormRecord';
import createPDF from  '@salesforce/apex/InspectionFormLWCController.createPDF';
import getprefilldata from  '@salesforce/apex/InspectionFormLWCController.getprefilldata';
import { CloseActionScreenEvent } from 'lightning/actions';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
import PHONE_FIELD from '@salesforce/schema/User.Phone';


let idCounter = Date.now().toString();

export default class InspectionFormLWC extends LightningElement {

    @api recordId;
    userId = Id;
    @track formType = '';
    @track loadform = false;
    @track formid='';

    @track isPassForm= false;
    @track isRepairForm=false;
    @track isCashForm=false;
    @track isInsuranceForm=false;
    @track formTitle='';

    @track clientName = '';
    @track clientAddress = '';
    @track clientCity = '';
    @track clientState = '';
    @track clientZipCode = '';
    @track clientEmail = '';
    @track inspectorName = '';
    @track inspectorPhone = '';
    @track inspectionDate = '';

    
    @track propertyType = '';
    @track isPropertyTypeOther=false;
    @track propertyTypeOther=''
    @track roofPitch = '';
    @track isRoofPitchOther=false;
    @track roofPitchOther='';
    @track roofCovering = '';
    @track isRoofCoveringOther=false;
    @track roofCoveringOther='';
    @track roofLife = '';
    @track roofObservedFrom = '';
    @track isRoofObservedFromOther=false;
    @track roofObservedFromOther='';
    @track roofAge = '';
    @track layersOfShingles = '';
    @track underlayment = '';
    @track chimneys = '';
    @track pipeJacks = '';
    @track ventStacks = '';
    @track exhaustVentilation = '';
    @track isExhaustVentilationOther=false;
    @track exhaustVentilationOther='';
    @track intakeVentilation = '';
    @track isIntakeVentilationOther=false;
    @track intakeVentilationOther='';
    @track ventilation = '';

    @track inspectionYield =[{"id": "1","value": "" }];
    @track inspectionNotes = '';
    @track notes = '';

    @track roofRequiresRepairs = false;


    @track alluploadedfiles = [];   // list format {filename:"" ,cdid:""}
    @track photoBlocks = [];
    @track frontphoto={"filename":"","isfileuploaded":false,"cdid":"","fileurl":"","selectedOption":""};
    @track FormJSON =[];
    @track IsPDFGenerated=false;
    @track isloading =true;
    @track showConfirmation =false;



    @wire(getRecord, { recordId: '$userId', fields: [NAME_FIELD, PHONE_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            this.inspectorName = data.fields.Name.value;
            this.inspectorPhone = data.fields.Phone ? data.fields.Phone.value : '';
        } else if (error) {
            console.error('Error fetching user info', error);
        }
    }



    

    // formTypeOptions = [
    //     { label: 'Passes', value: 'Inspection Report - PASSES INSPECTION' },
    //     { label: 'Repair', value: 'Inspection Report - REQUIRES REPAIRS' },
    //     { label: 'Cash Full Replacement', value: 'Inspection Report - FULL REPLACEMENT' },
    //     { label: 'Insaurance Full Replacement', value: 'Inspection Report - FULL REPLACEMENT' },
    // ];

    formTypeOptions = [
        { label: 'Passes', value: 'Passes Inspection Form' },
        { label: 'Repair', value: 'Repair Inspection Form' },
        { label: 'Cash Full Replacement', value: 'Cash Full Replacement Inspection Form' },
        { label: 'Insurance Full Replacement', value: 'Insurance Full Replacement Inspection Form' },
    ];

    


    propertytypeOptions = [];
    //     { "label": "1 Story", "value": "1 Story" , selected : false},
    //     { "label": "2 Story", "value": "2 Story" , selected : false },
    //     { "label": "3 Story", "value": "3 Story" , selected : false},
    //     { "label": "3+ Story", "value": "3+ Story" , selected : false},
    //     { "label": "Detached", "value": "Detached" , selected : false},
    //     { "label": "Attached", "value": "Attached" , selected : false},
    //     { "label": "Hip & Ridge", "value": "Hip & Ridge" , selected : false},
    //     { "label": "Gable & Ridge", "value": "Gable & Ridge" , selected : false},
    //     { "label": "Flat", "value": "Flat" , selected : false},
    //     { "label": "Other", "value": "Other" , selected : false}
    // ];

    roofCoveringOptions = [];
    //     { label: "3-Tab Composition Asphalt Shingles", value: "3-Tab Composition Asphalt Shingles" },
    //     { label: "Laminated Composition Asphalt Shingles", value: "Laminated Composition Asphalt Shingles" },
    //     { label: "High Profile Hip and Ridge", value: "High Profile Hip and Ridge" },
    //     { label: "Modified Bitumen (Commercial Grade Granulated Roll Roofing)", value: "Modified Bitumen (Commercial Grade Granulated Roll Roofing)" },
    //     { label: "TPO", value: "TPO" },
    //     { label: "PVC", value: "PVC" },
    //     { label: "EPDM", value: "EPDM" },
    //     { label: "Standing Seam", value: "Standing Seam" },
    //     { label: "R-Panel / U-Panel Metal", value: "R-Panel / U-Panel Metal" },
    //     { label: "Concrete Tile", value: "Concrete Tile" },
    //     { label: "Clay Tile", value: "Clay Tile" },
    //     { label: "Slate", value: "Slate" },
    //     { label: "Synthetic Tile", value: "Synthetic Tile" },
    //     { label: "Other", value: "Other" }
    // ];

    roofAgeOptions = [];
    //     { label: '1-5 years of age', value: '1-5 years of age' },
    //     { label: '5-10 years of age', value: '5-10 years of age' },
    //     { label: '10-15 years of age', value: '10-15 years of age' },
    //     { label: '15-20 years of age', value: '15-20 years of age' },
    //     { label: '20+ years of age', value: '20+ years of age' },
    // ];

    underlaymentOptions = [];
    //     { "label": "is installed correctly over the drip edge at the eaves", "value": "is installed correctly over the drip edge at the eaves" },
    //     { "label": "is installed incorrectly over the drip edge at the eaves", "value": "is installed incorrectly over the drip edge at the eaves" }
    // ]

    layerShinglesOptions = [];
    //     { "label": "1", "value": "1" },
    //     { "label": "2", "value": "2" },
    //     { "label": "3", "value": "3" }
    // ];

    intakeVentilationOptions = [];
    //     { "label": "No Ventilation Observed", "value": "No Ventilation Observed" },
    //     { "label": "Soffit Vents", "value": "Soffit Vents" },
    //     { "label": "Ventilated Soffit", "value": "Ventilated Soffit" },
    //     { "label": "Eave Vent", "value": "Eave Vent" },
    //     { "label": "Gable End Vents", "value": "Gable End Vents" },
    //     { "label": "Other", "value": "Other" }
    // ];

    exhaustVentilationOptions = [];
    //     { "label": "No Exhaust Ventilation Observed", "value": "No Exhaust Ventilation Observed" },
    //     { "label": "Gable End Vents", "value": "Gable End Vents" },
    //     { "label": "Ridge Vents", "value": "Ridge Vents" },
    //     { "label": "Low-Profile Box Vents", "value": "Low-Profile Box Vents" },
    //     { "label": "Static Domes", "value": "Static Domes" },
    //     { "label": "Turbines", "value": "Turbines" },
    //     { "label": "Power Attic Fans", "value": "Power Attic Fans" },
    //     { "label": "Solar Power Vents", "value": "Solar Power Vents" },
    //     { "label": "Other", "value": "Other" }
    // ];

    ventilationOptions = [];
    //     { "label": "Adequate (The roof ventialtion system appears to be working as intended)", "value": "Adequate (The roof ventialtion system appears to be working as intended)" },
    //     { "label": "Marginal (See suggested notes for additional improvements)", "value": "Marginal (See suggested notes for additional improvements)" },
    //     { "label": "Inadequate (See inspection notes for required repairs)", "value": "Inadequate (See inspection notes for required repairs)" }
    // ];

    pipeJacksventStackchimneyOptions = [];
    //     { "label": "Functional", "value": "Functional" },
    //     { "label": "In need of repair(See inspection notes for required repairs)", "value": "In need of repair(See inspection notes for required repairs)" }
    // ];

    roofObservedFromOptions = [];
    //     { "label": "Roof - accessed with ladder", "value": "Roof - accessed with ladder" },
    //     { "label": "Roof - accessed with ladder AT EAVES", "value": "Roof - accessed with ladder AT EAVES" },
    //     { "label": "Drone", "value": "Drone" },
    //     { "label": "Ground", "value": "Ground" },
    //     { "label": "Other", "value": "Other" }
    // ];

    roofPitchOptions = [];
    //     { "label": "0-2", "value": "0-2" },
    //     { "label": "2-4", "value": "2-4" },
    //     { "label": "4-7", "value": "4-7" },
    //     { "label": "7-9", "value": "7-9" },
    //     { "label": "9-12", "value": "9-12" },
    //     { "label": "12+", "value": "12+" },
    //     { "label": "Other", "value": "Other" }
    // ];

    photoOptions = [];
    //     { label: 'Front Elevation Overview', value: 'Front' },
    //     { label: 'Right Elevation Overview', value: 'Right' },
    //     { label: 'Rear Elevation Overview', value: 'Rear' },
    //     { label: 'Left Elevation Overview', value: 'Left' },
    //     { label: 'Other', value: 'Other' },
    // ];

    manufacturerOptions = [];
    //     { label: 'CertainTeed', value: 'CertainTeed' },
    //     { label: 'Malarkey', value: 'Malarkey' },
    //     { label: 'Owens Corning', value: 'Owens Corning' }
    // ];

    manufacturerSeries = {};
    //     'CertainTeed': [
    //         { label: 'Landmark', value: 'Landmark' },
    //         { label: 'Landmark Pro', value: 'Landmark Pro' },
    //         { label: 'Landmark Climate Flex', value: 'Landmark Climate Flex' },
    //         { label: 'Highland Slate', value: 'Highland Slate' },
    //         { label: 'Presidential Shake (TL)', value: 'Presidential Shake (TL)' },
    //         { label: 'Grand Manor', value: 'Grand Manor' },
    //         { label: 'Carriage House', value: 'Carriage House' },
    //         { label: 'XT-25 (3-tab)', value: 'XT-25 (3-tab)' }
    //     ],
    //     'Malarkey': [
    //         { label: 'Vista', value: 'Vista' },
    //         { label: 'Legacy', value: 'Legacy' },
    //         { label: 'Highlander', value: 'Highlander' },
    //         { label: 'Windsor', value: 'Windsor' },
    //         { label: 'Ecoasis', value: 'Ecoasis' }
    //     ],
    //     'Owens Corning': [
    //         { label: 'Duration', value: 'Duration' },
    //         { label: 'Duration Designer', value: 'Duration Designer' },
    //         { label: 'True Definition Duration Flex', value: 'True Definition Duration Flex' },
    //         { label: 'Oakridge', value: 'Oakridge' },
    //         { label: 'Berkshire', value: 'Berkshire' }
    //     ]
    // };

    manufacturerColor = {};
    //     'CertainTeed': [
    //         { label: 'Weathered Wood', value: 'Weathered Wood' },
    //         { label: 'Georgetown Gray', value: 'Georgetown Gray' },
    //         { label: 'Colonial Slate', value: 'Colonial Slate' },
    //         { label: 'Cobbelstone Gray', value: 'Cobbelstone Gray' },
    //         { label: 'Silver Birch', value: 'Silver Birch' },
    //         { label: 'Resawn Shake', value: 'Resawn Shake' },
    //         { label: 'Burnt Sienna', value: 'Burnt Sienna' },
    //         { label: 'Heather Blend', value: 'Heather Blend' }
    //     ],
    //     'Malarkey': [
    //         { label: 'Weathered Wood', value: 'Weathered Wood' },
    //         { label: 'Midnight Black', value: 'Midnight Black' },
    //         { label: 'Storm Gray', value: 'Storm Gray' },
    //         { label: 'Antique Brown', value: 'Antique Brown' },
    //         { label: 'Black Oak', value: 'Black Oak' },
    //         { label: 'Natural Wood', value: 'Natural Wood' },
    //         { label: 'Rainforest', value: 'Rainforest' },
    //         { label: 'Heather', value: 'Heather' },
    //         { label: 'Sienna Blend', value: 'Sienna Blend' },
    //         { label: 'Silver Wood', value: 'Silver Wood' }
    //     ],
    //     'Owens Corning': [
    //         { label: 'Driftwood', value: 'Driftwood' },
    //         { label: 'Onyx Black', value: 'Onyx Black' },
    //         { label: 'Estate Gray', value: 'Estate Gray' },
    //         { label: 'Brown Wood', value: 'Brown Wood' },
    //         { label: 'Colonial Slate', value: 'Colonial Slate' },
    //         { label: 'Teak', value: 'Teak' },
    //         { label: 'Desert Rose', value: 'Desert Rose' },
    //         { label: 'Williamsburg Gray', value: 'Williamsburg Gray' },
    //         { label: 'Aged Copper', value: 'Aged Copper' },
    //         { label: 'Black Sable', value: 'Black Sable' },
    //         { label: 'Bourbon', value: 'Bourbon' },
    //         { label: 'Merlot', value: 'Merlot' },
    //         { label: 'Storm Cloud', value: 'Storm Cloud' },
    //         { label: 'Summer Harvest', value: 'Summer Harvest' }
    //     ]
    // };



    @track repairs =[];
    // = [
    //     { id: 1, name: "Shingles Required (1-4)", unit: "Per Bundle", price: 225, quantity: 0, total: 0, isChecked: false },
    //     { id: 2, name: "Flashing Replacement", unit: "Per 10 ft Section", price: 115, quantity: 0, total: 0, isChecked: false },
    //     { id: 3, name: "Shingles Required (>5)", unit: "Per Bundle", price: 150, quantity: 0, total: 0, isChecked: false },
    //     { id: 4, name: "Ridge Cap (5+)", unit: "Per Bundle", price: 150, quantity: 0, total: 0, isChecked: false },
    //     { id: 5, name: "Ridge Cap (1-4)", unit: "Per Bundle", price: 225, quantity: 0, total: 0, isChecked: false },
    //     { id: 6, name: "Pipe Jack", unit: "Per Unit", price: 25, quantity: 0, total: 0, isChecked: false },
    //     { id: 7, name: "Bullet Boot", unit: "Per Unit", price: 50, quantity: 0, total: 0, isChecked: false },
    //     { id: 8, name: "Roof Vent", unit: "Per Unit", price: 75, quantity: 0, total: 0, isChecked: false },
    //     { id: 9, name: "Chimney Flashing", unit: "Per Chimney", price: 300, quantity: 0, total: 0, isChecked: false },
    //     { id: 10, name: "Tarp Installation", unit: "Per 8 x 10 ft Section", price: 350, quantity: 0, total: 0, isChecked: false },
    //     { id: 11, name: "Valley Repair", unit: "Per 10 Ft", price: 200, quantity: 0, total: 0, isChecked: false },
    //     { id: 12, name: "Skylight Repair", unit: "Per Unit", price: 200, quantity: 0, total: 0, isChecked: false },
    //     { id: 13, name: "Decking Replacement", unit: "Per Piece", price: 100, quantity: 0, total: 0, isChecked: false },
    //     { id: 14, name: "Steep Roof Charge (7-9)", unit: "Per Hour", price: 30, quantity: 0, total: 0, isChecked: false },
    //     { id: 15, name: "Steep Roof Charge (11+)", unit: "Per Hour", price: 90, quantity: 0, total: 0, isChecked: false },
    //     { id: 16, name: "2-Story", unit: "Per Hour", price: 60, quantity: 0, total: 0, isChecked: false },
    //     { id: 17, name: "Repair Nail Pops", unit: "Per 10 Nail Pops", price: 125, quantity: 0, total: 0, isChecked: false },
    //     { id: 18, name: "Trip Charge", unit: "Per Job", price: 150, quantity: 0, total: 0, isChecked: false },
    //     { id: 19, name: "Repair Lifted Shingles", unit: "Per 10 Shingles", price: 125, quantity: 0, total: 0, isChecked: false },
    //     { id: 20, name: "Seal As Needed (Penetrations, Flashings, Exposed Nail Heads)", unit: "Per 25 Ft", price: 50, quantity: 0, total: 0, isChecked: false },
    //     { id: 21, name: "Paint As Needed (Flashings and Penetrations)", unit: "Per 10 Sq Ft", price: 50, quantity: 0, total: 0, isChecked: false },
    //     { id: 22, name: "Remove Debris / Clean Gutters and Downspouts", unit: "Per 100 Linear Ft", price: 50, quantity: 0, total: 0, isChecked: false },
    //     { id: 23, name: "Install Rafter Bracing / Purlin / Purlin Braces", unit: "Per Piece", price: 75, quantity: 0, total: 0, isChecked: false },
    //     { id: 24, name: "After Hours Charge", unit: "Outside Mon-Sat 8AM-6PM", price: 150, quantity: 0, total: 0, isChecked: false },
    //     { id: 25, name: "Replace, Seal, and Paint Soffit/Facia / Wood Trim", unit: "Per Linear Ft", price: 30, quantity: 0, total: 0, isChecked: false },
    //     { id: 26, name: "Inclement Weather Charge", unit: "Rain, Ice, Wind, Hail, Etc.", price: 150, quantity: 0, total: 0, isChecked: false },
    //     { id: 27, name: "Other 1", unit: "", price: 10, quantity: 0, total: 0, isChecked: false },
    //     { id: 28, name: "Other 2", unit: "", price: 10, quantity: 0, total: 0, isChecked: false },
    //     { id: 29, name: "Other 3", unit: "", price: 10, quantity: 0, total: 0, isChecked: false },
    //     { id: 30, name: "Install soffit vent(s)", unit: "Per Unit", price: 80, quantity: 0, total: 0, isChecked: false },
    //     { id: 31, name: "Steep Roof Charge (9-11)", unit: "Per Hour", price: 60, quantity: 0, total: 0, isChecked: false },
    //     { id: 32, name: "Gutter Repair", unit: "Up to 6 inches", price: 60, quantity: 0, total: 0, isChecked: false }
    // ];

    

    // @track roofPassesStandard=false;
    // @track roofNoReplacementNeeded=false;
    // @track roofRegularInspection=false;
    // @track passRecOther=false;
    // @track passRecOtherText='';

    // @track passrecomendation =  [
    // { id: 30, label: "This roof passes our quality standard for performance. There are no repairs necessary as any deficiencies notated herein are cosmetic in nature and do not require remedy. This roof should continue to function as intended and shed water.", isChecked: this.roofPassesStandard, type: 'checkbox' },
    // { id: 31, label: "I do not believe there is significant enough storm damage, physical defects or installation issues on the roof, to warrant a full replacement, nor do I perceive any reason for immediate, or even intermediate, leak concerns.", isChecked: this.roofNoReplacementNeeded, type: 'checkbox' },
    // { id: 32, label: "I do recommend regular inspections of the roof to ensure components are not deteriorating to the point they will allow water to infiltrate the home. I also recommend a thorough inspection by a qualified roofing professional after any significant storm event.",isChecked: this.roofRegularInspection, type: 'checkbox' },
    // { id: 33, label: 'Other', isChecked: this.passRecOther, passRecOtherText: this.passRecOtherText, type: 'checkbox' }
    // ];


    @track passRecommendation = {

        instructions: `<p>This roof passes our quality standard for performance. 
    There are no repairs necessary as any deficiencies notated herein are cosmetic in nature 
    and do not require remedy. This roof should continue to function as intended and shed water.</p>

    <p>I do not believe there is significant enough storm damage, physical defects or installation issues on the roof, 
    to warrant a full replacement, nor do I perceive any reason for immediate, or even intermediate, leak concerns.</p>

    <p>I do recommend regular inspections of the roof to ensure components are not deteriorating to the point they will allow water to infiltrate the home. 
    I also recommend a thorough inspection by a qualified roofing professional after any significant storm event.</p>`,

        Other: ''
    };

    @track insuranceRecommendation = {
        instructions: "<p>This roof should be inspected by a licensed adjuster to determine if the amount of storm-related damage is sufficient to warrant a full replacement under insurance provisions. I recommend the homeowner file a claim with their insurance carriers.</p><p><strong>CLAIM FILING INSTRUCTIONS:</strong></p><ol><li>Contact your current insurance provider using their designated claim call number.</li><li>The claim should be designated a <strong>“wind and hail”</strong> claim.</li><li>I recommend the seller contact their carrier and file a claim stating that the home is for sale, and as a process of the sale, an inspection of the roof noted some damage consistent with hail. Reference the date below for <strong>Date Of Loss</strong>.</li><li>An adjuster will be assigned after <strong>24–72 hours</strong> (inspection date will be assigned then).</li><li>Contact <strong>Fundamental Roofing</strong> with the scheduled inspection date and time.</li></ol><p>Following these guidelines will allow Fundamental Roofing to assist in claim valuation and inspection. It is important to have someone representing you to confirm that a full analysis is provided of the property for claimable reimbursement. Having an <strong>experienced contractor</strong> on your team ensures that all statutory guidelines and codes are followed.</p>",

        dateOfLoss: '',

        Other: ''
    };


    @track cashRecommendation = {
        "shingleLine": {
            "manufacturer": "",
            "series": ""
        },
        "shingleColor": {
            "manufacturer": "",
            "color": ""
        },
        "formFields": [
            {
                "id": 1,
                "value": "Material delivery, tear off / haul off of existing shingles and permit fee."
            },
            {
                "id": 2,
                "value": "Cover landscaping, windows, and HVAC to protect from falling debris."
            },
            {
                "id": 3,
                "value": "",
                "isPicklist": true,
                "options": [
                    {
                        "label": "Replacement of up to two pieces of damaged sheathing. Additional pieces at $65 each",
                        "value": "Replacement of up to two pieces of damaged sheathing. Additional pieces at $65 each"
                    },
                    {
                        "label": "Install new decking with deck clips",
                        "value": "Install new decking with deck clips"
                    }
                ]
            },
            {
                "id": 4,
                "value": "Installation of new synthetic underlayment."
            },
            {
                "id": 5,
                "value": "",
                "isPicklist": true,
                "options": [
                    {
                        "label": "Install self-adhesive ice and water shield in valley areas and around penetrations.",
                        "value": "Install self-adhesive ice and water shield in valley areas and around penetrations."
                    },
                    {
                        "label": "Install “W” metal valley in a close color match to shingle and install ice and water shield around penetrations.",
                        "value": "Install “W” metal valley in a close color match to shingle and install ice and water shield around penetrations."
                    }
                ]
            },
            {
                "id": 6,
                "value": "Install starter shingles on all rakes and eaves."
            },
            {
                "id": 7,
                "value": "",
                "isPicklist": true,
                "options": [
                    {
                        "label": "Reuse drip edge due to gutter coverage.",
                        "value": "Reuse drip edge due to gutter coverage."
                    },
                    {
                        "label": "Replace drip edge with 2\" x 2\" in a color that compliments the shingles.",
                        "value": "Replace drip edge with 2\" x 2\" in a color that compliments the shingles."
                    }
                ]
            },
            {
                "id": 8,
                "value": "Replace all pipe jacks, vent stack caps, and ventilation."
            },
            {
                "id": 9,
                "value": "Paint all roof penetrations with rust inhibiting paint if not factory colored."
            },
            {
                "id": 10,
                "value": "All incidentals consistent with asphalt roof installation."
            },
            {
                "id": 11,
                "value": "",
                "isPicklist": true,
                "options": [
                    {
                        "label": "One day installation based on size and complexity of roof.",
                        "value": "One day installation based on size and complexity of roof."
                    },
                    {
                        "label": "Two day installation based on size and complexity of roof.",
                        "value": "Two day installation based on size and complexity of roof."
                    },
                    {
                        "label": "Three day installation based on size and complexity of roof.",
                        "value": "Three day installation based on size and complexity of roof."
                    }
                ]
            },
            {
                "id": 12,
                "value": "Complete clean up of all roofing material from the job site."
            },
            {
                "id": 13,
                "value": "Lifetime transferrable labor warranty + manufacturer warranty."
            }
        ],
        "Squares": "",
        "BaseRate": 0,
        "SteepRoofCharge": 0,
        "TwoStoryCharge": 0,
        "Total": 0,
        "DateOfLoss": ""
    };

     connectedCallback() {
        this.isloading=false;
        this.getpicklistvalues();

       
    }
    selectionchangeeventhandler(event){
        console.log('selectionchangeeventhandler called'+ JSON.stringify(event.detail));
        this[event.detail.picklistfieldname] = event.detail.value;
        this[event.detail.picklistfieldname].forEach(option => {
            if(option.value === 'Other' && option.selected){
                if(event.detail.picklistfieldname === 'propertytypeOptions'){
                    this.isPropertyTypeOther=true;
                }
                if(event.detail.picklistfieldname === 'roofCoveringOptions'){
                    this.isRoofCoveringOther=true;
                }
                if(event.detail.picklistfieldname === 'roofPitchOptions'){
                    this.isRoofPitchOther=true;
                }
                if(event.detail.picklistfieldname === 'intakeVentilationOptions'){
                    this.isIntakeVentilationOther=true;
                }
                if(event.detail.picklistfieldname === 'exhaustVentilationOptions'){
                    this.isExhaustVentilationOther=true;
                }
                if(event.detail.picklistfieldname === 'roofObservedFromOptions'){
                    this.isRoofObservedFromOther=true;
                }
            }
             
            else if(option.value === 'Other' && !option.selected){
                if(event.detail.picklistfieldname === 'propertytypeOptions'){
                    this.isPropertyTypeOther=false;
                }
                if(event.detail.picklistfieldname === 'roofCoveringOptions'){
                    this.isRoofCoveringOther=false;
                }
                if(event.detail.picklistfieldname === 'roofPitchOptions'){
                    this.isRoofPitchOther=false;
                }
                if(event.detail.picklistfieldname === 'intakeVentilationOptions'){
                    this.isIntakeVentilationOther=false;
                }
                if(event.detail.picklistfieldname === 'exhaustVentilationOptions'){
                    this.isExhaustVentilationOther=false;
                }
                if(event.detail.picklistfieldname === 'roofObservedFromOptions'){
                    this.isRoofObservedFromOther=false;
                }

            }

        });
        
    }

    handleFormChange(event) {
        console.log('handleFormChange called:');
        const value = event.detail.value;
        this.formType = value;

        this.formTitle= 'Fundamental Roofing LLC Field ' +this.formType;

        this.isPassForm = false;
        this.isRepairForm = false;
        this.isCashForm = false;
        this.isInsuranceForm = false;

        if (this.formType === 'Passes Inspection Form') {
            this.isPassForm = true;
        } else if (this.formType === 'Repair Inspection Form') {
            this.isRepairForm = true;
            this.getrepairitemlist();
        } else if (this.formType === 'Cash Full Replacement Inspection Form') {
            this.isCashForm = true;
        } else if (this.formType === 'Insurance Full Replacement Inspection Form') {
            this.isInsuranceForm = true;
        }

    }

    getFormdetails(event) {
        console.log('getFormdetails recordid:'+ this.recordId);
        
        getformJSON({ OpprecordId: this.recordId , formType: this.formType})
            .then(result => {
                console.log('getformJSON',JSON.stringify(result));
                if(result){
                    console.log('inside if');
                this.formid = result.Id;
                this.loadFromJson(result.Form_JSON__c);
                this.IsPDFGenerated=result.IsPDFGenerated__c;
                this.loadform = true;
                

                }
                else{
                    console.log('inside else');
                    this.addBlock();
                    this.prefillformdata();
                    
                }

              
            })
            .catch(error => {
                this.isloading=false;
                console.error(error);
            });

       
    }

   
   prefillformdata(){
    console.log('prefillformdata :');
   
    getprefilldata({ OpprecordId: this.recordId })
            .then(result => {
                console.log('getprefilldata',JSON.stringify(result));
                if(result){
                    this.clientName = result?.Contact?.Name || '';
                    this.clientEmail = result?.Contact?.Email || '';
                    this.clientAddress = result?.Contact?.Account?.BillingAddress?.street || '';
                    this.clientCity = result?.Contact?.Account?.BillingAddress?.city || '';
                    this.clientState = result?.Contact?.Account?.BillingAddress?.state || '';
                    this.clientZipCode = result?.Contact?.Account?.BillingAddress?.postalCode || '';
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1).padStart(2, '0');
                    const day = String(today.getDate()).padStart(2, '0');
                    this.inspectionDate = `${year}-${month}-${day}`;
                }
                this.isloading=false;
                this.loadform=true;
            })
            .catch(error => {
                this.isloading=false;
                console.error(error);
            });

   }

   async getpicklistvalues(){
        const picklistvaluelist = await getallpicklistvalues();
      //  console.log('picklistvaluelist',JSON.stringify(picklistvaluelist));
        try{
        picklistvaluelist.forEach(picklist => {
               const group = picklist.Picklist_Group__c;
                const label = picklist.Label__c;
                const value = picklist.Value__c;
                const parent = picklist.Parent_Value__c || null;
                const multiselct = picklist.MultiSelect__c;
                const selected = false;                

                if (parent) {
                    if (!this[group]) {
                        this[group] = {};
                    }
                    if (!this[group][parent]) {
                        this[group][parent] = [];
                    }
                    this[group][parent].push({ label, value });
                } else {
                    if (!this[group]) {
                        this[group] = [];
                    }
                    if(multiselct){
                        this[group].push({ label, value , selected });
                    }
                    else{
                    this[group].push({ label, value });
                    }
                }
               // console.log('group:', JSON.stringify(this[group]));
            });
        }
        catch(error){
            console.error('Error processing picklist values:', error);
        }

 }

 async getrepairitemlist(){
    const repairitemlist = await getrepairitemlist();
       // console.log('repairitemlist',JSON.stringify(repairitemlist));
  //{ id: 1, name: "Shingles Required (1-4)", unit: "Per Bundle", price: 225, quantity: 0, total: 0, isChecked: false },
    this.repairs = repairitemlist.map(item => ({
       id : item.Id,
       name : item.Label,
       unit : item.Unit__c,
       price : item.Price__c,
       quantity : item.Label=='Trip Charge'?1:0,
       total : item.Label=='Trip Charge'? 1 * item.Price__c:0,
       isChecked : false,
       isNewItem : false
    }));

    console.log('mapped repairs:', JSON.stringify(this.repairs));
 }

    get formJson() {
        return JSON.stringify({
            GeneralInformation :[
               
                { id: 2, label: 'Client Address', value: this.clientAddress, type: 'Text' },
                { id: 26, label: 'City', value: this.clientCity, type: 'Text' },
                { id: 27, label: 'State', value: this.clientState, type: 'Text' },
                { id: 28, label: 'Zip Code', value: this.clientZipCode, type: 'number' },
                { id: 1, label: 'Client Name', value: this.clientName, type: 'text' },
                { id: 3, label: 'Client Email', value: this.clientEmail, type: 'email' },
                { id: 4, label: 'Inspector Name', value: this.inspectorName, type: 'text' },
                { id: 5, label: 'Inspector Phone', value: this.inspectorPhone, type: 'phone' },
                { id: 6, label: 'Inspection Date', value: this.inspectionDate, type: 'date' },
                { id: 7, label: 'Form Type', value: this.formType, type: 'picklist' },
            ],
            // GeneralPropertyDescription: [
            //     { id: 8, label: 'Property Type', value: this.propertyType, isOtherSelected:this.isPropertyTypeOther, valOther :this.propertyTypeOther , type: 'multiselectpicklist' },
                
            //     { id: 8, label: 'Property Type', value: this.propertyType, isOtherSelected:this.isPropertyTypeOther, valOther :this.propertyTypeOther , type: 'picklist' },
            //     { id: 9, label: 'Predominant Roof Pitch', value: this.roofPitch, isOtherSelected:this.isRoofPitchOther, valOther:this.roofPitchOther, type: 'picklist' },
            //     { id: 10, label: 'Type of Roof Covering', value: this.roofCovering, isOtherSelected:this.isRoofCoveringOther, valOther:this.roofCoveringOther, type: 'picklist' },
            //     { id: 12, label: 'Roof Observed From', value: this.roofObservedFrom, isOtherSelected:this.isRoofObservedFromOther, valOther:this.roofObservedFromOther, type: 'picklist' },
            //     { id: 13, label: 'The roof appears to be approximately', value: this.roofAge, type: 'picklist' },
            //     { id: 14, label: 'Layers of Shingles Installed', value: this.layersOfShingles, type: 'picklist' },
            //     { id: 15, label: 'Underlayment', value: this.underlayment, type: 'picklist' },
            //     { id: 16, label: 'Chimneys Appear To Be', value: this.chimneys, type: 'picklist' },
            //     { id: 17, label: 'Pipe Jacks Appear To Be', value: this.pipeJacks, type: 'picklist' },
            //     { id: 18, label: 'Vent Stacks Appear To Be', value: this.ventStacks, type: 'picklist' },
            //     { id: 19, label: 'Exhaust Ventilation', value: this.exhaustVentilation,isOtherSelected:this.isExhaustVentilationOther, valOther:this.exhaustVentilationOther, type: 'picklist' },
            //     { id: 20, label: 'Intake Ventilation', value: this.intakeVentilation, isOtherSelected:this.isIntakeVentilationOther, valOther:this.intakeVentilationOther,type: 'picklist' },
            //     { id: 21, label: 'Ventilation Appears To Be', value: this.ventilation,  type: 'picklist' }
                
            // ],
             GeneralPropertyDescription: [
                { id: 8, label: 'Property Type', values: this.propertytypeOptions, isOtherSelected:this.isPropertyTypeOther, valOther :this.propertyTypeOther , type: 'multiselectpicklist' },
                { id: 9, label: 'Roof Pitch', values: this.roofPitchOptions, isOtherSelected:this.isRoofPitchOther, valOther:this.roofPitchOther, type: 'multiselectpicklist' },
                { id: 10, label: 'Type of Roof Covering', values: this.roofCoveringOptions, isOtherSelected:this.isRoofCoveringOther, valOther:this.roofCoveringOther, type: 'multiselectpicklist' },
                { id: 12, label: 'Roof Observed From', values: this.roofObservedFromOptions, isOtherSelected:this.isRoofObservedFromOther, valOther:this.roofObservedFromOther, type: 'multiselectpicklist' },
                { id: 13, label: 'The roof appears to be approximately', value: this.roofAge, type: 'picklist' },
                { id: 14, label: 'Layers of Shingles Installed', value: this.layersOfShingles, type: 'picklist' },
                { id: 15, label: 'Underlayment', value: this.underlayment, type: 'picklist' },
                { id: 16, label: 'Chimneys Appear To Be', value: this.chimneys, type: 'picklist' },
                { id: 17, label: 'Pipe Jacks Appear To Be', value: this.pipeJacks, type: 'picklist' },
                { id: 18, label: 'Vent Stacks Appear To Be', value: this.ventStacks, type: 'picklist' },
                { id: 19, label: 'Exhaust Ventilation', values: this.exhaustVentilationOptions,isOtherSelected:this.isExhaustVentilationOther, valOther:this.exhaustVentilationOther, type: 'multiselectpicklist' },
                { id: 20, label: 'Intake Ventilation', values: this.intakeVentilationOptions, isOtherSelected:this.isIntakeVentilationOther, valOther:this.intakeVentilationOther,type: 'multiselectpicklist' },
                { id: 21, label: 'Ventilation Appears To Be', value: this.ventilation,  type: 'picklist' }
                
            ],
            otherinfo:[
                { id: 23, label: 'Inspection Notes', value: this.inspectionNotes, type: 'textarea' },
                { id: 24, label: 'Notes', value: this.notes, type: 'textarea' },
                { id: 25, label: 'Roof Requires Repairs?', value: this.roofRequiresRepairs, type: 'checkbox' },
                 { id: 11, label: 'Roof Life Expectancy', value: this.roofLife, type: 'picklist' },
            ],

            repairs: this.repairs,
            inspectionYield: this.inspectionYield,
            alluploadedfiles: this.photoBlocks,
            frontphoto: this.frontphoto,
            insuranceRecommendation:this.insuranceRecommendation,
            passRecommendation:this.passRecommendation,
            cashRecommendation:this.cashRecommendation
        });
    }

    


    loadFromJson(jsonString) {
        try {
            const data = JSON.parse(jsonString);


            if (data.GeneralInformation) {
                data.GeneralInformation.forEach(field => {
                    switch (field.label) {
                        case 'Client Name': this.clientName = field.value; break;
                        case 'Client Address': this.clientAddress = field.value; break;
                        case 'City': this.clientCity = field.value; break;
                        case 'State': this.clientState = field.value; break;
                        case 'Zip Code': this.clientZipCode = field.value; break;
                        case 'Client Email': this.clientEmail = field.value; break;
                        case 'Inspector Name': this.inspectorName = field.value; break;
                        case 'Inspector Phone': this.inspectorPhone = field.value; break;
                        case 'Inspection Date': this.inspectionDate = field.value; break;
                        case 'Form Type': this.formType = field.value; break;
                        default: console.warn(`Unmapped field: ${field.label}`);
                    }
                });
            }

            if (data.GeneralPropertyDescription) {
                data.GeneralPropertyDescription.forEach(field => {
                    switch (field.label) {
                        case 'Property Type': this.propertytypeOptions = field.values; this.isPropertyTypeOther=field.isOtherSelected ; this.propertyTypeOther = field.valOther;  break;
                        case 'Roof Pitch': this.roofPitchOptions = field.values; this.isRoofPitchOther = field.isOtherSelected; this.roofPitchOther = field.valOther; break;
                        case 'Type of Roof Covering': this.roofCoveringOptions = field.values; this.isRoofCoveringOther = field.isOtherSelected; this.roofCoveringOther = field.valOther; break;
                        case 'Roof Observed From': this.roofObservedFromOptions = field.values; this.isRoofObservedFromOther = field.isOtherSelected; this.roofObservedFromOther = field.valOther; break;
                        case 'The roof appears to be approximately': this.roofAge = field.value;  break;
                        case 'Layers of Shingles Installed': this.layersOfShingles = field.value; break;
                        case 'Underlayment': this.underlayment = field.value; break;
                        case 'Chimneys Appear To Be': this.chimneys = field.value; break;
                        case 'Pipe Jacks Appear To Be': this.pipeJacks = field.value; break;
                        case 'Vent Stacks Appear To Be': this.ventStacks = field.value; break;
                        case 'Exhaust Ventilation': this.exhaustVentilationOptions = field.values; this.isExhaustVentilationOther = field.isOtherSelected; this.exhaustVentilationOther = field.valOther; break;
                        case 'Intake Ventilation': this.intakeVentilationOptions = field.values; this.isIntakeVentilationOther = field.isOtherSelected; this.intakeVentilationOther = field.valOther; break;
                        case 'Ventilation Appears To Be': this.ventilation = field.value; break;
                        default: console.warn(`Unmapped field: ${field.label}`);
                    }
                });
            }
            if (data.otherinfo) {
                data.otherinfo.forEach(field => {
                    switch (field.label) {
                        case 'Inspection Notes': this.inspectionNotes = field.value; break;
                        case 'Notes': this.notes = field.value; break;
                        case 'Roof Requires Repairs?': this.roofRequiresRepairs = field.value; break;
                        case 'Roof Life Expectancy': this.roofLife = field.value; break;
                        default: console.warn(`Unmapped field: ${field.label}`);
                    }
                });
            }


            if (data.repairs) {
                this.repairs = data.repairs;
            }
            if (data.inspectionYield) {
                this.inspectionYield = data.inspectionYield;
            }
            if (data.alluploadedfiles) {
                this.photoBlocks=data.alluploadedfiles;
            }
            if (data.frontphoto) {
                this.frontphoto=data.frontphoto;
            }
            if (data.insuranceRecommendation) {
                this.insuranceRecommendation=data.insuranceRecommendation;
            }
            if (data.passRecommendation) {
                this.passRecommendation=data.passRecommendation;
            }
            if (data.cashRecommendation) {
                this.cashRecommendation=data.cashRecommendation;
            }
            this.isloading=false;

        } catch (error) {
            this.isloading=false;
            console.error('Invalid JSON string provided', error);
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;

        console.log('handleInputChange called:', field, value);

        if (field === 'propertyType') {
            this.isPropertyTypeOther = value === 'Other';
            if (!this.isPropertyTypeOther) {
                this.propertyTypeOther = ''; 
            }
        }
        else if (field === 'roofCovering') {
            this.isRoofCoveringOther = value === 'Other';
            if (!this.isRoofCoveringOther) {
                this.roofCoveringOther = ''; 
            }
        }
        else if (field === 'intakeVentilation') {
            this.isIntakeVentilationOther = value === 'Other';
            if (!this.isIntakeVentilationOther) {
                this.intakeVentilationOther = ''; 
            }
        }
        else if (field === 'exhaustVentilation') {
            this.isExhaustVentilationOther = value === 'Other';
            if (!this.isExhaustVentilationOther) {
                this.exhaustVentilationOther = ''; 
            }
        }
        else if (field === 'roofObservedFrom') {
            this.isRoofObservedFromOther = value === 'Other';
            if (!this.isRoofObservedFromOther) {
                this.roofObservedFromOther = ''; 
            }
        }
        else if (field === 'roofPitch') {
            this.isRoofPitchOther = value === 'Other';
            if (!this.isRoofPitchOther) {
                this.roofPitchOther = ''; 
            }
        }

        else if (field === 'dateOfLoss') {
            this.insuranceRecommendation.dateOfLoss = value;
        } else if (field === 'Other') {
            console.log('Other field changed');
            if(this.isPassForm){
                this.passRecommendation.Other = value;
            }
            else{
                this.insuranceRecommendation.Other = value;
            }
            
        } 
     
            this[field] = value;
        


        

    }
    addrepairitemblock(){
        this.repairs = [
            ...this.repairs,
            { id: Date.now().toString(), name: "", unit: "", price: 0, quantity: 0, total: 0, isChecked: false , isNewItem:true}
        ];
        console.log('addrepairitemblock called:', JSON.stringify(this.repairs));
         this.repairs=this.reindexFields(this.repairs);
    }
    removerepairitemblock(event) {
        const blockId = event.target.dataset.id;

        this.repairs = this.repairs.filter(b => b.id !== blockId);

         console.log('removerepairitemblock called:', JSON.stringify(this.repairs));
         this.repairs=this.reindexFields(this.repairs);
    }

    handleOtherRepairFieldChange(event) {
        const blockId = event.target.dataset.id;
        const field = event.target.dataset.field;
        const value = event.target.value;
        console.log('handleOtherRepairFieldChange called:', blockId, field, value);
        this.repairs = this.repairs.map(b => 
             b.id === blockId ? { ...b, [field]: value } : b 
        );
    }

    

    
    addBlock() {
        this.photoBlocks = [
            ...this.photoBlocks,
            { id: Date.now().toString() , filename: '', isfileuploaded: false, cdid: '',fileurl:'',selectedOption:'',isOtherSelected:false }
        ];
        console.log('addBlock called:', JSON.stringify(this.photoBlocks));
    }

    removeBlock(event) {
        const blockId = event.target.dataset.id;

        this.photoBlocks = this.photoBlocks.filter(b => b.id !== blockId);

         console.log('removeBlock called:', JSON.stringify(this.photoBlocks));
    }

    handlePhotoChange(event) {
        const blockId = event.target.dataset.id;
        console.log('handlePhotoChange called:');
        console.log('blockId:' + blockId)
        const value = event.detail.value;
        console.log('value:' + value);
        this.photoBlocks = this.photoBlocks.map(b => 
            b.id === blockId ? { ...b, filename: value , selectedOption:value ,isOtherSelected : value === 'Other' } : b

        );


         console.log('handlePhotoChange aftr chnge done:', JSON.stringify(this.photoBlocks));
    }

    handlePhotoblockOtherChange(event) {
        
        const blockId = event.target.dataset.id;
        const value = event.target.value;
        console.log('handlePhotoblockOtherChange called:', value);
        this.photoBlocks = this.photoBlocks.map(b => 
             b.id === blockId ? { ...b, valOther: value } : b 
        );


    }


     handleFileUpload(event) {
         const scrollY = window.scrollY;
        const uploadedFiles = event.detail.files;
        const uploadfiletype = event.target.dataset.name;
        const blockId =event.target.dataset.id;
       

        console.log('uploadfiletype:'+uploadfiletype + 'blockId:'+blockId);  
        try{ 
        if (uploadedFiles.length > 0) {
            const fileId = uploadedFiles[0].documentId; // Get the file's ContentDocumentId
            console.log('fileId:'+fileId);
            const versionId =uploadedFiles[0].contentVersionId //await getContentVersion({ cdid: fileId });
            const fileUrl = '/sfc/servlet.shepherd/version/download/' + versionId;
            

            if (uploadfiletype === 'Front Of Property') {
               this.frontphoto.filename = uploadfiletype;
               this.frontphoto.cdid = fileId;
               this.frontphoto.isfileuploaded=true;
               this.frontphoto.fileurl=fileUrl;
            }
            else {
                const block = this.photoBlocks.find(b => b.id === blockId);
                if (block) {
                    block.cdid = fileId;
                    block.isfileuploaded = true;
                    block.fileurl = fileUrl;
                }
                /*this.photoBlocks = this.photoBlocks.map(b => {
                    if (b.id === blockId) {
                        return {
                            ...b,
                           // id:fileId,
                            cdid: fileId,
                            isfileuploaded: true,
                            fileurl: fileUrl
                        };
                    }
                    return b;
                });*/
            }


            
            this.showToast('Success', 'File has been uploaded successfully', 'success');
            console.log('filesCv',JSON.stringify(this.photoBlocks));
        }
     }
        catch(error){
            console.log('error'+error);
        }
        finally {
            // restore scroll after render completes
            setTimeout(() => window.scrollTo(0, scrollY), 0);
        }
    }

     getcontentversion(fileId){

         getContentVersion({ cdid: fileId})
            .then(result => {
                console.log('filesCv',result);
               return '/sfc/servlet.shepherd/version/download/'+result;
            })
            .catch(error => {
                console.error(error);
            });


    }

    handleQuantityChange(event) {
        const id = event.target.dataset.id
        const value = parseInt(event.target.value, 10) || 0;
        console.log('handleQuantityChange called:', id, value);

        this.repairs = this.repairs.map(item => {
            if (item.id === id) {
                return {
                    ...item,
                    quantity: value,
                    total: value * item.price,
                    isChecked:value>0 ?true:false
                };
            }
            return item;
        });
    }

    get grandTotal() {
        return this.repairs.reduce((sum, item) => sum + item.total, 0);
    }



     handleSave() {
        console.log('handleSave', JSON.stringify(this.formJson));
        this.isloading=true;
       createupdateFormRecord({ OpprecordId: this.recordId ,formid:this.formid || null, formType: this.formType , formJSON: this.formJson})
            .then(result => {
                console.log('createupdateFormRecord',JSON.stringify(result));
                this.formid= result.Id;
                if(this.showConfirmation){
                    this.handleSaveandGeneratePdf();
                }
                else{
                  this.isloading=false;
                  this.dispatchEvent(new CloseActionScreenEvent());
                  this.showToast('Success', 'Form saved successfully!', 'success');
                }
                
               
            })
            .catch(error => {
                this.isloading=false;
                console.error(error);
            });
    }

    generatepdfconfirmconfirmation(){
        this.showConfirmation = true;
    }
     closeModal() {
        this.showConfirmation = false;
     }

    handleSaveandGeneratePdf() {
        this.isloading=true;
        this.showConfirmation = true;
        console.log('handleSaveandGeneratePdf', JSON.stringify(this.formJson));
       createPDF({ OpprecordId: this.recordId ,formid:this.formid || null, formType: this.formType , formJSON: this.formJson})
            .then(result => {
                console.log('handleSaveAndExit',result);
                this.isloading=false;
                  this.dispatchEvent(new CloseActionScreenEvent());
                  this.showToast('Success', 'PDF generated successfully!', 'success');
               
            })
            .catch(error => {
                this.isloading=false;
                console.error(error);
                this.showToast('Error!', 'PDF generation  Failed!', 'error');
            });
    }


    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    get lineSeriesOptions() {
        return this.manufacturerSeries[this.cashRecommendation.shingleLine.manufacturer] || [];
    }
   
    get colorOptions() {
        return this.manufacturerColor[this.cashRecommendation.shingleColor.manufacturer] || [];
    }
  

    handleManufacturerChange(event) {
        const name = event.target.name;
        const val = event.detail ? event.detail.value : event.target.value;

        if (name === 'lineManufacturer') {
           this.cashRecommendation.shingleLine.manufacturer = val;
            // reset dependent
            this.cashRecommendation.shingleLine.series= '';
        } else if (name === 'colorManufacturer') {
            this.cashRecommendation.shingleColor.manufacturer = val;
            this.cashRecommendation.shingleColor.color = '';
        }
    }

    handleLineSeriesChange(event) {
        this.cashRecommendation.shingleLine.series = event.detail ? event.detail.value : event.target.value;
    }

    handleColorChange(event) {
        this.cashRecommendation.shingleColor.color = event.detail ? event.detail.value : event.target.value;
    }
    handleFormFieldChange(event) {
        const id = event.target.dataset.id;
         console.log('handleFormFieldChange called:', id);
         console.log('event :', JSON.stringify(event.detail));
         
        const newValue = (event.detail && event.detail.value !== undefined) ? event.detail.value : event.target.value;

        this.cashRecommendation.formFields = this.cashRecommendation.formFields.map(f => {
            if (f.id === id) {
                console.log('Updating field id:', id, 'with new value:', newValue);
                return { ...f, value: newValue };
            }
            return f;
        });
    }
    
    handleCashRecommendationInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value; 
        console.log('handleCashRecommendationInputChange called:', field, value);
        this.cashRecommendation[field] = value;
    }

    addField() {
        this.cashRecommendation.formFields = [
            ...this.cashRecommendation.formFields,
            { id: Date.now().toString(), value:"",isother:true }
        ];
       this.cashRecommendation.formFields= this.reindexFields(this.cashRecommendation.formFields );
    }
    removeField(event){
        console.log('removeField');
        const blockId = event.target.dataset.id;
        console.log('blockId:' + blockId);
        this.cashRecommendation.formFields  = this.cashRecommendation.formFields.filter(b => b.id !== blockId);
       this.cashRecommendation.formFields= this.reindexFields(this.cashRecommendation.formFields );

    }
    addInspectionField(){
        this.inspectionYield = [ ...this.inspectionYield,
            { id: Date.now().toString(), value:"" }
        ];
       this.inspectionYield= this.reindexFields(this.inspectionYield);
    } 

    removeInspectionField(event){
        console.log('removeInspectionField');
        const blockId = event.target.dataset.id;
        console.log('removeInspectionField blockId:' + blockId);
        this.inspectionYield  = this.inspectionYield.filter(b => b.id !== blockId);
        this.inspectionYield=this.reindexFields(this.inspectionYield);

    }
    handleInspectionFieldChange(event) {
        const blockId = event.target.dataset.id;
        const newValue = event.target.value;
        console.log('handleInspectionFieldChange called:', blockId, newValue);
        this.inspectionYield = this.inspectionYield.map(f => {
            if (f.id === blockId) {
                console.log('Updating inspection field id:', blockId, 'with new value:', newValue);
                return { ...f, value: newValue };
            }
            return f;
        });
    }
    reindexFields(listtobeindexed){ 
       return listtobeindexed.map((field, index) => ({
        ...field,
        id: (index + 1).toString()
    }));
       /* this.cashRecommendation.formFields = this.cashRecommendation.formFields.map((field, index) => {
            return { ...field, id: (index + 1).toString() };
        });*/
    }


}
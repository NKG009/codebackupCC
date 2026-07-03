import { LightningElement, wire, track, api } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import SKILL_SET_OBJECT from '@salesforce/schema/Skill_Set__c';
import Category__c from '@salesforce/schema/Skill_Set__c.Category__c';
import Specialty__c from '@salesforce/schema/Skill_Set__c.Specialty__c';
import Seniority__c from '@salesforce/schema/Skill_Set__c.Seniority__c';
import Employment_Preference__c from '@salesforce/schema/Skill_Set__c.Employment_Preference__c';
import SUBSPECIALITY_FIELD from '@salesforce/schema/Skill_Set__c.Sub_Specialty__c';
import getContactSkillSet from '@salesforce/apex/CreateUpdateSkillSetRecordsController.getContactSkillSet';
import saveSkillSet from '@salesforce/apex/CreateUpdateSkillSetRecordsController.saveSkillSet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateSkillSetRecord from '@salesforce/apex/CreateUpdateSkillSetRecordsController.updateSkillSetRecord';
import { refreshApex } from "@salesforce/apex";
import { CloseActionScreenEvent } from 'lightning/actions';
import deleteSkillSetRecord from '@salesforce/apex/CreateUpdateSkillSetRecordsController.deleteSkillSetRecord';


export default class createSkilSetRecordsComponent extends LightningElement {
    @api recordId; // Ensure recordId is available
    @track controllingValue;
    @track dependentValue;
    @track dependentValue2;
    @track controllingOptions = [];
    @track dependentOptions = [];
    @track dependentOptions2 = [];
    @track employmentdependentOptions = [];
    @track subSpecialitydependentOptions = [];
    allDependentOptions = [];
    allDependentOptions2 = [];
    allEmploymentDependentOptions = [];
    allSubSpecialityDependentOptions = [];
    controllingFieldMap = {};
    controllingFieldMap2 = {};
    controllingFieldMap3 = {};
    employmentPreference = {};
    @track addSkillSet = true;
    @track SubspecialityPickListValues = [];
    skillSetDataAvailable = false;
    @track skillSetRecords = [];

    editSkillSet = false;
    @track name = null
    @track category = null
    @track Specialty = null
    @track Sub_Specialty = null
    @track seniority = null
    employmentPreferenceValue = null;
    requiredField = false;
    selectedSkillSetRow = ''
    wiredResult
    @track showError = false;
    inputString = ''
    startsWith003 = false;
    conJobRecordId

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Category', fieldName: 'Category__c' },
        { label: 'Specialty', fieldName: 'Specialty__c' },
        { label: 'Sub_Specialty', fieldName: 'Sub_Specialty__c' },
        { label: 'Seniority', fieldName: 'Seniority__c' },
        { label: 'Employment Preference', fieldName: 'Employment_Preference__c' },

        {
            label: 'Edit',
            type: 'button',
            typeAttributes: { label: 'Edit', name: 'edit', variant: 'base' },
            initialWidth: 75,
            cellAttributes: { alignment: 'center' },
            fieldName: 'editAction'
        },

        {
            label: 'Delete',
            type: 'button',
            typeAttributes: { label: 'Delete', name: 'delete', variant: 'base' },
            initialWidth: 75,
            cellAttributes: {
                alignment: 'center', color: 'red',
                class: 'deleteColor'
            },
            fieldName: 'deleteAction'
        }
    ];

    @wire(getPicklistValues, {
        recordTypeId: "012000000000000AAA",
        fieldApiName: Employment_Preference__c
    })
    picklistResults({ error, data }) {
        if (data) {

            this.employmentPreference = data.values;

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.employmentPreference = undefined;
        }
    }

    @wire(getContactSkillSet, { contactId: '$recordId' })
    wiredSkillSetRecords(result) {
        this.wiredResult = result;

        if (result.error) {
            this.skillSetRecords = [];
            this.skillSetDataAvailable = false;
        } else if (result.data) {
            this.skillSetRecords = result.data;
            this.skillSetDataAvailable = result.data.length > 0;
        } else {
            this.skillSetRecords = [];
            this.skillSetDataAvailable = false;
        }

    }



    @wire(getObjectInfo, { objectApiName: SKILL_SET_OBJECT })
    skillSetObjectInfo;
    @wire(getPicklistValues, { recordTypeId: '$skillSetObjectInfo.data.defaultRecordTypeId', fieldApiName: Category__c })
    controllingPicklistValues({ error, data }) {
        if (data) {
            this.controllingOptions = [{ label: '--None--', value: '' }];
            const options = data.values.map(item => {
                return { label: item.label, value: item.value };
            });
            this.controllingOptions = [...this.controllingOptions, ...options];
        } else if (error) {
            console.error('Error fetching controlling picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$skillSetObjectInfo.data.defaultRecordTypeId', fieldApiName: SUBSPECIALITY_FIELD })
    subSpecialityPicklistValues({ error, data }) {
        if (data) {
            this.controllingFieldMap3 = data.controllerValues;
            this.allSubSpecialityDependentOptions = data.values.map(item => {
                return { label: item.label, value: item.value, validFor: item.validFor };
            });
        } else if (error) {
            console.error('Error fetching dependent picklist values:', error);
        }
      
    }

    @wire(getPicklistValues, { recordTypeId: '$skillSetObjectInfo.data.defaultRecordTypeId', fieldApiName: Employment_Preference__c })
    employmentDependentPicklistValues({ error, data }) {
        if (data) {
            this.controllingFieldMap = data.controllerValues;
            this.allEmploymentDependentOptions = data.values.map(item => {
                return { label: item.label, value: item.value, validFor: item.validFor };
            });
        } else if (error) {
            console.error('Error fetching dependent picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$skillSetObjectInfo.data.defaultRecordTypeId', fieldApiName: Specialty__c })
    dependentPicklistValues({ error, data }) {
        if (data) {
            this.controllingFieldMap = data.controllerValues;
            this.allDependentOptions = data.values.map(item => {
                return { label: item.label, value: item.value, validFor: item.validFor };
            });
        } else if (error) {
            console.error('Error fetching dependent picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$skillSetObjectInfo.data.defaultRecordTypeId', fieldApiName: Seniority__c })
    dependentPicklistValues2({ error, data }) {
        if (data) {
            this.controllingFieldMap2 = data.controllerValues;
            this.allDependentOptions2 = data.values.map(item => {
                return { label: item.label, value: item.value, validFor: item.validFor };
            });
        } else if (error) {
            console.error('Error fetching dependent picklist values:', error);
        }
    }

    handleNameChange(event) {
        if (this.editSkillSet == true) {
            this.selectedSkillSetRow = { ...this.selectedSkillSetRow, Name: event.target.value };

        } else {
            this.name = event.target.value;
        }

    }
    handleFieldChange(event) {
        const field = event.target.dataset.field;
        if (field === 'Category__c') {

            this.category = event.target.value;

            this.updateDependentOptions();
            this.updateDependentOptions2();
            this.updateEmploymentdependent();
            // this.updateSubSpecialitydependent();
        }
        console.log('field@@ ' + field);
        if (field === 'Specialty__c') {

            this.Specialty = event.target.value;
            this.updateSubSpecialitydependent();
        }


        this.selectedSkillSetRow = { ...this.selectedSkillSetRow, [field]: event.target.value };
    }

    validateSpecialty() {
        const combobox = this.template.querySelector('lightning-combobox[data-id="specialtyCombobox"]');
        if (this.Specialty == null) {
            combobox.setCustomValidity('Please select a Specialty.');
            this.showError = true;
        } else {
            combobox.setCustomValidity('');
            this.showError = false;
        }
        combobox.reportValidity();
    }

    handleControllingChange(event) {
        this.category = event.detail.value;
        this.updateDependentOptions();
        this.updateDependentOptions2();
        this.updateEmploymentdependent();
        //this.updateSubSpecialitydependent();
    }

    handleDependentChange(event) {
        this.Specialty = event.detail.value;
        const combobox = this.template.querySelector('lightning-combobox[data-id="specialtyCombobox"]');
        combobox.setCustomValidity('');
        combobox.reportValidity();
        this.updateSubSpecialitydependent();

    }

    handleDependentChange2(event) {
        this.seniority = event.detail.value;
        const combobox = this.template.querySelector('lightning-combobox[data-id="seniorityCombobox"]');
        //if (event.detail.value != null) {
        combobox.setCustomValidity('');
        combobox.reportValidity();

        //  }
    }

    updateEmploymentdependent() {

        const selectedControllingValue = this.category;
        if (!selectedControllingValue) {
            this.employmentdependentOptions = [];
            return;
        }

        const controllingIndex = this.controllingFieldMap[selectedControllingValue];
        if (controllingIndex !== undefined) {


            this.employmentdependentOptions = this.allEmploymentDependentOptions.filter(option =>
                option.validFor.includes(controllingIndex)
            ).map(item => {
                return { label: item.label, value: item.value };
            });
        } else {
            this.employmentdependentOptions = [];
        }
    }
    updateSubSpecialitydependent() {

        const selectedControllingValue = this.Specialty;
        if (!selectedControllingValue) {
            this.subSpecialitydependentOptions = [];
            return;
        }

        const controllingIndex = this.controllingFieldMap3[selectedControllingValue];
        if (controllingIndex !== undefined) {


            this.subSpecialitydependentOptions = this.allSubSpecialityDependentOptions.filter(option =>
                option.validFor.includes(controllingIndex)
            ).map(item => {
                return { label: item.label, value: item.value };
            });
        } else {
            this.subSpecialitydependentOptions = [];
        }
       
    }


    updateDependentOptions() {



        const selectedControllingValue = this.category;
        if (!selectedControllingValue) {
            this.dependentOptions = [];
            return;
        }

        const controllingIndex = this.controllingFieldMap[selectedControllingValue];
        if (controllingIndex !== undefined) {


            this.dependentOptions = this.allDependentOptions.filter(option =>
                option.validFor.includes(controllingIndex)
            ).map(item => {
                return { label: item.label, value: item.value };
            });
        } else {
            this.dependentOptions = [];
        }
    }

    updateDependentOptions2() {
        const selectedControllingValue = this.category;
        if (!selectedControllingValue) {
            this.dependentOptions2 = [];
            return;
        }

        const controllingIndex = this.controllingFieldMap2[selectedControllingValue];
        if (controllingIndex !== undefined) {
            this.dependentOptions2 = this.allDependentOptions2.filter(option =>
                option.validFor.includes(controllingIndex)
            ).map(item => {
                return { label: item.label, value: item.value };
            });
        } else {
            this.dependentOptions2 = [];
        }
    }


    addSkillSetHandler() {
        this.editSkillSet = false;
        this.addSkillSet = true;
    }

    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA',
        fieldApiName: SUBSPECIALITY_FIELD
    })
    picklistSubspecialityResults({ error, data }) {
        if (data) {
            this.SubspecialityPickListValues = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.SubspecialityPickListValues = undefined;
        }
    }


    handleSubSpecialty(event) {
        this.Sub_Specialty = event.target.value;
        this.updateSubSpecialitydependent();

        const combobox = this.template.querySelector('lightning-combobox[data-id="subSpecialityCombobox"]');
        combobox.setCustomValidity('');
        combobox.reportValidity();

    }

    handleEmploymentPreferenceValue(event) {
        this.employmentPreferenceValue = event.target.value;
    }
    //This method is to create SkillSet
    handleSaveSkillSet(event) {

        if (this.name == null && this.category == null && this.Specialty == null && this.Sub_Specialty == null
            && this.seniority == null) {

            this.showToastNotification('Error', 'Please provide the input values', 'Info')

        }
        else if (this.category == 'Doctor' && (this.seniority == null)) {


            if (this.seniority == null) {
                const combobox = this.template.querySelector('lightning-combobox[data-id="seniorityCombobox"]');
                combobox.setCustomValidity('Seniority must be populated.');
                combobox.reportValidity();
            }

        }else if (this.category == 'Doctor' && (this.Specialty == null)) {

            const combobox = this.template.querySelector('lightning-combobox[data-id="specialtyCombobox"]');
            combobox.setCustomValidity('Specialty must be populated.');
            combobox.reportValidity();

        }
        else if (this.category == 'Allied Health' && (this.Specialty == null)) {

            const combobox = this.template.querySelector('lightning-combobox[data-id="specialtyCombobox"]');
            combobox.setCustomValidity('Specialty must be populated.');
            combobox.reportValidity();

        }
        else if (this.category == 'Medical Administration' && (this.seniority == null)) {

            const combobox = this.template.querySelector('lightning-combobox[data-id="seniorityCombobox"]');
            combobox.setCustomValidity('Seniority must be populated.');
            combobox.reportValidity();

        }
        else if (this.category == 'Clinical Executive' && (this.seniority == null)) {

            const combobox = this.template.querySelector('lightning-combobox[data-id="seniorityCombobox"]');
            combobox.setCustomValidity('Seniority must be populated.');
            combobox.reportValidity();

        } else if (this.category == 'Nurse' && (this.seniority == null)) {

            const combobox = this.template.querySelector('lightning-combobox[data-id="seniorityCombobox"]');
            combobox.setCustomValidity('Seniority must be populated.');
            combobox.reportValidity();

        }else if(this.category != null && this.skillSetRecords.length > 0 && this.skillSetRecords[0].Category__c != this.category){
                this.showToastNotification('Warning', 'Please Select Category: '+this.skillSetRecords[0].Category__c, 'warning');

        }
        else {
            saveSkillSet({
                ContactId: this.recordId, name: this.name,
                category: this.category, specialty: this.Specialty,
                subSpecialty: this.Sub_Specialty, seniority: this.seniority,
                employmentPreference: this.employmentPreferenceValue
            })
                .then(result => {
                    if (result == false) {
                        this.showToastNotification('Success', 'SkillSet Created Sucessfully.', 'success');
                        // this.addSkillSet = false;

                        return refreshApex(this.wiredResult);
                    } else {
                        this.showToastNotification('Warning', 'SkillSet already exists: ', 'Warning');

                    }
                })
                .catch(error => {
                    console.log('insideee' + error);
                });
            this.editSkillSet = false;
            this.category = null;
            this.name = null;
            this.Specialty = null;
            this.Sub_Specialty = null;
            this.seniority = null;
            this.employmentPreferenceValue = null;

        }
        // refreshApex(this.records);
        return refreshApex(this.skillSetRecords);

    }

    //This is used to update the skillset records
    handleUpdateSkillSet(event) {
        updateSkillSetRecord({
            updateSkillSet: this.selectedSkillSetRow
        })
            .then(result => {
              
                this.showToastNotification('Success', 'SkillSet updated Sucessfully.', 'success');
                this.category = null;
                this.name = null;
                this.Specialty = null;
                this.Sub_Specialty = null;
                this.seniority = null;
                this.employmentPreferenceValue = null;
                return refreshApex(this.wiredResult);
            })
            .catch(error => {
                // Handle error
            });
        // return refreshApex( this.skillSetRecords );
        this.addSkillSet = true;
        this.editSkillSet = false;
    }


    handleCancel() {
        this.editSkillSet = false;
        this.addSkillSet = true;
        this.category = null;
        this.name = null;
        this.Specialty = null;
        this.Sub_Specialty = null;
        this.seniority = null;
    }

    handleCancelButton() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    getRowActions(row, doneCallback) {
        const actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        doneCallback(actions);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                this.editRecord(row);
                break;
            case 'delete':
                this.deleteRecord(row);
                break;
            default:
        }
    }
    editRecord(row) {

        this.editSkillSet = true;
        this.addSkillSet = false;
        this.selectedSkillSetRow = row;
        this.Specialty = this.selectedSkillSetRow.Specialty__c;
        this.category = this.selectedSkillSetRow.Category__c;
        this.updateDependentOptions();
        this.updateDependentOptions2();
        this.updateEmploymentdependent();
        this.updateSubSpecialitydependent();
    }

    deleteRecord(row) {

        this.selectedSkillSetRow = row;
        deleteSkillSetRecord({
            deleteSkillSet: row
        })
            .then(result => {
               
                console.log('skillSetRecords@@@ ' + JSON.stringify(this.skillSetRecords));
                this.showToastNotification('Success', 'SkillSet Deleted Sucessfully.', 'success');
            
                return refreshApex(this.wiredResult);
            })
            .catch(error => {
                // Handle error
            });
        this.editSkillSet = false;
        this.addSkillSet = true;
    }

    showToastNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(evt);
    };
}
import { LightningElement, api, wire, track } from 'lwc';
import getPlacementData from '@salesforce/apex/ChangeRequestController.getPlacementData';
import savePlacementData from '@salesforce/apex/ChangeRequestController.savePlacementData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import payTypeField from '@salesforce/schema/AVTRRT__Placement__c.AVTRRT__Pay_Type__c';
import rateTypeField from '@salesforce/schema/AVTRRT__Placement__c.Rate_Type__c';

export default class ExtendPlacementComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    @track selectedEndDate;
    @track selectedStartDate;
    @track isSelectedRateChangeCB = false;
    @track isSelectedExtensionCB = true;
    @track payTypeValues = [];
    @track payTypeValue;
    @track rateTypeValues = [];
    @track rateTypeValue;
    @track placementData;
    @track isSaveButtonClicked = false;
    previousPlacementUrl;
    previousPlacementCandidate;
    previousPlacementAccount;
    previousPlacementJobApp;
    previousPlacementJob;
    placementEndDate;
    showInsurances = true
    showGNC = true
    applicationName
    candidateName
    employerName
    showPayRollTax = true
    error;
    showSpinner = false;

    @wire(getPlacementData, { recordId: '$recordId' })
    wiredPlacementData({ error, data }) {
        if (data) {

            this.placementData = data;
            console.log('placementDatachangeee@@ ' + JSON.stringify(this.placementData));
            this.previousPlacementUrl = '/' + this.placementData.Id;
            this.employerName = this.placementData.AVTRRT__Employer__c != null ? this.placementData.AVTRRT__Employer__r.Name : '';
            this.candidateName = this.placementData.AVTRRT__Contact_Candidate__c != null ? this.placementData.AVTRRT__Contact_Candidate__r.Name : '';
            this.applicationName = this.placementData.AVTRRT__Job_Applicant__c != null ? this.placementData.AVTRRT__Job_Applicant__r.Name : '';
            this.previousPlacementCandidate = '/' + this.placementData.AVTRRT__Contact_Candidate__c;
            this.previousPlacementAccount = '/' + this.placementData.AVTRRT__Employer__c;
            this.previousPlacementJobApp = '/' + this.placementData.AVTRRT__Job_Applicant__c;
            this.previousPlacementJob = '/' + this.placementData.AVTRRT__Job__c;
            this.placementEndDate = this.placementData.AVTRRT__End_Date__c;
            if (!this.selectedStartDate) {
                this.selectedStartDate = this.placementEndDate;
            }
        } else if (error) {
            console.error('Error fetching placement data:', error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '0125j000000SfdFAAS',
        fieldApiName: payTypeField
    })
    payTypePicklistResults({ error, data }) {
        console.log('data.values@@@ ' + JSON.stringify(data));
        if (data) {
            console.log('data' + data.values);
            this.payTypeValues = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.payTypeValues = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: "012000000000000AAA",
        fieldApiName: rateTypeField
    })
    rateTypePicklistResults({ error, data }) {
        if (data) {
            this.rateTypeValues = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.rateTypeValues = undefined;
        }
    }

    handlePayTypeChange(event) {
        // this.placementData.AVTRRT__Pay_Type__c = event.target.value;
        this.payTypeValue = event.target.value;
        if (this.payTypeValue == 'GNA') {
            this.showInsurances = false
            this.showGNC = true
        } else if (this.payTypeValue == 'Paid by Client' || this.payTypeValue == 'PTY LTD') {
            this.showGNC = false
            this.showInsurances = false
        } else {
            this.showGNC = true
            this.showInsurances = true
        }
    }

    handleRateTypeChange(event) {
        this.rateTypeValue = event.target.value;

    }

    handleEndDateChange(event) {
        this.selectedEndDate = event.target.value;
    }

    handleStartDateChange(event) {
        this.selectedStartDate = event.target.value;
    }

    handleRateChangeCheckbox(event) {
        this.isSelectedRateChangeCB = event.target.checked;
    }

    handleExtensionCheckbox(event) {
        this.isSelectedExtensionCB = event.target.checked;
    }



    handlePlacementFieldsChange(event) {
        const field = event.target.dataset.field;
        // const id = event.target.dataset.id;
        const value = event.target.value;

        if (this.placementData) {
            // Update the field with the new value
            this.placementData = {
                ...this.placementData,
                [field]: value
            };
        }

        //this.rateTypeValue = event.target.value;
        //this.payTypeValue = event.target.value;
        if (this.placementData.AVTRRT__Pay_Type__c == 'GNA' || this.placementData.AVTRRT__Pay_Type__c == 'Paid by GNA') {
            this.showInsurances = false
            this.showGNC = true
            this.showPayRollTax = true
        } else if (this.placementData.AVTRRT__Pay_Type__c == 'PAYG' || this.placementData.AVTRRT__Pay_Type__c == 'Paid by Wave - PAYG') {

            this.showGNC = false
            this.showInsurances = true
            this.showPayRollTax = true
        }
        else if (this.placementData.AVTRRT__Pay_Type__c == 'Paid by Client' || this.placementData.AVTRRT__Pay_Type__c == 'PTY LTD') {
            this.showGNC = false
            this.showInsurances = false
            this.showPayRollTax = false
        } else if (this.placementData.AVTRRT__Pay_Type__c == 'Paid by Wave - PTY/Trust'
        ) {
            this.showGNC = false
            this.showInsurances = false
            // this.showPayRollTax = false
        } else {
            this.showGNC = true
            this.showInsurances = true
            this.showPayRollTax = true
        }

        console.log('placementDatachangeee@@ ' + JSON.stringify(this.placementData));
    }

    handleSubmit() {
        this.showSpinner = true;
        if (this.selectedEndDate == null || this.selectedEndDate == '') {
            this.showToast('Warning', 'Please provide the End Date', 'warning');

        }
        else if (this.selectedStartDate > this.selectedEndDate) {
            this.showToast('Warning', 'Please Make sure End Date of new placement should be greater than the Start Date of new Placement.', 'warning');
        } else {
            try {
                if (this.selectedStartDate != null) {
                    this.isSaveButtonClicked = true;
                    savePlacementData({
                        plaementList: this.placementData,
                        ratechangeCB: this.isSelectedRateChangeCB,
                        extensionCB: this.isSelectedExtensionCB,
                        startDate: this.selectedStartDate,
                        endDate: this.selectedEndDate,
                        recordId: this.recordId
                    })
                        .then(newRecordId => {
                            this.isSaveButtonClicked = false;
                            if (newRecordId) {
                                this.showToast('Success', 'Successfully Created the record ', 'success', 'dismissable');
                                this.navigateToRecord(newRecordId);
                            } else {
                                console.log('Error occurred');
                            }
                        })
                        .catch(error => {
                            this.isSaveButtonClicked = false;
                            console.error('Error:', error);
                        })
                        .finally(() => {
                            this.showSpinner = false; // Hide spinner when the action is complete
                        });
                } else {
                    this.showToast('Error', 'Please enter start Date', 'error', 'dismissable');
                }
            } catch (exception) {
                console.error('Unhandled exception:', exception);
                this.showToast('Error', 'An unexpected error occurred.', 'error', 'dismissable');
            }
        }
        this.showSpinner = false;
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'AVTRRT__Placement__c',
                actionName: 'view'
            }
        });
    }

    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    closeAction() {
        window.history.back();
        return false;
    }
}
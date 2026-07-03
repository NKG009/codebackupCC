import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchAllRecordType from '@salesforce/apex/CustomSiteCreationController.fetchAllRecordType';
import fetchAccountRecord from '@salesforce/apex/CustomSiteCreationController.fetchAccountRecord';
export default class CreateNewSiteV2 extends LightningElement {

    objName = 'sirenum__Site__c';
    @api accountId;
    @track showRTScreen = false;
    @track domain = '';
    @track lstRecordType = [];
    @track selectedRecordTypeName ='';
    @track selectedRecordTypeId;
    @track showRecordForm = false;
    @track showSpinner = false;
    @track operationCompany;

    @track isSiteFromAccount = false;

    connectedCallback() {
        this.showSpinner = true;
        this.domain = window.location.origin;
        this.fetchAllRecordType();
        console.log('================= accountId : '+JSON.stringify(this.accountId));
        if(this.accountId != null && this.accountId != '' && this.accountId != undefined){
            if(this.accountId.startsWith('001')){
                this.fetchAccountRecord(this.accountId);
            }
        }
    }
    fetchAccountRecord(accountId){
        fetchAccountRecord({'recordId': accountId}).then(data => {
            if(data){
                this.operationCompany = data[0].Id;
                this.isSiteFromAccount = true;
            }
        });
        console.log('================= operationCompany : '+JSON.stringify(this.operationCompany));
    }

    fetchAllRecordType() {
        fetchAllRecordType({'objName': this.objName}).then(data => {
            console.log('================ data : '+JSON.stringify(data));
            if (data != null && data != '') {
                this.showRTScreen = true;
                this.lstRecordType = data;
            } else {
                console.log('====== record not found '+JSON.stringify(data));
                /*this.dispatchEvent(new ShowToastEvent({
                    title: 'Warning',
                    message: 'Org do not have any active record type for this object.',
                    variant: 'Warning'
                }));*/
                this.showRTScreen = false;
                this.showRecordForm = true;
            }
            this.showSpinner = false;
        });
    }

    get options(){
        return this.lstRecordType?.map(rt =>({
            label : rt.Name,
            value: rt.Id
        })) || [];
    }

    handleRadioButtonChange(event){
        const selectedValue = event.detail.value;        
        const selectedOption = this.options.find(option => option.value === selectedValue);

    if (selectedOption) {
        const selectedLabel = selectedOption.label;
        this.selectedRecordTypeName = selectedLabel;
    } else {
        console.warn('Selected value not found in options');
    }
        this.selectedRecordTypeId = event.detail.value;
        console.log('================= this.selectedRecordTypeId :'+JSON.stringify(this.selectedRecordTypeId));
    }

    handleRadioCancel(){
        window.location.href = this.domain + '/lightning/o/sirenum__Site__c/list?filterName=__Recent';
    }

    handleRadioSave(){
        this.showRTScreen = false;
        this.showRecordForm = true;
    }

    handleFormCancelButton(){
        if(this.lstRecordType.length > 0){
            this.showRecordForm = false;
            this.showRTScreen = true;
        }else{
            window.location.href = this.domain + '/lightning/o/sirenum__Site__c/list?filterName=__Recent';
        }
        
    }

    handleError(event){
         console.log('============ handle custom submit button : '+event.detail.message);
        this.showSpinner = false;
    }

    handleCustomSubmitButton(){
        console.log('============ handle custom submit button');
        this.showSpinner = true;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleSubmit(event) {
        console.log('============ handle submit ');
        event.preventDefault();
        const fields = event.detail.fields;
        if(this.selectedRecordTypeId){
            fields.RecordTypeId = this.fetchRecordTypeId();
        }
        console.log('============ handle submit '+JSON.stringify(fields));
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    @track siteId = '';
    handleSuccess(event) {
        console.log('====================== handleSuccess');
        this.siteId = event.detail.id;
        this.showToast = true;

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Site has been created successfully',
            variant: 'success'
        }));
        
        console.log('================= this.accountId :'+JSON.stringify(this.accountId));
        if(this.siteId != '' && this.siteId != null){
            this.handleFlowScreen();
        }
        this.showSpinner = false;
    }

    @track showFlow = false;
    handleFlowScreen(){
            this.showRTScreen = false;
            this.showRecordForm = false;
            this.showFlow = true;
            console.log('================= this.showRecordForm :'+this.showRecordForm);
    }

    get inputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.siteId
            }
        ];
    }

    handleStatusChange(event) {
        console.log('================ handleStatusChange :'+JSON.stringify(event.detail.status));
        if (event.detail.status === 'FINISHED') {
            window.location.href = this.domain + '/lightning/r/sirenum__Site__c/'+this.siteId+'/view';
        }
    }
}
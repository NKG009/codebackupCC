import { LightningElement, track, api, wire } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import CSS from '@salesforce/resourceUrl/NewAccountCSS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchAllRecordType from '@salesforce/apex/AccountNewCustomCreationController.fetchAllRecordType';
import fetchUserInfo from '@salesforce/apex/AccountNewCustomCreationController.fetchUserInfo';
export default class CreateNewAccountV2 extends LightningElement {

    objName = 'Account';
    @track lstRecordType = [];
    @track accountId;
    @track selectedRecordTypeId = '';
    @track showRTScreen = false;
    @track domain = '';
    @track showSpinner = false;
    @track brandLogoHtml = '<img src="/resource/BASmall" alt=" " border="0"/>';

    connectedCallback() {
        loadStyle(this, CSS);
        this.showSpinner = true;
        this.domain = window.location.origin;
        console.log('====================== connected call back ');
        console.log('====================== objectName : ' + this.objectName);
        this.fetchUserInfo()
        this.fetchAllRecordType();

    }
    @track userProfileName = '';
    fetchUserInfo() {
        fetchUserInfo({}).then(data => {
            if (data) {
                this.userProfileName = data;
            }
        })
        console.log('================= userProfileName: ' + JSON.stringify(this.userProfileName));
    }

    @track selectedRecordTypeDevName = '';

    fetchAllRecordType() {
        fetchAllRecordType({ 'objName': this.objName }).then(data => {
            console.log('====================== this.data ' + JSON.stringify(data));
            if (data) {
                if (this.userProfileName == 'JS Admin tier 1') {
                    const filterData = data.filter(item => ["2nd Tier Supplier", "Account", "Candidate"].includes(item.Name));
                    console.log('================filterData :: ' + JSON.stringify(filterData));
                    this.lstRecordType = filterData;
                    this.selectedRecordTypeId = filterData[0].Id;
                    this.selectedRecordTypeDevName = filterData[0].DeveloperName;
                } else if (this.userProfileName == 'JS Recruiter - Hybrid') {
                    const filterData = data.filter(record => record.Name === 'Account');
                    console.log('================filterData :: ' + JSON.stringify(filterData));

                    this.lstRecordType = filterData;

                    if (filterData.length > 0) {
                        this.selectedRecordTypeId = filterData[0].Id;
                        this.selectedRecordTypeDevName = filterData[0].DeveloperName;
                    }
                } else {
                    /*const filterData = data.filter(record => record.Name === 'Account');
                    if (filterData.length > 0) {
                        this.selectedRecordTypeId = filterData[0].Id;
                        this.selectedRecordTypeDevName = filterData[0].DeveloperName;
                    }*/
                    this.lstRecordType = data;
                    console.log('================lstRecordType :: ' + JSON.stringify(this.lstRecordType));
                }
                this.showRTScreen = true;
            } else {
                console.log('===== Unable to fatch Record Type =======');
            }
            this.showSpinner = false;
            console.log('================this.selectedRecordTypeId :: ' + JSON.stringify(this.selectedRecordTypeId));
        })
    }

    get options() {
        return this.lstRecordType?.map(rt => ({
            label: rt.Name,
            value: rt.Id
        })) || [];
    }

    handleRadioCancel() {
        this.showRTScreen = false;
        window.location.href = this.domain + '/lightning/o/Account/list?filterName=__Recent';
    }

    validateRadioGroup() {
        console.log('================ validate Radio Group');
        const radioGroup = this.template.querySelector('[data-id="recordTypeRadioGroup"]');
        if (!this.selectedRecordTypeId) {
            radioGroup.setCustomValidity('Please select a record type.');
        } else {
            radioGroup.setCustomValidity('');
        }
        console.log('========= radioGroup.reportValidity() : ' + radioGroup.reportValidity());

        return radioGroup.reportValidity();
    }

    handleRadioSave() {
        console.log('========= handleRadioSave');
        this.showSpinner = true;
        if (this.validateRadioGroup()) {
            setTimeout(() => {
                this.showSpinner = false;
            }, 3000);
            this.showRTScreen = false;
            this.showRecordForm = true;
            console.log('========= selectedRecordTypeDevName : ' + JSON.stringify(this.selectedRecordTypeDevName));
            if (this.selectedRecordTypeDevName == 'Account') {
                this.selectedRecordTypeName = this.selectedRecordTypeDevName;
                this.accountRTAccount = true;
                this.accountRTCandidate = false;
                this.accountRTClient = false;
                this.accountRT2ndTierSupplier = false;
                this.saveButtonLabel = 'Save & Add Address';
            }
        }
        console.log('========= selectedRecordTypeName : ' + JSON.stringify(this.selectedRecordTypeName));
        console.log('========= radioGroup.showRTScreen() : ' + JSON.stringify(this.showRTScreen));
        console.log('========= radioGroup.showRecordForm() : ' + JSON.stringify(this.showRecordForm));
    }


    @track selectedRecordTypeName = '';
    @track accountRTCandidate = false;
    @track accountRTAccount = false;
    @track accountRTClient = false;
    @track accountRT2ndTierSupplier = false;
    @track saveButtonLabel = '';

    handleRadioButtonChange(event) {
        console.log('========= handleRadioButtonChange : ');
        const selectedValue = event.detail.value;
        console.log('========= selectedValue : ' + JSON.stringify(selectedValue));
        const selectedOption = this.options.find(option => option.value === selectedValue);

        if (selectedOption) {
            const selectedLabel = selectedOption.label;
            this.selectedRecordTypeName = selectedLabel;
        } else {
            console.warn('Selected value not found in options');
        }
        this.selectedRecordTypeId = event.detail.value;

        console.log('================= this.selectedRecordTypeName :' + JSON.stringify(this.selectedRecordTypeName));
        console.log('================= this.selectedRecordTypeId :' + JSON.stringify(this.selectedRecordTypeId));
        if (this.selectedRecordTypeName == 'Candidate') {
            this.accountRTAccount = false;
            this.accountRTCandidate = true;
            this.accountRT2ndTierSupplier = false;
            this.accountRTClient = false;
            this.saveButtonLabel = 'Save';
        }
        if (this.selectedRecordTypeName == 'Account') {
            this.accountRTAccount = true;
            this.accountRTCandidate = false;
            this.accountRTClient = false;
            this.accountRT2ndTierSupplier = false;
            this.saveButtonLabel = 'Save & Add Address';
        }
        if (this.selectedRecordTypeName == 'Client') {
            this.accountRTAccount = false;
            this.accountRTCandidate = false;
            this.accountRT2ndTierSupplier = false;
            this.accountRTClient = true;
            this.saveButtonLabel = 'Save & Add Address';
        }
        if (this.selectedRecordTypeName == '2nd Tier Supplier' || this.selectedRecordTypeName == 'Candidate Pool') {
            console.log('================= 2nd Tier Supplier if condation :');
            this.accountRTAccount = false;
            this.accountRTCandidate = false;
            this.accountRTClient = false;
            this.accountRT2ndTierSupplier = true;
            this.saveButtonLabel = 'Save & Add Address';
        }
    }

    handleFormCancelButton() {
        this.showRecordForm = false;
        this.showRTScreen = true;
    }

    handleCustomSubmitButton() {
        //console.log('====================== handle Custom Submit Button');
        //this.template.querySelector('lightning-record-edit-form').submit();

        const form = this.template.querySelector('[data-id="accountForm"]');
        if (form) {
            form.submit();
        } else {
            console.error('Form not found!');
        }

    }

    handleSubmit(event) {
        console.log('====================== handleSubmit');
        console.log('====================== handleSubmit this.selectedRecordTypeId' + this.selectedRecordTypeId);
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        if (this.selectedRecordTypeId) {
            fields.RecordTypeId = this.selectedRecordTypeId;
            console.log('====================== fields.RecordTypeId' + fields.RecordTypeId);
        }
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleError(event) {
        this.showSpinner = false;
    }

    handleSuccess(event) {
        this.showSpinner = true;
        setTimeout(() => {
            this.showSpinner = false;
        }, 3000);
        console.log('====================== handleSuccess');
        this.accountId = event.detail.id;
        this.showToast = true;

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Account has been created successfully',
            variant: 'success'
        }));

        console.log('================= this.accountId :' + JSON.stringify(this.accountId));
        if (this.accountId != '' && this.accountId != null) {
            if (this.selectedRecordTypeName == 'Candidate') {
                window.location.href = this.domain + '/lightning/r/Account/' + this.accountId + '/view';
            } else {
                this.handleFlowScreen();
            }

        } else {
            this.showSpinner = false;
        }
    }

    @track showFlow = false;
    handleFlowScreen() {
        this.showRTScreen = false;
        this.showRecordForm = false;
        this.showFlow = true;
        this.showSpinner = false;
        console.log('================= this.showRecordForm :' + this.showRecordForm);
    }

    get inputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.accountId
            }
        ];
    }

    handleStatusChange(event) {
        console.log('================ handleStatusChange :' + JSON.stringify(event.detail.status));
        if (event.detail.status === 'FINISHED') {
            window.location.href = this.domain + '/lightning/r/Account/' + this.accountId + '/view';
        }
    }
}
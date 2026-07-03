import { LightningElement, api, track } from 'lwc';
import fetchExistingAddress from '@salesforce/apex/CustomSiteCreationController.fetchExistingAddress';
import updateAddress from '@salesforce/apex/CustomSiteCreationController.updateLocationAddress';

export default class AddressDisplay extends LightningElement {
    @api recordId;
    @api addressType = '';
    @track locationSection = false;
    @track invoiceSection = false;
    @track locStreet = '';
    @track locCity = '';
    @track locCounty = '';
    @track locPostalCode = '';
    @track locCountry= '';
    @track incStreet = '';
    @track incCity = '';
    @track incCounty = '';
    @track incPostalCode = '';
    @track incCountry= '';
    isEditMode = false;

    connectedCallback() {
        this.addressType == 'Location' ? this.locationSection = true : this.invoiceSection = true;
        console.log('=================== Record id : '+JSON.stringify(this.recordId));
        console.log('=================== addressType : '+JSON.stringify(this.addressType));
        this.fetchExistingAddress();
    }

    fetchExistingAddress(){
        fetchExistingAddress({'recordId' : this.recordId}).then(data =>{
            console.log('=================== Record id : '+JSON.stringify(data));
            if(data){
                this.locStreet = data[0].sirenum__Street_Address__c;
                this.locCity = data[0].sirenum__City__c;
                this.locCounty = data[0].sirenum__County__c;
                this.locPostalCode = data[0].sirenum__Postal_Code__c;
                this.locCountry = data[0].sirenum__Country__c;
                this.incCity = data[0].IP_InvoiceAddressCity__c;
                this.incStreet = data[0].IP_InvoiceAddressStreet__c;
                this.incCounty = data[0].IP_InvoiceAddressCounty__c;
                this.incPostalCode = data[0].IP_InvoiceAddressPostcode__c;
                this.incCountry = data[0].IP_InvoiceAddressCountry__c;
            }
        })
        console.log('=================== incStreet : '+JSON.stringify(this.incStreet));
        console.log('=================== incCity : '+JSON.stringify(this.incCity));
        console.log('=================== incCounty : '+JSON.stringify(this.incCounty));
        console.log('=================== incPostalCode : '+JSON.stringify(this.incPostalCode));
        console.log('=================== incCountry : '+JSON.stringify(this.incCountry));
    }

    toggleEdit() {
        this.isEditMode = !this.isEditMode;
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        console.log('================= field : '+JSON.stringify(field));
        this[field] = event.target.value;
    }

    updateRecord() {
        console.log('=================== Record id : '+JSON.stringify(this.locStreet));
        console.log('=================== Record id : '+JSON.stringify(this.locCity));
        console.log('=================== Record id : '+JSON.stringify(this.locCounty));
        console.log('=================== Record id : '+JSON.stringify(this.locPostalCode));
        console.log('=================== Record id : '+JSON.stringify(this.locCountry));
        console.log('=================== addressType : '+JSON.stringify(this.addressType));
        this.updateSiteLocationAddress();
        if(this.addressType = 'Location'){
            
        }
    }

    updateInvoiceAddressRecord(){
        this.updateSiteInvoiceAddress();
    }

    updateSiteInvoiceAddress(){
        console.log('=================== Record id : '+JSON.stringify(this.incStreet));
        console.log('=================== Record id : '+JSON.stringify(this.incCity));
        console.log('=================== Record id : '+JSON.stringify(this.incCounty));
        console.log('=================== Record id : '+JSON.stringify(this.incPostalCode));
        console.log('=================== Record id : '+JSON.stringify(this.incCountry));
        console.log('=================== addressType : '+JSON.stringify(this.addressType));
        updateAddress({
            recordId: this.recordId,
            addressType : this.addressType,
            street: this.incStreet,
            city: this.incCity,
            county: this.incCounty,
            postalCode: this.incPostalCode,
            country: this.incCountry
        })
        .then((data) => {
            if(data){
                this.isEditMode = false;
            }
            
        })
        .catch(error => {
            console.error('Error updating record:', error);
        });
    }

    updateSiteLocationAddress(){
        updateAddress({
            recordId: this.recordId,
            addressType : this.addressType,
            street: this.locStreet,
            city: this.locCity,
            county: this.locCounty,
            postalCode: this.locPostalCode,
            country: this.locCountry
        })
        .then((data) => {
            if(data){
                this.isEditMode = false;
            }
            
        })
        .catch(error => {
            console.error('Error updating record:', error);
        });
    }


}
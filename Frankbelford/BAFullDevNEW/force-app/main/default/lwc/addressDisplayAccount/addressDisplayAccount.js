import { LightningElement, api , track } from 'lwc';
import fetchExistingAccountAddress from '@salesforce/apex/AddressDisplayAccountController.fetchExistingAccountAddress';
import updateAddressOnRecord from '@salesforce/apex/AddressDisplayAccountController.updateAddressOnRecord';
export default class AddressDisplayAccount extends LightningElement {
    @api recordId;
    @api addressType = '';
    @track accountRecord = false;
    @track billStreet = '';
    @track billCity = '';
    @track billCounty = '';
    @track billPostalCode = '';
    @track billCountry = '';

    @track shipStreet = '';
    @track shipCity = '';
    @track shipCounty = '';
    @track shipPostalCode = '';
    @track shipCountry = '';

    @track billingSection = false;
    @track shippingSection = false;

    @track isEditMode = false;

    connectedCallback() {
        console.log('=================== Record id : '+JSON.stringify(this.recordId));
        console.log('=================== addressType : '+JSON.stringify(this.addressType));
        this.addressType == 'Billing' ? this.billingSection = true : this.shippingSection = true;
        this.fetchExistingAccountAddress();
        console.log('=================== billingSection : '+JSON.stringify(this.billingSection));
        console.log('=================== shippingSection : '+JSON.stringify(this.shippingSection));
        console.log('=================== isEditMode : '+JSON.stringify(this.isEditMode));
    }

    toggleEdit() {
        this.isEditMode = !this.isEditMode;
    }

    fetchExistingAccountAddress(){
        fetchExistingAccountAddress({'recordId': this.recordId}).then(data =>{
            console.log('===================data: '+JSON.stringify(data));
            if(data){
                this.billStreet = data[0].BillingStreet;
                this.billCity = data[0].BillingCity;
                this.billCounty = data[0].BillingState;
                this.billCountry = data[0].BillingCountry;
                this.billPostalCode = data[0].BillingPostalCode;
                this.shipStreet = data[0].ShippingStreet;
                this.shipCity = data[0].ShippingCity;
                this.shipCounty = data[0].ShippingState;
                this.shipPostalCode = data[0].ShippingPostalCode;
                this.shipCountry = data[0].ShippingCountry;
            }
        })
        console.log('=================== billStreet : '+JSON.stringify(this.billStreet));
        console.log('=================== billCity : '+JSON.stringify(this.billCity));
        console.log('=================== billCounty : '+JSON.stringify(this.billCounty));
        console.log('=================== billCountry : '+JSON.stringify(this.billCountry));
        console.log('=================== billPostalCode : '+JSON.stringify(this.billPostalCode));

        console.log('=================== shipStreet : '+JSON.stringify(this.shipStreet));
        console.log('=================== shipCity : '+JSON.stringify(this.shipCity));
        console.log('=================== shipCounty : '+JSON.stringify(this.shipCounty));
        console.log('=================== shipPostalCode : '+JSON.stringify(this.shipPostalCode));
        console.log('=================== shipCountry : '+JSON.stringify(this.shipCountry));
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        console.log('================= field : '+JSON.stringify(field));
        this[field] = event.target.value;
    }

    updateBillingAddRecord(){
        updateAddressOnRecord({
            'recordId': this.recordId,
            'addressType': this.addressType,
            'street': this.billStreet,
            'city': this.billCity,
            'county': this.billCounty,
            'postalCode': this.billPostalCode,
            'country': this.billCountry
        }).then((data) => {
            if(data){
                this.isEditMode = false;
            }
            
        })
        .catch(error => {
            console.error('Error updating record:', error);
        });
    }

    updateShippingAddRecord(){

    }
}
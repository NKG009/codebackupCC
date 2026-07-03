import { LightningElement, api, track } from 'lwc';
import fetchExistingAddress from '@salesforce/apex/CustomContactAddressCreationController.fetchExistingAddress';
import updateAddress from '@salesforce/apex/CustomContactAddressCreationController.updateAddress';
export default class AddressDisplayForContact extends LightningElement {
    @api recordId;
    @api addressType = '';
    isEditMode = false;
    @track maillingAddressSection = false;
    @track otherAddressSection = false;

    @track mailStreet = '';
    @track mailCity = '';
    @track mailCounty = '';
    @track mailPostalCode = '';
    @track mailCountry = '';
    @track otherStreet = '';
    @track otherCity = '';
    @track otherCounty = '';
    @track otherPostalCode = '';
    @track otherCountry = '';

    connectedCallback() {
        //this.addressType = 'Mailling' ? this.maillingAddressSection = true : this.otherAddressSection = true;
        if(this.addressType == 'Mailling'){
            this.maillingAddressSection = true;
            this.otherAddressSection = false;
        }else if(this.addressType == 'Other'){
            this.maillingAddressSection = false;
            this.otherAddressSection = true;
        }else {
            this.maillingAddressSection = true;
            this.otherAddressSection = true;
        }
        this.fetchExistingAddress();
        console.log('================ addressType : '+JSON.stringify(this.addressType));
        console.log('================ maillingAddressSection     : '+JSON.stringify(this.maillingAddressSection));
        console.log('================ otherAddressSection : '+JSON.stringify(this.otherAddressSection));
    }
    
    

    fetchExistingAddress() {
        fetchExistingAddress({ 'recordId': this.recordId }).then(data => {
            console.log('================ fetchExistingAddress : '+JSON.stringify(data));
            console.log('================ data[0] : '+JSON.stringify(data[0]));
            console.log('================ data[0] : '+JSON.stringify(data[0].MailingStreet));
            console.log('================ data[0] : '+JSON.stringify(data[0].OtherStreet));
            if (data) {
                this.mailStreet = data[0].MailingStreet;
                this.mailCity = data[0].MailingCity;
                this.mailCounty = data[0].MailingState;
                this.mailPostalCode =data[0].MailingPostalCode;
                this.mailCountry = data[0].MailingCountry;
                this.otherStreet = data[0].OtherStreet;
                this.otherCity = data[0].OtherCity;
                this.otherCounty = data[0].OtherState;
                this.otherPostalCode = data[0].OtherPostalCode;
                this.otherCountry = data[0].OtherCountry;
            }
        })
    }

    toggleEdit(){
        this.isEditMode = !this.isEditMode;
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        console.log('================= field : '+JSON.stringify(field));
        this[field] = event.target.value;
    }

    updateRecord(){
        updateAddress({
            'recordId': this.recordId,
            'addressType': this.addressType,
            'street': this.mailStreet,
            'city': this.mailCity,
            'county': this.mailCounty,
            'postalCode': this.mailPostalCode,
            'country': this.mailCountry
        }).then(data =>{
            if(data){
                this.isEditMode = false;
            }
        });
    }

    updateOtherAddress(){
        updateOtherAddress({
            'recordId': this.recordId,
            'addressType': this.addressType,
            'street': this.otherStreet,
            'city': this.otherCity,
            'county': this.otherCounty,
            'postalCode': this.otherPostalCode,
            'country': this.otherCountry
        }).then(data => {
            if(data){
                this.isEditMode = false;
            }
        })
    }


}
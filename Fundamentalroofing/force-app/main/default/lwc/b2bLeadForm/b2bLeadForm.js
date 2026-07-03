import { LightningElement, track } from 'lwc';
import logo from '@salesforce/resourceUrl/Roofinglogo';
import createLead from '@salesforce/apex/B2BLeadController.createLead';

export default class B2bLeadForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';
    @track company = '';
    @track street = '';
    @track city = '';
    @track state = '';
    @track zip = '';
    @track country = '';
    @track isSuccess = false;
    @track error = '';
    logoUrl = logo;

    // New: store generated UTM link
    @track utmLink = '';
    @track agentEmail = '';

    connectedCallback() {
    const params = new URLSearchParams(window.location.search);
    this.agentEmail = params.get('agent') || 'not_provided@example.com';
    console.log('Agent Email from URL:', this.agentEmail);
        console.log('Logo URL:', this.logoUrl);

}

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value; 
    }

    handleSubmit() {
            console.log('handleSubmit fired');

        this.error = '';

        if (!this.email) {
            this.error = 'Email is required.';
            return;
        }

        createLead({
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            phone: this.phone,
            company: this.company,
            street: this.street,
            city: this.city,
            state: this.state,
            zip: this.zip,
            country: this.country,
            agentEmail: this.agentEmail
        })
        .then(() => {
            this.isSuccess = true;

            // Generate UTM link dynamically
            const baseUrl = 'https://force-saas-4448--devsandbox.sandbox.my.site.com/s/';
            if(this.agentEmail){
                this.utmLink = `${baseUrl}?agent=${encodeURIComponent(this.agentEmail)}`;
                console.log('Generated UTM link:', this.utmLink);
            }
            // Clear form fields
            this.firstName = '';
            this.lastName = '';
            this.email = '';
            this.phone = '';
            this.company = '';
            this.street = '';
            this.city = '';
            this.state = '';
            this.zip = '';
            this.country = '';
        }).catch(error => {
    if (error && error.body && error.body.message) {
        this.error = error.body.message;
    } else if (error && error.message) {
        this.error = error.message;
    } else {
        this.error = JSON.stringify(error);
    }
    console.error('Error:', this.error);
});

    }
}
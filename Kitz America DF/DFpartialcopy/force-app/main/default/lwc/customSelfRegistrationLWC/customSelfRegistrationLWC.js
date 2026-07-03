import { LightningElement, track } from 'lwc';
import registerUser from '@salesforce/apex/CustomSelfRegistrationLWCController.registerUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Toast from 'lightning/toast';


export default class CustomSelfRegistrationLWC extends LightningElement {

    @track formData = {};
    @track errorMessage;

    handleChange(event) {
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    validateFields() {
        const inputs = this.template.querySelectorAll('lightning-input');
        return [...inputs].reduce((validSoFar, input) => {
            input.reportValidity();
            return validSoFar && input.checkValidity();
        }, true);
    }

    handleRegister() {

        if (!this.validateFields()) {
            return;
        }

        registerUser({
            firstName: this.formData.firstName,
            lastName: this.formData.lastName,
            email: this.formData.email,
            phone: this.formData.phone,
            branchAddress: this.formData.branchAddress,
            
        })
        .then(result => {
            
            if (result === 'Contact_Exists') {
                this.errorMessage = 'User already exists. Please login.';
                this.showToast('Contact already exists!', 'You Already exists in our system please contact your administrator for access.', 'error');
            } else {
                this.errorMessage = 'Registration successful!';
                this.showToast('Success', 'Registration successful!', 'success');
                setTimeout(() => {
                window.location.href = '/kitzus/s/login';
            }, 2000);
         }

        })
        .catch(error => {
            this.errorMessage = error.body?.message || 'Something went wrong.';
        });
    }

    showToast(title, message, variant) {
    Toast.show({
        label: title,
        message: message,
        variant: variant
    });
}
    // showToast(title, message, variant, mode = 'dismissable') {
    //     this.dispatchEvent(
    //         new ShowToastEvent({
    //             title,
    //             message,
    //             variant,
    //             mode
    //         })
    //     );
    // }
}

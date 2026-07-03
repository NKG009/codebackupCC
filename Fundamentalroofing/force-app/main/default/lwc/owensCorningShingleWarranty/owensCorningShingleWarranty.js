import { LightningElement, track } from 'lwc';
export default class OwensCorningShingleWarranty extends LightningElement {

    pdfUrl = 'https://force-saas-4448--devsandbox.sandbox.my.salesforce.com/sfc/p/WE00000ERo5V/a/WE000000oYZZ/Oh.hKTN08OBHffAMSXXSZqRyd1I2qvpBOftj9G8ruZg';
    @track formData = {
        email: '',
        firstName: '',
        lastName: '',
        clientphone: '',
        street: '',
        city: '',
        state: '',
        zip: '',
        notes: ''
    };

    // Getter to always return today's date in YYYY-MM-DD format
    get todayDate() {
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    }

    handleChange(event) {
        const field = event.target.name;
        this.formData[field] = event.target.value;
    }

}
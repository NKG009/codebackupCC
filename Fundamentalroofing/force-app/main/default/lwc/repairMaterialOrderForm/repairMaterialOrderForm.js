import { LightningElement, track } from 'lwc';

export default class RepairMaterialOrderForm extends LightningElement {
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
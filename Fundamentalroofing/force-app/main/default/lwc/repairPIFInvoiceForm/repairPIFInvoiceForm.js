import { LightningElement, track } from 'lwc';

export default class RepairPIFInvoiceForm extends LightningElement {
    @track invoiceNumber;
    @track invoiceDate;
    @track firstName;
    @track lastName;
    @track street1;
    @track street2;
    @track city;
    @track state;
    @track zip;
    @track email;
    @track serviceDesc;
    @track cost = 0;
    @track paid = 0;
    @track due = 0;

    get stateOptions() {
        return [
            { label: 'Texas', value: 'TX' },
            { label: 'California', value: 'CA' },
            { label: 'New York', value: 'NY' },
            { label: 'Florida', value: 'FL' },
            { label: 'Illinois', value: 'IL' },
        ];
    }

    handleChange(event) {
        const field = event.target.label.replace(/\s+/g, '').toLowerCase();
        this[field] = event.target.value;
    }

    handleAmountChange(event) {
        const label = event.target.label;
        if (label.includes('Cost')) {
            this.cost = parseFloat(event.target.value) || 0;
        } else if (label.includes('paid')) {
            this.paid = parseFloat(event.target.value) || 0;
        }
        // Formula: Cost - Paid = Due
        this.due = this.cost - this.paid;
    }
}
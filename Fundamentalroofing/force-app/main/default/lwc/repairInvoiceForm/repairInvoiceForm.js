import { LightningElement } from 'lwc';

export default class RepairInvoiceForm extends LightningElement {
    handleSave() {
        alert('Invoice Saved!');
    }

    handleSubmit() {
        alert('Invoice Submitted!');
    }
}
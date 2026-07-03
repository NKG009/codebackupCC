import { LightningElement, api } from 'lwc';

export default class CustomPicklist extends LightningElement {
    @api value;
    @api options;
    @api context;

    handleChange(event) {
        this.dispatchEvent(new CustomEvent('cellchange', {
            detail: {
                context: this.context,
                value: event.detail.value
            }
        }));
    }
}
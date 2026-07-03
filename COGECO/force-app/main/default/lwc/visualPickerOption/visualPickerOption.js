import { LightningElement, track, api } from 'lwc';

export default class VisualPickerOption extends LightningElement {
    @track selected = false;
    @api option;

    setState(event) {
        this.selected = !this.selected;
        this.setStyle();
    }

    setStyle() {
        let card = this.template.querySelector(".slds-visual-picker__figure");

        if (this.selected) {
            card.classList.add("selected");
        } else {
            card.classList.remove("selected");
        }
    }

    get docType() {
        return 'doctype:' + this.option.attachmentExtension;
    }

    @api
    getValue() {
        return { 
            selected: this.selected,
            attachmentId: this.option.attachmentId
        };
    }
}
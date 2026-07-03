import { LightningElement } from 'lwc';

export default class FlowSidebar extends LightningElement {
  connectedCallback() {
    this.template.addEventListener('dragstart', this.handleDragStart);
  }

  handleDragStart(event) {
    event.dataTransfer.setData('type', event.target.dataset.type);
  }
}

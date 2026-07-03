import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import drawflowLib from '@salesforce/resourceUrl/SortableJS';

export default class FlowCanvas extends LightningElement {
  drawflowInstance;

  renderedCallback() {
    if (this.drawflowInitialized) {
      return;
    }
    this.drawflowInitialized = true;

    Promise.all([
      loadScript(this, drawflowLib)
    ])
    .then(() => {
      const container = this.template.querySelector('.drawflow');
      this.drawflowInstance = new Drawflow(container);
      this.drawflowInstance.start();

      // Handle drop events
      container.addEventListener('drop', event => {
        event.preventDefault();
        const nodeType = event.dataTransfer.getData('node');
        const position = this.drawflowInstance.editor.getRelativeMousePosition(event);
        this.addNode(nodeType, position.x, position.y);
      });

      container.addEventListener('dragover', event => {
        event.preventDefault();
      });
    })
    .catch(error => {
      console.error('Error loading Drawflow:', error);
    });
  }

  addNode(type, x, y) {
    let data = {};
    let html = '';
    switch(type) {
      case 'decision':
        html = `<div class="node">Decision</div>`;
        break;
      case 'sendEmail':
        html = `<div class="node">Send Email</div>`;
        break;
    }
    this.drawflowInstance.addNode(type, 1, 1, x, y, type, data, html);
  }
}

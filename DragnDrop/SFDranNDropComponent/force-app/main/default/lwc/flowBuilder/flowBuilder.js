import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import SORTABLE_JS from '@salesforce/resourceUrl/sortableJS'; // Make sure you've uploaded SortableJS as a static resource

export default class FlowBuilder extends LightningElement {
    isCanvasEmpty = true;
    nextId = 1;
    sortableInstance;

    renderedCallback() {
        if (this.sortableInitialized) return;
        
        loadScript(this, SORTABLE_JS)
            .then(() => {
                this.initializeSortable();
                this.setupDragFromComponentList();
            })
            .catch(error => {
                console.error('Error loading SortableJS', error);
            });
    }

    initializeSortable() {
        const canvas = this.template.querySelector('.flow-canvas');
        
        this.sortableInstance = new Sortable.create(canvas, {
            group: {
                name: 'flow',
                pull: 'clone',
                put: true
            },
            animation: 150,
            sort: false, // Disable sorting within the canvas
            draggable: '.component-item', // Make sure this matches your component class
            onAdd: (evt) => this.handleComponentAdded(evt),
            onEnd: (evt) => this.handleSortEnd(evt)
        });
    }

    setupDragFromComponentList() {
        const componentList = this.template.querySelector('.component-list');
        
        new Sortable.create(componentList, {
            group: {
                name: 'flow',
                pull: 'clone',
                put: false
            },
            sort: true,
            animation: 150,
            draggable: '.component-item',
            filter: '.ignore-elements' // Add this if you have elements that shouldn't be draggable
        });
    }

    handleComponentAdded(evt) {
        this.isCanvasEmpty = false;
        const componentType = evt.item.dataset.type;
        const id = `component-${this.nextId++}`;
        
        evt.item.dataset.id = id;
        evt.item.classList.add('flow-component');
        
        if (componentType === 'decision') {
            evt.item.innerHTML = this.createDecisionElement(id);
        } else {
            evt.item.innerHTML = this.createActionElement(id, componentType);
        }
    }

    createDecisionElement(id) {
        return `
            <div class="component-handle slds-p-around_small">
                <div class="slds-grid slds-grid_align-spread">
                    <span>Decision</span>
                    <button class="slds-button slds-button_icon slds-button_icon-small">
                        <lightning-icon icon-name="utility:delete" size="small"></lightning-icon>
                    </button>
                </div>
                <div class="slds-box slds-m-top_small">
                    <div class="slds-grid slds-gutters">
                        <div class="slds-col slds-size_1-of-2">
                            <div class="slds-p-around_small decision-path" data-outcome="yes">
                                <div class="slds-text-align_center">Yes</div>
                            </div>
                        </div>
                        <div class="slds-col slds-size_1-of-2">
                            <div class="slds-p-around_small decision-path" data-outcome="no">
                                <div class="slds-text-align_center">No</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    createActionElement(id, actionType) {
        const actionLabel = actionType === 'action' ? 'Send Email' : 'Create Record';
        return `
            <div class="component-handle slds-p-around_small">
                <div class="slds-grid slds-grid_align-spread">
                    <span>${actionLabel}</span>
                    <button class="slds-button slds-button_icon slds-button_icon-small">
                        <lightning-icon icon-name="utility:delete" size="small"></lightning-icon>
                    </button>
                </div>
                <div class="slds-box slds-m-top_small">
                    <div class="slds-p-around_small action-path">
                        <div class="slds-text-align_center">Next</div>
                    </div>
                </div>
            </div>
        `;
    }

    handleSortEnd(evt) {
        console.log('Item moved', evt.item);
    }
}
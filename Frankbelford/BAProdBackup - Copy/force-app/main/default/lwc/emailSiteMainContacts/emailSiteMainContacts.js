import {
    LightningElement,
    api,
    track
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';

export default class EmailSiteMainContacts extends NavigationMixin(LightningElement) {
    @api selectedSiteIds = [];
    @api selectedListViewId='';
    @track flowInputVariables = [];
    isInvokeFlow = true;

    renderedCallback() {
        this.selectedSiteIds = this.selectedSiteIds.slice(1, -1)
        this.selectedSiteIds = this.selectedSiteIds.split(',').map(id => id.trim());
        console.log('selectedSiteIds:::', this.selectedSiteIds+'???'+this.selectedListViewId)
        this.flowInputVariables = [{
            name: 'SelectedSiteIds',
            type: 'String',
            value: this.selectedSiteIds
        }]
        console.log('firstrun::' + this.isInvokeFlow)
        if (this.isInvokeFlow && this.isInvokeFlow === true) {
            this.launchFlow();

        }

    }

    launchFlow() {
        const flowComp = this.template.querySelector('lightning-flow');
        flowComp.startFlow('SendMailToSiteMainContacts', this.flowInputVariables);
    }

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN') {
            this.isInvokeFlow = false;
						console.log('selected list view id::'+this.selectedListViewId)
            window.location.href = '/lightning/o/sirenum__Site__c/list?filterId=' + this.selectedListViewId;
            console.log('firstrun finish::' + this.isFirstRun)
        }
        console.log('firstrun finish1::' + this.isFirstRun)
    }

}
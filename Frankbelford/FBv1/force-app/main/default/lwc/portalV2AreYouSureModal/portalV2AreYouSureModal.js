import {
	LightningElement,
	api
} from "lwc";
import {
	ShowToastEvent
} from 'lightning/platformShowToastEvent';

export default class PortalV2AreYouSureModal extends LightningElement {
	@api
	actionName;
	@api
	isShowCancelRsns;
	showCancelRsnSect = false;
	selectedSupCancelRsn = '--None--';
	supCancelRsns;

	connectedCallback() {
		if (this.isShowCancelRsns && this.isShowCancelRsns === 'true') {
			this.supCancelRsns = [{
					value: "--None--",
					label: "--None--"
				},
				{
					value: "Filled by Other Agency",
					label: "Filled by Other Agency"
				},
				{
					value: "Filled Internally",
					label: "Filled Internally"
				},
				{
					value: "No Longer Required",
					label: "No Longer Required"
				}
			];
		}
		console.log('supCancelRsns::' + JSON.stringify(this.supCancelRsns))
		this.showCancelRsnSect = true;
	}
	closeHandler() {
		this.dispatchEvent(new CustomEvent("close"));
	}

	yesHandler() {

		if (this.isShowCancelRsns && this.isShowCancelRsns === 'true') {
			if (this.selectedSupCancelRsn !== null && this.selectedSupCancelRsn !== "" && this.selectedSupCancelRsn !== '--None--') {
				this.dispatchEvent(new CustomEvent('yesselected', {
					detail: {
						selectedsupcancelrsn: this.selectedSupCancelRsn
					}
				}));
			} else {
				this.showToast();
			}

		} else
			this.dispatchEvent(new CustomEvent("yesselected"));
	}

	showToast() {
		const event = new ShowToastEvent({
			//title: 'Toast message',
			message: 'Cancellation Reason is mandatory.Please provide the value.',
			variant: 'error',
			mode: 'dismissable'
		});
		this.dispatchEvent(event);
	}

	handleSupCancelRsnChange(evt) {
		this.selectedSupCancelRsn = evt.detail.value;
	}
}
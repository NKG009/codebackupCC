import { LightningElement,api } from 'lwc';
import sendOrderToSAP from "@salesforce/apex/SendOrderToSAPController.sendOrderToSAP";
import checkForDuplicates from "@salesforce/apex/SendOrderToSAPController.checkForDuplicates";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from "lightning/actions";
import { NavigationMixin } from "lightning/navigation";
import {notifyRecordUpdateAvailable} from 'lightning/uiRecordApi';

export default class SendOrderToSAP extends NavigationMixin(LightningElement) {

    loaded = false;
    duplicateOrderName='';
    duplicateOrderId;
    @api 
    get recordId() {
        return this._recordId; 
    }

    set recordId(value) {
        this._recordId = value;
        if (this._recordId) {
            console.log('_recordId--',this._recordId);
            console.log('_recordId--',this.recordId);

            checkForDuplicates({orderId: this.recordId})
            .then(response => {
                console.log('Response:'+response);
                let sendOrderResp = JSON.parse(response);
                if(sendOrderResp.duplicateOrderFound)
                {
                    console.log('Duplicate Found');
                    this.loaded = true;
                    this.duplicateOrderName = sendOrderResp.duplicateOrderName;
                    this.duplicateOrderId = sendOrderResp.duplicateOrderId;
                }
                else{
                    console.log('In Send To SAP from check duplicates');
                    this.handleSendToSap();
                }
            })
            .catch(error => {
                console.log('ERROR:'+error);
                const message = error && error.body ? error.body.message : error;
                const event = new ShowToastEvent({
                    title: "Error",
                    variant: "error",
                    message: message
                });
                this.dispatchEvent(event);
                this.handleCancel();
            })
        }
    }

    handleSendToSap() {
        // Logic to trigger SAP integration via Apex
        console.log('Sending to SAP...', this.recordId);
        sendOrderToSAP({orderId: this.recordId})
        .then(response => {
            console.log('Response:'+response);
            let sendOrderResp = JSON.parse(response);
            
            if(sendOrderResp.success) {
                // Show success message
                const event = new ShowToastEvent({
                    title: "Success!",
                    variant: "success",
                    message: sendOrderResp.responseMessage
                });
                this.dispatchEvent(event);
            } else {
                const event = new ShowToastEvent({
                    title: "Error",
                    variant: "error",
                    message: sendOrderResp.responseMessage
                });
                this.dispatchEvent(event);
            }
            this.handleCancel();
            notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        })
        .catch(error => {
            console.log('ERROR:'+error);
            const message = error && error.body ? error.body.message : error;
            const event = new ShowToastEvent({
                title: "Error",
                variant: "error",
                message: message
            });
            this.dispatchEvent(event);
            this.handleCancel();
        })
    }

    navigateToDuplicate() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.duplicateOrderId,
                objectApiName: 'Apttus_Config2__Order__c',
                actionName: 'view'
            }
        });
    }

    refreshUI() {
        eval("$A.get('e.force:refreshView').fire();");
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}
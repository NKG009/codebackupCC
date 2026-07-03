import { LightningElement,wire,track } from 'lwc';
import getOEQRecords from '@salesforce/apex/OrderErrorQueueController.getOEQRecords';
import sendOrderToSAP from "@salesforce/apex/SendOrderToSAPController.sendOrderToSAP";
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from "lightning/actions";
import { NavigationMixin } from "lightning/navigation";

const COLUMNS = [
    { label: 'Order Number', fieldName: 'Order_Name__c', type: 'text' },
    { label: 'Error Message', fieldName: 'Error_Message__c', type: 'text', wrapText: true },
    {
        label: "Last Attempt Date",
        fieldName: "LastModifiedDate",
        type: "date",
        typeAttributes:{
            year: "numeric",
            month: "long",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        }
    },
    
    {
        type: "button", typeAttributes: {
           label: 'View Order',
            name: 'ViewOrder',
            variant: 'brand',
            title: 'ViewOrder',
            disabled: false,
            value: 'vieworder',
            variant:'Brand'
        }
    },
    /*
    {
        type: "button", label: 'View', typeAttributes: {
            label: 'Send To SAP',
            name: 'SendToSAP',
            variant: 'brand',
            title: 'SendToSAP',
            disabled: false,
            value: 'sendtosap',
            variant:'Brand'
        }
    }
    */
];

export default class OrderErrorQueue extends NavigationMixin(LightningElement) {

    oeqRecords = [];
    columns = COLUMNS;
    wiredOEQResult;
    sendordertosapclick = false;

    @wire(getOEQRecords)
    wiredOEQ(result) {
        this.wiredOEQResult = result;
        console.log('result>>>',JSON.stringify(result.data));
        //console.log(JSON.stringify(result.error));
        if (result.data) {
            // Flattening data if you are pulling related Account fields
            this.oeqRecords = result.data.map(row => {
                return {
                    ...row,
                    OrderNumber: row.APTSOrder__r ? row.APTSOrder__r.Name : ''
                };
            });
        } else if (result.error) {
            console.log('Error fetching orders:', result.error);
        }

        console.log('this.oeqRecords>>>',JSON.stringify(this.oeqRecords));
    }

    handleRefresh() {
        return refreshApex(this.wiredOEQResult);
    }

    callRowAction(event) {
        const recId = event.detail.row.Order__c;
        const actionName = event.detail.action.name;
        if (actionName === 'SendToSAP') {
            this.handleSendToSap(recId);
        }
        else if (actionName === 'ViewOrder') {
            this.navigateToRecord(recId);
        }
    }

    navigateToRecord(orderId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: orderId,
                objectApiName: 'Order',
                actionName: 'view'
            }
        });
    }


    handleSendToSap(orderId) {
        // Logic to trigger SAP integration via Apex
        console.log('Sending to SAP...', orderId);
        this.sendordertosapclick = true;
        sendOrderToSAP({orderId: orderId})
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
            //this.sendordertosapclick = false
            //this.handleCancel();
        })
        .catch(error => {
            console.log('ERROR:'+error);
            const message = error && error.body ? error.body.message : error;
            const event = new ShowToastEvent({
                title: "Error",
                variant: "error",
                message: message
            });
            this.sendordertosapclick = false;
            //this.dispatchEvent(event);
            //this.handleCancel();
        })
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}
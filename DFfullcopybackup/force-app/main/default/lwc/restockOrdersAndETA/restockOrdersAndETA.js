import { LightningElement,api,wire } from 'lwc';
 import getInventory from '@salesforce/apex/restockOrdersAndETAController.restockOrdersAndETA';

export default class RestockOrdersAndETA extends LightningElement {

  etaInventory = [
        /*{
            REC_REQD_QTY_ALT_UOM: 30,
            AVAIL_DATE: "2021-02-11T00:00:00.000Z",
            ROWNO: 1
        },
        {
            REC_REQD_QTY_ALT_UOM: 60,
            AVAIL_DATE: "2021-03-13T00:00:00.000Z",
            ROWNO: 2
        }*/
    ];

    restockData = [
        /*{
            PO_NUMBER: "3071004712",
            LINE_NUMBER: "00044",
            REC_REQD_QTY_ALT_UOM: 80,
            AVAIL_DATE: "2021-05-11T00:00:00.000Z",
            ROWNO: 1
        },
        {
            PO_NUMBER: "3071004685",
            LINE_NUMBER: "00057",
            REC_REQD_QTY_ALT_UOM: 50,
            AVAIL_DATE: "2021-05-20T00:00:00.000Z",
            ROWNO: 2
        },
        {
            PO_NUMBER: "3071004729",
            LINE_NUMBER: "00034",
            REC_REQD_QTY_ALT_UOM: 50,
            AVAIL_DATE: "2021-07-21T00:00:00.000Z",
            ROWNO: 3
        },
        {
            PO_NUMBER: "3071004732",
            LINE_NUMBER: "00030",
            REC_REQD_QTY_ALT_UOM: 50,
            AVAIL_DATE: "2021-08-17T00:00:00.000Z",
            ROWNO: 4
        }*/
    ];

    // Columns for ETA Inventory
    etaColumns = [
        { label: "Quantity", fieldName: "REC_REQD_QTY_ALT_UOM", type: "number", cellAttributes: { alignment: "left" }},
        { label: "Available Date", fieldName: "AVAIL_DATE", type: "date",cellAttributes: { alignment: "left" } },
        { label: "Row No", fieldName: "ROWNO", type: "number",cellAttributes: { alignment: "left" } }
    ];

    // Columns for Restock Orders
    restockColumns = [
        { label: "PO Number", fieldName: "PO_NUMBER", type: "text" ,cellAttributes: { alignment: "left" }},
        { label: "Line Number", fieldName: "LINE_NUMBER", type: "text",cellAttributes: { alignment: "left" } },
        { label: "Quantity", fieldName: "REC_REQD_QTY_ALT_UOM", type: "number",cellAttributes: { alignment: "left" } },
        { label: "Available Date", fieldName: "AVAIL_DATE", type: "date" ,cellAttributes: { alignment: "left" }},
        { label: "Row No", fieldName: "ROWNO", type: "number" ,cellAttributes: { alignment: "left" }}
    ];

    @api quoteId;
    @api materialNumber;
   


    showEtaTable = false;
    showRestockTable = false;

    etaMessage = '';
    restockMessage = '';

    error;

    @wire(getInventory, { materialNumber: '$materialNumber' })
    wiredInventory({ data, error }) {

        if (data) {
            console.log('Inventory Response:', JSON.stringify(data));

            if (data.ETA?.Message_Status === 'NODATA') {
                this.showEtaTable = false;
                this.etaInventory = [];
                this.etaMessage = 'ETA data not found';
            } else {
                const etaList = data.ETA?.ETA_Data || [];
                this.etaInventory = etaList.map((item, index) => ({
                    REC_REQD_QTY_ALT_UOM: item.REC_REQD_QTY_ALT_UOM,
                    AVAIL_DATE: item.AVAIL_DATE,
                    ROWNO: index + 1
                }));
                this.showEtaTable = this.etaInventory.length > 0;
                this.etaMessage = '';
            }

            if (data.RESTOCK?.Message_Status === 'NODATA' && data.RESTOCK?.RESTOCK_Data ==[]) {
                this.showRestockTable = false;
                this.restockData = [];
                this.restockMessage = 'Restock data not found';
            } else {
                const restockList = data.RESTOCK?.RESTOCK_Data || [];
                this.restockData = restockList.map((item, index) => ({
                    PO_NUMBER: item.PO_NUMBER?.trim(),
                    LINE_NUMBER: item.LINE_NUMBER,
                    REC_REQD_QTY_ALT_UOM: item.REC_REQD_QTY_ALT_UOM,
                    AVAIL_DATE: item.AVAIL_DATE,
                    ROWNO: index + 1
                }));
                this.showRestockTable = this.restockData.length > 0;
                this.restockMessage = '';
            }

            this.error = undefined;

        } else if (error) {
            console.error('Apex Error:', error);
            this.error = error;

            this.showEtaTable = false;
            this.showRestockTable = false;

            this.etaMessage = 'Unable to fetch ETA data';
            this.restockMessage = 'Unable to fetch Restock data';
        }
    }

    connectedCallback() {
        console.log('Quote Id from VF:', this.quoteId);
        console.log('Material Number from VF:', this.materialNumber);
       //  this.loadInventory();

    }
}
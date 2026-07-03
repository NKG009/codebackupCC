import { LightningElement } from 'lwc';

export default class RestockOrdersAndETA extends LightningElement {

  etaInventory = [
        {
            REC_REQD_QTY_ALT_UOM: 30,
            AVAIL_DATE: "2021-02-11T00:00:00.000Z",
            ROWNO: 1
        },
        {
            REC_REQD_QTY_ALT_UOM: 60,
            AVAIL_DATE: "2021-03-13T00:00:00.000Z",
            ROWNO: 2
        }
    ];

    restockData = [
        {
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
        }
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
}
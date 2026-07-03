import { LightningElement,api,track } from 'lwc';
import updateQuoteLineWarehouse from '@salesforce/apex/productselectorvfcontroller.updateQuoteLineWarehouse';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class WarehouseSelectionLWC extends LightningElement {
    @api recordId;
    @api quoteLineId;
    @api quoteId;   
    selectedWarehouse;
    selectedwarehousedata;


    @track lineInfo = {
        lineNumber: 2,
        size: 1,
        materialNumber: '01K1A3P061',
        kcaFigure: 'AKSZA'
    };
  @track warehouse=[{"MTR_Number":"01K1AF6110","WAREHOUSE_Data":[{"QTY":356,"WAREHOUSE_NAME":"STAFFORD","LGORT":"3008","ROWNO":1},{"QTY":90,"WAREHOUSE_NAME":"INTRASIT","LGORT":"3099","ROWNO":2},{"QTY":6,"WAREHOUSE_NAME":"DENSAND INC","LGORT":"30W0030","ROWNO":3},{"QTY":4,"WAREHOUSE_NAME":"R.D. KINCAIDE","LGORT":"30W0024","ROWNO":4},{"QTY":2,"WAREHOUSE_NAME":"SOUTHERN SPEC","LGORT":"30W0031","ROWNO":5},{"QTY":2,"WAREHOUSE_NAME":"WILLIAMS & ASSOCIATES","LGORT":"30W0003","ROWNO":6}]}];
    @track warehouseList = [];
    /*@track warehouseList = [
        { name: 'STAFFORD', number: '3008', location: 'Stafford, TX', qty: 12207 },
        { name: 'INTRASIT', number: '3099', location: 'INTRANSIT', qty: 3312 },
        { name: 'DENSAND INC', number: '30W0030', location: 'ENGLEWOOD, CO', qty: 79 },
        { name: 'SPOTSWOOD COTTON WELSH INC', number: '30W0035', location: 'Norcross', qty: 33 },
        { name: 'WILLIAMS & ASSOCIATES', number: '30W0003', location: 'BIRMINGHAM, AL', qty: 17 }
    ];*/


    connectedCallback() {
        console.log('Record Id received from VF:', this.recordId);
        console.log('quoteLineId Id received from VF:', this.quoteLineId);
        console.log('quoteId Id received from VF:', this.quoteId);
        this.warehouseList = this.warehouse[0].WAREHOUSE_Data.filter(wh => wh.WAREHOUSE_NAME !== 'INTRASIT').map(wh => ({
            id:wh.ROWNO,
            name: wh.WAREHOUSE_NAME,
            number: wh.LGORT,
            qty: wh.QTY,
            isSelected: wh.WAREHOUSE_NAME === 'STAFFORD' 
        }));
        this.selectedWarehouse = this.warehouseList.find(wh => wh.isSelected).id;
        console.log('Warehouse List:', JSON.stringify(this.warehouseList));
    }

    handleSelect(event) {
        console.log('Selected Warehouse Number:', event.currentTarget.dataset.id);
        const whNum = event.currentTarget.dataset.id;
        this.selectedWarehouse = whNum;

        this.warehouseList = this.warehouseList.map(wh => ({
            ...wh,
            isSelected: wh.id == whNum
        }));

        console.log('===handleSelectWarehouse List:', JSON.stringify(this.warehouseList));
       /* const selected = this.warehouseList.find(w => w.id === whNum);

        this.dispatchEvent(
            new CustomEvent('warehousesel', { detail: selected })
        );*/
    }
     
    handleOk() {
        if (!this.selectedWarehouse) {
            alert("Please select a warehouse");
            return;
        }
        console.log('Selected Warehouse to apply:', this.selectedWarehouse);
         this.selectedwarehousedata = this.warehouseList.find(
            w => w.id == this.selectedWarehouse
        );

        console.log('Selected Warehouse:', JSON.stringify(this.selectedwarehousedata));
        // ⭐ CPQ QLE update without Apex!
       window.parent.postMessage(
        {
            event: "LWC_TO_VF",
            qliId: this.quoteLineId,
            
        },
       "*" // restrict to same origin for security
    );

    window.top.postMessage(
        {
            event: "LWC_TO_VF",
            qliId: this.quoteLineId,
           
        },
       "*" // restrict to same origin for security
    );
        try {
             updateQuoteLineWarehouse({
                quoteLineId: this.quoteLineId,
                warehouseName: this.selectedwarehousedata.name,
                qty: this.selectedwarehousedata.qty
            });

            console.log('Quote Line updated successfully!');

        } catch (error) {
            console.error(error);
            alert('Error updating Quote Line');
        }

        //alert("Warehouse applied to Quote Line!");
       // window.close();
         this.dispatchEvent(new CloseActionScreenEvent());
    }
}
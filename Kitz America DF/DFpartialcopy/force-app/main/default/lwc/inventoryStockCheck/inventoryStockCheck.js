import { LightningElement, track } from 'lwc';
import searchProducts from '@salesforce/apex/InventoryStockCheckLWCController.searchProducts';
import getLocationStock from '@salesforce/apex/InventoryStockCheckLWCController.getLocationStock';

const COLUMNS = [
    { label: 'Product Name', fieldName: 'name' , type: "button",typeAttributes: {
            label: { fieldName: 'name' },
            name: 'open_modal',
            variant: 'base'   
        }},
    { label: 'Size (Inch)', fieldName: 'size' ,cellAttributes: { alignment: 'left' }},
    { label: 'List Price', fieldName: 'listPrice', type: 'currency' ,cellAttributes: { alignment: 'left' } },
    { label: 'Available Qty', fieldName: 'availableQty', type: 'number' ,cellAttributes: { alignment: 'left' }}
];

export default class InventoryStockCheck extends LightningElement {
    searchKey = '';
    columns = COLUMNS;

    @track data = [];
    @track isModalOpen = false;
    @track locationData = [];
    @track isLocationDataEmpty = false;
    @track locationSpinnerboolean = true;
    @track totalQty = 0;

    selectedProductId;

    @track productDetails = {
    caseLbs: 0.00,
    caseKgs: 0.00,
    caseQty: 0,

    boxLbs: 0.00,
    boxKgs: 0.00,
    boxQty: 0,

    unitLbs: 0.00,
    unitKgs: 0.00,
    

    country: ''
};

    handleInputChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        if (!this.searchKey) {
            alert('Please enter product name');
            return;
        }

        searchProducts({ searchKey: this.searchKey })
            .then(result => {
                this.data = result;
                console.log('Search Results: ', JSON.stringify(this.data));
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleRowAction(event) {
        console.log('onrowaction called');
        this.locationSpinnerboolean = true;
        const row = event.detail.row;
        console.log('Selected Row: ', JSON.stringify(row));
        let num = row.weightKg * 2.20462; 
        
        this.selectedProductId = row.productId;

        this.productDetails.unitKgs = parseFloat(row.weightKg.toFixed(4));
        this.productDetails.unitLbs = parseFloat((row.weightKg * 2.20462).toFixed(4));

        this.productDetails.boxKgs = parseFloat((row.weightKg * row.boxQty).toFixed(4));
        this.productDetails.boxLbs = parseFloat((row.weightKg * 2.20462 * row.boxQty).toFixed(4));
        this.productDetails.boxQty = row.boxQty;

        this.productDetails.caseKgs = parseFloat((row.weightKg * row.caseQty).toFixed(4));
        this.productDetails.caseLbs = parseFloat((row.weightKg * 2.20462 * row.caseQty).toFixed(4));
        this.productDetails.caseQty = row.caseQty;
        
        this.productDetails.country = row.mainPlantDesc;
       
        this.openModal(row.materialNum);
    }

    openModal(materialNum) {
        
        this.helpText = 'Loading location data...';
        this.isModalOpen = true;
        this.locationData = [];
        this.totalQty = 0;

        getLocationStock({ matnum: materialNum })
            .then(result => {
                if (result.length === 0) {
                    this.isLocationDataEmpty = true;
                } else {
                    this.isLocationDataEmpty = false;
                this.locationData = result;
                console.log('Location Stock: ', JSON.stringify(this.locationData));
                this.totalQty = result.reduce((sum, r) => sum + r.qty, 0);
                }
                this.locationSpinnerboolean = false;
            })
            .catch(error => {
                console.error(error);
                this.locationSpinnerboolean = false;
            });
    }

    closeModal() {
        this.isModalOpen = false;
        this.isLocationDataEmpty = false;
        this.locationSpinnerboolean = true;
    }
}
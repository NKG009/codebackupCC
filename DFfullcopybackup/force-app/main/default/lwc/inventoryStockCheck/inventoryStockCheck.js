import { LightningElement, track } from 'lwc';

export default class InventoryStockCheck extends LightningElement {
    @track searchKey = '';

    handleInputChange(event) {
        this.searchKey = event.target.value;
    }

 
    handleSearch() {
        console.log('Searching for:', this.searchKey);
    if (this.searchKey && this.searchKey.trim() !== '') {
      
        alert('This feature is under development. Please check back soon.');
    } else {
        alert('Please enter a product name or code before searching.');
    }
}

}
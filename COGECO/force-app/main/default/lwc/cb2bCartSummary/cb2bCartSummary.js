import B2bCartSummary from 'vlocity_cmt/b2bCartSummary';
import { LightningElement, wire, track } from "lwc";
 import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from "lightning/navigation";
 
import TOTAL_LABEL from "@salesforce/label/vlocity_cmt.CMEXTotal";
import ADD_PRODUCTS_LABEL from "@salesforce/label/vlocity_cmt.CMEXAddProducts";
import DISCOUNTS_AND_PROMOTIONS_LABEL from "@salesforce/label/vlocity_cmt.CMEXDiscountAndPromotions";
import CREATE_ORDERS_LABEL from "@salesforce/label/vlocity_cmt.CMEXCreateOrders";
import CLONE_QUOTE_LABEL from "@salesforce/label/vlocity_cmt.CMEXCloneQuoteAction";
import VIEW_RECORD_LABEL from "@salesforce/label/vlocity_cmt.CPQViewRecord";
 
const FIELDS = ["Quote.Total__c"];
 
export default class cb2bCartSummary extends B2bCartSummary {
    @track filteredItems = [];
    @track cartId;
    @track quoteRecord;
    labels = {
        TotalLabel: TOTAL_LABEL,
        addProductsLabel: ADD_PRODUCTS_LABEL,
        discountsAndPromotionsLabel: DISCOUNTS_AND_PROMOTIONS_LABEL,
        createOrdersLabel: CREATE_ORDERS_LABEL,
        cloneQuoteLabel: CLONE_QUOTE_LABEL,
        viewRecordLabel: VIEW_RECORD_LABEL
    };
 
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.cartId = currentPageReference.state.c__cartId;
        }
    };
 
    @wire(getRecord, { recordId: "$cartId", fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.quoteRecord = data;
        }
    }
 
    connectedCallback(){
        super.connectedCallback();
 
        this.nList = this.route.Quote;
        this.filteredItems = this.actionList.filter(item => item.label !== 'Create Proposal');
    }
   
    navigateToQuote() {
        const queryParams = new URL(window.location.href).searchParams;
        const cartId = queryParams.get('c__cartId');
 
        if (cartId) {        
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: cartId,
                    objectApiName: 'Quote',
                    actionName: 'view'
                }
            });
        }    
    }
    //open clone quote model.
    cloneQuote() {
        
        this.cartId = this.route.Quote.id;
       
        this.template.querySelector("vlocity_cmt-b2b-clone-quote-modal").openModal();
        
    }
}
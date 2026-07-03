import { LightningElement } from 'lwc';
import LABORCODE from '@salesforce/schema/Labor_Codes__c';
import PRICE from '@salesforce/schema/Labor_Codes__c.Price__c';
import QUANTITY from '@salesforce/schema/Labor_Codes__c.Quantity__c';
import SERVICECONTRACT from '@salesforce/schema/Labor_Codes__c.Service_Appointment__c';
import PRODUCT from '@salesforce/schema/Labor_Codes__c.Product__c';
export default class LaborCodeProducts extends LightningElement {

    objectName = LABORCODE;
    fieldList = [PRICE, QUANTITY, SERVICECONTRACT, PRODUCT];
    

}
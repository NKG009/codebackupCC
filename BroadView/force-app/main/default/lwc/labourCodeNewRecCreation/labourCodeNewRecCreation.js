import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Getrec from '@salesforce/apex/labourCodeNewRecCreationController.Getrecorddetail';
import Createlabourrec from '@salesforce/apex/labourCodeNewRecCreationController.Createlabourrec';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class LabourCodeNewRecCreation extends NavigationMixin(LightningElement){
    @track notfixed;
    @track firstmod;
    @track secondmod;
    @api recordId;
    @api objectApiName;
    contacts;
    error;
    productid;
    @track Slineitemid;
    Noofhours=0;
    @track LCrecname;
    Name='xyz';
    @track selectOptions = [];

    
  // initialize component
  connectedCallback() {
    this.notfixed =false;
    this.firstmod=true;
    this.secondmod=false;
  }


    @wire(Getrec, { recordId: '$recordId' })
    recorddetails ({ error, data }) {
        if (data) {
            
            this.contacts = data;
            console.log('data'+JSON.stringify(this.contacts));
            for(const list of data.ContractLineItems){
                console.log('listitem'+list.Product2Id);
                console.log('listitemdata'+JSON.stringify(list.Product2));

                const option = {
                    label: list.Product2.Name,
                    value: list.Product2Id
                };
                // this.selectOptions.push(option);
                this.selectOptions = [ ...this.selectOptions, option ];
            }
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
            console.log('errer');
        }
    }

    handleChange(event) {
        this.productid = event.detail.value;
        
        console.log('this.productid'+this.productid);
        for(const list of  this.contacts.ContractLineItems){
            console.log('list.Product2.Fixed__c'+list.Product2.Fixed__c); 
            if(this.productid ==list.Product2.Id ){
                this.Slineitemid=list.Id;
                if(list.Product2.Fixed__c=='NO'){
               this.notfixed=true;
                }
                else{
                    this.notfixed=false; 
                }
            }
            
        }
        console.log(' this.notfixed'+ this.notfixed);  

    }
  
    handlehours(event) {
        this.Noofhours = event.detail.value;
    }

    closeModal() {

        console.log('closein');
        let ev = new CustomEvent('childmethod'
                                );
            this.dispatchEvent(ev);   
        //this.dispatchEvent(new CloseActionScreenEvent());
       // window.location.reload();
        
        }
     
        async SaveRecord(){
        console.log('insave'+this.recordId+this.productid +this.Slineitemid +this.Noofhours);
        Createlabourrec({ recordId: this.recordId, prodid :this.productid ,Slitemid :this.Slineitemid, hours:this.Noofhours })
            .then((result) => {
                console.log('result'+JSON.stringify(result));
                this.firstmod=false;
                this.secondmod=true;
                this.LCrecname=result.Name;
                
                // dispatching custom event to aura On Save of Records
                let saverec = new CustomEvent('savrecmethod',{
                detail: { data:this.LCrecname }
                });
                 this.dispatchEvent(saverec);
                 
                /*this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.Id,
                        objectApiName: 'Labor_Codes__c',
                        actionName: 'view'
                    },
                });
                this.dispatchEvent(new CloseActionScreenEvent());
                this.dispatchEvent(
                new ShowToastEvent({
                title: 'Success',
                message: 'Labor Code Record created',
                variant: 'success'
               })
               );*/
               
            })
            .catch((error) => {
               
            });

    }

    /*navigateToViewAccountPage() {
        console.log('naviagtion')
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.LCrecname,
                objectApiName: 'Labor_Codes__c',
                actionName: 'view'
            },
        });
    }*/
    
}
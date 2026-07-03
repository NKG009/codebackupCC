import { LightningElement,api,wire,track } from 'lwc';
import createreq from '@salesforce/apex/chatterPostMacrosLWCController.postchatterrequest';
import getpklistvalue from '@salesforce/apex/chatterPostMacrosLWCController.Getpicklistval';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import LightningAlert from 'lightning/alert';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ChatterPostMacrosLWC extends LightningElement {
    @api recordId;
    //value='';
    options=[];

   /* get options() {
        return [
            { label: 'choose one...', value: '' },
            { label: 'one', value: '1' },
            { label: 'two', value: '2' },
            { label: 'three', value: '3' },
        ];
    }*/

    @wire(getpklistvalue)
    setpicklistval({error,data}){
        if(data){
            console.log('data picklist:'+JSON.stringify(data));
           /* for(var i in data){
                this.options.push({label:data[i].MasterLabel, value:data[i].MasterLabel});

            }*/
            this.options = data.map( data => {
                return {
                    label: `${data.MasterLabel}`,
                    value: `${data.MasterLabel}`
                };
            });
         console.log('optionsdebugggers2:'+ JSON.stringify(this.options));
        }

    }

    handleChange(event) {
        this.value = event.detail.value;
        console.log('this.value:'+this.value);
        console.log('this.recordId:'+this.recordId);
    }

    handleSend(){
        createreq({recordid:this.recordId , optionval:this.value})
        .then((result) =>{
            if(result !=null ){
            console.log('result:'+result);
            this.dispatchEvent(
                new ShowToastEvent({
                title: 'Success',
                message: 'Macros Posted Successfully',
                variant: 'success'
               })
               );
            this.dispatchEvent(new RefreshEvent());
            this.dispatchEvent(new CloseActionScreenEvent());
            }     
           else{
            LightningAlert.open({
                message: 'Something Went Wrong',
                theme: 'error', 
                label: 'Error!',
            });
           } 

        })
        .catch((error) => {
           
               
        });
;

    }
    closeModal(){
        this.dispatchEvent(new CloseActionScreenEvent());

    }
}
import { LightningElement, track } from 'lwc';
import UpdateCreditStatusBatch from '@salesforce/apex/CredentialStatusUpdateBatchController.runBatch';

export default class Tr_credentialBatchRunner extends LightningElement {
 
    @track showConfirm = false;
    @track message;


    handleClick(event){
        event.preventDefault();
        this.showConfirm = true;
        console.log('handle click called' +this.showConfirm);
    }

    handleConfirm(event) {
        event.preventDefault();
        UpdateCreditStatusBatch()
        .then((result) => {
            this.message = result;
            setTimeout(() => {
                window.location.reload();
            }, 3000);
        })
        .catch((error) => {
            this.message = 'Error initiating batch job: ' + error.body.message;
        });
        console.log('message'+message);

    }

    handleCancel(){
        this.showConfirm = false;

    }
}
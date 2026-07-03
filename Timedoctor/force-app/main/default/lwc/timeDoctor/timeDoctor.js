import { LightningElement, wire, api } from 'lwc';
import datalist from '@salesforce/apex/TimeDoctorResponse.response';
import { getRecord } from 'lightning/uiRecordApi';
import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import TimeDoctorLogo from '@salesforce/resourceUrl/TimeDoctorLogo';
import LightningAlert from 'lightning/alert';


const columns = [
    { label: 'User Email', fieldName: 'UserId' },
    { label: 'Start Time', fieldName: 'StartTime' },
    { label: 'End Time', fieldName: 'EndTime' },
    { label: 'Total Time', fieldName: 'TotalTime' },
    
];

export default class TimeDoctor extends LightningElement {

    @api recordId;
    @api objectApiName;
    data;
    columns = columns;
    datatableshow=false;
    Spinnerboolean=false;
    TDlogo = TimeDoctorLogo;

    
    connectedCallback(){
        this.Spinnerboolean=true;
        //this.datatableshow=true;
        console.log('here button clicked'+this.recordId);
        datalist({recordid:this.recordId ,Objname:this.objectApiName})
        .then((result) => {
            if(result != null){
            this.data=result;
            this.Spinnerboolean=false;
            this.datatableshow=true;
            console.log('result'+JSON.stringify(result));
            //console.log('result'+JSON.stringify(result[0].EndTime));
            console.log('result'+JSON.stringify(this.data));
            }
            else{
                this.Spinnerboolean=false;
                console.log('inside else');
                LightningAlert.open({
                    message: 'No time has been logged yet',
                    theme: 'warning', 
                    label: 'Warning!!',
                });
                 

            }
        })
        .catch((error) => {
            console.log('inside Error Block');
            this.Spinnerboolean=false;
            LightningAlert.open({
                message: 'Something Went Wrong',
                theme: 'error', 
                label: 'Error!',
            });
               
        });

    }

}
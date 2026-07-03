import { LightningElement, wire, api,track } from 'lwc';
import getsubmittedcandidates from '@salesforce/apex/PortalV2MyCandidatesController.getAllSubmittedCandidates';

export default class YourLWCComponent extends LightningElement {
    @api joborderdetaildata;
    allSubmittedCandidateRecords;
    error;
    @track searchString;
    @track initialRecords;

    SubmittedCandidatecolumns = [
    {
        label: 'Name',
        fieldName: 'ContactLink',
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'Name' },
            target: '_self'  // Opens in a new tab
        }
    },
    {
        label: 'Mobile',
        fieldName: 'MobilePhone',
        type: 'phone'
    },
    {
        label: 'Email',
        fieldName: 'Email',
        type: 'email'
    },
    /*{
        label: 'Date Submitted',
        fieldName: 'CreatedDate',
        type: 'date'
    },
    {
        label: 'Job Order',
        fieldName: 'JobOrderLink',
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'JobOrderName' },  // Assuming you have a name for the Job Order
            target: '_self'
        }
    },
    {
        label: 'Job Order',
        fieldName: 'JobOrderName',
        type: 'text',
        
    },*/
    {
        label: 'Created Date',
        fieldName: 'CreatedDate',
        type: 'date',
        
    },
   /* {
        label: 'Status',
        fieldName: 'Status__c',
        type: 'text',
        cellAttributes: { class: { fieldName: 'statusColor' } }
    }*/
];


    @wire(getsubmittedcandidates)
    wiredCandidates({ error, data }) {
        if (data) {
            console.log("getsubmittedcandidates: " + JSON.stringify(data));
            this.allSubmittedCandidateRecords = data.map(record => ({
                ...record,
                // ContactName: record.Contact__r.Name,
                // ContactMobilePhone: record.Contact__r.MobilePhone,
                // ContactEmail: record.Contact__r.Email,
                ContactLink: '/detail/' + record.Id 
                // JobOrderName: record.Job_Order__r.Name,
                // JobOrderLink: '/detail/' + record.Job_Order__c,  // Link to job order record in community
                // statusColor: this.getStatusColor(record.Status__c),
                // concreateddate:record.Contact__r.CreatedDate
            }));
            this.error = undefined;
            this.initialRecords=this.allSubmittedCandidateRecords;
        } else if (error) {
            console.log("Error in fetching candidates: ", error);
            this.error = error;
            this.allSubmittedCandidateRecords = undefined;
        }
    }

    getStatusColor(status) {
        switch (status) {
            case 'In Review':
                return 'slds-theme_warning';  // Custom CSS class for 'In Review'
            case 'Progressed':
                return 'slds-theme_success';  // Custom CSS class for 'Progressed'
            case 'Submitted':
                return 'slds-theme_inverse';  // Custom CSS class for 'Submitted'.slds-theme_error
            case 'Rejected':
                return 'slds-theme_error';  // Custom CSS class for 'Rejected' slds-theme_success
            case 'Accepted':
             return 'slds-theme_success';
            default:
                return '';
        }
    }

    
    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
 
        if (searchKey) {
            this.allSubmittedCandidateRecords = this.initialRecords;
 
            if (this.allSubmittedCandidateRecords) {
                let searchRecords = [];
 
                for (let record of this.allSubmittedCandidateRecords) {
                    let valuesArray = Object.values(record);
 
                    for (let val of valuesArray) {
                        console.log('val is ' + val);
                        let strVal = String(val);
 
                        if (strVal) {
 
                            if (strVal.toLowerCase().includes(searchKey)) {
                                searchRecords.push(record);
                                break;
                            }
                        }
                    }
                }
 
                console.log('Matched Accounts are ' + JSON.stringify(searchRecords));
                this.allSubmittedCandidateRecords = searchRecords;
            }
        } else {
            this.allSubmittedCandidateRecords = this.initialRecords;
        }
    }
  
}
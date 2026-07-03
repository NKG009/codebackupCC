import { LightningElement, track, wire, api } from 'lwc';
import getAllSubmittedCandidatesForJobOrder from '@salesforce/apex/VMSJobOrderResponseController.getAllSubmittedCandidatesForJobOrder';
import updateCandidateStatus from '@salesforce/apex/VMSJobOrderResponseController.updateCandidateStatus';
import LightningAlert from 'lightning/alert';

import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getCookie, setCookie } from "c/utility";




export default class VmsJobOrderResponse extends LightningElement {

    @track getJobOrderAllCandidatesRecords = [];
    parsedData = [];
  filteredParsedData = [];
    @track selectedCandidateIds = [];
    @track buttondisabled=true;
    wiredJobOrderCandidatesResult;
    isloading=false;
    @track candidatedatatobeprocessed=[];
    @track statusOptions = [
      { label: 'All', value: 'All' },
      { label: 'Submitted', value: 'Submitted' },
      { label: 'Accepted', value: 'Accepted' },
      { label: 'Rejected', value: 'Rejected' }
  ];
  @track selectedStatus = 'Submitted';
    
    



    @track JobOrderAllCandidatescolumns = [
        { label: 'Candidate Name', fieldName: 'candidateUrl', type: 'url', typeAttributes: { label: { fieldName: 'candidateName' }, target: '_blank' } },
        { label: 'Account', fieldName: 'accountUrl', type: 'url', typeAttributes: { label: { fieldName: 'accountName' }, target: '_blank' } },
        { label: 'Job Order', fieldName: 'jobOrderUrl', type: 'url', typeAttributes: { label: { fieldName: 'jobOrderName' }, target: '_blank' } },
        { label: 'Job Order Number', fieldName: 'jobOrderNumber', type: 'text' },
        { label: 'Minimum Requirement', fieldName: 'jobRoleminimum', type: 'number' },
        { label: 'Job Role', fieldName: 'jobRoleUrl', type: 'url', typeAttributes: { label: { fieldName: 'jobRoleName' }, target: '_blank' } },
        { label: 'Site', fieldName: 'siteUrl', type: 'url', typeAttributes: { label: { fieldName: 'siteName' }, target: '_blank' } },
        { label: 'Supplier Agency', fieldName: 'supplierAgencyUrl', type: 'url', typeAttributes: { label: { fieldName: 'supplierAgencyName' }, target: '_blank' } },
        { label: 'Job Owner', fieldName: 'jobOwnerUrl', type: 'url', typeAttributes: { label: { fieldName: 'jobOwnerName' }, target: '_blank' } },
        { label: 'Job Order Date', fieldName: 'jobOrderDate', type: 'date' },
        { label: 'Competencies to be Verified', fieldName: 'competencies', type: 'text' },
        { label: 'Status', fieldName: 'status', type: 'text' }
    ];

   
    accountFilter ;
    siteFilter ;
    jobRoleFilter;
    supplierAgencyFilter;
    shiftOwnerFilter;

    filterFields = {
        shiftOwner: {
          fields: ["Name", "Brand__c"],
          displayFields: "Name, Brand__c"
        },
        jobRole: {
          fields: ["Name", "Job_Category_Text__c"],
          displayFields: "Name, Job_Category_Text__c"
        },
        site: {
          fields: ["Name", "Brand__c"],
          displayFields: "Name, Brand__c"
        },
        account: {
          fields: ["Name", "Brand__c"],
          displayFields: "Name,Brand__c"
        }
      };
    


    // Fetch data
    @wire(getAllSubmittedCandidatesForJobOrder)
    wireddata(response) {
        this.wiredJobOrderCandidatesResult = response;
        const { data, error } = response;
        if (data) {
            this.getJobOrderAllCandidatesRecords=data;
            this.flattenData();
            this.filterTable();
            this.filterRecords();
            console.log('Raw Data: ', JSON.stringify(data));
           
            
        } else if (error) {
            console.error('Error fetching job data', error);
        }

        console.log(
            "getAllSubmittedCandidatesForJobOrder: " + JSON.stringify(this.getJobOrderAllCandidatesRecords));
    }


    flattenData() {
        const outputData = [];

        this.getJobOrderAllCandidatesRecords.forEach((candidateWrapper) => {
            let flattenedRecord = {
            Id: candidateWrapper.candidate.Id,
            candidateUrl: candidateWrapper.candidate.Contact__r ? `/lightning/r/Contact/${candidateWrapper.candidate.Contact__r.Id}/view` : '',
            candidateName: candidateWrapper.candidate.Contact__r ? candidateWrapper.candidate.Contact__r.Name : '',
            candidatedata:candidateWrapper.candidate.Contact__r? candidateWrapper.candidate.Contact__r : '',
           
            
            accountUrl: candidateWrapper.candidate.Job_Order__r.sirenum__Account__r ? `/lightning/r/Account/${candidateWrapper.candidate.Job_Order__r.sirenum__Account__r.Id}/view` : '',
            accountName: candidateWrapper.candidate.Job_Order__r.sirenum__Account__r ? candidateWrapper.candidate.Job_Order__r.sirenum__Account__r.Name : '',
            joaccount:  candidateWrapper.candidate.Job_Order__r.sirenum__Account__r ? candidateWrapper.candidate.Job_Order__r.sirenum__Account__r.Id :'',

            jobOrderUrl: candidateWrapper.candidate.Job_Order__r ? `/lightning/r/joborder/${candidateWrapper.candidate.Job_Order__r.Id}/view` : '',
            jobOrderName:candidateWrapper.candidate.Job_Order__r ?  candidateWrapper.candidate.Job_Order__r.Name : '',
            jobOrder:candidateWrapper.candidate.Job_Order__r ? candidateWrapper.candidate.Job_Order__r.Id :'',
            jobRoleminimum: candidateWrapper.candidate.Job_Order__r? candidateWrapper.candidate.Job_Order__r.Total_Resource_Required__c:'',
            jobOrderNumber:candidateWrapper.candidate.Job_Order__r ? candidateWrapper.candidate.Job_Order__r.Job_Order_Number__c:'' ,
            

            jobRoleUrl: candidateWrapper.candidate.Job_Order__r.sirenum__JobRole__r ? `/lightning/r/JobRole/${candidateWrapper.candidate.Job_Order__r.sirenum__JobRole__r.Id}/view` : '',
            jobRoleName: candidateWrapper.candidate.Job_Order__r.sirenum__JobRole__r ? candidateWrapper.candidate.Job_Order__r.sirenum__JobRole__r.Name : '',
            jobRole: candidateWrapper.candidate.Job_Order__r.sirenum__JobRole__r ? candidateWrapper.candidate.Job_Order__r.sirenum__JobRole__r.Id : '',
            


            siteUrl: candidateWrapper.candidate.Job_Order__r.sirenum__Site__r ? `/lightning/r/Site/${candidateWrapper.candidate.Job_Order__r.sirenum__Site__r.Id}/view` : '',
            siteName: candidateWrapper.candidate.Job_Order__r.sirenum__Site__r ? candidateWrapper.candidate.Job_Order__r.sirenum__Site__r.Name : '',
            site:candidateWrapper.candidate.Job_Order__r.sirenum__Site__r ? candidateWrapper.candidate.Job_Order__r.sirenum__Site__r.Id:'',

            supplierAgencyUrl: candidateWrapper.candidate.Submitted_By__r ? `/lightning/r/Account/${candidateWrapper.candidate.Submitted_By__r.Contact.Account.Id}/view` : '',
            supplierAgencyName: candidateWrapper.candidate.Submitted_By__r ? candidateWrapper.candidate.Submitted_By__r.Contact.Account.Name : '',
            supplierAgency:candidateWrapper.candidate.Submitted_By__r ?candidateWrapper.candidate.Submitted_By__r.Contact.Account.Id:'',
            supplierContactdata:candidateWrapper.candidate.Submitted_By__r ? candidateWrapper.candidate.Submitted_By__r.Contact :'',
           


            jobOwnerUrl: candidateWrapper.candidate.Job_Order__r.Owner ? `/lightning/r/User/${candidateWrapper.candidate.Job_Order__r.Owner.Id}/view` : '',  //shiftowner
            jobOwnerName: candidateWrapper.candidate.Job_Order__r.Owner ? candidateWrapper.candidate.Job_Order__r.Owner.Name : '',
            jobOwnerEmail: candidateWrapper.candidate.Job_Order__r.Owner ? candidateWrapper.candidate.Job_Order__r.Owner.Email :'',
            shiftOwner:candidateWrapper.candidate.Job_Order__r.Owner ? candidateWrapper.candidate.Job_Order__r.Owner.Id:'',
            

            jobOrderDate: candidateWrapper.candidate.Job_Order__r ? candidateWrapper.candidate.Job_Order__r.CreatedDate : '',
            status: candidateWrapper.candidate.Status__c,
            competencies: candidateWrapper.ticketStatus
            };
            outputData.push(flattenedRecord);
        });
    
    
        this.parsedData = outputData;
        this.filteredParsedData = outputData;
        this.loading = false;
        console.log('filteredParsedData:'+ JSON.stringify(this.filteredParsedData))
      
      
      }

    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
        this.filterRecords();
    }

    filterRecords() {
        if (this.selectedStatus === 'All') {
          this.filteredParsedData = [...this.parsedData];
        } else {
            this.filteredParsedData = this.parsedData.filter(record => record.status === this.selectedStatus);
        }
    }
      
      filterTable() {
        this.filteredParsedData = [...this.parsedData];
        if (this.accountFilter !== undefined) {
            this.filteredParsedData = this.filteredParsedData.filter((record) => {
              return record.joaccount === this.accountFilter.Id;
            });
          }
        if (this.siteFilter !== undefined) {
          this.filteredParsedData = this.filteredParsedData.filter((record) => {
            return record.site === this.siteFilter.Id;
          });
        }
        
        if (this.jobRoleFilter) {
          this.filteredParsedData = this.filteredParsedData.filter((record) => {
            return record.jobRole === this.jobRoleFilter.Id;
          });
        }
        if (this.supplierAgencyFilter !== undefined) {
            this.filteredParsedData = this.filteredParsedData.filter((record) => {
              return record.supplierAgency === this.supplierAgencyFilter.Id;
            });
          }
          if (this.shiftOwnerFilter !== undefined) {
            this.filteredParsedData = this.filteredParsedData.filter((record) => {
              return record.shiftOwner === this.shiftOwnerFilter.Id;
            });
          }
      }
    
      connectedCallback() {
        const accountFilterCookie = getCookie("accountFilter");
        const shiftOwnerFilterCookie = getCookie("shiftOwnerFilter");
        const jobRoleFilterFilterCookie = getCookie("jobRoleFilter");
        const siteFilterCookie = getCookie("siteFilter");
        const supplierAgencyFilterCookie = getCookie("supplierAgencyFilter");
    
        this.accountFilterCookie =
        accountFilterCookie !== ""
            ? JSON.parse(accountFilterCookie)
            : undefined;
        this.shiftOwnerFilter =
          shiftOwnerFilterCookie !== ""
            ? JSON.parse(shiftOwnerFilterCookie)
            : undefined;
        this.jobRoleFilter =
          jobRoleFilterFilterCookie !== ""
            ? JSON.parse(jobRoleFilterFilterCookie)
            : undefined;
        this.siteFilterCookie =
        siteFilterCookie !== ""
            ? JSON.parse(siteFilterCookie)
            : undefined;
        this.supplierAgencyFilterCookie =
        supplierAgencyFilterCookie !== ""
            ? JSON.parse(supplierAgencyFilterCookie)
            : undefined;
      }


      get shiftOwnerFields() {
        return this.filterFields.shiftOwner.fields;
      }
    
      get shiftOwnerDisplayFields() {
        return this.filterFields.shiftOwner.displayFields;
      }
    
      get supplierAgencyFields() {
        return this.filterFields.account.fields;
      }
    
      get supplierAgencyDisplayFields() {
        return this.filterFields.account.displayFields;
      }
    
      get jobRoleFields() {
        return this.filterFields.jobRole.fields;
      }
    
      get jobRoleDisplayFields() {
        return this.filterFields.jobRole.displayFields;
      }
    
      get siteFields() {
        return this.filterFields.site.fields;
      }
    
      get siteDisplayFields() {
        return this.filterFields.site.displayFields;
      }
    
      get accountFields() {
        return this.filterFields.account.fields;
      }
    
      get accountDisplayFields() {
        return this.filterFields.account.displayFields;
      }
    
    
   
    // Capture selected rows
    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
          this.selectedCandidateIds = selectedRows.map(row => row.Id); 
        console.log('Selected Row IDs: ', JSON.stringify(this.selectedCandidateIds));
        this.buttondisabled = this.selectedCandidateIds.length === 0 ? true : false;
         
    }

    handleAccept() {
        console.log('inside handleAccept');
        this.buttondisabled=true;
        this.updateCandidates('Accepted');
    }

    // Handle Reject button click
    handleReject() {
       this.buttondisabled=true;
        this.updateCandidates('Rejected');
    }

    // Function to update the status field for selected candidate records
    updateCandidates(status) {
        this.isloading=true;
        this.candidatedatatobeprocessed = [];
        this.filteredParsedData.forEach(element => {
            if (this.selectedCandidateIds.includes(element.Id)) {
                this.candidatedatatobeprocessed.push(element);
            }
        });

        

       
        console.log('inside updateCandidates'+ this.candidatedatatobeprocessed.length);
        // Call the Apex method
        updateCandidateStatus({ candidaterecords: this.candidatedatatobeprocessed, status: status })
            .then(() => {
                this.showToast('Success', `Candidates have been ${status} successfully`, 'success');

                this.selectedCandidateIds = [];
                this.candidatedatatobeprocessed = [];
            
            // Clear the selected rows in the datatable
            const datatable = this.template.querySelector('lightning-datatable');
            if (datatable) {
                datatable.selectedRows = [];
            }
            
            refreshApex(this.wiredJobOrderCandidatesResult);
            this.isloading=false;  
            })
            .catch(error => {
                console.log('error:'+ JSON.stringify(error));
                this.isloading=false; 
                console.log('error on updateCandidateStatus: '+ error.body.message);
                this.showToast('Error', JSON.stringify(error), 'error');
            });
    }
    

    // Function to show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }

    handleShiftOwnerLookup(event) {
        if (event.detail.data === undefined) {
          setCookie("shiftOwnerFilter", "", 1000);
    
          this.shiftOwnerFilter = undefined;
          this.filterTable();
          return;
        }
        const { record } = event.detail?.data;
        this.shiftOwnerFilter = record;
        setCookie("shiftOwnerFilter", JSON.stringify(record), 1000);
        this.filterTable();
      }
      handleSupplierAgencyLookup(event) {
        if (event.detail.data === undefined) {
          setCookie("supplierAgencyFilter", "", 1000);
    
          this.supplierAgencyFilter = undefined;
          this.filterTable();
          return;
        }
        const { record } = event.detail?.data;
        this.supplierAgencyFilter = record;
        setCookie("supplierAgencyFilter", JSON.stringify(record), 1000);
        this.filterTable();
      }
      handleJobRoleLookup(event) {
        if (event.detail.data === undefined) {
          setCookie("jobRoleFilter", "", 1000);
    
          this.jobRoleFilter = undefined;
          this.filterTable();
          return;
        }
        const { record } = event.detail?.data;
        this.jobRoleFilter = record;
        setCookie("jobRoleFilter", JSON.stringify(record), 1000);
        this.filterTable();
      }
      handleSiteLookup(event) {
        if (event.detail.data === undefined) {
          setCookie("siteFilter", "", 1000);
    
          this.siteFilter = undefined;
          this.filterTable();
          return;
        }
        const { record } = event.detail?.data;
        this.siteFilter = record;
        setCookie("siteFilter", JSON.stringify(record), 1000);
        this.filterTable();
      }
      handleAccountLookup(event) {
        if (event.detail.data === undefined) {
          setCookie("accountFilter", "", 1000);
    
          this.accountFilter = undefined;
          this.filterTable();
          return;
        }
        const { record } = event.detail?.data;
        this.accountFilter = record;
        setCookie("accountFilter", JSON.stringify(record), 1000);
        this.filterTable();
      }
     
      
      

}
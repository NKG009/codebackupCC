import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';import getprefilldata from '@salesforce/apex/LWCFormControllerutilityclass.getprefilldata';
import getformJSON from  '@salesforce/apex/LWCFormControllerutilityclass.getformJSON';
import createupdateFormRecord from  '@salesforce/apex/LWCFormControllerutilityclass.createupdateFormRecord';

export default class RepairManChecklistForm extends LightningElement {
    
    @api recordId;
    @track formType = 'Repairman Checklist Form';
    @track isloading = true;
    @track formid = '';
    @track IsPDFGenerated = false;
    @track showConfirmation = false;

    @track clientAddress = '';
    @track clientCity = '';
    @track clientState = '';
    @track clientZipCode = '';
    @track date = '';
    @track email = 'Fundamentalroofingllc@gmail.com';
    @track inspectionYield=[];// final fomat of inspectionYield JSON[{"id":"","value": "", "isChecked": false,"isfileuploaded":false, "files": []}];

    
    connectedCallback() {
        // this.isloading = false;
        setTimeout(() => {
            this.getFormdetails();
            
        }, 2000);
       


    }

     get formJson() {
        return JSON.stringify({
            GeneralInformation: [
                { id: 1, label: 'Date', value: this.date, type: 'Date' },
                { id: 4, label: 'Client Address', value: this.clientAddress, type: 'Text' },
                { id: 6, label: 'City', value: this.clientCity, type: 'Text' },
                { id: 9, label: 'State', value: this.clientState, type: 'Text' },
                { id: 8, label: 'Zip Code', value: this.clientZipCode, type: 'number' },
                { id: 7, label: 'Form Type', value: this.formType, type: 'picklist' },
                 { id: 6, label: 'Email', value: this.email, type: 'Email' },
            { id: 7, label: 'Notes', value: this.notes, type: 'TextArea' },
                
            ],

             inspectionYield: this.inspectionYield || [],
        });
    }

    getFormdetails(event) {
        console.log('getFormdetails recordid:' + this.recordId);
         this.fetchFormDetails(this.recordId, this.formType)
        .then(result => {
             if (result) {
                 console.log('inside if');
                    this.formid = result.Id;
                    this.loadFromJson(result.Form_JSON__c);
                    this.IsPDFGenerated = result.IsPDFGenerated__c;
            } else {
                 console.log('inside else');
                this.prefillformdata();
            }
        })
        .catch(error => {
                this.isloading = false;
                console.error(error);
            });
        }

     fetchFormDetails(recordId, formType) {
        console.log('fetchFormDetails recordId:', recordId);

        return getformJSON({ OpprecordId: recordId, formType: formType })
            .then(result => {
                console.log('getformJSON result:', JSON.stringify(result));
                if (result) {
                    return result;
                } else {
                    return null;
                }
            })
            .catch(error => {
                console.error('Error fetching form details:', error);
                throw error; // re-throw to handle in caller
            });
    }

    prefillformdata() {
        console.log('prefillformdata :');

        getprefilldata({ OpprecordId: this.recordId })
            .then(result => {
                console.log('getprefilldata', JSON.stringify(result));
                if (result) {
                  //  this.clientFirstName = result?.Contact?.FirstName || '';
                  //  this.clientLastName = result?.Contact?.LastName || '';
                   // this.clientEmail = result?.Contact?.Email || '';
                    this.clientAddress = result?.Contact?.Account?.BillingAddress?.street || '';
                    this.clientCity = result?.Contact?.Account?.BillingAddress?.city || '';
                    this.clientState = result?.Contact?.Account?.BillingAddress?.state || '';
                    this.clientZipCode = result?.Contact?.Account?.BillingAddress?.postalCode || '';
                  //  this.clientPhone = result?.Contact?.Phone || '';
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1).padStart(2, '0');
                    const day = String(today.getDate()).padStart(2, '0');
                    this.date = `${year}-${month}-${day}`;
                    // getting inspectionYield from inspection form if exist
                    this.fetchFormDetails(this.recordId, 'Repair Inspection Form')
                        .then(result => {
                            if (result) {
                                console.log('inside getting repair item from inspection form if exist:');
                               const data = JSON.parse(result.Form_JSON__c);
                                if (data.inspectionYield) {
                                    this.inspectionYield = data.inspectionYield;
                                }
                            }
                            else{
                                this.showToast('Info', 'No previous Inspection Form found to prefill Repairman Checklist Form.', 'info');
                            }
                        });
                }
                this.isloading = false;
                //this.loadform=true;
            })
            .catch(error => {
                this.isloading = false;
                console.error(error);
            });

    }

    loadFromJson(jsonString) {
        try {
            const data = JSON.parse(jsonString);


            if (data.GeneralInformation) {
                data.GeneralInformation.forEach(field => {
                    switch (field.label) {
                       // case 'Client Last Name': this.clientLastName = field.value; break;
                      //  case 'Client First Name': this.clientFirstName = field.value; break;
                        case 'Client Address': this.clientAddress = field.value; break;
                        case 'City': this.clientCity = field.value; break;
                        case 'State': this.clientState = field.value; break;
                        case 'Zip Code': this.clientZipCode = field.value; break;
                       // case 'Client Email': this.clientEmail = field.value; break;
                        case 'Email': this.email = field.value; break;
                        case 'Notes': this.notes = field.value; break;
                        default: console.warn(`Unmapped field: ${field.label}`);
                    }
                });
            }

            if (data.inspectionYield) {
                this.inspectionYield = data.inspectionYield;
            }

           
          
            this.isloading = false;

        } catch (error) {
            this.isloading = false;
            console.error('Invalid JSON string provided', error);
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;

        this[field] = value;

    }

        handleInspectionFieldChange(event) {
        const blockId = event.target.dataset.id;
        const newValue = event.target.checked;
        console.log('handleInspectionFieldChange called:', blockId, newValue);
        this.inspectionYield = this.inspectionYield.map(f => {
            if (f.id === blockId) {
                console.log('Updating inspection field id:', blockId, 'with new value:', newValue);
                return { ...f, isChecked: newValue };
            }
            return f;
        });
    }

 handleFileUpload(event) {
        console.log('Files uploaded:', JSON.stringify(event.detail.files));
        const blockId =event.target.dataset.id;
        const uploadedFiles = event.detail.files;
        const block = this.inspectionYield.find(b => b.id === blockId);
                
        try {
          /*  if (!Array.isArray(checklistItem.files)) {
            checklistItem.files = [];

        }
        uploadedFiles.forEach(file => {
            checklistItem.files.push({
                fileName: file.name,
                fileUrl: '/sfc/servlet.shepherd/version/download/' + file.contentVersionId
            });
        });

                checklistItem.isfileuploaded = true;*/

            if (uploadedFiles.length > 0) {
                block.isfileuploaded = true;
                for (var i in uploadedFiles) {
                    if (block.files.length == 0) {
                        block.files = [];
                    }
                    var file = {};
                    file.id = uploadedFiles[i].documentId;
                    file.fileName = uploadedFiles[i].name;
                    file.fileUrl = '/sfc/servlet.shepherd/version/download/' + uploadedFiles[i].contentVersionId;
                    block.files.push(file);
                }
                this.showToast('Success', 'File has been uploaded successfully', 'success');
            }
        }
        catch (error) {
            console.log('error' + error);
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
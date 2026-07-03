import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import getrepairitemlist from '@salesforce/apex/LWCFormControllerutilityclass.getrepairitemlist';
import getprefilldata from '@salesforce/apex/LWCFormControllerutilityclass.getprefilldata';
import getformJSON from  '@salesforce/apex/LWCFormControllerutilityclass.getformJSON';
import createupdateFormRecord from  '@salesforce/apex/LWCFormControllerutilityclass.createupdateFormRecord';
import createPDF from  '@salesforce/apex/LWCFormControllerutilityclass.createPDF';

export default class RepairQuoteForm extends LightningElement {

    @api recordId;
    @track formType = 'Repair Quote Form';
    @track isloading = true;
    @track formid = '';
    @track IsPDFGenerated = false;
    @track showConfirmation = false;

    @track quoteDate = new Date().toISOString().split('T')[0];
    @track clientFirstName = '';
    @track clientLastName = '';
    @track clientAddress = '';
    @track clientCity = '';
    @track clientState = '';
    @track clientZipCode = '';
    @track clientEmail = '';
    @track clientPhone = '';

    @track couponCode;
    @track notes;

    @track frontphoto = { "filename": "", "isfileuploaded": false, "cdid": "", "fileurl": "", "selectedOption": "" };

    @track discountPercent = 0;
    @track discountReason = '';
    //@track netTotal = 0;
    get totalCost() {
        return this.services.reduce((total, s) => total + (Number(s.price) * Number(s.quantity)), 0);
    }

    calculateNetTotal() {
        const discount = Number(this.discountPercent) || 0;
        const total = this.services.reduce((sum, s) => sum + (Number(s.price) * Number(s.quantity)), 0);
        this.netTotal = parseFloat((total - (total * discount / 100)).toFixed(2));
    }

    get netTotal(){
        const discount = Number(this.discountPercent) || 0;
        const total = this.services.reduce((sum, s) => sum + (Number(s.price) * Number(s.quantity)), 0);
        return parseFloat((total - (total * discount / 100)).toFixed(2));
    }

    handleDiscountChange(event) {
        this.discountPercent = Number(event.target.value) || 0;
        //this.calculateNetTotal();
    }

    handleDiscountReasonChange(event) {
        this.discountReason = event.target.value;
    }


    @track services = [];
       /* { id: '1', name: 'Flashing Replacement', unitDescription: 'Per 10ft section', price: 112.50, quantity: 0, selected: false },
        { id: '2', name: 'Shingles Required: (1-4)', unitDescription: 'Per Bundle', price: 225.00, quantity: 0, selected: false },
        { id: '3', name: 'Shingles Required: (>5)', unitDescription: 'Per Bundle', price: 150.00, quantity: 0, selected: false },
        { id: '4', name: 'Ridge Cap ( 5+ )', unitDescription: 'Per Bundle', price: 150.00, quantity: 0, selected: false },
        { id: '5', name: 'Ridge Cap ( 1-4 )', unitDescription: 'Per Bundles', price: 225.00, quantity: 0, selected: false },
        { id: '6', name: 'Pipe Jack', unitDescription: 'Per unit', price: 25.00, quantity: 0, selected: false },
        { id: '7', name: 'Bullet Boot', unitDescription: 'Per unit', price: 50.00, quantity: 0, selected: false },
        { id: '8', name: 'Roof Vent', unitDescription: 'Per unit', price: 75.00, quantity: 0, selected: false },
        { id: '9', name: 'Chimney Flashing', unitDescription: 'Per chimney', price: 300.00, quantity: 0, selected: false },
        { id: '10', name: 'Tarp Installation', unitDescription: 'Per 8x10 ft section', price: 350.00, quantity: 0, selected: false },
        { id: '11', name: 'Valley Repair', unitDescription: 'Per 10 ft', price: 200.00, quantity: 0, selected: false },
        { id: '12', name: 'Decking Replacement', unitDescription: 'Per piece', price: 100.00, quantity: 0, selected: false },
        { id: '13', name: 'Skylight Repair', unitDescription: 'Per unit', price: 187.50, quantity: 0, selected: false },
        { id: '14', name: 'Roof Tune Up', unitDescription: 'Walk-through and freshen up entire roof system, including sealing nail heads, pipe jacks, etc.', price: 600.00, quantity: 0, selected: false },
        { id: '15', name: 'Steep Roof Charge (7-9)', unitDescription: 'Per hour', price: 30.00, quantity: 0, selected: false },
        { id: '16', name: 'Steep Roof Charge (9-11)', unitDescription: 'Per hour', price: 60.00, quantity: 0, selected: false },
        { id: '17', name: 'Steep Roof Charge (11+)', unitDescription: 'Per hour', price: 90.00, quantity: 0, selected: false },
        { id: '18', name: '2-Story', unitDescription: 'Per Hour', price: 60.00, quantity: 0, selected: false },
        { id: '19', name: 'Repair nail pops', unitDescription: 'Per 10 nail pops', price: 125.00, quantity: 0, selected: false },
        { id: '20', name: 'Repair lifted shingles', unitDescription: 'Per 10 Shingles', price: 125.00, quantity: 0, selected: false },
        { id: '21', name: 'Seal as needed (penetrations, flashings, exposed nail heads)', unitDescription: 'Per 25 feet', price: 50.00, quantity: 0, selected: false },
        { id: '22', name: 'Paint Flashings / Penetrations As Needed', unitDescription: 'Per 10 sq ft', price: 50.00, quantity: 0, selected: false },
        { id: '23', name: 'Remove Debris / Clean Gutters and Downspouts', unitDescription: 'Per 100 linear Ft', price: 50.00, quantity: 0, selected: false },
        { id: '24', name: 'Replace, Seal, and Paint Soffit / Fascia / Wood Trim', unitDescription: 'Per linear foot', price: 30.00, quantity: 0, selected: false },
        { id: '25', name: 'Install Rafter Bracing / Purlins / Purlin Braces', unitDescription: 'Per Piece', price: 75.00, quantity: 0, selected: false },
        { id: '26', name: 'After Hours Charge', unitDescription: 'Anytime outside of Monday-Saturday 8am to 6 pm', price: 150.00, quantity: 0, selected: false },
        { id: '27', name: 'Chimney Crickets', unitDescription: 'Less than 4 ft', price: 650.00, quantity: 0, selected: false },
        { id: '28', name: 'Chimney Crickets', unitDescription: 'Between 4 - 6 ft', price: 850.00, quantity: 0, selected: false },
        { id: '29', name: 'Chimney Crickets', unitDescription: 'More than 6+ ft', price: 1050.00, quantity: 0, selected: false },
        { id: '30', name: 'Inclement Weather', unitDescription: 'Rain, Ice, Wind, Hail, Etc', price: 150.00, quantity: 0, selected: false },
        { id: '31', name: 'Gutter Repair (Up to 5 inch)', unitDescription: 'Up to 5 inch', price: 60.00, quantity: 0, selected: false },
        { id: '32', name: 'Trip Charge', unitDescription: '', price: 150.00, quantity: 0, selected: false },
        { id: '33', name: 'Gutter Repair (Up to 6 inch)', unitDescription: 'Up to 6 inch', price: 70.00, quantity: 0, selected: false },
        { id: '34', name: 'Install soffit vents', unitDescription: 'Per unit', price: 80.00, quantity: 0, selected: false },
        { id: '35', name: 'Other 1', unitDescription: '', price: '', quantity: 0, selected: false, isOther: true }
    ];*/

    /*handleAddOther() {
            const otherCount = this.services.filter(s => s.isOther).length;
            const newOther = {
                id: (this.services.length + 1).toString(),
                name: `Other ${otherCount + 1}`,
                unitDescription: 'See Notes',
                price: 10.00,
                quantity: 0,
                selected: false,
                isOther: true
            };
            this.services = [...this.services, newOther]; 
        }*/



    handleAddOther() {
        const otherCount = this.services.filter(s => s.isOther).length;
        const newOther = {
            id: (this.services.length + 1).toString(),
            name: `Other ${otherCount + 1}`,
            unit: '',
            price: 0.00,
            quantity: 0,
            isChecked: false,
            isNewItem: true
        };
        this.services = [...this.services, newOther];
    }

    /*handleOtherFieldChange(event) {
    const serviceId = event.target.dataset.id;
    const field = event.target.label === 'Price' ? 'price' : 'unitDescription';
    const value = field === 'price' ? parseFloat(event.target.value) : event.target.value;

    this.services = this.services.map(s => {
        if (s.id === serviceId) {
            return { ...s, [field]: value };
        }
        return s;
    });
}*/


    get totalCost() {
        return this.services.reduce((total, s) => total + (s.price * s.quantity), 0);
    }

    handleQuantityChange(event) {
        const serviceId = event.target.dataset.id;
        const newQty = Number(event.target.value) || 0;

        this.services = this.services.map(s =>
            s.id === serviceId ? { ...s, quantity: newQty, isChecked: newQty > 0 } : s
        );

        //this.calculateNetTotal();
    }


    handleOtherFieldChange(event) {
        const serviceId = event.target.dataset.id;
        const field = event.target.dataset.field || (event.target.label === 'Price' ? 'price' : 'unit');
        const value = field === 'price' ? Number(event.target.value) : event.target.value;

        this.services = this.services.map(s => s.id === serviceId ? { ...s, [field]: value } : s);

      //  this.calculateNetTotal();
    }


    handleServiceSelection(event) {
        const serviceId = event.target.dataset.id;
        const isChecked = event.target.checked;

        this.services = this.services.map(s =>
            s.id === serviceId ? { ...s, isChecked: isChecked, quantity: isChecked ? s.quantity : 0 } : s
        );
    }



    handleCouponChange(event) {
        this.couponCode = event.target.value;
    }

    handleNotesChange(event) {
        this.notes = event.target.value;
    }

    async handleFileUpload(event) {
        console.log('Files uploaded:', JSON.stringify(event.detail.files));
        const uploadedFiles = event.detail.files;
        try {
            if (uploadedFiles.length > 0) {
                const fileId = uploadedFiles[0].documentId; // Get the file's ContentDocumentId
                console.log('fileId:' + fileId);
                const versionId = uploadedFiles[0].contentVersionId;//await getContentVersion({ cdid: fileId });
                const fileUrl = '/sfc/servlet.shepherd/version/download/' + versionId;

                this.frontphoto.filename = 'Front Of Property';
                this.frontphoto.cdid = fileId;
                this.frontphoto.isfileuploaded = true;
                this.frontphoto.fileurl = fileUrl;
                this.showToast('Success', 'File has been uploaded successfully', 'success');
                console.log('filesCv', JSON.stringify(this.frontphoto));
            }
        }
        catch (error) {
            console.log('error' + error);
        }
    }


    handleReview() {
        console.log('Reviewing form...');
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }


    connectedCallback() {
        // this.isloading = false;
        setTimeout(() => {
            this.getFormdetails();
            
        }, 2000);
       


    }

    get formJson() {
        return JSON.stringify({
            GeneralInformation: [

                { id: 4, label: 'Client Address', value: this.clientAddress, type: 'Text' },
                { id: 6, label: 'City', value: this.clientCity, type: 'Text' },
                { id: 9, label: 'State', value: this.clientState, type: 'Text' },
                { id: 8, label: 'Zip Code', value: this.clientZipCode, type: 'number' },
                { id: 1, label: 'Client First Name', value: this.clientFirstName, type: 'text' },
                { id: 2, label: 'Client Last Name', value: this.clientLastName, type: 'text' },
                { id: 3, label: 'Client Email', value: this.clientEmail, type: 'email' },
                { id: 5, label: 'Client Phone', value: this.clientPhone, type: 'phone' },
                { id: 7, label: 'Form Type', value: this.formType, type: 'picklist' },
                { id: 10, label: 'Discount Percent', value: this.discountPercent, type: 'number'},
                { id: 11, label: 'Discount Reason', value: this.discountReason, type: 'text' }
            ],

            repairs: this.services,
            frontphoto: this.frontphoto
        });
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;

        this[field] = value;

    }

    async getrepairitemlist(){
        const repairitemlist = await getrepairitemlist();
           // console.log('repairitemlist',JSON.stringify(repairitemlist));
      //{ id: 1, name: "Shingles Required (1-4)", unit: "Per Bundle", price: 225, quantity: 0, total: 0, isChecked: false },
        this.services = repairitemlist.map(item => ({
           id : item.Id,
           name : item.Label,
           unit : item.Unit__c,
            price: item.Price__c,
            quantity: item.Label == 'Trip Charge' ? 1 : 0,
            total: item.Label == 'Trip Charge' ? 1 * item.Price__c : 0,
            isChecked: false,
           isNewItem : false
        }));
    
        console.log('mapped repairs:', JSON.stringify(this.repairs));
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
                 this.getrepairitemlist();
                this.prefillformdata();
            }
        })
        .catch(error => {
                this.isloading = false;
                console.error(error);
            });
 
        
       /* getformJSON({ OpprecordId: this.recordId, formType: this.formType })
            .then(result => {
                console.log('getformJSON', JSON.stringify(result));
                if (result) {
                    console.log('inside if');
                    this.formid = result.Id;
                    this.loadFromJson(result.Form_JSON__c);
                    this.IsPDFGenerated = result.IsPDFGenerated__c;
                    // this.isloading = false;


                }
                else {
                    console.log('inside else');
                    this.prefillformdata();

                }


            })
            .catch(error => {
                this.isloading = false;
                console.error(error);
            });*/


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
                    this.clientFirstName = result?.Contact?.FirstName || '';
                    this.clientLastName = result?.Contact?.LastName || '';
                    this.clientEmail = result?.Contact?.Email || '';
                    this.clientAddress = result?.Contact?.Account?.BillingAddress?.street || '';
                    this.clientCity = result?.Contact?.Account?.BillingAddress?.city || '';
                    this.clientState = result?.Contact?.Account?.BillingAddress?.state || '';
                    this.clientZipCode = result?.Contact?.Account?.BillingAddress?.postalCode || '';
                    this.clientPhone = result?.Contact?.Phone || '';
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1).padStart(2, '0');
                    const day = String(today.getDate()).padStart(2, '0');
                    this.inspectionDate = `${year}-${month}-${day}`;
                    // getting repair item from inspection form if exist
                    this.fetchFormDetails(this.recordId, 'Repair Inspection Form')
                        .then(result => {
                            if (result) {
                                console.log('inside getting repair item from inspection form if exist:');
                               const data = JSON.parse(result.Form_JSON__c);
                                if (data.repairs) {
                                    this.services = data.repairs;
                                }
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
                        case 'Client Last Name': this.clientLastName = field.value; break;
                        case 'Client First Name': this.clientFirstName = field.value; break;
                        case 'Client Address': this.clientAddress = field.value; break;
                        case 'City': this.clientCity = field.value; break;
                        case 'State': this.clientState = field.value; break;
                        case 'Zip Code': this.clientZipCode = field.value; break;
                        case 'Client Email': this.clientEmail = field.value; break;
                        case 'Client Phone': this.clientPhone = field.value; break;
                        case 'Discount Percent': this.discountPercent = field.value; break;
                        case 'Discount Reason': this.discountReason = field.value; break;
                        default: console.warn(`Unmapped field: ${field.label}`);
                    }
                });
            }

            if (data.repairs) {
                this.services = data.repairs;
            }

            if (data.frontphoto) {
                this.frontphoto = data.frontphoto;
            }
           // this.calculateNetTotal();

            this.isloading = false;

        } catch (error) {
            this.isloading = false;
            console.error('Invalid JSON string provided', error);
        }
    }
    generatepdfconfirmconfirmation() {
        this.showConfirmation = true;
    }
    closeModal() {
        this.showConfirmation = false;
    }

    handleSaveandGeneratePdf() {
        this.isloading = true;
        this.showConfirmation = true;
        console.log('handleSaveandGeneratePdf', JSON.stringify(this.formJson));
        createPDF({ OpprecordId: this.recordId, formid: this.formid || null, formType: this.formType, formJSON: this.formJson })
            .then(result => {
                console.log('handleSaveAndExit', result);
                this.isloading = false;
                this.dispatchEvent(new CloseActionScreenEvent());
                this.showToast('Success', 'PDF generated successfully!', 'success');

            })
            .catch(error => {
                this.isloading = false;
                console.error(error);
                this.showToast('Error!', 'PDF generation  Failed!', 'error');
            });
    }

    handleSave() {
        console.log('handleSave', JSON.stringify(this.formJson));
        this.isloading = true;
        createupdateFormRecord({ OpprecordId: this.recordId, formid: this.formid || null, formType: this.formType, formJSON: this.formJson })
            .then(result => {
                console.log('createupdateFormRecord', JSON.stringify(result));
                this.formid = result.Id;
                if (this.showConfirmation) {
                    this.handleSaveandGeneratePdf();
                }
                else {
                    this.isloading = false;
                    this.dispatchEvent(new CloseActionScreenEvent());
                    this.showToast('Success', 'Form saved successfully!', 'success');
                }


            })
            .catch(error => {
                this.isloading = false;
                console.error('error'+ JSON.stringify(error));
            });
    }


}
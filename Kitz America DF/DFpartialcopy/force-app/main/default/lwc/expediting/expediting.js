import { LightningElement, track, api, wire } from 'lwc';
import getExpediting from "@salesforce/apex/ExperienceCloudController.getExpeditingList";
import getCustomers from "@salesforce/apex/ExperienceCloudController.getCustomers";
import getUserConfig from '@salesforce/apex/ExperienceCloudController.getUserConfig';
import pdfjsWeb from '@salesforce/resourceUrl/pdfjs';
import getOrderAckPdfContent from '@salesforce/apex/ExperienceCloudController.getOrderAckPdfContent';
import communityPath from '@salesforce/community/basePath';

const EXPEDITING_COLUMNS = [
    { label: 'Line No', fieldName: 'lineNo' },
    { label: 'PO Number', fieldName: 'poNumber' },
    { label: 'Figure No', fieldName: 'figureNo' },
    { label: 'KCA Order No', fieldName: 'kcaOrderNo' },
    { label: 'MFG No', fieldName: 'mfgNo' },
    { label: 'Shipping From', fieldName: 'shippingFrom' },
    { label: 'Order Qty', fieldName: 'orderQty', type: 'number' },
    { label: 'In Transit Qty', fieldName: 'inTransitQty', type: 'number' },
    { label: 'Open Qty', fieldName: 'openQty', type: 'number' },
    { label: 'Invoice Qty', fieldName: 'invoiceQty', type: 'number' },
    { label: 'Status', fieldName: 'status' },
    { label: 'Date', fieldName: 'date' }
];

const CUSTOMER_COLUMNS = [
    { label: 'Customer ID', fieldName: 'CUSTOMERID',type: "button",typeAttributes: {
            label: { fieldName: 'CUSTOMERID' },
            name: 'open_modal',
            variant: 'base'   
        }},
    { label: 'Firm Name', fieldName: 'FIRMNAME' },
    { label: 'City', fieldName: 'CITY' },
    { label: 'State', fieldName: 'STATE' }
];

export default class expediting extends LightningElement {

    @track po = '';
    @track custno = '';
    @track Expeditingdata = [];
    @track customerId = '';
    @track customerName = '';
    @track customerData = [];
    @track isCustomerModalOpen = false;
    expeditingResponse = null;
    poNoOut = '';
    customerNameOut = '';
    hasOrders = false;
    showNoDataFound = false;
    isLoading = false;
    custSearchBy = '';
    @track custSearchString = '';
    isCustomerSearchLoading = false;
    pdfBaseUrl = 'https://portal.kitzus-kca.com/customer/pdfs2/';
    expViewType = 'ALL';
    warningMessage = '';
    filterClicked = false;
    @track isAdmin = false;
    @track loadingpdf = false;
    @track errorMessagepdf = '';
    dwnldAck = false;
    @track pdfData;
    @track viewerUrl;
    ispdfModalOpen = false;
    showPDFModalloadingSpinner = false;
    kcaOrderNoInContext;

    expColumns = EXPEDITING_COLUMNS;
    customerColumns = CUSTOMER_COLUMNS;

    @wire(getUserConfig)
    wiredConfig({ error, data }) {
        if (data) {
            this.isAdmin = data.isAdmin;
            //this.customerNumber = data.customerNumber;
            
            // If NOT an admin, auto-set the search field to their linked account
            if (!this.isAdmin) {
                this.custno = data.customerNumber;
            }
        } else if (error) {
            console.error('Error loading user config', error);
        }
    }

    handleInputChange(event) {
        const field = event.target.label;
        if (field === 'Purchase Order #') this.po = event.target.value;
        else if (field === 'Customer') this.custno = event.target.value;
    }

     get modalClass() {
        return this.ispdfModalOpen
        ? "slds-modal slds-modal_large slds-fade-in-open"
        : "slds-modal slds-modal_large";
    }

    get viewerUrlBase() {
        return `${communityPath}/resource/pdfjs/pdfjs/web/viewer.html`;
    }

    get issearchDisabled() {
        return !(this.po || this.custno);
    }

    get showFilterBar() {
        // Show if there are orders initially OR if a filter was already clicked
        return (this.hasOrders|| this.filterClicked);
    }

    handleSearch() {
        this.showNoDataFound = false;
        this.isLoading = true;
        this.hasOrders = false;
        this.warningMessage = '';
        
        getExpediting({poNumber: this.po, customerId: this.custno, viewType: this.expViewType})
        .then(response => {
            this.expeditingResponse =  JSON.parse(JSON.stringify(response));
            this.poNoOut = this.expeditingResponse.poNo;
            this.customerNameOut = this.expeditingResponse.customerName;
            if(this.expeditingResponse.orders.length > 0)
            {
                this.isLoading = false;
                this.hasOrders = true;
                this.Expeditingdata = this.expeditingResponse.orders.map(order => {
                    return {
                        ...order,
                        displayLabel: `KCA Order No: ${order.orderNumber}`,
                        orderItems: order.orderItems.map(item => {
                            let sldsClass = 'slds-badge '; // Base class

                            // Logic based on the Status string
                            if (item.status === 'INVOICED') {
                                sldsClass += 'slds-theme_success'; // Green for Invoiced
                            } else if (item.status === 'OPEN' || item.status === 'ETA') {
                                sldsClass += 'slds-theme_warning'; // Yellow/Orange for Open
                            } else if (item.status === 'CANCELLED') {
                                sldsClass += 'slds-theme_error';   // Red for Cancelled
                            } else {
                                sldsClass += 'slds-theme_lightest'; // Grey for others
                            }

                            return { ...item, statusClass: sldsClass,mfgPdfUrl: `${this.pdfBaseUrl}${item.mfgNumber}.pdf` };
                        })
                    };
                });
            } 
            else
            {
                this.isLoading = false;
                this.showNoDataFound = true;   
                this.hasOrders = false;
                this.warningMessage = 'No matching records for the criteria entered...';
            }
            //this.Expeditingdata = this.expeditingResponse.orders;
            //this.Expeditingdata = this.expeditingResponse;
            //console.log('ExpeditingResponse:'+JSON.stringify(response));
        })
        .catch(error => {
            console.log('ERROR:'+error);
            const message = error && error.body ? error.body.message : error;
        })

        /*
        this.Expeditingdata = [
            {
                lineNo: '1.0',
                poNumber: '1211349',
                figureNo: '27-100',
                kcaOrderNo: '3000146205',
                mfgNo: '1020861530-005-1',
                shippingFrom: 'STAFFORD, TX',
                orderQty: 2,
                inTransitQty: 0,
                openQty: 2,
                invoiceQty: 2,
                status: 'INVOICED',
                date: '02/10/2026'
            }
        ];
        */
    }

    openCustomerModal() {
        this.isCustomerModalOpen = true;
    }

    closeCustomerModal() {
        this.isCustomerModalOpen = false;
    }

    get isCustomerIdDisabled() {
        return this.customerName?.trim().length > 0;
    }

    get isCustomerNameDisabled() {
        return this.customerId?.trim().length > 0;
    }

    get isCustomerSearchDisabled() {
        return !(this.custSearchString?.trim());
    }

    handleCustomerIdChange(event) {
        this.custSearchString = event.target.value;
        this.custSearchBy = 'CID';
    }

    handleCustomerNameChange(event) {
        this.custSearchString = event.target.value;
        this.custSearchBy = 'CNAME';
    }

    handleCustomerSearch() {
        this.isCustomerSearchLoading = true;
        getCustomers({searchString: this.custSearchString, searchBy: this.custSearchBy})
        .then(response => {
            //console.log('GETCUSTOMER Response: ', JSON.stringify(response));
            if(response.length > 0)
            {
                this.customerData = response;
            }
            else
            {
                this.customerData = [];
            }
            this.isCustomerSearchLoading = false
        })
        .catch(error => {
            console.log('ERROR:'+error);
            const message = error && error.body ? error.body.message : error;
        })
        /*
        this.customerData = [
            {
                CustomerID: '30S0225',
                FirmName: 'LAKESIDE SUPPLY COMPANY',
                City: 'CLEVELAND, OH',
                State: 'OH'
            }
        ];
        */
    }
    handleRowAction(event) {
        console.log('onrowaction called');
        const row = event.detail.row;
        console.log('Selected Row: ', JSON.stringify(row));
        this.custno = row.CUSTOMERID;
        this.closeCustomerModal();
        this.customerData = [];
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage = 'Open sections: ' + openSections.join(', ');
        }
    }

    handleFilterAll() {
        this.expViewType = 'ALL';
        this.filterClicked = true;
        this.handleSearch();
    }

    handleFilterOpen() {  
        this.expViewType = 'OPEN';
        this.filterClicked = true;
        this.handleSearch();  
    }


    handleFilterClosed() {
        this.expViewType = 'CLOSED';
        this.filterClicked = true;
        this.handleSearch();
    }

    onLoad() {
        let myiframe = this.template.querySelector("iframe");
        if (myiframe) {
        myiframe.contentWindow.postMessage(this.pdfData, "*");
        }
    }

    loadPdf(event) {
        // Pass the record ID to Apex
        //this.dwnldAck = true;
        this.ispdfModalOpen = true;
        this.showPDFModalloadingSpinner = true;
        const kcaOrderNo = event.target.dataset.id;
        this.kcaOrderNoInContext = kcaOrderNo;
        console.log('KCA Order No: ' + kcaOrderNo)
        //this.loadingpdf = true;
        /*
        getOrderAckPdfContent({ sapOrderNumber: kcaOrderNo})
        .then(base64Data => {
            
            // Convert base64 to Blob URL
            const binaryString = window.atob(base64Data);
            const bytes = new Uint8Array(binaryString.length);
            for (let i = 0; i < binaryString.length; i++) {
                bytes[i] = binaryString.charCodeAt(i);
            }
            const blob = new Blob([bytes], { type: 'application/pdf' });
            const blobUrl = URL.createObjectURL(blob);
            this.viewerUrl = `${pdfjsWeb}/web/viewer.html?file=${encodeURIComponent(blobUrl)}`;
            
            console.log('Blob URL: ' + blobUrl);
            console.log('Viewer URL: ' + this.viewerUrl);
            this.loadingpdf = false;
            //this.renderViewer(blobUrl);
        })
        .catch(error => {
            this.errorMessagepdf = 'Error loading PDF: ' + (error.body?.message || error.message);
            this.loadingpdf = false;
        });
        */
        //event.stopPropagation();
        /*
        getOrderAckPdfContent({ sapOrderNumber: kcaOrderNo })
        .then(base64Data => {
            this.pdfData = base64Data; // Keep the raw base64
            
            // Point to the viewer WITHOUT the ?file= parameter
            //this.viewerUrl = `${pdfjsWeb}/web/viewer.html`; 
            this.viewerUrl = this.viewerUrlBase;
            
            this.loadingpdf = false;
            // The iframe onload event will now handle the data transfer
        })
        .catch(error => {
            this.errorMessagepdf = 'Error: ' + error.message;
            this.loadingpdf = false;
        });
        */

        getOrderAckPdfContent({ sapOrderNumber: kcaOrderNo })
        .then(base64Data => {
            // Convert base64 to Blob URL
            this.pdfData = base64Data; // Keep the raw base64
            const binaryString = window.atob(base64Data);
            const bytes = new Uint8Array(binaryString.length);
            for (let i = 0; i < binaryString.length; i++) {
                bytes[i] = binaryString.charCodeAt(i);
            }
            const blob = new Blob([bytes], { type: 'application/pdf' });
            const blobUrl = URL.createObjectURL(blob);
            this.renderViewer(blobUrl,kcaOrderNo);
        })
        .catch(error => {
            this.errorMessage = 'Error loading PDF: ' + (error.body?.message || error.message);
            this.loading = false;
        });
    }

    /*
    handleIframeLoad() {
        const iframe = this.template.querySelector('iframe');
        if (iframe && this.pdfData) {
            // Send the Base64 data directly to the PDF.js window
            iframe.contentWindow.postMessage({
                type: 'renderPdf',
                data: this.pdfData
            }, '*');
        }
    }
    */

    handleIframeLoad() {
        const iframe = this.template.querySelector('iframe');
        if (iframe && this.pdfData) {
            // We use a small timeout to ensure PDF.js internal scripts are ready
            setTimeout(() => {
                iframe.contentWindow.postMessage({
                    libUrl: communityPath + '/resource/pdfjs/',
                    data: this.pdfData
                }, '*');
            }, 800);
        }
    }

    renderViewer(blobUrl,kcaOrderNo) {
        const iframe = this.template.querySelector('.pdfjs-iframe'); 
        if (!iframe) {
            this.errorMessagepdf = 'Viewer iframe not found';
            //this.loadingpdf = false;
            //this.ispdfModalOpen = true;
            this.showPDFModalloadingSpinner = false;
            return;
        }
        // Compose the viewer.html URL with the Blob URL as the file param
        const customFileName = `OrderAcknowledgement_${kcaOrderNo}.pdf`;
        const viewerUrl = `${pdfjsWeb}/pdfjs/web/viewer.html?file=${encodeURIComponent(blobUrl)}&filename=${customFileName}`;
        console.log('Viewer URL: ' + viewerUrl);
        iframe.src = viewerUrl;
        //iframe.contentDocument.title = `Order_Acknowledgement_${kcaOrderNo}`;
        this.showPDFModalloadingSpinner = false;
        //this.dwnldAck = false;
    }

    closepdfModal() {
        this.ispdfModalOpen = false;
        this.showPDFModalloadingSpinner = false;
    }

    handlepdfSave() {
        const binaryString = window.atob(this.pdfData);
        const bytes = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
            bytes[i] = binaryString.charCodeAt(i);
        }
        const blob = new Blob([bytes], { type: 'application/pdf' });
        const blobUrl = URL.createObjectURL(blob);

        // 3. Create a hidden anchor element to trigger the download
        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = blobUrl;
        
        // 4. SPECIFY THE FILENAME HERE
        // You can use the Order Number stored in your component
        a.download = `Order_Acknowledgement_${this.kcaOrderNoInContext}.pdf`; 
        
        document.body.appendChild(a);
        a.click();

        // 5. Cleanup
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
    }

}
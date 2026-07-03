import { LightningElement, track } from 'lwc';
import getMTRData from '@salesforce/apex/MTRLWCController.getMTRData';

const COLUMNS = [
    {
        label: 'Number',
        fieldName: 'rowNumber',
        type: 'number',
        cellAttributes: { alignment: 'left' }
    },
    {
        label: 'KCA Order',
        fieldName: 'kcaOrder'
    },
    {
        label: 'Manufacturing Number',
        fieldName: 'mfgPdfUrl',
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'manufacturingNumber' },
            target: '_blank'
        }
    },
    {
        label: 'Customer PO#',
        fieldName: 'customerPO'
    },
    {
        label: 'CustLine#',
        fieldName: 'custLine'
    }
];


export default class Mtr extends LightningElement {
    @track currentPage = '';
    @track mfg = '';
    @track po = '';
    @track suborder = '';
    @track mtrdata = [];
    pdfBaseUrl = 'https://portal.kitzus-kca.com/customer/pdfs2/';

 columns = COLUMNS;
 /* [
        { label: 'Number', fieldName: 'number', hideDefaultActions: true  },
        { label: 'KCA Order', fieldName: 'kcaOrder', hideDefaultActions: true  },
        { label: 'MFG No', fieldName: 'mfgNo', hideDefaultActions: true  },
        { label: 'Customer PO #', fieldName: 'customerPo' , hideDefaultActions: true },
        { label: 'Cust Line #', fieldName: 'custLine', hideDefaultActions: true  }
    ];*/

    connectedCallback() {
        this.detectPage();
        
    }

    detectPage() {
        const url = window.location.href.toLowerCase();
        if (url.includes('/mtr')) {
            this.currentPage = 'mtr';
        } else if (url.includes('/expediting')) {
            this.currentPage = 'expediting';
        } else {
            this.currentPage = 'unknown';
        }
    }

    get isMtrPage() {
    return this.currentPage === 'mtr';
    }

    get isExpeditingPage() {
        return this.currentPage === 'expediting';
    }

    get isUnknownPage() {
        return this.currentPage === 'unknown';
    }

    get issearchDisabled() {
        return !(this.mfg || this.po || this.suborder);
    }


    handleInputChange(event) {
        const field = event.target.label;
        if (field === 'MFG #') this.mfg = event.target.value;
        else if (field === 'Customer PO #') this.po = event.target.value;
        else if (field === 'Suborder #') this.suborder = event.target.value;
    }

    handleSearch() {
       // alert('MTR search feature is under development. Please check back soon.');

       /* this.data = [];

        for (let i = 1; i <= 50; i++) {
            this.data.push({
                id: i.toString(),
                number: i.toString().padStart(3, '0'),
                kcaOrder: 'KCA-' + (8800 + i),
                mfgNo: this.mfg || 'MFG-' + i.toString().padStart(4, '0'),
                customerPo: this.po || 'PO-' + (10000 + i),
                custLine: 'CL-' + i.toString().padStart(3, '0')
            });
        }
        const apiResponse = [
            {
                "EKPO_LABNR": "1020861530-005-1",
                "EKKN_VBELN": "3000107458",
                "EKKN_POSNR": 1,
                "VBAK_BSTNK": "255"
            },
            {
                "EKPO_LABNR": "1020861530-032-01",
                "EKKN_VBELN": "3000107458",
                "EKKN_POSNR": 1,
                "VBAK_BSTNK": "255"
            }
        ];*/

        getMTRData({ mfg: this.mfg, suborder: this.suborder, po: this.po })
            .then(result => {
                console.log('MTR Data: ', result);
                console.log('MTR API Response: ', JSON.stringify(result));
                this.mtrdata = result.map((row, index) => ({
                    rowNumber: index + 1,
                    kcaOrder: row.EKKN_VBELN,
                    manufacturingNumber: row.EKPO_LABNR,
                    mfgPdfUrl: `${this.pdfBaseUrl}${row.EKPO_LABNR}.pdf`,
                    customerPO: row.VBAK_BSTNK,
                    custLine: row.EKKN_POSNR
                }));
            })
            .catch(error => {
                console.error('Error fetching MTR data:', error);
            });
        
    }
}
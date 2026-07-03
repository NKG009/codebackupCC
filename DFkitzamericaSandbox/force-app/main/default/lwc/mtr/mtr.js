import { LightningElement, track } from 'lwc';

export default class Mtr extends LightningElement {
    @track currentPage = '';
    @track mfg = '';
    @track po = '';
    @track suborder = '';
    @track data = [];

 columns = [
        { label: 'Number', fieldName: 'number', hideDefaultActions: true  },
        { label: 'KCA Order', fieldName: 'kcaOrder', hideDefaultActions: true  },
        { label: 'MFG No', fieldName: 'mfgNo', hideDefaultActions: true  },
        { label: 'Customer PO #', fieldName: 'customerPo' , hideDefaultActions: true },
        { label: 'Cust Line #', fieldName: 'custLine', hideDefaultActions: true  }
    ];

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


    handleInputChange(event) {
        const field = event.target.label;
        if (field === 'MFG #') this.mfg = event.target.value;
        else if (field === 'Customer PO #') this.po = event.target.value;
        else if (field === 'Suborder #') this.suborder = event.target.value;
    }

    handleSearch() {
        alert('MTR search feature is under development. Please check back soon.');

        this.data = [];

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
    }
}
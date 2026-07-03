import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import InspectionReportpdf from '@salesforce/apex/InspectionReportController.InspectionReportpdf';
import { loadScript } from 'lightning/platformResourceLoader';
import JSPDF from '@salesforce/resourceUrl/jspdf';
import logo from '@salesforce/resourceUrl/Roofinglogo';


export default class InspectionReport extends LightningElement {
    @api recordId;
 
    @track photoTypes = [
        { label: 'Front Elevation Overview', value: 'front', images: [] },
        { label: 'Right Elevation Overview', value: 'right', images: [] },
        { label: 'Rear Elevation Overview', value: 'rear', images: [] },
        { label: 'Left Elevation Overview', value: 'left', images: [] },
    { label: 'Other', value: 'other', images: [], isOther: true } // <-- only this isOther
    ];
    
    @track repairs = [
    { id: 1, name: "Shingles Required (1-4)", unit: "Per Bundle", price: 225, quantity: 0, total: 0 },
    { id: 2, name: "Flashing Replacement", unit: "Per 10 ft Section", price: 115, quantity: 0, total: 0 },
    { id: 3, name: "Shingles Required (>5)", unit: "Per Bundle", price: 150, quantity: 0, total: 0 },
    { id: 4, name: "Ridge Cap (5+)", unit: "Per Bundle", price: 150, quantity: 0, total: 0 },
    { id: 5, name: "Ridge Cap (1-4)", unit: "Per Bundle", price: 225, quantity: 0, total: 0 },
    { id: 6, name: "Pipe Jack", unit: "Per Unit", price: 25, quantity: 0, total: 0 },
    { id: 7, name: "Bullet Boot", unit: "Per Unit", price: 50, quantity: 0, total: 0 },
    { id: 8, name: "Roof Vent", unit: "Per Unit", price: 75, quantity: 0, total: 0 },
    { id: 9, name: "Chimney Flashing", unit: "Per Chimney", price: 300, quantity: 0, total: 0 },
    { id: 10, name: "Tarp Installation", unit: "Per 8 x 10 ft Section", price: 350, quantity: 0, total: 0 },
    { id: 11, name: "Valley Repair", unit: "Per 10 Ft", price: 200, quantity: 0, total: 0 },
    { id: 12, name: "Skylight Repair", unit: "Per Unit", price: 200, quantity: 0, total: 0 },
    { id: 13, name: "Decking Replacement", unit: "Per Piece", price: 100, quantity: 0, total: 0 },
    { id: 14, name: "Steep Roof Charge (7-9)", unit: "Per Hour", price: 30, quantity: 0, total: 0 },
    { id: 15, name: "Steep Roof Charge (11+)", unit: "Per Hour", price: 90, quantity: 0, total: 0 },
    { id: 16, name: "2-Story", unit: "Per Hour", price: 60, quantity: 0, total: 0 },
    { id: 17, name: "Repair Nail Pops", unit: "Per 10 Nail Pops", price: 125, quantity: 0, total: 0 },
    { id: 18, name: "Trip Charge", unit: "Per Job", price: 150, quantity: 0, total: 0 },
    { id: 19, name: "Repair Lifted Shingles", unit: "Per 10 Shingles", price: 125, quantity: 0, total: 0 },
    { id: 20, name: "Seal As Needed (Penetrations, Flashings, Exposed Nail Heads)", unit: "Per 25 Ft", price: 50, quantity: 0, total: 0 },
    { id: 21, name: "Paint As Needed (Flashings and Penetrations)", unit: "Per 10 Sq Ft", price: 50, quantity: 0, total: 0 },
    { id: 22, name: "Remove Debris / Clean Gutters and Downspouts", unit: "Per 100 Linear Ft", price: 50, quantity: 0, total: 0 },
    { id: 23, name: "Install Rafter Bracing / Purlin / Purlin Braces", unit: "Per Piece", price: 75, quantity: 0, total: 0 },
    { id: 24, name: "After Hours Charge", unit: "Outside Mon-Sat 8AM-6PM", price: 150, quantity: 0, total: 0 },
    { id: 25, name: "Replace, Seal, and Paint Soffit/Facia / Wood Trim", unit: "Per Linear Ft", price: 30, quantity: 0, total: 0 },
    { id: 26, name: "Inclement Weather Charge", unit: "Rain, Ice, Wind, Hail, Etc.", price: 150, quantity: 0, total: 0 },
    { id: 27, name: "Other 1", unit: "", price: 10, quantity: 0, total: 0 },
    { id: 28, name: "Other 2", unit: "", price: 10, quantity: 0, total: 0 },
    { id: 29, name: "Other 3", unit: "", price: 10, quantity: 0, total: 0 },
    { id: 30, name: "Install soffit vent(s)", unit: "Per Unit", price: 80, quantity: 0, total: 0 },
    { id: 31, name: "Steep Roof Charge (9-11)", unit: "Per Hour", price: 60, quantity: 0, total: 0 },
    { id: 32, name: "Gutter Repair", unit: "Up to 6 inches", price: 60, quantity: 0, total: 0 }
];

    roofAgeOptions = [
    { label: '1-5 years of age', value: '1-5 years of age' },
    { label: '5-10 years of age', value: '5-10 years of age' },
    { label: '10-15 years of age', value: '10-15 years of age' },
    { label: '15-20 years of age', value: '15-20 years of age' },
    { label: '20+ years of age', value: '20+ years of age' },
];

@track photoBlocks = Array.from({ length: 20 }, (_, i) => ({
    id: i + 1,
    selectedTypes: [],
    file: null,
    fileUrl: null,
    otherName: '',
    showOtherInput: false ,
        typeChecked: {} 

}));
@track streetAddress = '';
@track city = '';
@track state = '';
@track zipCode = '';

    isJsPdfInitialized = false;
    jsPDFLib = null;
    isLoading = false;
    uploadSuccess = false;
    uploadError = false;
    uploadErrorMessage = '';
@track propertyType = [];
@track roofCovering = [];
@track layerShingles = [];
@track intakeVentilation = [];
@track exhaustVentilation = [];
@track ventilation = []; 
@track underlayment = [];
@track pipeJacks = [];
@track pipeJacks = [];
@track ventStack = [];
@track chimney = [];
@track roofObserved = [];
@track roofPitch = [];
@track roofAge = '';
@track inspectionDate = '';
@track inspectionNotes = '';
@track observations = '';
@track recommendations = '';
@track notes = '';




handleInputChange(event) {
    const field = event.target.dataset.field;
    const value = event.target.value;

    const multiSelectFields = [
        "propertyType", "roofCovering", "underlayment", "layerShingles",
        "ventilation", "pipeJacks", "ventStack", "chimney",
        "roofObserved", "roofPitch"
    ];

    if (multiSelectFields.includes(field)) {
        if (event.target.checked) {
            if (!this[field].includes(value)) {
                this[field] = [...this[field], value];
            }
        } else {
            this[field] = this[field].filter(v => v !== value);
        }
    } else {
        // for combobox/textarea/text input
        this[field] = value;
    }
}



    get isButtonDisabled() {
        return this.isLoading || !this.jsPDFLib;
    }

    renderedCallback() {
        if (!this.isJsPdfInitialized) {
            this.isJsPdfInitialized = true;
            loadScript(this, JSPDF)
                .then(() => this.jsPDFLib = window.jspdf?.jsPDF)
                .catch(error => this.showToast('Error', 'Failed to load jsPDF: ' + error.message, 'error'));
        }
    }
    // Quantity change handler
    handleQuantityChange(event) {
        const id = parseInt(event.target.dataset.id, 10);
        const value = parseInt(event.target.value, 10) || 0;

        this.repairs = this.repairs.map(item => {
            if (item.id === id) {
                return {
                    ...item,
                    quantity: value,
                    total: value * item.price
                };
            }
            return item;
        });
    }

    // Grand Total (getter)
    get grandTotal() {
        return this.repairs.reduce((sum, item) => sum + item.total, 0);
    }


getBlockLabel(block) {
    return block.selectedTypes ? block.selectedTypes.map(t => this.getLabel(t)).join(', ') : '';
}
get frontImages() {
    return this.photoTypes && this.photoTypes.length > 0 ? this.photoTypes[0].images : [];
}get otherPhotoTypes() {
    return this.photoTypes.slice(1); 
}
getBlockLabelsMap(block) {
    return block.selectedTypes.map(t => this.getLabel(t)).join(', ');
}

isOtherChecked(block, typeValue) {
    return typeValue === 'other' && block.selectedTypes.includes('other');
}


/*handleCheckboxChange(event) {
    const blockId = parseInt(event.target.dataset.blockId);
    const value = event.target.dataset.value;
    const block = this.photoBlocks.find(b => b.id === blockId);

    if (event.target.checked) {
        if (!block.selectedTypes.includes(value)) block.selectedTypes.push(value);
    } else {
        block.selectedTypes = block.selectedTypes.filter(t => t !== value);
    }

    // Show input ONLY if 'Other' checkbox is selected
    block.showOtherInput = block.selectedTypes.includes('other');

    this.photoBlocks = [...this.photoBlocks];
}*/
handleCheckboxChange(event) {
    const blockId = parseInt(event.target.dataset.blockId);
    const value = event.target.dataset.value;
    const block = this.photoBlocks.find(b => b.id === blockId);

    if (event.target.checked) {
        // Only one checkbox can be selected per block
        block.selectedTypes = [value];

        // Update typeChecked object
        block.typeChecked = {};
        block.typeChecked[value] = true;
    } else {
        block.selectedTypes = [];
        block.typeChecked = {};
    }

    // Show Other input only if Other is selected
    block.showOtherInput = block.selectedTypes.includes('other');

    this.photoBlocks = [...this.photoBlocks];
}

getOtherInputVisible(block, typeValue) {
    return typeValue === 'other' && block.selectedTypes.includes('other');
}


handleOtherNameChange(event) {
    const blockId = parseInt(event.target.dataset.blockId);
    const block = this.photoBlocks.find(b => b.id === blockId);
    block.otherName = event.target.value;
    this.photoBlocks = [...this.photoBlocks];
}


    handleFileChange(event) {
        const typeValue = event.target.dataset.type;
        const blockId = event.target.dataset.blockId;
        const files = Array.from(event.target.files);

        files.forEach(file => this.compressImage(file, 600, 0.5)
            .then(blob => {
                const reader = new FileReader();
                reader.onload = e => {
                    if (typeValue) {
                        const typeObj = this.photoTypes.find(t => t.value === typeValue);
                        typeObj.images.push({ id: typeObj.images.length + 1, url: e.target.result, file: blob });
                        this.photoTypes = [...this.photoTypes];
                    } else if (blockId) {
                        const block = this.photoBlocks.find(b => b.id === parseInt(blockId));
                        block.file = blob;
                        block.fileUrl = e.target.result;
                        this.photoBlocks = [...this.photoBlocks];
                    }
                };
                reader.readAsDataURL(blob);
            })
            .catch(err => this.showToast('Error', 'Image compression failed: ' + err.message, 'error'))
        );

        event.target.value = null;
    }

    compressImage(file, maxWidth, quality) {
        return new Promise((resolve, reject) => {
            const img = new Image();
            const reader = new FileReader();
            reader.onload = e => img.src = e.target.result;
            img.onload = () => {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                let { width, height } = img;
                if (width > maxWidth) { height *= maxWidth / width; width = maxWidth; }
                canvas.width = width;
                canvas.height = height;
                ctx.drawImage(img, 0, 0, width, height);
                canvas.toBlob(blob => blob ? resolve(blob) : reject(new Error('Canvas toBlob null')), 'image/jpeg', quality);
            };
            reader.onerror = reject;
            reader.readAsDataURL(file);
        });
    }

    getLabel(value) {
        const typeObj = this.photoTypes.find(t => t.value === value);
        return typeObj ? typeObj.label : value;
    }

    async convertBlobToBase64(blob) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onloadend = () => resolve(reader.result.split(',')[1]);
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
async loadImageAsBase64(url) {
    return new Promise((resolve, reject) => {
        const img = new Image();
        img.crossOrigin = 'Anonymous'; // avoids CORS issues
        img.onload = () => {
            const canvas = document.createElement('canvas');
            canvas.width = img.width;
            canvas.height = img.height;
            const ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0);
            const dataURL = canvas.toDataURL('image/png');
            resolve(dataURL.split(',')[1]); // return Base64 string only
        };
        img.onerror = reject;
        img.src = url;
    });
}

    async generateAndUploadPdf() {
    if (!this.jsPDFLib) {
        this.showToast('Error', 'jsPDF not loaded', 'error');
        return;
    }

    this.isLoading = true;
    this.uploadSuccess = false;
    this.uploadError = false;
    this.uploadErrorMessage = '';

    try {
        const doc = new this.jsPDFLib();
        const pageHeight = 295;
        const lineHeight = 7;
        let yPos = 10;
        // Add logo at top
try {
    const logoBase64 = await this.loadImageAsBase64(logo);
    const logoWidth = 60;   // width of logo
    const logoHeight = 40;  // height of logo

    const pageWidth = doc.internal.pageSize.getWidth();
    const logoX = (pageWidth - logoWidth) / 2; // center logo horizontally
    const logoY = 10;  // top margin

    doc.addImage(logoBase64, 'PNG', logoX, logoY, logoWidth, logoHeight);

    // Heading BELOW the logo, centered
    yPos = logoY + logoHeight + 10; // move yPos below logo
    doc.setFontSize(18);
    doc.setFont(undefined, 'bold');

    const headingText = "Fundamental Roofing LLC Field Inspection Report";
    const textWidth = doc.getTextWidth(headingText);
    const headingX = (pageWidth - textWidth) / 2; // center text
    doc.text(headingText, headingX, yPos);

    yPos += 20; // leave space after heading
} catch (err) {
    console.warn('Logo failed to load:', err);
    doc.setFontSize(18);
    doc.setFont(undefined, 'bold');
    doc.text("Fundamental Roofing LLC Field Inspection Report", 10, yPos);
    yPos += 10;
}


        //  Front Of Property Images
        const frontType = this.photoTypes.find(t => t.value === 'front');
        if (frontType && frontType.images.length > 0) {
            if (yPos + 10 > pageHeight) { doc.addPage(); yPos = 10; }
            doc.setFont(undefined, 'bold');
            doc.setFontSize(14);
            doc.text('Front Of Property', 10, yPos);
            yPos += 10;

            doc.setFont(undefined, 'normal');
            doc.setFontSize(12);
            for (let img of frontType.images) {
                if (yPos + 105 > pageHeight) { doc.addPage(); yPos = 10; }
                const base64 = await this.convertBlobToBase64(img.file);
                doc.addImage(base64, 'JPEG', 10, yPos, 120, 100);
                yPos += 105;
            }
            yPos += 5;
        }

        // Client Info
        const sections = [
            { label: 'Client Address:', value: `${this.streetAddress || ''}, ${this.city || ''}, ${this.state || ''}, ${this.zipCode || ''}` },
            { label: 'Inspection Date:', value: this.inspectionDate || '' }
        ];

        doc.setFontSize(12);
        for (let sec of sections) {
            if (yPos + lineHeight > pageHeight) { doc.addPage(); yPos = 10; }
            doc.setFont(undefined, 'bold');
            doc.text(sec.label, 10, yPos);
            doc.setFont(undefined, 'normal');
            doc.text(sec.value, 60, yPos);
            yPos += lineHeight;
        }
        yPos += 5;

        
        //  Disclaimer on a new page
        doc.addPage();
        yPos = 10;
        doc.setFont(undefined, 'bold');
        doc.setFontSize(14);
        doc.text('Disclaimer:', 10, yPos);
        yPos += lineHeight;

        const disclaimer = "The above named requested an evaluation of the roofing system for the referenced address. Our evaluation will take into consideration the overall condition of the roofing system, its design and expected performance over time. We cannot be liable for determining insurability. This falls under the purview of a qualified underwriter. If the property is under contract, we recommend the buyer contact their insurance carrier and request an inspection by an underwriter to determine whether or not the roof is insurable prior to the end of the option period if possible or at least prior to closing.";
        const disclaimerLines = doc.splitTextToSize(disclaimer, 180);
        doc.setFont(undefined, 'normal');
        disclaimerLines.forEach(line => {
            if (yPos + lineHeight > pageHeight) { doc.addPage(); yPos = 10; }
            doc.text(line, 10, yPos);
            yPos += lineHeight;
        });
        yPos += 10;

// define addSection helper function 
       const addSection = (label, values) => {
    if (values && (Array.isArray(values) ? values.length > 0 : values !== '')) {
        if (yPos + lineHeight > pageHeight) { 
            doc.addPage(); 
            yPos = 10; 
        }
        doc.setFont(undefined, 'bold');
        doc.text(label, 10, yPos);
        yPos += lineHeight;

        doc.setFont(undefined, 'normal');
        let text = Array.isArray(values) ? values.join(', ') : values.toString();
        const lines = doc.splitTextToSize(text, 180);
        lines.forEach(line => {
            if (yPos + lineHeight > pageHeight) { 
                doc.addPage(); 
                yPos = 10; 
            }
            doc.text(line, 10, yPos);
            yPos += lineHeight;
        });
        yPos += 5;
    }
};

// General Property Description - Property Type
if (this.propertyType && this.propertyType.length > 0) {
    doc.addPage();
    yPos = 10;

    doc.setFont(undefined, 'bold');
    doc.setFontSize(14);
    doc.text('General Property Description:', 10, yPos);
    yPos += lineHeight;

    doc.setFontSize(12);
    doc.setFont(undefined, 'bold');
    doc.text('Property Type:', 10, yPos);
    doc.setFont(undefined, 'normal');
    const propText = this.propertyType.join(', ');
    doc.text(propText, 60, yPos);
    yPos += lineHeight + 5;
}

// Type of Roof Covering
if (this.roofCovering && this.roofCovering.length > 0) {
    doc.setFontSize(12);
    doc.setFont(undefined, 'bold');
    doc.text('Type of Roof Covering:', 10, yPos);
    doc.setFont(undefined, 'normal');
    const roofText = this.roofCovering.join(', ');
    doc.text(roofText, 60, yPos);
    yPos += lineHeight + 5;
}


addSection('Underlayment:', this.underlayment);
addSection('Layer(s) of Shingles Installed:', this.layerShingles);
addSection('Ventilation:', this.ventilation);
addSection('Pipe Jacks:', this.pipeJacks);
addSection('Vent Stack(s):', this.ventStack);
addSection('Chimney(s):', this.chimney);
addSection('Roof Observed From:', this.roofObserved);
addSection('Predominant Roof Pitch:', this.roofPitch);
if (this.roofAge) addSection('Roof Age:', [this.roofAge]);
if (this.inspectionNotes) addSection('Inspection Notes:', [this.inspectionNotes]);


        // Other Images (Right, Rear, Left, Other)
        for (let typeObj of this.photoTypes.filter(t => t.value !== 'front')) {
            if (typeObj.images.length > 0) {
                if (yPos + 10 > pageHeight) { doc.addPage(); yPos = 10; }
                doc.setFont(undefined, 'bold');
                doc.text(typeObj.label, 10, yPos);
                yPos += 5;

                for (let img of typeObj.images) {
                    if (yPos + 105 > pageHeight) { doc.addPage(); yPos = 10; }
                    const base64 = await this.convertBlobToBase64(img.file);
                    doc.addImage(base64, 'JPEG', 10, yPos, 120, 100);
                    yPos += 105;
                }
                yPos += 5;
            }
        }

        //  Notes Sections
        const notesSections = [
    { label: 'Conclusions & Recommendations', value: this.notes }
];

notesSections.forEach(section => {
    if (yPos + lineHeight > pageHeight) { 
        doc.addPage(); 
        yPos = 10; 
    }

    doc.setFont(undefined, 'bold');
    doc.text(`${section.label}:`, 10, yPos);  
    yPos += lineHeight;

    const textLines = doc.splitTextToSize(section.value || '', 180);
    doc.setFont(undefined, 'normal');
    textLines.forEach(line => {
        if (yPos + lineHeight > pageHeight) { 
            doc.addPage(); 
            yPos = 10; 
        }
        doc.text(line, 10, yPos);
        yPos += lineHeight;
    });
    yPos += 5;
});


       
        // Itemized Repairs Section (Only selected repairs will show)
if (this.repairs && this.repairs.length > 0) {
    let grandTotal = 0;

    const selectedRepairs = this.repairs.filter(r => r.quantity > 0);

    if (selectedRepairs.length > 0) {
        if (yPos + lineHeight > pageHeight) { doc.addPage(); yPos = 10; }

        // Section Heading
        doc.setFont(undefined, 'bold');
        doc.setFontSize(14);
        doc.text("Itemized Repairs:", 10, yPos);
        yPos += lineHeight;

        // Table Header
        doc.setFontSize(12);
        doc.setFont(undefined, 'bold');
        doc.text(" Item", 10, yPos);
        doc.text("Qty", 100, yPos);
        doc.text("Unit Price", 120, yPos);
        doc.text("Total", 160, yPos);
        yPos += lineHeight;

        // Table Rows
        doc.setFont(undefined, 'normal');
        selectedRepairs.forEach(item => {
            const total = item.quantity * item.price;
            grandTotal += total;

            if (yPos + lineHeight > pageHeight) { doc.addPage(); yPos = 10; }

            doc.text(item.name, 10, yPos);
            doc.text(String(item.quantity), 105, yPos);
            doc.text(`$${item.price.toFixed(2)}`, 120, yPos);
            doc.text(`$${total.toFixed(2)}`, 160, yPos);

            yPos += lineHeight;
        });

        // Grand Total
        if (yPos + lineHeight > pageHeight) { doc.addPage(); yPos = 10; }
        yPos += 5;
        doc.setFont(undefined, 'bold');
        doc.text("Grand Total", 120, yPos);
        doc.text(`$${grandTotal.toFixed(2)}`, 160, yPos);
        yPos += lineHeight * 2;
    }
}


        //  Dynamic Blocks — one image per page with "Photo Of"
        const photoNote = "The photographs that follow are intended to be a representative sample of the kind of flaws that exist at the property. This is not an exhaustive cataloging of every imperfection needing addressed:";
        const photoNoteLines = doc.splitTextToSize(photoNote, 180);
        if (yPos + photoNoteLines.length * lineHeight > pageHeight) { doc.addPage(); yPos = 10; }
        doc.setFont(undefined, 'bold');
        photoNoteLines.forEach((line, idx) => {
            doc.text(line, 10, yPos + idx * lineHeight);
        });
        yPos += photoNoteLines.length * lineHeight + 5;

        for (let block of this.photoBlocks) {
            if (block.file) {
                doc.addPage();
                yPos = 10;

               if (block.selectedTypes.length > 0) {
    doc.setFont(undefined, 'bold');

    // Determine the caption for PDF
    let photoOfText = "Photo Of: ";
    if (block.selectedTypes.includes('other') && block.otherName) {
        photoOfText += block.otherName; // use the entered name
    } else {
        // for normal types, use labels
        photoOfText += block.selectedTypes.map(t => this.getLabel(t)).join(', ');
    }

    doc.text(photoOfText, 10, yPos);
    yPos += 10;
}


                const base64 = await this.convertBlobToBase64(block.file);
                doc.setFont(undefined, 'normal');
                doc.addImage(base64, 'JPEG', 10, yPos, 180, 150); // full width
            }
        }

        // Upload PDF to Salesforce
        const pdfBlob = doc.output('blob');
        await InspectionReportpdf({
            opportunityId: this.recordId,
            base64Pdf: await this.convertBlobToBase64(pdfBlob),
            fileName: `Opportunity_${this.recordId}_Inspection.pdf`
        });

        this.uploadSuccess = true;
        this.showToast('Success', 'PDF uploaded successfully!', 'success');
    } catch (error) {
        this.uploadError = true;
        this.uploadErrorMessage = error.message || error;
        this.showToast('Error', 'Error generating/uploading PDF: ' + (error.message || error), 'error');
    } finally {
        this.isLoading = false;
    }
}

}
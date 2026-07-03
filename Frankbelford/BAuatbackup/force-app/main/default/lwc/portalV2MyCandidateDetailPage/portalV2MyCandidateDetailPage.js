import { LightningElement, api } from 'lwc';


export default class PortalV2MyCandidatesDetailPage extends LightningElement {
    @api recordId;

    connectedCallback() {
        const url = window.location.href;
        console.log('📌 Full URL:', url);

        const segments = url.split('/');
        this.recordId = segments[segments.length - 2];

        
            console.log('✅ Extracted Contact Record ID:', this.recordId);
        
    }

    
}
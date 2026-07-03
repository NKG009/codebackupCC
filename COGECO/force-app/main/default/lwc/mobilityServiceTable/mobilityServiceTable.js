import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getMobilityServices from '@salesforce/apex/MobilityServiceController.getMobilityServices';
import saveMobilityServices from '@salesforce/apex/MobilityServiceController.saveMobilityServices';
import deleteMobilityService from '@salesforce/apex/MobilityServiceController.deleteMobilityService';

export default class MobilityServiceTable extends LightningElement {
    @api recordId;
    @track mobilityServices = [];
    @track isEditing = false;
    @track isLoading = true;
    @track originalData = [];

    @track showDeleteModal = false;
    @track recordToDelete = null;
    @track deleteRecordName = '';

    wiredMobilityServicesResult;
    _isInitialized = false;

    connectedCallback() {
        console.log('Component connected. RecordId:', this.recordId);

        setTimeout(() => {
            if (!this._isInitialized && this.recordId) {
                console.warn('Wire not initialized. Loading manually.');
                this.loadMobilityServicesManually();
            } else if (!this.recordId) {
                console.error('No recordId passed to component');
                this.showToast('Error', 'Component not initialized properly. Account Plan ID is missing.', 'error');
                this.isLoading = false;
            }
        }, 3000);
    }

    @wire(getMobilityServices, { accountPlanId: '$recordId' })
    wiredMobilityServices(result) {
        this.wiredMobilityServicesResult = result;

        if (result.data) {
            this._isInitialized = true;
            console.log('Wire data loaded successfully.');
            this.processMobilityServicesData(result.data);
            this.isLoading = false;
        } else if (result.error) {
            this._isInitialized = true;
            console.error('Wire error:', result.error);
            this.showToast('Error', 'Failed to load mobility services', 'error');
            this.initializeBlankRows();
            this.isLoading = false;
        }
    }

    loadMobilityServicesManually() {
        if (!this.recordId) return;

        this.isLoading = true;

        getMobilityServices({ accountPlanId: this.recordId })
            .then(data => {
                this._isInitialized = true;
                this.processMobilityServicesData(data);
                this.isLoading = false;
            })
            .catch(error => {
                this._isInitialized = true;
                console.error('Manual load error:', error);
                this.showToast('Error', 'Failed to load mobility services: ' + error.body.message, 'error');
                this.initializeBlankRows();
                this.isLoading = false;
            });
    }

    processMobilityServicesData(data) {
        if (data && data.length > 0) {
            this.mobilityServices = data.map(service => ({
                ...service,
                tempId: service.Id || this.generateTempId(),
                recordId: service.Id,
                isNew: false
            }));
        } else {
            this.initializeBlankRows();
        }

        this.originalData = JSON.parse(JSON.stringify(this.mobilityServices));
    }

    initializeBlankRows() {
        this.mobilityServices = [];
        for (let i = 0; i < 3; i++) {
            this.mobilityServices.push(this.createBlankRow());
        }
        this.originalData = JSON.parse(JSON.stringify(this.mobilityServices));
    }

    createBlankRow() {
        return {
            tempId: this.generateTempId(),
            Service_Element__c: '',
            TELUS_Roaming__c: '',
            TELUS_MVNO_Wholesale__c: '',
            ROGERS__c: '',
            BELL__c: '',
            Account_Plan__c: this.recordId,
            recordId: null,
            isNew: true
        };
    }

    generateTempId() {
        return 'temp_' + Date.now() + '_' + Math.random().toString(36).substring(2, 9);
    }

    handleEdit() {
        this.isEditing = true;
        this.originalData = JSON.parse(JSON.stringify(this.mobilityServices));
        if (this.mobilityServices.length === 0 || this.mobilityServices.every(service => service.recordId)) {
            this.mobilityServices.push(this.createBlankRow());
        }
    }

    handleCancel() {
        this.isEditing = false;
        this.mobilityServices = JSON.parse(JSON.stringify(this.originalData));
    }

    handleSave() {
        if (!this.recordId) {
            this.showToast('Error', 'Missing Account Plan ID', 'error');
            return;
        }

        const servicesToSave = this.mobilityServices.filter(service =>
            service.Service_Element__c ||
            service.TELUS_Roaming__c ||
            service.TELUS_MVNO_Wholesale__c ||
            service.ROGERS__c ||
            service.BELL__c
        ).map(service => {
            const cleaned = {
                Service_Element__c: service.Service_Element__c || '',
                TELUS_Roaming__c: service.TELUS_Roaming__c || '',
                TELUS_MVNO_Wholesale__c: service.TELUS_MVNO_Wholesale__c || '',
                ROGERS__c: service.ROGERS__c || '',
                BELL__c: service.BELL__c || '',
                Account_Plan__c: this.recordId
            };
            if (service.recordId && !service.isNew) {
                cleaned.Id = service.recordId;
            }
            return cleaned;
        });

        if (servicesToSave.length === 0) {
            this.showToast('Warning', 'No data to save', 'warning');
            return;
        }

        this.isLoading = true;

        saveMobilityServices({ services: servicesToSave, accountPlanId: this.recordId })
            .then(saved => {
                this.showToast('Success', 'Services saved!', 'success');
                this.processSavedRecords(saved);
                this.isEditing = false;
            })
            .catch(error => {
                console.error('Save error:', error);
                this.showToast('Error', error.body.message || 'Save failed.', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    processSavedRecords(savedRecords) {
        this.mobilityServices = this.mobilityServices.map(service => {
            if (service.isNew) {
                const match = savedRecords.find(saved =>
                    saved.Service_Element__c === service.Service_Element__c &&
                    saved.TELUS_Roaming__c === service.TELUS_Roaming__c &&
                    saved.TELUS_MVNO_Wholesale__c === service.TELUS_MVNO_Wholesale__c &&
                    saved.ROGERS__c === service.ROGERS__c &&
                    saved.BELL__c === service.BELL__c
                );
                if (match) {
                    return {
                        ...service,
                        recordId: match.Id,
                        Id: match.Id,
                        isNew: false
                    };
                }
            }
            return service;
        });

        this.mobilityServices = this.mobilityServices.filter(service =>
            service.Service_Element__c ||
            service.TELUS_Roaming__c ||
            service.TELUS_MVNO_Wholesale__c ||
            service.ROGERS__c ||
            service.BELL__c
        );

        this.originalData = JSON.parse(JSON.stringify(this.mobilityServices));
    }

    handleInputChange(event) {
        const tempId = event.target.dataset.id;
        const field = event.target.dataset.field;
        const value = event.target.value;

        this.mobilityServices = this.mobilityServices.map(service =>
            service.tempId === tempId ? { ...service, [field]: value } : service
        );
    }

    handleAddRow(event) {
        const tempId = event.target.dataset.id;
        const index = this.mobilityServices.findIndex(s => s.tempId === tempId);
        const newRow = this.createBlankRow();
        this.mobilityServices.splice(index + 1, 0, newRow);
        this.mobilityServices = [...this.mobilityServices];
    }

    handleDeleteRow(event) {
        const tempId = event.target.dataset.id;
        const toDelete = this.mobilityServices.find(s => s.tempId === tempId);

        if (toDelete.recordId && !toDelete.isNew) {
            this.recordToDelete = toDelete;
            this.deleteRecordName = toDelete.Service_Element__c || 'Record';
            this.showDeleteModal = true;
        } else {
            this.mobilityServices = this.mobilityServices.filter(s => s.tempId !== tempId);
        }
    }

    handleDeleteConfirm() {
        this.isLoading = true;
        this.showDeleteModal = false;

        deleteMobilityService({ serviceId: this.recordToDelete.recordId })
            .then(() => {
                this.showToast('Success', 'Record deleted', 'success');
                this.mobilityServices = this.mobilityServices.filter(
                    s => s.tempId !== this.recordToDelete.tempId
                );
                if (this.mobilityServices.length === 0) {
                    this.mobilityServices.push(this.createBlankRow());
                }
                this.refreshData();
            })
            .catch(error => {
                console.error('Delete error:', error);
                this.showToast('Error', 'Failed to delete: ' + error.body.message, 'error');
            })
            .finally(() => {
                this.recordToDelete = null;
                this.deleteRecordName = '';
                this.isLoading = false;
            });
    }

    handleDeleteCancel() {
        this.showDeleteModal = false;
        this.recordToDelete = null;
        this.deleteRecordName = '';
    }

    refreshData() {
        if (this.wiredMobilityServicesResult) {
            this.isLoading = true;
            refreshApex(this.wiredMobilityServicesResult)
                .finally(() => {
                    this.isLoading = false;
                });
        } else {
            this.loadMobilityServicesManually();
        }
    }

    get hasData() {
        return this.mobilityServices.length > 0;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    errorCallback(error, stack) {
        console.error('Component error:', error);
        console.error('Stack:', stack);
        this.showToast('Error', 'Unexpected error: ' + error.message, 'error');
        this.isLoading = false;
    }
}
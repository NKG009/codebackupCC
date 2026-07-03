import { LightningElement, api, wire, track } from 'lwc';
import getSitesForAccount from '@salesforce/apex/VMSConfigController.getSitesForAccount';
import featchSiteData from '@salesforce/apex/VMSConfigController.featchSiteData';
import saveSupplierTiers from '@salesforce/apex/VMSConfigController.saveSupplierTiers';
import getSuppliersForAccount from '@salesforce/apex/VMSConfigController.getSuppliersForAccount';
import getJobOrderforSite from '@salesforce/apex/VMSConfigController.getJobOrderforSite';
import updateVendStatus from '@salesforce/apex/VMSConfigController.updateVendStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateJobOrdersApex from '@salesforce/apex/VMSConfigController.updateJobOrders';

export default class VmsConfig extends LightningElement {

    @api recordId;
    @track sites = [];
    @track allSuppliers = [];
    @track allJobOrders = [];
    @track selectedSiteId = '';
    @track selectedSiteRecord = [];
    @track showtable = false;
    @track isLoading = false;
    @track searchTerm = '';
    @track isDropdownVisible = false;
    @track filteredSites = [];

    @track siteName = '';
    @track siteAdditionalSLA = '';
    @track siteMainContact = '';
    @track siteStreetAddress = '';
    @track siteCity = '';
    @track sitePostalCode = '';
    @track siteMainContactId = '';

    @track tierOption = [{ label: 'Null', value: 'Null', selected: false },
    { label: 'Tier 1', value: 'Tier 1', selected: false },
    { label: 'Tier 2', value: 'Tier 2', selected: false }];


    handleSearchChange(event) {
        this.searchTerm = event.target.value;

        if (this.searchTerm) {
            this.filteredSites = this.sites.filter(site =>
                site.label.toLowerCase().includes(this.searchTerm.toLowerCase())
            );
        } else {
            this.filteredSites = [...this.sites];
        }

        this.isDropdownVisible = this.filteredSites.length > 0;
    }

    showDrop() {
        this.isDropdownVisible = this.filteredSites.length > 0;
    }

    hideDrop() {
        setTimeout(() => { this.isDropdownVisible = false; }, 200);
    }

    handleSelectSite(event) {
        const selectedId = event.currentTarget.dataset.id;
        const selectedSite = this.sites.find(site => site.value === selectedId);
        if (selectedId) {
            console.log('======================if selectedSite');
            this.selectedSiteId = selectedId;
            this.getSiteData();
        }

        this.isDropdownVisible = false;
    }


    @wire(getSitesForAccount, { accountId: '$recordId', searchTerm: '$searchTerm' })
    wiredSites({ error, data }) {
        if (data) {
            this.sites = data.map(site => ({
                label: site.Name,
                value: site.Id
            }));
            this.filteredSites = [...this.sites];
        } else if (error) {
            console.error('Error fetching sites:', error);
        }
    }

    get siteRecordUrl() {
        return this.selectedSiteId ? `/lightning/r/Site__c/${this.selectedSiteId}/view` : '#';
    }

    get contactRecordUrl() {
        return this.selectedSiteId ? `/lightning/r/Contact/${this.siteMainContactId}/view` : '#';
    }



    getSiteData() {
        featchSiteData({ selectedSiteId: this.selectedSiteId })
            .then((data) => {
                this.siteName = '';
                this.siteAdditionalSLA = '';
                this.siteMainContact = '';
                this.siteStreetAddress = '';
                this.siteCity = '';
                this.sitePostalCode = '';
                this.siteMainContactId = '';

                const site = data[0];
                console.log('======================getSiteData' + JSON.stringify(data));

                this.siteName = site?.Name || '';
                this.siteAdditionalSLA = site?.Additional_SLA__c || '';
                this.siteMainContact = site?.IP_MainContact__r?.Name || '';
                this.siteMainContactId = site?.IP_MainContact__c || '';
                this.siteStreetAddress = site?.sirenum__Street_Address__c || '';
                this.siteCity = site?.sirenum__City__c || '';
                this.sitePostalCode = site?.sirenum__Postal_Code__c || '';

                this.getSuppliersData();
                this.getJobOrderData();
                this.isTierDisabled = false;
                this.showtable = true;
            })
            .catch((error) => {
                console.error('Error fetching site data:', error);
            });
    }

    @track isSuppliersData = true;


/*
    getSuppliersData() {
        console.log('====================== getSuppliersData START');

        if (!this.recordId || !this.selectedSiteId) {
            console.error('Missing required parameters: Account ID or Site ID.');
            return;
        }

        getSuppliersForAccount({ accountId: this.recordId, siteId: this.selectedSiteId })
            .then((data) => {
                console.log('Data received from getSuppliersForAccount:', JSON.stringify(data));
                this.isSuppliersView = false;
                if (!data || data.length === 0) {
                    console.warn('No suppliers found.');
                    this.allSuppliers = [];
                    this.isSuppliersData = false;
                    return;
                }

                this.allSuppliers = data.map(supplier => {
                    console.log('============================= supplier : ' + supplier);
                    let tierValue = supplier?.Site_Supplier_Links__r?.[0]?.Tier__c || 'Null';

                    console.log('============================= tierValue : ' + tierValue);


                    return {
                        ...supplier,
                        AccountName: supplier?.Account__r?.Name || '',
                        SuppliersUrl: '/lightning/r/Suppliers__c/' + supplier.Id + '/view',
                        SupplierName: supplier?.Supplier__r?.Name || '',
                        InstantVendDateTime: supplier?.Site_Supplier_Links__r?.[0]?.Instant_Vend_Date_Time__c || '',
                        SiteSupplierLinksId: supplier?.Site_Supplier_Links__r?.[0]?.Id || '',
                        SiteSupplierLinkUrl: '/lightning/r/Site_Supplier_Links__r/' + supplier?.Site_Supplier_Links__r?.[0]?.Id + '/view',
                        Override: supplier.Override__c,
                        
                        tierOption: [
                            { label: '--None--', value: '', selected: tierValue === '' },
                            { label: 'Tier 1', value: 'Tier 1', selected: tierValue === 'Tier 1' },
                            { label: 'Tier 2', value: 'Tier 2', selected: tierValue === 'Tier 2' }
                        ]
                    };
                });
                console.log('============================= this.allSuppliers asitis : ' + JSON.stringify(this.allSuppliers));
                // Sort: Tier 1 → Tier 2 → All Tier → Others
                const tierOrder = {
                    'Tier 1': 0,
                    'Tier 2': 1,
                    'All Tier': 2
                };

                this.allSuppliers.sort((a, b) => {
                    const tierA = tierOrder.hasOwnProperty(a.tierValue) ? tierOrder[a.tierValue] : 99;
                    const tierB = tierOrder.hasOwnProperty(b.tierValue) ? tierOrder[b.tierValue] : 99;
                    return tierA - tierB;
                });

                console.log('============================= this.allSuppliers shorted : '+ JSON.stringify(this.allSuppliers));

                this.isSuppliersData = true;
                this.isSuppliersView = true;
                console.log('Final allSuppliers:', JSON.stringify(this.allSuppliers));
            })
            .catch((error) => {
                console.error('Error fetching suppliers:', JSON.stringify(error));
            });
    }*/

    getSuppliersData() {
    console.log('====================== getSuppliersData START');

    if (!this.recordId || !this.selectedSiteId) {
        console.error('Missing required parameters: Account ID or Site ID.');
        return;
    }

    getSuppliersForAccount({ accountId: this.recordId, siteId: this.selectedSiteId })
        .then((data) => {
            console.log('Data received from getSuppliersForAccount:', JSON.stringify(data));
            this.isSuppliersView = false;

            if (!data || data.length === 0) {
                console.warn('No suppliers found.');
                this.allSuppliers = [];
                this.isSuppliersData = false;
                return;
            }

            this.allSuppliers = data.map(supplier => {
                console.log('============================= supplier : ', supplier);
                let tierValue = supplier?.Site_Supplier_Links__r?.[0]?.Tier__c || '';

                console.log('============================= tierValue : ' + tierValue);

                return {
                    ...supplier,
                    AccountName: supplier?.Account__r?.Name || '',
                    SuppliersUrl: '/lightning/r/Suppliers__c/' + supplier.Id + '/view',
                    SupplierName: supplier?.Supplier__r?.Name || '',
                    InstantVendDateTime: supplier?.Site_Supplier_Links__r?.[0]?.Instant_Vend_Date_Time__c || '',
                    SiteSupplierLinksId: supplier?.Site_Supplier_Links__r?.[0]?.Id || '',
                    SiteSupplierLinkUrl: '/lightning/r/Site_Supplier_Links__r/' + (supplier?.Site_Supplier_Links__r?.[0]?.Id || '') + '/view',
                    Override: supplier.Override__c,
                    tierValue: tierValue, // 🛠️ Save tierValue to use in sorting
                    tierOption: [
                        { label: '--None--', value: '', selected: tierValue === '' },
                        { label: 'Tier 1', value: 'Tier 1', selected: tierValue === 'Tier 1' },
                        { label: 'Tier 2', value: 'Tier 2', selected: tierValue === 'Tier 2' }
                    ]
                };
            });

            console.log('============================= this.allSuppliers as-is: ', JSON.stringify(this.allSuppliers));

            // Sort: Tier 1 → Tier 2 → All Tier → Others
            const tierOrder = {
                'Tier 1': 0,
                'Tier 2': 1,
                'All Tier': 2
            };

            this.allSuppliers.sort((a, b) => {
                const tierA = tierOrder.hasOwnProperty(a.tierValue) ? tierOrder[a.tierValue] : 99;
                const tierB = tierOrder.hasOwnProperty(b.tierValue) ? tierOrder[b.tierValue] : 99;
                return tierA - tierB;
            });

            console.log('============================= this.allSuppliers sorted: ', JSON.stringify(this.allSuppliers));

            this.isSuppliersData = true;
            this.isSuppliersView = true;
            console.log('Final allSuppliers:', JSON.stringify(this.allSuppliers));
        })
        .catch((error) => {
            console.error('Error fetching suppliers:', JSON.stringify(error));
        });
}


    @track isjobOrderData = true;

    getJobOrderData() {
        console.log('====================== getJobOrderData START');

        if (!this.recordId || !this.selectedSiteId) {
            console.error('Missing required parameters: Account ID or Site ID.');
            return;
        }

        getJobOrderforSite({ accountId: this.recordId, siteId: this.selectedSiteId })
            .then((data) => {
                console.log('Data received from getJobOrderforSite:', JSON.stringify(data));
                this.allJobOrders = [];
                if (!data || data.length === 0) {
                    console.warn('No Job Order found.');
                    this.allJobOrders = [];
                    this.isjobOrderData = false;
                    return;
                }

                const updatedJobOrders = data.map((jobOrder) => ({
                    id: jobOrder.Id,
                    siteId: jobOrder.sirenum__Site__c,
                    siteName: jobOrder.sirenum__Site__r?.Name || '',
                    accountId: jobOrder.sirenum__Account__c,
                    accountName: jobOrder.sirenum__Account__r?.Name || '',
                    jobRoleName: jobOrder.sirenum__JobRole__r?.Name || '',
                    jobRoleId: jobOrder.sirenum__JobRole__r?.Id || '',
                    jobStatus:jobOrder.sirenum__Status__c || '',
                    jobOrderNumber :  jobOrder.Job_Order_Number__c || '',  
                    jobRoleUrl: '/lightning/r/sirenum__JobRole__c/' + jobOrder.sirenum__JobRole__r?.Id + '/view',
                    jobOrderUrl: '/lightning/r/sirenum__JobOrder__c/' + jobOrder.Id + '/view',
                    name: jobOrder.Name || '',
                    overrideJob: jobOrder.Override__c || false,
                    InstaVendee: jobOrder.Insta_Vended__c || false,
                    InstaVendTier: jobOrder.Instant_Vend_Tier__c || '',
                    startDate: jobOrder.sirenum__StartDate__c || '',
                    endDate: jobOrder.sirenum__EndDate__c || ''
                }));
                console.log('=========================== : ' + JSON.stringify(updatedJobOrders));
                this.allJobOrders = [...updatedJobOrders];

                this.isjobOrderData = true;
                console.log('Final allJobOrders:', JSON.stringify(this.allJobOrders));
            })
            .catch((error) => {
                console.error('Error fetching suppliers:', JSON.stringify(error));
            });
    }

    handleSave() {
        const hasTierChanges = Object.keys(this.tierChanges).length > 0;

        if (!hasTierChanges) {
            this.showToast('Info', 'No changes found.', 'info');
            return;
        }

        if (hasTierChanges) {
            this.handleSaveSupplierTiers();
        }

    }


    @track tierChanges = {};

    handleTierChange(event) {
        const supplierId = event.target.dataset.id;
        const selectedTier = event.target.value;
        this.tierChanges = { ...this.tierChanges, [supplierId]: selectedTier };
        console.log('======================this.tierChanges' + JSON.stringify(this.tierChanges));
        this.isChangesfound = true;
    }

    @track isSuppliersView = true;


    handleSaveSupplierTiers() {
        this.isLoading = true;
        const updates = Object.keys(this.tierChanges).map(supplierId => ({
            supplierId,
            tier: this.tierChanges[supplierId]
        }));

        if (updates.length === 0) {
            this.isLoading = false;
            this.showToast('Info', 'No changes found.', 'info');
            return;
        }

        console.log('======================updates' + JSON.stringify(updates));

        if (updates.length > 0) {
            saveSupplierTiers({ siteId: this.selectedSiteId, updates })
                .then((data) => {

                    if (data) {
                        const messg = data;
                        if (messg === 'Supplier Tier updated successfully!') {
                            this.showToast('Success', messg, 'success');
                        }
                        this.tierChanges = {};

                    }
                })

                .catch(error => {
                    console.error('Error updating tiers:', error);
                    this.showToast('Error', 'Failed to update supplier tiers.', 'error');
                });


            setTimeout(() => {
                this.isLoading = false;
                this.getSuppliersData();
            }, 4000);

        }
    }
    @track isChangesfound = false;


    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }



    @track changedRecords = [];
    @track selectedTier = '';

    handleCheckboxChange(event) {
        const jobOrderId = event.target.dataset.id;
        const isChecked = event.target.checked;

        let record = this.changedRecords.find((rec) => rec.Id === jobOrderId);

        if (!record) {
            record = { Id: jobOrderId };
            this.changedRecords.push(record);
        }

        record.Insta_Vended__c = isChecked;

        if (isChecked) {
            record.Instant_Vend_Tier__c = this.selectedTier || null;
        } else {
            record.Instant_Vend_Tier__c = null;
        }

        console.log('Updated changedRecords:', JSON.stringify(this.changedRecords));
    }


    handleTierSelection(event) {
        this.selectedTier = event.target.value;
        console.log('Selected Tier:', this.selectedTier);

        this.changedRecords.forEach((record) => {
            if (record.Insta_Vended__c) {
                record.Instant_Vend_Tier__c = this.selectedTier || null;
            }
        });

        console.log('Updated changedRecords after tier selection:', JSON.stringify(this.changedRecords));
    }

    @track isCheckboxChecked = false;

    handelupdateJobOrders() {
        this.isLoading = true;
        console.log('Executing handelupdateJobOrders');

        if (this.changedRecords.length === 0) {
            this.showToast('Error', 'Please select at least one job order to update.', 'error');
            this.isLoading = false;
            return;

        }

        updateJobOrdersApex({ jobOrders: this.changedRecords, siteId: this.selectedSiteId })
            .then((message) => {
                this.showToast('Success', message, 'success');

                this.changedRecords = [];
                this.selectedTier = '';

                this.getJobOrderData();

            })
            .catch((error) => {
                console.error('Error updating job orders:', error);
                this.showToast('Error', 'Error updating job orders: ' + error.body.message, 'error');
            });
        this.isLoading = false;
    }



    handelVendClick(event) {
        const siteId = this.selectedSiteId;
        const supplierId = event.target.dataset.id;

        if (!siteId || !supplierId) {
            this.showToast('Error', 'Missing Site or Supplier information.', 'error');
            return;
        }

        this.isLoading = true;

        updateVendStatus({ siteId: siteId, supplierId: supplierId, isVend: true })
            .then((message) => {
                this.showToast('Success', message, 'success');
                this.getSuppliersData();
            })
            .catch((error) => {
                console.error('Error updating Vend status:', error);
                this.showToast('Error', 'Failed to update Vend status.', error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }


    @track isVendPopupVisible = false;
    @track selectedSupplierId = '';
    @track selectedSuppliername = '';

    showVendConfirmationPopup(event) {
        this.selectedSupplierId = event.target.dataset.id;
        this.selectedSuppliername = event.target.dataset.name;
        this.isVendPopupVisible = true;

        console.log('=============showVendConfirmationPopup selectedSupplierId : ' + this.selectedSupplierId);
    }

    hideVendConfirmationPopup() {
        this.isVendPopupVisible = false;

    }

    handleVendConfirmed() {
        this.hideVendConfirmationPopup();
        const siteId = this.selectedSiteId;
        const supplierId = this.selectedSupplierId;
        if (!siteId || !supplierId) {
            this.showToast('Error', 'Missing Site or Supplier information.', 'error');
            return;
        }

        this.isLoading = true;

        updateVendStatus({ siteId: siteId, supplierId: supplierId, isVend: true })
            .then((message) => {
                this.showToast('Success', message, 'success');
                this.getSuppliersData();
            })
            .catch((error) => {
                console.error('Error updating Vend status:', error);
                this.showToast('Error', 'Failed to update Vend status.', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
        this.selectedSupplierId = '';
    }


}
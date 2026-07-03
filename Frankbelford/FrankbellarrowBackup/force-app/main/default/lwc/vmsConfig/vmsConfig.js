import { LightningElement, api, wire, track } from 'lwc';
import getSitesForAccount from '@salesforce/apex/VMSConfigController.getSitesForAccount';
import featchSiteData from '@salesforce/apex/VMSConfigController.featchSiteData';
import saveSupplierTiers from '@salesforce/apex/VMSConfigController.saveSupplierTiers';
import getSuppliersForAccount from '@salesforce/apex/VMSConfigController.getSuppliersForAccount';
import getJobOrderforSite from '@salesforce/apex/VMSConfigController.getJobOrderforSite';
import updateSupplierOverrides from '@salesforce/apex/VMSConfigController.updateSupplierOverrides';
import updateJobOrderOverrides from '@salesforce/apex/VMSConfigController.updateJobOrderOverrides';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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
                        Override: supplier.Override__c,
                        tierOption: [
                            { label: '--None--', value: '', selected: tierValue === '' },
                            { label: 'Tier 1', value: 'Tier 1', selected: tierValue === 'Tier 1' },
                            { label: 'Tier 2', value: 'Tier 2', selected: tierValue === 'Tier 2' }
                        ]
                    };
                });
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

                this.allJobOrders = data.map((jobOrder) => ({
                    id: jobOrder.Id,
                    siteId: jobOrder.sirenum__Site__c,
                    siteName: jobOrder.sirenum__Site__r.Name,
                    accountId: jobOrder.sirenum__Account__c,
                    accountName: jobOrder.sirenum__Account__r.Name,
                    jobRoleName: jobOrder.sirenum__JobRole__r.Name,
                    jobOrderUrl: '/lightning/r/sirenum__JobOrder__c/' + jobOrder.Id + '/view',
                    name: jobOrder.Name,
                    startDate: jobOrder.sirenum__StartDate__c,
                    endDate: jobOrder.sirenum__EndDate__c
                }));

                this.isjobOrderData = true;
                console.log('Final allJobOrders:', JSON.stringify(this.allJobOrders));
            })
            .catch((error) => {
                console.error('Error fetching suppliers:', JSON.stringify(error));
            });
    }

    handleSave() {
        const hasTierChanges = Object.keys(this.tierChanges).length > 0;
        const hasOverrideChanges = Object.keys(this.overrideChanges).length > 0;

        if (!hasTierChanges && !hasOverrideChanges) {
            this.showToast('Info', 'No changes found.', 'info');
            return;
        }

        if (hasTierChanges) {
            this.handleSaveSupplierTiers();
        }

        if (hasOverrideChanges) {
            this.handleSaveOverrideCheckbox();
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
                        if (messg === 'Supplier successfully updated!') {
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
              }, 2000);
           
        }
    }
    @track isChangesfound = false;
    @track overrideChanges = {};

    handleOverrideChange(event) {
        const supplierId = event.target.dataset.id;
        console.log('======================this.overrideChanges' + supplierId);
        const isChecked = event.target.checked;
        this.overrideChanges = { ...this.overrideChanges, [supplierId]: isChecked };
        console.log('======================this.overrideChanges' + JSON.stringify(this.overrideChanges));
        this.isChangesfound = true;
    }

    handleSaveOverrideCheckbox() {
        const updates = Object.keys(this.overrideChanges).map(supplierId => ({
            supplierId,
            override: this.overrideChanges[supplierId]
        }));

        console.log('====================== Override Updates' + JSON.stringify(updates));

        updateSupplierOverrides({ updates })
            .then((data) => {
                if (data) {
                    this.showToast('Success', data, 'success');
                    this.overrideChanges = {};

                    // Ensure job orders are updated based on override changes
                const overrideValue = updates.some(update => update.override); // If any supplier is checked, override is true
                this.updateJobOrders(overrideValue);

                }
            })
            .catch(error => {
                console.error('Error updating override:', error);
                this.showToast('Error', 'Failed to update supplier override.', 'error');
            })
            .finally(() => {
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

// New method to update job orders under the selected site
updateJobOrders(overrideValue) {
    updateJobOrderOverrides({ selectedSiteId: this.selectedSiteId, overrideValue })
        .then((data) => {
            if (data) {
                this.showToast('Success', 'Job order overrides updated successfully!', 'success');
            }
        })
        .catch(error => {
            console.error('Error updating job order overrides:', error);
            this.showToast('Error', 'Failed to update job order overrides.', 'error');
        });
}

    


}
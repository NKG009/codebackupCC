public class VMSConfigController {
    
    @AuraEnabled(cacheable=true)
    public static List<sirenum__Site__c> getSitesForAccount(Id accountId, String searchTerm) {
        // If searchTerm is provided, filter based on the term
        String query = 'SELECT sirenum__Operating_Company__c, Id, Name, Additional_SLA__c, IP_MainContact__c, '
            + 'sirenum__Street_Address__c, sirenum__City__c, sirenum__Postal_Code__c, '
            + 'Additional_Supplier_Flat_Fee__c, Additional_Supplier_Percentage_Fee__c '
            + 'FROM sirenum__Site__c '
            + 'WHERE sirenum__Operating_Company__c = :accountId';
        
        if (String.isNotBlank(searchTerm)) {
            query += ' AND Name LIKE :\'%' + searchTerm + '%\'';
        }
        
        return Database.query(query);
    }
        
    @AuraEnabled(cacheable=true)
    public static List<sirenum__JobOrder__c > getJobOrderss(Id jobOrderId) {
        return [
            SELECT Id, sirenum__Site__c, sirenum__Account__c, sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,Instant_Vend_Tier__c,Insta_Vended__c,
            sirenum__Site__r.Name, sirenum__Account__r.Name, sirenum__JobRole__r.Name, Name, Override__c FROM sirenum__JobOrder__c 
            WHERE Id =: jobOrderId];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Suppliers__c> getSuppliersForAccount(Id accountId, Id siteId) {
        return [
            SELECT Id, Name, Account__c, Account__r.Name, Active__c, SLA__c, Supplier__c, Supplier__r.Name, Override__c,
            (SELECT Id, Tier__c, Instant_Vend_Date_Time__c FROM Site_Supplier_Links__r WHERE Site__c = :siteId) 
            FROM Suppliers__c
            WHERE Account__c = :accountId
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sirenum__JobOrder__c > getJobOrderforSite(Id accountId, Id siteId) {
        return [
            SELECT Id, sirenum__Site__c, sirenum__Account__c, sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,Instant_Vend_Tier__c,Insta_Vended__c,
            sirenum__Site__r.Name, sirenum__Account__r.Name, sirenum__JobRole__r.Name, Name, Override__c,sirenum__Status__c FROM sirenum__JobOrder__c 
            WHERE sirenum__Site__c  = :siteId AND sirenum__EndDate__c >= TODAY
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sirenum__JobOrder__c > getsingleJobOrderforSite(Id accountId, Id siteId , Id jobOrderId) {
        system.debug('=======================jobOrderId'+jobOrderId);
        return [
            SELECT Id, sirenum__Site__c, sirenum__Account__c, sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,Instant_Vend_Tier__c,Insta_Vended__c,
            sirenum__Site__r.Name, sirenum__Account__r.Name, sirenum__JobRole__r.Name, Name, Override__c FROM sirenum__JobOrder__c 
            WHERE Id =:jobOrderId
        ];
    }
    
    
    
    
    @AuraEnabled(cacheable=true) 
    public static List<sirenum__Site__c> featchSiteData(Id selectedSiteId) {
        return [
            SELECT sirenum__Operating_Company__c, Id, Name, Additional_SLA__c, IP_MainContact__c,IP_MainContact__r.Name,
            sirenum__Street_Address__c, sirenum__City__c, sirenum__Postal_Code__c,
            Additional_Supplier_Flat_Fee__c, Additional_Supplier_Percentage_Fee__c
            FROM sirenum__Site__c
            WHERE Id = :selectedSiteId
        ];
    }
    
    @AuraEnabled
    public static String saveSupplierTiers(Id siteId, List<Map<String, String>> updates) {
        List<Site_Supplier_Link__c> recordsToUpsert = new List<Site_Supplier_Link__c>();
        List<Site_Supplier_Link__c> recordsToDeactivate = new List<Site_Supplier_Link__c>();
        List<Suppliers__c> suppliersToUpdate = new List<Suppliers__c>();
        
        // Query VMS_Tier_Config__mdt to get Tier and SLA__c mappings
        Map<String, Decimal> tierToSLA = new Map<String, Decimal>();
        List<VMS_Tier_Config__mdt> tierConfigs = [SELECT Id, Label, SLA__c, Tier__c FROM VMS_Tier_Config__mdt];
        for (VMS_Tier_Config__mdt tierConfig : tierConfigs) {
            tierToSLA.put(tierConfig.Tier__c, tierConfig.SLA__c);
        }
        system.debug('============================updates :' + updates);
        
        for (Map<String, String> updatee : updates) {
            String supplierId = updatee.get('supplierId');
            String tier = updatee.get('tier');
            
            // Handle Site_Supplier_Link__c records
            List<Site_Supplier_Link__c> existingRecords = [
                SELECT Id, Site__c, Suppliers__c, Active__c, Tier__c, Instant_Vend_Date_Time__c
                FROM Site_Supplier_Link__c
                WHERE Site__c = :siteId
                AND Suppliers__c = :supplierId
            ];
            
            if (!existingRecords.isEmpty()) {
                for (Site_Supplier_Link__c record : existingRecords) {
                    if (String.isBlank(tier)) { 
                        // If tier is blank and old value exists, deactivate the record
                        if (!String.isBlank(record.Tier__c)) {
                            record.Active__c = false;
                            record.Tier__c = null;
                            recordsToDeactivate.add(record);
                        }
                    } else if (record.Tier__c != tier) { 
                        // If tier is changed, update the record
                        record.Tier__c = tier;
                        record.Active__c = true;
                        recordsToUpsert.add(record);
                    }
                }
            } else if (!String.isBlank(tier)) { 
                // If no record exists and a valid tier is provided, create a new record
                recordsToUpsert.add(new Site_Supplier_Link__c(
                    Site__c = siteId,
                    Suppliers__c = supplierId,
                    Active__c = true,
                    Tier__c = tier
                ));
            }
            
            // Update Suppliers__c SLA logic
            Suppliers__c supplier = [
                SELECT Id, Name, Account__c, Active__c, SLA__c, Supplier__c, Override__c
                FROM Suppliers__c
                WHERE Id = :supplierId
                LIMIT 1
            ];
            
            if (supplier != null) {
                if (String.isBlank(tier)) {
                    // Set SLA__c to null if tier is blank
                    if (supplier.SLA__c != null) {
                        supplier.SLA__c = null;
                        suppliersToUpdate.add(supplier);
                    }
                } else {
                    // Get SLA value from map
                    Decimal sla = tierToSLA.get(tier);
                    
                    // Set SLA__c to null if it is blank in metadata or update it if different
                    if (sla == null) {
                        if (supplier.SLA__c != null) {
                            supplier.SLA__c = null;
                            suppliersToUpdate.add(supplier);
                        }
                    } else if (supplier.SLA__c != sla) {
                        supplier.SLA__c = sla;
                        suppliersToUpdate.add(supplier);
                    }
                }
            }
        }
        
        // Perform DML operations outside loops
        if (!recordsToUpsert.isEmpty()) {
            upsert recordsToUpsert;
        }
        
        if (!recordsToDeactivate.isEmpty()) {
            update recordsToDeactivate;
        }
        
        if (!suppliersToUpdate.isEmpty()) {
            update suppliersToUpdate;
        }
        
        return 'Supplier Tier updated successfully!';
    }
    
    
    @AuraEnabled
    public static String updateVendStatus(Id siteId, Id supplierId, Boolean isVend) {
        try {
            List<Site_Supplier_Link__c> links = [SELECT Id, Instant_Vend_Date_Time__c,Tier__c, Site_Account__c, Suppliers__r.Supplier__c
                                                 FROM Site_Supplier_Link__c 
                                                 WHERE Site__c = :siteId 
                                                 AND Suppliers__c = :supplierId];
            
            Site_Supplier_Link__c link;
            String message;
            
            if (links.isEmpty()) {
                // No matching record found, so create a new one
                link = new Site_Supplier_Link__c(
                    Site__c = siteId,
                    Suppliers__c = supplierId,
                    Instant_Vend_Date_Time__c = isVend ? System.now() : null
                );
                insert link;
                message = isVend ? 'Vend status created successfully!' : 'UnVend status created successfully!';
            } else {
                // Matching record found, so update it
                link = links[0];
                link.Instant_Vend_Date_Time__c = isVend ? System.now() : null;
                update link;
                message = isVend ? 'Vend status updated successfully!' : 'UnVend status updated successfully!';
            }
            
            // Fetch all Job Orders for the site
            List<sirenum__JobOrder__c> jobOrders = [SELECT Id, sirenum__EndDate__c FROM sirenum__JobOrder__c WHERE sirenum__Site__c = :siteId AND sirenum__EndDate__c >= TODAY];
            
            if (!jobOrders.isEmpty()) {
                
                // Create Vend_History__c records
                List<Vend_History__c> vendHistoryRecords = new List<Vend_History__c>();
                Id loggedInUserId = UserInfo.getUserId();
                DateTime currentTime = System.now();
                
                for (sirenum__JobOrder__c jobOrder : jobOrders) {
                    vendHistoryRecords.add(new Vend_History__c(
                        Job_Order__c = jobOrder.Id,
                        Vended_to_Tier__c = 'Vend All',
                        Vended_By__c = loggedInUserId,
                        Vended_to_Supplier__c = supplierId,
                        Supplier_Account__c = (link != null && link.Suppliers__r != null) ? link.Suppliers__r.Supplier__c : null,
                        Supplier_Tier__c = (link != null && link.Tier__c != null) ? link.Tier__c : null,
                        Date_Time__c = currentTime
                    ));
                }
                
                if (!vendHistoryRecords.isEmpty()) {
                    insert vendHistoryRecords;
                }
                
                if (isVend && link.Site_Account__c != null) {
                    sendEmailToContacts(siteId, supplierId);
                }
            }
            
            return message;
        } catch (Exception e) {
            String errorDetails = 'Error: ' + e.getMessage() + '-- ' + e.getStackTraceString();
            throw new AuraHandledException(errorDetails);
        }
    }
    
    @AuraEnabled
    public static String genrateLink(Id siteId, Id supplierId) {
        try {
            List<Site_Supplier_Link__c> links = [SELECT Id, Instant_Vend_Date_Time__c,Tier__c, Site_Account__c, Suppliers__r.Supplier__c
                                                 FROM Site_Supplier_Link__c 
                                                 WHERE Site__c = :siteId 
                                                 AND Suppliers__c = :supplierId];
            
            Site_Supplier_Link__c link;
            String message;
            
            if (links.isEmpty()) {
                // No matching record found, so create a new one
                link = new Site_Supplier_Link__c(
                    Site__c = siteId,
                    Suppliers__c = supplierId
                );
                insert link;
                message = 'Link Genrated successfully';
            } else {
                message ='Link Alreaady avaiable';
            }
            return message;
        } catch (Exception e) {
            String errorDetails = 'Error: ' + e.getMessage() + '-- ' + e.getStackTraceString();
            throw new AuraHandledException(errorDetails);
        }
    }
    
    
    
    @future
    private static void sendEmailToContacts(Id siteId, Id supplierId) { 
        try {
            // Fetch the account ID from the site
            sirenum__Site__c site = [
                SELECT Id, sirenum__Operating_Company__c 
                FROM sirenum__Site__c 
                WHERE Id = :siteId 
                LIMIT 1
            ];
             
            // Fetch the supplier details
            Suppliers__c supplier = [
                SELECT Id, Name,Supplier__c, Supplier__r.Name 
                FROM Suppliers__c 
                WHERE Id = :supplierId 
                LIMIT 1
            ];
            
            
            // Ensure the account ID exists
            if (supplier.Supplier__c == null) {
                throw new AuraHandledException('No Company (Account) is associated with the given supplier.');
            }
            
            Id accountId = supplier.Supplier__c;
            Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            system.debug('=====================contactRecordTypeId ' + contactRecordTypeId);
            List<Contact> contacts = [SELECT Id, FirstName,RecordType.Name, Email FROM Contact 
                                      WHERE AccountId =: accountId
                                      AND Email != null 
                                      AND Person_Status__c = 'Active'
                                      AND RecordTypeId =: contactRecordTypeId];
            
            system.debug('=====================contacts ' + contacts);
            
            if (contacts.isEmpty()) {
                system.debug('No contacts found for the given account with Person_Status__c = Active & RecordType.Name = Contact.');
                return; // No contacts to email
            }
            
            
            
            // Ensure the supplier exists and has a name
            if (supplier == null || supplier.Supplier__r.Name == null) {
                throw new AuraHandledException('Supplier details are not found or do not have a valid name.');
            }
            
            String agencyName = supplier.Supplier__r.Name; // Use Supplier__r.Name as agencyName
            
            // Fetch all job orders related to the site
            List<sirenum__JobOrder__c> jobOrders = [
                SELECT Id, Name, sirenum__JobRole__r.Name, sirenum__StartDate__c, sirenum__EndDate__c, sirenum__Site__r.Name 
                FROM sirenum__JobOrder__c 
                WHERE sirenum__Site__c = :siteId And sirenum__EndDate__c >= TODAY
            ];
            
            if (jobOrders.isEmpty()) {
                throw new AuraHandledException('No job orders found for the given Site ID.');
            }
            
            // Build job order details HTML
            String jobOrderDetails = '';
            String jobOrderLink = '';
            String baseURL = URL.getOrgDomainUrl().toExternalForm();
            for (sirenum__JobOrder__c jobOrder : jobOrders) {
                String jobOrderId = jobOrder.Id != null ? jobOrder.Id : 'N/A';
                String jobRoleId = jobOrder.sirenum__JobRole__c != null ? jobOrder.sirenum__JobRole__c : 'N/A';
                String jobOrderNumber = jobOrder.Job_Order_Number__c != null ? jobOrder.Job_Order_Number__c : 'N/A';
                String jobRole = jobOrder.sirenum__JobRole__r.Name != null ? jobOrder.sirenum__JobRole__r.Name : 'N/A';
                String siteName = jobOrder.sirenum__Site__r.Name != null ? jobOrder.sirenum__Site__r.Name : 'N/A';
                String startDate = jobOrder.sirenum__StartDate__c != null ? String.valueOf(jobOrder.sirenum__StartDate__c) : 'N/A';
                
                // Create a clickable link for the job order
                jobOrderLink = jobOrderId != 'N/A' 
                    ? '<a href="' + baseURL + '/lightning/r/sirenum__JobOrder__c/' + jobOrderId + '/view" target="_blank">here</a>'
                    : 'N/A';
                
                // Make job role clickable if the ID exists
                if (jobRoleId != null) {
                    jobRole = '<a href="' + baseURL + '/lightning/r/sirenum__JobRole__c/' + jobRoleId + '/view" target="_blank">' + jobRole + '</a>';
                }
                
                jobOrderDetails += 
                    
                    
                    '<li><b>Job Order Number:</b> ' + jobOrderNumber + '</li>' +
                    '<li><b>Job Role:</b> ' + jobRole + '</li>' +
                    '<li><b>Site Name:</b> ' + siteName + '</li>' +
                    '<li><b>Start Date:</b> ' + startDate + '</li><br/>';
            }
            
            // Prepare the email messages
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Contact contact : contacts) {
                system.debug('===========================contact.Email' +contact.Email);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { contact.Email });
                
                // Replace placeholders with actual data
                String acknowledgeLink = 'insert acknowledge link';  // Replace with the actual acknowledge link
                String portalLink = 'https://blue-arrow--test.sandbox.my.site.com/cpv2';  // Replace with the actual portal link
                
                email.setSubject('New Booking Assigned');
                email.setHtmlBody(
                    'Dear ' + contact.FirstName + ',<br/><br/>' +
                    'The following booking(s) have been assigned to <b>' + agencyName + '</b>:<br/>' +
                    '<ul>' +
                    jobOrderDetails +
                    '</ul>' +
                    '<br/>' +
                    //'Please click'  + jobOrderLink +  'to acknowledge receipt of this booking. ' +
                    '<br/><br/>' +
                    'To view the full details of the role and to submit candidates, please click <a href="' + portalLink + '">here</a> to access the portal.<br/><br/>' +
                    'Best regards,<br/>' +
                    'Blue Arrow'
                );
                
                emails.add(email);
                
            }
            
            // Send the emails
            Messaging.sendEmail(emails, false);
            
            system.debug('Emails sent successfully.');
        } catch (Exception e) {
            system.debug('Error in sendEmailToContacts: ' + e.getMessage() + '\nStackTrace: ' + e.getStackTraceString());
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String updateJobOrders(List<sObject> jobOrders, Id siteId) {
        try {
            List<sirenum__JobOrder__c> jobOrderUpdates = new List<sirenum__JobOrder__c>();
            List<Vend_History__c> vendHistoryRecords = new List<Vend_History__c>();
            Map<Id, String> jobOrderTierMap = new Map<Id, String>();
            String otier;
            List<Id> jobOrderIds = new List<Id>();
            for (sObject record : jobOrders) {
                sirenum__JobOrder__c jobOrder = (sirenum__JobOrder__c) record;
                jobOrderIds.add(record.Id);
                
                if (record.get('Insta_Vended__c') != null) {
                    jobOrder.Insta_Vended__c = (Boolean) record.get('Insta_Vended__c');
                }
                
                if (record.get('Instant_Vend_Tier__c') != null || record.get('Insta_Vended__c') != null) {
                    if (record.get('Insta_Vended__c') != null && !(Boolean) record.get('Insta_Vended__c')) {
                        jobOrder.Instant_Vend_Tier__c = null;
                    } else {
                        jobOrder.Instant_Vend_Tier__c = (String) record.get('Instant_Vend_Tier__c');
                    }
                }
                
                jobOrderUpdates.add(jobOrder);
                jobOrderTierMap.put(jobOrder.Id, jobOrder.Instant_Vend_Tier__c);
                otier = jobOrder.Instant_Vend_Tier__c;
            }
            
            if (!jobOrderUpdates.isEmpty()) {
                update jobOrderUpdates;
            }
            
            // Fetch suppliers linked to the site along with Supplier__c field
            List<Site_Supplier_Link__c> siteSupplierLinks = [
                SELECT Id, Site__c, Suppliers__c, Tier__c, 
                Suppliers__r.Supplier__c  // Fetch Supplier__c from related object
                FROM Site_Supplier_Link__c
                WHERE Site__c = :siteId
            ];
            
            // Map to store suppliers for each tier
            Map<String, List<Site_Supplier_Link__c>> tierToSuppliersMap = new Map<String, List<Site_Supplier_Link__c>>();
            List<Site_Supplier_Link__c> allTierSuppliers = new List<Site_Supplier_Link__c>();
            
            
            for (Site_Supplier_Link__c link : siteSupplierLinks) {
                if (link.Tier__c != null) { // Only map suppliers with a valid tier
                    if (!tierToSuppliersMap.containsKey(link.Tier__c)) {
                        tierToSuppliersMap.put(link.Tier__c, new List<Site_Supplier_Link__c>());
                    }
                    tierToSuppliersMap.get(link.Tier__c).add(link);
                    
                    // Collect all suppliers with a non-null tier (for "All Tier" scenario)
                    allTierSuppliers.add(link);
                }
            }
            
            Id loggedInUserId = UserInfo.getUserId();
            DateTime currentTime = System.now();
            
            // Create Vend History records
            for (Id jobOrderId : jobOrderTierMap.keySet()) {
                String tier = jobOrderTierMap.get(jobOrderId);
                
                
                
                if (tier != null && tier.equalsIgnoreCase('All Tier')) {
                    // If job order tier is "All Tier", use all suppliers where Tier__c is not null
                    for (Site_Supplier_Link__c supplierLink : allTierSuppliers) {
                        vendHistoryRecords.add(new Vend_History__c(
                            Job_Order__c = jobOrderId,
                            Vended_to_Tier__c = 'All Tier',
                            Vended_By__c = loggedInUserId,
                            Vended_to_Supplier__c = supplierLink.Suppliers__c,
                            Supplier_Account__c = supplierLink.Suppliers__r.Supplier__c, 
                            Supplier_Tier__c = supplierLink.Tier__c,
                            Date_Time__c = currentTime 
                        ));
                    }
                } else if (tier != null && tierToSuppliersMap.containsKey(tier)) {
                    // Matching suppliers found, create Vend_History__c for each supplier
                    for (Site_Supplier_Link__c supplierLink : tierToSuppliersMap.get(tier)) {
                        vendHistoryRecords.add(new Vend_History__c(
                            Job_Order__c = jobOrderId,
                            Vended_to_Tier__c = tier,
                            Vended_By__c = loggedInUserId,
                            Vended_to_Supplier__c = supplierLink.Suppliers__c,
                            Supplier_Account__c = supplierLink.Suppliers__r.Supplier__c,
                            Supplier_Tier__c = supplierLink.Tier__c,
                            Date_Time__c = currentTime 
                        ));
                    }
                } else { 
                    // No supplier matched, insert record with Vended_to_Supplier__c = null
                    vendHistoryRecords.add(new Vend_History__c(
                        Job_Order__c = jobOrderId,
                        Vended_to_Tier__c = (tier == null) ? 'UnVended' : tier,
                        Vended_By__c = loggedInUserId,
                        Vended_to_Supplier__c = null, 
                        Supplier_Account__c = null, 
                        Supplier_Tier__c = null,
                        Date_Time__c = currentTime
                    ));
                }
            }
            
            if (!vendHistoryRecords.isEmpty()) { 
                insert vendHistoryRecords;
            }
            
            if(otier != null ){
                sendEmailToContactsJob(siteId, jobOrderIds, otier);
            }
            
            
            return 'Job orders updated, Vend History created, and emails sent successfully!';
        } catch (Exception e) {
            throw new AuraHandledException('Error updating job orders: ' + e.getMessage());
        }
    }
    
    @future
    private static void sendEmailToContactsJob(Id siteId, List<Id> jobOrderIds, String tier) {
        system.debug('====================siteId : ' + siteId);
        system.debug('====================jobOrderIds : ' + jobOrderIds);
        system.debug('====================tier : ' + tier);
        
        try {
            // Fetch full job order details
            List<sirenum__JobOrder__c> jobOrders = [
                SELECT Id, Name, sirenum__JobRole__r.Name, sirenum__StartDate__c,sirenum__EndDate__c, sirenum__Site__r.Name,Job_Order_Number__c
                FROM sirenum__JobOrder__c
                WHERE Id IN :jobOrderIds And sirenum__EndDate__c >= TODAY
            ];
            
            if (jobOrders.isEmpty()) {
                throw new AuraHandledException('No job orders found for the given IDs.');
            }
            
            // Fetch the account ID from the site
            sirenum__Site__c site = [
                SELECT Id, sirenum__Operating_Company__c 
                FROM sirenum__Site__c 
                WHERE Id = :siteId 
                LIMIT 1
            ];
            
            if (site == null || site.sirenum__Operating_Company__c == null) {
                throw new AuraHandledException('No operating company (account) associated with the given site.');
            }
            
            Id accountId = site.sirenum__Operating_Company__c;
            
            // Fetch suppliers linked to the account
            List<Suppliers__c> suppliers = [
                SELECT Id, Name, Supplier__c
                FROM Suppliers__c 
                WHERE Account__c = :accountId
            ];
            
            if (suppliers.isEmpty()) {
                throw new AuraHandledException('No suppliers found for the given account.');
            }
            
            // Fetch Site_Supplier_Link__c records matching site and suppliers
            Map<Id, Suppliers__c> supplierMap = new Map<Id, Suppliers__c>();
            for (Suppliers__c supplier : suppliers) {
                supplierMap.put(supplier.Id, supplier);
            }
            
            List<Site_Supplier_Link__c> siteSupplierLinks = [
                SELECT Id, Site__c, Suppliers__c, Suppliers__r.Supplier__c, Tier__c
                FROM Site_Supplier_Link__c
                WHERE Site__c = :siteId AND Suppliers__c IN :supplierMap.keySet()
            ];
            
            if (siteSupplierLinks.isEmpty()) {
                throw new AuraHandledException('No matching site-supplier links found.');
            }
            
            // Filter suppliers based on the tier condition
            List<Id> matchingSupplierIds = new List<Id>();
            for (Site_Supplier_Link__c link : siteSupplierLinks) {
                if (tier == 'All Tier') {
                    if (link.Tier__c != null) { // Include all non-null tiers
                        matchingSupplierIds.add(link.Suppliers__r.Supplier__c);
                    }
                } else {
                    if (link.Tier__c == tier) { // Match the exact tier
                        matchingSupplierIds.add(link.Suppliers__r.Supplier__c);
                    }
                }
            }
            
            if (matchingSupplierIds.isEmpty()) {
                throw new AuraHandledException('No suppliers match the given tier.');
            }
            
            system.debug('====================matchingSupplierIds : ' + matchingSupplierIds);
            
            // Fetch contacts of the matching suppliers
             Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            List<Contact> contacts = [
                SELECT Id, FirstName, Email
                FROM Contact 
                WHERE AccountId IN :matchingSupplierIds
                AND Email != null 
                AND Person_Status__c = 'Active'
                AND RecordTypeId =: contactRecordTypeId];
            
            if (contacts.isEmpty()) {
                throw new AuraHandledException('No active contacts with email found for matching suppliers.');
            }
            
            // Build job order details
            String jobOrderDetails = '';
            String jobacknowledgeLink = '';
            String baseURL = Label.SiteBaseUrl;
            Id jOrderId;
            for (sirenum__JobOrder__c jobOrder : jobOrders) {
               jOrderId = jobOrder.Id;
                jobOrderDetails += '<li><b>Job Order Number:</b> ' + jobOrder.Job_Order_Number__c + '</li>' +
                '<li><b>Job Role:</b> ' + jobOrder.sirenum__JobRole__r.Name + '</li>' +
                    '<li><b>Site Name:</b> ' + jobOrder.sirenum__Site__r.Name + '</li>' +
                    '<li><b>Start Date:</b> ' + String.valueOf(jobOrder.sirenum__StartDate__c) + '</li><br/>';
            }
            
            // Prepare emails
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Contact contact : contacts) {
                 jobacknowledgeLink = '<a href="' + baseURL + '/acknowledgement?contactId=' + contact.Id + '&jobOrderId=' + jOrderId + '">here</a>';
                     
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { contact.Email });
                email.setSubject('New Booking Assigned');
                email.setHtmlBody(
                    'Dear ' + contact.FirstName + ',<br/><br/>' +
                    'The following booking(s) have been assigned:<br/>' +
                    '<ul>' + jobOrderDetails + '</ul>' +
                    '<br/>To view details, please click <a href="https://blue-arrow--test.sandbox.my.site.com/cpv2">here</a> to access the portal.<br/><br/>' +
                    'Please click '  + jobacknowledgeLink +  ' to acknowledge receipt of this booking. ' +
                    'Best regards,<br/>Blue Arrow'
                );
                emails.add(email);
            }
            
            // Send emails
            Messaging.sendEmail(emails, false);
        } catch (Exception e) {
            throw new AuraHandledException('Error sending emails: ' + e.getMessage());
        }
    }
    
    
}
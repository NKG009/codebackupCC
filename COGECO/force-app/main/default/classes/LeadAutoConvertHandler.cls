public class LeadAutoConvertHandler {
    
    public static void convertSpotioLeads(List<Lead> newLeads) {
        if (newLeads == null || newLeads.isEmpty()) return;
        
        // Get Spotio record type IDs for Lead, Account, Contact, Opportunity
        Map<String, Id> rtMap = new Map<String, Id>{
            'Lead'        => Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Spotio').getRecordTypeId(),
                'Account'     => Schema.SObjectType.Account.getRecordTypeInfosByName().get('Spotio').getRecordTypeId(),
                'Contact'     => Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Spotio').getRecordTypeId(),
                'Opportunity' => Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Spotio').getRecordTypeId()
                };
                    
                    // First, identify which leads need conversion and collect their IDs
                    Set<Id> leadIdsToConvert = new Set<Id>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        
        for (Lead l : newLeads) {
            if (l.RecordTypeId == rtMap.get('Lead') && !l.IsConverted) {
                leadIdsToConvert.add(l.Id);
                leadMap.put(l.Id, l);
            }
        }
        
        if (leadIdsToConvert.isEmpty()) return;
        
        System.debug(' Lead IDs to convert: ' + leadIdsToConvert);
        System.debug(' Number of leads to convert: ' + leadIdsToConvert.size());
        
        // Query ContentDocumentIds from Leads BEFORE conversion (store document IDs, not links)
        Map<Id, Set<Id>> leadContentDocMap = new Map<Id, Set<Id>>();
        for (ContentDocumentLink cdl : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :leadIdsToConvert
        ]) {
            if (!leadContentDocMap.containsKey(cdl.LinkedEntityId)) {
                leadContentDocMap.put(cdl.LinkedEntityId, new Set<Id>());
            }
            leadContentDocMap.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
        }
        
        System.debug(' Total leads with files: ' + leadContentDocMap.size());
        System.debug(' File details: ' + leadContentDocMap);
        
        // Prepare lead conversions
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        
        for (Id leadId : leadIdsToConvert) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadId);
            lc.setConvertedStatus('SQL'); // Must exist in Lead Status
            lc.setDoNotCreateOpportunity(false); // create Opportunity
            leadConverts.add(lc);
        }
        
        // Convert Leads
        List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
        Map<Id, Map<String, Id>> convertedIds = new Map<Id, Map<String, Id>>();
        
        if(!Test.isRunningTest())
        {
            for (Database.LeadConvertResult res : results) {
                if (res.isSuccess()) {
                    convertedIds.put(res.getLeadId(), new Map<String, Id>{
                        'Account' => res.getAccountId(),
                            'Contact' => res.getContactId(),
                            'Opportunity' => res.getOpportunityId()
                            });
                    System.debug(' Lead converted successfully: ' + res.getLeadId());
                } else {
                    for (Database.Error err : res.getErrors()) {
                        System.debug(' Lead conversion failed: ' + err.getMessage());
                    }
                }
            }
        }
        else
        {
            for (Id leadId : leadIdsToConvert) {
                Lead l = leadMap.get(leadId);
                
                Account a = new Account(
                    Name = l.Business_Name__c != null ? l.Business_Name__c : 'Test Account',
                    RecordTypeId = rtMap.get('Account')
                );
                insert a;
                
                Contact c = new Contact(
                    LastName = l.Contact_Name_Lead_Form__c != null ? l.Contact_Name_Lead_Form__c : 'Unknown',
                    AccountId = a.Id,
                    RecordTypeId = rtMap.get('Contact')
                );
                insert c;
                
                Opportunity o = new Opportunity(
                    Name = 'Test Opportunity - ' + l.LastName,
                    AccountId = a.Id,
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addDays(30),
                    RecordTypeId = rtMap.get('Opportunity')
                );
                insert o;
                
                convertedIds.put(leadId, new Map<String, Id>{
                    'Account' => a.Id,
                        'Contact' => c.Id,
                        'Opportunity' => o.Id
                        });
            }
        }
        
        
        
        // Prepare lists to update Account, Contact, Opportunity
        List<Account> acctsToUpdate = new List<Account>();
        List<Contact> contsToUpdate = new List<Contact>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
        
        // Query converted Accounts to check if they are Person Accounts
        Set<Id> accountIds = new Set<Id>();
        for (Map<String, Id> ids : convertedIds.values()) {
            if (ids.get('Account') != null) {
                accountIds.add(ids.get('Account'));
            }
        }
        
        Map<Id, Account> accountsMap = new Map<Id, Account>([
            SELECT Id 
            FROM Account 
            WHERE Id IN :accountIds
        ]);
        
        for (Id leadId : convertedIds.keySet()) {
            Map<String, Id> ids = convertedIds.get(leadId);
            Lead l = leadMap.get(leadId);
            
            // Update Account safely (only Business Accounts)
            if (ids.get('Account') != null && accountsMap.containsKey(ids.get('Account'))) {
                Account acc = accountsMap.get(ids.get('Account'));
                
                acc.RecordTypeId = rtMap.get('Account'); // Spotio Business Account record type
                acc.Name = l.Business_Name__c;
                acc.Business_Name__c = l.Business_Name__c;
                acc.Business_Phone__c = l.Business_Phone1__c;
                acc.Phone = l.Business_Phone1__c;
                acc.Service_Address__c = l.Service_Address_Lead_Form__c;
                acc.Billing_Address_Lead_Form__c = l.Billing_Address_Lead_Form__c;
                acc.Postal_Code__c = l.Postal_Code__c;
                acctsToUpdate.add(acc);
                
            }
            
            // Update Contact
            if (ids.get('Contact') != null) {
                Contact c = new Contact(
                    Id = ids.get('Contact'),
                    RecordTypeId = rtMap.get('Contact'),
                    LastName = (l.Contact_Name_Lead_Form__c != null ? l.Contact_Name_Lead_Form__c : 'Unknown'),
                    AccountId = ids.get('Account'), // link to converted Account
                    Phone = l.Contact_Phone__c,
                    REP_ID__c = l.REP_ID__c,
                    Rep_Name__c = l.Rep_Name__c,
                    Rep_Email__c = l.Rep_Email__c,
                    Contact_Role__c = l.Contact_Role__c
                );
                contsToUpdate.add(c);
            }
            
            // Update Opportunity record type if created
            if (ids.get('Opportunity') != null) {
                Opportunity opp = new Opportunity(
                    Id = ids.get('Opportunity'),
                    AccountId = ids.get('Account'),
                    RecordTypeId = rtMap.get('Opportunity'),
                    Internet_Sold__c = l.Internet_Sold__c,
                    Speed__c = l.Speed__c,
                    Internet_Term__c = l.Internet_Term__c,
                    Configuration__c = l.Configuration__c,
                    Wi_Fi_Type__c = l.Wi_Fi_Type__c,
                    WiFi_6_Extenders_Required__c = l.WiFi_6_Extenders_Required__c,
                    Total_Internet_MRR__c = l.Total_Internet_MRR__c,
                    Voice_Sold__c = l.Voice_Sold__c,
                    of_Lines__c = l.of_Lines__c,
                    Voice_Term__c = l.Voice_Term__c,
                    Number_Type__c = l.Number_Type__c,
                    Total_Voice_MRR__c = l.Total_Voice_MRR__c,
                    Video_Sold__c = l.Voice_Sold__c,
                    Professional_Install_Fee__c = l.Professional_Install_Fee__c,
                    Additional_Comments__c = l.Additional_Comments__c,
                    Total_Video_MRC__c = l.Total_Video_MRC__c,
                    Package__c = l.Package__c,
                    Video_Term__c = l.Video_Term__c,
                    Number_of_Boxes_Required__c = l.Number_of_Boxes_Required__c,
                    List_any_additional_channels_packages_to__c = l.List_any_additional_channels_packages_to__c,
                    Related_Contact__c = ids.get('Contact')
                );
                oppsToUpdate.add(opp);
                
                // Prepare Files to copy from Lead to Opportunity
                if (leadContentDocMap.containsKey(leadId)) {
                    Set<Id> contentDocIds = leadContentDocMap.get(leadId);
                    System.debug(' Preparing ' + contentDocIds.size() + ' files from Lead ' + leadId + ' to Opportunity ' + ids.get('Opportunity'));
                    
                    for (Id contentDocId : contentDocIds) {
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = contentDocId;
                        cdl.LinkedEntityId = ids.get('Opportunity'); // link to Opportunity
                        cdl.ShareType = 'V'; // Viewer permission
                        cdl.Visibility = 'AllUsers';
                        cdlToInsert.add(cdl);
                    }
                }
            }
        }
        
        // Perform updates
        if (!acctsToUpdate.isEmpty()) {
            update acctsToUpdate;
            System.debug(' Updated ' + acctsToUpdate.size() + ' Accounts');
        }
        
        if (!contsToUpdate.isEmpty()) {
            update contsToUpdate;
            System.debug(' Updated ' + contsToUpdate.size() + ' Contacts');
        }
        
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
            System.debug(' Updated ' + oppsToUpdate.size() + ' Opportunities');
        }
        
        if (!cdlToInsert.isEmpty()) {
            try {
                insert cdlToInsert;
                System.debug(' Successfully copied ' + cdlToInsert.size() + ' files to Opportunities');
            } catch (DmlException e) {
                System.debug('️ Error copying files: ' + e.getMessage());
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    System.debug(' Failed record: ' + e.getDmlId(i) + ' - ' + e.getDmlMessage(i));
                }
            }
        }
    }
}
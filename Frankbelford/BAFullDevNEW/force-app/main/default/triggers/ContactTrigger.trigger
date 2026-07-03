trigger ContactTrigger on Contact (before insert,before update,after insert,after update, before delete, after delete) {
    
    Set<id> Personid = new Set<id>();
    Set<id> conset = new Set<id>();
    Set<id> Payprofileid  = new Set<id>();
    Set<id> payeid = new Set<id>();
    Set<id> consentupdates = new Set<id>();
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');
    //DefaultAccounts__c candidateAccId = DefaultAccounts__c.getValues('Candidates');
    System.debug('================ : '+Payroll.Batch_check__c);
    if(!Payroll.Batch_check__c) {
            System.debug('================ : after if');
        if(trigger.isBefore && (Trigger.isUpdate)  && Limits.getQueries() <90 ) { 
            Id RecordTypeIdexternal = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('2nd Tier Candidate').getRecordTypeId();
            //Id
            for (SObject so : Trigger.old) {
                Contact oldcon = (Contact)so;
                Contact newcon = Trigger.newMap.get(so.Id);
                if(newcon.recordtypeId == RecordTypeIdexternal &&
                        newcon.IP_TempestDepartment__c != '0000' &&
                            (   
                                (
                                    newcon.IP_LastPassedToTempest2ndTier__c == null && 
                                    newcon.IP_Pass2ndTierToTempest__c == True &&
                                    newcon.IP_FirstPassExternalWorker__c== True &&
                                    (
                                        newcon.IP_Pass2ndTierToTempest__c != oldcon.IP_Pass2ndTierToTempest__c || 
                                        newcon.IP_FirstPassExternalWorker__c != oldcon.IP_FirstPassExternalWorker__c
                                    )
                                ) || 
                                (
                                    newcon.IP_Pass2ndTierToTempest__c != oldcon.IP_Pass2ndTierToTempest__c && 
                                    newcon.IP_Pass2ndTierToTempest__c == True && 
                                    newcon.IP_FirstPassExternalWorker__c == False && 
                                    newcon.IP_LastPassedToTempest2ndTier__c!= null 
                                ) 
                            )
                        ) {
                    system.debug('Value being PAssed' +so);
                    PassExternalWorker.passexternal(Trigger.newMap.get(so.Id)); // CONTAINS DML STATEMENTS, THIS NEEDS TO BE OUT SIDE OF FOR LOOP
                }
                if(newcon.recordtypeId == RecordTypeIdexternal && 
                            newcon.IP_EmergencyPull__c == True && 
                            newcon.IP_EmergencyPull__c  != oldcon.IP_EmergencyPull__c ) {
                    PassExternalWorker.passExternalEmergency(Trigger.newMap.get(so.Id)); // CONTAINS DML STATEMENTS, THIS NEEDS TO BE OUT SIDE OF FOR LOOP
                }
            }
        }
    
        if(trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert) && Limits.getQueries() <90 ) { 
            Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
            system.debug('c.RecordType.name-->'+devRecordTypeId);
            
            for(Contact c : Trigger.new){
                if(Trigger.isInsert) {
                    if(c.MailingStreet != null) {
                            TriggerFactory.createHandler(Contact.sObjectType);
                    }
                }
                if(Trigger.isUpdate) {
                    Contact cold = Trigger.OldMap.get(c.id);
                    if(cold.MailingStreet != c.MailingStreet) {
                        TriggerFactory.createHandler(Contact.sObjectType);
                    }
                }
            }  
            if(Trigger.isUpdate) {
                List<sirenum__site__c> accupdatecheck = [Select id,IP_MainContact__c,IP_ClientLastPassedToTempest__c,IP_ClientAddressLastPassedToTempest__c 
                                                            from sirenum__site__c 
                                                            where (IP_MainContact__c =: Trigger.new)];
                for(sirenum__site__c s :accupdatecheck) {                
                    conset.add(s.IP_MainContact__c);
                }
                for(integer i=0;i<trigger.new.size();i++) {
                    if((trigger.new[i].AccountID != trigger.old[i].AccountID) && conset.contains(trigger.new[i].id)) {
                        trigger.new[i].adderror('You cannot change the account linked to this contact, as they are a Main Contact for a site. Please update the site/s with a new Contact first.');
                    }
                }
            }
        }

        //Trigger for  External Worker - subsequent pass logic 
        if(trigger.isAfter && trigger.isUpdate  && Limits.getQueries() <90) {
            Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('2nd Tier Candidate').getRecordTypeId();
            Id RecordTypeIdContact1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            for(integer i=0;i<trigger.new.size();i++){
                system.debug('Inside IF ');
                system.debug('@A@ '+trigger.new[i].recordtypeid + trigger.new[i].Salutation + trigger.old[i].Salutation);
                if(trigger.new[i].recordtypeid == RecordTypeIdContact && 
                        (   trigger.new[i].IP_2nd_Tier_Supplier__c != trigger.old[i].IP_2nd_Tier_Supplier__c  || 
                            trigger.new[i].Birthdate != trigger.old[i].Birthdate || 
                            trigger.new[i].Salutation != trigger.old[i].Salutation || 
                            trigger.new[i].FirstName != trigger.old[i].FirstName ||
                            trigger.new[i].LastName  != trigger.old[i].LastName ||
                            trigger.new[i].IP_MailingAddressLine1__c  != trigger.old[i].IP_MailingAddressLine1__c ||
                            trigger.new[i].IP_MailingAddressLine2__c  != trigger.old[i].IP_MailingAddressLine2__c ||
                            trigger.new[i].IP_MailingAddressLine3__c != trigger.old[i].IP_MailingAddressLine3__c || 
                            trigger.new[i].MailingCity   != trigger.old[i].MailingCity || 
                            trigger.new[i].MailingState!= trigger.old[i].MailingState || 
                            trigger.new[i].MailingPostalCode!= trigger.old[i].MailingPostalCode || 
                            trigger.new[i].IP_TempestDepartment__c    != trigger.old[i].IP_TempestDepartment__c  || 
                            trigger.new[i].IP_TempestDivision__c    != trigger.old[i].IP_TempestDivision__c ||
                            trigger.new[i].IP_CandidateIDlegacy__c != trigger.old[i].IP_CandidateIDlegacy__c || 
                            trigger.new[i].IP_WorkerStartDate__c != trigger.old[i].IP_WorkerStartDate__c)
                        ){
                    system.debug('Inside IF IF');
                    Personid.add(trigger.new[i].id);                
                }
            }
            if(!Personid.isEmpty()){
                PersonProcessBuilder.updatePass2ndtiertoTempest(Personid);
            }
        } 

        //Trigger for Internal Worker subsequent pass logic v2 support 
        if(trigger.isAfter && trigger.isUpdate  && Limits.getQueries() <90  ){
            for(integer i=0;i<trigger.new.size();i++){            
                for(Contact c:trigger.new){
                    system.debug('##$$$ '+trigger.new[i].MailingCity +'  ** '+trigger.old[i].MailingCity);
                    if (trigger.new[i].Salutation !=trigger.old[i].Salutation ||
                        trigger.new[i].FirstName!=trigger.old[i].FirstName || 
                        trigger.new[i].LastName !=trigger.old[i].LastName ||
                        trigger.new[i].Birthdate !=trigger.old[i].Birthdate || 
                        trigger.new[i].IP_ConsultantsTempestID__c!=trigger.old[i].IP_ConsultantsTempestID__c ||
                        trigger.new[i].IP_MailingAddressLine1__c !=trigger.old[i].IP_MailingAddressLine1__c || 
                        trigger.new[i].IP_MailingAddressLine2__c !=trigger.old[i].IP_MailingAddressLine2__c || 
                        trigger.new[i].MailingCity!=trigger.old[i].MailingCity ||
                        trigger.new[i].MailingPostalCode!=trigger.old[i].MailingPostalCode ||
                        trigger.new[i].Phone!=trigger.old[i].Phone || 
                        trigger.new[i].EEO_Gender__c!=trigger.old[i].EEO_Gender__c || 
                        trigger.new[i].IP_WorkerStartDate__c!=trigger.old[i].IP_WorkerStartDate__c ||
                        trigger.new[i].IP_NewStartTaxStatus__c !=trigger.old[i].IP_NewStartTaxStatus__c  ||
                        trigger.new[i].IP_TempestDepartment__c !=trigger.old[i].IP_TempestDepartment__c ||
                        trigger.new[i].IP_TempestDivision__c  !=trigger.old[i].IP_TempestDivision__c ||  
                        trigger.new[i].sirenum__National_Insurance__c !=trigger.old[i].sirenum__National_Insurance__c ||
                        trigger.new[i].Email !=trigger.old[i].Email || 
                        trigger.new[i].IP_MailingAddressLine3__c !=trigger.old[i].IP_MailingAddressLine3__c  || 
                        trigger.new[i].MailingCountry !=trigger.old[i].MailingCountry || 
                        trigger.new[i].MailingState  !=trigger.old[i].MailingState ||
                        trigger.new[i].WTR_Completed__c !=trigger.old[i].WTR_Completed__c || 
                        trigger.new[i].Student__c !=trigger.old[i].Student__c ||
                        trigger.new[i].Preferred_Name__c !=trigger.old[i].Preferred_Name__c )
                    {                    
                        Payprofileid.add(c.id);  
                        system.debug('swati check123---' + Payprofileid);
                        
                    } 
                } 
            } 
            if(!Payprofileid.isEmpty()) {                        
                PersonProcessBuilder.UpdatepayProfile(Payprofileid);
            }
        }

        if(trigger.isAfter && trigger.isUpdate  && Limits.getQueries()< Limits.getLimitQueries()){
            for(integer i=0;i<trigger.new.size();i++){            
                for(Contact c:trigger.new){
                    if(trigger.new[i].P45_Suppression_Reason__c!=trigger.old[i].P45_Suppression_Reason__c) {
                        payeid.add(c.id);
                        System.debug('check suppression update');
                    }
                    if(trigger.new[i].IP_Consent_from_Data_Store__c != trigger.old[i].IP_Consent_from_Data_Store__c && trigger.new[i].IP_Consent_entered_by__c == 'Email Template') {
                        consentupdates.add(c.id);
                    }
                }
            }
            if(!payeid.isEmpty()) {                        
                PersonProcessBuilder.UpdatepayepayProfile(payeid);
            }
            if(!consentupdates.isEmpty()) {
                UpdateDataStore.sendconsentdata(consentupdates);
            }
        }

        if(trigger.isBefore && trigger.isDelete && Limits.getQueries() <90 ) {
            List<sirenum__site__c> sitelist = [Select Id,IP_MainContact__c from sirenum__site__c where ( IP_MainContact__c in : trigger.old)];
            if(sitelist.size()>0) {
                trigger.old[0].adderror('You cannot delete this Contact as they are a Main Contact on a site/s. Please update the site/s with a new Main Contact first.');
            }
            
        }

        /*
         * AS PER VMS LITE INTEGRATION - 2ND TIER CANDIDATE PORTAL USER WILL BE CREATED IF COMPLIANCE IS COMPLETED
         */
        if(trigger.isAfter &&
                (trigger.isInsert || trigger.isUpdate)){
            System.debug('Preparing for User creation');
            List<Contact> oldContacts = new List<Contact>(trigger.old);
            //TRUNING OFF THE CALL
            ContactTriggerHandler.createCandidatePortalUser(trigger.new, oldContacts);
        } else {
            System.debug('Not preparing for user creation task cuse trigger.isAfter=' + trigger.isAfter + ' and (trigger.isInsert || trigger.isUpdate)='+(trigger.isInsert || trigger.isUpdate));
        }
        
        //jyothi.start
        if(trigger.isUpdate && trigger.isBefore){
            ContactTriggerHandler.onGeneralComplianceStatusChange(trigger.new, trigger.oldMap);
        }
        //jyothi.stop
    }
}
public with sharing class PayProfileTriggerHandler implements ITrigger {
    
    public PayProfileTriggerHandler()
    {
        //This is the constructor
    }     
    public void bulkBefore()
    {
        //It is Bulk Before functionality
    }    
    public void bulkAfter()
    { 
        //It is Bulk After functionality
    }
    
    public void beforeInsert(SObject so)
    {  
        //It is for Before Insert functionality 
        IP_PayProfile__c payProfiles = (IP_PayProfile__c) so;
        Id devRecordTypeId2 = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();
        if(payProfiles.RecordTypeId == devRecordTypeId2  && Limits.getQueries() <90 )
        {
            list <IP_Umbrellalist__c> umblist = [SELECT IP_AddressLine1__c,Id,IP_AddressLine2__c,IP_AddressLine3__c,IP_BankAccountName__c,IP_BankAccountNumber__c,IP_BankSortCode__c,IP_BuildingSocietyNo__c,IP_CompanyRegNo__c,IP_OkToSupply__c,IP_PaymentType__c,IP_Postcode__c,IP_SupplierReference__c,VAT_Number__c,IP_VATRegistered__c,Name FROM IP_Umbrellalist__c where id =:payProfiles.IP_UmbrellaName__c LIMIT 1];
            MAP<ID ,IP_Umbrellalist__c> mapUmb = new MAP<ID ,IP_Umbrellalist__c>();
            if(umblist!= null && !umblist.isEmpty())
            {
                mapUmb.put(umblist[0].id,umblist[0]); 
            }
            
            
            if(mapUmb.containskey(payProfiles.IP_UmbrellaName__c))
            {
                IP_Umbrellalist__c ul = mapUmb.get(payProfiles.IP_UmbrellaName__c);
                payProfiles.IP_BusinessAddressLine1__c = ul.IP_AddressLine1__c;
                payProfiles.IP_BusinessAddressLine2__c = ul.IP_AddressLine2__c;
                payProfiles.IP_BusinessAddressCounty__c = ul.IP_AddressLine3__c;
                payProfiles.IP_BankAccountName__c= ul.IP_BankAccountName__c;
                payProfiles.IP_AccountNumber__c = ul.IP_BankAccountNumber__c;
                payProfiles.IP_SortCode__c = ul.IP_BankSortCode__c;
                payProfiles.IP_BuildingSocietyNumber__c = ul.IP_BuildingSocietyNo__c;
                payProfiles.IP_CompanyRegNo__c = ul.IP_CompanyRegNo__c;
                payProfiles.IP_OkToSupply__c = ul.IP_OkToSupply__c;
                if(ul.IP_PaymentType__c == 'B')
                {
                    payProfiles.IP_PaymentType__c = 'BACS';
                }
                if(ul.IP_PaymentType__c == 'C')
                {                       
                    payProfiles.IP_PaymentType__c = 'Cheque';
                }
                payProfiles.IP_BusinessAddressPostcode__c= ul.IP_Postcode__c;
                payProfiles.IP_SupplierReference__c = ul.IP_SupplierReference__c;
                payProfiles.IP_VATNumber__c = ul.VAT_Number__c;
                if(ul.IP_VATRegistered__c == 0)
                    payProfiles.IP_VATRegistered__c = FALSE;
                
                else
                    payProfiles.IP_VATRegistered__c = TRUE;
                payProfiles.IP_CompanyName__c = ul.Name;
                
            }   
        }
    }
    
    public void afterInsert(SObject so)
    {
        //It is for After Insert functionality 
        IP_PayProfile__c payProfiles = (IP_PayProfile__c) so;
        PayProfileOkToSupply.method1(payProfiles);
        
        
        IP_JSToFrostSwtich__c FrostIntegration = IP_JSToFrostSwtich__c.getValues('JSToFrost');
        
        if(Trigger.isAfter && Trigger.isInsert && FrostIntegration.IP_RunJSToFrost__c  && Limits.getQueries() <90 ){
            
            List<IP_PayProfile__c> payProfileList = [select id,name,RecordType.Name,IP_PayrollID__c,IP_Candidate__c,IP_CompanyName__c,IP_CompanyRegNo__c,IP_VATRegistered__c,IP_VATNumber__c,IP_OkToSupply__c,
                                                     IP_Candidate__r.LastName,IP_Candidate__r.FirstName,IP_Candidate__r.MailingStreet,IP_Candidate__r.MailingCity,IP_Candidate__r.MailingCountry,
                                                     IP_Candidate__r.MailingPostalCode,IP_Candidate__r.Birthdate,IP_Candidate__r.Title,IP_Candidate__r.Phone_Type__c,IP_Candidate__r.Initials__c,
                                                     IP_Candidate__r.sirenum__National_Insurance__c,IP_Candidate__r.ts2__EEO_Gender__c,IP_Candidate__r.Phone,IP_Candidate__r.IP_CandidateIDlegacy__c,
                                                     IP_Candidate__r.IP_CategoryOfWork__c
                                                     from IP_PayProfile__c 
                                                     where id=:payProfiles.Id 
                                                     and RecordType.DeveloperName ='PAYE' 
                                                     and IP_PayrollID__c=null
                                                     and IP_Candidate__r.RecordType.DeveloperName ='Candidate' 
                                                     limit 1];
            if(!payProfileList.isEmpty()){
                
                IP_PayProfile__c payProfile = payProfileList[0];
                system.debug('payProfileList --->'+payProfileList );
                if(payProfile.IP_Candidate__r.LastName!=null && payProfile.IP_Candidate__r.FirstName!=null && payProfile.IP_Candidate__r.Birthdate!=null && payProfile.IP_Candidate__r.sirenum__National_Insurance__c!=null  && 
                   payProfile.IP_PayrollID__c ==null && Util.stopFrostRunAgain && payProfile.RecordType.Name =='PAYE'){
                       Util.stopFrostRunAgain = false;
                       RetreiveFrostRecord.restCalloutforPayProfile(payProfile.id);
                   }
            }
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {        
        //It is for Before Update functionality 
        if(Trigger.isBefore && Trigger.isUpdate  && Limits.getQueries() <90 ){
            System.debug('IN BEFORE UPDATE');
            IP_PayProfile__c payProfiles = (IP_PayProfile__c) so;
            IP_PayProfile__c oldpayProfiles = (IP_PayProfile__c) oldSo;
            Set<id> Payprofileid  = new Set<id>();
            Id devRecordTypeIdcheck = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
            
            if(oldpayProfiles.IP_GUID__c ==  payProfiles.IP_GUID__c && oldpayProfiles.IP_LastPassedToTempest__c ==  payProfiles.IP_LastPassedToTempest__c)
            {
                System.debug('IN BEFORE UPDATE not run');
                if(Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosById().get(payProfiles.RecordTypeID).getname() !='Umbrella'){
                    payProfiles.IP_UmbrellaName__c = null;
                    if( payProfiles.P45_Requested__c == true && (payProfiles.Reason_for_Leaving1__c !=oldpayProfiles.Reason_for_Leaving1__c && payProfiles.Reason_for_Leaving1__c !='Automatic') && payProfiles.RecordTypeId  ==devRecordTypeIdcheck )
                    {
                        System.debug('IN BEFORE UPDATE not run in IF');
                        if(payProfiles.IP_LastPassedToTempest__c!=null && payProfiles.IP_Status__c=='Active')
                        {
                            system.debug('**debug before update**');
                            payProfiles.IP_PassToTempest__c = true;
                        }
                    }
                    
                    
                }
                else
                {
                if(payProfiles.IP_UmbrellaName__c != oldpayProfiles.IP_UmbrellaName__c ){
                    list <IP_Umbrellalist__c> umblist = [SELECT IP_AddressLine1__c,Id,IP_AddressLine2__c,IP_AddressLine3__c,IP_BankAccountName__c,IP_BankAccountNumber__c,IP_BankSortCode__c,IP_BuildingSocietyNo__c,IP_CompanyRegNo__c,IP_OkToSupply__c,IP_PaymentType__c,IP_Postcode__c,IP_SupplierReference__c,VAT_Number__c,IP_VATRegistered__c,Name FROM IP_Umbrellalist__c where id =:payProfiles.IP_UmbrellaName__c LIMIT 1];
                    MAP<ID ,IP_Umbrellalist__c> mapUmb = new MAP<ID ,IP_Umbrellalist__c>();
                    if(umblist!= null && !umblist.isEmpty())
                    {
                        mapUmb.put(umblist[0].id,umblist[0]);    
                    }
                    
                    if(mapUmb.containskey(payProfiles.IP_UmbrellaName__c))
                    {
                        IP_Umbrellalist__c ul = mapUmb.get(payProfiles.IP_UmbrellaName__c);
                        payProfiles.IP_BusinessAddressLine1__c = ul.IP_AddressLine1__c;
                        payProfiles.IP_BusinessAddressLine2__c = ul.IP_AddressLine2__c;
                        payProfiles.IP_BusinessAddressCounty__c = ul.IP_AddressLine3__c;
                        payProfiles.IP_BankAccountName__c= ul.IP_BankAccountName__c;
                        payProfiles.IP_AccountNumber__c = ul.IP_BankAccountNumber__c;
                        payProfiles.IP_SortCode__c = ul.IP_BankSortCode__c;
                        payProfiles.IP_BuildingSocietyNumber__c = ul.IP_BuildingSocietyNo__c;
                        payProfiles.IP_CompanyRegNo__c = ul.IP_CompanyRegNo__c;
                        payProfiles.IP_OkToSupply__c = ul.IP_OkToSupply__c;
                      /*  if(ul.IP_PaymentType__c == 'B')
                        {
                            payProfiles.IP_PaymentType__c = 'BACS';
                        }
                        if(ul.IP_PaymentType__c == 'C')
                        {                       
                            payProfiles.IP_PaymentType__c = 'Cheque';
                        }*/
                        payProfiles.IP_BusinessAddressPostcode__c= ul.IP_Postcode__c;
                        payProfiles.IP_SupplierReference__c = ul.IP_SupplierReference__c;
                        payProfiles.IP_VATNumber__c = ul.VAT_Number__c;
                        if(ul.IP_VATRegistered__c == 0)
                            payProfiles.IP_VATRegistered__c = FALSE;
                        
                        else
                            payProfiles.IP_VATRegistered__c = TRUE;
                        payProfiles.IP_CompanyName__c = ul.Name;
                        
                    }    
                   } 
                }
            }
            if(( (payProfiles.IP_PassToTempest__c != oldpayProfiles.IP_PassToTempest__c || payProfiles.IP_FirstPass__c != oldpayProfiles.IP_FirstPass__c) && payProfiles.IP_EmergencyPull__c== False && payProfiles.IP_FirstPass__c ==True && payProfiles.IP_LastPassedToTempest__c == Null && payProfiles.IP_PassToTempest__c == True) || ( payProfiles.IP_LastPassedToTempest__c != Null && payProfiles.IP_PassToTempest__c == True && payProfiles.IP_PassToTempest__c != oldpayProfiles.IP_PassToTempest__c))
        {
        system.debug('In Internal Worker###');
        String branchcode = payProfiles.IP_Candidate_Branch__c;
         system.debug('In department '+payProfiles.IP_Candidate_Branch__c);
        if(branchcode != '0000')
            PassInternalWorker.passpayroll(so, branchcode);
        }
        if(payProfiles.IP_EmergencyPull__c != oldpayProfiles.IP_EmergencyPull__c && payProfiles.IP_EmergencyPull__c == True ){
         String branchcode = payProfiles.IP_Candidate_Branch__c;
         if(branchcode != '0000')
         PassInternalWorker.passEmergency(so, branchcode);
        
        }
        }
    }
    
    public void beforeDelete(SObject so)
    {
        //It is for Before Delete functionality 
    }
    
    
    public void afterUpdate(SObject oldSo, SObject so)
    { 
        System.debug('IN AFTER UPDATE');
        //It is for After Update functionality
        IP_PayProfile__c payProfiles = (IP_PayProfile__c) so;
        IP_PayProfile__c oldpayProfiles = (IP_PayProfile__c) oldSo;
        if(oldpayProfiles.IP_GUID__c ==  payProfiles.IP_GUID__c && oldpayProfiles.IP_LastPassedToTempest__c ==  payProfiles.IP_LastPassedToTempest__c  && Limits.getQueries() <90 )
        {
            System.debug('IN AFTER UPDATE not run');
            PayProfileOkToSupply.method1(payProfiles);
            IP_JSToFrostSwtich__c FrostIntegration = IP_JSToFrostSwtich__c.getValues('JSToFrost');
            if(Trigger.isAfter && Trigger.isUpdate && FrostIntegration.IP_RunJSToFrost__c){
                
                List<IP_PayProfile__c> payProfileList = [select id,name,RecordType.Name,IP_PayrollID__c,IP_Candidate__c,IP_CompanyName__c,IP_CompanyRegNo__c,IP_VATRegistered__c,IP_VATNumber__c,IP_OkToSupply__c,
                                                         IP_Candidate__r.LastName,IP_Candidate__r.FirstName,IP_Candidate__r.MailingStreet,IP_Candidate__r.MailingCity,IP_Candidate__r.MailingCountry,
                                                         IP_Candidate__r.MailingPostalCode,IP_Candidate__r.Birthdate,IP_Candidate__r.Title,IP_Candidate__r.Phone_Type__c,IP_Candidate__r.Initials__c,
                                                         IP_Candidate__r.sirenum__National_Insurance__c,IP_Candidate__r.ts2__EEO_Gender__c,IP_Candidate__r.Phone,IP_Candidate__r.IP_CandidateIDlegacy__c,
                                                         IP_Candidate__r.IP_CategoryOfWork__c
                                                         from IP_PayProfile__c 
                                                         where id=:payProfiles.Id 
                                                         and RecordType.DeveloperName ='PAYE' 
                                                         and IP_PayrollID__c=null
                                                         and IP_Candidate__r.RecordType.DeveloperName ='Candidate' 
                                                         limit 1];
                if(!payProfileList.isEmpty()){
                    
                    IP_PayProfile__c payProfile = payProfileList[0];
                    system.debug('payProfileList --->'+payProfileList );
                    if(payProfile.IP_Candidate__r.LastName!=null && payProfile.IP_Candidate__r.FirstName!=null && payProfile.IP_Candidate__r.Birthdate!=null && payProfile.IP_Candidate__r.sirenum__National_Insurance__c!=null && 
                       payProfile.IP_PayrollID__c ==null && Util.stopFrostRunAgain && payProfile.RecordType.Name =='PAYE' ){
                           Util.stopFrostRunAgain = false;
                           RetreiveFrostRecord.restCalloutforPayProfile(payProfile.id);
                       }
                }
            }
        }
        updatePayProfile(payProfiles, oldpayProfiles);//1147
     
    }   
    
    public void afterDelete(SObject so)
    { //It is for After Delete functionality
    }
    
    public void andFinally()
    {
        //It is for Finally functionality 
    }    
    //jyothi.start
    public static void updatePayProfile(IP_PayProfile__c newPayProfile, IP_PayProfile__c oldPayProfile){
        Id payERT= Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        Set<Id> setCandidates = new Set<Id>();
        
        //newPayProfile.RecordTypeId == payERT
        if(newPayProfile.P45_Requested__c && newPayProfile.P45_Requested__c != oldPayProfile.P45_Requested__c){
            setCandidates.add(newPayProfile.IP_Candidate__c);                
        }
        
        if(!setCandidates.isEmpty()){
            List<Contact> persons = [SELECT Id,Person_Status__c from Contact Where Id IN: setCandidates and Person_Status__c = 'active'];
            for(Contact con: persons ){
                con.Person_Status__c = 'Inactive';
            }
            update persons;            
        }
    }
    //jyothi.stop
    
}
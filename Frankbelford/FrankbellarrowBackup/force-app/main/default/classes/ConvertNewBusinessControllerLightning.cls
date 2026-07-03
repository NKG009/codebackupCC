/**********************************************************************************************
* @Author:         Espire
* @Date:           10/10/2019
* @Description:    This class is get New Business Lead Information. 
* @Requirement Id:  JPC-2028
**********************************************************************************************/
public class ConvertNewBusinessControllerLightning {
    
    private static Final string PROSPECT = 'Prospect';
    
    /*
    * Method Name: getNewBusinessDetails
    * Description: To get New Business Lead Details
    * Parameters : String newBusinessLeadId
    * Return Type: jsinq__Inquiry__c
    * Date : 10/10/2019
    */
    @AuraEnabled
    public Static jsinq__Inquiry__c getNewBusinessDetails(String newBusinessLeadId){
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
        return inquiry;                     
    }
    
    /*
    * Method Name: getInquiryInfo
    * Description: To get New Business Lead Details
    * Parameters : String newBusinessLeadId
    * Return Type: jsinq__Inquiry__c
    * Date : 10/10/2019
    */
    private static jsinq__Inquiry__c getInquiryInfo(String newBusinessLeadId){
        jsinq__Inquiry__c inquiry = [Select id,Name,National_Competitor__c,Local_Competitor__c,Estimated_Perm_Vacancies__c,
            Estimated_Temp_Requirements__c,Company_Registration_No__c,Business_Type__c,jsinq__Website__c,
            jsinq__Email__c,jsinq__Phone_Number__c,jsinq__Contact__c,jsinq__Contact_Last_Name__c,
            jsinq__Contact_First_Name__c,jsinq__Street__c,jsinq__State__c,jsinq__Country__c,jsinq__City__c,
            jsinq__Zip_Postal_Code__c,Ownerid,jsinq__Title__c,jsinq__Job_Title__c,jsinq__Description__c,
            jsinq__Converted__c from jsinq__Inquiry__c where id=:newBusinessLeadId limit 1];
        return inquiry;
    }
    
    /*
    * Method Name: getInquiryInfo
    * Description: To get New Business Lead Details
    * Parameters : String newBusinessLeadId
    * Return Type: Map<String, String>
    * Date : 10/10/2019
    */
    @AuraEnabled
    public static Map<String, String> getAccountOptionValues(String newBusinessLeadId){
        //List<SelectOption> accOptions = new List<SelectOption>();
        Map<String, String> accOptions = new Map<String, String>();
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
        accOptions.put('--None--','--None--');
        accOptions.put('Create New Account:','Create New Account: '+inquiry.Name);
        transient List<Account> listAccRegNoMatch = new List<Account>();
        transient List<Account> listAccPhnNoMatch = new List<Account>();
        transient List<Account> listAccNameExactMatch = new List<Account>();
        transient List<Account> listAccNamePartialFirstMatch = new List<Account>();
        transient List<Account> listAccNamePartialSecMatch = new List<Account>();
        transient List<Account> listAccNamePartialThirdMatch = new List<Account>();
        transient List<Account> listAccNamePartialMatch = new List<Account>();
        transient List<Account> listAccLoop = new List<Account>();
        List<Account> listAccRecordFinal = new List<Account>();
            
        //Dynamic
        String inQName = inquiry.Name;
        String inQRegNo = inquiry.Company_Registration_No__c;
        String inQPhnNo = inquiry.jsinq__Phone_Number__c;
        string recTypeName ='Account';
        String[] searchName = inQName.split(' ');
        //
        String st = '';
        String st1 = '';
        String st2 = '';
        system.debug('>>>>searchName[0]>>>>'+searchName[0]);
        if(!searchName[0].equalsIgnoreCase(st)){
            st = inQName.substringBeforeLast(' ');
        }        
        if(!searchName[0].equalsIgnoreCase(st)){
            st1 = st.substringBeforeLast(' ');
        }
        if(!searchName[0].equalsIgnoreCase(st1)){
            st2 = st1.substringBeforeLast(' ');
        }
        system.debug('>>>>st>>>>'+st);
        system.debug('>>>>st1>>>>'+st1);
        system.debug('>>>>st2>>>>'+st2);
        //
        String soql = 'select Name,id,ts2__Status__c,OwnerId,Owner.Name,LastmodifiedDate,'+
                    'IP_CompanyRegistrationNo__c,Phone from account where '+
                     'RecordType.DeveloperName =\'' + recTypeName + '\' AND' +
                    '((IP_CompanyRegistrationNo__c != null AND IP_CompanyRegistrationNo__c = \'' +inQRegNo + '\')'+
                    ' OR (Phone = \'' + inQPhnNo + '\' AND Phone!= null) OR Name =\'' + String.escapeSingleQuotes(inQName) + '\' OR';
                    
        String filter ='';
        Map<String,String> mapBusinessName = new Map<String,String>();
        For(Integer i=0 ; i< searchName.size();i++){            
            mapBusinessName.put(searchName[i].toLowerCase(),searchName[i]);
            filter = filter+' Name like \'%' + String.escapeSingleQuotes(searchName[i]) + '%\' OR';
        }
        if(String.isNotBlank(filter) ){
            filter = filter.removeEnd('OR') +')';
            filter = filter +'Order By IP_CompanyRegistrationNo__c asc NULLS LAST,Phone asc NULLS LAST,Name asc';
            soql = soql + filter ;
        }
        soql = soql + ' limit 1000';
        //End Dynamic
        Set<Id> setAccid = new Set<Id>();
        system.debug('soql>>>>>>>>'+soql);
        Map<String,Account> mapAccounts = new Map<String,Account>();
        
        for(Account acc : database.query(soql)){
            String[] accName = acc.Name.split(' ');
            if(inQName.contains(acc.name) || (acc.IP_CompanyRegistrationNo__c == inQRegNo && inQRegNo!=null)
                || (inQPhnNo == acc.phone && inQPhnNo!=null)){
                    mapAccounts.put(acc.id,acc);
            }
            else {
                for(Integer i=0 ; i < accName.size();i++){              
                    if(mapBusinessName.containskey(accName[i].toLowerCase()) ){
                        mapAccounts.put(acc.id,acc);
                    }
                }
            }
        }
        
        for(Account acc : mapAccounts.values()){
            if(acc.IP_CompanyRegistrationNo__c == inquiry.Company_Registration_No__c && string.IsnotBlank(inquiry.Company_Registration_No__c) ){
                listAccRegNoMatch.add(acc);
            }
            else if(acc.Phone == inquiry.jsinq__Phone_Number__c && inquiry.jsinq__Phone_Number__c != null){
                listAccPhnNoMatch.add(acc);
            }
            else if(acc.Name.equalsIgnoreCase(inquiry.Name) || acc.Name.toLowerCase().contains(inquiry.Name.toLowerCase())){
                listAccNameExactMatch.add(acc);
            }
            else if(acc.Name.toLowerCase().contains(st.toLowerCase())){
                listAccNamePartialFirstMatch.add(acc);
            }
            else if(acc.Name.toLowerCase().contains(st1.toLowerCase())){
                listAccNamePartialSecMatch.add(acc);
            }
            else if(acc.Name.toLowerCase().contains(st2.toLowerCase())){
                listAccNamePartialThirdMatch.add(acc);
            }
            else if(acc.Name != inquiry.Name){
                listAccNamePartialMatch.add(acc);
            }
        }
        
        System.debug('>>>>listAccNamePartialFirstMatch>>>>'+listAccNamePartialFirstMatch);
        System.debug('>>>>listAccNamePartialSecMatcht>>>>'+listAccNamePartialSecMatch);
        System.debug('>>>>listAccNamePartialThirdMatch>>>>'+listAccNamePartialThirdMatch);
        if(!listAccRegNoMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccRegNoMatch);
        }
        if(!listAccPhnNoMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccPhnNoMatch);
        }
        if(!listAccNameExactMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNameExactMatch);
        }
        if(!listAccNamePartialFirstMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialFirstMatch);
        }
        if(!listAccNamePartialSecMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialSecMatch);
        }
        if(!listAccNamePartialThirdMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialThirdMatch);
        }
        if(!listAccNamePartialMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialMatch);
        }
        
        List<Account> listAccRecordFinalDisplay = new List<Account>();
        
        if(!listAccRecordFinal.isEmpty() && listAccRecordFinal.size()>20){
            for(integer i=0;i<20;i++){
                listAccRecordFinalDisplay.add(listAccRecordFinal[i]);
            }
            for(Account acc : listAccRecordFinalDisplay){
                accOptions.put(acc.id,acc.Name);
            }
        }
        else{
            for(Account acc : listAccRecordFinal){
                accOptions.put(acc.id,acc.Name);
            }
        }
        
        listAccRegNoMatch = null;
        listAccPhnNoMatch = null;
        listAccNameExactMatch = null;
        listAccNamePartialFirstMatch = null;
        listAccNamePartialSecMatch = null;
        listAccNamePartialThirdMatch = null;
        listAccNamePartialMatch = null;
        listAccLoop = null;
        
        return accOptions;
    }
    
    /*
    * Method Name: addAccountIdFromLookup
    * Description: To get Account id from Look Up
    * Parameters : String newBusinessLeadId
    * Return Type: Map<String, String>
    * Date : 10/10/2019
    */
    @AuraEnabled
    public static Map<String, String> addAccountIdFromLookup(String newBusinessLeadId,String jsonString){
        Map<String, String> accOptions = new Map<String, String>();
        Map<String, String> lstAccountOptions = getAccountOptionValues(newBusinessLeadId);
        
        system.debug('+++++++++jsonString+++++++++'+jsonString);
        //Map<String, Object> values = (Map<String, Object>)System.JSON.deserializeUntyped(jsonString);
        //system.debug('+++++++++values+++++++++'+values);
        Account acc = (Account) JSON.deserialize(jsonString, Account.class);
        system.debug('+++++++++acc+++++++++'+acc);
        if(acc!=null){
            accOptions.put(acc.id,acc.Name);
        }
        accOptions.putall(lstAccountOptions);
        //accOptions = new List<SelectOption>();
        
        /*Account acc = new Account();
        if(string.IsNotBlank(accountIdValue) || selectedAccountId!=null){
            accounthiddenValue = accountIdValue;
            selectedAccountId = accountIdValue;
            acc = [Select id,Name from Account where id=:accountIdValue limit 1];
            accOptions = new List<SelectOption>();
            accOptions.addall(lstAccountOptions);
            accOptions.add( new SelectOption(acc.id,acc.Name) );
        }*/
        return accOptions;
    }
    
    
    /*
    * Method Name: ConvertToNewAccount
    * Description: To insert Account , Site and Contact
    * Parameters : String newBusinessLeadId
    * Return Type: String
    * Date : 16/10/2019
    */
    @AuraEnabled
    public Static List<wrapAccount> getMatchingAccountList(String newBusinessLeadId){
        List<wrapAccount> wrapAccountList = new List<wrapAccount>();
        
        transient List<Account> listAccRegNoMatch = new List<Account>();
        transient List<Account> listAccPhnNoMatch = new List<Account>();
        transient List<Account> listAccNameExactMatch = new List<Account>();
        transient List<Account> listAccNamePartialFirstMatch = new List<Account>();
        transient List<Account> listAccNamePartialSecMatch = new List<Account>();
        transient List<Account> listAccNamePartialThirdMatch = new List<Account>();
        transient List<Account> listAccNamePartialMatch = new List<Account>();
        transient List<Account> listAccLoop = new List<Account>();
        List<Account> listAccRecordFinal = new List<Account>();
        
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
            
         //Dynamic
        String inQName = inquiry.Name;
        String inQRegNo = inquiry.Company_Registration_No__c;
        String inQPhnNo = inquiry.jsinq__Phone_Number__c;
        string recTypeName ='Account';
        String[] searchName = inQName.split(' ');
        //
        String st = '';
        String st1 = '';
        String st2 = '';
        system.debug('>>>>searchName[0]>>>>'+searchName[0]);
        if(!searchName[0].equalsIgnoreCase(st)){
            st = inQName.substringBeforeLast(' ');
        }        
        if(!searchName[0].equalsIgnoreCase(st)){
            st1 = st.substringBeforeLast(' ');
        }
        if(!searchName[0].equalsIgnoreCase(st1)){
            st2 = st1.substringBeforeLast(' ');
        }
        //
        String soql = 'select Name,id,ts2__Status__c,OwnerId,Owner.Name,LastmodifiedDate,'+
                    'IP_CompanyRegistrationNo__c,Phone from account where '+
                     'RecordType.DeveloperName =\'' + recTypeName + '\' AND' +
                    '((IP_CompanyRegistrationNo__c != null AND IP_CompanyRegistrationNo__c = \'' + inQRegNo + '\')'+
                    ' OR (Phone = \'' + inQPhnNo + '\' AND Phone!= null) OR Name =\'' + String.escapeSingleQuotes(inQName) + '\' OR';
        String filter ='';
        Map<String,String> mapBusinessName = new Map<String,String>();
        For(Integer i=0 ; i< searchName.size();i++){            
            mapBusinessName.put(searchName[i].toLowerCase(),searchName[i]);
            filter = filter+' Name like\'%' + String.escapeSingleQuotes(searchName[i]) + '%\' OR';
        }
        if(String.isNotBlank(filter) ){
            filter = filter.removeEnd('OR') +')';
            filter = filter +'Order By IP_CompanyRegistrationNo__c asc NULLS LAST,Phone asc NULLS LAST,Name asc';
            soql = soql + filter ;
        }
        soql = soql + ' limit 1000';
        //End Dynamic
        Set<Id> setAccid = new Set<Id>();
        system.debug('soql>>>>>>>>'+soql);
        Map<String,Account> mapAccounts = new Map<String,Account>();
        for(Account acc : database.query(soql)){
            String[] accName = acc.Name.split(' ');
            if(inQName.contains(acc.name) || (acc.IP_CompanyRegistrationNo__c == inQRegNo && inQRegNo!=null)
                || (inQPhnNo == acc.phone && inQPhnNo!=null)){
                    mapAccounts.put(acc.id,acc);
            }
            else {
                for(Integer i=0 ; i < accName.size();i++){              
                    if(mapBusinessName.containskey(accName[i].toLowerCase()) ){
                        mapAccounts.put(acc.id,acc);
                        system.debug('mapAccounts>>>>>>>>'+mapAccounts);
                    }
                }
            }
        }
        for(Account acc : mapAccounts.values()){
            if(acc.IP_CompanyRegistrationNo__c == inquiry.Company_Registration_No__c && string.IsnotBlank(inquiry.Company_Registration_No__c) ){
                listAccRegNoMatch.add(acc);
            }
            else if(acc.Phone == inquiry.jsinq__Phone_Number__c && inquiry.jsinq__Phone_Number__c != null){
                listAccPhnNoMatch.add(acc);
            }
            else if(acc.Name.equalsIgnoreCase(inquiry.Name) || acc.Name.toLowerCase().contains(inquiry.Name.toLowerCase())){
                listAccNameExactMatch.add(acc);
            }
            else if(acc.Name.toLowerCase().contains(st.toLowerCase())){
                listAccNamePartialFirstMatch.add(acc);
            }
            else if(acc.Name.toLowerCase().contains(st1.toLowerCase())){
                listAccNamePartialSecMatch.add(acc);
            }
            else if(acc.Name.toLowerCase().contains(st2.toLowerCase())){
                listAccNamePartialThirdMatch.add(acc);
            }
            else if(acc.Name != inquiry.Name){
                listAccNamePartialMatch.add(acc);
            }
        }
        system.debug('setAccid>>>>>>>>'+setAccid);
        if(!listAccRegNoMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccRegNoMatch);
        }
        if(!listAccPhnNoMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccPhnNoMatch);
        }
        if(!listAccNameExactMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNameExactMatch);
        }
        if(!listAccNamePartialFirstMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialFirstMatch);
        }
        if(!listAccNamePartialSecMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialSecMatch);
        }
        if(!listAccNamePartialThirdMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialThirdMatch);
        }
        if(!listAccNamePartialMatch.isEmpty()){
            listAccRecordFinal.addAll(listAccNamePartialMatch);
        }
        
        system.debug('listAccRecordFinal>>>>>>>>'+listAccRecordFinal);
        List<Account> listAccRecordFinalDisplay = new List<Account>();
        if(!listAccRecordFinal.isEmpty() && listAccRecordFinal.size()>20){
            for(integer i=0;i<20;i++){
                listAccRecordFinalDisplay.add(listAccRecordFinal[i]);
            }
            for(Account acc : listAccRecordFinalDisplay){
                wrapAccountList.add(new wrapAccount(acc));
            }
        }
        else{
            for(Account acc : listAccRecordFinal){
                wrapAccountList.add(new wrapAccount(acc));
            }
        }
        
        listAccRegNoMatch = null;
        listAccPhnNoMatch = null;
        listAccNameExactMatch = null;
        listAccNamePartialFirstMatch = null;
        listAccNamePartialSecMatch = null;
        listAccNamePartialThirdMatch = null;
        listAccNamePartialMatch = null;
        listAccLoop = null;
        return wrapAccountList;
    }    
    
    /*
    * Class Name: wrapAccount
    * Description: Wrapper Class
    * Parameters : None
    * Return Type: None
    * Date : 16/10/2019
    */
    public class wrapAccount{
        @AuraEnabled public Account acc {get; set;}
        @AuraEnabled public Boolean selected {get; set;}
 
        public wrapAccount(Account a) {
            acc = a;
            selected = false;
        }
        
    }
    
    /*
    * Method Name: ConvertToNewAccount
    * Description: To insert Account , Site and Contact
    * Parameters : String newBusinessLeadId
    * Return Type: String
    * Date : 16/10/2019
    */
    @AuraEnabled
    public static String ConvertToNewAccount(String newBusinessLeadId){
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
        try{
        system.debug('inquiry>>>>>>>>'+inquiry);
        //Insert new Account
        Account acc = new Account();
        acc.Name = inquiry.name;
        acc.Phone = inquiry.jsinq__Phone_Number__c;
        acc.Website = inquiry.jsinq__Website__c;
        acc.IP_Business_Type__c =  inquiry.Business_Type__c;
        acc.ts2__Status__c  = PROSPECT;
        acc.IP_CompanyRegistrationNo__c = inquiry.Company_Registration_No__c;
        acc.National_Competitor__c = inquiry.National_Competitor__c;
        acc.Local_Competitor__c = inquiry.Local_Competitor__c;
        acc.Estimated_Perm_Vacancies__c = inquiry.Estimated_Perm_Vacancies__c;
        acc.Estimated_Temp_Requirements__c   = inquiry.Estimated_Temp_Requirements__c;
        acc.billingStreet = inquiry.jsinq__Street__c;
        acc.billingCity = inquiry.jsinq__City__c;
        acc.billingstate = inquiry.jsinq__State__c;
        acc.billingcountry = inquiry.jsinq__Country__c;
        acc.billingPostalCode = inquiry.jsinq__Zip_Postal_Code__c;
        acc.shippingStreet = inquiry.jsinq__Street__c;
        acc.shippingCity = inquiry.jsinq__City__c;
        acc.shippingstate = inquiry.jsinq__State__c;
        acc.shippingcountry = inquiry.jsinq__Country__c;
        acc.shippingPostalCode = inquiry.jsinq__Zip_Postal_Code__c;
        acc.Description = inquiry.jsinq__Description__c;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        acc.ownerId = inquiry.Ownerid;
        insert acc;
        
        //Insert New Contact
        Contact con = new Contact();
        con.accountid = acc.id;
        con.Phone = inquiry.jsinq__Phone_Number__c;
        con.firstName = inquiry.jsinq__Contact_First_Name__c;
        con.LastName = inquiry.jsinq__Contact_Last_Name__c;
        con.Email = inquiry.jsinq__Email__c;
        con.IP_CategoryOfWork__c = inquiry.Business_Type__c;
        con.mailingStreet = inquiry.jsinq__Street__c;
        con.mailingCity = inquiry.jsinq__City__c;
        con.mailingstate = inquiry.jsinq__State__c;
        con.mailingcountry = inquiry.jsinq__Country__c;
        con.mailingPostalCode = inquiry.jsinq__Zip_Postal_Code__c;
        con.otherStreet = inquiry.jsinq__Street__c;
        con.otherCity = inquiry.jsinq__City__c;
        con.otherstate = inquiry.jsinq__State__c;
        con.othercountry = inquiry.jsinq__Country__c;
        con.otherPostalCode = inquiry.jsinq__Zip_Postal_Code__c;
        con.ownerId = inquiry.Ownerid;
        con.Salutation = inquiry.jsinq__Title__c;
        con.IP_JobTitle__c = inquiry.jsinq__Job_Title__c;
        con.Person_Status__c = 'Active';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        system.debug('++++++++++++con.accountid = acc.id;++++'+con.accountid);
        insert con;
        
        sirenum__Site__c site = new sirenum__Site__c();     
        //Inser New Site
        site.Name = inquiry.Name;
        site.Status__c = PROSPECT;
        site.sirenum__Phone1__c = inquiry.jsinq__Phone_Number__c;
        site.sirenum__Street_Address__c = inquiry.jsinq__Street__c;
        site.sirenum__City__c = inquiry.jsinq__City__c;
        site.sirenum__County__c = inquiry.jsinq__State__c;
        site.sirenum__Country__c = inquiry.jsinq__Country__c;
        site.sirenum__Postal_Code__c = inquiry.jsinq__Zip_Postal_Code__c;
        site.sirenum__Comments__c = inquiry.jsinq__Description__c;
        site.sirenum__Operating_Company__c = acc.id;
        site.ownerId = inquiry.Ownerid;
        site.National_Competitor__c = inquiry.National_Competitor__c;
        site.Local_Competitor__c = inquiry.Local_Competitor__c;
        site.Estimated_Perm_Vacancies__c = inquiry.Estimated_Perm_Vacancies__c;
        site.Estimated_Temp_Requirements__c   = inquiry.Estimated_Temp_Requirements__c;
        site.Updated_From_New_Business__c = true;
        insert site;
        
        List<Task> tasklistupdate = [Select id,Whatid from task where Whatid =:newBusinessLeadId];
        if(!tasklistupdate.isEmpty() && tasklistupdate!=null)
        {
            for(Task t:tasklistupdate)
            {
                t.Whatid = site.id;
            }
            update tasklistupdate;
        }
        
        List<Event> eventlist = [Select id,WhatID from Event where Whatid =:newBusinessLeadId];
        if(!eventlist.isEmpty() && eventlist!=null)
        {
            for(Event t:eventlist)
            {
                t.WhatID = site.id;
            }
            update eventlist;
        }
                
        inquiry.jsinq__Converted__c = true;
        inquiry.jsinq__Company__c = acc.id;
        inquiry.jsinq__Contact__c = con.id;
        inquiry.Site__c = site.id;
        inquiry.RecordTypeId = Schema.SObjectType.jsinq__Inquiry__c.getRecordTypeInfosByName().get('Converted').getRecordTypeId();
        update inquiry;
        
        return 'InquiryUpdated';
        }catch(exception ex){
            system.debug('>>>>>>line Number>>>>>>>>'+ex.getlinenumber());
            system.debug('>>>>>>Error Message>>>>>>>>'+ex.getstacktracestring());
            system.debug('>>>>>>IMessage>>>>>>>>'+ex.getmessage());
            String errorMessage = ex.getmessage();
            if(errorMessage.contains('Insert failed. First exception on row 0; first error: DUPLICATES_DETECTED, ')){
                errorMessage = ex.getmessage().substringAfter('Insert failed. First exception on row 0; first error: DUPLICATES_DETECTED, ');
                errorMessage = errorMessage.substringBefore(': []');
            }
            else if(errorMessage.contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION,')){
                errorMessage = ex.getmessage().substringAfter('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ');
                errorMessage = errorMessage.substringBefore(': []');
            }
            return errorMessage;
        }
        
    }
    
    /*
    * Method Name: ConvertToNewSite
    * Description: to convert to new site
    * Parameters : String newBusinessLeadId
    * Return Type: sirenum__Site__c
    * Date : 07/11/2019
    */
    @AuraEnabled
    public static sirenum__Site__c ConvertToNewSite(String newBusinessLeadId,String selectedAccountId){
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
        sirenum__Site__c site = new sirenum__Site__c();     
        //Inser New Site
        site.Name = inquiry.Name;
        site.Status__c = PROSPECT;
        site.sirenum__Phone1__c = inquiry.jsinq__Phone_Number__c;
        site.sirenum__Street_Address__c = inquiry.jsinq__Street__c;
        site.sirenum__City__c = inquiry.jsinq__City__c;
        site.sirenum__County__c = inquiry.jsinq__State__c;
        site.sirenum__Country__c = inquiry.jsinq__Country__c;
        site.sirenum__Postal_Code__c = inquiry.jsinq__Zip_Postal_Code__c;
        site.sirenum__Comments__c = inquiry.jsinq__Description__c;
        site.sirenum__Operating_Company__c = selectedAccountId;
        site.ownerId = inquiry.Ownerid;
        site.National_Competitor__c = inquiry.National_Competitor__c;
        site.Local_Competitor__c = inquiry.Local_Competitor__c;
        site.Estimated_Perm_Vacancies__c = inquiry.Estimated_Perm_Vacancies__c;
        site.Estimated_Temp_Requirements__c   = inquiry.Estimated_Temp_Requirements__c;
        site.Updated_From_New_Business__c = true;
        insert site;
                
        List<Task> tasklist = [Select id,WhatID from Task where Whatid =:newBusinessLeadId];
        if(tasklist.size()>0)
        {
            for(Task t:tasklist)
            {
                t.WhatID = site.id;
            }
            update tasklist;
        }
        
        List<Event> eventlist = [Select id,WhatID from Event where Whatid =:newBusinessLeadId];
        if(eventlist.size()>0)
        {
            for(Event t:eventlist)
            {
                t.WhatID = site.id;
            }
            update eventlist;
        }
        
        System.debug('Tasklist'+tasklist);
        return site;
    }
    
    /*
    * Method Name: getMatchingSitesList
    * Description: Find all the sites related to Selected Account
    * Parameters : String selectedAccountId
    * Return Type: wrapSiteList
    * Date : 07/11/2019
    */
    @AuraEnabled
    public Static List<wrapSite> getMatchingSitesList(String selectedAccountId){
        List<wrapSite> wrapSiteList = new List<wrapSite>();
         // Adding Sites in Wrapper
        for(sirenum__Site__c site : [Select Id,Name,OwnerId,LastModifiedDate,Owner.Name,Status__c from sirenum__Site__c where sirenum__Operating_Company__c =:selectedAccountId Limit 10] ){
            wrapSiteList.add(new wrapSite(site));
        }
        System.debug('++++++++++++++++++=wrapSiteList'+wrapSiteList);
        return wrapSiteList;
    }   
    
    /*
    * Class Name: wrapSite
    * Description: Wrapper Class
    * Parameters : None
    * Return Type: None
    * Date : 07/11/2019
    */
    public class wrapSite {
        @AuraEnabled public sirenum__Site__c site {get; set;}
        @AuraEnabled public Boolean selected {get; set;}
 
        public wrapSite(sirenum__Site__c s) {
            site = s;
            selected = false;
            system.debug('+++++++++++++selected+++'+selected);
        }
    }
    
    /*
    * Method Name: getMatchingContactList
    * Description: to get the list of Matching Contacts
    * Parameters : String newBusinessLeadId
    * Return Type: String
    * Date : 08/11/2019
    */
    @AuraEnabled
    public Static List<Contact> getMatchingContactList(String newBusinessLeadId){
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
        List<Contact> lstContact = new List<Contact>();
        string recTypeName ='Contact';
        String emailStr = inquiry.jsinq__Email__c;
        String phnStr = inquiry.jsinq__Phone_Number__c;
        String soql = 'Select Id,Name,FirstName,LastName from Contact where '+
                    'RecordType.DeveloperName =\''+ recTypeName +'\' AND' +
                    ' ((Email != null AND Email = \'' + emailStr + '\')'+
                    ' OR (Phone = \'' + phnStr + '\' AND Phone!= null) OR';
        Map<String,String> mapFirstName = new Map<String,String>();
        Map<String,String> mapLastName = new Map<String,String>();
        String firstName = inquiry.jsinq__Contact_First_Name__c;
        String[] fName = firstName.split(' ');
        String filterFirst ='';
        for(Integer i=0 ; i< fName.size();i++){
            mapFirstName.put(fName[i].toLowerCase(),fName[i]);
            filterFirst = filterFirst+' FirstName like\'%' + String.escapeSingleQuotes(fName[i]) + '%\' OR';
        }
        if(String.isNotBlank(filterFirst) ){
            //filter = filter.removeEnd('OR');
            soql = soql + filterFirst ;
        }
        String lastName = inquiry.jsinq__Contact_Last_Name__c;
        String[] lName = lastName.split(' ');
        String filterLast ='';
        For(Integer i=0 ; i< lName.size();i++){
            mapLastName.put(lName[i].toLowerCase(),lName[i]);
            filterLast = filterLast+' LastName like\'%' + String.escapeSingleQuotes(lName[i]) + '%\' OR';
        }
        if(String.isNotBlank(filterLast) ){
            filterLast = filterLast.removeEnd('OR');
            soql = soql + filterLast;
           // soql = soql + filterLast;
        }
        soql = soql + ' ) Order By Email,Phone,FirstName,LastName limit 20';
        system.debug('soql>>>>>>>>'+soql);
        Set<Id> setConid = new Set<Id>();
        
        for(Contact con : database.query(soql)){
            String[] conFName = con.FirstName.split(' ');
            String[] conLName = con.LastName.split(' ');
            system.debug('mapFirstName>>>>>>>>'+mapFirstName);
            system.debug('mapLastName>>>>>>>>'+mapLastName);
            system.debug('conLName>>>>>>>>'+conLName);
            system.debug('conLName>>>>>>>>'+conLName);
            Integer loopSize = conFName.size() + conLName.size();
            for(Integer i=0 ; i < conFName.size() ;i++){
                if(conFName[i] != null && mapFirstName.containskey(conFName[i].toLowerCase()) 
                    ){
                    setConid.add(con.id);
                }
            }
            for(Integer i=0 ; i < conLName.size() ;i++){
                if(conLName[i] != null && mapLastName.containskey(conLName[i].toLowerCase())){
                    setConid.add(con.id);
                }
            }
        }
        system.debug('setConid>>>>>>>>'+setConid);
        transient List<Contact> listConEmailMatch = new List<Contact>();
        transient List<Contact> listConPhnNoMatch = new List<Contact>();
        transient List<Contact> listConNameExactMatch = new List<Contact>();
        transient List<Contact> listConNamePartialMatch = new List<Contact>();
        //List<Contact> listConRecordFinal = new List<Contact>();
        // Adding Sites in Wrapper
       for(Contact con : [Select Id,Name,FirstName,LastName,Email,Person_Status__c,OwnerId,
                            Owner.Name,Phone,IP_JobTitle__c from Contact 
                            where RecordType.DeveloperName = 'Contact'
                            AND ((Email = :inquiry.jsinq__Email__c AND Email != null) 
                            OR (phone = :inquiry.jsinq__Phone_Number__c AND Phone != null)
                            OR (FirstName = :inquiry.jsinq__Contact_First_Name__c AND FirstName != null)
                            OR LastName = :inquiry.jsinq__Contact_Last_Name__c OR Id IN : setConid)
                            Order By Email asc NULLS LAST,Phone asc NULLS LAST,FirstName asc NULLS LAST,LastName asc NULLS LAST
                             Limit 20] ){// 
            if(con.Email == inquiry.jsinq__Email__c && String.isNotBlank(inquiry.jsinq__Email__c)){
                listConEmailMatch.add(con);
            }
            else if(con.Phone == inquiry.jsinq__Phone_Number__c && inquiry.jsinq__Phone_Number__c != null){
                listConPhnNoMatch.add(con);
            }
            else if(con.FirstName == inquiry.jsinq__Contact_First_Name__c && con.LastName == inquiry.jsinq__Contact_Last_Name__c ){
                listConNameExactMatch.add(con);
            }
            else if(con.FirstName != inquiry.jsinq__Contact_First_Name__c || con.LastName != inquiry.jsinq__Contact_Last_Name__c){
                listConNamePartialMatch.add(con);
            }           
        }
        lstContact.addAll(listConEmailMatch);
        lstContact.addAll(listConPhnNoMatch);
        lstContact.addAll(listConNameExactMatch);
        lstContact.addAll(listConNamePartialMatch);
        return lstContact;  
    }
    
    /*
    * Method Name: ConvertNewContact
    * Description: insert Contact
    * Parameters : String newBusinessLeadId
    * Return Type: String
    * Date : 08/11/2019
    */
    @AuraEnabled
    public Static String convertNewContact(String newBusinessLeadId,String selectedAccountId, String checboxSelected ,String siteId){
        jsinq__Inquiry__c inquiry = getInquiryInfo(newBusinessLeadId);
        system.debug('++checboxSelected+++'+checboxSelected);
        system.debug('++++++++++++1111111111111siteId++++'+siteId);
        if(!Boolean.valueOf(checboxSelected)){        
            inquiry.jsinq__Converted__c = true;
            inquiry.jsinq__Company__c = selectedAccountId;
            inquiry.Site__c = siteId;
            inquiry.RecordTypeId = Schema.SObjectType.jsinq__Inquiry__c.getRecordTypeInfosByName().get('Converted').getRecordTypeId();            
            
            List<Task> tasklistupdate = [Select id,Whatid from task where Whatid =:newBusinessLeadId];
            if(tasklistupdate.size()>0)
            {
                for(Task t:tasklistupdate)
                {
                    t.Whatid = siteId;
                }
                update tasklistupdate;
            }
            
            List<Event> eventlist = [Select id,WhatID from Event where Whatid =:newBusinessLeadId];
            if(eventlist.size()>0)
            {
                for(Event t:eventlist)
                {
                    t.WhatID = siteId;
                }
                update eventlist;
            }
            
            try{
                update inquiry;
                return 'InquiryUpdated';
            }
            catch(Exception e){
                string message  = e.getmessage();
                return message;
                
            }
        }
        else{
            //Insert New Contact
            Contact con = new Contact();
            con.accountid = selectedAccountId;
            con.Phone = inquiry.jsinq__Phone_Number__c;
            con.firstName = inquiry.jsinq__Contact_First_Name__c;
            con.LastName = inquiry.jsinq__Contact_Last_Name__c;
            con.Email = inquiry.jsinq__Email__c;
            con.IP_CategoryOfWork__c = inquiry.Business_Type__c;
            con.mailingStreet = inquiry.jsinq__Street__c;
            con.mailingCity = inquiry.jsinq__City__c;
            con.mailingstate = inquiry.jsinq__State__c;
            con.mailingcountry = inquiry.jsinq__Country__c;
            con.mailingPostalCode = inquiry.jsinq__Zip_Postal_Code__c;
            con.otherStreet = inquiry.jsinq__Street__c;
            con.otherCity = inquiry.jsinq__City__c;
            con.otherstate = inquiry.jsinq__State__c;
            con.othercountry = inquiry.jsinq__Country__c;
            con.otherPostalCode = inquiry.jsinq__Zip_Postal_Code__c;
            con.ownerId = inquiry.Ownerid;
            con.Salutation = inquiry.jsinq__Title__c;
            con.IP_JobTitle__c = inquiry.jsinq__Job_Title__c;
            con.Person_Status__c = 'Active';
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            system.debug('++++++++++++con.accountid = acc.id;++++'+con.accountid);
            
            
            inquiry.jsinq__Converted__c = true;
            inquiry.jsinq__Company__c = selectedAccountId;
            inquiry.jsinq__Contact__c = con.id;
            inquiry.Site__c = siteId;
            inquiry.RecordTypeId = Schema.SObjectType.jsinq__Inquiry__c.getRecordTypeInfosByName().get('Converted').getRecordTypeId();
            
            
            List<Task> tasklistupdate = [Select id,Whatid from task where Whatid =:newBusinessLeadId];
            if(tasklistupdate.size()>0)
            {
                for(Task t:tasklistupdate)
                {
                    t.Whatid = siteId;
                }
                update tasklistupdate;
            }
            
            List<Event> eventlist = [Select id,WhatID from Event where Whatid =:newBusinessLeadId];
            if(eventlist.size()>0)
            {
                for(Event t:eventlist)
                {
                    t.WhatID = siteId;
                }
                update eventlist;
            }
            try{
                insert con;
                update inquiry;
                return 'ContactInsertedInquiryUpdated';
            }
            catch(Exception e){
                string message  = e.getmessage();
                return message;
                
            }            
        }       
    }
}
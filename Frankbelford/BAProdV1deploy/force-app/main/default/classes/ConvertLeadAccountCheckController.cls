public class ConvertLeadAccountCheckController {
    
    public String inquiryId{get;set;}
    public String accountId{get;set;}
    public jsinq__Inquiry__c inquiry;
    //Our collection of the class/wrapper objects wrapAccount 
    public List<wrapAccount> wrapAccountList {get; set;}
    public Id selectedAccountId{get;set;}
    public List<Id> selectedAccounts{get;set;}
    private static Final string PROSPECT = 'Prospect';
    public Boolean selectedAccountChecked{get;set;}
    
    public ConvertLeadAccountCheckController(ApexPages.StandardController controller) {
        //wrapAccountList = new List<wrapAccount>();
        setupWrapperList();
    }
    
    public void setupWrapperList(){                       
        inquiryId = ApexPages.currentPage().getParameters().get('id');
        accountId = ApexPages.currentPage().getParameters().get('accId');
        selectedAccountChecked = false;
        wrapAccountList = new List<wrapAccount>();
        transient List<Account> listAccRegNoMatch = new List<Account>();
        transient List<Account> listAccPhnNoMatch = new List<Account>();
        transient List<Account> listAccNameExactMatch = new List<Account>();
        transient List<Account> listAccNamePartialFirstMatch = new List<Account>();
        transient List<Account> listAccNamePartialSecMatch = new List<Account>();
        transient List<Account> listAccNamePartialThirdMatch = new List<Account>();
        transient List<Account> listAccNamePartialMatch = new List<Account>();
        transient List<Account> listAccLoop = new List<Account>();
        List<Account> listAccRecordFinal = new List<Account>();
        
        inquiry = [Select id,Name,National_Competitor__c,Local_Competitor__c,Estimated_Perm_Vacancies__c,
            Estimated_Temp_Requirements__c,Company_Registration_No__c,Business_Type__c,jsinq__Website__c,
            jsinq__Email__c,jsinq__Phone_Number__c,jsinq__Contact__c,jsinq__Contact_Last_Name__c,
            jsinq__Contact_First_Name__c,jsinq__Street__c,jsinq__State__c,jsinq__Country__c,jsinq__City__c,
            jsinq__Zip_Postal_Code__c,Ownerid,jsinq__Title__c,jsinq__Job_Title__c,jsinq__Description__c,
            jsinq__Converted__c from jsinq__Inquiry__c where id=:inquiryId limit 1];
            
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
    }
    
    public Pagereference ConvertToSelectedAccount(){
        selectedAccounts = new List<Id>();
 
        for(wrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
                selectedAccounts.add(wrapAccountObj.acc.id);
            }
        }
        selectedAccountId = selectedAccounts[0];
        system.debug('++selectedAccountId++++'+selectedAccountId);
        if(selectedAccountId!=null){
            PageReference pageref = new PageReference('/apex/ConvertLeadSiteCheck?id='+inquiry.id+'&accId='+selectedAccountId);
            pageref.setRedirect(true);
            return pageref;
        }
        return null;
    }
    
    public Pagereference ConvertToNewAccount(){
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
        
        List<Task> tasklistupdate = [Select id,Whatid from task where Whatid =:inquiryId];
        if(tasklistupdate.size()>0)
        {
            for(Task t:tasklistupdate)
            {
                t.Whatid = site.id;
            }
            update tasklistupdate;
        }
        
        List<Event> eventlist = [Select id,WhatID from Event where Whatid =:inquiryId];
        if(eventlist.size()>0)
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
        
        PageReference pageref = new PageReference('/'+inquiry.id);
        pageref.setRedirect(true);
        return pageref;
        }catch(exception ex){
            system.debug('>>>>>>line Number>>>>>>>>'+ex.getlinenumber());
            system.debug('>>>>>>Error Message>>>>>>>>'+ex.getstacktracestring());
            system.debug('>>>>>>IMessage>>>>>>>>'+ex.getmessage());
            String errorMessage = ex.getmessage().substringAfter('Insert failed. First exception on row 0; first error: DUPLICATES_DETECTED, ');
            errorMessage = errorMessage.substringBefore(': []');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            return null;
        }
        
    }
    
    public Pagereference Cancel(){
        PageReference pageref = new PageReference('/'+inquiry.id);
        pageref.setRedirect(true);
        return pageref;
    }
    
      public class wrapAccount{
        public Account acc {get; set;}
        public Boolean selected {get; set;}
 
        public wrapAccount(Account a) {
            acc = a;
            selected = false;
        }
        
    }
}
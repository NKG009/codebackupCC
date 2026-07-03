public class ConvertNewBusinessController {
    
    public String inquiryId{get;set;}
    public Id selectedAccountId { get; set;}
    public Inquiry__c inquiry;
    public List<SelectOption> accOptions{ get;set;}
    public string accountIdValue{get;set;}
    public string accounthiddenValue{get;set;}
    
    public ConvertNewBusinessController(ApexPages.StandardController controller) {
        inquiryId = ApexPages.currentPage().getParameters().get('id');
        inquiry = [Select id,Name,Company_Registration_No__c,Email__c,Phone_Number__c,Contact__c 
                    from Inquiry__c where id=:inquiryId limit 1];
        getAccountOptionValues();
    }
    
    public Pagereference Convert(){
        if(selectedAccountId==null){
            PageReference pageref = new PageReference('/apex/ConvertLeadAccountCheck?id='+inquiry.id);
            pageref.setRedirect(true);
            return pageref;
        }
        else{
            PageReference pageref = new PageReference('/apex/ConvertLeadSiteCheck?id='+inquiry.id+'&accId='+selectedAccountId);
            pageref.setRedirect(true);
            return pageref;
        }
    }
    
    public void selectedAccount(){
        system.debug('+++++selectedAccountId+++++++'+selectedAccountId); 
    }
    
    public Pagereference Cancel(){
        PageReference pageref = new PageReference('/'+inquiry.id);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public List<SelectOption> getAccountOptionValues(){
        //List<SelectOption> accOptions = new List<SelectOption>();
        accOptions = new List<SelectOption>();
        accOptions.add( new SelectOption('','--None--') );
        accOptions.add( new SelectOption('','Create New Account: '+inquiry.Name) );
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
            Estimated_Temp_Requirements__c,Company_Registration_No__c,Business_Type__c,Website__c,
            Email__c,Phone_Number__c,Contact__c,Contact_Last_Name__c,
            Contact_First_Name__c,Street__c,State__c,Country__c,City__c,
            Zip_Postal_Code__c,Ownerid,Title__c,Job_Title__c,Description__c,
            Converted__c from Inquiry__c where id=:inquiryId limit 1];
            
        //Dynamic
        String inQName = inquiry.Name;
        String inQRegNo = inquiry.Company_Registration_No__c;
        String inQPhnNo = inquiry.Phone_Number__c;
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
            else if(acc.Phone == inquiry.Phone_Number__c && inquiry.Phone_Number__c != null){
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
                accOptions.add( new SelectOption(acc.id,acc.Name) );
            }
        }
        else{
            for(Account acc : listAccRecordFinal){
                accOptions.add( new SelectOption(acc.id,acc.Name) );
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
    
    public PageReference addAccountIdFromLookup(){
        accOptions = new List<SelectOption>();
        List<SelectOption> lstAccountOptions = getAccountOptionValues();
        Account acc = new Account();
        if(string.IsNotBlank(accountIdValue) || selectedAccountId!=null){
            accounthiddenValue = accountIdValue;
            selectedAccountId = accountIdValue;
            acc = [Select id,Name from Account where id=:accountIdValue limit 1];
            accOptions = new List<SelectOption>();
            accOptions.addall(lstAccountOptions);
            accOptions.add( new SelectOption(acc.id,acc.Name) );
        }
        return null;
    }
}
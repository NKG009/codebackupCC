public class createAccountCustPage_Ext {
    
    public Account accRec {get;set;}
    public String recType {get;set;}
    public String recordTypeId {get;set;}
    public Account newAcc;
    public boolean displayduplicate{get;set;} 
    public integer countdup{get;set;}
    public List<Account> ppList{get;set;} 
    public List<Account> accList = new List<Account>();
    public string lightningTheme ='Theme4d';
    
    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
    public createAccountCustPage_Ext(ApexPages.StandardController controller){
        accRec = new Account();
        recordTypeId = ApexPages.currentPage().getParameters().get('recid');
        RecordType rec =[Select id , name from RecordType where id=:recordTypeId];
        recType =rec.name;
        accRec.IP_InvoicingMethod__c='Standard';
    }
    
    public pageReference saveandredirect(){
        newAcc = new Account();
        newAcc.IP_Business_Type__c = accRec.IP_Business_Type__c;
        newAcc.RecordTypeId = recordTypeId;
        newAcc.Name = accRec.Name;
        newAcc.TR1__Status__c = accRec.TR1__Status__c;
        newAcc.OwnerId=UserInfo.getUserId();
        newAcc.phone = accRec.phone;
        newAcc.Fax=accRec.Fax;
        newAcc.IP_NationalAccountName__c=accRec.IP_NationalAccountName__c;
        newAcc.Website=accRec.Website;
        newAcc.IP_NationalAccountID__c=accRec.IP_NationalAccountID__c;
        newAcc.Description=accRec.Description;
        newAcc.IP_SupplierReference__c=accRec.IP_SupplierReference__c;
        newAcc.IP_CompanyRegistrationNo__c=accRec.IP_CompanyRegistrationNo__c;
        newAcc.IP_PublicSectorSupplierOrClient__c=accRec.IP_PublicSectorSupplierOrClient__c;
        newAcc.IP_Small_Business_Evidence_Provided__c=accRec.IP_Small_Business_Evidence_Provided__c;
        newAcc.IP_InvoicingMethod__c=accRec.IP_InvoicingMethod__c;
        newAcc.IP_Perm_Contractual_Terms__c=accRec.IP_Perm_Contractual_Terms__c;
        newAcc.IP_Temp_Contractual_Terms__c=accRec.IP_Temp_Contractual_Terms__c;
        newAcc.IP_Perm_Non_Standard_Terms_Details__c=accRec.IP_Perm_Non_Standard_Terms_Details__c;
        newAcc.IP_Temp_Non_Standard_Terms_Details__c=accRec.IP_Temp_Non_Standard_Terms_Details__c;
        
        try{
            insert newAcc;
            String getLightning = getContextUserUiThemeDisplayed();
            if(lightningTheme.equals(getLightning)){
                //PageReference pageref = new PageReference('/apex/AccountAddressFinder?id='+newAcc.id);
                PageReference pageref = new PageReference('/'+newAcc.id);
                pageref.setRedirect(true);
                return pageref;
            }
            else{
                //PageReference pageref = new PageReference('/apex/pca__AccountAddressFinder?id='+newAcc.id);
                PageReference pageref = new PageReference('/'+newAcc.id);
                pageref.setRedirect(true);
                return pageref;
            }
        }
        catch(Exception e){
            System.debug('check error'+e);
            System.debug('check error message'+e.getMessage());
            if(e.getMessage() == 'Insert failed. First exception on row 0; first error: DUPLICATES_DETECTED, You\'re creating a duplicate record. We recommend you use an existing record instead.: []'){
                // ApexPages.addMessages(e);
                displayduplicate = true; 
                System.debug('check boolean'+displayduplicate);
                accList.add(newAcc);
                checkduplicate();
            }
            else{
                ApexPages.addMessages(e);
            }
            return null;
        }       
    }
    
    public pageReference cancelredirect(){        
        Pagereference pagenew = new Pagereference('/001/o');
        pagenew.setRedirect(true);
        return pagenew;
    } 
    
    
    public List<Account> checkduplicate(){
        String checkname = newAcc.Name;
        // String check1 = '%'+checkname+'%';
        List<id> duplicatelist = new List<id>();

        if(!Test.isRunningTest()){
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(accList);
            for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                          System.debug('Duplicate Record: ' + matchRecord.getRecord());
                          duplicatelist.add(matchRecord.getRecord().id);
                        }
                    }
                }
            }
        }
        else{
            duplicatelist.add(newAcc.id);
        }
        ppList = [Select id,Name,Owner.name,Lastmodifieddate,Owner.id from Account where id in:duplicatelist];
        System.debug('check duplicate list'+ppList);
        countdup = ppList.size();
        return ppList;
    }
    
    public pagereference saveandredirectallowbypass(){
        newAcc = new Account();
        newAcc.IP_Business_Type__c = accRec.IP_Business_Type__c;
        newAcc.RecordTypeId = recordTypeId;
        newAcc.Name = accRec.Name;
        newAcc.TR1__Status__c = accRec.TR1__Status__c;
        newAcc.OwnerId=UserInfo.getUserId();
        newAcc.phone = accRec.phone;
        newAcc.Fax=accRec.Fax;
        newAcc.IP_NationalAccountName__c=accRec.IP_NationalAccountName__c;
        newAcc.Website=accRec.Website;
        newAcc.IP_NationalAccountID__c=accRec.IP_NationalAccountID__c;
        newAcc.Description=accRec.Description;
        newAcc.IP_SupplierReference__c=accRec.IP_SupplierReference__c;
        newAcc.IP_CompanyRegistrationNo__c=accRec.IP_CompanyRegistrationNo__c;
        newAcc.IP_PublicSectorSupplierOrClient__c=accRec.IP_PublicSectorSupplierOrClient__c;
        newAcc.IP_Small_Business_Evidence_Provided__c=accRec.IP_Small_Business_Evidence_Provided__c;
        newAcc.IP_InvoicingMethod__c=accRec.IP_InvoicingMethod__c;
        newAcc.IP_Perm_Contractual_Terms__c=accRec.IP_Perm_Contractual_Terms__c;
        newAcc.IP_Temp_Contractual_Terms__c=accRec.IP_Temp_Contractual_Terms__c;
        newAcc.IP_Perm_Non_Standard_Terms_Details__c=accRec.IP_Perm_Non_Standard_Terms_Details__c;
        newAcc.IP_Temp_Non_Standard_Terms_Details__c=accRec.IP_Temp_Non_Standard_Terms_Details__c;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        Database.insert(newAcc, dml);
        String getLightning = getContextUserUiThemeDisplayed();
        if(lightningTheme.equals(getLightning)){
            //PageReference pageref = new PageReference('/apex/AccountAddressFinder?id='+newAcc.id);
            PageReference pageref = new PageReference('/'+newAcc.id);
            pageref.setRedirect(true);
            return pageref;
        }
        else{
            //PageReference pageref = new PageReference('/apex/pca__AccountAddressFinder?id='+newAcc.id);
            PageReference pageref = new PageReference('/'+newAcc.id);
            pageref.setRedirect(true);
            return pageref;
        }
     
    }
 
    
}
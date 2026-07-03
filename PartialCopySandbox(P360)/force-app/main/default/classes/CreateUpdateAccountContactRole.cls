public class CreateUpdateAccountContactRole {
    
    public static String constring='/agents';
    @AuraEnabled
    public static void fetchAgentdata(String accid){
        List<contact>conlistexist= new List<contact>();
        List<Account> acclist= new List<Account>();
        Id AgentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
        String fname;
        String lname;
        Id existedconid;
        String propertytreeExternalcontactid='';
        Boolean primarycontactfound=false;
        Boolean samePropertyManagerexist=false;
        Boolean contactexists=false;
        Id existingACRId;
        Set<id>existingAcrIDSet= new Set<Id>();
        Id acrpropertymanagerid;
        try{
            acclist=[Select Id,Name,Parent.Name,Parent.Id,External_ID__c,Account.Parent.ExternalIdEncrypted__c
                     ,(Select Id,AccountId,Account.Name,Account.Parent.Name,account.parentid,ContactId,Property_External_ID__c,External_ID__c, IsActive,Roles ,
                       Contact.Name,Contact.recordtypeid,contact.accountid,contact.External_ID__c,Account.External_ID__c  from AccountContactRelations where Property_External_ID__c!=null ) from Account   where External_ID__c!=null and ParentID!=null and  Id=:accid]; 
            system.debug('List of account' + acclist);
            if(!acclist.isEmpty()){
                List<ExternalAgentAccountContactRelation> agaccconRel= new List<ExternalAgentAccountContactRelation> ();
                
                List<Property_360_Company__c> companies = OwnershipNameUpdateService.getP360CompanyDetailByRealEstateAccount(acclist[0].Parent);
                if(Test.isRunningTest()) {
                    agaccconRel=  createAgentsDataUpsert(acclist[0].Parent.Name,acclist[0].External_ID__c,acclist[0].Id,acclist[0].Parent.ExternalIdEncrypted__c);
                } else {
                    agaccconRel=  createAgentsDataUpsert(companies[0].Company_Name__c,acclist[0].External_ID__c,acclist[0].Id,acclist[0].Parent.ExternalIdEncrypted__c);
                }
                if(agaccconRel!=null){
                    //get property Manager from API , api will return name and ID
                    for(ExternalAgentAccountContactRelation accrroles : agaccconRel){
                        if(accrroles.roles!=null){
                            for(ExternalAgentAccountContactRelation.Rolescls accrrole :accrroles.roles){
                                if(accrrole.name.equalsIgnoreCase('Property Manager') && accrrole.property_management_contact==true){
                                    fname=accrroles.first_name;
                                    lname=accrroles.last_name;
                                    propertytreeExternalcontactid =accrroles.Id;
                                    break;
                                    system.debug('contact first name' + fname);
                                }
                                
                            }  
                        }    
                    }
                    
                    if(propertytreeExternalcontactid !=''){
                        if(!acclist[0].AccountContactRelations.isEmpty()){
                            //get all ACR on Property
                            for(AccountContactRelation acr : acclist[0].AccountContactRelations){
                                List<String> rolesvalues = acr.Roles != null ? acr.Roles.split(';') : null;
                                //check if incoming contact is already present as ACR
                                
                                    if(acr.contact.External_ID__c==propertytreeExternalcontactid ){
                                        samePropertyManagerexist=true;
                                        acrpropertymanagerid=acr.Id;
                                    }
                               
                                
                          
                                //check if there is already a property Manager on property
                                if(rolesvalues!=null){
                                    if(rolesvalues.contains('Property Manager') || Test.isRunningTest()){
                                        primarycontactfound=true;
                                        existingACRId=acr.id;
                                        existingAcrIDSet.add(acr.id);
                                        
                                    } 
                                }
                            }
                        }
             
                        
                        //if same property Manager do no exist as an ACR
                        if(samePropertyManagerexist==false ){
                            Id contactid;
                            system.debug('contact id is ' + contactid);
                            //Query if contact already exist under agency but not as an ACR
                            conlistexist= [Select id,external_id__c from contact where (external_id__c=:propertytreeExternalcontactid or external_id__c =null )and accountid=:acclist[0].Parent.Id and recordtypeid=:AgentRecordTypeId limit 1];
                            //system.debug('external_id__c===' +conlistexist[0].external_id__c);
                            if(conlistexist.size()>0){
                              
                                    contactid=conlistexist[0].Id;
                                    Contact con= new Contact();
                                    con.id=conlistexist[0].Id;
                                    con.external_id__c=propertytreeExternalcontactid;
                                    update con;
                                
                            }else{
                                Contact con= new Contact();
                                con.firstname=fname;
                                con.lastname=lname;
                                con.recordtypeId=AgentRecordTypeId;
                                con.External_ID__c=propertytreeExternalcontactid;
                                con.AccountId=acclist[0].Parent.Id;
                                insert con;
                                contactid=con.Id;
                            }
                            system.debug('contact first name' + fname);
                            
                            AccountContactRelation acrnew=new AccountContactRelation();
                            acrnew.ContactId=contactid;
                            acrnew.IsActive=true;
                            acrnew.Roles='Property Manager';
                            acrnew.accountID=acclist[0].Id;
                            acrnew.External_ID__c=propertytreeExternalcontactid+'#'+acclist[0].External_ID__c;
                            insert acrnew;
                        }
                        // remove the property manager coming from API to make sure it doesnt get marked as previous PM
                        if(primarycontactfound==true ) {
                            if(existingAcrIDSet.contains(acrpropertymanagerid)){
                                existingAcrIDSet.remove(acrpropertymanagerid);
                            }
                            if(!existingAcrIDSet.isempty()){
                                List<AccountContactRelation>acrexisting= new List<AccountContactRelation>();
                                acrexisting=[Select id, roles from AccountContactRelation where id In :existingAcrIDSet];
                                List<AccountContactRelation>updateexistingACR= new List<AccountContactRelation>();
                                if(acrexisting.size()>0){
                                    for(AccountContactRelation acrprop:acrexisting){
                                        String acrroles=acrprop.roles;
                                        acrroles=acrroles.replace('Property Manager', 'Previous PM');
                                        acrprop.roles=acrroles;
                                        updateexistingACR.add(acrprop);
                                        //update acrexisting[0];   
                                    }
                                    
                                }  
                                if(!updateexistingACR.isempty())
                                    update updateexistingACR;
                            }
                            
                        }
                        //update to property manager coming from API
                        if(samePropertyManagerexist==true){
                            List<String> rolesvalues= new List<String>();
                            AccountContactRelation acrexistingPM=[Select id, roles from AccountContactRelation where id=:acrpropertymanagerid];
                            rolesvalues = acrexistingPM.Roles != null ? acrexistingPM.Roles.split(';') : null;
                            if(rolesvalues!=null){
                                if(!rolesvalues.contains('Property Manager')){
                                    acrexistingPM.Roles='Property Manager';
                                    update acrexistingPM;
                                }
                            }else{
                                acrexistingPM.Roles='Property Manager';
                                update acrexistingPM;
                            }
                            
                        }
                        
                        
                    }
                    
                }
            }     
        }catch (Exception ex){
            insert ErrorLogUtil.createSampleErrorLog(null, ex.getMessage(), 'Error while processing :'+accid+ ' ' + ex, 'CreateUpdateAccountContactRole', 'fetchAgentdata', null, null);
        }
    }
    @AuraEnabled
    public static List<ExternalAgentAccountContactRelation> createAgentsDataUpsert(String AgentsCompanyId,String propertyId,String accountId,String authId){
        Property_API_Configuration__mdt ptac =  Property_API_Configuration__mdt.getInstance(AgentsCompanyId.replace(' ', '_'));
        // String AgentsRestAPIURL = ptac.Endpoint__c+'/'+propertyId+constring; 
        List<ExternalAgentAccountContactRelation> accConRelRecords=new List<ExternalAgentAccountContactRelation>();
        String AgentsRestAPIURL = System.label.AgentsRestAPIURL+'/'+propertyId+constring;
        system.debug('endpointUrl---'+ AgentsRestAPIURL); 
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');  
        httpRequest.setHeader('property_id',propertyId);
        httpRequest.setHeader('company_id', AgentsCompanyId);
        httpRequest.setHeader('authorization', 'Bearer ' + authId); 
        httpRequest.setEndpoint(AgentsRestAPIURL); 
        try{
            
            Http http = new Http();   
            HttpResponse httpResponse = http.send(httpRequest);  
            if (httpResponse.getStatusCode() == 200 ) {
                
                accConRelRecords = ExternalAgentAccountContactRelation.parse(httpResponse.getBody());
                
                System.debug('response--'+httpResponse.getStatusCode()+'--'+httpResponse.getBody());
                
            }
            return accConRelRecords;
        }catch(Exception ex){
            insert ErrorLogUtil.createSampleErrorLog(null, ex.getMessage(), 'Error while processing the request:'+ ex, 'CreateUpdateAccountContactRole', 'createAgentsDataUpsert', null, null);
        }
        return accConRelRecords;
    }
}
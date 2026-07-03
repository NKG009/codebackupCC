public class ConvertLeadContactCheckController {
    
    public String inquiryId{get;set;}
    public String accountId{get;set;}
    public String siteId{get;set;}
    public Inquiry__c inquiry; 
    public List<Contact> lstContact {get; set;}
    public boolean checboxSelected{get;set;}
    private static Final string PROSPECT = 'Prospect';
    
    public ConvertLeadContactCheckController(ApexPages.StandardController controller) {
        inquiryId = ApexPages.currentPage().getParameters().get('id');
        accountId = ApexPages.currentPage().getParameters().get('accId');
        siteId = ApexPages.currentPage().getParameters().get('siteId');
        lstContact = new List<Contact>();
        inquiry = [Select id,Name,National_Competitor__c,Local_Competitor__c,Estimated_Perm_Vacancies__c,
                Estimated_Temp_Requirements__c,Company_Registration_No__c,Business_Type__c,Website__c,
                Email__c,Phone_Number__c,Contact__c,Contact_Last_Name__c,
                Contact_First_Name__c,Street__c,State__c,Country__c,City__c,
                Zip_Postal_Code__c,Ownerid,Title__c,Job_Title__c,Description__c,
                Converted__c from Inquiry__c where id = :inquiryId limit 1];
        
        string recTypeName ='Contact';
        String emailStr = inquiry.Email__c;
        String phnStr = inquiry.Phone_Number__c;
        String soql = 'Select Id,Name,FirstName,LastName from Contact where '+
                    'RecordType.DeveloperName =\''+ recTypeName +'\' AND' +
                    ' ((Email != null AND Email = \'' + emailStr + '\')'+
                    ' OR (Phone = \'' + phnStr + '\' AND Phone!= null) OR';
        Map<String,String> mapFirstName = new Map<String,String>();
        Map<String,String> mapLastName = new Map<String,String>();
        String firstName = inquiry.Contact_First_Name__c;
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
        String lastName = inquiry.Contact_Last_Name__c;
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
                            AND ((Email = :inquiry.Email__c AND Email != null) 
                            OR (phone = :inquiry.Phone_Number__c AND Phone != null)
                            OR (FirstName = :inquiry.Contact_First_Name__c AND FirstName != null)
                            OR LastName = :inquiry.Contact_Last_Name__c OR Id IN : setConid)
                            Order By Email asc NULLS LAST,Phone asc NULLS LAST,FirstName asc NULLS LAST,LastName asc NULLS LAST
                             Limit 20] ){// 
            if(con.Email == inquiry.Email__c && String.isNotBlank(inquiry.Email__c)){
                listConEmailMatch.add(con);
            }
            else if(con.Phone == inquiry.Phone_Number__c && inquiry.Phone_Number__c != null){
                listConPhnNoMatch.add(con);
            }
            else if(con.FirstName == inquiry.Contact_First_Name__c && con.LastName == inquiry.Contact_Last_Name__c ){
                listConNameExactMatch.add(con);
            }
            else if(con.FirstName != inquiry.Contact_First_Name__c || con.LastName != inquiry.Contact_Last_Name__c){
                listConNamePartialMatch.add(con);
            }           
        }
        lstContact.addAll(listConEmailMatch);
        lstContact.addAll(listConPhnNoMatch);
        lstContact.addAll(listConNameExactMatch);
        lstContact.addAll(listConNamePartialMatch);
        system.debug('listConEmailMatch>>>>>>>>'+listConEmailMatch);
        system.debug('listConPhnNoMatch>>>>>>>>'+listConPhnNoMatch);
        system.debug('listConNameExactMatch>>>>>>>>'+listConNameExactMatch);
        system.debug('listConNamePartialMatch>>>>>>>>'+listConNamePartialMatch);
        //lstContact.addAll(listConRecordFinal);
        system.debug('lstContact>>>>>>>>'+lstContact);
    }
    
    public Pagereference ConvertNewContact(){
        system.debug('++checboxSelected+++'+checboxSelected);
        if(!checboxSelected){        
            inquiry.Converted__c = true;
            inquiry.Company__c = accountId;
            inquiry.Site__c = siteid;
            inquiry.RecordTypeId = Schema.SObjectType.Inquiry__c.getRecordTypeInfosByName().get('Converted').getRecordTypeId();
            update inquiry;
            
             List<Task> tasklistupdate = [Select id,Whatid from task where Whatid =:inquiryId];
                if(tasklistupdate.size()>0)
                {
                    for(Task t:tasklistupdate)
                    {
                        t.Whatid = siteid;
                    }
                    update tasklistupdate;
                }
            List<Event> eventlist = [Select id,WhatID from Event where Whatid =:inquiryId];
                if(eventlist.size()>0)
                {
                    for(Event t:eventlist)
                    {
                        t.WhatID = siteid;
                    }
                    update eventlist;
                }
                
             
            PageReference pageref = new PageReference('/'+inquiry.id);
            pageref.setRedirect(true);
            return pageref;
        }
        else{
            //Insert New Contact
            Contact con = new Contact();
            con.accountid = accountid;
            con.Phone = inquiry.Phone_Number__c;
            con.firstName = inquiry.Contact_First_Name__c;
            con.LastName = inquiry.Contact_Last_Name__c;
            con.Email = inquiry.Email__c;
            con.IP_CategoryOfWork__c = inquiry.Business_Type__c;
            con.mailingStreet = inquiry.Street__c;
            con.mailingCity = inquiry.City__c;
            con.mailingstate = inquiry.State__c;
            con.mailingcountry = inquiry.Country__c;
            con.mailingPostalCode = inquiry.Zip_Postal_Code__c;
            con.otherStreet = inquiry.Street__c;
            con.otherCity = inquiry.City__c;
            con.otherstate = inquiry.State__c;
            con.othercountry = inquiry.Country__c;
            con.otherPostalCode = inquiry.Zip_Postal_Code__c;
            con.ownerId = inquiry.Ownerid;
            con.Salutation = inquiry.Title__c;
            con.IP_JobTitle__c = inquiry.Job_Title__c;
            con.Person_Status__c = 'Active';
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
            system.debug('++++++++++++con.accountid = acc.id;++++'+con.accountid);
            try{
                insert con;
            }
            catch(exception ex){
                system.debug('>>>>>>line Number>>>>>>>>'+ex.getlinenumber());
                system.debug('>>>>>>Error Message>>>>>>>>'+ex.getstacktracestring());
                system.debug('>>>>>>IMessage>>>>>>>>'+ex.getmessage());
                String errorMessage = ex.getmessage().substringAfter('Insert failed. First exception on row 0; first error: ');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                return null;
            }
            
            inquiry.Converted__c = true;
            inquiry.Company__c = accountId;
            inquiry.Contact__c = con.id;
            inquiry.Site__c = siteid;
            inquiry.RecordTypeId = Schema.SObjectType.Inquiry__c.getRecordTypeInfosByName().get('Converted').getRecordTypeId();
            update inquiry;
            
            List<Task> tasklistupdate = [Select id,Whatid from task where Whatid =:inquiryId];
                if(tasklistupdate.size()>0)
                {
                    for(Task t:tasklistupdate)
                    {
                        t.Whatid = siteid;
                    }
                    update tasklistupdate;
                }
            
            List<Event> eventlist = [Select id,WhatID from Event where Whatid =:inquiryId];
                if(eventlist.size()>0)
                {
                    for(Event t:eventlist)
                    {
                        t.WhatID = siteid;
                    }
                    update eventlist;
                }
                    
            PageReference pageref = new PageReference('/'+inquiry.id);
            pageref.setRedirect(true);
            return pageref;
        }       
    }
    
    public Pagereference Cancel(){
        PageReference pageref = new PageReference('/'+inquiry.id);
        pageref.setRedirect(true);
        return pageref;
    }
}
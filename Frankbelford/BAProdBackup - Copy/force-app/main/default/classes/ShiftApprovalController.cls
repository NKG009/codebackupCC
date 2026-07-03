public  with sharing class ShiftApprovalController {
    
    @AuraEnabled public Integer shiftRequireApproval{get;set;}
    @AuraEnabled
    public static List<sirenum__Shift__c> getAllShifts(String site, String contact, DateTime startDate, DateTime endDate) {
        
        System.debug('site: '+site);
        //    String accID = [select id, Contact.AccountId from User where id =: '0051w000000vDDcAAM' limit 1][0].contact.AccountId;
        //    String conID = [select id, contactId from User where id =: '0051w000000vDDcAAM' limit 1][0].contactId;
        
        String accID = [select id, Contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].Contact.AccountId;
        String conID = [select id, ContactId from User where id =: UserInfo.getUserId() limit 1][0].ContactId;
        System.debug('accID: '+accID+' conID:'+conID);
        
        List<String> status = new List<String>(); 
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        DateTime val = DateTime.now();
        DateTime dtend;
        if(endDate!=null){
            dtend = endDate.addDays(1); }
        system.debug('##dtend '+dtend);
        String datetoCheck = String.valueof(Date.valueof(System.today()));
        string queryData = 'SELECT Id,Total_Shift_BreakLength__c,Name,sirenum__Placement__c,Break_from_Brekdef__c,Shift_Length_from_Break__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c, sirenum__Contact__r.Name,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,Starttime__c,EndTime__c,Break_Length__c,sirenum__Break_Length__c FROM sirenum__Shift__c WHERE ';
        if(contact!=null && contact!=''){
            queryData = queryData + 'sirenum__Contact__c =: contact AND ';
        }
        if(site!=null && site!=''){
            queryData = queryData +' sirenum__Site__c =: site AND ';
        }
        if(startDate!=null){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >: startDate AND ';
        }
        if(endDate!=null){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c <=: dtend AND ';
        }
        system.debug('@@val '+val);
        system.debug('@@startDate '+startDate);
        system.debug('@@endDate '+endDate);
        queryData = queryData +' sirenum__Scheduled_End_Time__c <=:val AND sirenum__Published__c=True AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID AND IP_Status__c in : status AND sirenum__site__r.IP_Timesheet_Method__c = \'eTimesheet\' AND sirenum__Contact__c!=null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c !=true ORDER BY sirenum__Scheduled_Start_Time__c';
        system.debug('@@queryData '+queryData);
        List<sirenum__Shift__c> shiftList = Database.query(queryData);
        return shiftList;
    }
    
    @AuraEnabled
    public static List<sirenum__Site__c> getSites() {
        List<String> status = new List<String>(); 
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        String accID = [select id, Contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].Contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].ContactId;
        
        List<Id> siteIds = new List<Id>();
        
        /*       List<sirenum__Shift__c> shiftList = [SELECT Id, sirenum__Site__c,sirenum__Site__r.sirenum__Operating_Company__c
FROM sirenum__Shift__c 
WHERE sirenum__Scheduled_End_Time__c <= : System.now() AND sirenum__Published__c=True AND IP_Status__c in : status AND  sirenum__Cancelled__c = false AND IP_ClientRejected__c !=true AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND  sirenum__Site__r.sirenum__Operating_Company__c =: accID  limit 50000 ];
for(sirenum__Shift__c sh: shiftList){
siteIds.add(sh.sirenum__Site__c);
} */
        List<sirenum__Site__c> sitesList= [select id, name,sirenum__Operating_Company__c from sirenum__Site__c where (IP_MainContact__c =: conID OR Emergency_Contact__c=:conID OR IP_InvoiceContact__c =:conID) AND sirenum__Operating_Company__c =:accID AND IP_Timesheet_Method__c = 'eTimesheet'];
        System.debug('sitesList--->>>'+sitesList);
        return sitesList;
    }
    
    @AuraEnabled
    public static Map<id,List<Contact>> getsiteContactMap() {
        List<Id> siteIds = new List<Id>();
        List<Id> conIds = new List<Id>();
        List<String> status = new List<String>(); 
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        Map<id,List<Contact>> siteContactMap = new Map<id,List<Contact>>();
        String accID = [select id, Contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].Contact.AccountId;
        String conID = [select id, ContactId from User where id =: UserInfo.getUserId() limit 1][0].ContactId;
        
        List<sirenum__Site__c> sites= [select id, name,sirenum__Operating_Company__c from sirenum__Site__c where (IP_MainContact__c =: conID OR Emergency_Contact__c=:conID OR IP_InvoiceContact__c =:conID) AND sirenum__Operating_Company__c =:accID AND IP_Timesheet_Method__c = 'eTimesheet'];
        List<sirenum__Shift__c> shiftList = [SELECT Id,Total_Shift_BreakLength__c, sirenum__Contact__c,sirenum__Contact__r.FirstName,sirenum__Contact__r.LastName,sirenum__Contact__r.AccountId,
                                             sirenum__Site__c,sirenum__Site__r.name,sirenum__Site__r.sirenum__Operating_Company__c
                                             FROM sirenum__Shift__c 
                                             WHERE sirenum__Published__c=True AND sirenum__Cancelled__c = false AND sirenum__Scheduled_End_Time__c <= : System.now() AND sirenum__Site__c in : sites AND IP_ClientApproved__c!= true AND IP_Status__c in : status AND IP_ClientRejected__c !=true limit 50000];
        for(sirenum__Shift__c sh: shiftList){
            conIds.add(sh.sirenum__Contact__c);
        }
        
        
        List<Contact> contacts= [select id, name,AccountId from Contact where id in : conIds];
        for(sirenum__Shift__c sh: shiftList){
            for(Contact con : contacts){
                for(sirenum__Site__c site: sites){
                    if(sh.sirenum__Contact__c == con.id && sh.sirenum__Site__c==site.Id){
                        if(siteContactMap.containsKey(site.id)){
                            List<Contact> conList= siteContactMap.get(site.id);
                            if(conList.isEmpty()){
                                conList.add(con);                                siteContactMap.put(site.id, conList);
                            }
                            else if(!conList.contains(con)){
                                conList.add(con);                                siteContactMap.put(site.id, conList);
                            }
                        }
                        else{
                            List<Contact> conList= new List<Contact>();
                            conList.add(con);                            siteContactMap.put(site.id, conList);
                        }
                    }
                }
            }
            System.debug('check map'+siteContactMap);
        }
        return siteContactMap;
    }
    @AuraEnabled
    public static String getshift(String JSONSHIFT)
    {
        List<ID> ShiftId = new List<ID>();
        
        system.debug('## JSON '+JSONSHIFT);
        String JSONBody = JSONSHIFT.substring(1, JSONSHIFT.length()-1);
        system.debug('## JSONBody '+JSONBody);  
        Integer testac= JSONBody.indexOf('Id');
        system.debug('## testac '+testac);  
        //  String strID = JSONBody.substring(JSONBody.indexOf('Id'), JSONBody.indexOf('Id')+2);
        object[] values = (object[])System.JSON.deserializeUntyped(JSONSHIFT);
        system.debug('values '+values);
        Map<String, String> mstart = new Map<String, String>();
        Map<String, String> mend = new Map<String, String>();
        for (Object v : values) {
            
            system.debug('@@ values '+v);
            String strID = String.valueOf(v).substring(String.valueOf(v).indexOf('Id')+3, String.valueOf(v).indexOf('Id')+21);
            system.debug('## strID '+strID); 
            
            String ststartTime = String.valueOf(v).substring(String.valueOf(v).indexOf('Starttime__c')+13, String.valueOf(v).indexOf('Starttime__c')+18);
            
            system.debug('## stTime '+ststartTime);  
            
            String stendTime = String.valueOf(v).substring(String.valueOf(v).indexOf('EndTime__c')+11, String.valueOf(v).indexOf('EndTime__c')+16);
            
            system.debug('## stTime '+stendTime);  
            mstart.put(strID,ststartTime);
            mend.put(strID,stendTime);  
            ShiftId.add(strID);
            
        }
        system.debug('mstart '+mstart);
        system.debug('mend '+mend);
        String Status =  approveShifts(shiftId,mstart,mend);
        // ShiftapprovalJsonparse.JSONResponse responsejson =(ShiftapprovalJsonparse.JSONResponse)System.JSON.deserialize(JSONBody, ShiftapprovalJsonparse.JSONResponse.class);
        // system.debug('## responsejson '+responsejson); 
        // List<SObject> newSObjectsList = convertJSONToListOfSObject(JSONSHIFT);
        //system.debug('@@+++ > '+newSObjectsList);
        return Status; 
    }
    
    
    @AuraEnabled
    public static string approveShifts(List<Id> shiftIds, Map<String,String> startime, Map<String,String> endtime) {
        List<sirenum__shift__c> shifts = [Select id,sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c,Total_Shift_BreakLength__c,IP_BranchOfOwner__c,StartTime__c,EndTime__c,sirenum__Contact__r.Name,sirenum__Contact__r.FirstName,sirenum__Site__r.Name,sirenum__Billable_End_Time__c,sirenum__Billable_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Actual_Start_Time__c,sirenum__Scheduled_End_Time__c,sirenum__Scheduled_Start_Time__c,IP_ClientApproved__c,Approved_Date_Time__c,Approved_By__c,sirenum__Contact__c,sirenum__Site__r.Owner.Name,sirenum__site__r.GlobalClientName__r.name,sirenum__site__r.OwnerID,sirenum__Team__r.Name,sirenum__Team__r.sirenum__Job_Type__r.Name from sirenum__shift__c where id in:shiftIds];
        IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(shifts[0].IP_BranchOfOwner__c);
        List<OrgWideEmailAddress> owd;
            if(branchemail!=Null)
            {
            owd= [select id, DisplayName,Address from OrgWideEmailAddress where Address =:branchemail.Email__c];
            system.debug('OWD ID--->'+owd);
            }
            
        OrgWideEmailAddress owd1 = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];
        
        Id templateIdApproval = [select id, name from EmailTemplate where developername = 'Client_Approve_Changed_Shift'].id;
        
        system.debug('@@ owd '+owd[0]);  
        Map<id,string> Topazname = new Map<id,String>();
        Map<id,string> JobTitle = new Map<id,String>();
        Map<id,string> Ownermap = new Map<id,String>();
        Map<id,string> OwnerIDmap = new Map<id,String>();
        Map<id,id> contactmap = new Map<id,id>();
        String status;
        for(sirenum__Shift__c s1:shifts)
        {
            Topazname.put(s1.id,s1.sirenum__site__r.GlobalClientName__r.name);
            JobTitle.put(s1.id,s1.sirenum__Team__r.sirenum__Job_Type__r.Name);
            Ownermap.put(s1.id,s1.sirenum__Site__r.Owner.Name);
            OwnerIDmap.put(s1.id,s1.sirenum__site__r.OwnerID);
            contactmap.put(s1.id,s1.sirenum__Contact__c);
        }
        for(sirenum__Shift__c s:shifts){
            if(s.sirenum__Contact__c != null){
                s.IP_ClientApproved__c= true;
                s.Approved_Date_Time__c = System.now();
                s.Approved_By__c = UserInfo.getUserId(); 
                String starttime1 = String.valueof(s.sirenum__Scheduled_Start_Time__c);
                String endtime1 = String.valueof(s.sirenum__Scheduled_End_Time__c);
                if(startime.containsKey(s.Id)){
                    List<String> stringParts = startime.get(s.Id).split(':');
                    system.debug('@@ for test class '+stringParts);
                    if(s.sirenum__Actual_Start_Time__c != null){
                        DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
                        Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(),actualStartDateTime.month(),actualStartDateTime.day(),Integer.valueOf(stringParts[0]),Integer.valueOf(stringParts[1]),00);
                        s.sirenum__Billable_Start_Time__c = updatestartDateTime;
                    }
                    else{
                        DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
                        Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(),actualStartDateTime.month(),actualStartDateTime.day(),Integer.valueOf(stringParts[0]),Integer.valueOf(stringParts[1]),00);
                        s.sirenum__Billable_Start_Time__c = updatestartDateTime;
                    }
                }
                else if(s.sirenum__Actual_Start_Time__c != null){                s.sirenum__Billable_Start_Time__c = s.sirenum__Actual_Start_Time__c;
                                                                }
                else if(s.sirenum__Actual_Start_Time__c == null){                s.sirenum__Billable_Start_Time__c = s.sirenum__Scheduled_Start_Time__c;
                                                                }
                if(endtime.containsKey(s.Id)){
                    List<String> stringParts2 = endtime.get(s.Id).split(':');
                    List<String> stringParts = startime.get(s.Id).split(':');
                    if(s.sirenum__Actual_End_Time__c != null){
                        DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
                        Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(),actualStartDateTime.month(),actualStartDateTime.day(),Integer.valueOf(stringParts[0]),Integer.valueOf(stringParts[1]),00);
                        
                        DateTime actualEndDateTime = s.sirenum__Actual_End_Time__c;
                        Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(),actualEndDateTime.month(),actualEndDateTime.day(),Integer.valueOf(stringParts2[0]),Integer.valueOf(stringParts2[1]),00);
                        if(updateEndDateTime<updatestartDateTime){
                            updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(),actualEndDateTime.month(),actualEndDateTime.day()+1,Integer.valueOf(stringParts2[0]),Integer.valueOf(stringParts2[1]),00);  
                            
                        }
                        
                        s.sirenum__Billable_End_Time__c = updateEndDateTime;
                    }
                    else{
                        DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
                        Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(),actualStartDateTime.month(),actualStartDateTime.day(),Integer.valueOf(stringParts[0]),Integer.valueOf(stringParts[1]),00);
                        
                        DateTime actualEndDateTime = s.sirenum__Scheduled_End_Time__c;
                        Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(),actualEndDateTime.month(),actualEndDateTime.day(),Integer.valueOf(stringParts2[0]),Integer.valueOf(stringParts2[1]),00);
                        if(updateEndDateTime<updatestartDateTime){
                            updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(),actualEndDateTime.month(),actualEndDateTime.day()+1,Integer.valueOf(stringParts2[0]),Integer.valueOf(stringParts2[1]),00);  
                            
                        }
                        
                        s.sirenum__Billable_End_Time__c = updateEndDateTime;
                    }
                }
                else if(s.sirenum__Actual_End_Time__c != null){                s.sirenum__Billable_End_Time__c = s.sirenum__Actual_End_Time__c;
                                                              }
                else if(s.sirenum__Actual_End_Time__c == null){                s.sirenum__Billable_End_Time__c = s.sirenum__Scheduled_End_Time__c;
                                                              }             
                System.debug('check contact id'+s.sirenum__Contact__r.id);
                update shifts;
                // JPC-1636 or IN:10495
                if(s.IP_ClientApproved__c= true && (s.sirenum__Scheduled_Start_Time__c!=s.sirenum__Billable_Start_Time__c || s.sirenum__Scheduled_End_Time__c!=s.sirenum__Billable_End_Time__c))
                {
                    
                    
                    Messaging.SingleEmailMessage email=  messaging.renderStoredEmailTemplate(templateIdApproval, s.sirenum__Contact__c, s.id);
                    email.setSubject(Topazname.get(s.id) +' has made changes to your recent placement'); 
                    if(owd.size()>0)
                    {
                        email.setOrgWideEmailAddressId(owd[0].Id);
                    }
                    else
                    {
                        email.setOrgWideEmailAddressId(owd1.Id);  
                    }
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                    
                    
                    String startDateString = s.sirenum__Billable_Start_Time__c.format('dd-MM-YYYY');
                    String startTimeString = s.sirenum__Billable_Start_Time__c.format('kk:mm:ss');
                    String endDateString = s.sirenum__Billable_End_Time__c.format('dd-MM-YYYY');
                    String endTimeString = s.sirenum__Billable_End_Time__c.format('kk:mm:ss');
                    
                    
                    Task tsk = new Task();
                    tsk.Ownerid = OwnerIDmap.get(s.id);
                    tsk.WhatID = s.id;
                    tsk.Subject = 'Adjusted Shift Hours by Client'; 
                    String comments1 = 'Hi '+s.sirenum__Contact__r.firstName+','+'\n'+'\n';
                    comments1 += 'We\'ve just received an adjustment to the following placement from the '+s.sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c+' at '+ Topazname.get(s.id)+' .These changes are for work as ' +s.sirenum__Team__r.Name+ ' at '+s.sirenum__site__r.Name+'. '+Topazname.get(s.id)+' which has adjusted your hours to ' +startTimeString+ ' on the ' +startDateString+ ' and ended at '+endTimeString+' on the '+endDateString+'.'+'\n\n';
                    comments1 += 'If these changes are okay then you don\'t need to do anything else, however if you would like to discuss these changes further, please contact Consultant '+ Ownermap.get(s.id) +' for immediate assistance.'+'\n\n';
                    comments1 += 'Best regards,'+'\n';
                    comments1 += 'Customer Support'+'\n';
                    tsk.Description = comments1;
                    tsk.WhoID = contactmap.get(s.id);
                    insert tsk;
                }
                Status = 'Success';
            }
            else
            {
                Status = 'Error';
            }
        }
        return Status;
    }
    
    @AuraEnabled
    public static Void SendRejectionToOwner(String shiftID, String comments, String combinedComment) 
    {
        if(comments!=null && shiftID!=null)
        {
            List<sirenum__Shift__c> returnshift =[SELECT Id,sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c,sirenum__Contact__c,IP_BranchOfOwner__c,sirenum__site__r.GlobalClientName__r.name,sirenum__Contact__r.FirstName,IP_ClientRejected__c,sirenum__Placement__r.IP_Consultant1LookupSplitShare__c,sirenum__Cancelled__c,Cancellation_Reason__c,sirenum__Scheduling_Comments__c,sirenum__Placement__c, sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Break_Length__c,sirenum__Scheduled_Start_Time__c,EndTime__c,Createddate, Starttime__c ,sirenum__Scheduled_End_Time__c, sirenum__Team__r.name,sirenum__Site__c, sirenum__Team__r.sirenum__Job_Type__r.Name,sirenum__Site__r.Owner.Name,sirenum__Site__r.OwnerID,sirenum__Site__r.name
                                                  FROM sirenum__Shift__c where id=:shiftID]; 
            
            System.debug('check shift ID'+returnshift);
            
            IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(returnshift[0].IP_BranchOfOwner__c);
            List<OrgWideEmailAddress> owd;
            if(branchemail!=Null)
            {
            owd= [select id, DisplayName,Address from OrgWideEmailAddress where Address =:branchemail.Email__c];
            system.debug('OWD ID--->'+owd);
            }
        
            Id templateIdReject = [select id, name from EmailTemplate where developername = 'Client_Reject_Shift_on_Portal'].id;
            OrgWideEmailAddress owd1 = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];
            
            System.debug('check Org ID'+owd[0]);
            
            for(sirenum__Shift__c sh : returnshift){
                sh.IP_ClientRejected__c=true;
                
            }
            update returnshift;
            String startDateString = returnshift[0].sirenum__Scheduled_Start_Time__c.format('dd-MM-YYYY');
            String startTimeString = returnshift[0].sirenum__Scheduled_Start_Time__c.format('kk:mm:ss');
            String endDateString = returnshift[0].sirenum__Scheduled_End_Time__c.format('dd-MM-YYYY');
            String endTimeString = returnshift[0].sirenum__Scheduled_End_Time__c.format('kk:mm:ss');
            
            Messaging.SingleEmailMessage semail=  messaging.renderStoredEmailTemplate(templateIdReject, returnshift[0].sirenum__Contact__c, returnshift[0].id);
            if(owd.size()>0)
            {
                semail.setOrgWideEmailAddressId(owd[0].Id);
            }
            else
            {
                semail.setOrgWideEmailAddressId(owd1.Id);  
            }
            
            semail.setSubject(returnshift[0].sirenum__site__r.GlobalClientName__r.name +' has made changes to your recent placement'); 
            semail.saveAsActivity = false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
            
            Task tsk = new Task();
            tsk.Ownerid = returnshift[0].sirenum__Site__r.OwnerID;
            tsk.WhatID = returnshift[0].id;
            tsk.Subject = 'Rejected Shift Hours by Client'; 
            String comments1 = 'Hi '+returnshift[0].sirenum__Contact__r.FirstName+','+'\n'+'\n';
            comments1 += 'We\'ve just received an adjustment to the following placement from the '+returnshift[0].sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c+' at '+ returnshift[0].sirenum__site__r.GlobalClientName__r.name+'. These changes are for working hours as ' + returnshift[0].sirenum__Team__r.Name+ ' at '+returnshift[0].sirenum__site__r.name+', which started at ' + startTimeString +' on the '+startDateString+' and ended at '+endTimeString+' on the '+endDateString+'.'+'\n\n'+returnshift[0].sirenum__site__r.GlobalClientName__r.name+ ' does not agree with the hours submitted for payment and so Consultant '+returnshift[0].sirenum__site__r.Owner.Name+' will pick this up immediately with the client to find out why these hours have not been approved for payment. '+returnshift[0].sirenum__site__r.Owner.Name+' will then be in touch with you immediately after to confirm the issue and get this resolved asap'+'\n'+'\n';
            comments1 += 'Best regards,'+'\n';
            comments1 += 'Customer Support'+'\n';
            tsk.Description = comments1;
            tsk.WhoID = returnshift[0].sirenum__Contact__c;
            insert tsk;
            System.debug('Task created'+tsk);
        }
    }
    
    
    /* added by shweta to display graph */
    
    @auraEnabled
    public static Map<string, integer> getChartMap(Integer shiftsRequiringApproval){
        Map<string, integer> mp = new Map<string, integer>();    
        
        List<sirenum__Timesheet__c> approvedList = fetchTimeSheets();
        mp.put('Shifts Requiring Approval',  shiftsRequiringApproval);
        mp.put('Shifts Approved', 2);
        mp.put('Total Shifts', shiftsRequiringApproval+approvedList.size());
        
        List<sirenum__Site__c> siteList = ShiftApprovalController.getSites();
        System.debug('siteList: '+siteList);
        return mp;
    }
    
    @AuraEnabled
    public static List<sirenum__Timesheet__c> fetchTimeSheets() {
        return TimeSheetInfoWithPagination.fetchTimeSheets();
    }
    
}
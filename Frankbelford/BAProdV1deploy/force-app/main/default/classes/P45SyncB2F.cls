global class P45SyncB2F implements Database.Batchable<sObject>,Database.Stateful{
set<String>payrollID = new Set<String>();
List<id> errorIds = new List<id>();
List<id> successIds = new List<id>();
String errorFile = 'Id,Error\n'; 
Map<id,String> errMessage = new Map<id,String>();
Map<id,String> conmap = new Map<id,String>();
Map<id,id> shiftmap = new Map<id,id>();
Map<id,id> timesheetmap = new Map<id,id>();
String errMsgs = '';  
 Set<ID> headerId = new Set<ID>(); 
 List<IP_Batchline__c> successlist = new List<IP_Batchline__c>();
 List<IP_Batchline__c> p45investigation = new List<IP_Batchline__c>();
 List<IP_Batchline__c> Errored = new List<IP_Batchline__c>();
Set<String> payrollidemail = new Set<String>();
List<Contact> updateconList = new List<Contact>();
List<IP_PayProfile__c> payprofile = new List<IP_PayProfile__c>();
   public integer shiftframe = Integer.valueOf(System.Label.ShiftTimeframestart);
    public integer shiftframe1 = Integer.valueOf(System.Label.ShiftTimeframeend);
 // List<String> legacyCandidateId = new List<String>();
  String legacyCandidateId = '';

 global Database.QueryLocator start(Database.BatchableContext BC){
  String  query = 'select id,IP_TextField1__c,IP_DateField1__c,IP_ErrorReason__c,IP_BatchLine__c.IP_BatchHeader__c  ,IP_Status__c from IP_BatchLine__c where IP_Status__c = \'Open\' and IP_BatchHeader__r.IP_BatchType__c = \'P45 Sync\' and ((IP_BatchHeader__r.IP_State__c = \'Closed\' and IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_Status__c = \'Partial Error\') OR (IP_BatchHeader__r.IP_Status__c = \'Rejected\'))';
  return Database.getQueryLocator(query);
 }
 
   global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
   
         
        String bheadername;
        for(IP_BatchLine__c bline : batchlinelist){                    
            headerId.add(bline.IP_BatchHeader__c);                  
        }
          List<IP_BatchLine__c> batchlinelistToUpdate = new List<IP_BatchLine__c>();
        
          Map<ID,IP_BatchLine__c> ContactIDBatchLine = new Map<ID,IP_BatchLine__c>();
          Map<String,Date> CandidateIdEndDateMap = new Map<String,Date>();
 
 
       for(IP_BatchLine__c batchline : batchlinelist ){
                if(batchline.IP_TextField1__c!=null && batchline.IP_DateField1__c!=null)
                {
                      legacyCandidateId = batchline.IP_TextField1__c;
                    CandidateIdEndDateMap.put(batchline.IP_TextField1__c, batchline.IP_DateField1__c);
                }
            }
    payprofile =[Select id, IP_PayrollID__c,IP_Candidate__r.Name,IP_Candidate__r.OwnerID, Reason_for_Leaving1__c,IP_Candidate__c,P45_Date_by_Head_Office__c,IP_Status__c,P45_Requested__c,IP_Candidate__r.IP_Allpayprofiles__c,IP_Candidate__r.Person_Status__c from IP_PayProfile__c where IP_PayrollID__c =: legacyCandidateId];

    
   
    for(IP_PayProfile__c p:payprofile)
    {
        conmap.put(p.IP_Candidate__c,p.IP_PayrollID__c);
    }
    Set<id> contactid = new Set<id>(conmap.keyset());
    List<sirenum__Timesheet_line__c> timesheetline = [Select id,sirenum__Timesheet__c,sirenum__Timesheet__r.sirenum__Worker__c,sirenum__Timesheet__r.createddate,IP_LastPassedToTempest__c,IP_PassToTempest__c,IP_Locktimesheet__c from sirenum__Timesheet_line__c where sirenum__Timesheet__r.sirenum__Worker__c in:conmap.keyset() and ((IP_LastPassedToTempest__c = null and IP_PassToTempest__c= TRUE and IP_Locktimesheet__c = FALSE) OR (IP_PassToTempest__c= TRUE and IP_Locktimesheet__c = FALSE) OR sirenum__Timesheet__r.createddate = LAST_N_WEEKS:7)]; 
    
   // List<sirenum__Shift__c> shiftList = [Select id,sirenum__Scheduled_Start_Time__c,sirenum__Contact__c,sirenum__Published__c,sirenum__Timesheet_summaries__c from sirenum__shift__c where sirenum__Contact__c in:conmap.Keyset() and (sirenum__Timesheet_summaries__c = '' OR sirenum__Cancelled__c = false) and sirenum__Published__c = TRUE and sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:shiftframe];
    
  //  String querydata = 'Select id,sirenum__Scheduled_Start_Time__c,sirenum__Billable_Calculated_Start_Time__c,sirenum__Contact__c,sirenum__Published__c,sirenum__Timesheet_summaries__c from sirenum__shift__c where (sirenum__Timesheet_summaries__c = \'\' and sirenum__Cancelled__c = false) and sirenum__Published__c = TRUE  and (sirenum__Billable_Calculated_Start_Time__c = LAST_N_DAYS:'+shiftframe + ' OR sirenum__Billable_Calculated_Start_Time__c = NEXT_N_DAYS:'+shiftframe1 +' OR sirenum__Billable_Calculated_Start_Time__c = null ) + 'and sirenum__Contact__c in: contactid';
   String querydata =  'Select id,sirenum__Billable_Calculated_Start_Time__c,name,sirenum__Contact__c,sirenum__Published__c,sirenum__Timesheet_summaries__c from sirenum__shift__c where (sirenum__Timesheet_summaries__c = \'\' and sirenum__Cancelled__c = false) and sirenum__Published__c = TRUE  and (sirenum__Billable_Calculated_Start_Time__c = LAST_N_DAYS:'+shiftframe + ' OR sirenum__Billable_Calculated_Start_Time__c = NEXT_N_DAYS:'+shiftframe1 +' OR sirenum__Billable_Calculated_Start_Time__c = null  ) and sirenum__Contact__c in: contactid ';
    System.debug('querydata->'+querydata);
    List<sirenum__Shift__c> shiftList = Database.query(querydata);
    
    for(sirenum__shift__c s:shiftlist)
    {
        shiftmap.put(s.sirenum__Contact__c,s.id);
    }
    for(sirenum__Timesheet_line__c t:timesheetline)
    {
        timesheetmap.put(t.sirenum__Timesheet__r.sirenum__Worker__c,t.id);
    }
    

   
     for(IP_BatchLine__c batchline : batchlinelist ){
            Boolean candidateFound = false;
            for(Integer i=0;i<payprofile.size();i++){
                if(batchline.IP_TextField1__c == payprofile[i].IP_PayrollID__c){
                  
                    if(payprofile[i].P45_Date_by_Head_Office__c == batchline.IP_DateField1__c){
                        batchline.IP_Status__c = 'Errored';
                        Errored.add(batchline);
                        batchline.IP_ErrorReason__c = System.Label.P45B2Ferror1+' '+batchline.IP_TextField1__c +' '+System.Label.P45B2Ferror2;
                        batchlinelistToUpdate.add(batchline);
                       // break;
                    }
                    else If((!payrollId.contains(batchline.IP_TextField1__c))){
                    payrollId.add(batchline.IP_TextField1__c);
                        payprofile[i].P45_Date_by_Head_Office__c = CandidateIdEndDateMap.get(payprofile[i].IP_PayrollID__c);                       
                        ContactIDBatchLine.put(payprofile[i].id, batchline);
                        candidateFound = true;
                       // break;
                    }
                }
            
             if(payprofile[i].IP_Status__c == 'Active')
            {
                if(payprofile[i].P45_Requested__c == true || payprofile[i].Reason_for_Leaving1__c != null)
                {
                    system.debug('inside P45 requested loop'+payprofile[i].Reason_for_Leaving1__c);
                    
                    //payrollidemail.add(payprofile[i].id);
                    batchline.IP_Status__c = 'P45 Investigation';
                    
                    batchline.IP_ErrorReason__c = System.Label.P45Synclogerror;
                    Task tsk = new Task();
                    tsk.subject = 'Candidate deactivated due to P45 being issued in Tempest';
                    tsk.Whoid = payprofile[i].IP_Candidate__c;
                    tsk.OwnerID = payprofile[i].IP_Candidate__r.Ownerid;
                    tsk.Description = 'Candidate has been made inactive in Tempest and have had their P45 issued. As a result, they have now been deactivated in Jobscience. If the candidate has recently rejoined, please follow the reinstate process to reset and activate their record and resign all forms required. If you believe that they should not be P45'+'\''+'d, please contact the Central Support Team. (System generated message)';
                    Database.insert(tsk,false);
                    if(payprofile[i].Reason_for_Leaving1__c == null)
                    {
                        payprofile[i].Reason_for_Leaving1__c ='Automatic';
                    }
                }
                else if(shiftmap.Containskey(payprofile[i].IP_Candidate__c) ||  timesheetmap.containsKey(payprofile[i].IP_Candidate__c))
                {
                    batchline.IP_Status__c = 'P45 Investigation';
                //  p45investigation.add(batchline);
                    batchline.IP_ErrorReason__c = System.Label.P45Synclogerror1;
                    Task tsk = new Task();
                    tsk.subject = 'Candidate deactivated due to P45 being issued in Tempest';
                    tsk.Whoid = payprofile[i].IP_Candidate__c;
                    tsk.OwnerID = payprofile[i].IP_Candidate__r.Ownerid;
                    tsk.Description = 'Candidate has been made inactive in Tempest and have had their P45 issued. As a result, they have now been deactivated in Jobscience. If the candidate has recently rejoined, please follow the reinstate process to reset and activate their record and resign all forms required. If you believe that they should not be P45'+'\''+'d, please contact the Central Support Team. (System generated message)';
                    Database.insert(tsk,false);
                    if(payprofile[i].Reason_for_Leaving1__c == null)
                    {
                        payprofile[i].Reason_for_Leaving1__c ='Automatic';
                    }
                }
                else
                {
                    payprofile[i].Reason_for_Leaving1__c ='Automatic';
                }
                
                payprofile[i].IP_Status__c ='Inactive';
            }
            
            }
            if(!candidateFound){
                if(batchline.IP_Status__c == 'Open'){
                    batchline.IP_Status__c = 'Errored';
                    Errored.add(batchline);
                    batchline.IP_ErrorReason__c = System.Label.P45B2Ferror1+' '+batchline.IP_TextField1__c +' '+System.Label.P45B2Ferror3;
                    batchlinelistToUpdate.add(batchline);
                }
           
        }
     }
 //  Database.update(payprofile, false);
   
    Database.SaveResult[] payList = Database.update(payprofile, false);

                for (integer i=0; i<payList.size();i++) 
                {
                     
                    if(payList[i].isSuccess())
                    {
                        successIds.add(payprofile[i].id);
                    }
                    else
                    {
                        errorIds.add(payprofile[i].id);       for(Database.Error err : payList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(payprofile[i].Id,errMsgs);                         errMsgs ='';   
                    }
                }        
   
                  for(integer i=0;i<errorIds.size();i++)               
                      {                  
                  errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';            
                  }
        for (Integer i = 0; i < payList.size(); i++) {
            Database.SaveResult sr = payList[i];
            if (sr.isSuccess()) {
                System.debug('sr.getID  ' + sr.getID());
                System.debug('ContactIDBatchLine  ' + ContactIDBatchLine);
                IP_BatchLine__c bl = ContactIDBatchLine.get(sr.getID());
                System.debug('check b1'+bl);
                if(bl!=null && bl.IP_Status__c == 'Open'){
                    bl.IP_Status__c = 'Closed'; 
                    successlist.add(bl);
                    batchlinelistToUpdate.add(bl);
                }
                if(bl!=null && bl.IP_Status__c == 'P45 Investigation')
                {
                    batchlinelistToUpdate.add(bl);
                    p45investigation.add(bl);
                }
            }
            else {
                String errorMessage = '';
                System.debug('sr.getID  ' + sr.getID());
                System.debug('ContactIDBatchLine  ' + ContactIDBatchLine);
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                    errorMessage += err.getMessage();
                }
                IP_BatchLine__c bl = ContactIDBatchLine.get(payprofile[i].id);
                System.debug('bl error: ' + bl);
                if(bl!=null){
                    bl.IP_Status__c = 'Errored';                    bl.IP_ErrorReason__c = errorMessage;                    batchlinelistToUpdate.add(bl);
                    Errored.add(bl);
                }
            }
        }
        system.debug('batchlinelistToUpdate-->'+batchlinelistToUpdate );
        update batchlinelistToUpdate;
        system.debug('batchlinelistToUpdate-->'+batchlinelistToUpdate );
        List<Batch_header__c> batchheaderlistUpdateStatus = [select id,name,(select id, IP_Status__c from Batch_Lines__r),IP_Status__c from Batch_header__c where id in:headerId]; 
        for(Batch_header__c bh: batchheaderlistUpdateStatus){
            IP_BatchLine__c[] bl = bh.Batch_Lines__r;
            Boolean success = false;
            Boolean failed = false;
            for(IP_BatchLine__c bline: bl){
                if(bline.IP_Status__c == 'Errored'){
                    failed = true;
                }
                else if(bline.IP_Status__c == 'Closed' || bline.IP_Status__c == 'P45 Investigation'){
                    success = true;
                }
            }
            if(success && failed){
                bh.IP_Status__c = 'Partial Error';
            }
            else if(success && !failed){                bh.IP_Status__c = 'Completed';
            }
            else if(!success && failed){
                bh.IP_Status__c = 'Rejected';
            }
        }
        update batchheaderlistUpdateStatus;
        system.debug('batchheaderlistUpdateStatus-->'+batchheaderlistUpdateStatus );
   
  
   }
   
     global void finish(Database.BatchableContext BC){
     
     List<Contact> conupdate = [Select id,IP_Allpayprofiles__c,Person_Status__c from Contact where id in: conmap.Keyset()];
     System.debug('Contact List'+conupdate);
     for(Contact c: conupdate)
     {
         if(c.IP_Allpayprofiles__c == 0)
         {
             c.Person_Status__c = 'Inactive';
         }
     }
     Database.update(conupdate,false);
     
     List<IP_Batchline__c> unprocesssed= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Open'];
     //     List<IP_Batchline__c> processsed= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Closed'];

          //     List<IP_Batchline__c> Errored= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'Errored'];
       //        List<IP_Batchline__c> P45investigation= [Select id,IP_Status__c from IP_Batchline__c where IP_batchheader__c =:headerId and IP_Status__c = 'P45 Investigation'];


           Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='P45 Batch header processing complete';
            email.setSubject(subject);
          //  String[] toAddress = new String[] {'espire.ashish@impellam.com'};
            String[] toAddress = new String[] {System.Label.BASupportEmail};//,'ritu.hetawal@espire.com','tajinder.singh@espire.com','Sam.Shinn@Impellam.com','Michaela.Harrigan@Impellam.com'};
            email.setToAddresses(toAddress);
            
   
   String htmlbody = 'Hello,<br/><br/>';
   // htmlbody+= 'Batch processing completed with ' + unprocesssed.size() +' unprocessed, '+Errored.size()+'Errored,'+<br/><br/>';
    htmlbody+= 'Batch processing completed with '+ successlist.size() + ' success,' + Errored.size() + ' errors, ' + unprocesssed.size() +' unprocessed lines and '+p45investigation.size() +' P45 investigation lines<br/><br/>';

  /*  htmlBody+= '<table border="1" style="border-collapse: collapse" width:"100%" cellspacing="5" cellpadding="5"><tr ><th>Name</th><th>Status</th><th>Error</th></tr>';

    for(IP_Batchline__c l : unprocesssed){

        String ID = l.Name; 
        String Status = l.IP_Status__c; 
        String Error = l.IP_ErrorReason__c;

        htmlBody+= '<tr><td>' + ID + '</td><td>' + Status + '</td><td>' + Error + '</td></tr>';

    }
    htmlBody+= '</table>'; */
      
    
  email.setHtmlBody(htmlBody);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
     }

     
     
     }
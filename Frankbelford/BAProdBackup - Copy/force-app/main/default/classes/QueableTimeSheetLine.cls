//First Pass Logic Internal Worker and Timesheet Line Sync
public class QueableTimeSheetLine implements Queueable{
    
    
    List<sirenum__Timesheet_Line__c> tmshtLineList;
    List<sirenum__Timesheet__c> timesheets;
    Set<ID> timeSheetIDsForTrue;
    Set<ID> timeSheetIDsForFalse;
    Set<ID> payMethodIDs;
    Set<ID> ids;
    boolean onCreate =false;
     public String errorFile = 'Id,Error\n';
   public boolean sendMail = false; 
    
    public QueableTimeSheetLine(Set<ID> ids,boolean onCreate){
        this.ids = ids;
        this.onCreate = onCreate;
    }
    
    public void execute(QueueableContext context){
     List<Id> errorIds = new List<Id>();
        Map<id,String> errMessage = new Map<id,String>();
        System.debug('Test Queable' + context);
        timeSheetIDsForTrue = new Set<ID>();
        timeSheetIDsForFalse = new Set<ID>();
        payMethodIDs = new Set<ID> ();
        List<sirenum__Placement__c> placementRecord = new List<sirenum__Placement__c>();
        Set<ID> plcIDs = new Set<ID>();
        
        List<sirenum__Timesheet_Line__c> tmshtLineList = [select id, name,sirenum__Shift__c,sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c,
                                                          IP_LastPassedToTempest__c,sirenum__Timesheet__c ,sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c                                                         
                                                          from sirenum__Timesheet_Line__c where id in : ids];
        for(sirenum__Timesheet_Line__c tsl:tmshtLineList){
            plcIDs.add(tsl.sirenum__Shift__r.sirenum__Placement__c);
            if(tsl.sirenum__Shift__c != null && tsl.sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__r.IP_LastPassedToTempest__c == null){
                payMethodIDs.add(tsl.sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__c);
            }
            system.debug('dateTIme==> '+tsl.IP_LastPassedToTempest__c);
            /*if(tsl.IP_LastPassedToTempest__c !=null)
timeSheetIDsForTrue.add(tsl.sirenum__Timesheet__c);
else
timeSheetIDsForFalse.add(tsl.sirenum__Timesheet__c);*/
        }
        //update tmshtLineList;
        if(onCreate){
            List<sirenum__Placement__c> placementRecords = [select id,name,IP_LastPassedToTempest__c,IP_PassToTempest__c,sirenum__Contact__c,
                                                            IP_Consultant1LookupSplitShare__r.Name,IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c, 
                                                            IP_Consultant1LookupSplitShare__r.IP_TempestDivision__c,IP_Consultant1LookupSplitShare__r.IP_TempestID__c 
                                                            from sirenum__Placement__c where id in: plcIDs];
            for(sirenum__Placement__c plc: placementRecords){
                System.debug('testplacement--->'+placementRecords);
                if(plc.IP_LastPassedToTempest__c==null && plc.IP_Consultant1LookupSplitShare__r.Name!=null && plc.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c!=null && plc.IP_Consultant1LookupSplitShare__r.IP_TempestDivision__c!=null && plc.IP_Consultant1LookupSplitShare__r.IP_TempestID__c!=null){
                    System.debug('testplacement1--->'+plc.IP_Consultant1LookupSplitShare__r.Name);
                    System.debug('testplacement2--->'+plc.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c );
                    System.debug('testplacement3--->'+plc.IP_Consultant1LookupSplitShare__r.IP_TempestDivision__c );
                    System.debug('testplacement4--->'+plc.IP_Consultant1LookupSplitShare__r.IP_TempestID__c);
                    plc.IP_PassToTempest__c = true;
                    System.debug('testplacement5--->'+plc.IP_PassToTempest__c);
                    placementRecord.add(plc);
                }
            }
          //  update placementRecord;
            Database.SaveResult[] srList = Database.update(placementRecord,false);    
              for (integer i=0; i<srList.size();i++) 
            {
                String errMsgs = '';

                if(!srList[i].isSuccess())
                {
                    errorIds.add(placementRecord[i].Id);                   
                }
                for(Database.Error err : srList[i].getErrors())
                {
                    errMsgs = errMsgs + '  ' + err.getMessage();

                }
                
                errMessage.put(placementRecord[i].Id,errMsgs);
                errMsgs ='';     
            }
           
            if(!errorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                        
                    sendMail = true;
                }
            }
            
        }
        // System.debug('timeSheetIDsForTrue-->'+timeSheetIDsForTrue);
        // System.debug('timeSheetIDsForFalse-->'+timeSheetIDsForFalse);
        // List<sirenum__Timesheet__c> tmshtListTrue = [select id, name, Sync_Timesheet_Line__c from sirenum__Timesheet__c where id in: timeSheetIDsForTrue];
        //List<sirenum__Timesheet__c> tmshtListFalse = [select id, name, Sync_Timesheet_Line__c from sirenum__Timesheet__c where id in: timeSheetIDsForFalse];
        List<sirenum__Shift__c> shiftSync = [select id, name,Sync_Timesheet__c from sirenum__Shift__c where sirenum__Timesheet_summaries__c in : timeSheetIDsForTrue];
        List<IP_PayProfile__c> payProfileTempest = [select id, name,IP_PassToTempest__c from IP_PayProfile__c where id in : payMethodIDs];
        for(IP_PayProfile__c ppTemp: payProfileTempest)
        { ppTemp.IP_PassToTempest__c = true;}
        Database.update(payProfileTempest,false);   
        
        /*  for(sirenum__Timesheet__c syncTrue : tmshtListTrue)
syncTrue.Sync_Timesheet_Line__c = true;
for(sirenum__Timesheet__c syncFalse : tmshtListFalse)
syncFalse.Sync_Timesheet_Line__c = false;*/
        for(sirenum__Shift__c shiftSyncTrue : shiftSync)
            shiftSyncTrue.Sync_Timesheet__c = true;
        
        // System.debug('Timesheet True-->'+tmshtListTrue);
        // System.debug('Timesheet False-->'+tmshtListFalse);
        System.debug('Shifts False-->'+shiftSync);
        
        //update tmshtListTrue;
        // update tmshtListFalse;
         Database.update(shiftSync,false);   
        
        
        If(sendMail == true)
        {
          Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
      
            String subject ='Track S-placement pass to tempest';
            email.setSubject(subject);
           String[] toAddresses = new String[] {'tajinder.singh@espire.com'};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        
        
        if(!Test.isRunningTest()){
        System.enqueueJob(new QueableSplitTimesheetLine(ids,plcIDs));
        }
        
    }
}
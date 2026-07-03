global class Checkduplicatebatch extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{
global   List<sirenum__Timesheet__c> timesheet;
global   List<sirenum__Timesheet__c> timesheetlist = new List<sirenum__Timesheet__c>();
     global Database.QueryLocator start(Database.BatchableContext BC)
    {
     //   string query ='Select id,IP_StandardWeeklyNumberID__c,IP_Error__c,IP_ErrorDetail__c,IP_DuplicateCheckPassOK__c from  sirenum__Timesheet__c where IP_DuplicateCheckPassOK__c=false AND (IP_Error__c = FALSE OR (IP_Error__c = TRUE AND IP_ErrorDetail__c Like \'%unable to obtain exclusive access%\'  ) OR (IP_DuplicateCheckPassOK__c = TRUE AND  IP_ErrorDetail__c Like \'%unable to obtain exclusive access%\'  AND IP_FlaggingCheck__c = False) OR (IP_DuplicateCheckPassOK__c = TRUE AND  IP_ErrorDetail__c =\'\' AND IP_FlaggingCheck__c = False)) AND IP_StandardWeeklyNumberID__c!=null';
     
    string query ='Select id,IP_StandardWeeklyNumberID__c,IP_Error__c,IP_ErrorDetail__c,IP_DuplicateCheckPassOK__c from '+
    '  sirenum__Timesheet__c where (IP_DuplicateCheckPassOK__c=false OR (IP_DuplicateCheckPassOK__c = TRUE AND IP_Error__c = False '+
    ' AND IP_FlaggingCheck__c = False) OR (IP_DuplicateCheckPassOK__c = TRUE AND '+
    ' IP_ErrorDetail__c Like \'%unable to obtain exclusive access%\'  AND IP_FlaggingCheck__c = False) OR '+
 ' (IP_DuplicateCheckPassOK__c=false AND IP_Error__c = False AND IP_ErrorDetail__c Like \'%unable to obtain exclusive access%\'  )) AND IP_StandardWeeklyNumberID__c!=null';
    System.debug('query11111111 '  +  query);
      return Database.getQueryLocator(query);
        
    }
    
     global void execute(Database.BatchableContext BC, List<sirenum__Timesheet__c> scope) 
    { 
           Database.SaveResult[] srList;
         String key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String payrollnumber;
        String subtext;
        string searchtext;
        String subtimenumber;
        if(scope[0].IP_StandardWeeklyNumberID__c!=null)
        {
         
             payrollnumber=scope[0].IP_StandardWeeklyNumberID__c;
        }
        if(payrollnumber!=null)
        {
           
            System.debug('payrollnumber '+payrollnumber + ' '  +  scope[0].IP_DuplicateCheckPassOK__c);
              subtext = payrollnumber;
            subtimenumber=payrollnumber.substring(0, 10);
            searchtext = subtimenumber +'%';
               timesheet =  [Select id,IP_Error__c,IP_ErrorDetail__c,IP_StandardWeeklyNumberID__c,IP_DuplicateCheckPassOK__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c = : payrollnumber];
System.debug('list check'+timesheet);
           List<sirenum__Timesheet__c> uniqtime =  [Select id,IP_StandardWeeklyNumberID__c,IP_DuplicateCheckPassOK__c from sirenum__Timesheet__c where IP_StandardWeeklyNumberID__c Like : searchtext 
 ORDER BY IP_StandardWeeklyNumberID__c DESC limit 1];
            String uniqnumber;
            String lastletter;
            String lastchar;
            if(uniqtime.size()>0)
            {
                system.debug(uniqtime);
                uniqnumber = uniqtime[0].IP_StandardWeeklyNumberID__c;
                 System.debug('uniqnumber '+uniqnumber);
                 Integer size = uniqnumber.length()-2;
                lastletter = uniqnumber.substring(size, uniqnumber.length()-1);
                System.debug('lastletter '+lastletter);
            }
        
            if(timesheet.size()>1)
            {
                for(Integer i=0;i<timesheet.size();i++)
                {
                    If(timesheet[i].IP_DuplicateCheckPassOK__c==false)
                    {
                      Integer size = payrollnumber.length()-2;
                      system.debug('@@size '+size);
                      Integer index = key.indexOf(lastletter);
                      system.debug('@@index '+index);
                      String abc = key.substring(index+1+i, index+2+i);     
                      
                      system.debug('@@ '+abc);
                      payrollnumber =subtext.substring(0,size);
                      lastchar = subtext.substring(size+1,size+2);
                      system.debug('lastchar '+lastchar);
                      payrollnumber +=abc + lastchar;
                      system.debug('payrollnumber '+payrollnumber);
                     
                      timesheet[i].IP_StandardWeeklyNumberID__c=payrollnumber;
                      timesheet[i].IP_DuplicateCheckPassOK__c = True;
                    }
                }
               
              
            }
          else
          {
              if(timesheet.size()>0)
              {
              timesheet[0].IP_DuplicateCheckPassOK__c = True;
              }
          }
              srlist = Database.update(timesheet,true);   
         if (srlist[0].isSuccess()) {
                      System.debug('Successfully updated ');
             timesheetlist.addAll(timesheet);
            } 
           
            else {
                        for(Database.Error err : srlist[0].getErrors()) {
                        timesheet[0].IP_Error__c = TRUE;
                        timesheet[0].IP_ErrorDetail__c = 'Failed to check duplicate pass';
                         timesheet[0].IP_DuplicateCheckPassOK__c = False;
                        }
                update timesheet;
                       
            }       
                      
                  
        
        }
        
    
    }
        
        
        
    
    
     global void finish(Database.BatchableContext BC)
    {    
        /* system.debug('timesheetlist ## '+timesheetlist);
        Database.executeBatch(new Timesheetflagging(timesheetlist),5);*/
        super.finishBatch(BC);
    }
    
}
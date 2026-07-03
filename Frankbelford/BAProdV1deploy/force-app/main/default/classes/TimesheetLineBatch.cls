global class TimesheetLineBatch implements Database.Batchable<sObject>,Database.Stateful{

   global final String Query;
   global final String Field1;
   global final String Field2;
   global final String GUID;
    global boolean sendMail = false;
      List<id> lockrow1 = new List<id>();
    List<id> lockrow2 = new List<id>();
   global String errorFile = 'Id,Error\n';

      global TimesheetLineBatch(String q, String f1, String f2,String gd){
             Query=q;Field1=f1;Field2=f2;GUID=gd;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   
     global void execute(Database.BatchableContext BC, 
                        List<sirenum__Timesheet_Line__c> scope){
       Map<id,String> errMessage = new Map<id,String>();
    List<Id> errorIds = new List<Id>();
        List<Id> terrorIds = new List<Id>();
List<IP_OutboundDataTransfer__c> outboundList = new List<IP_OutboundDataTransfer__c>();
         Map<id,String> terrMessage = new Map<id,String>();
            Set<ID> timeId = new Set<ID>();
      for(sirenum__Timesheet_Line__c timeline : scope)
      {
            /* s.put(Field1,False); 
          s.put(Field2,System.now());
          s.put(Field3,False);*/
     
          timeline.IP_PassToTempest__c=false;
          timeline.IP_LastPassedToTempest__c=System.now();
          timeId.add(timeline.sirenum__Timesheet__c);
          
          boolean testRunning=true;
          if(Test.isRunningTest() && testRunning)
          {
               testRunning = false;
               timeline.id = null;
                                    
          }
          system.debug('@@ Site time method '+timeline.sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c);
          if(timeline.sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c == 'eTimesheet')
          {
               IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
              
              ob.IP_TimsheetID__c = timeline.IP_PayrollPresentedTimesheetNumber__c;
              ob.IP_OriginRecordID__c = timeline.Name;
              ob.IP_RowCount__c = timeline.sirenum__Timesheet__r.sirenum__Lines__c; 
              ob.IP_CandidateName__c = timeline.sirenum__Timesheet__r.sirenum__Worker__r.name;
              string workerpayroll = timeline.sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c;
              ob.IP_CandidateID__c = workerpayroll.abbreviate(10);
              ob.IP_ClientName__c = timeline.sirenum__Timesheet__r.sirenum__Client__r.Name;
              ob.IP_SiteName__c  = timeline.sirenum__Timesheet__r.sirenum__Site__r.Name;
              ob.IP_WeekendingDate__c = timeline.sirenum__Timesheet__r.sirenum__Week_Ending__c;
              string assignment = timeline.sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c;
              ob.IP_AssignmentNumber__c = assignment.abbreviate(10);
              ob.IP_PO__c = timeline.IP_PurchaseOrderNumber__c;
              ob.IP_Date__c = timeline.sirenum__Date__c;
              ob.IP_RateCode__c = timeline.IP_EdiRateCode__c;
              ob.IP_Passed__c = 'PASSING';
              if(timeline.sirenum__Overtime_Rate__c == True)
              {
                  ob.IP_RateDescription__c = 'Overtime Hours';
              }
              else if(timeline.IP_RateCodes__c != null)
              {
                  String RCode = timeline.IP_RateCodes__c;
                  List<String> rate = RCode.split('/');
                 ob.IP_RateDescription__c = rate[0];
              }
              else{
                 ob.IP_RateDescription__c = timeline.sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c;
              }
              ob.IP_Unit__c = timeline.sirenum__Hours__c;
              ob.IP_ApprovalStamp__c = timeline.sirenum__Shift__r.Approved_By__r.Name +' '+timeline.sirenum__Shift__r.Approved_Date_Time__c; 
              ob.IP_TransferType__c = 'TimesheetLineData';
         outboundList.add(ob);
          }
          
      }      
         List<sirenum__Timesheet__c> timesheet =[Select id, IP_EmergencyPull__c from sirenum__Timesheet__c where id in : timeId and IP_EmergencyPull__c = TRUE];                  
     If(timesheet.size()>0)
     {
     System.debug('Inside Timesheet IF');
     for(sirenum__Timesheet__c tm : timesheet)
     {
         tm.IP_EmergencyPull__c=false;
         
     }
     }
          Database.SaveResult[] srList1 = Database.update(timesheet,false);                   
         
       Database.SaveResult[] srList = Database.update(scope,false);       
     
     Database.SaveResult[] srList2 = Database.insert(outboundList,false); 
   

         for (integer i=0; i<srList.size();i++) 
            {
                String errMsgs = '';

                if(!srList[i].isSuccess())
                {
                    errorIds.add(scope[i].Id);                   
                }
                for(Database.Error err : srList[i].getErrors())
                {
                     errMsgs = errMsgs + '  ' + err.getMessage();
                     if(errMsgs.contains('unable to obtain exclusive access'))
                   {
                       lockrow1.add(srList[i].id);
                   }
                /*   else
                   {
                   errMsgs = errMsgs + '  ' + err.getMessage();
                   }*/


                }
                
                errMessage.put(scope[i].Id,errMsgs);
                errMsgs ='';     
            }
           
              for (integer i=0; i<srList1.size();i++) 
            {
                String errMsgs = '';

                if(!srList1[i].isSuccess())
                {
                    terrorIds.add(scope[i].sirenum__Timesheet__c);                   
                }
                for(Database.Error err : srList1[i].getErrors())
                {
                   errMsgs = errMsgs + '  ' + err.getMessage();
                    if(errMsgs.contains('unable to obtain exclusive access'))
                   {
                       lockrow2.add(srList1[i].id);
                   }
                 /*  else
                   {
                   errMsgs = errMsgs + '  ' + err.getMessage();
                   }*/

                }
                
                terrMessage.put(scope[i].sirenum__Timesheet__c,errMsgs);
                errMsgs ='';     
            }
           
           if(!errorIds.IsEmpty() || !terrorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                        
                    sendMail = true;
                }
                for(integer i=0;i<terrorIds.size();i++)
                {
                    errorFile = errorFile + terrorIds[i]+','+ terrMessage.get(terrorIds[i]) + ',' +'\n';                        
                    sendMail = true;
                }
            } 
   }

   global void finish(Database.BatchableContext BC){
 if(sendMail == true)
        {
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
         /*   List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='API Batch Failure - Timesheet Line';
            email.setSubject(subject);
           String[] toAddresses = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }  
     if(lockrow1.size()>0)
        {
            List<sirenum__Timesheet_line__c> updatetl= [Select id,IP_PassToTempest__c,IP_LastPassedToTempest__c from sirenum__Timesheet_line__c where id in: lockrow1];
            for(sirenum__Timesheet_line__c tl: updatetl)
            {
                tl.IP_PassToTempest__c = false;
                tl.IP_LastPassedToTempest__c=System.now();
            }
            Database.update(updatetl,false);
        }
        if(lockrow2.size()>0)
        {
            List<sirenum__Timesheet__c> updatet2= [Select id,IP_EmergencyPull__c from sirenum__Timesheet__c where id in: lockrow2];
            for(sirenum__Timesheet__c tl: updatet2)
            {
                tl.IP_EmergencyPull__c = false;
            }
            Database.update(updatet2,false);
        }
   }        
   

}
public class QueableSplitTimesheetLine implements Queueable {
    public boolean sendMail = false; 
    List<sirenum__Timesheet_Line__c> tmshtLineList;
    List<sirenum__Timesheet_Line__c> clonetmshtLine1;
    List<sirenum__Timesheet_Line__c> clonetmshtLine2;
    List<sirenum__AWR__c> AWR;
    String errorFile = 'Id,Error\n'; 
    Map<id,String> errMessage = new Map<id,String>();
    Boolean isPresent;
      Boolean isPresentelse;
    Set<ID> ids;
    Set<ID> plcIDs;
    String a;
     String a1;
    String substring;
    String substring1;
    Double Hours;
    Double Hours1;
    public QueableSplitTimesheetLine(Set<ID> ids){ 
        this.ids = ids; 
     // this.plcIDs = plcIDs;
    }
    
    public void execute(QueueableContext context){
        
       List<sirenum__Timesheet_Line__c> tmshtLineList=[Select id, IP_RateCodes__c,sirenum__Hours__c,sirenum__Cost_Matrix__c,sirenum__Timesheet__c,sirenum__Shift__c, sirenum__Description__c,
                                                        sirenum__Rate__c,sirenum__Charge__c,sirenum__Shift__r.sirenum__Team__r.IP_PercentageCharge__c,sirenum__Date__c,
                                                        sirenum__Shift__r.sirenum__Team__r.sirenum__AWR_Group__c,sirenum__Shift__r.sirenum__Contact__c,  sirenum__Shift__r.sirenum__Site__r.sirenum__Operating_Company__c,
                                                        sirenum__Shift__r.sirenum__Site__r.IP_InUsePreAWRWTRValue__c,sirenum__Shift__r.sirenum__Site__r.IP_InUsePostAWRWTRValue__c,
                                                        sirenum__Shift__r.sirenum__Team__r.IP_Fixed__c,IP_SplitTimesheetLine__c,sirenum__Shift__r.sirenum__Placement__c,IP_PayrollPresentedRateCode__c 
                                                        from sirenum__Timesheet_Line__c where IP_SplitTimesheetLine__c=false and sirenum__Shift__r.sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c!='Standard' and Adhoc_Formula__c = 'N' and ID in:ids];
        
        List<sirenum__Timesheet_Line__c> clonetmshtLine1= tmshtLineList.deepclone(false);
        
        
        
        for(sirenum__Timesheet_Line__c  tslFirstCloneIterator:clonetmshtLine1){
     		System.debug('tslFirstCloneIterator:::'+JSON.serialize(tslFirstCloneIterator)+'??'+tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_Fixed__c+'??'+tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_PercentageCharge__c);
            if(tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_Fixed__c!=null){
                //tslFirstCloneIterator.sirenum__Charge__c= (tslFirstCloneIterator.sirenum__Hours__c * tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_Fixed__c);
                tslFirstCloneIterator.sirenum__Charge__c=tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_Fixed__c;
                tslFirstCloneIterator.IP_RateCodes__c='Separated Charge /CM';
            } 
            else if (tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_PercentageCharge__c!=null){
               tslFirstCloneIterator.sirenum__Hours__c= (tslFirstCloneIterator.sirenum__Hours__c * tslFirstCloneIterator.sirenum__Rate__c * (tslFirstCloneIterator.sirenum__Shift__r.sirenum__Team__r.IP_PercentageCharge__c * 0.01));     
                tslFirstCloneIterator.IP_RateCodes__c='Separated Charge /PR';
                tslFirstCloneIterator.sirenum__Charge__c=1;
            } 
            
            
            tslFirstCloneIterator.sirenum__Cost_Matrix__c= null;
            tslFirstCloneIterator.sirenum__Code__c='';
            tslFirstCloneIterator.sirenum__Rate__c=0;
            tslFirstCloneIterator.IP_SplitTimesheetLine__c=true;
            
        }
        
      // insert clonetmshtLine1;
    //   System.debug('Insert1' + clonetmshtLine1);
    //sirenum__Timesheet_Line__c clonedSheet = [SELECT sirenum__Cost_Matrix__c,sirenum__Code__c,IP_RateCodes__c,For_BatchClass__c from sirenum__Timesheet_Line__c where id =:clonetmshtLine1[0].id]; 
        //System.debug('tslFirstCloneIterator values:::'+clonedSheet.sirenum__Cost_Matrix__c+'??'+clonedSheet.sirenum__Code__c+'??'+clonedSheet.IP_RateCodes__c+'??'+clonedSheet.For_BatchClass__c);
         Database.SaveResult[] srList = Database.insert(clonetmshtLine1, false);
      //  System.debug('Value in List1---->' + srList);
         List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(clonetmshtLine1[i].id);
                    }
                    else
                    {
                        errorIds.add(clonetmshtLine1[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(clonetmshtLine1[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(!errorIds.isEmpty())
           //return new ResponseClass('true', 'Query executed successfully.',tsData);     
           
            {
            for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';
                 }
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();    
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='Clonning Failure - Timesheet';
            email.setSubject(subject);
                String[] toAddress = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
          // return new ResponseClass('false', 'Error in querying records',null);     
            }
        
        
        set<String> awrgroup = new set<String>();
        Boolean check= false;
        
         List<sirenum__AWR__c> awrlist = [select id, sirenum__AWR_Group__c, sirenum__Valid_From__c,sirenum__Client__c,sirenum__Contact__c,sirenum__AWR_Eligible__c from
                                          sirenum__AWR__c where sirenum__AWR_Eligible__c=true ];
        
       
        
        List<sirenum__Timesheet_Line__c> clonetmshtLine2 =tmshtLineList.deepclone(false);
        
         for(sirenum__AWR__c awr : awrlist)
        {
              for(sirenum__Timesheet_Line__c timline3:clonetmshtLine2)
              {
                  If(awr.sirenum__Client__c==timline3.sirenum__Shift__r.sirenum__Site__r.sirenum__Operating_Company__c && awr.sirenum__Contact__c == timline3.sirenum__Shift__r.sirenum__Contact__c && awr.sirenum__AWR_Group__c == timline3.sirenum__Shift__r.sirenum__Team__r.sirenum__AWR_Group__c 
                    && awr.sirenum__Valid_From__c<=timline3.sirenum__Date__c)
                  {
                      
                      check=true;
                  }
                  
              }
            
        }
        
        
      Impellam_Settings__c impset = Impellam_Settings__c.getValues('DefaultNIPercentage');   
    
                for(sirenum__Timesheet_Line__c timline3:clonetmshtLine2)
                {  
                  if(check==true)
                    { 
                       System.debug('Value in IF----->' + timline3.sirenum__Hours__c * timline3.sirenum__Rate__c* timline3.sirenum__Shift__r.sirenum__Site__r.IP_InUsePostAWRWTRValue__c *(1+impset.IP_DefaultNIPercentage__c));
                       Hours = (timline3.sirenum__Hours__c *timline3.sirenum__Rate__c* (timline3.sirenum__Shift__r.sirenum__Site__r.IP_InUsePostAWRWTRValue__c) *0.01 *(1+(impset.IP_DefaultNIPercentage__c *0.01))).setScale(2); 
                        System.debug('Value in Hours' + Hours);
                       /* a= string.valueOf(Hours);
                        System.debug('Valu--->' + a);
                        substring = a.substring(0,4);
                        System.debug('Value in sub string--->' + substring);*/
                        timline3.sirenum__Hours__c= Hours;
                       
                        
                    }
                    else
                    { 
                       System.debug('Value in IF----->' + timline3.sirenum__Hours__c);
                       System.debug('timline3.sirenum__Rate__c:::'+  timline3.sirenum__Rate__c+'??');
                        System.debug(' timline3.sirenum__Shift__r.sirenum__Site__r.IP_InUsePostAWRWTRValue__c::'+ timline3.sirenum__Shift__r.sirenum__Site__r.IP_InUsePostAWRWTRValue__c);
                        System.debug('impset:::'+impset.IP_DefaultNIPercentage__c);
                       System.debug('Value in Else---->' + timline3.sirenum__Hours__c *timline3.sirenum__Rate__c * timline3.sirenum__Shift__r.sirenum__Site__r.IP_InUsePreAWRWTRValue__c *(1+impset.IP_DefaultNIPercentage__c));
                       Hours1= (timline3.sirenum__Hours__c * timline3.sirenum__Rate__c * (timline3.sirenum__Shift__r.sirenum__Site__r.IP_InUsePreAWRWTRValue__c)*0.01 *(1+(impset.IP_DefaultNIPercentage__c  * 0.01))).setScale(2) ;
                        /*a1= string.valueOf(Hours1);
                        System.debug('Value in Hours1--->' + a1);
                        substring1= a1.substring(0,4);
                        System.debug('Value in sub string1 in pre--->' + substring1);*/
                        
                        //timline3.sirenum__Hours__c= double.valueOf(substring1);
                       timline3.sirenum__Hours__c= Hours1;
                        
                    } 

                }
              
         for(sirenum__Timesheet_Line__c timline3:clonetmshtLine2){
            
            timline3.sirenum__Charge__c=1;
            timline3.sirenum__Cost_Matrix__c= null;
            timline3.sirenum__Code__c='';
            timline3.IP_RateCodes__c='Holiday Accrual /HA';
            timline3.sirenum__Rate__c=0;
            timline3.IP_SplitTimesheetLine__c=true;
           // timline3.Isclone__c=true;
        }
        
        
       //insert clonetmshtLine2;
      //system.debug('Insert 2 clone'+ clonetmshtLine2);  
      
        Database.SaveResult[] srList1 = Database.insert(clonetmshtLine2, false);
       // System.debug('Value in List2---->' + srList1);
         List<id> errorIds1 = new List<id>();
                 List<id> successIds1 = new List<id>();
                for (integer i=0; i<srList1.size();i++) 
                {
                     String errMsgs = '';
                    if(srList1[i].isSuccess())
                    {
                        successIds1.add(clonetmshtLine2[i].id);
                    }
                    else
                    {
                        errorIds1.add(clonetmshtLine2[i].id);
                        for(Database.Error err : srList1[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(clonetmshtLine2[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(!errorIds1.isEmpty())
           //return new ResponseClass('true', 'Query executed successfully.',tsData);     
           
            {
            for(integer i=0;i<errorIds1.size();i++)
                {
                    errorFile = errorFile + errorIds1[i]+','+ errMessage.get(errorIds1[i]) + ',' +'\n';
                 }
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();    
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='Clonning Failure - Timesheet';
            email.setSubject(subject);
                String[] toAddress = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
          // return new ResponseClass('false', 'Error in querying records',null);     
            }
         
        
        
        
        List<sirenum__Timesheet_Line__c> tslList = new List<sirenum__Timesheet_Line__c>();
        for(sirenum__Timesheet_Line__c tsl: tmshtLineList)
        {
            tsl.IP_SplitTimesheetLine__c=TRUE;
            tslList.add(tsl);
        }
        try
        {
            update tslList;
        }
        catch(Exception ex){
            system.debug('update standard time sheet-'+ex);
        }
    
    
       
        
    }
    
}
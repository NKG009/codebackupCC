public class Placementprocessupdate {
    public static Boolean sendMail = false;

    public static void senddata(Set<id> placementid){
    Set<String> branchset = new Set<String>();
    String errorFile = 'Id,Error\n';
    Map<id,String> errMessage = new Map<id,String>();
    Map<id,String> errMessage1 = new Map<id,String>();
    List<Id> errorIds = new List<Id>();
    List<Id> errorIds1 = new List<Id>();
   	IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
    IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
    List<IP_OutboundDataTransfer__c> outboundList = new List<IP_OutboundDataTransfer__c>();
    List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];
    for(IP_BranchStatus__c b:branchlist)
    {
        branchset.add(b.IP_BranchID__c);
    }
    List<TR1__Closing_Report__c> placelist = [Select id,IP_PassToTempest__c,IP_LastPassedToTempest__c,IP_TempestDivision__c,IP_TempestDepartment__c,IP_ClientIDLegacy__c,Candidate_First_Name__c,Candidate_Last_Name__c, TR1__Start_Date__c,Sirenum_Job_Role__c,TR1__Salary__c,IP_Fixed_Fee__c,Fee_Pct__c,Contact_Name__c,Status_PO_Number__c,Filled_By__r.IP_TempestID__c,Filled_Pct__c,Filled_By_2__r.IP_TempestID__c,Filled_Pct_2__c,IP_Department__c,IP_PermID__c,IP_Amount_to_Credit__c,IP_Credit_Indicator__c,IP_Reason_for_Credit_Code__c,IP_Reference_to_Tempest__c FROM TR1__Closing_Report__c  where IP_TempestDepartment__c in:branchset and id in:placementid and (RecordType.DeveloperName ='Perm'OR RecordType.Name = 'Perm Credits') ];
    System.debug('Placement list'+placelist);
    for(TR1__Closing_Report__c pl : placelist)
    {
         if(!paycheck.Run_Parallel_Payroll__c)
        {
        pl.IP_PassToTempest__c = false;
        pl.IP_LastPassedToTempest__c = System.now();
        }
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
        ob.IP_Tempest_Department__c = pl.IP_TempestDepartment__c;
        ob.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
        ob.IP_First_Name__c = pl.Candidate_First_Name__c;
        ob.IP_Last_Name__c = pl.Candidate_Last_Name__c;
        ob.IP_PermPlacementStart_Date__c = pl.TR1__Start_Date__c;
        ob.IP_JobRole_Name__c = pl.Sirenum_Job_Role__c;
        ob.IP_Salary__c = String.valueOf(pl.TR1__Salary__c);
        ob.IP_Invoice_Fee_Value__c = String.valueOf(pl.IP_Fixed_Fee__c);
        ob.IP_Fee_Pct__c = String.valueOf(pl.Fee_Pct__c);
        ob.IP_Invoice_ContactName__c = pl.Contact_Name__c;
        ob.IP_Invoice_PO_Number__c = pl.Status_PO_Number__c;
        ob.IP_Consultants_Tempest_ID__c = pl.Filled_By__r.IP_TempestID__c;
        ob.IP_Filled_Pct__c = String.valueOf(pl.Filled_Pct__c);
        ob.IP_Filled_By2_Tempest_ID__c = pl.Filled_By_2__r.IP_TempestID__c;
        ob.IP_Filled_Pct_2__c = String.valueOf(pl.Filled_Pct_2__c);
        ob.IP_Department__c = pl.IP_Department__c;
        ob.IP_Perm_ID__c = pl.IP_PermID__c;
        ob.IP_Passed__c = 'PASSING';
        ob.IP_Amount_to_Credit__c = String.valueOf(pl.IP_Amount_to_Credit__c);
        ob.IP_Credit_Indicator__c = pl.IP_Credit_Indicator__c;
        ob.IP_Reason_for_Credit_Code__c = String.valueOf(pl.IP_Reason_for_Credit_Code__c);
        ob.IP_Reference_to_Tempest__c = pl.IP_Reference_to_Tempest__c ;
         ob.IP_OriginRecordID__c = pl.id;
         // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        ob.IP_TransferType__c = 'Placement';
        outboundList.add(ob);
    }
    Database.SaveResult[] srList1 = database.insert(outboundList,false);
     for (integer i=0; i<srList1.size();i++) 
                {      String errMsgs = '';
                    if(!srList1[i].isSuccess())
                    {
                        errorIds1.add(srList1[i].id);
                    }
                    for(Database.Error err : srList1[i].getErrors())
                        {    errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage1.put(srList1[i].Id,errMsgs);                errMsgs ='';                            
                }
        if(!errorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                {    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                       sendMail = true;                    
                }
            } 
            else
            {
    Database.SaveResult[] srList = database.update(placelist,false);
     for (integer i=0; i<srList.size();i++) 
                {    String errMsgs = '';
                    if(!srList[i].isSuccess())
                    {
                        errorIds.add(srList[i].id);
                    }
                    for(Database.Error err : srList[i].getErrors())
                        {   errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage.put(srList[i].Id,errMsgs);                errMsgs ='';                            
                }
               
        if(!errorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                { errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                     sendMail = true;                    
                }
            } 
            }
         String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
         if(sendMail == true)
         {
             Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);              errAtt.setFileName('Placement Failed_Records.csv');            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Placement - Outbound Transfer Failure';            email.setSubject(subject);         String[] toAddresses = new String[]{emailid};
            email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         }
    }
}
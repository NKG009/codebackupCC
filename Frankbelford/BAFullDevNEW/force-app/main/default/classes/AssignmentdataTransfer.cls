public class AssignmentdataTransfer {
    
    public static String YES_VALUE = 'Yes';
    public static String NO_VALUE = 'No';
    
    public static void sendemergencydata(Set<id> emergencyset){
     IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
        Set<String> branchset = new Set<String>();
        boolean checkpassed = false;
        String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
        String errorFile = 'Id,Error\n';        
        Map<id,String> errMessage = new Map<id,String>();
        Map<id,String> errMessage1 = new Map<id,String>();
        Map<id,String> errMessage2 = new Map<id,String>();
        List<Id> errorIds = new List<Id>();
        List<Id> errorIds1 = new List<Id>();
        List<Id> errorIds2 = new List<Id>();
        Boolean sendMail = false;
            List<IP_OutboundDataTransfer__c> outboundList = new List<IP_OutboundDataTransfer__c>();
            List<IP_OutboundDataTransfer__c> updateoutboundlistemergency = new List<IP_OutboundDataTransfer__c>();
             IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
           List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];

        for(IP_BranchStatus__c b:branchlist)
        {
            branchset.add(b.IP_BranchID__c);
        }
        
        List<PermissionSetAssignment> checkpermission =  [SELECT Id, PermissionSet.Name,AssigneeId
                                                                    FROM PermissionSetAssignment
                                                                    WHERE AssigneeId = :Userinfo.getUserId()]; 
                                                                    
       system.debug('check permission'+checkpermission);
        if(checkpermission.size()>0)
        {
            for(PermissionSetAssignment ps:checkpermission)
            {
                if(ps.PermissionSet.Name == 'Emergency_Payroll')
                {
                    checkpassed = true;
                }
            }
        }
                                                                      
        List<sirenum__Placement__c> assignlist = [select id,sirenum__Site__r.IP_TempestDepartment__c,IP_TimesheetIDLink__c,IP_FirstPass__c,IP_AssignmentRefForTempest__c,IP_AWRCoreCat__c, IP_AWRJobCat__c,IP_ClientIDLegacy__c,IP_Consultant1IDnumberSplitShare__c, IP_PassToTempest__c,IP_EmergencyPull__c, IP_LastPassedToTempest__c,IP_Consultant1PercentageSplit__c, IP_Consultant2IDnumberSplitShare__c,IP_Consultant2PercentageSplit__c, IP_TempestDepartment__c,IP_TempestDivision__c,IP_LookUpOfHolidayEntitlement__c,Adhoc_Formula__c,IP_WorkerPayrollRef__c,IP_PurchaseOrderNumber__c,sirenum__End_Date__c, Sirenum__Job_Role__r.sirenum__Job_Type__r.Name,Sirenum__Site__r.IP_Public_Sector__c,Sirenum__Site__r.Name, Sirenum__Site__r.IP_InvoiceContactText__c,Sirenum__Site__r.IP_MainContact__r.Name,sirenum__Site__r.sirenum__Postal_Code__c,sirenum__Start_Date__c,OPWIPS__c,IP_Department__c from sirenum__Placement__c where IP_EmergencyPull__c=true and IP_Department__c in:branchset and id in:emergencyset];
        
        List<IP_OutboundDataTransfer__c> existingemergencyrec = [Select id,IP_OriginRecordID__c,IP_TimesheetID__c from IP_OutboundDataTransfer__c where IP_OriginRecordID__c in: emergencyset and IP_Passed__c = ''];
        
        if(existingemergencyrec.size()>0)
        {
       for(sirenum__Placement__c pl : assignlist)
        {
            for(IP_OutboundDataTransfer__c oexists :existingemergencyrec)
            {
                if(oexists.IP_OriginRecordID__c == pl.id)
                {
            if(!paycheck.Run_Parallel_Payroll__c)
            {
            pl.IP_PassToTempest__c = false;       
           // pl.IP_LastPassedToTempest__c = System.now();
            pl.IP_EmergencyPull__c = false;
            }
            if(pl.IP_FirstPass__c == TRUE)
            {
                pl.IP_FirstPass__c = false;
            }
            IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
            ob.id = oexists.id;
            if(checkpassed == true)
            {
                ob.IP_Passed__c = 'PASSING';
                if(!paycheck.Run_Parallel_Payroll__c)
                {
                    pl.IP_LastPassedToTempest__c = System.now();
                }
            }
            ob.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
                    if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob.IP_RateFrequency__c = 'H';
        ob.IP_Standard_Occupation_Code__c = '';
        ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
        ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob.IP_RateFrequency__c = '<IGNORE>';
        ob.IP_Standard_Occupation_Code__c = pl.IP_AWRJobCat__c;
        ob.IP_Lookup_of_holiday_entitlement__c = '<IGNORE>';
        ob.IP_Adhoc_Formula__c = 'N';
        }
            ob.IP_Tempest_Department__c = pl.IP_TempestDepartment__c; 
            ob.IP_AssignmentRef__c= pl.IP_AssignmentRefForTempest__c;
            ob.IP_AWR_Job_Cat__c = pl.IP_AWRJobCat__c;
            ob.IP_AWR_Core_Cat__c = pl.IP_AWRCoreCat__c;
            ob.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
            ob.IP_Consultant_1_ID_number__c = pl.IP_Consultant1IDnumberSplitShare__c;
            ob.IP_Commission_Split__c = String.valueOf(pl.IP_Consultant1PercentageSplit__c);
            ob.IP_Consultant_2_ID_number__c = pl.IP_Consultant2IDnumberSplitShare__c;
            ob.IP_Consultant_2_Percentage_Split__c = String.valueOf(pl.IP_Consultant2PercentageSplit__c);
            //ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
           // ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
            ob.IP_WorkerPayroll_Ref__c = pl.IP_WorkerPayrollRef__c;
            ob.IP_Invoice_PO_Number__c = pl.IP_PurchaseOrderNumber__c;
            ob.IP_Placement_End_Date__c = pl.sirenum__End_Date__c;
            ob.IP_Job_Type_Name__c = pl.Sirenum__Job_Role__r.sirenum__Job_Type__r.Name;
            ob.IP_SiteName__c = pl.Sirenum__Site__r.Name;
            ob.IP_Invoice_ContactName__c = pl.Sirenum__Site__r.IP_InvoiceContactText__c;
            ob.IP_Main_ContactName__c = pl.Sirenum__Site__r.IP_MainContact__r.Name;
            ob.IP_Postal_Code__c = pl.sirenum__Site__r.sirenum__Postal_Code__c;
            ob.IP_Placement_Start_Date__c = pl.sirenum__Start_Date__c;
            if(NO_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                ob.IP_Public_Sector_Placement__c = 'N';
            }
            else if(YES_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
            }
            // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
              //ob.IP_Department__c = pl.IP_Department__c; changed for JPC 2459
        IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(pl.sirenum__Site__r.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
            ob.IP_OriginRecordID__c = pl.id;
            ob.IP_TransferType__c = 'Assignment';
            ob.IP_EmergencyPull__c = TRUE;
             ob.IP_TimesheetID__c = pl.IP_TimesheetIDLink__c;
            updateoutboundlistemergency.add(ob);
            }
            }
        }
        }
        else
        {
            for(sirenum__Placement__c pl : assignlist)
            {
                if(!paycheck.Run_Parallel_Payroll__c)
            {
            pl.IP_PassToTempest__c = false;       
           // pl.IP_LastPassedToTempest__c = System.now();
            pl.IP_EmergencyPull__c = false;
            }
             if(pl.IP_FirstPass__c == TRUE)
            {
                pl.IP_FirstPass__c = false;
            }
            IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
            if(checkpassed == true)
            {
                ob.IP_Passed__c = 'PASSING';
                if(!paycheck.Run_Parallel_Payroll__c)
                {
                    pl.IP_LastPassedToTempest__c = System.now();
                }
            }
            ob.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
                if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob.IP_RateFrequency__c = 'H';
        ob.IP_Standard_Occupation_Code__c = '';
        ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
        ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob.IP_RateFrequency__c = '<IGNORE>';
        ob.IP_Standard_Occupation_Code__c = pl.IP_AWRJobCat__c;
        ob.IP_Lookup_of_holiday_entitlement__c = '<IGNORE>';
        ob.IP_Adhoc_Formula__c ='N';
        }
            ob.IP_Tempest_Department__c = pl.IP_TempestDepartment__c; 
            ob.IP_AssignmentRef__c= pl.IP_AssignmentRefForTempest__c;
            ob.IP_AWR_Job_Cat__c = pl.IP_AWRJobCat__c;
            ob.IP_AWR_Core_Cat__c = pl.IP_AWRCoreCat__c;
            ob.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
            ob.IP_Consultant_1_ID_number__c = pl.IP_Consultant1IDnumberSplitShare__c;
            ob.IP_Commission_Split__c = String.valueOf(pl.IP_Consultant1PercentageSplit__c);
            ob.IP_Consultant_2_ID_number__c = pl.IP_Consultant2IDnumberSplitShare__c;
            ob.IP_Consultant_2_Percentage_Split__c = String.valueOf(pl.IP_Consultant2PercentageSplit__c);
          //  ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
           // ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
            ob.IP_WorkerPayroll_Ref__c = pl.IP_WorkerPayrollRef__c;
            ob.IP_Invoice_PO_Number__c = pl.IP_PurchaseOrderNumber__c;
            ob.IP_Placement_End_Date__c = pl.sirenum__End_Date__c;
            ob.IP_Job_Type_Name__c = pl.Sirenum__Job_Role__r.sirenum__Job_Type__r.Name;
            ob.IP_SiteName__c = pl.Sirenum__Site__r.Name;
            ob.IP_Invoice_ContactName__c = pl.Sirenum__Site__r.IP_InvoiceContactText__c;
            ob.IP_Main_ContactName__c = pl.Sirenum__Site__r.IP_MainContact__r.Name;
            ob.IP_Postal_Code__c = pl.sirenum__Site__r.sirenum__Postal_Code__c;
            ob.IP_Placement_Start_Date__c = pl.sirenum__Start_Date__c;
            //ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
            if(NO_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                ob.IP_Public_Sector_Placement__c = 'N';
            }
            else if(YES_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
            }
                   //ob.IP_Department__c = pl.IP_Department__c; changed for JPC 2459
        IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(pl.sirenum__Site__r.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
            ob.IP_OriginRecordID__c = pl.id;
                //ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
 
            ob.IP_TransferType__c = 'Assignment';
            ob.IP_EmergencyPull__c = TRUE;
             ob.IP_TimesheetID__c = pl.IP_TimesheetIDLink__c;
            outboundList.add(ob);
            }
            
        }
          if(updateoutboundlistemergency.size()>0)
        {
            Database.SaveResult[] srList2 = database.update(updateoutboundlistemergency,false);
                  for (integer i=0; i<srList2.size();i++) 
                    {                     String errMsgs = '';                    if(!srList2[i].isSuccess())
                        {
                            errorIds2.add(srList2[i].id);
                        }
                        for(Database.Error err : srList2[i].getErrors())
                            {                             errMsgs = errMsgs + '  ' + err.getMessage();
                            }   
                    errMessage2.put(srList2[i].Id,errMsgs);                errMsgs ='';                            
                    }
                    
            if(!errorIds2.IsEmpty())
                {
                    for(integer i=0;i<errorIds2.size();i++)
                    {                    errorFile = errorFile + errorIds2[i]+','+ errMessage2.get(errorIds2[i]) + ',' +'\n';                       sendMail = true;                    
                    }               
                } 
        }
         Database.SaveResult[] srList1 = database.insert(outboundList,false);
         for (integer i=0; i<srList1.size();i++) 
                    {
                         String errMsgs = '';
                        if(!srList1[i].isSuccess())
                        {
                            errorIds1.add(srList1[i].id);
                        }
                        for(Database.Error err : srList1[i].getErrors())
                            {
                                 errMsgs = errMsgs + '  ' + err.getMessage();
                            }   
                    errMessage1.put(srList1[i].Id,errMsgs);
                    errMsgs ='';                            
                    }
            if(!errorIds1.IsEmpty())
                {                
                    for(integer i=0;i<errorIds1.size();i++)
                    {
                        errorFile = errorFile + errorIds1[i]+','+ errMessage1.get(errorIds1[i]) + ',' +'\n';
                        sendMail = true;                    
                    }
                } 
        else
        {
                    
         Database.SaveResult[] srList = database.update(assignlist,false);
        
          for (integer i=0; i<srList.size();i++) 
                    {
                         String errMsgs = '';
                        if(!srList[i].isSuccess())
                        {
                            errorIds.add(srList[i].id);
                        }
                        for(Database.Error err : srList[i].getErrors())
                            {
                                 errMsgs = errMsgs + '  ' + err.getMessage();
                            }   
                    errMessage.put(srList[i].Id,errMsgs);
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
        if(sendMail == true)
         {
             Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Assignment Failed_Records.csv');
            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Assignment - Outbound Transfer Failure';
            email.setSubject(subject);
            String[] toAddresses = new String[] {emailid};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         }
    }
 
    public static void sendassigndatasecondpass(Set<id> placeset1){
         IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
    Set<String> branchset = new Set<String>();
    String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
    String errorFile = 'Id,Error\n';
    Map<id,String> errMessage = new Map<id,String>();
    Map<id,String> errMessage1 = new Map<id,String>();
    List<Id> errorIds = new List<Id>();
    List<Id> errorIds1 = new List<Id>();
    Boolean sendMail = false;
        List<IP_OutboundDataTransfer__c> outboundList = new List<IP_OutboundDataTransfer__c>();
         IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
       List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];

    for(IP_BranchStatus__c b:branchlist)
    {
        branchset.add(b.IP_BranchID__c);
    }
    List<sirenum__Placement__c> assignlist = [select id,sirenum__Site__r.IP_TempestDepartment__c,IP_AssignmentRefForTempest__c,IP_AWRCoreCat__c, IP_AWRJobCat__c,IP_ClientIDLegacy__c,IP_Consultant1IDnumberSplitShare__c, IP_PassToTempest__c, IP_LastPassedToTempest__c,IP_Consultant1PercentageSplit__c, IP_Consultant2IDnumberSplitShare__c,IP_Consultant2PercentageSplit__c, IP_TempestDepartment__c,IP_TempestDivision__c,IP_LookUpOfHolidayEntitlement__c,Adhoc_Formula__c,IP_WorkerPayrollRef__c,IP_PurchaseOrderNumber__c,sirenum__End_Date__c, Sirenum__Job_Role__r.sirenum__Job_Type__r.Name,Sirenum__Site__r.IP_Public_Sector__c,Sirenum__Site__r.Name, Sirenum__Site__r.IP_InvoiceContactText__c,Sirenum__Site__r.IP_MainContact__r.Name,sirenum__Site__r.sirenum__Postal_Code__c,sirenum__Start_Date__c,OPWIPS__c,IP_Department__c from sirenum__Placement__c where IP_PassToTempest__c=true and IP_Department__c in:branchset and id in:placeset1];
    
    for(sirenum__Placement__c pl : assignlist)
    {
          if(!paycheck.Run_Parallel_Payroll__c)
        {
        pl.IP_PassToTempest__c = false;       
        pl.IP_LastPassedToTempest__c = System.now();
        }
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
          if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob.IP_RateFrequency__c = 'H';
        ob.IP_Standard_Occupation_Code__c = '';
        ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
        ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob.IP_RateFrequency__c = '<IGNORE>';
        ob.IP_Standard_Occupation_Code__c = pl.IP_AWRJobCat__c;
        ob.IP_Lookup_of_holiday_entitlement__c = '<IGNORE>';
        ob.IP_Adhoc_Formula__c = 'N';
        }
        ob.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
        ob.IP_Passed__c = 'PASSING';
        ob.IP_Tempest_Department__c = pl.IP_TempestDepartment__c; 
        ob.IP_AssignmentRef__c= pl.IP_AssignmentRefForTempest__c;
        ob.IP_AWR_Job_Cat__c = pl.IP_AWRJobCat__c;
        ob.IP_AWR_Core_Cat__c = pl.IP_AWRCoreCat__c;
        ob.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
        ob.IP_Consultant_1_ID_number__c = pl.IP_Consultant1IDnumberSplitShare__c;
        ob.IP_Commission_Split__c = String.valueOf(pl.IP_Consultant1PercentageSplit__c);
        ob.IP_Consultant_2_ID_number__c = pl.IP_Consultant2IDnumberSplitShare__c;
        ob.IP_Consultant_2_Percentage_Split__c = String.valueOf(pl.IP_Consultant2PercentageSplit__c);
       // ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
       // ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        ob.IP_WorkerPayroll_Ref__c = pl.IP_WorkerPayrollRef__c;
        ob.IP_Invoice_PO_Number__c = pl.IP_PurchaseOrderNumber__c;
        ob.IP_Placement_End_Date__c = pl.sirenum__End_Date__c;
        ob.IP_Job_Type_Name__c = pl.Sirenum__Job_Role__r.sirenum__Job_Type__r.Name;
        ob.IP_SiteName__c = pl.Sirenum__Site__r.Name;
        ob.IP_Invoice_ContactName__c = pl.Sirenum__Site__r.IP_InvoiceContactText__c;
        ob.IP_Main_ContactName__c = pl.Sirenum__Site__r.IP_MainContact__r.Name;
        ob.IP_Postal_Code__c = pl.sirenum__Site__r.sirenum__Postal_Code__c;
        ob.IP_Placement_Start_Date__c = pl.sirenum__Start_Date__c;
        //ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
        if(NO_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
            ob.IP_Public_Sector_Placement__c = 'N';
        }
        else if(YES_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
            ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
        }
           //ob.IP_Department__c = pl.IP_Department__c; changed for JPC 2459
        IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(pl.sirenum__Site__r.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
        ob.IP_OriginRecordID__c = pl.id;
        ob.IP_TransferType__c = 'Assignment';
          // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
        outboundList.add(ob);
    }
     Database.SaveResult[] srList1 = database.insert(outboundList,false);
     for (integer i=0; i<srList1.size();i++) 
                {
                     String errMsgs = '';
                    if(!srList1[i].isSuccess())
                    {
                        errorIds1.add(srList1[i].id);
                    }
                    for(Database.Error err : srList1[i].getErrors())
                        {
                             errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage1.put(srList1[i].Id,errMsgs);
                errMsgs ='';                            
                }
        if(!errorIds1.IsEmpty())
            {                
                for(integer i=0;i<errorIds1.size();i++)
                {
                    errorFile = errorFile + errorIds1[i]+','+ errMessage1.get(errorIds1[i]) + ',' +'\n';
                    sendMail = true;                    
                }
            } 
    else
    {
                
     Database.SaveResult[] srList = database.update(assignlist,false);
    
      for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(!srList[i].isSuccess())
                    {
                        errorIds.add(srList[i].id);
                    }
                    for(Database.Error err : srList[i].getErrors())
                        {
                             errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage.put(srList[i].Id,errMsgs);
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
    if(sendMail == true)
         {
             Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Assignment Failed_Records.csv');
            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Assignment - Outbound Transfer Failure';
            email.setSubject(subject);
            String[] toAddresses = new String[] {emailid};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         }
    }
    public static void sendassigndatafirstpass(Set<id> placeset){
    IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
    Set<id> Timesheetidset = new Set<id>();
    Boolean sendMail = false;
    String errorFile = 'Id,Error\n';
      Map<id,String> errMessage2 = new Map<id,String>();
    Map<id,String> errMessage3 = new Map<id,String>();
    Map<id,String> errMessage4 = new Map<id,String>();
    List<Id> errorIds2 = new List<Id>();
    List<Id> errorIds3 = new List<Id>();
    List<Id> errorIds4 = new List<Id>();
        Set<String> timeset = new Set<String>();

        Set<String> branchset = new Set<String>();
         IP_Parallel_Payroll_Check__c paycheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck');
       List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];
    for(IP_BranchStatus__c b:branchlist)
    {
        branchset.add(b.IP_BranchID__c);
    }
    List<IP_OutboundDataTransfer__c> updateoutboundlist = new List<IP_OutboundDataTransfer__c>();
    List<IP_OutboundDataTransfer__c> insertoutboundlist = new List<IP_OutboundDataTransfer__c>();
    List<sirenum__Placement__c> assignlist1 = [select id,sirenum__Site__r.IP_TempestDepartment__c,IP_FirstPass__c,IP_AssignmentRefForTempest__c,IP_TimesheetIDLink__c,IP_AWRCoreCat__c, IP_AWRJobCat__c,IP_ClientIDLegacy__c,IP_Consultant1IDnumberSplitShare__c, IP_PassToTempest__c, IP_LastPassedToTempest__c,IP_Consultant1PercentageSplit__c, IP_Consultant2IDnumberSplitShare__c,IP_Consultant2PercentageSplit__c, IP_TempestDepartment__c,IP_TempestDivision__c,IP_LookUpOfHolidayEntitlement__c,Adhoc_Formula__c,IP_WorkerPayrollRef__c,IP_PurchaseOrderNumber__c,sirenum__End_Date__c, Sirenum__Job_Role__r.sirenum__Job_Type__r.Name,Sirenum__Site__r.IP_Public_Sector__c,Sirenum__Site__r.Name, Sirenum__Site__r.IP_InvoiceContactText__c,Sirenum__Site__r.IP_MainContact__r.Name,sirenum__Site__r.sirenum__Postal_Code__c,sirenum__Start_Date__c,OPWIPS__c,IP_Department__c from sirenum__Placement__c where IP_Department__c in:branchset and id in:placeset];
    
    List<IP_OutboundDataTransfer__c> existingrec = [Select id,IP_OriginRecordID__c,IP_TimesheetID__c from IP_OutboundDataTransfer__c where IP_OriginRecordID__c in: placeset and IP_Passed__c = ''];
    System.debug('check existing list'+existingrec);
    for(IP_OutboundDataTransfer__c o:existingrec)
    {
        Timesheetidset.add(o.IP_TimesheetID__c);
    }    
    if(existingrec.size()>0)
    {
  /*  List<sirenum__Timesheet__c> timesheetlist = [Select id from sirenum__Timesheet__c where id in:Timesheetidset];
    for(sirenum__Timesheet__c tl :timesheetlist)
    {
        timeset.add(tl.id);
    }*/
    for(sirenum__Placement__c pl : assignlist1)
    {
        for(IP_OutboundDataTransfer__c ot :existingrec) 
        {            
            if(ot.IP_OriginRecordID__c == pl.id)
            {
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
                   if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob.IP_RateFrequency__c = 'H';
        ob.IP_Standard_Occupation_Code__c = '';
        ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
        ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob.IP_RateFrequency__c = '<IGNORE>';
        ob.IP_Standard_Occupation_Code__c = pl.IP_AWRJobCat__c;
        ob.IP_Lookup_of_holiday_entitlement__c = '<IGNORE>';
        ob.IP_Adhoc_Formula__c = 'N';
        }
                ob.id = ot.id;
                ob.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
                ob.IP_Tempest_Department__c = pl.IP_TempestDepartment__c; 
                ob.IP_AssignmentRef__c= pl.IP_AssignmentRefForTempest__c;
                ob.IP_AWR_Job_Cat__c = pl.IP_AWRJobCat__c;
                ob.IP_AWR_Core_Cat__c = pl.IP_AWRCoreCat__c;
                ob.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
                ob.IP_Consultant_1_ID_number__c = pl.IP_Consultant1IDnumberSplitShare__c;
                ob.IP_Commission_Split__c = String.valueOf(pl.IP_Consultant1PercentageSplit__c);
                ob.IP_Consultant_2_ID_number__c = pl.IP_Consultant2IDnumberSplitShare__c;
                ob.IP_Consultant_2_Percentage_Split__c = String.valueOf(pl.IP_Consultant2PercentageSplit__c);
              //  ob.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
             //   ob.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
                ob.IP_WorkerPayroll_Ref__c = pl.IP_WorkerPayrollRef__c;
                ob.IP_Invoice_PO_Number__c = pl.IP_PurchaseOrderNumber__c;
                ob.IP_Placement_End_Date__c = pl.sirenum__End_Date__c;
                ob.IP_Job_Type_Name__c = pl.Sirenum__Job_Role__r.sirenum__Job_Type__r.Name;
                ob.IP_SiteName__c = pl.Sirenum__Site__r.Name;
                ob.IP_Invoice_ContactName__c = pl.Sirenum__Site__r.IP_InvoiceContactText__c;
                ob.IP_Main_ContactName__c = pl.Sirenum__Site__r.IP_MainContact__r.Name;
                ob.IP_Postal_Code__c = pl.sirenum__Site__r.sirenum__Postal_Code__c;
                ob.IP_Placement_Start_Date__c = pl.sirenum__Start_Date__c;
                //ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
                if(NO_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                    ob.IP_Public_Sector_Placement__c = 'N';
                }
                else if(YES_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                    ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
                }
                //ob.IP_Department__c = pl.IP_Department__c; changed for JPC 2459
        IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(pl.sirenum__Site__r.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
                ob.IP_OriginRecordID__c = pl.id;
                ob.IP_TransferType__c = 'Assignment';
                //  ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                updateoutboundlist.add(ob);
              /*  if(!timeset.contains(pl.IP_TimesheetIDLink__c))
                {
                    pl.IP_TimesheetIDLink__c = '';
                }
                else
                {*/
                if(!Timesheetidset.contains(pl.IP_TimesheetIDLink__c))
                {
                IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c(); 
                   if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob1.IP_RateFrequency__c = 'H';
        ob1.IP_Standard_Occupation_Code__c = '';
        ob1.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
        ob1.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob1.IP_RateFrequency__c = '<IGNORE>';
        ob1.IP_Standard_Occupation_Code__c = pl.IP_AWRJobCat__c;
        ob1.IP_Lookup_of_holiday_entitlement__c = '<IGNORE>';
        ob1.IP_Adhoc_Formula__c = 'N';
        }          
                  ob1.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;         
                ob1.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
                ob1.IP_Tempest_Department__c = pl.IP_TempestDepartment__c; 
                ob1.IP_AssignmentRef__c= pl.IP_AssignmentRefForTempest__c;
                ob1.IP_AWR_Job_Cat__c = pl.IP_AWRJobCat__c;
                ob1.IP_AWR_Core_Cat__c = pl.IP_AWRCoreCat__c;
                ob1.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
                ob1.IP_Consultant_1_ID_number__c = pl.IP_Consultant1IDnumberSplitShare__c;
                ob1.IP_Commission_Split__c = String.valueOf(pl.IP_Consultant1PercentageSplit__c);
                ob1.IP_Consultant_2_ID_number__c = pl.IP_Consultant2IDnumberSplitShare__c;
                ob1.IP_Consultant_2_Percentage_Split__c = String.valueOf(pl.IP_Consultant2PercentageSplit__c);
             //   ob1.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
            //    ob1.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
                ob1.IP_WorkerPayroll_Ref__c = pl.IP_WorkerPayrollRef__c;
                ob1.IP_Invoice_PO_Number__c = pl.IP_PurchaseOrderNumber__c;
                ob1.IP_Placement_End_Date__c = pl.sirenum__End_Date__c;
                ob1.IP_Job_Type_Name__c = pl.Sirenum__Job_Role__r.sirenum__Job_Type__r.Name;
                ob1.IP_SiteName__c = pl.Sirenum__Site__r.Name;
                ob1.IP_Invoice_ContactName__c = pl.Sirenum__Site__r.IP_InvoiceContactText__c;
                ob1.IP_Main_ContactName__c = pl.Sirenum__Site__r.IP_MainContact__r.Name;
                ob1.IP_Postal_Code__c = pl.sirenum__Site__r.sirenum__Postal_Code__c;
                ob1.IP_Placement_Start_Date__c = pl.sirenum__Start_Date__c;
                //ob1.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
                if(NO_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                    ob.IP_Public_Sector_Placement__c = 'N';
                }
                else if(YES_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                    ob.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
                }
                ob1.IP_Department__c = pl.IP_Department__c;
                ob1.IP_OriginRecordID__c = pl.id;
                ob1.IP_TransferType__c = 'Assignment';
                ob1.IP_TimesheetID__c = pl.IP_TimesheetIDLink__c;
                insertoutboundlist.add(ob1);
                }
                
            }
        }
        pl.IP_FirstPass__c = false;
        if(!paycheck.Run_Parallel_Payroll__c)
        {
        pl.IP_PassToTempest__c = false;  
        }
    }
    }
    
    else
    {
        for(sirenum__Placement__c pl : assignlist1) 
        {
               
                IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();       
                  if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob1.IP_RateFrequency__c = 'H';
        ob1.IP_Standard_Occupation_Code__c = '';
        ob1.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
        ob1.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob1.IP_RateFrequency__c = '<IGNORE>';
        ob1.IP_Standard_Occupation_Code__c = pl.IP_AWRJobCat__c;
        ob1.IP_Lookup_of_holiday_entitlement__c = '<IGNORE>';
        ob1.IP_Adhoc_Formula__c = 'N';
        } 
         ob1.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;        
                ob1.IP_Tempest_Division__c = pl.IP_TempestDivision__c;
                ob1.IP_Tempest_Department__c = pl.IP_TempestDepartment__c; 
                ob1.IP_AssignmentRef__c= pl.IP_AssignmentRefForTempest__c;
                ob1.IP_AWR_Job_Cat__c = pl.IP_AWRJobCat__c;
                ob1.IP_AWR_Core_Cat__c = pl.IP_AWRCoreCat__c;
                ob1.IP_Client_ID_Legacy__c = pl.IP_ClientIDLegacy__c;
                ob1.IP_Consultant_1_ID_number__c = pl.IP_Consultant1IDnumberSplitShare__c;
                ob1.IP_Commission_Split__c = String.valueOf(pl.IP_Consultant1PercentageSplit__c);
                ob1.IP_Consultant_2_ID_number__c = pl.IP_Consultant2IDnumberSplitShare__c;
                ob1.IP_Consultant_2_Percentage_Split__c = String.valueOf(pl.IP_Consultant2PercentageSplit__c);
             //   ob1.IP_Lookup_of_holiday_entitlement__c = String.valueof(pl.IP_LookUpOfHolidayEntitlement__c);
             //   ob1.IP_Adhoc_Formula__c = pl.Adhoc_Formula__c;
                ob1.IP_WorkerPayroll_Ref__c = pl.IP_WorkerPayrollRef__c;
                ob1.IP_Invoice_PO_Number__c = pl.IP_PurchaseOrderNumber__c;
                ob1.IP_Placement_End_Date__c = pl.sirenum__End_Date__c;
                ob1.IP_Job_Type_Name__c = pl.Sirenum__Job_Role__r.sirenum__Job_Type__r.Name;
                ob1.IP_SiteName__c = pl.Sirenum__Site__r.Name;
                ob1.IP_Invoice_ContactName__c = pl.Sirenum__Site__r.IP_InvoiceContactText__c;
                ob1.IP_Main_ContactName__c = pl.Sirenum__Site__r.IP_MainContact__r.Name;
                ob1.IP_Postal_Code__c = pl.sirenum__Site__r.sirenum__Postal_Code__c;
                ob1.IP_Placement_Start_Date__c = pl.sirenum__Start_Date__c;
                //ob1.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
                if(NO_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                    ob1.IP_Public_Sector_Placement__c = 'N';
                }
                else if(YES_VALUE.equals(pl.Sirenum__Site__r.IP_Public_Sector__c)){
                    ob1.IP_Public_Sector_Placement__c = pl.OPWIPS__c;
                }
                 //ob.IP_Department__c = pl.IP_Department__c; changed for JPC 2459
        IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(pl.sirenum__Site__r.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob1.IP_Department__c = shiftcode.IP_Site_Name__c;}
                ob1.IP_OriginRecordID__c = pl.id;
                ob1.IP_TransferType__c = 'Assignment';
                ob1.IP_TimesheetID__c = pl.IP_TimesheetIDLink__c;
                insertoutboundlist.add(ob1);
                
                pl.IP_FirstPass__c = false;
        if(!paycheck.Run_Parallel_Payroll__c)
        {
        pl.IP_PassToTempest__c = false;  
        }
        
    }
    }
    if(updateoutboundlist.size()>0)
    {
        Database.SaveResult[] srList2 = database.update(updateoutboundlist,false);
              for (integer i=0; i<srList2.size();i++) 
                {                     String errMsgs = '';                    if(!srList2[i].isSuccess())
                    {
                        errorIds2.add(srList2[i].id);
                    }
                    for(Database.Error err : srList2[i].getErrors())
                        {                             errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage2.put(srList2[i].Id,errMsgs);                errMsgs ='';                            
                }
                
        if(!errorIds2.IsEmpty())
            {
                for(integer i=0;i<errorIds2.size();i++)
                {                    errorFile = errorFile + errorIds2[i]+','+ errMessage2.get(errorIds2[i]) + ',' +'\n';                       sendMail = true;                    
                }               
            } 
    }
    if(insertoutboundlist.size()>0)
    {
        Database.SaveResult[] srList3 = database.insert(insertoutboundlist,false);
              for (integer i=0; i<srList3.size();i++) 
                {
                     String errMsgs = '';
                    if(!srList3[i].isSuccess())
                    {
                        errorIds3.add(srList3[i].id);
                    }
                    for(Database.Error err : srList3[i].getErrors())
                        {                             errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage3.put(srList3[i].Id,errMsgs);
                errMsgs ='';                            
                }
                
        if(!errorIds3.IsEmpty())
            {
                for(integer i=0;i<errorIds3.size();i++)
                {errorFile = errorFile + errorIds3[i]+','+ errMessage3.get(errorIds3[i]) + ',' +'\n';                     sendMail = true;                    
                }               
            } 
    }
    Database.SaveResult[] srList4 = database.update(assignlist1,false);
                  for (integer i=0; i<srList4.size();i++) 
                {
                     String errMsgs = '';
                    if(!srList4[i].isSuccess())
                    {
                        errorIds4.add(srList4[i].id);
                    }
                    for(Database.Error err : srList4[i].getErrors())
                        {                            errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage4.put(srList4[i].Id,errMsgs);
                errMsgs ='';                            
                }
                
        if(!errorIds4.IsEmpty())
            {
                for(integer i=0;i<errorIds4.size();i++)
                {    errorFile = errorFile + errorIds4[i]+','+ errMessage4.get(errorIds4[i]) + ',' +'\n';                       sendMail = true;                    
                }               
            } 
                    String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
            if(sendMail == true)
         {
             Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);             errAtt.setFileName('Assignment Failed_Records.csv');            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Assignment - Outbound Transfer Failure';            email.setSubject(subject);            String[] toAddresses = new String[] {emailid};            email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         }
    }
 }
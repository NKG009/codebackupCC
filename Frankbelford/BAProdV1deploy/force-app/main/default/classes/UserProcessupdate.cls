public class UserProcessupdate {
    public static Boolean sendMail = false;

    public static void senduserdata(Set<id> Userid){
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
    List<User> Userlist = [Select id,Name,Email,IP_TempestID__c,IP_TempestDepartment__c,IP_TempestDivision__c,IP_PassToTempest__c,IP_LastPassedToTempest__c from User where IP_TempestDepartment__c in: branchset and id in:Userid];
    
    for(User u : Userlist)
    {
      
        if(!paycheck.Run_Parallel_Payroll__c)
        {
        u.IP_PassToTempest__c = false;
         u.IP_LastPassedToTempest__c = System.now();
        }
       
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_Tempest_Division__c = u.IP_TempestDivision__c;
        ob.IP_Tempest_Department__c = u.IP_TempestDepartment__c;
        ob.IP_Consultants_Tempest_ID__c = u.IP_TempestID__c;
        ob.IP_Email__c = u.Email;
        ob.IP_Passed__c = 'PASSING';
        ob.IP_Consultant_Name__c = u.Name;
        ob.IP_OriginRecordID__c = u.id;
        ob.IP_TransferType__c = 'Consultant';
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
        if(!errorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                {    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                       sendMail = true;                    
                }
            } 
            else
            {
    Database.SaveResult[] srList = database.update(Userlist,false);
     for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(!srList[i].isSuccess())
                    {
                        errorIds.add(srList[i].id);
                    }
                    for(Database.Error err : srList[i].getErrors())
                        {                             errMsgs = errMsgs + '  ' + err.getMessage();
                        }   
                errMessage.put(srList[i].Id,errMsgs);
                errMsgs ='';                            
                }
               
        if(!errorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                {                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                       sendMail = true;                    
                }
            } 
            }
         if(sendMail == true)
         {
             String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
             Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);   errAtt.setFileName('Consultant Failed_Records.csv');            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Consultant - Outbound Transfer Failure';           email.setSubject(subject);           String[] toAddresses = new String[] {emailid};            email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         }
        }
        }
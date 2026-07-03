global without sharing class CPBankDetailController {
    
    @AuraEnabled
    Public Static List<IP_PayProfile__C> getDefaultBankDetail()
    { 
        
        List<IP_PayProfile__C> Lst = new List<IP_PayProfile__C>();
        List<IP_PayProfile__C> ppLst = [Select Id,Name,IP_AccountNumber__c,IP_BankAccountName__c,IP_SortCode__c,IP_BuildingSocietyNumber__c,RecordType.Name,IP_AccountNumberSalted__c,IP_SortCodeSalted__c	 from IP_PayProfile__C where IP_PrimaryPayMethod__c=true and IP_Candidate__c=:getUserId()];                            
        for(IP_PayProfile__C p:ppLst){  if(p.IP_SortCodeSalted__c!=null){  p.IP_SortCodeSalted__c = p.IP_SortCodeSalted__c.left(1) + '****' + p.IP_SortCodeSalted__c.right(1); }else{ p.IP_SortCodeSalted__c = '1****6'; } if(p.IP_AccountNumberSalted__c!=null){ p.IP_AccountNumberSalted__c = p.IP_AccountNumberSalted__c.left(2) + '****' + p.IP_AccountNumberSalted__c.right(2); }else{   p.IP_AccountNumberSalted__c = '1****8'; } Lst.add(p);    
                                     }     
        return Lst;        
        
    }
    
    @AuraEnabled
    Public Static List<IP_PayProfile__C> getPaymentType()
    {
        return [Select Id,Name,RecordType.Name,IP_PrimaryPayMethod__c from IP_PayProfile__C where IP_Candidate__c=:getUserId() and IP_Status__c='Active'];               
    }
    
    @AuraEnabled
    Public Static List<IP_PayProfile__C> BankDetail(String recordId)
    {              
        List<IP_PayProfile__C> Lst = new List<IP_PayProfile__C>();
        List<IP_PayProfile__C> ppLst = [Select Id,Name,IP_AccountNumber__c,IP_BankAccountName__c,IP_SortCode__c,IP_BuildingSocietyNumber__c,RecordType.Name,IP_AccountNumberSalted__c,IP_SortCodeSalted__c from IP_PayProfile__C where Id=:recordId];              
        for(IP_PayProfile__C p:ppLst){ 
            if(p.IP_SortCodeSalted__c!=null){
                p.IP_SortCodeSalted__c = p.IP_SortCodeSalted__c.left(1) + '****' + p.IP_SortCodeSalted__c.right(1);
            }else{
                p.IP_SortCodeSalted__c = '1****6';
            }
            if(p.IP_AccountNumberSalted__c!=null){
                p.IP_AccountNumberSalted__c = p.IP_AccountNumberSalted__c.left(2) + '****' + p.IP_AccountNumberSalted__c.right(2);
            }else{
                p.IP_AccountNumberSalted__c = '1****8';
            }
            Lst.add(p);    
        }              
        return Lst;
    }
    
    @AuraEnabled
    public static IP_PayProfile__C savePP(String Ids,String inputId,String part) 
    {
        Id templateId = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Change_Bank_Details'].id;
        
        OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];
        
        IP_PayProfile__C ToUpdate = [select Id,IP_Candidate__r.IP_TempestDepartment__c,IP_BankAccountName__c,IP_Candidate__c,IP_candidate__r.FirstName,IP_AccountNumber__c,IP_AccountNumberSalted__c,IP_SortCodeSalted__c,IP_SortCode__c,IP_BuildingSocietyNumber__c from IP_PayProfile__C where id=:Ids];
        if(part!=null && part=='ACCOUNTNAME'){
            ToUpdate.IP_BankAccountName__c=inputId;
            system.debug('================================================================ToUpdate-->'+ToUpdate);
        }
        if(part=='SORTCODE'){
            ToUpdate.IP_SortCodeSalted__c=inputId;
            ToUpdate.IP_SortCode__c=inputId;
        }
        if(part=='ACCOUNTNUMBER'){
            ToUpdate.IP_AccountNumber__c=inputId;
            ToUpdate.IP_AccountNumberSalted__c=inputId;
        }
        if(part=='BUILDINGSOCIETYREF'){
            ToUpdate.IP_BuildingSocietyNumber__c=inputId;
        }
        update ToUpdate;
        String department = ToUpdate.IP_Candidate__r.IP_TempestDepartment__c;
            IP_Shift_Template__c shiftemp1 = IP_Shift_Template__c.getValues(department);
             system.debug('================================================================shiftemp1-->'+shiftemp1);
            List<OrgWideEmailAddress> owd1;
            if(shiftemp1!=Null){
            owd1= [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp1.Email__c];
            system.debug('================================================================OWD ID--->'+owd1);
            }
            
        
        
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
        system.debug('=======================================================email'+email);
        email.setTargetObjectId(ToUpdate.IP_Candidate__r.id);
        if(owd1.size()>0)
            {
            email.setOrgWideEmailAddressId(owd1[0].Id);
            }
            else
           {
			email.setOrgWideEmailAddressId(owd.Id);
               }
            
        email.setTemplateId(templateId); 
        email.saveAsActivity = false;
        Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         
        return ToUpdate;
        
    }
    
    public static String getUserId(){
        ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
        return contactId;
    }
}
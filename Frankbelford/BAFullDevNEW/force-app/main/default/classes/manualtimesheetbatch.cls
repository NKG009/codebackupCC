global class manualtimesheetbatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    public List<String> placename = new List<String>();
    public Map<Id,String> error = new Map<Id,String>();
    public Map<Id,String> emailerror = new Map<Id,String>();
    public String errorFile = 'Id,Error,Message\n';
    public Boolean sendMail = false;
    public Map<Id,String> emailsuccess = new Map<Id,String>();
    public Boolean indicateLightning = false;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string query;
        Date dt = System.today();
        Date dt2 =dt.addDays(-1);
        Datetime datet = (DateTime)dt;
        String DayWeek = datet.format('EEEE');
        System.debug('DayWeek '+DayWeek);
        
        Date today = System.today()+7;
        Boolean IsLightning;
        IsLightning = [SELECT id,UserPreferencesLightningExperiencePreferred FROM User where id = : UserInfo.getUserId()].UserPreferencesLightningExperiencePreferred;
        If(IsLightning)
        { 
            indicateLightning= true;
        }
        else{   
            indicateLightning = false;
        } 
        
       query ='Select id,createdby.email,sirenum__Contact__r.Email,sirenum__Site__r.Ip_Timesheet_Method__c,sirenum__Contact__r.Person_Status__c,IP_Consultant1LookupSplitShare__r.email,IP_Consultant1LookupSplitShare__c,'+
            'IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c,IP_Consultant1LookupSplitShare__r.name,name,'+
            'sirenum__Start_Date__c,sirenum__End_Date__c,sirenum__Contact__c,sirenum__Job_Role__r.sirenum__Rota__r.Name'+
            ' from sirenum__Placement__c where  sirenum__Contact__r.Person_Status__c=\'Active\' and'+
            ' sirenum__Contact__r.HasOptedOutOfEmail=false and (sirenum__Contact__r.Email !=\'\' OR sirenum__Contact__r.Email !=NULL) and sirenum__Site__r.Ip_Timesheet_Method__c=\'Manual\' and'+
            ' sirenum__Start_Date__c<=:today and sirenum__End_Date__c >:dt and Id in (Select sirenum__Placement__c from'+
            ' sirenum__shift__c where sirenum__Scheduled_Start_Time__c >=:dt and sirenum__Scheduled_Start_Time__c<=:today'+
            ' and sirenum__Cancelled__c = FALSE)  '; 
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sirenum__Placement__c> scope) 
    {  
        Date dt = System.today();
        Date startdate = scope[0].sirenum__Start_Date__c;
        Date enddate = scope[0].sirenum__End_Date__c;
        Date today = System.today()+7;
        List<sirenum__shift__c> shiftlist = [Select id,sirenum__Scheduled_Start_Time__c from sirenum__shift__c where sirenum__Placement__c =:scope[0].id and sirenum__Scheduled_Start_Time__c >=:dt and sirenum__Scheduled_Start_Time__c<=:today and sirenum__Cancelled__c = FALSE];
        
        string category=scope[0].sirenum__Job_Role__r.sirenum__Rota__r.Name;
        
        
        If(startdate<=today && enddate>System.today() && shiftlist.size()>0)        
        {
            try{
                PageReference pdfPage;
                If(category=='driving')
                {
                    pdfPage = new PageReference('/apex/TimesheetDesign?Id='+scope[0].id);
                }
                else
                {
                    pdfPage = new PageReference('/apex/TimesheetDesign2?Id='+scope[0].id);
                    
                }
                pdfPage.getParameters().put('id',scope[0].id);
                Blob pdf;
                if(!test.isrunningtest()){        
                    pdf = pdfPage.getContentAsPdf();
                }
                else
                    pdf=Blob.valueOf('Test');
                
                if(indicateLightning)
                {
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S';
                    conVer.PathOnClient = 'application/pdf'; 
                    conVer.Title = 'Timesheet.pdf';  
                    conVer.VersionData = pdf; 
                    insert conVer;
                    Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = conDoc;
                    cDe.LinkedEntityId = scope[0].id;
                    cDe.ShareType = 'I';
                    cDe.Visibility = 'AllUsers';
                    insert cDe;
                    
                }
                else
                {
                    Attachment a = New Attachment();
                    a.body = pdf;
                    a.parentID = scope[0].id;
                    a.ContentType  = 'application/pdf';
                    a.Name = 'Timesheet.pdf';
                    
                    insert a;
                }
                
                //Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Timesheet.pdf');//Pleace ad pdf name from contact name project and oppty concatinate
                efa.setContentType('application/pdf');
                efa.setBody(pdf);
                
                // Create the Single Email Message
                Id templateId;  
                templateId = [select id, name from EmailTemplate where developername = 'Bulk_Timesheet_Template'].id; 
                
                String department = scope[0].IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c;
                IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
                
                
                List<User> ucand = [Select id from User where ContactId =: scope[0].sirenum__Contact__c limit 1];
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTemplateId(templateId);  
                
                if(ucand.size()>0){
                    email.setTargetObjectId(ucand[0].Id);          email.setSaveAsActivity(false);        }else {
                        email.setTargetObjectId(scope[0].sirenum__Contact__c);
                        email.setSaveAsActivity(true);
                    }
                
                
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                email.setWhatId(scope[0].id);
                email.setReplyTo(scope[0].IP_Consultant1LookupSplitShare__r.email);
                
                if(shiftemp != NULL){
                    List<OrgWideEmailAddress> owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
                    if(owd.size()>0){ email.setOrgWideEmailAddressId(owd[0].Id); }}
                else{
                    List<OrgWideEmailAddress> defaultowd = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='jobscience.support@rssglobal.com'];
                    email.setOrgWideEmailAddressId(defaultowd[0].Id);}
                
                // Sends the email
                Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                if (results[0].success) {
                    //  System.debug('The email was sent successfully.');
                    
                } else {
                    //  System.debug('The email failed to send: ' + results[0].errors[0].message);
                    //  emailerror.put(scope[0].id, results[0].errors[0].message);
                    errorFile = errorFile + scope[0].id+','+ results[0].errors[0].message + ','+' Error in Sending Mail' +','+ '\n';       
                    sendMail = true;    
                }
                
            }catch(Exception e){
                
                System.debug('Attachment=Exception-->'+e);
                placename.add(scope[0].id);
                // error.put(scope[0].id, e.getMessage());
                errorFile = errorFile + scope[0].id+','+ e.getMessage() + ',' + 'Error in Attachment OR email' + ',' + '\n';     
                sendMail = true;      
            }
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC)
    {     
        If(sendMail == true)
        {   
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Manual Batch Timesheet Error(Friday)';
            email.setSubject(subject);
            email.saveAsActivity= false;
            email.settargetObjectId(UserInfo.getUserId()); 
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
        }
    }
    
}
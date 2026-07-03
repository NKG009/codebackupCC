/*
    * Class Name: SendAutoReminderToRefree.
    * Description: Batch class to send the auotoreminder to refree
    * Test Class: TestSendAutoReminderToRefree
    * Date : 5th June 2019
    */
    global class SendAutoReminderToRefree implements Database.Batchable<sObject>,Database.Stateful{
        
        private static final string EMAIL_TMPLT_MAPPING_LABEL = 'Send Auto Reminder To Refree';
        global String errorFile = 'Id,Error\n';
        global boolean sendMail = false;
        public Integer referenceFirstMailSend = Integer.valueOf(System.Label.ReferenceFirstMailSend);
        public Integer referenceSecondMailSend = Integer.valueOf(System.Label.ReferenceSecondMailSend);
        public Integer referenceThirdMailSend = Integer.valueOf(System.Label.ReferenceThirdMailSend);  
        
        /*
        * Method Name: start
        * Description: to query all the records
        * Parameters : Database.BatchableContext BC
        * Return Type: Database.QueryLocator
        * Date : 5th June 2019
        */
        global Database.QueryLocator start(Database.BatchableContext BC) {            
            String query = 'Select id ,ts2__Status__c,Date_Reference_Request_Sent__c, ts2__Candidate__r.Brand__c, ts2__Candidate__r.Owner.Email,ts2__Name__c,ts2__Email__c,ts2__Candidate__r.IP_TempestDepartment__c,ts2__Candidate__c,ts2__Candidate__r.Email,ts2__Candidate__r.Ownerid from ts2__Reference__c where Date_Reference_Request_Sent__c!=null and ts2__Status__c!=\'Inactive\' and Date_Reference_Received__c=null and (Date_Reference_Request_Sent__c<=LAST_N_DAYS:'+referenceFirstMailSend+' or Date_Reference_Request_Sent__c<=LAST_N_DAYS:'+referenceSecondMailSend+' or Date_Reference_Request_Sent__c<=LAST_N_DAYS:'+referenceThirdMailSend+')  limit 50000';
            system.debug('+++++++++++++++'+query);
            return Database.getQueryLocator(query);
        }
        
        /*
        * Method Name: execute.
        * Description: to process all the records
        * Parameters : Database.BatchableContext BC, List<ts2__Reference__c> refernceList
        * Return Type: void
        * Date : 5th June 2019
        */
        global void execute(Database.BatchableContext BC, List<ts2__Reference__c> refernceList) {
            Map<Id,ts2__Reference__c> mapReferenceIdCandidateId = new Map<Id,ts2__Reference__c>();
            Map<Id,ts2__Reference__c> mapReferenceIdCanIdTask = new Map<Id,ts2__Reference__c>();
            List<Task> listInsertTask = new List<Task>();
            List<ts2__Reference__c> listUpdateReference = new List<ts2__Reference__c>();
            Set<String> setTempestCode = new Set<String>();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Date firstMailDaysDate = System.today().addDays(-referenceFirstMailSend);
            Date secondMailDaysDate = System.today().addDays(-referenceSecondMailSend);
            Date lastMailDaysDate = System.today().addDays(-referenceThirdMailSend);
            
            //Id templateId = [select id, name from EmailTemplate where developername = :REFERENCE_DEVELOPER_NAME].id;
            //Id templateId = Util.getEmailTemplateMapping(refernceList.ts2__Candidate__r.Brand__c,REFERENCE_DEVELOPER_NAME).TemplateId__c;
            for(ts2__Reference__c reference : refernceList){
                setTempestCode.add(reference.ts2__Candidate__r.IP_TempestDepartment__c);
                Date referenceRequestSentDate = date.newinstance(reference.Date_Reference_Request_Sent__c.year(), reference.Date_Reference_Request_Sent__c.month(), reference.Date_Reference_Request_Sent__c.day());
                
                if(referenceRequestSentDate==lastMailDaysDate){
                    mapReferenceIdCanIdTask.put(reference.id,reference);
                    mapReferenceIdCandidateId.put(reference.id,reference);
                }
                if(referenceRequestSentDate==firstMailDaysDate || referenceRequestSentDate==secondMailDaysDate ){
                    mapReferenceIdCandidateId.put(reference.id,reference);
                }
                system.debug('+++++mapReferenceIdCanIdTask++++++++++'+mapReferenceIdCanIdTask);
                system.debug('++++++++++mapReferenceIdCandidateId+++++'+mapReferenceIdCandidateId);
            }
            
            List<IP_Shift_Template__c> listShiftemp = new List<IP_Shift_Template__c>();
            Map<String,String> mapTempNameTempEmail = new Map<String,String>();
            listShiftemp = [select id,Email__c,Name from IP_Shift_Template__c where Name IN :setTempestCode];
            if(!listShiftemp.isEmpty()){
                for(IP_Shift_Template__c shiftTemplate : listShiftemp){
                    mapTempNameTempEmail.put(shiftTemplate.Name,shiftTemplate.Email__c);
                }
            }
            
            Map<String,String> mapOrgWideIdOrgWideEmail = new Map<String,String>();
            List<OrgWideEmailAddress> listOrgwideEmailAddress = [select id, DisplayName,Address from OrgWideEmailAddress where Address IN:mapTempNameTempEmail.values()];
            for(OrgWideEmailAddress owd : listOrgwideEmailAddress){
                mapOrgWideIdOrgWideEmail.put(owd.Address,owd.id);
            }
            
            if(!mapReferenceIdCanIdTask.isEmpty()){
                for(ts2__Reference__c referenceTask : mapReferenceIdCanIdTask.values()){
                    Task tsk = new Task();
                    tsk.Ownerid = referenceTask.ts2__Candidate__r.OwnerID;
                    tsk.Subject = Label.Reference_Task_Subject;
                    tsk.whatid = referenceTask.id;
                    tsk.Whoid = referenceTask.ts2__Candidate__c;
                    tsk.ActivityDate = System.today();
                    listInsertTask.add(tsk);
                }system.debug('++++++++++listInsertTask+++++'+listInsertTask);
                insert listInsertTask;
                system.debug('++++++++++listInsertTask+++++'+listInsertTask);
            }
            if(!mapReferenceIdCandidateId.isEmpty()){
                for(ts2__Reference__c reference : mapReferenceIdCandidateId.values()){
                    if(String.IsNotBlank(reference.ts2__Email__c)){
                        //Email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                
                        string[] toaddress = new String[] {reference.ts2__Email__c};
                        email.setToAddresses(toaddress);
                        email.setTargetObjectId(mapReferenceIdCandidateId.get(reference.id).ts2__Candidate__c);
                        email.setTreatTargetObjectAsRecipient(false);
                        email.setWhatid(reference.id);
                        email.setReplyTo(reference.ts2__Candidate__r.Owner.Email);
                        email.setTemplateId(Util.getEmailTemplateMapping(reference.ts2__Candidate__r.Brand__c,EMAIL_TMPLT_MAPPING_LABEL).TemplateId__c);
                        email.setOrgWideEmailAddressId(mapOrgWideIdOrgWideEmail.get(mapTempNameTempEmail.get(reference.ts2__Candidate__r.IP_TempestDepartment__c)));
                        email.setSaveasActivity(true);
                        mails.add(email);
                        
                        //update Date_Latest_Reference_Reminder_Sent__c Field
                        reference.Date_Latest_Reference_Reminder_Sent__c = System.now();
                        reference.ts2__Status__c = 'Resent';
                        listUpdateReference.add(reference);
                    }
                    else{
                        sendMail = true;
                        errorFile = errorFile + reference.id+','+ 'Email is Empty' + ',' +'\n';
                    }
                }
                try{
                    if(!mails.isEmpty()){
                        Messaging.sendEmail(mails,true);
                    }
                }
                catch(exception e){
                    system.debug('++++++++++e.getlinenumber()+++++'+e.getlinenumber());
                    system.debug('++++++++++e.getmessage()+++++'+e.getmessage());
                }
                if(!listUpdateReference.isEmpty()){
                    update listUpdateReference;
                }
            }
        }
        
        /*
        * Method Name: finish
        * Description: 
        * Parameters : Database.BatchableContext BC
        * Return Type: void
        * Date : 5th June 2019
        */
        global void finish(Database.BatchableContext BC) {
            if(sendMail){
                Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
                blob errBlob = blob.valueof(errorFile);    
                errAtt.setFileName('Failed_Records.csv');
                errAtt.setBody(errBlob);
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                String subject ='Batch Failure - SendAutoReminderToRefree';
                email.setSubject(subject);
                String[] toAddresses = new String[] {System.Label.BASupportEmail};
                email.setToAddresses(toAddresses);
                email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
    }
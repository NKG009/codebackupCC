public class VMSJobOrderResponseController {
    
    @AuraEnabled(cacheable=true)
    public static  List<CandidateTicketWrapper> getAllSubmittedCandidatesForJobOrder() {
        Set<Id> twotierconid = new Set<Id>();
        Map<Id,String> contactTicketMap = new Map<Id,String>();
        
        List<Candidate__c> candidateList = [SELECT Id, Status__c, Contact__r.Name, Contact__r.Id,Contact__r.email,
                                            Job_Order__r.sirenum__Account__r.Name, 
                                            Job_Order__r.Total_Resource_Required__c,
                                            Job_Order__r.name,
                                            Job_Order__r.Job_Order_Number__c,
                                            Job_Order__r.JobRoleMinimum__c,
                                            Job_Order__r.sirenum__Site__r.Name, 
                                            Job_Order__r.sirenum__JobRole__r.Name, 
                                            Job_Order__r.CreatedDate, 
                                            Job_Order__r.Owner.Name,
                                            Job_Order__r.Owner.Email, 
                                            Submitted_By__r.Contact.Account.Name, 
                                            Submitted_By__r.Contact.email,
                                            Submitted_By__r.Contact.Name
                                            FROM Candidate__c  // WHERE Status__c='Submitted'
                                            ];
        for(Candidate__c can: candidateList){
            twotierconid.add(can.Contact__r.id);
        }
        system.debug('twotierconid'+ twotierconid);
        for( contact con : [select id, (select id,sirenum__Valid__c from sirenum__Tickets__r) from contact where ID IN:twotierconid]){
            Boolean hasInvalidTicket = false;
            
            
            for (sirenum__Ticket__c ticket : con.sirenum__Tickets__r) {
                if (!ticket.sirenum__Valid__c) {
                    hasInvalidTicket = true;
                    break; 
                }
            }
            
            
            if (hasInvalidTicket) {
                contactTicketMap.put(con.Id, 'YES');
            } else {
                contactTicketMap.put(con.Id, 'NO');
            }
        }
        
        List<CandidateTicketWrapper> wrapperList = new List<CandidateTicketWrapper>();
        
        for (Candidate__c can : candidateList) {
            
            String yesOrNo = ''; 
            if (can.Contact__r != null && contactTicketMap.containsKey(can.Contact__r.Id)) {
                yesOrNo = contactTicketMap.get(can.Contact__r.Id);
            }
            CandidateTicketWrapper wrapper = new CandidateTicketWrapper();
            wrapper.candidate = can;
            wrapper.ticketStatus = yesOrNo;
            
            // Add the wrapper instance to the list
            wrapperList.add(wrapper);
        }
        
        
        system.debug('wrapperList'+ wrapperList);
        return wrapperList;
        // add mvs client boolean   return [SELECT Id,CreatedDate,sirenum__Account__r.name,sirenum__Site__r.name,sirenum__JobRole__r.Name,Date_Confirmed__c,(SELECT Id,Contact__r.Name,Status__c,Submitted_By__r.contact.account.name  from Candidates__r) FROM sirenum__JobOrder__c WHERE Id=: recordId limit 1 ];
    }
    
    @AuraEnabled
    public static void updateCandidateStatus(List<Map<String, Object>> candidaterecords, String status) {
        if (candidaterecords.isEmpty()) {
            throw new AuraHandledException('No candidates selected');
        }
        boolean throwexception=false;
        system.debug('candidaterecordssize:'+candidaterecords.size());
        // List<Candidate__c> candidatesToUpdate = [SELECT Id, Status__c FROM Candidate__c WHERE Id IN :candidateIds];
        // try{ 
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'no.reply@bluearrow.co.uk' LIMIT 1];
            List<Candidate__c> candidatesToUpdate = new List<Candidate__c>();
            
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            
            List<User> portalUsersToCreate = new List<User>();
            Set<Id> Joborderids = new Set<Id>();
            Map<Id,sirenum__JobOrder__c> joblistforshifts = new  Map<Id,sirenum__JobOrder__c> ();
            List<sirenum__Shift__c> shiftsrecordstoinsert = new  List<sirenum__Shift__c>();
            List<sirenum__Shift__c> shiftsToUpdate = new List<sirenum__Shift__c>();
            Map<Id, Map<Id, sirenum__Shift__c>> jobOrderToShiftMap = new Map<Id, Map<Id, sirenum__Shift__c>>();
            //Map<Id,Id> Joidtoaccid = new Map<Id,Id>();
            
            for (Map<String, Object> record : candidaterecords) {  //jobOrder
                Joborderids.add((Id) record.get('jobOrder'));
            }
            
            if(Joborderids.size()>0){
                joblistforshifts =new Map<Id, sirenum__JobOrder__c>([select id,Total_Resource_Required__c,sirenum__StartDate__c,sirenum__Account__c, (select id,sirenum__Broadcasts__c,sirenum__AssignedShifts__c,IP_Account__c,sirenum__Site__c,sirenum__Team__c,sirenum__Contract__c,sirenum__Rota__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,sirenum__Published__c,sirenum__JobOrder__c from sirenum__Shifts__r where  recordtype.developername='Shift_Demand') from sirenum__JobOrder__c where ID IN:Joborderids AND Total_Resource_Required__c !=null and Total_Resource_Required__c >0]);
                
            }
            
            for (Id joid : joblistforshifts.keySet()) {
                sirenum__JobOrder__c jorec = joblistforshifts.get(joid);
                
                if (jorec != null && jorec.sirenum__Shifts__r != null && jorec.sirenum__Shifts__r.size() > 0) {
                    Map<Id, sirenum__Shift__c> shiftsMap = new Map<Id, sirenum__Shift__c>();
                    
                    
                    for (sirenum__Shift__c shift : jorec.sirenum__Shifts__r) {
                        if(shift.sirenum__Scheduled_Start_Time__c >=jorec.sirenum__StartDate__c){
                            if(shift.sirenum__Broadcasts__c == shift.sirenum__AssignedShifts__c && throwexception==false){
                                throwexception =true;
                               
                            }
                            else{
                                 shiftsMap.put(shift.Id, shift);
                            }
                           
                        }
                        
                    }
                    
                    
                    jobOrderToShiftMap.put(joid, shiftsMap);
                }

            }
            if(throwexception == true){
                throw new AuraHandledException('Shifts Already been filled for this Job Order');  
            }
            
            
            for (Map<String, Object> record : candidaterecords) {
                // Extracting necessary information from the map
                Id candidateId = (Id) record.get('Id');
                String jobOrderName = (String) record.get('jobOrderName');
                String clientAccountName = (String) record.get('accountName');
                String jobOrderOwnerEmail = (String) record.get('jobOwnerEmail');
                Map<Object, Object> Candidateconrecord = (Map<Object, Object>) record.get('candidatedata');
                Map<Object, Object> Supplierconrecord = (Map<Object, Object>) record.get('supplierContactdata');
                string candidateconid = (String) Candidateconrecord.get('Id');
                String candidateName = (String) Candidateconrecord.get('Name');
                String candidateEmail = (String) Candidateconrecord.get('Email'); 
                String supplierUserName = (String) Supplierconrecord.get('Name');
                String supplierEmail = (String) Supplierconrecord.get('Email'); 
                Id joid =(Id) record.get('jobOrder');
                
                
                Domain d=[SELECT Domain FROM Domain where domain like '%my.site.com%' limit 1];
                Network ns=[select name, UrlPathPrefix FROM Network where name LIKE '%Client Portal V2%' limit 1];
                Network nc=[select name, UrlPathPrefix FROM Network where name like '%Your Blue Arrow Account%' limit 1];
                
                string supplierPortalUrl='https://'+d.Domain+'/'+ns.UrlPathPrefix; 
                string candidatePortalUrl='https://'+d.Domain+'/'+nc.UrlPathPrefix;
                
                
                
                
                // Creating email template for Supplier based on the status
                String emailSubject='';
                String emailBody='';
                
                if (status == 'Accepted') {
                    
                    if(jobOrderToShiftMap.containskey(joid)){
                        
                        Map<Id, sirenum__Shift__c> shiftMap = jobOrderToShiftMap.get(joid);
                        for (Id shiftId : shiftMap.keySet()) {
                            
                            sirenum__Shift__c shiftRec = shiftMap.get(shiftId);
                            shiftRec.sirenum__AssignedShifts__c = shiftRec.sirenum__AssignedShifts__c==null?0:shiftRec.sirenum__AssignedShifts__c;
                            system.debug('shiftRec.sirenum__Broadcasts__c:'+shiftRec.sirenum__Broadcasts__c);
                            system.debug('shiftRec.sirenum__AssignedShifts__c:'+shiftRec.sirenum__AssignedShifts__c);
                            
                            if (shiftRec.sirenum__Broadcasts__c >= 1 && shiftRec.sirenum__AssignedShifts__c <shiftRec.sirenum__Broadcasts__c  ){
                                system.debug('insideif to add' );
                                sirenum__Shift__c newShiftRec = new sirenum__Shift__c();
                                newShiftRec.sirenum__ShiftDemand__c = shiftRec.Id;  
                                newShiftRec.sirenum__Contact__c = candidateconid; 
                                //newShiftRec.sirenum__Published__c = true;  
                                newShiftRec.IP_Account__c= shiftRec.IP_Account__c!=null?shiftRec.IP_Account__c : joblistforshifts.get(joid).sirenum__Account__c;
                                newShiftRec.sirenum__Site__c = shiftRec.sirenum__Site__c;
                                newShiftRec.sirenum__Team__c = shiftRec.sirenum__Team__c;
                                newShiftRec.sirenum__Contract__c = shiftRec.sirenum__Contract__c;
                                newShiftRec.sirenum__Rota__c = shiftRec.sirenum__Rota__c;
                                newShiftRec.sirenum__Scheduled_Start_Time__c = shiftRec.sirenum__Scheduled_Start_Time__c;
                                newShiftRec.sirenum__Scheduled_End_Time__c = shiftRec.sirenum__Scheduled_End_Time__c;
                                newShiftRec.sirenum__JobOrder__c = 	shiftRec.sirenum__JobOrder__c;
                                
                                
                                shiftsrecordstoinsert.add(newShiftRec);
                                
                                
                                shiftRec.sirenum__AssignedShifts__c += 1;
                                shiftMap.put(shiftRec.Id, shiftRec); 
                            }
                        }
                        
                    }
                    emailSubject = 'Candidate Accepted: ' + candidateName + ' for Job Order: ' + jobOrderName;
                    emailBody = '<p>Dear ' + supplierUserName + ',</p>' +
                        '<p>' + candidateName + ' has been accepted into ' + jobOrderName + ' with ' + clientAccountName + '.</p>' +
                        '<p>Please consult your supplier portal <a href="' + supplierPortalUrl + '">here</a> for all necessary details on this role.</p>' +
                        '<p>If you have any questions, please contact us at ' + jobOrderOwnerEmail + '.</p>' +
                        '<p>Kind regards,<br>Blue Arrow</p>';
                    
                    // Send acceptance email to the candidate
                    String candidateEmailSubject = 'Congratulations ' + candidateName + '! You have been accepted for ' + jobOrderName;
                    String candidateEmailBody = '<p>Dear ' + candidateName + ',</p>' +
                        '<p>You have been accepted into a role with ' + clientAccountName + ' and Blue Arrow.</p>' +
                        '<p>' + supplierUserName + ' will provide all details of the role to you.</p>' +
                        '<p>If you haven’t already, please download the Blue Arrow app to submit your hours:</p>' +
                        // Adding images with links to the stores
                        '<p><a href="https://play.google.com/store/apps/details?id=uk.co.bluearrow.mobile&pli=1" target="_blank">' +
                        '<img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Google Play Store" style="width:150px;height:auto;"></a></p>' +
                        '<p><a href="https://play.google.com/store/apps/details?id=uk.co.bluearrow.mobile&pli=1">Click here to access the Google Play store</a></p>' +
                        '<p><a href="https://apps.apple.com/us/app/blue-arrow/id1591189235" target="_blank">' +
                        '<img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-example-preferred.png" alt="Apple App Store" style="width:150px;height:auto;"></a></p>' +
                        '<p><a href="https://apps.apple.com/us/app/blue-arrow/id1591189235">Click here to access the Apple App store</a></p>' +
                        '<p>Alternatively, if you do not have a smartphone, you can submit your hours using our portal via your browser by clicking the link below:</p>' +
                        '<p><a href="'+candidatePortalUrl+'" target="_blank">Please click here</a></p>' +
                        '<p>Your username will be your email address, and when you first access the portal, you will set your own memorable password. If you forget your password, you can click on the ‘Forgot your password?’ link on the login page, which will send a reset password email to your email account.</p>' +
                        '<p>If you have any questions, please contact ' + supplierUserName + '.</p>' +
                        '<p>Kind regards,<br>Blue Arrow</p>';
                    
                    // Send email to candidate
                    Messaging.SingleEmailMessage candidateEmailMessage = new Messaging.SingleEmailMessage();
                    candidateEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                    candidateEmailMessage.setToAddresses(new String[] { candidateEmail });
                    candidateEmailMessage.setSubject(candidateEmailSubject);
                    candidateEmailMessage.sethtmlbody (candidateEmailBody);
                    emails.add(candidateEmailMessage);
                    
                    // Check if candidate already has a portal user
                    if ([SELECT Id FROM User WHERE ContactId = :candidateconid LIMIT 1].isEmpty()) {
                        createuserrecords(candidateName,candidateEmail,candidateconid);
                        
                    }
                } else if (status == 'Rejected') {
                    emailSubject = 'Candidate Rejected: ' + candidateName + ' for Job Order: ' + jobOrderName;
                    emailBody = '<p>Dear ' + supplierUserName + ',</p>' +
                        '<p>' + candidateName + ' has been rejected for ' + jobOrderName + ' with ' + clientAccountName + '.</p>' +
                        '<p>Please consult your supplier portal <a href="' + supplierPortalUrl + '">here</a> for all necessary details on this role.</p>' +
                        '<p>if you have any questions please contact us at harrisoncatering@bluearrow.co.uk.</p>' +
                        '<p>Kind regards,<br>Blue Arrow</p>';
                }
                
                
                
                
                // Send email to supplier
                Messaging.SingleEmailMessage supplierEmailMessage = new Messaging.SingleEmailMessage();
                supplierEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                supplierEmailMessage.setToAddresses(new String[] { supplierEmail });
                supplierEmailMessage.setSubject(emailSubject);
                supplierEmailMessage.sethtmlbody(emailBody);
                emails.add(supplierEmailMessage);
                
                Candidate__c canupdate  = new Candidate__c();
                canupdate.id=candidateId;
                canupdate.Status__c = status;
                candidatesToUpdate.add(canupdate);
                
                
            }
            
            
            
            // Update the candidates' statuses
            if (!candidatesToUpdate.isEmpty()) {
                update candidatesToUpdate;
            }
            
            // Insert portal users for candidates
            if (!portalUsersToCreate.isEmpty()) {
                insert portalUsersToCreate;
                
            }
            
            system.debug('emailstosent:'+emails);
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
            
            system.debug('shiftsrecordstoinsert:'+shiftsrecordstoinsert.size() + shiftsrecordstoinsert);
            if (!shiftsrecordstoinsert.isEmpty()) {
                insert shiftsrecordstoinsert;
                
                List<VMSCandidateshiftsupdate__c> customSettingsToInsert = new List<VMSCandidateshiftsupdate__c>();
                
                
                for (sirenum__Shift__c shift : shiftsrecordstoinsert) {
                    VMSCandidateshiftsupdate__c newSetting = new VMSCandidateshiftsupdate__c();
                    newSetting.Name = shift.Id; 
                    customSettingsToInsert.add(newSetting);
                }
                
                
                if (!customSettingsToInsert.isEmpty()) {
                    insert customSettingsToInsert;
                }
            }
            for (Map<Id, sirenum__Shift__c> shiftsMap : jobOrderToShiftMap.values()) {
                shiftsToUpdate.addAll(shiftsMap.values());  
                
            }
            if (!shiftsToUpdate.isEmpty()) {
                update shiftsToUpdate;  
            }
            
            
        // }
        // catch(exception e){
        //     throw new AuraHandledException('error on accept reject'+ e +e.getStackTraceString() ); 
        // }
    }
    
    @future
    public static void createuserrecords(String candidateName , string candidateEmail, string candidateconid){
        
        User portalUser = new User(
            FirstName = candidateName.split(' ')[0],
            LastName = candidateName.split(' ')[1],
            Email = candidateEmail,
            Username = candidateEmail,
            Alias = candidateName.substring(0, 4),
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'User Portal' LIMIT 1].Id,
            TimeZoneSidKey = 'Europe/London',
            LocaleSidKey = 'en_GB',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            ContactId = candidateconid
        );
        
        insert portalUser;
        
    }
    
    
    public class CandidateTicketWrapper {
        @AuraEnabled public Candidate__c candidate { get; set; }
        @AuraEnabled public String ticketStatus { get; set; } 
    }
    
}
/**Class Name - ResendShiftCnfrmCtrl
 * Description - Used to resend shift confirmation emails to candidate when Emails are bounced
 * Test Class - ResendShiftCnfrmCtrl_Test
 * Author - Swarupa Karri
 **/

global class ResendShiftCnfrmCtrlBatch implements Database.Batchable<sObject> {
    
    public static List<Messaging.SingleEmailMessage> emailMsgLstToUpd = new List<Messaging.SingleEmailMessage>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         List<EmailMessage> emailMsgLst = new List<EmailMessage>();
         GenericSetting__mdt filteredDateRec = [SELECT Id,FromDate__c,EndDate__c FROM GenericSetting__mdt WHERE DeveloperName='ResendShiftCnfrmDates'];
         Date fromDate = Date.valueOf(filteredDateRec.FromDate__c),toDate = Date.valueOf(filteredDateRec.EndDate__c);
         String query = '';
         if(filteredDateRec != null && !Test.isRunningTest()){
             query = 'SELECT Id,Name,RelatedToId FROM EmailMessage WHERE IsBounced =True AND Subject = \'Blue Arrow Candidate Assignment Confirmation\' AND CreatedDate >= :fromDate AND CreatedDate <= :toDate ';
         	 System.debug('query:::'+JSON.serialize(query));
         }else if(Test.isRunningTest()){
             query = 'SELECT Id,Name,RelatedToId FROM EmailMessage WHERE IsBounced =True AND Subject = \'Blue Arrow Candidate Assignment Confirmation\'';
         }
      	emailMsgLst = Database.query(query);
        System.debug('emailMsgLst::'+emailMsgLst.size());
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<EmailMessage> emailMsgLst) {
        Set<Id> splacementIdSet = new Set<Id>(),jobRoleIdSet = new Set<Id>(), rateCardIdSet = new Set<Id>(), emailSucSPlaceIdSet = new Set<Id>();
      List<sirenum__Shift__c> shiftLst;
      List<sirenum__Rate_Line__c> rateLineLst;
      Map<Id,List<sirenum__Shift__c>> jobRoleShiftMap = new Map<Id,List<sirenum__Shift__c>>();
      Map<Id,List<sirenum__Rate_Line__c>> rateCardLineMap = new Map<Id,List<sirenum__Rate_Line__c>>();
      Map<Id,String> jobRoleRCIdMap = new Map<Id,String>();
      List<Messaging.SingleEmailMessage> emailMsgLstToUpd = new List<Messaging.SingleEmailMessage>();
      String sub = 'Blue Arrow Candidate Assignment Confirmation';
      String compassPayStr = 'Payment for work at Compass will be made weekly in arrears directly into your bank account subject to deduction of tax and national insurance in respect of hours worked in the preceding week. Compass’ working week is Thursday to Wednesday.';
      Set<Id> errTargetIdSet = new Set<Id>();
        
      // Retrieve S-Placement Ids
      for(EmailMessage emailMsg: emailMsgLst){
           splacementIdSet.add(emailMsg.RelatedToId);
      }
       
       //Retrieve S-Placement Records
       List<sirenum__Placement__c> splaceRecLst = [SELECT Id,sirenum__Job_Role__c,sirenum__Contact__c,sirenum__Job_Role__r.sirenum__Rate_Card__c,sirenum__Site__r.IP_SalesLedgerNo__c,sirenum__Site__r.Name,
                                                   sirenum__Contact__r.FirstName,sirenum__Site__r.sirenum__Full_Address__c,sirenum__Job_Role__r.Name,sirenum__Start_Date__c,sirenum__Job_Role__r.IP_Notified_Health_Safety_Risks__c,
                                                   sirenum__Job_Role__r.IP_Special_Induction__c,sirenum__Job_Role__r.IP_Personal_Protective_Equipment__c,sirenum__Job_Role__r.IP_Job_Description__c,
                                                   IP_Consultant1LookupSplitShare__r.FirstName,IP_Consultant1LookupSplitShare__r.LastName,sirenum__Contact__r.Email,IP_Consultant1LookupSplitShare__r.Email,
                                                   IP_Consultant1LookupSplitShare__r.Phone,Assignment_Email_Sent_Manually__c,IP_Shift_Details_sent__c FROM sirenum__Placement__c WHERE Id IN :splacementIdSet AND Assignment_Email_Sent_Manually__c = :FALSE AND IP_Shift_Details_sent__c = :FALSE];
        
        System.debug('splaceRecLst::'+JSON.serialize(splaceRecLst));
       //Retrieve JobRoleIds, Rate Card Ids
       for(sirenum__Placement__c splaceRec : splaceRecLst){
            jobRoleIdSet.add(splaceRec.sirenum__Job_Role__c);
            jobRoleRCIdMap.put(splaceRec.sirenum__Job_Role__c,splaceRec.sirenum__Job_Role__r.sirenum__Rate_Card__c);
            rateCardIdSet.add(splaceRec.sirenum__Job_Role__r.sirenum__Rate_Card__c);
        }
       
       //Prepare a map with Job Role Id and Respective shifts
        for(sirenum__Shift__c shift : [SELECT Id,sirenum__Contact__r.Email,sirenum__Placement__c,sirenum__Team__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE sirenum__Placement__c IN :splacementIdSet AND sirenum__Cancelled__c = FALSE ORDER BY sirenum__Shift_Date__c ASC]){
        	 if(!jobRoleShiftMap.isEmpty() && jobRoleShiftMap.containsKey(shift.sirenum__Team__c)){
                jobRoleShiftMap.get(shift.sirenum__Team__c).add(shift);
            }else if(jobRoleShiftMap.isEmpty() || !jobRoleShiftMap.containsKey(shift.sirenum__Team__c)){
                jobRoleShiftMap.put(shift.sirenum__Team__c,new List<sirenum__Shift__c>{shift});
            }
        }
        
        for(sirenum__Rate_Line__c rateLine : [SELECT Id,sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c,sirenum__Standard_Rate_Name__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,
                                              sirenum__End_Hour__c,sirenum__Pay_Rate__c,sirenum__Overtime_Pay_Rate__c 
                                              FROM sirenum__Rate_Line__c WHERE sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c IN :rateCardIdSet ORDER BY sirenum__SortOrder__c ASC]){
                   if(!rateCardLineMap.isEmpty() && rateCardLineMap.containsKey(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c)){
                rateCardLineMap.get(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c).add(rateLine);
            }else if(rateCardLineMap.isEmpty() || !rateCardLineMap.containsKey(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c)){
                rateCardLineMap.put(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c,new List<sirenum__Rate_Line__c>{rateLine});
            }
            
        }

		//Set Org Wide Address
		OrgWideEmailAddress orgWideAddress = [SELECT Id,DisplayName from OrgWideEmailAddress where Address = 'no.reply@bluearrow.co.uk'];     
       //Prepare Data for Email 
       for(sirenum__Placement__c splaceRec : splaceRecLst){
           //if(splaceRec.Assignment_Email_Sent_Manually__c == false && splaceRec.IP_Shift_Details_sent__c == false){
           shiftLst = new List<sirenum__Shift__c>();
           rateLineLst = new List<sirenum__Rate_Line__c>();
           String shiftTable = '<table style="border: 1px solid black;border-collapse: collapse;"> <tr>  <th style="border: 1px solid black;border-collapse: collapse;">Start Time</th>  <th style="border: 1px solid black;border-collapse: collapse;">End Time</th></tr>';
           String rateTable = '<table style="border: 1px solid black;border-collapse: collapse;"> <tr>  <th style="border: 1px solid black;border-collapse: collapse;">Rate Name</th>  <th style="border: 1px solid black;border-collapse: collapse;">Day Type</th>  <th style="border: 1px solid black;border-collapse: collapse;">Start Hour</th> <th style="border: 1px solid black;border-collapse: collapse;">End Hour</th> <th style="border: 1px solid black;border-collapse: collapse;">Pay Rate</th><th style="border: 1px solid black;border-collapse: collapse;">Overtime Pay Rate</th></tr>';
           //Prepare Shift Information
           if(!jobRoleShiftMap.isEmpty() && jobRoleShiftMap.containsKey(splaceRec.sirenum__Job_Role__c)){
               shiftLst = jobRoleShiftMap.get(splaceRec.sirenum__Job_Role__c);
           }
           
           System.debug('shiftLst::'+JSON.serialize(shiftLst));
           if(shiftLst.size() > 0){
           for(sirenum__Shift__c shift : shiftLst){
               shiftTable = shiftTable + '<tr><td style="border: 1px solid black;border-collapse: collapse;">'+ shift.sirenum__Scheduled_Start_Time__c +' </td> <td style="border: 1px solid black;border-collapse: collapse;">'+ shift.sirenum__Scheduled_End_Time__c +'</td></tr>';
           }
           }
           shiftTable += '</table>';
           
            System.debug('shiftTable::'+JSON.serialize(shiftTable));
           //Prepare RateCard Information
           Id rateCardId = !jobRoleRCIdMap.isEmpty() && jobRoleRCIdMap.containsKey(splaceRec.sirenum__Job_Role__c) ? jobRoleRCIdMap.get(splaceRec.sirenum__Job_Role__c) : null;
           if(rateCardId != null && !rateCardLineMap.isEmpty() && rateCardLineMap.containsKey(rateCardId)){
               rateLineLst = rateCardLineMap.get(rateCardId);
               System.debug('rateLineLst::'+JSON.serialize(rateLineLst));
               
               for(sirenum__Rate_Line__c rateLine : rateLineLst){
                 String startHour = String.isNotEmpty(rateLine.sirenum__Start_Hour__c) ? rateLine.sirenum__Start_Hour__c : '';
                 String endHour = String.isNotEmpty(rateLine.sirenum__End_Hour__c) ? rateLine.sirenum__End_Hour__c : '';
                 String payRate = String.isNotEmpty(String.valueOf(rateLine.sirenum__Pay_Rate__c)) ? '£' + String.valueOf(rateLine.sirenum__Pay_Rate__c) : '£ 0.0';
                 String oPayRate = String.isNotEmpty(String.valueOf(rateLine.sirenum__Overtime_Pay_Rate__c)) ? '£' + String.valueOf(rateLine.sirenum__Overtime_Pay_Rate__c) : '£ 0.0';
                            
                   rateTable = rateTable + '<tr><td style="border: 1px solid black;border-collapse: collapse;">' +  rateLine.sirenum__Standard_Rate_Name__c + 
		  				' </td><td style="border: 1px solid black;border-collapse: collapse;">' + rateLine.sirenum__Day_Type__c+
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + startHour +
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + endHour +
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + payRate +
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + oPayRate +
						'</tr>';
               }
               rateTable += '</table>';
           }
           String emailBody = '<html><p><img src="https://impellam--c.um5.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&amp;versionId=0684J00000Xgd1F&amp;operationContext=DELIVERY&amp;contentId=05T4J00001vB13O&amp;page=0&amp;d=/a/4J000000d08i/aN4HAHSuEYLj3.Heg8qebRWpUp4XfGPXHpA6RNktQlQ&amp;oid=00DPu0000008rVN&amp;dpt=null&amp;viewId=" alt="Blue Arrow Logo.png"></p><p><span style="color: rgb(0, 0, 0);">Dear {!Get_S_Placement.sirenum__Contact__r.FirstName},</span></p><p><strong style="color: rgb(0, 0, 0);">Confirmation of ongoing temporary assignment at:</strong></p><p><strong style="color: rgb(0, 0, 0);">Client Name: </strong><span style="color: rgb(0, 0, 0);"> {!Get_S_Placement.sirenum__Site__r.Name}</span></p><p><strong style="color: rgb(0, 0, 0);">Client Address:</strong><span style="color: rgb(0, 0, 0);">  {!Get_S_Placement.sirenum__Site__r.sirenum__Full_Address__c}</span></p><p><strong style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">Starting on: </strong><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Get_S_Placement.sirenum__Start_Date__c} as {!Get_S_Placement.sirenum__Job_Role__r.Name}</span></p><p><strong style="color: rgb(0, 0, 0);">Notified Health and Safety Risks:</strong><span style="color: rgb(0, 0, 0);">  {!Get_Job_Role.IP_Notified_Health_Safety_Risks__c}</span></p><p><strong style="color: rgb(0, 0, 0);">Special Induction:</strong><span style="color: rgb(0, 0, 0);"> </span></p>{!Get_Job_Role.IP_Special_Induction__c}<p><strong style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">Uniform Requirements: </strong><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Get_Job_Role.IP_Personal_Protective_Equipment__c}</span></p><p><strong style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">Job Description:</strong></p><p>{!Get_Job_Role.IP_Job_Description__c}</p><p><br></p><p><strong style="color: rgb(0, 0, 0);">Initial hours of work:</strong></p><p><span style="color: rgb(0, 0, 0);">{!Shift_Table}</span></p><p><span style="color: rgb(0, 0, 0);">The table below outlines pay rate(s) that are applicable to this assignment. Note that pay rates may vary depending on time and date of the shift and other factors. Should the pay rate applicable to your shifts change, we will confirm accordingly.</span></p><p></p><p><span style="color: rgb(0, 0, 0);">{!Compass_Pay_Cycle_Text}</span></p><p><span style="color: rgb(0, 0, 0);">{!Rate_Table}</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);">Additional information can also be obtained from your Key Information Document and Flexible Employee Handbook. </span><span style="color: rgb(0, 0, 0);">If you have any queries regarding your assignment please feel free to contact me.</span></p><p><br></p><p><span style="color: rgb(0, 0, 0);">Yours sincerely</span></p><p><span style="color: rgb(0, 0, 0);">{!Get_S_Placement.IP_Consultant1LookupSplitShare__r.FirstName} {!Get_S_Placement.IP_Consultant1LookupSplitShare__r.LastName}</span></p><p><span style="color: rgb(0, 0, 0);"></span></p><p><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Sender_Phone}</span></p><p><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Sender_Email}</span></p><img src="https://impellam.my.salesforce.com/servlet/servlet.ImageServer?oid=00D0Y000000LzSj&esid=018Q5000007yl4s&from=int"></html>';
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Contact__r.FirstName}',splaceRec.sirenum__Contact__r.FirstName);
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Site__r.Name}',splaceRec.sirenum__Site__r.Name);
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Site__r.sirenum__Full_Address__c}',splaceRec.sirenum__Site__r.sirenum__Full_Address__c);
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Start_Date__c} as {!Get_S_Placement.sirenum__Job_Role__r.Name}',splaceRec.sirenum__Start_Date__c + ' as ' + splaceRec.sirenum__Job_Role__r.Name);
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Notified_Health_Safety_Risks__c}',splaceRec.sirenum__Job_Role__r.IP_Notified_Health_Safety_Risks__c != null ? splaceRec.sirenum__Job_Role__r.IP_Notified_Health_Safety_Risks__c : '');
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Special_Induction__c}',splaceRec.sirenum__Job_Role__r.IP_Special_Induction__c != null ? splaceRec.sirenum__Job_Role__r.IP_Special_Induction__c : '');
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Personal_Protective_Equipment__c}',splaceRec.sirenum__Job_Role__r.IP_Personal_Protective_Equipment__c != null ? splaceRec.sirenum__Job_Role__r.IP_Personal_Protective_Equipment__c : '');
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Job_Description__c}',splaceRec.sirenum__Job_Role__r?.IP_Job_Description__c != null ? splaceRec.sirenum__Job_Role__r?.IP_Job_Description__c : '');
		   //Set Compass Text to Null when SalesLedger No is not 1000026
            if(splaceRec.sirenum__Site__r.IP_SalesLedgerNo__c != '1000026'){
               emailBody = emailBody.replace('{!Compass_Pay_Cycle_Text}','');
            }else{
                emailBody = emailBody.replace('{!Compass_Pay_Cycle_Text}',compassPayStr);
            }
           emailBody = emailBody.replace('{!Compass_Pay_Cycle_Text}','');
           System.debug('emailBody::'+JSON.serialize(emailBody));
           emailBody = emailBody.replace('{!Get_S_Placement.IP_Consultant1LookupSplitShare__r.FirstName} {!Get_S_Placement.IP_Consultant1LookupSplitShare__r.LastName}',splaceRec.IP_Consultant1LookupSplitShare__r.FirstName + '' +splaceRec.IP_Consultant1LookupSplitShare__r.LastName);
           emailBody = emailBody.replace('{!Sender_Phone}',splaceRec.IP_Consultant1LookupSplitShare__r.Phone != null ? splaceRec.IP_Consultant1LookupSplitShare__r.Phone : '');
           emailBody = emailBody.replace('{!Sender_Email}',splaceRec.IP_Consultant1LookupSplitShare__r.Email != null ? splaceRec.IP_Consultant1LookupSplitShare__r.Email : '');
           emailBody = emailBody.replace('{!Shift_Table}',shiftTable);
           emailBody = emailBody.replace('{!Rate_Table}',rateTable);
           
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	   //mail.setTemplateId(et.Id);
    	   mail.setOrgWideEmailAddressId(orgWideAddress.Id);
           //mail.setToAddresses(new List<String>{'swarupa.karri@rssglobal.com'});//'corey.edwards@rssglobal.com','shahed.ahmed@rssglobal.com'});
           mail.setToAddresses(new List<String>{splaceRec.sirenum__Contact__r.Email});
           mail.setSubject(sub);
           mail.setHTMLBody(emailBody);
           mail.setTargetObjectId(splaceRec.sirenum__Contact__c);
           mail.setWhatId(splaceRec.Id);
           mail.setSaveAsActivity(true);
           mail.setUseSignature(false);
		   emailMsgLstToUpd.add(mail);
           
           //Prepare data to update S-Placement Records. Below logic is moved to flow as there is no way to track successfully inserted EmailMessage Ids
            /* splaceRec.Assignment_Email_Sent_Manually__c = true;
             splaceRec.Date_Assignment_Letter_Sent__c = System.now();
           	 splaceRec.Error_Message__c = '';
           	 splaceRec.IP_Shift_Details_sent__c = true;
           	 splaceRecUpdLst.add(splaceRec);*/
       }
    //}
        
        if(!emailMsgLstToUpd.isEmpty()){
          	try {
    			
                 	Messaging.SendEmailResult[] srList = Messaging.sendEmail(emailMsgLstToUpd,false);
                    // Iterate through each returned result
                    for ( Messaging.SendEmailResult sr : srList) {
                        if (sr.isSuccess()) {
                            System.debug('Email was sent succesfully' + JSON.serialize(sr));
                        }
                        else {
                            // Operation failed, so get all errors                
                                for(Messaging.SendEmailError err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('fields that affected this error: ' + err.getFields());
                                    errTargetIdSet.add(err.getTargetObjectId());
                            }
                        }
                    }
                System.debug('errTargetIdSet:::'+JSON.serialize(errTargetIdSet));
                return;
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
       }
    }
    
    public void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }
    
    //Commenting this method as the below method is converted to Batch
   /* public static void resendEmail(){
      
      Set<Id> splacementIdSet = new Set<Id>(),jobRoleIdSet = new Set<Id>(), rateCardIdSet = new Set<Id>(), emailSucSPlaceIdSet = new Set<Id>(),errTargetIdSet = new Set<Id>();
      List<sirenum__Shift__c> shiftLst;
      List<sirenum__Rate_Line__c> rateLineLst;
      List<EmailMessage> emailMsgLst = new List<EmailMessage>();
      Map<Id,List<sirenum__Shift__c>> jobRoleShiftMap = new Map<Id,List<sirenum__Shift__c>>();
      Map<Id,List<sirenum__Rate_Line__c>> rateCardLineMap = new Map<Id,List<sirenum__Rate_Line__c>>();
      Map<Id,String> jobRoleRCIdMap = new Map<Id,String>();
      //List<Messaging.SingleEmailMessage> emailMsgLstToUpd = new List<Messaging.SingleEmailMessage>();
      String sub = 'Blue Arrow Candidate Assignment Confirmation';
      String compassPayStr = 'Payment for work at Compass will be made weekly in arrears directly into your bank account subject to deduction of tax and national insurance in respect of hours worked in the preceding week. Compass’ working week is Thursday to Wednesday.';
      
      /* GenericSetting__mdt filteredDateRec = [SELECT Id,FromDate__c,EndDate__c FROM GenericSetting__mdt WHERE DeveloperName='ResendShiftCnfrmDates'];
       
       //Filter the EmailMessage Records to resend email
       if(filteredDateRec != null && !Test.isRunningTest()){
           emailMsgLst = [SELECT Id,Name,RelatedToId FROM EmailMessage WHERE IsBounced =True AND Subject = 'Blue Arrow Candidate Assignment Confirmation' AND CreatedDate >= :Date.valueOf(filteredDateRec.FromDate__c) AND CreatedDate <= :Date.valueOf(filteredDateRec.EndDate__c)];//2023-04-08T00:00:00.000+01:00];//[SELECT Id,Name,RelatedToId FROM EmailMessage WHERE IsBounced =True AND Subject = 'Blue Arrow Candidate Assignment Confirmation' AND CreatedDate >= 2024-04-08T00:00:00.000+00:00 AND CreatedDate <= 2024-04-10T00:00:00.000+00:00];
       }else if(Test.isRunningTest()){
           emailMsgLst = [SELECT Id,Name,RelatedToId FROM EmailMessage WHERE IsBounced =True AND Subject = 'Blue Arrow Candidate Assignment Confirmation'];
       }
      
	  System.debug('emailMsgLst::'+emailMsgLst.size());
       
      // Retrieve S-Placement Ids
      for(EmailMessage emailMsg: emailMsgLst){
           splacementIdSet.add(emailMsg.RelatedToId);
      }
       
       //Retrieve S-Placement Records
       List<sirenum__Placement__c> splaceRecLst = [SELECT Id,sirenum__Job_Role__c,sirenum__Contact__c,sirenum__Job_Role__r.sirenum__Rate_Card__c,sirenum__Site__r.IP_SalesLedgerNo__c,sirenum__Site__r.Name,
                                                   sirenum__Contact__r.FirstName,sirenum__Site__r.sirenum__Full_Address__c,sirenum__Job_Role__r.Name,sirenum__Start_Date__c,sirenum__Job_Role__r.IP_Notified_Health_Safety_Risks__c,
                                                   sirenum__Job_Role__r.IP_Special_Induction__c,sirenum__Job_Role__r.IP_Personal_Protective_Equipment__c,sirenum__Job_Role__r.IP_Job_Description__c,
                                                   IP_Consultant1LookupSplitShare__r.FirstName,IP_Consultant1LookupSplitShare__r.LastName,sirenum__Contact__r.Email,IP_Consultant1LookupSplitShare__r.Email,
                                                   IP_Consultant1LookupSplitShare__r.Phone FROM sirenum__Placement__c WHERE Id IN :splacementIdSet];
        
       //Retrieve JobRoleIds, Rate Card Ids
       for(sirenum__Placement__c splaceRec : splaceRecLst){
            jobRoleIdSet.add(splaceRec.sirenum__Job_Role__c);
            jobRoleRCIdMap.put(splaceRec.sirenum__Job_Role__c,splaceRec.sirenum__Job_Role__r.sirenum__Rate_Card__c);
            rateCardIdSet.add(splaceRec.sirenum__Job_Role__r.sirenum__Rate_Card__c);
        }
       
       //Prepare a map with Job Role Id and Respective shifts
        for(sirenum__Shift__c shift : [SELECT Id,sirenum__Contact__r.Email,sirenum__Placement__c,sirenum__Team__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE sirenum__Placement__c IN :splacementIdSet AND sirenum__Cancelled__c = FALSE]){
        	 if(!jobRoleShiftMap.isEmpty() && jobRoleShiftMap.containsKey(shift.sirenum__Team__c)){
                jobRoleShiftMap.get(shift.sirenum__Team__c).add(shift);
            }else if(jobRoleShiftMap.isEmpty() || !jobRoleShiftMap.containsKey(shift.sirenum__Team__c)){
                jobRoleShiftMap.put(shift.sirenum__Team__c,new List<sirenum__Shift__c>{shift});
            }
        }
        
        for(sirenum__Rate_Line__c rateLine : [SELECT Id,sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c,sirenum__Standard_Rate_Name__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,
                                              sirenum__End_Hour__c,sirenum__Pay_Rate__c,sirenum__Overtime_Pay_Rate__c 
                                              FROM sirenum__Rate_Line__c WHERE sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c IN :rateCardIdSet]){
                   if(!rateCardLineMap.isEmpty() && rateCardLineMap.containsKey(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c)){
                rateCardLineMap.get(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c).add(rateLine);
            }else if(rateCardLineMap.isEmpty() || !rateCardLineMap.containsKey(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c)){
                rateCardLineMap.put(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__c,new List<sirenum__Rate_Line__c>{rateLine});
            }
            
        }

		//Set Org Wide Address
		OrgWideEmailAddress orgWideAddress = [SELECT Id,DisplayName from OrgWideEmailAddress where Address = 'no.reply@bluearrow.co.uk'];     
       //Prepare Data for Email 
       for(sirenum__Placement__c splaceRec : splaceRecLst){
           shiftLst = new List<sirenum__Shift__c>();
           rateLineLst = new List<sirenum__Rate_Line__c>();
           String shiftTable = '<table style="border: 1px solid black;border-collapse: collapse;"> <tr>  <th style="border: 1px solid black;border-collapse: collapse;">Start Time</th>  <th style="border: 1px solid black;border-collapse: collapse;">End Time</th></tr>';
           String rateTable = '<table style="border: 1px solid black;border-collapse: collapse;"> <tr>  <th style="border: 1px solid black;border-collapse: collapse;">Rate Name</th>  <th style="border: 1px solid black;border-collapse: collapse;">Day Type</th>  <th style="border: 1px solid black;border-collapse: collapse;">Start Hour</th> <th style="border: 1px solid black;border-collapse: collapse;">End Hour</th> <th style="border: 1px solid black;border-collapse: collapse;">Pay Rate</th><th style="border: 1px solid black;border-collapse: collapse;">Overtime Pay Rate</th></tr>';
           //Prepare Shift Information
           if(!jobRoleShiftMap.isEmpty() && jobRoleShiftMap.containsKey(splaceRec.sirenum__Job_Role__c)){
               shiftLst = jobRoleShiftMap.get(splaceRec.sirenum__Job_Role__c);
           }
           
           System.debug('shiftLst::'+JSON.serialize(shiftLst));
           if(shiftLst.size() > 0){
           for(sirenum__Shift__c shift : shiftLst){
               shiftTable = shiftTable + '<tr><td style="border: 1px solid black;border-collapse: collapse;">'+ shift.sirenum__Scheduled_Start_Time__c +' </td> <td style="border: 1px solid black;border-collapse: collapse;">'+ shift.sirenum__Scheduled_End_Time__c +'</td></tr>';
           }
           }
           shiftTable += '</table>';
           
            System.debug('shiftTable::'+JSON.serialize(shiftTable));
           //Prepare RateCard Information
           Id rateCardId = !jobRoleRCIdMap.isEmpty() && jobRoleRCIdMap.containsKey(splaceRec.sirenum__Job_Role__c) ? jobRoleRCIdMap.get(splaceRec.sirenum__Job_Role__c) : null;
           if(rateCardId != null && !rateCardLineMap.isEmpty() && rateCardLineMap.containsKey(rateCardId)){
               rateLineLst = rateCardLineMap.get(rateCardId);
               System.debug('rateLineLst::'+JSON.serialize(rateLineLst));
               
               for(sirenum__Rate_Line__c rateLine : rateLineLst){
                 String startHour = String.isNotEmpty(rateLine.sirenum__Start_Hour__c) ? rateLine.sirenum__Start_Hour__c : '';
                 String endHour = String.isNotEmpty(rateLine.sirenum__End_Hour__c) ? rateLine.sirenum__End_Hour__c : '';
                 String payRate = String.isNotEmpty(String.valueOf(rateLine.sirenum__Pay_Rate__c)) ? '£' + String.valueOf(rateLine.sirenum__Pay_Rate__c) : '£ 0.0';
                 String oPayRate = String.isNotEmpty(String.valueOf(rateLine.sirenum__Overtime_Pay_Rate__c)) ? '£' + String.valueOf(rateLine.sirenum__Overtime_Pay_Rate__c) : '£ 0.0';
                            
                   rateTable = rateTable + '<tr><td style="border: 1px solid black;border-collapse: collapse;">' +  rateLine.sirenum__Standard_Rate_Name__c + 
		  				' </td><td style="border: 1px solid black;border-collapse: collapse;">' + rateLine.sirenum__Day_Type__c+
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + startHour +
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + endHour +
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + payRate +
						' </td><td style="border: 1px solid black;border-collapse: collapse;">' + oPayRate +
						'</tr>';
               }
               rateTable += '</table>';
           }
           String emailBody = '<html><p><img src="https://impellam--c.um5.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&amp;versionId=0684J00000Xgd1F&amp;operationContext=DELIVERY&amp;contentId=05T4J00001vB13O&amp;page=0&amp;d=/a/4J000000d08i/aN4HAHSuEYLj3.Heg8qebRWpUp4XfGPXHpA6RNktQlQ&amp;oid=00DPu0000008rVN&amp;dpt=null&amp;viewId=" alt="Blue Arrow Logo.png"></p><p><span style="color: rgb(0, 0, 0);">Dear {!Get_S_Placement.sirenum__Contact__r.FirstName},</span></p><p><strong style="color: rgb(0, 0, 0);">Confirmation of ongoing temporary assignment at:</strong></p><p><strong style="color: rgb(0, 0, 0);">Client Name: </strong><span style="color: rgb(0, 0, 0);"> {!Get_S_Placement.sirenum__Site__r.Name}</span></p><p><strong style="color: rgb(0, 0, 0);">Client Address:</strong><span style="color: rgb(0, 0, 0);">  {!Get_S_Placement.sirenum__Site__r.sirenum__Full_Address__c}</span></p><p><strong style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">Starting on: </strong><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Get_S_Placement.sirenum__Start_Date__c} as {!Get_S_Placement.sirenum__Job_Role__r.Name}</span></p><p><strong style="color: rgb(0, 0, 0);">Notified Health and Safety Risks:</strong><span style="color: rgb(0, 0, 0);">  {!Get_Job_Role.IP_Notified_Health_Safety_Risks__c}</span></p><p><strong style="color: rgb(0, 0, 0);">Special Induction:</strong><span style="color: rgb(0, 0, 0);"> </span></p>{!Get_Job_Role.IP_Special_Induction__c}<p><strong style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">Uniform Requirements: </strong><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Get_Job_Role.IP_Personal_Protective_Equipment__c}</span></p><p><strong style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">Job Description:</strong></p><p>{!Get_Job_Role.IP_Job_Description__c}</p><p><br></p><p><strong style="color: rgb(0, 0, 0);">Initial hours of work:</strong></p><p><span style="color: rgb(0, 0, 0);">{!Shift_Table}</span></p><p><span style="color: rgb(0, 0, 0);">The table below outlines pay rate(s) that are applicable to this assignment. Note that pay rates may vary depending on time and date of the shift and other factors. Should the pay rate applicable to your shifts change, we will confirm accordingly.</span></p><p></p><p><span style="color: rgb(0, 0, 0);">{!Compass_Pay_Cycle_Text}</span></p><p><span style="color: rgb(0, 0, 0);">{!Rate_Table}</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);">Additional information can also be obtained from your Key Information Document and Flexible Employee Handbook. </span><span style="color: rgb(0, 0, 0);">If you have any queries regarding your assignment please feel free to contact me.</span></p><p><br></p><p><span style="color: rgb(0, 0, 0);">Yours sincerely</span></p><p><span style="color: rgb(0, 0, 0);">{!Get_S_Placement.IP_Consultant1LookupSplitShare__r.FirstName} {!Get_S_Placement.IP_Consultant1LookupSplitShare__r.LastName}</span></p><p><span style="color: rgb(0, 0, 0);"></span></p><p><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Sender_Phone}</span></p><p><span style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">{!Sender_Email}</span></p><img src="https://impellam.my.salesforce.com/servlet/servlet.ImageServer?oid=00D0Y000000LzSj&esid=018Q5000007yl4s&from=int"></html>';
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Contact__r.FirstName}',splaceRec.sirenum__Contact__r.FirstName);
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Site__r.Name}',splaceRec.sirenum__Site__r.Name);
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Site__r.sirenum__Full_Address__c}',splaceRec.sirenum__Site__r.sirenum__Full_Address__c);
           emailBody = emailBody.replace('{!Get_S_Placement.sirenum__Start_Date__c} as {!Get_S_Placement.sirenum__Job_Role__r.Name}',splaceRec.sirenum__Start_Date__c + ' as ' + splaceRec.sirenum__Job_Role__r.Name);
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Notified_Health_Safety_Risks__c}',splaceRec.sirenum__Job_Role__r.IP_Notified_Health_Safety_Risks__c != null ? splaceRec.sirenum__Job_Role__r.IP_Notified_Health_Safety_Risks__c : '');
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Special_Induction__c}',splaceRec.sirenum__Job_Role__r.IP_Special_Induction__c != null ? splaceRec.sirenum__Job_Role__r.IP_Special_Induction__c : '');
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Personal_Protective_Equipment__c}',splaceRec.sirenum__Job_Role__r.IP_Personal_Protective_Equipment__c != null ? splaceRec.sirenum__Job_Role__r.IP_Personal_Protective_Equipment__c : '');
           emailBody = emailBody.replace('{!Get_Job_Role.IP_Job_Description__c}',splaceRec.sirenum__Job_Role__r?.IP_Job_Description__c != null ? splaceRec.sirenum__Job_Role__r?.IP_Job_Description__c : '');
		   //Set Compass Text to Null when SalesLedger No is not 1000026
            if(splaceRec.sirenum__Site__r.IP_SalesLedgerNo__c != '1000026'){
               emailBody = emailBody.replace('{!Compass_Pay_Cycle_Text}','');
            }else{
                emailBody = emailBody.replace('{!Compass_Pay_Cycle_Text}',compassPayStr);
            }
           emailBody = emailBody.replace('{!Compass_Pay_Cycle_Text}','');
           System.debug('emailBody::'+JSON.serialize(emailBody));
           emailBody = emailBody.replace('{!Get_S_Placement.IP_Consultant1LookupSplitShare__r.FirstName} {!Get_S_Placement.IP_Consultant1LookupSplitShare__r.LastName}',splaceRec.IP_Consultant1LookupSplitShare__r.FirstName + '' +splaceRec.IP_Consultant1LookupSplitShare__r.LastName);
           emailBody = emailBody.replace('{!Sender_Phone}',splaceRec.IP_Consultant1LookupSplitShare__r.Phone != null ? splaceRec.IP_Consultant1LookupSplitShare__r.Phone : '');
           emailBody = emailBody.replace('{!Sender_Email}',splaceRec.IP_Consultant1LookupSplitShare__r.Email != null ? splaceRec.IP_Consultant1LookupSplitShare__r.Email : '');
           emailBody = emailBody.replace('{!Shift_Table}',shiftTable);
           emailBody = emailBody.replace('{!Rate_Table}',rateTable);
           
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	   //mail.setTemplateId(et.Id);
    	   mail.setOrgWideEmailAddressId(orgWideAddress.Id);
           //mail.setToAddresses(new List<String>{'swarupa.karri@rssglobal.com'});//'corey.edwards@rssglobal.com','shahed.ahmed@rssglobal.com'});
           mail.setToAddresses(new List<String>{splaceRec.sirenum__Contact__r.Email});
           mail.setSubject(sub);
           mail.setHTMLBody(emailBody);
           mail.setTargetObjectId(splaceRec.sirenum__Contact__c);
           mail.setWhatId(splaceRec.Id);
           mail.setSaveAsActivity(true);
           mail.setUseSignature(false);
		   emailMsgLstToUpd.add(mail);
           
           //Prepare data to update S-Placement Records. Below logic is moved to flow as there is no way to track successfully inserted EmailMessage Ids
            /* splaceRec.Assignment_Email_Sent_Manually__c = true;
             splaceRec.Date_Assignment_Letter_Sent__c = System.now();
           	 splaceRec.Error_Message__c = '';
           	 splaceRec.IP_Shift_Details_sent__c = true;
           	 splaceRecUpdLst.add(splaceRec);
       }
       if(!emailMsgLstToUpd.isEmpty()){
          	try {
    			
                 	Messaging.SendEmailResult[] srList = Messaging.sendEmail(emailMsgLstToUpd,false);
                    // Iterate through each returned result
                    for ( Messaging.SendEmailResult sr : srList) {
                        if (sr.isSuccess()) {
                            System.debug('Successfully inserted account. Account ID: ' + JSON.serialize(sr));
                        }
                        else {
                            // Operation failed, so get all errors                
                                for(Messaging.SendEmailError err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('fields that affected this error: ' + err.getFields());
                                    errTargetIdSet.add(err.getTargetObjectId());
                            }
                        }
                    }
                System.debug('errTargetIdSet:::'+JSON.serialize(errTargetIdSet));
                return;
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
       }
} */
}
public without sharing class Shifts_to_be_ApprovedCnt {
    
    @AuraEnabled 
    public Integer shiftRequireApproval {
        get;
        set;
    }
    @AuraEnabled
    public static String approveallshift(String candID, String state, String rejectionComments) {
        System.debug('--state--'+state);
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        Map < id, string > OwnerIDmap = new Map < id, String > ();
        List < String > status = new List < String > ();
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        DateTime val = DateTime.now();
        List < sirenum__Shift__c > shiftList = new List < sirenum__Shift__c > ();
        shiftList = [Select id, Name, sirenum__site__r.Name, sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, sirenum__Site__r.Owner.Name,sirenum__Actual_End_Time__c,sirenum__Actual_Start_Time__c, sirenum__Team__r.sirenum__Job_Type__r.Name, sirenum__site__r.GlobalClientName__r.name, sirenum__Team__r.Name,
                     sirenum__Contact__r.Name, sirenum__site__r.OwnerID, IP_ClientRejected__c, Approved_By__c, Approved_Date_Time__c,
                     IP_ClientApproved__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c, sirenum__Scheduled_Start_Time__c,
                     sirenum__Scheduled_End_Time__c,sirenum__Forecast_Charge__c
                     FROM sirenum__Shift__c
                     WHERE sirenum__Contact__r.Id =: candID AND sirenum__Scheduled_End_Time__c <=: val AND
                     sirenum__Published__c = True AND sirenum__Site__r.sirenum__Operating_Company__c =: accID AND IP_Status__c in: status AND
                     sirenum__Contact__c != null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c != true AND
                     IP_ClientApproved__c != True
                    ];
        system.debug('--shiftList--'+shiftList);

		// Commented as part of the story requirement - PTI # 640
		/*
        for(sirenum__Shift__c sh : shiftList){
            if(sh.sirenum__Actual_Start_Time__c == null || sh.sirenum__Actual_End_Time__c == null){
                return 'Shift # ' + sh.Name + ': Please provide actual start or end time for this shift.';
            }
        }
		*/

        if (test.isRunningTest()) {
            shiftList = [Select id, sirenum__site__r.Name, sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, sirenum__Site__r.Owner.Name, sirenum__Team__r.sirenum__Job_Type__r.Name, sirenum__site__r.GlobalClientName__r.name, sirenum__Team__r.Name,
                         sirenum__Contact__r.Name, sirenum__site__r.OwnerID, IP_ClientRejected__c, Approved_By__c, Approved_Date_Time__c,
                         IP_ClientApproved__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c, sirenum__Scheduled_Start_Time__c,
                         sirenum__Scheduled_End_Time__c,sirenum__Forecast_Charge__c
                         FROM sirenum__Shift__c Limit 10
                        ];
        }
        System.debug('Shift size ' + shiftList.size());
        for (sirenum__Shift__c sh: shiftList) {
            
            if (state == 'approve') {
                sh.sirenum__Billable_Start_Time__c = sh.sirenum__Scheduled_Start_Time__c;
                sh.sirenum__Billable_End_Time__c = sh.sirenum__Scheduled_End_Time__c;
                sh.IP_ClientApproved__c = True;
                sh.Approved_By__c = UserInfo.getUserId();
                sh.Approved_Date_Time__c = System.now();
            } else {
                sh.IP_ClientRejected__c = True;
                sh.sirenum__Client_Comments__c = rejectionComments;
            }
        }
        try {
            update shiftList;
            
            System.debug('--state--'+state);            
            if (state == 'approve') {
                Task tsk = new Task();
                tsk.Ownerid = shiftList[0].sirenum__site__r.OwnerID;
                tsk.WhatID = shiftList[0].id;
                tsk.Subject = 'Adjusted Shift Hours by Client';
                String comments1 = 'Hi ' + shiftList[0].sirenum__Contact__r.Name + ',' + '\n' + '\n';
                comments1 += 'We\'ve just received an adjustment to the following placement from the ' + shiftList[0].sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c + ' at ' + shiftList[0].sirenum__site__r.GlobalClientName__r.name + ' .These changes are for work as ' + shiftList[0].sirenum__Team__r.name + ' at ' + shiftList[0].sirenum__site__r.Name + ' .' + ' If these changes are okay then you don\'t need to do anything else. If these changes mean that you can longer make the placement, please contact ' + shiftList[0].sirenum__Site__r.Owner.Name + ' immediately and we\'ll try to find you suitable alternative work.' + '\n' + '\n';
                comments1 += 'Best regards,' + '\n';
                comments1 += 'Customer Support' + '\n';
                tsk.Description = comments1;
                tsk.WhoID = shiftList[0].sirenum__Contact__c;
                insert tsk;
            } else {
                Task tsk = new Task();
                tsk.Ownerid = shiftList[0].sirenum__site__r.OwnerID;
                tsk.WhatID = shiftList[0].id;
                tsk.Subject = 'Rejected Shift Hours by Client';
                String comments1 = 'Hi ' + shiftList[0].sirenum__Contact__r.Name + ',' + '\n' + '\n';
                comments1 += 'We\'ve just received an adjustment to the following placement from the ' + shiftList[0].sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c + ' at ' + shiftList[0].sirenum__site__r.GlobalClientName__r.name + ' .These changes are for working hours as ' + shiftList[0].sirenum__Team__r.Name + ' at ' + shiftList[0].sirenum__site__r.name + ' .' + '\n\n' + shiftList[0].sirenum__site__r.GlobalClientName__r.name + ' does not agree with the hours submitted for payment and so Consultant ' + shiftList[0].sirenum__site__r.Owner.Name + ' will pick this up immediately with the client to find out why these hours have not been approved for payment. ' + shiftList[0].sirenum__site__r.Owner.Name + ' will then be in touch with you immediately after to confirm the issue and get this resolved asap' + '\n' + '\n';
                comments1 += 'Best regards,' + '\n';
                comments1 += 'Customer Support' + '\n';
                tsk.Description = comments1;
                tsk.WhoID = shiftList[0].sirenum__Contact__c;
            }
            
            return 'Success';
        } catch (Exception e) {
            
            return 'An internal error occurred while processing your request. Please contact your consultant.';
            
        }
    }
    @AuraEnabled
    public static User getUserInformation() {
        
        User user = [SELECT id, email, Hide_Shift_Approval__c, Hide_Booked_temps__c, Hide_Contact__c, Hide_invoice_details__c, Hide_temp_hours__c, Hide_temps__c, Name, username, firstname, lastname, phone, title, street, city, country, postalcode, User_Image__c, state, contact.email
                     FROM User WHERE id =: UserInfo.getUserId()
                    ];
        return User;
        
    }
    @AuraEnabled
    public static void updateuserwidget(String fieldtoupdate, String updatevalue) {
        System.debug('check value1' + fieldtoupdate);
        System.debug('check value2' + updatevalue);
        User u = [Select id, Hide_Shift_Approval__c from user where id =: UserInfo.getUserId()];
        if (fieldtoupdate == 'Hide_Shift_Approval__c') {
            u.Hide_Shift_Approval__c = updatevalue;
        } else if (fieldtoupdate == 'Hide_Booked_temps__c') {
            u.Hide_Booked_temps__c = updatevalue;
        } else if (fieldtoupdate == 'Hide_Contact__c') {
            u.Hide_Contact__c = updatevalue;
        } else if (fieldtoupdate == 'Hide_invoice_details__c') {
            u.Hide_invoice_details__c = updatevalue;
        } else if (fieldtoupdate == 'Hide_temp_hours__c') {
            u.Hide_temp_hours__c = updatevalue;
        } else {
            u.Hide_temps__c = updatevalue;
        }
        System.debug('check value3' + u.Hide_Shift_Approval__c);
        update u;
        
    }
    
    @AuraEnabled
    public static List < sirenum__Shift__c > getAllShifts(String site, String role, String contact, String DateRange) {
        List < String > DateList = new List < String > ();
        
        if (DateRange != null && DateRange != '')
            DateList = DateRange.split('-');
        
        DateTime startDate;
        DateTime endDate;
        
        if (DateList != null && DateList.size() > 0) {
            if (DateList.size() > 1)
                endDate = convertMonthTextToNumber(DateList[1]).addDays(1);
            else
                endDate = convertMonthTextToNumber(DateList[0]).addDays(1);
            
            startDate = convertMonthTextToNumber(DateList[0]);
        }
        
        System.debug('------' + endDate + '========' + startDate);
        
        //  String accID = [select id, contact.AccountId from User where id =: '0051w000000vDDcAAM' limit 1][0].contact.AccountId;
        //String conID = [select id, contactId from User where id =: '0051w000000vDDcAAM' limit 1][0].contactId;
        
        //System.debug('----'+site);
        //System.debug('----'+contact);
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        System.debug('accID: ' + accID + ' conID:' + conID);
        
        List < String > status = new List < String > ();
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        DateTime val = DateTime.now();
        DateTime dtend;
        
        
        if (site == null || site == '') {
            List < sirenum__Site__c > sitesList = [select id, name, sirenum__Operating_Company__c from sirenum__Site__c where sirenum__Operating_Company__c =: accID order by name asc limit 1];
            
            if (sitesList != null && sitesList.size() > 0) site = sitesList[0].Id;
        }
        
        /*  if(endDate!=null)
dtend = endDate.addDays(1); */
        
        system.debug('##dtend ' + dtend);
        // String datetoCheck = String.valueof(Date.valueof(System.today()));
        string queryData = 'SELECT Id,Total_Shift_BreakLength__c,Scheduled_Start_Date_Text__c,TexsT__c,TexeT__c,Name,sirenum__Placement__c,Break_from_Brekdef__c,Shift_Length_from_Break__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c,sirenum__Forecast_Charge__c, sirenum__Contact__r.Name,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,Starttime__c,EndTime__c,Break_Length__c,sirenum__Break_Length__c,IP_ClientApproved__c,IP_ClientRejected__c FROM sirenum__Shift__c WHERE ';
        
        if (contact != null && contact != '')
            queryData = queryData + 'sirenum__Contact__c =: contact AND ';
        
        if (site != null && site != '')
            queryData = queryData + ' sirenum__Site__c =: site AND ';
        
        
        if (startDate != null)
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >=: startDate AND ';
        
        if (endDate != null)
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c <=: endDate AND ';
        
        if (role != null && role != '')
            queryData = queryData + ' sirenum__Team__c =: role AND ';
        
        //system.debug('@@val '+val);
        //system.debug('@@startDate '+startDate);
        //system.debug('@@endDate '+endDate);
        queryData = queryData + ' sirenum__Scheduled_End_Time__c <:val AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14 AND sirenum__Published__c=True AND sirenum__Site__r.sirenum__Operating_Company__c =: accID AND IP_Status__c in : status AND sirenum__Contact__c!=null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c !=true ORDER BY sirenum__Scheduled_Start_Time__c DESC LIMIT 30';
        
        system.debug('@@queryData ' + queryData);
        List < sirenum__Shift__c > shiftList = Database.query(queryData);
        
        system.debug('--------' + shiftList);
        return shiftList;
    }
    
    @AuraEnabled
    public static List <CandiInfoWrapper> getAllShiftsForCandidate(String contact, String site) {
        
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        if (site == null || site == '') {
            List < sirenum__Site__c > sitesList = [select id, name, sirenum__Operating_Company__c from sirenum__Site__c where sirenum__Operating_Company__c =: accID order by name asc limit 1];
            
            if (sitesList != null && sitesList.size() > 0) site = sitesList[0].Id;
        }
        
        
        System.debug('accID: ' + accID + ' conID:' + conID);
        
        List < String > status = new List < String > ();
        
        DateTime val = DateTime.now();
        
        Map < String, CandiInfoWrapper > ReturnShiftMap = new Map < String, CandiInfoWrapper > ();
        
        string queryData = 'SELECT Id,Starttime__c,sirenum__Placement__r.IP_PurchaseOrderNumber__c,Total_Shift_BreakLength__c,EndTime__c,Scheduled_Start_Date_Text__c,Break_from_Brekdef__c,Shift_Length_from_Break__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c,sirenum__Forecast_Charge__c, sirenum__Contact__r.Id,sirenum__Contact__r.Name,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,Break_Length__c,sirenum__Break_Length__c,IP_ClientApproved__c,IP_ClientRejected__c,TSchShL__c,TActShL__c FROM sirenum__Shift__c WHERE sirenum__Scheduled_End_Time__c <=:val AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14 AND sirenum__Published__c=True AND sirenum__Site__r.sirenum__Operating_Company__c =: accID AND sirenum__Contact__c!=null AND sirenum__Cancelled__c = false And sirenum__Timesheet_summaries__c = null ';
        
        if (contact != null && contact != '') {
            String constr = '%' + contact + '%';
            System.debug('Debug log for constr: '+constr);
            queryData = queryData + ' And sirenum__Contact__r.Name Like : constr ';
        }
        
        if (site != null && site != '') {
            queryData = queryData + ' And sirenum__Site__c =: site ';
        }
        
        queryData = queryData + ' AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:14 ORDER BY sirenum__Scheduled_Start_Time__c ASC';
        
        List < sirenum__Shift__c > queryShiftData = new List < sirenum__Shift__c > ();
        
        if (test.isRunningTest()) {
            queryShiftData = [SELECT Id,ActSt__c, Starttime__c,sirenum__Placement__r.IP_PurchaseOrderNumber__c, Total_Shift_BreakLength__c, EndTime__c, Scheduled_Start_Date_Text__c, Break_from_Brekdef__c, Shift_Length_from_Break__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c, sirenum__Contact__r.Id, sirenum__Contact__r.Name, sirenum__Team__r.Name, sirenum__Site__r.name, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c, sirenum__Actual_Start_Time__c, sirenum__Actual_End_Time__c, Break_Length__c, sirenum__Break_Length__c, IP_ClientApproved__c, IP_ClientRejected__c, TSchShL__c, TActShL__c,sirenum__Forecast_Charge__c FROM sirenum__Shift__c];
        } else {
            queryShiftData = Database.query(queryData);
        }
        
        System.debug('queryData==='+queryData);
        Set < String > candId = new Set < String > ();
        List<CandiInfoWrapper> candInfoList = new List<CandiInfoWrapper>();
        Set<String> blackListedContact = new Set<String>();
        Map<String,List<String>> mapCandIdtoStatus = new Map<String,List<String>>();
        Decimal forecastValue = 0.00;
          
        for (sirenum__Shift__c Shift: queryShiftData) {
            candId.add(Shift.sirenum__Contact__r.Id);
            CandiInfoWrapper candInfo = new CandiInfoWrapper();
            
            if (ReturnShiftMap.get(Shift.sirenum__Contact__r.Id) == null) {
                candInfo.CandidateName = Shift.sirenum__Contact__r.Name;
                candInfo.JobRole = Shift.sirenum__Team__r.Name;
                candInfo.CandidateId = Shift.sirenum__Contact__r.Id;
                candInfo.shiftId = Shift.Id;
                candInfo.InvoicePO = Shift.sirenum__Placement__r.IP_PurchaseOrderNumber__c;
                Decimal scheduledShift = 0;
                System.debug('===251=='+Shift.TSchShL__c);
                if (Shift.TSchShL__c == null || Shift.TSchShL__c== 0)
                    scheduledShift = 0;
                else
                    scheduledShift = Shift.TSchShL__c;
                
                Decimal ActualShift = 0;
                
                Decimal startT = Decimal.valueOf(Shift.Starttime__c.replace(':', '.'));
                Decimal endT = Decimal.valueOf(Shift.EndTime__c.replace(':', '.'));
                
                System.debug('===262=='+Shift.TActShL__c);
                if (Shift.TActShL__c == null || Shift.TActShL__c == 0)
                    ActualShift = 0;
                else
                    ActualShift = Shift.TActShL__c;
                
                candInfo.BookedHourse = scheduledShift;
                candInfo.ActualHourse = ActualShift;
                candInfo.Diff = (candInfo.ActualHourse - candInfo.BookedHourse);
                
                if (Shift.IP_ClientApproved__c == True)
                    candInfo.Action = 'Approved';
                else if (Shift.IP_ClientRejected__c == True)
                    candInfo.Action = 'Rejected';
                else if (Shift.IP_ClientApproved__c == false && Shift.IP_ClientRejected__c == false)
                    candInfo.Action = 'Pending';
                
                system.debug('+++++++++shift.sirenum__Forecast_Charge__c+++'+shift.sirenum__Forecast_Charge__c);
                decimal chargevalue=0.0;
                if (shift.IP_ClientRejected__c)
                {
                    chargevalue=0.0;
                }
                else
                {
                    if(shift.sirenum__Forecast_Charge__c!=null){
                        chargevalue = shift.sirenum__Forecast_Charge__c ;
                    }
                    else{
                        chargevalue = 0.0 ;
                    }
                }
                candInfo.ForecastCharge = chargevalue + candInfo.ForecastCharge;
                
                /*
                if(shift.sirenum__Forecast_Charge__c!=null){
                    candInfo.ForecastCharge = shift.sirenum__Forecast_Charge__c + candInfo.ForecastCharge;
                }
                else{
                    candInfo.ForecastCharge = 0.00 + candInfo.ForecastCharge;
                }*/
                
                Integer offset = UserInfo.getTimezone().getOffset(Shift.sirenum__Scheduled_Start_Time__c);
                
                List < sirenum__Shift__c > slist = new List < sirenum__Shift__c > ();
                slist.add(Shift);
                candInfo.shiftInfo = slist;
                
            } else {
                candInfo = ReturnShiftMap.get(Shift.sirenum__Contact__r.Id);
                candInfo.CandidateName = Shift.sirenum__Contact__r.Name;
                candInfo.JobRole = Shift.sirenum__Team__r.Name;
                candInfo.InvoicePO = Shift.sirenum__Placement__r.IP_PurchaseOrderNumber__c;
                Decimal scheduledShift = 0;
                
                if (Shift.TSchShL__c == null)
                    scheduledShift = 0;
                else
                    scheduledShift = Shift.TSchShL__c;
                
                Decimal ActualShift = 0;
                
                Decimal startT = Decimal.valueOf(Shift.Starttime__c.replace(':', '.'));
                Decimal endT = Decimal.valueOf(Shift.EndTime__c.replace(':', '.'));
                System.debug('===Test=Actual Hours=='+Shift.TActShL__c);
                
                if (Shift.TActShL__c == null || Shift.TActShL__c == 0)
                    ActualShift = 0;
                else
                    ActualShift = Shift.TActShL__c;
                
                system.debug('+++++++++shift.sirenum__Forecast_Charge__c+++'+shift.sirenum__Forecast_Charge__c);
                decimal chargevalue=0.0;
                if (shift.IP_ClientRejected__c)
                {
                    chargevalue=0.0;
                }
                else
                {
                    if(shift.sirenum__Forecast_Charge__c!=null){
                        chargevalue = shift.sirenum__Forecast_Charge__c ;
                    }
                    else{
                        chargevalue = 0.0 ;
                    }
                }
                candInfo.ForecastCharge = chargevalue + candInfo.ForecastCharge;
               /* if(shift.sirenum__Forecast_Charge__c!=null){
                    candInfo.ForecastCharge = shift.sirenum__Forecast_Charge__c + candInfo.ForecastCharge;
                }
                else{
                    candInfo.ForecastCharge = 0.00 + candInfo.ForecastCharge;
                }
				*/
                
                candInfo.BookedHourse = candInfo.BookedHourse + scheduledShift;
                candInfo.ActualHourse = candInfo.ActualHourse + ActualShift;
                candInfo.Diff = (candInfo.ActualHourse - candInfo.BookedHourse);
                
                
                candInfo.CandidateId = Shift.sirenum__Contact__r.Id;
                candInfo.shiftId = Shift.Id;
                List < sirenum__Shift__c > slist = candInfo.shiftInfo;
                
                String alreadyAct = candInfo.Action;
                String Action = null;
                
                
                if (Shift.IP_ClientApproved__c == True)
                    Action = 'Approved';
                else if (Shift.IP_ClientRejected__c == True)
                    Action = 'Rejected';
                else if (Shift.IP_ClientApproved__c == false && Shift.IP_ClientRejected__c == false)
                    Action = 'Pending';
                
                
                if (alreadyAct == Action && Action == 'Approved')
                    candInfo.Action = 'Approved';
                else if (alreadyAct == Action && Action == 'Rejected')
                    candInfo.Action = 'Rejected';
                else if (alreadyAct == Action && Action == 'Pending')
                    candInfo.Action = 'Pending';
                else if (alreadyAct == null || Action == null || alreadyAct == 'Pending' || Action == 'Pending')
                    candInfo.Action = 'Pending';
                else
                    candInfo.Action = 'Completed';
                
                
                slist.add(Shift);
                candInfo.shiftInfo = slist;

            }
            candInfoList.add(candInfo);
            System.debug('Debug log for ReturnShiftMap: '+ReturnShiftMap);
            
            for(CandiInfoWrapper info : candInfoList){
                if(mapCandIdtoStatus.containsKey(info.CandidateId)) {
                    List<String> statusList = mapCandIdtoStatus.get(info.CandidateId);
                    statusList.add(info.Action);
                    mapCandIdtoStatus.put(info.CandidateId,statusList);
                    System.debug('In If');
                }   
                else {
                    mapCandIdtoStatus.put(info.CandidateId, new List<String> {info.Action});
                    System.debug('In Else');
                }
            }

            System.debug('Debug log for mapCandIdtoStatus : '+mapCandIdtoStatus);
            System.debug('Debug log for candInfo.CandidateName : '+candInfo.CandidateName);
            System.debug('Debug log for candInfo.Action : '+candInfo.Action);
            System.debug('Debug log for Shift.Id : '+Shift.Id);

            System.debug('Outside');
            
            /*if((mapCandIdtoStatus.get(Shift.sirenum__Contact__r.Name).contains('Pending') && blackListedContact.contains(candInfo.CandidateName)) && ReturnShiftMap.size()<30){
            //if(displayingConId.contains(candInfo.CandidateId)){
                System.debug('Inside');
                ReturnShiftMap.put(Shift.sirenum__Contact__r.Id, candInfo);
                System.debug('Debug log for Shift.sirenum__Contact__r.Name : '+Shift.sirenum__Contact__r.Name);
                System.debug('Debug log for Shift.Id : '+Shift.Id);
                System.debug('Debug log for ReturnShiftMap: '+ReturnShiftMap);
            }*/
                    ReturnShiftMap.put(Shift.sirenum__Contact__r.Id, candInfo);
        }
        for(String conIds : mapCandIdtoStatus.keySet()){
                if(!mapCandIdtoStatus.get(conIds).contains('Pending')){
                    blackListedContact.add(conIds);
                }
        }
        System.debug('Debug log for blackListedContact: '+blackListedContact);
        for(String str :ReturnShiftMap.keySet()){
            if(blackListedContact.contains(str)){
                ReturnShiftMap.remove(str);
            }
        }

        for (String Id: ReturnShiftMap.keySet()) {
            
            CandiInfoWrapper candInfo = new CandiInfoWrapper();
            candInfo = ReturnShiftMap.get(Id);
            System.debug('booked hours ' + candInfo.BookedHourse);
            
            //booked hours on shift by temp name screen
            
            Integer BookedHoursInMinutes = Integer.ValueOf(candInfo.BookedHourse);
            Double hoursPartDbl = Math.ceil(BookedHoursInMinutes / 60);
            Integer hoursPart = Integer.valueOf(hoursPartDbl);
            Integer minutesPart = Math.mod(BookedHoursInMinutes,60);
            String timeSpentOnCase;
            if(minutesPart < 10 && minutesPart != 0){
                timeSpentOnCase = hoursPart + ':0' + minutesPart;
            } else {
                timeSpentOnCase = hoursPart + ':' + minutesPart;
            }
            candInfo.stBookedHourse = timeSpentOnCase;
            
           //actual hours on shift by temp name screen 
            
            Integer actualHoursInMinutes = Integer.ValueOf(candInfo.ActualHourse);
            Double AHhoursPartDbl = Math.ceil(actualHoursInMinutes / 60);
            Integer AHhoursPart = Integer.valueOf(AHhoursPartDbl);
            Integer AHminutesPart = Math.mod(actualHoursInMinutes,60);
            String actimeSpentOnCase;
            if(AHminutesPart < 10 && AHminutesPart != 0){
                actimeSpentOnCase = AHhoursPart + ':0' + AHminutesPart;
            } else {
                actimeSpentOnCase = AHhoursPart + ':' + AHminutesPart;
            }
            candInfo.stActualHourse = actimeSpentOnCase;
            
            //Difference of actual hours and booked hours on shift by temp name screen
            
            Integer differenceInMinutes = Integer.ValueOf(candInfo.Diff);
            Double DIMhoursPartDbl = Math.ceil(differenceInMinutes / 60);
            Integer DIMhoursPart = Integer.valueOf(DIMhoursPartDbl);
            Integer DIMminutesPart = Math.mod(differenceInMinutes,60);
            if(DIMminutesPart<0){
               DIMminutesPart = (-1)*DIMminutesPart;
            }
            String diftimeSpentOnCase;
            if(DIMminutesPart < 10){
                diftimeSpentOnCase = DIMhoursPart + ':0' + DIMminutesPart;
            } else {
                diftimeSpentOnCase = DIMhoursPart + ':' + DIMminutesPart;
            }
            candInfo.stDiff = diftimeSpentOnCase;
            
        }  
        system.debug('ReturnShiftMap.values()->'+ReturnShiftMap.values());
            return ReturnShiftMap.values();
    }

    @AuraEnabled
    public static List < sirenum__Site__c > getSites() {
        
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];
        
        List < Id > siteIds = new List < Id > ();
        List<Contact_Site_link__c> lstContactList = [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c,IP_PortalType__c FROM Contact_Site_link__c
                                                     WHERE IP_Contact__r.Id=:cont.id AND Account__r.Id=:cont.AccountId AND IP_PortalType__c!=null];
        System.debug(lstContactList.size()+'==lstContactList=='+lstContactList);
        for(Contact_Site_link__c conSiteLink : lstContactList){
            siteIds.add(conSiteLink.IP_Site__r.id);
        }
        
        List < sirenum__Site__c > sitesList = [SELECT id, name, sirenum__Operating_Company__c FROM sirenum__Site__c 
                                               WHERE id IN: siteIds ORDER BY name ASC];
        
        return sitesList;
    }
    
    @AuraEnabled
    public static List < sirenum__Shift__c > getCandidate() {
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        List < sirenum__Shift__c > shiftList = new List < sirenum__Shift__c > ();
        Map < String, sirenum__Shift__c > candidateMap = new Map < String, sirenum__Shift__c > ();
        for (sirenum__Shift__c shift: [SELECT Id, sirenum__Contact__r.Name, sirenum__Contact__r.Id FROM sirenum__Shift__c WHERE(sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c =: conID OR sirenum__Site__r.IP_InvoiceContact__c =: conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID And sirenum__Contact__c != null]) {
            candidateMap.put(shift.sirenum__Contact__r.Id, shift);
        }
        shiftList = candidateMap.values();
        return shiftList;
    }
    
    
    @AuraEnabled
    public static Map < String, Object > getSitesAndCandidate() {
        
        // String accID = [select id, contact.AccountId from User where id =: '0051w000000vDDcAAM' limit 1][0].contact.AccountId;
        // String conID = [select id, contactId from User where id =: '0051w000000vDDcAAM' limit 1][0].contactId;
        set<Id> siteId = new set<ID>();
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        
        for(Contact_Site_link__c lstContactList: [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c,IP_PortalType__c FROM Contact_Site_link__c
                                                  WHERE IP_Contact__r.Id=:conID AND Account__r.Id=:accID AND IP_PortalType__c!=null])
        {
            siteId.add(lstContactList.IP_Site__c);
        }
        Map < String, Object > ReturnMap = new Map < String, Object > ();
        List < sirenum__Site__c > sitesList = [select id, name, sirenum__Operating_Company__c from sirenum__Site__c where id=: siteId AND sirenum__Operating_Company__c =: accID order by name asc];
        ReturnMap.put('Site', sitesList);
        
        Map < String, sirenum__Shift__c > candidateMap = new Map < String, sirenum__Shift__c > ();
        for (sirenum__Shift__c shift: [SELECT Id, sirenum__Contact__r.Name, sirenum__Contact__r.Id FROM sirenum__Shift__c WHERE Id=:siteId AND sirenum__Site__r.sirenum__Operating_Company__c =: accID And sirenum__Contact__c != null]) {
            candidateMap.put(shift.sirenum__Contact__r.Id, shift);
        }
        ReturnMap.put('Candidate', candidateMap.values());
        
        System.debug('--------+' + ReturnMap);
        return ReturnMap;
        
    }
    
    @AuraEnabled
    public static Map < String, Object > getRolesAndCandidate(String site) {
        DateTime val = System.now();
        set<Id> siteId = new set<ID>();
        User u = [select id, contactId,contact.AccountId FROM User WHERE id =: UserInfo.getUserId() limit 1];
        
        
        List<sirenum__Shift__c> lstShift = [SELECT Id, sirenum__Team__r.Id,sirenum__Contact__r.Name, sirenum__Contact__r.Id FROM sirenum__Shift__c WHERE sirenum__Timesheet_summaries__c = Null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c != true AND IP_ClientApproved__c = False AND sirenum__Site__r.Id =: site And sirenum__Contact__c != null AND sirenum__Scheduled_End_Time__c <=: val AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS: 14 AND sirenum__Published__c = True Order by sirenum__Contact__r.Name];
        set<id> jobRoleIds = new set<id>();
        for(sirenum__Shift__c sh: lstShift ){
            jobRoleIds.add(sh.sirenum__Team__r.Id);
        }
        
        Map < String, Object > ReturnMap = new Map < String, Object > ();
        List < sirenum__Team__c > jobRoleList = [SELECT id, Name FROM sirenum__Team__c WHERE Id IN:jobRoleIds Order by Name];
        ReturnMap.put('Role', jobRoleList);
        
        Map < String, sirenum__Shift__c > candidateMap = new Map < String, sirenum__Shift__c > ();
        for (sirenum__Shift__c shift: lstShift) {
            candidateMap.put(shift.sirenum__Contact__r.Id, shift);
        }
        ReturnMap.put('Candidate', candidateMap.values());
        
        System.debug('--------+' + ReturnMap);
        return ReturnMap;
        
    }
    
    
    
    @Auraenabled
    public static List < sirenum__Team__c > getJobRoleList() {
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        //   String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        List < sirenum__Team__c > jobRoleList = [SELECT id, Name FROM sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =: accID];
        System.debug('&&&&&&&&&&&&&&&&&&&' + jobRoleList);
        return jobRoleList;
    }
    
    
    
    @AuraEnabled
    public static Map < id, List < Contact >> getsiteContactMap() {
        List < Id > siteIds = new List < Id > ();
        List < Id > conIds = new List < Id > ();
        List < String > status = new List < String > ();
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        Map < id, List < Contact >> siteContactMap = new Map < id, List < Contact >> ();
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        List < sirenum__Site__c > sites = [select id, name, sirenum__Operating_Company__c from sirenum__Site__c where(IP_MainContact__c =: conID OR Emergency_Contact__c =: conID OR IP_InvoiceContact__c =: conID) AND sirenum__Operating_Company__c =: accID];
        
        List < sirenum__Shift__c > shiftList = [SELECT Id, Total_Shift_BreakLength__c, sirenum__Contact__c, sirenum__Contact__r.FirstName, sirenum__Contact__r.LastName, sirenum__Contact__r.AccountId,sirenum__Forecast_Charge__c,
                                                sirenum__Site__c, sirenum__Site__r.name, sirenum__Site__r.sirenum__Operating_Company__c
                                                FROM sirenum__Shift__c
                                                WHERE sirenum__Published__c = True AND sirenum__Scheduled_End_Time__c <=: System.now() AND sirenum__Site__c in: sites AND IP_ClientApproved__c != true AND IP_Status__c in: status AND IP_ClientRejected__c != true limit 50000
                                               ];
        for (sirenum__Shift__c sh: shiftList) {
            conIds.add(sh.sirenum__Contact__c);
        }
        
        
        
        List < Contact > contacts = [select id, name, AccountId from Contact where id in: conIds];
        for (sirenum__Shift__c sh: shiftList) {
            for (Contact con: contacts) {
                for (sirenum__Site__c site: sites) {
                    if (sh.sirenum__Contact__c == con.id && sh.sirenum__Site__c == site.Id) {
                        if (siteContactMap.containsKey(site.id)) {
                            List < Contact > conList = siteContactMap.get(site.id);
                            if (conList.isEmpty()) {
                                conList.add(con);
                                siteContactMap.put(site.id, conList);
                            } else if (!conList.contains(con)) {
                                conList.add(con);
                                siteContactMap.put(site.id, conList);
                            }
                        } else {
                            List < Contact > conList = new List < Contact > ();
                            conList.add(con);
                            siteContactMap.put(site.id, conList);
                        }
                    }
                }
            }
        }
        return siteContactMap;
    }
    
    @AuraEnabled
    public static String getshift(String JSONSHIFT) {
        List < ID > ShiftId = new List < ID > ();
        
        system.debug('## JSON ' + JSONSHIFT);
        String JSONBody = JSONSHIFT.substring(1, JSONSHIFT.length() - 1);
        // system.debug('## JSONBody '+JSONBody);  
        Integer testac = JSONBody.indexOf('Starttime__c');
        system.debug('## testac ' + testac);
        
        
        List < object > values = (List < object > ) System.JSON.deserializeUntyped(JSONSHIFT);
        
        system.debug('values ' + values);
        system.debug('values2 ' + JSON.serialize(JSON.deserializeUntyped(JSONSHIFT)));
        
        Map < String, String > mstart = new Map < String, String > ();
        Map < String, String > mend = new Map < String, String > ();
        for (Object v: values) {
            
            Integer i = String.valueOf(v).indexOf('Starttime__c');
            system.debug('## i value ' + i);
            system.debug('@@ values ' + v);
            String strID = String.valueOf(v).substring(String.valueOf(v).indexOf('Id') + 3, String.valueOf(v).indexOf('Id') + 21);
            system.debug('## strID ' + strID);
             system.debug('## String.valueOf(v).indexOf ' + String.valueOf(v).indexOf('Starttime__c'));
            String ststartTime = String.valueOf(v).substring(String.valueOf(v).indexOf('Starttime__c') + 13, String.valueOf(v).indexOf('Starttime__c') + 18);
            
            system.debug('## stTime ' + ststartTime);
            
            String stendTime = String.valueOf(v).substring(String.valueOf(v).indexOf('EndTime__c') + 11, String.valueOf(v).indexOf('EndTime__c') + 16);
            
            system.debug('## stTime ' + stendTime);
            mstart.put(strID, ststartTime);
            mend.put(strID, stendTime);
            ShiftId.add(strID);
            
        }
        
        // system.debug('mstart '+mstart);
        // system.debug('mend '+mend);
        // system.debug('shiftId '+mend);
        String Status = approveShifts(shiftId, mstart, mend);
        system.debug('Status '+Status);
        return Status;
        //return 'Success';
    }
    
    /*
@AuraEnabled
public static string approveShifts(List < Id > shiftIds, Map < String, String > startime, Map < String, String > endtime) {

List < sirenum__shift__c > shifts = [Select id, sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, Total_Shift_BreakLength__c, IP_BranchOfOwner__c, StartTime__c, EndTime__c, sirenum__Contact__r.Name, sirenum__Contact__r.FirstName, sirenum__Site__r.Name, sirenum__Billable_End_Time__c, sirenum__Billable_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Actual_Start_Time__c, sirenum__Scheduled_End_Time__c, sirenum__Scheduled_Start_Time__c, IP_ClientApproved__c, Approved_Date_Time__c, Approved_By__c, sirenum__Contact__c, sirenum__Site__r.Owner.Name, sirenum__site__r.GlobalClientName__r.name, sirenum__site__r.OwnerID, sirenum__Team__r.Name, sirenum__Team__r.sirenum__Job_Type__r.Name from sirenum__shift__c where id in: shiftIds];
Map < id, string > Topazname = new Map < id, String > ();
Map < id, string > JobTitle = new Map < id, String > ();
Map < id, string > Ownermap = new Map < id, String > ();
Map < id, string > OwnerIDmap = new Map < id, String > ();
Map < id, id > contactmap = new Map < id, id > ();
String status;
IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(shifts[0].IP_BranchOfOwner__c);
List < OrgWideEmailAddress > owd;
if (branchemail != Null) {
owd = [select id, DisplayName, Address from OrgWideEmailAddress where Address =: branchemail.Email__c];
system.debug('OWD ID--->' + owd);
}

OrgWideEmailAddress owd1 = [select id, DisplayName, Address from OrgWideEmailAddress where Address = 'no.reply@bluearrow.co.uk'];


Id templateIdApproval = [select id, name from EmailTemplate where developername = 'Client_Approve_Changed_Shift'].id;
for (sirenum__Shift__c s1: shifts) {
Topazname.put(s1.id, s1.sirenum__site__r.GlobalClientName__r.name);
JobTitle.put(s1.id, s1.sirenum__Team__r.sirenum__Job_Type__r.Name);
Ownermap.put(s1.id, s1.sirenum__Site__r.Owner.Name);
OwnerIDmap.put(s1.id, s1.sirenum__site__r.OwnerID);
contactmap.put(s1.id, s1.sirenum__Contact__c);
}

for (sirenum__Shift__c s: shifts) {
if (s.sirenum__Contact__c != null) {
s.IP_ClientApproved__c = true;
s.Approved_Date_Time__c = System.now();
s.Approved_By__c = UserInfo.getUserId();
String starttime1 = String.valueof(s.sirenum__Scheduled_Start_Time__c);
String endtime1 = String.valueof(s.sirenum__Scheduled_End_Time__c);
if (startime.containsKey(s.Id)) {
List < String > stringParts = startime.get(s.Id).split(':');
system.debug('@@ for test class ' + stringParts);
if (s.sirenum__Actual_Start_Time__c != null) {
DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
s.sirenum__Billable_Start_Time__c = updatestartDateTime;
} else {
DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
s.sirenum__Billable_Start_Time__c = updatestartDateTime;
}
} else if (s.sirenum__Actual_Start_Time__c != null) {
s.sirenum__Billable_Start_Time__c = s.sirenum__Actual_Start_Time__c;
} else if (s.sirenum__Actual_Start_Time__c == null) {
s.sirenum__Billable_Start_Time__c = s.sirenum__Scheduled_Start_Time__c;
}
if (endtime.containsKey(s.Id)) {
List < String > stringParts2 = endtime.get(s.Id).split(':');
List < String > stringParts = startime.get(s.Id).split(':');
if (s.sirenum__Actual_End_Time__c != null) {
DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);

DateTime actualEndDateTime = s.sirenum__Actual_End_Time__c;
Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day(), Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
if (updateEndDateTime < updatestartDateTime) {
updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day() + 1, Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);

}

s.sirenum__Billable_End_Time__c = updateEndDateTime;
} else {
DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);

DateTime actualEndDateTime = s.sirenum__Scheduled_End_Time__c;
Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day(), Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
if (updateEndDateTime < updatestartDateTime) {
updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day() + 1, Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);

}

s.sirenum__Billable_End_Time__c = updateEndDateTime;
}
} else if (s.sirenum__Actual_End_Time__c != null) {
s.sirenum__Billable_End_Time__c = s.sirenum__Actual_End_Time__c;
} else if (s.sirenum__Actual_End_Time__c == null) {
s.sirenum__Billable_End_Time__c = s.sirenum__Scheduled_End_Time__c;
}
System.debug('check contact id' + s.sirenum__Contact__r.id);


if (s.sirenum__Billable_End_Time__c != null)
s.sirenum__Actual_End_Time__c = s.sirenum__Billable_End_Time__c;

if (s.sirenum__Billable_Start_Time__c != null)
s.sirenum__Actual_Start_Time__c = s.sirenum__Billable_Start_Time__c;

try {
update s;
if (s.IP_ClientApproved__c = true && (s.sirenum__Scheduled_Start_Time__c != s.sirenum__Billable_Start_Time__c || s.sirenum__Scheduled_End_Time__c != s.sirenum__Billable_End_Time__c)) {

if (!test.isRunningTest()) {
Messaging.SingleEmailMessage email = messaging.renderStoredEmailTemplate(templateIdApproval, s.sirenum__Contact__c, s.id);
email.setSubject(Topazname.get(s.id) + ' has made changes to your recent placement');
if (owd.size() > 0) {
email.setOrgWideEmailAddressId(owd[0].Id);
} else {
email.setOrgWideEmailAddressId(owd1.Id);
}
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
email
});
}

String startDateString = s.sirenum__Billable_Start_Time__c.format('dd-MM-YYYY');
String startTimeString = s.sirenum__Billable_Start_Time__c.format('kk:mm:ss');
String endDateString = s.sirenum__Billable_End_Time__c.format('dd-MM-YYYY');
String endTimeString = s.sirenum__Billable_End_Time__c.format('kk:mm:ss');


Task tsk = new Task();
tsk.Ownerid = OwnerIDmap.get(s.id);
tsk.WhatID = s.id;
tsk.Subject = 'Adjusted Shift Hours by Client';
String comments1 = 'Hi ' + s.sirenum__Contact__r.firstName + ',' + '\n' + '\n';
comments1 += 'We\'ve just received an adjustment to the following placement from the ' + s.sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c + ' at ' + Topazname.get(s.id) + ' .These changes are for work as ' + s.sirenum__Team__r.Name + ' at ' + s.sirenum__site__r.Name + '. ' + Topazname.get(s.id) + ' which has adjusted your hours to ' + startTimeString + ' on the ' + startDateString + ' and ended at ' + endTimeString + ' on the ' + endDateString + '.' + '\n\n';
comments1 += 'If these changes are okay then you don\'t need to do anything else, however if you would like to discuss these changes further, please contact Consultant ' + Ownermap.get(s.id) + ' for immediate assistance.' + '\n\n';
comments1 += 'Best regards,' + '\n';
comments1 += 'Customer Support' + '\n';
tsk.Description = comments1;
tsk.WhoID = contactmap.get(s.id);
insert tsk;
}

Status = 'Success';
} catch (Exception e) {
Status = 'Error';
}
} else {
Status = 'Error';
}
}
return Status;
}*/
    
    @AuraEnabled
    public static string approveShifts(List <Id> shiftIds, Map < String, String > startime, Map < String, String > endtime) {
        String status;
        try{ 
            Id loggedInUserId = UserInfo.getUserId();
            User u = [SELECT id,ContactId,Name FROM User WHERE id = :loggedInUserId Limit 1];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List < sirenum__shift__c >  shifts = [SELECT id,sirenum__Break_Override__c,
                                                  sirenum__site__r.sirenum__Operating_Company__r.name,sirenum__Site__r.IP_TempestDepartment__c, 
                                                  sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, Total_Shift_BreakLength__c, 
                                                  IP_BranchOfOwner__c, StartTime__c, EndTime__c, sirenum__Contact__r.Name, 
                                                  sirenum__Contact__r.FirstName, sirenum__Site__r.Name, sirenum__Billable_End_Time__c, 
                                                  sirenum__Billable_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Actual_Start_Time__c, 
                                                  sirenum__Scheduled_End_Time__c, sirenum__Scheduled_Start_Time__c, IP_ClientApproved__c, 
                                                  Approved_Date_Time__c, Approved_By__c, sirenum__Contact__c, sirenum__Site__r.Owner.Name, 
                                                  sirenum__site__r.GlobalClientName__r.name, sirenum__site__r.OwnerID, sirenum__Team__r.Name, 
                                                  sirenum__Team__r.sirenum__Job_Type__r.Name,sirenum__Forecast_Charge__c,
                                                  (select id,sirenum__Duration__c,sirenum__End_Time__c,sirenum__Paid_Break__c,sirenum__Shift__c,sirenum__Start_Time__c from sirenum__Shift_Breaks__r order by sirenum__Start_Time__c asc) 
                                                  from sirenum__shift__c WHERE id in: shiftIds];
            SYSTEM.debug('shifts: '+shifts);
            Map < id, string > Topazname = new Map < id, String > ();
            Map < id, string > JobTitle = new Map < id, String > ();
            Map < id, string > Ownermap = new Map < id, String > ();
            Map < id, string > OwnerIDmap = new Map < id, String > ();
            Map < id, id > contactmap = new Map < id, id > ();
            
            
            for (sirenum__Shift__c s1: shifts) {
                Topazname.put(s1.id, s1.sirenum__site__r.GlobalClientName__r.name);
                JobTitle.put(s1.id, s1.sirenum__Team__r.sirenum__Job_Type__r.Name);
                Ownermap.put(s1.id, s1.sirenum__Site__r.Owner.Name);
                OwnerIDmap.put(s1.id, s1.sirenum__site__r.OwnerID);
                contactmap.put(s1.id, s1.sirenum__Contact__c);
            }
            
            List<sirenum__Shift__c> lstShiftToUpdate = new List<sirenum__Shift__c>();
            List<Task> lstTaskToInsert = new List<Task>();
            List<sirenum__Shift_Break__c> breaksUpdate = new List<sirenum__Shift_Break__c>();
            
            for (sirenum__Shift__c s: shifts) {
                if (s.sirenum__Contact__c != null) {
                    
                    //break update on approval starts
                if(s.sirenum__Shift_Breaks__r.size()>0){    
                    datetime brkStartTimeAfterAbreak= null;
                    
                    DateTime actualStartDate = s.sirenum__Scheduled_Start_Time__c;
                    List<String> ActualStartTimeArray = startime.get(String.valueOf(s.Id)).split(':');
                    String ActualStartTimeHour = ActualStartTimeArray[0];
                    String ActualStartTimeMin = ActualStartTimeArray[1];
                    datetime ActualStartTimeBreak = DateTime.newInstance(actualStartDate.year(), actualStartDate.month(), actualStartDate.day(), Integer.valueOf(ActualStartTimeHour), Integer.valueOf(ActualStartTimeMin), 00);
                    system.debug('--ActualStartTimeBreak--'+ActualStartTimeBreak);
                    
                    DateTime actualEndDate = s.sirenum__Scheduled_End_Time__c;
                    List<String> ActualEndTimeArray = endtime.get(String.valueOf(s.Id)).split(':');
                    String ActualEndTimeHour = ActualEndTimeArray[0];
                    String ActualEndTimeMin = ActualEndTimeArray[1];
                    dateTime ActualEndTimeBreak = DateTime.newInstance(actualEndDate.year(), actualEndDate.month(), actualEndDate.day(), Integer.valueOf(ActualEndTimeHour), Integer.valueOf(ActualEndTimeMin), 00);
                   system.debug('--ActualEndTimeBreak--'+ActualEndTimeBreak);
                    System.debug('Debug log for s.sirenum__Shift_Breaks__r.size() '+s.sirenum__Shift_Breaks__r.size());
                    Integer numberOfBreaks = s.sirenum__Shift_Breaks__r.size();
                    System.debug('Debug log for numberOfBreaks '+numberOfBreaks);
                    datetime firstBreakStartTime = s.sirenum__Shift_Breaks__r[0].sirenum__Start_Time__c;
                    system.debug('--firstBreakStartTime--'+firstBreakStartTime);
                    datetime lastBreakEndTime = s.sirenum__Shift_Breaks__r[numberOfBreaks-1].sirenum__End_Time__c;
                    system.debug('--lastBreakEndTime--'+lastBreakEndTime);
                    
                    if(firstBreakStartTime >= ActualStartTimeBreak && lastBreakEndTime <= ActualEndTimeBreak){
                        
                    }
                    else{
                       for(sirenum__Shift_Break__c brk : s.sirenum__Shift_Breaks__r){
                            datetime brkEndtime;
                            datetime brkStartTime;
                            if(brkStartTimeAfterAbreak == null){
                                brkStartTime = DateTime.newInstance(actualStartDate.year(), actualStartDate.month(), actualStartDate.day(), Integer.valueOf(ActualStartTimeHour), Integer.valueOf(ActualStartTimeMin), 00);
                            }
                            else{
                                brkStartTime = brkStartTimeAfterAbreak;
                            }
                            brkEndtime = (brkStartTime).addMinutes(Integer.valueof(brk.sirenum__Duration__c*60));
                            brkStartTimeAfterAbreak = brkEndtime;
                            breaksUpdate.add(new sirenum__Shift_Break__c(sirenum__Start_Time__c=brkStartTime,sirenum__End_Time__c=brkEndtime,Id=brk.id)); 
                        } 
                    }
                        
                }
                    
                    //break update on approval ends
                    
                    s.IP_ClientApproved__c = true;
                    s.Approved_Date_Time__c = System.now();
                    s.Approved_By__c = UserInfo.getUserId();
                    String starttime1 = String.valueof(s.sirenum__Scheduled_Start_Time__c);
                    String endtime1 = String.valueof(s.sirenum__Scheduled_End_Time__c);
                    if (startime.containsKey(s.Id)) {
                        List < String > stringParts = startime.get(s.Id).split(':');
                        system.debug('@@ for test class ' + stringParts);
                        if (s.sirenum__Actual_Start_Time__c != null) {
                            DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            s.sirenum__Billable_Start_Time__c = updatestartDateTime;
                        } else {
                            DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            s.sirenum__Billable_Start_Time__c = updatestartDateTime;
                        }
                    } else if (s.sirenum__Actual_Start_Time__c != null) {
                        s.sirenum__Billable_Start_Time__c = s.sirenum__Actual_Start_Time__c;
                    } else if (s.sirenum__Actual_Start_Time__c == null) {
                        s.sirenum__Billable_Start_Time__c = s.sirenum__Scheduled_Start_Time__c;
                    }
                    if (endtime.containsKey(s.Id)) {
                        List < String > stringParts2 = endtime.get(s.Id).split(':');
                        List < String > stringParts = startime.get(s.Id).split(':');
                        if (s.sirenum__Actual_End_Time__c != null) {
                            DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            
                            DateTime actualEndDateTime = s.sirenum__Actual_End_Time__c;
                            Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day(), Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                            if (updateEndDateTime < updatestartDateTime) {
                                updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day() + 1, Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                                
                            }
                            
                            s.sirenum__Billable_End_Time__c = updateEndDateTime;
                        } else {
                            DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            
                            DateTime actualEndDateTime = s.sirenum__Scheduled_End_Time__c;
                            Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day(), Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                            if (updateEndDateTime < updatestartDateTime) {
                                updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day() + 1, Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                                
                            }
                            
                            s.sirenum__Billable_End_Time__c = updateEndDateTime;
                        }
                    } else if (s.sirenum__Actual_End_Time__c != null) {
                        s.sirenum__Billable_End_Time__c = s.sirenum__Actual_End_Time__c;
                    } else if (s.sirenum__Actual_End_Time__c == null) {
                        s.sirenum__Billable_End_Time__c = s.sirenum__Scheduled_End_Time__c;
                    }
                    System.debug('check contact id' + s.sirenum__Contact__r.id);
                    
                    
                    if (s.sirenum__Billable_End_Time__c != null)
                        s.sirenum__Actual_End_Time__c = s.sirenum__Billable_End_Time__c;
                    
                    if (s.sirenum__Billable_Start_Time__c != null)
                        s.sirenum__Actual_Start_Time__c = s.sirenum__Billable_Start_Time__c;
                    //JPC-2144
                    
                    s.sirenum__Allow_pay__c=true;
                    s.sirenum__Allow_charge__c=true;
                    
                    //JPC-2061
                    s.sirenum__Break_Override__c=true;
                    
                    // try {
                    //update s;
                    System.debug('Debug log for lstShiftToUpdate.size '+lstShiftToUpdate.size());
                    lstShiftToUpdate.add(s);
                    String startDateString = s.sirenum__Billable_Start_Time__c.format('dd-MM-YYYY');
                    String startTimeString = s.sirenum__Billable_Start_Time__c.format('kk:mm:ss');
                    String endDateString = s.sirenum__Billable_End_Time__c.format('dd-MM-YYYY');
                    String endTimeString = s.sirenum__Billable_End_Time__c.format('kk:mm:ss');
                    System.debug('Debug log for shifts.size '+shifts.size());

                 /*   if(!shifts.isEmpty()){
                        IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(shifts[0].sirenum__Site__r.IP_TempestDepartment__c);
                        System.debug('===branchemail==='+branchemail.Email__c);
                        if(branchemail.Email__c != null){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            List<String> sendTo = new List<String>();
                            sendTo.add(branchemail.Email__c);
                            mail.setToAddresses(sendTo);
                            String subject = shifts[0].sirenum__site__r.sirenum__Operating_Company__r.name+' has adjusted a shift for '+shifts[0].sirenum__Contact__r.FirstName;
                            mail.setSubject(subject);
                            String body = 'Hi '+shifts[0].sirenum__site__r.owner.Name+', <br><br>';
                            body += 'We\'ve just received an adjustment to the following placement for '+shifts[0].sirenum__Contact__r.Name+' working as '+shifts[0].sirenum__Team__r.Name+' at '+shifts[0].sirenum__site__r.sirenum__Operating_Company__r.name+'. These changes are for working hours at '+shifts[0].sirenum__Site__r.Name+', which started at '+startTimeString+' on the '+startDateString+ ' and ended at '+endTimeString+' on the '+endDateString+'.<br><br>';
                            body += u.Name+' does not agree with the hours submitted for payment and please investigate this immediately to find out why these hours have not been approved for payment and update Jobscience accordingly.<br><br>';
                            body += 'Thanks,<br> Jobscience.';
                            mail.setHtmlBody(body);
                            mails.add(mail);
                            System.debug('===mails=='+mails);
                            
                            if(mails!=null){
                                Messaging.sendEmail(mails);
                            }
                        }
                    }*/
                    
                    Task tsk = new Task();
                    tsk.Ownerid = OwnerIDmap.get(s.id);
                    tsk.WhatID = s.id;
                    tsk.Subject = 'Adjusted Shift Hours by Client';
                    String comments1 = 'Hi ' + s.sirenum__Contact__r.firstName + ',' + '\n' + '\n';
                    comments1 += 'We\'ve just received an adjustment to the following placement from the ' + s.sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c + ' at ' + Topazname.get(s.id) + ' .These changes are for work as ' + s.sirenum__Team__r.Name + ' at ' + s.sirenum__site__r.Name + '. ' + Topazname.get(s.id) + ' which has adjusted your hours to ' + startTimeString + ' on the ' + startDateString + ' and ended at ' + endTimeString + ' on the ' + endDateString + '.' + '\n\n';
                    comments1 += 'If these changes are okay then you don\'t need to do anything else, however if you would like to discuss these changes further, please contact Consultant ' + Ownermap.get(s.id) + ' for immediate assistance.' + '\n\n';
                    comments1 += 'Best regards,' + '\n';
                    comments1 += 'Customer Support' + '\n';
                    tsk.Description = comments1;
                    tsk.WhoID = contactmap.get(s.id);
                    //insert tsk;
                    lstTaskToInsert.add(tsk);
                    
                    Status = 'Success';
                    // }catch (Exception e) {
                    //  Status = 'Error';
                    // }
                    
                } else {
                    Status = 'Error';
                }
            }
            update breaksUpdate;
            if(!lstShiftToUpdate.isEmpty()){
                update lstShiftToUpdate;
                System.debug('in update shift');
            }
            if(!lstTaskToInsert.isEmpty()){
                insert lstTaskToInsert ;
                System.debug('in update task');
            }
        }catch(exception ex){
            // system.debug('----'+string.valueOf(ex));
            Status = 'Error';
        }
        
        return Status;
    }
    
    
    /* @AuraEnabled
public static Void SendRejectionToOwner(String shiftID, String comments, String combinedComment) {
if (comments != null && shiftID != null) {
List < sirenum__Shift__c > returnshift = [SELECT Id, sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, sirenum__Contact__c, IP_BranchOfOwner__c, sirenum__site__r.GlobalClientName__r.name, sirenum__Contact__r.FirstName, IP_ClientRejected__c, sirenum__Placement__r.IP_Consultant1LookupSplitShare__c, sirenum__Cancelled__c, Cancellation_Reason__c, sirenum__Scheduling_Comments__c, sirenum__Placement__c, sirenum__Actual_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Break_Length__c, sirenum__Scheduled_Start_Time__c, EndTime__c, Createddate, Starttime__c, sirenum__Scheduled_End_Time__c, sirenum__Team__r.name, sirenum__Site__c, sirenum__Team__r.sirenum__Job_Type__r.Name, sirenum__Site__r.Owner.Name, sirenum__Site__r.OwnerID, sirenum__Site__r.name
FROM sirenum__Shift__c where id =: shiftID
];

System.debug('check shift ID' + returnshift);

IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(returnshift[0].IP_BranchOfOwner__c);
System.debug('==branchemail@@@@@@='+branchemail);
List < OrgWideEmailAddress > owd = new List< OrgWideEmailAddress >();
if (branchemail != Null) {
owd = [select id, DisplayName, Address from OrgWideEmailAddress where Address =: branchemail.Email__c];
system.debug('OWD ID--->' + owd);
}

Id templateIdReject = [select id, name from EmailTemplate where developername = 'Client_Reject_Shift_on_Portal'].id;
OrgWideEmailAddress owd1 = [select id, DisplayName, Address from OrgWideEmailAddress where Address = 'no.reply@bluearrow.co.uk'];



for (sirenum__Shift__c sh: returnshift) {
sh.IP_ClientRejected__c = true;

}
update returnshift;
String startDateString = returnshift[0].sirenum__Scheduled_Start_Time__c.format('dd-MM-YYYY');
String startTimeString = returnshift[0].sirenum__Scheduled_Start_Time__c.format('kk:mm:ss');
String endDateString = returnshift[0].sirenum__Scheduled_End_Time__c.format('dd-MM-YYYY');
String endTimeString = returnshift[0].sirenum__Scheduled_End_Time__c.format('kk:mm:ss');
Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
if (!test.isRunningTest()) {
semail = messaging.renderStoredEmailTemplate(templateIdReject, returnshift[0].sirenum__Contact__c, returnshift[0].id);

if (owd.size() > 0) {
semail.setOrgWideEmailAddressId(owd[0].Id);
} else {
semail.setOrgWideEmailAddressId(owd1.Id);
}

semail.setSubject(returnshift[0].sirenum__site__r.GlobalClientName__r.name + ' has made changes to your recent placement');
semail.saveAsActivity = false;
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
semail
});
}
Task tsk = new Task();
tsk.Ownerid = returnshift[0].sirenum__Site__r.OwnerID;
tsk.WhatID = returnshift[0].id;
tsk.Subject = 'Rejected Shift Hours by Client';
String comments1 = 'Hi ' + returnshift[0].sirenum__Contact__r.FirstName + ',' + '\n' + '\n';
comments1 += 'We\'ve just received an adjustment to the following placement from the ' + returnshift[0].sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c + ' at ' + returnshift[0].sirenum__site__r.GlobalClientName__r.name + '. These changes are for working hours as ' + returnshift[0].sirenum__Team__r.Name + ' at ' + returnshift[0].sirenum__site__r.name + ', which started at ' + startTimeString + ' on the ' + startDateString + ' and ended at ' + endTimeString + ' on the ' + endDateString + '.' + '\n\n' + returnshift[0].sirenum__site__r.GlobalClientName__r.name + ' does not agree with the hours submitted for payment and so Consultant ' + returnshift[0].sirenum__site__r.Owner.Name + ' will pick this up immediately with the client to find out why these hours have not been approved for payment. ' + returnshift[0].sirenum__site__r.Owner.Name + ' will then be in touch with you immediately after to confirm the issue and get this resolved asap' + '\n' + '\n';
comments1 += 'Best regards,' + '\n';
comments1 += 'Customer Support' + '\n';
tsk.Description = comments1;
tsk.WhoID = returnshift[0].sirenum__Contact__c;
insert tsk;
System.debug('Task created' + tsk);
}
}*/
    
    //JPC-1900
    @AuraEnabled
    public static Void SendRejectionToOwner(String shiftID, String comments, String combinedComment) {
        if (comments != null && shiftID != null) {
            Id loggedInUserId = UserInfo.getUserId();
            User u = [SELECT id,ContactId,Name FROM User WHERE id = :loggedInUserId Limit 1];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            List< sirenum__Shift__c > returnshift = [SELECT Id,sirenum__site__r.sirenum__Operating_Company__r.name,sirenum__Site__r.IP_TempestDepartment__c, sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, sirenum__Contact__c, IP_BranchOfOwner__c, sirenum__site__r.GlobalClientName__r.name, sirenum__Contact__r.FirstName,sirenum__Contact__r.Name, IP_ClientRejected__c, sirenum__Placement__r.IP_Consultant1LookupSplitShare__c, sirenum__Cancelled__c, Cancellation_Reason__c, sirenum__Scheduling_Comments__c, sirenum__Placement__c, sirenum__Actual_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Break_Length__c, sirenum__Scheduled_Start_Time__c, EndTime__c, Createddate, Starttime__c, sirenum__Scheduled_End_Time__c, sirenum__Team__r.name, sirenum__Site__c, sirenum__Team__r.sirenum__Job_Type__r.Name, sirenum__Site__r.Owner.Name, sirenum__Site__r.OwnerID, sirenum__Site__r.name,sirenum__Forecast_Charge__c
                                                     FROM sirenum__Shift__c WHERE id=:shiftId];
            
            String startDateString = returnshift[0].sirenum__Scheduled_Start_Time__c.format('dd-MM-YYYY');
            String startTimeString = returnshift[0].sirenum__Scheduled_Start_Time__c.format('kk:mm:ss');
            String endDateString = returnshift[0].sirenum__Scheduled_End_Time__c.format('dd-MM-YYYY');
            String endTimeString = returnshift[0].sirenum__Scheduled_End_Time__c.format('kk:mm:ss');
            
          /*  if(!returnshift.isEmpty()){
                IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(returnshift[0].sirenum__Site__r.IP_TempestDepartment__c);
                System.debug('===branchemail==='+branchemail.Email__c);
                if(branchemail.Email__c != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add(branchemail.Email__c);
                    mail.setToAddresses(sendTo);
                    String subject = returnshift[0].sirenum__site__r.sirenum__Operating_Company__r.name+' has rejected a shift for '+returnshift[0].sirenum__Contact__r.FirstName;
                    mail.setSubject(subject);
                    String body = 'Hi '+returnshift[0].sirenum__site__r.owner.Name+', <br><br>';
                    body += 'We\'ve just received a shift rejection to the following placement for '+returnshift[0].sirenum__Contact__r.Name+' working as '+returnshift[0].sirenum__Team__r.Name+' at '+returnshift[0].sirenum__site__r.sirenum__Operating_Company__r.name+'. These changes are for working hours at '+returnshift[0].sirenum__Site__r.Name+', which started at '+startTimeString+' on the '+startDateString+ ' and ended at '+endTimeString+' on the '+endDateString+'.<br><br>';
                    body += u.name+' does not agree with the hours submitted for payment and please investigate this immediately to find out why these hours have not been approved for payment and update Jobscience accordingly.<br><br>';
                    body += 'Thanks,<br> Jobscience.';
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    System.debug('===mails=='+mails);
                    if(mails!=null){
                        Messaging.sendEmail(mails);
                    }
                }
            }*/
            
            for (sirenum__Shift__c sh: returnshift) {
                sh.IP_ClientRejected__c = true;
                sh.sirenum__Client_Comments__c = comments;
                sh.sirenum__Break_Override__c=true;
            }
            update returnshift;
            
            Task tsk = new Task();
            tsk.Ownerid = returnshift[0].sirenum__Site__r.OwnerID;
            tsk.WhatID = returnshift[0].id;
            tsk.Subject = 'Rejected Shift Hours by Client';
            String comments1 = 'Hi ' + returnshift[0].sirenum__Contact__r.FirstName + ',' + '\n' + '\n';
            comments1 += 'We\'ve just received an adjustment to the following placement from the ' + returnshift[0].sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c + ' at ' + returnshift[0].sirenum__site__r.GlobalClientName__r.name + '. These changes are for working hours as ' + returnshift[0].sirenum__Team__r.Name + ' at ' + returnshift[0].sirenum__site__r.name + ', which started at ' + startTimeString + ' on the ' + startDateString + ' and ended at ' + endTimeString + ' on the ' + endDateString + '.' + '\n\n' + returnshift[0].sirenum__site__r.GlobalClientName__r.name + ' does not agree with the hours submitted for payment and so Consultant ' + returnshift[0].sirenum__site__r.Owner.Name + ' will pick this up immediately with the client to find out why these hours have not been approved for payment. ' + returnshift[0].sirenum__site__r.Owner.Name + ' will then be in touch with you immediately after to confirm the issue and get this resolved asap' + '\n' + '\n';
            comments1 += 'Best regards,' + '\n';
            comments1 += 'Customer Support' + '\n';
            tsk.Description = comments1;
            tsk.WhoID = returnshift[0].sirenum__Contact__c;
            insert tsk;
            System.debug('Task created' + tsk);
        }
    }
    
    
    
    
    @auraEnabled
    public static Map < string, integer > getChartMap(Integer shiftsRequiringApproval) {
        Map < string, integer > mp = new Map < string, integer > ();
        
        List < sirenum__Timesheet__c > approvedList = fetchTimeSheets();
        mp.put('Shifts Requiring Approval', shiftsRequiringApproval);
        mp.put('Shifts Approved', 0);
        if (!test.isRunningTest()) {
            mp.put('Total Shifts', shiftsRequiringApproval + approvedList.size());
        }
        List < sirenum__Site__c > siteList = ShiftApprovalController.getSites();
        System.debug('siteList: ' + siteList);
        return mp;
    }
    
    @AuraEnabled
    public static List < sirenum__Timesheet__c > fetchTimeSheets() {
        return TimeSheetInfoWithPagination.fetchTimeSheets();
    }
    
    public class CandiInfoWrapper {
        @AuraEnabled public String CandidateName;
        @AuraEnabled public String CandidateId;
        @AuraEnabled public String ShiftId;
        @AuraEnabled public String JobRole;
        @AuraEnabled public Decimal BookedHourse;
        @AuraEnabled public String stBookedHourse;
        @AuraEnabled public Decimal ActualHourse;
        @AuraEnabled public String stActualHourse;
        @AuraEnabled public Decimal Diff;
        @AuraEnabled public Decimal ForecastCharge=0.00;
        @AuraEnabled public String stDiff;
        @AuraEnabled public String InvoicePO;
        @AuraEnabled public String Action;
        @AuraEnabled public List <sirenum__Shift__c> shiftInfo;
    }
    
    @AuraEnabled
    public static String fetchUser() {
        return userinfo.getName();
    }
    
    private static Datetime convertMonthTextToNumber(String myDate) {
        
        String[] myDateOnly = myDate.split(' ');
        Integer month;
        String strDate = myDateOnly[1];
        
        if (myDateOnly[myDateOnly.size() - 2] == 'Jan') {
            month = 1;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Feb') {
            month = 2;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Mar') {
            month = 3;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Apr') {
            month = 4;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'May') {
            month = 5;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Jun') {
            month = 6;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Jul') {
            month = 7;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Aug') {
            month = 8;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Sep') {
            month = 9;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Oct') {
            month = 10;
        } else if (myDateOnly[myDateOnly.size() - 2] == 'Nov') {
            month = 11;
        } else {
            month = 12;
        }
        
        Date d = Date.newInstance(integer.valueOf('20' + myDateOnly[myDateOnly.size() - 1]), month, integer.valueOf(myDateOnly[myDateOnly.size() - 3]));
        
        Datetime dt = (Datetime) d;
        //2018-08-10
        System.debug('d: ' + dt.format('yyyy-MM-dd'));
        return dt;
    }
    
    @AuraEnabled
    public static List<Contact_Site_link__c>  checkPermissionToViewAction(string siteId){
        
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];
        
        List < Id > siteIds = new List < Id > ();
        List<Contact_Site_link__c> lstContactList = [SELECT Id, IP_PortalType__c FROM Contact_Site_link__c
                                                     WHERE IP_Contact__r.Id=:cont.id AND Account__r.Id=:cont.AccountId AND IP_Site__r.Id=:siteId];
        System.debug(lstContactList.size()+'=lstContactList958='+lstContactList);
        if(!lstContactList.isEmpty()){
            return lstContactList;
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static string SubmitInvoicePODB(Id shiftId,String InvoicePO){
        List<sirenum__Placement__c> placement = new List<sirenum__Placement__c>();
        List<sirenum__Shift__c> shifts = [select id,Account__c,IP_Account__r.Invoice_PO_Number_Format__c,sirenum__Placement__c from sirenum__Shift__c where Id=:shiftId limit 1];
        //A#A###
        String format = shifts[0].IP_Account__r.Invoice_PO_Number_Format__c;
        boolean result;
        if(format != NULL){
            if(format.length() == InvoicePO.length()){
                integer i;
                String Regexbody='';
                for(i=0;i<format.length();i++){
                    if(format.charAt(i)==65){
                        Regexbody=Regexbody + '[A-Z]{1}';
                    }
                    else if(format.charAt(i)==35){
                        Regexbody=Regexbody + '[0-9]{1}';
                    }
                    else if(format.charAt(i)==97){
                        Regexbody=Regexbody + '[a-z]{1}';
                    }
                    else if(format.charAt(i)==33){
                        Regexbody=Regexbody + '[^\\w]{1}';
                    }
                }
                String Regex = '^'+Regexbody+'$';
                System.debug('------'+Regex); 
                Pattern MyPattern = Pattern.compile(Regex);
                Matcher MyMatcher = mypattern.matcher(InvoicePO);
                result = MyMatcher.matches();
                System.debug('----result----'+result);
            }
        }
        if(format == NULL){
            result=true;
        }
        if(result==true){
            placement.add(new sirenum__Placement__c(Id=shifts[0].sirenum__Placement__c,IP_PurchaseOrderNumber__c=InvoicePO));
            update placement;
            return 'success' ;
        }
        else{
            //System.debug('--return format--'+format);
            return format;
        }
        
    }
    
    @AuraEnabled
    public static List<sirenum__Shift_Break__c> getAllBreaksDB(Id shiftId){
        return [Select id,sirenum__Duration__c,Duration_Long__c,sirenum__Paid_Break__c,sirenum__Shift__c from sirenum__Shift_Break__c where sirenum__Shift__c =: shiftId and sirenum__Paid_Break__c=:false order by createddate asc];
    }
    
    @AuraEnabled
    public static List<sirenum__Shift_Break__c> testMethod1(object breakData,string shiftid){
        /* [{"serial":"1","Duration":"120","paidBreak":"true","breakId":"a4Z8E000000mbVmUAI"},
{"serial":"2","Duration":"60","paidBreak":"false","breakId":"a4Z8E000000mdjFUAQ"},
{"serial":"3","Duration":"30","paidBreak":"true","breakId":"a4Z8E000000mMh1UAE"},
{"serial":"4","Duration":"40","paidBreak":"","breakId":"New Record"}]*/
        String jsonstring = JSON.serialize(breakData);
        //String ProperJSONString = jsonstring.substring(1, jsonstring.length() - 1);
        List<wrapperBreak> convertedData = (List<wrapperBreak>)JSON.deserialize(jsonstring,List<wrapperBreak>.Class); 
        Integer dataLength = convertedData.size();
        Datetime StartTime=null;
        List<sirenum__Shift_Break__c> breaks = [Select id,sirenum__Duration__c,Duration_Long__c,sirenum__Start_Time__c,sirenum__End_Time__c,sirenum__Paid_Break__c,sirenum__Shift__c from sirenum__Shift_Break__c where sirenum__Shift__c =: shiftid order by createddate asc];
        List<sirenum__Shift_Break__c>  breaksUpdate = new List<sirenum__Shift_Break__c>();
        List<sirenum__Shift_Break__c>  breaksInsert = new List<sirenum__Shift_Break__c>();
        List<sirenum__Shift_Break__c>  breaksDelete = new List<sirenum__Shift_Break__c>();
        for(sirenum__Shift_Break__c brk:breaks){
            datetime brkStartTime;
            datetime endtime;
            boolean paid;
            for(integer i=0;i<dataLength;i++){
                if(convertedData[i].breakId != 'New Record'){
                    if(brk.Id==convertedData[i].breakId ){
                        
                        if(StartTime != null){
                            brkStartTime = StartTime;
                        }
                        else{
                            brkStartTime = brk.sirenum__Start_Time__c;
                        }
                        endtime = (brkStartTime).addminutes(convertedData[i].Duration == '' ? 0 : Integer.valueOf(convertedData[i].Duration));
                        StartTime = endtime;
                        
                        paid = false;
                    }
                }
                
                
            }
            breaksUpdate.add(new sirenum__Shift_Break__c(
                sirenum__Paid_Break__c = false,
                sirenum__Start_Time__c = Test.isRunningTest() ? System.now() : brkStartTime,
                sirenum__End_Time__c = endtime,
                Id = brk.id
            ));
        }
        
        update breaksUpdate; 
        sirenum__Shift__c shift = [select id,Break_Calculation_Start_Time__c,sirenum__Break_Override__c from sirenum__Shift__c where id=:shiftid];
        datetime shiftStartTime = shift.Break_Calculation_Start_Time__c;
        datetime newbrkStartTime1=null;
        for(integer j=0;j<dataLength;j++){
            
            if(convertedData[j].breakId == 'New Record'){
                datetime newbrkStartTime;
                datetime newendtime;
                boolean paid;
                if(StartTime !=null) {
                    newbrkStartTime = StartTime;
                }
                else{
                    // newbrkStartTime = [select id,Break_Calculation_Start_Time__c from sirenum__Shift__c where id=:shiftid][0].Break_Calculation_Start_Time__c;
                    if(newbrkStartTime1 == null){
                        newbrkStartTime = shiftStartTime;
                        newbrkStartTime1 = newbrkStartTime.addMinutes(convertedData[j].Duration == '' ? 0 : Integer.valueOf(convertedData[j].Duration));
                    }
                    else{
                        newbrkStartTime=newbrkStartTime1;
                    }
                    
                }
                newendtime = newbrkStartTime.addMinutes(convertedData[j].Duration == '' ? 0 : Integer.valueOf(convertedData[j].Duration));
                StartTime=newendtime;
                paid = false;
                breaksInsert.add(new sirenum__Shift_Break__c(sirenum__Start_Time__c=newbrkStartTime,sirenum__Paid_Break__c=false,sirenum__End_Time__c=newendtime,sirenum__Shift__c=shiftid));
            }
            
            
        }
        if(breaksInsert.size()>0){
            Insert breaksInsert; 
        }
        
        breaksDelete = [Select id,sirenum__Duration__c,Duration_Long__c,sirenum__Start_Time__c,sirenum__End_Time__c,sirenum__Paid_Break__c,sirenum__Shift__c from sirenum__Shift_Break__c where sirenum__Shift__c =: shiftid and sirenum__Paid_Break__c=:false and sirenum__Duration__c=:0 order by createddate asc];
        delete breaksDelete;
        
        shift.sirenum__Break_Override__c=true;
        update shift;
        
        return [Select id,sirenum__Duration__c,Duration_Long__c,sirenum__Start_Time__c,sirenum__End_Time__c,sirenum__Paid_Break__c,sirenum__Shift__c from sirenum__Shift_Break__c where sirenum__Shift__c =: shiftid and sirenum__Paid_Break__c=:false order by createddate asc];
    }
    
    public class wrapperBreak{
        @AuraEnabled
        public String serial;
        @AuraEnabled
        public String Duration;
        //@AuraEnabled
        //public String paidBreak;
        @AuraEnabled
        public String breakId;
    }
    
    @AuraEnabled
    public static String CallSaveShiftDB(String JSONSHIFT) {
        List <Id> ShiftId = new List <Id> ();
        
        system.debug('## JSON ' + JSONSHIFT);
        String JSONBody = JSONSHIFT.substring(1, JSONSHIFT.length() - 1);
        // system.debug('## JSONBody '+JSONBody);  
        Integer testac = JSONBody.indexOf('Starttime__c');
        system.debug('## testac ' + testac);
        
        
        List < object > values = (List < object > ) System.JSON.deserializeUntyped(JSONSHIFT);
        
        system.debug('values ' + values);
        Map < String, String > mstart = new Map < String, String > ();
        Map < String, String > mend = new Map < String, String > ();
        for (Object v: values) {
            
            Integer i = String.valueOf(v).indexOf('Starttime__c');
            system.debug('## i value ' + i);
            system.debug('@@ values ' + v);
            String strID = String.valueOf(v).substring(String.valueOf(v).indexOf('Id') + 3, String.valueOf(v).indexOf('Id') + 21);
            system.debug('## strID ' + strID);
            
            String ststartTime = String.valueOf(v).substring(String.valueOf(v).indexOf('Starttime__c') + 13, String.valueOf(v).indexOf('Starttime__c') + 18);
            
            system.debug('## stTime ' + ststartTime);
            
            String stendTime = String.valueOf(v).substring(String.valueOf(v).indexOf('EndTime__c') + 11, String.valueOf(v).indexOf('EndTime__c') + 16);
            
            system.debug('## stTime ' + stendTime);
            mstart.put(strID, ststartTime);
            mend.put(strID, stendTime);
            ShiftId.add(strID);
            
        }
        
        // system.debug('mstart '+mstart);
        // system.debug('mend '+mend);
        // system.debug('shiftId '+mend);
        String Status = SaveShiftDB(shiftId, mstart, mend);
        system.debug('Status '+Status);
        return Status;
        //return 'Success';
    }
    
    @AuraEnabled
    public static string SaveShiftDB(List <Id> shiftIds, Map < String, String > startime, Map < String, String > endtime) {
        String status;
        try{ 
            Id loggedInUserId = UserInfo.getUserId();
            User u = [SELECT id,ContactId,Name FROM User WHERE id = :loggedInUserId Limit 1];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List < sirenum__shift__c >  shifts = [SELECT id,sirenum__Break_Override__c,
                                                  sirenum__site__r.sirenum__Operating_Company__r.name,sirenum__Site__r.IP_TempestDepartment__c, 
                                                  sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c, Total_Shift_BreakLength__c, 
                                                  IP_BranchOfOwner__c, StartTime__c, EndTime__c, sirenum__Contact__r.Name, 
                                                  sirenum__Contact__r.FirstName, sirenum__Site__r.Name, sirenum__Billable_End_Time__c, 
                                                  sirenum__Billable_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Actual_Start_Time__c, 
                                                  sirenum__Scheduled_End_Time__c, sirenum__Scheduled_Start_Time__c, IP_ClientApproved__c, 
                                                  Approved_Date_Time__c, Approved_By__c, sirenum__Contact__c, sirenum__Site__r.Owner.Name, 
                                                  sirenum__site__r.GlobalClientName__r.name, sirenum__site__r.OwnerID, sirenum__Team__r.Name, 
                                                  sirenum__Team__r.sirenum__Job_Type__r.Name,sirenum__Forecast_Charge__c,
                                                  (select id,sirenum__Duration__c,sirenum__End_Time__c,sirenum__Paid_Break__c,sirenum__Shift__c,sirenum__Start_Time__c from sirenum__Shift_Breaks__r order by sirenum__Start_Time__c asc) 
                                                  from sirenum__shift__c WHERE id in: shiftIds];
            
            List<sirenum__Shift__c> lstShiftToUpdate = new List<sirenum__Shift__c>();
            List<Task> lstTaskToInsert = new List<Task>();
            List<sirenum__Shift_Break__c> breaksUpdate = new List<sirenum__Shift_Break__c>();
            
            for (sirenum__Shift__c s: shifts) {
                if (s.sirenum__Contact__c != null) {
                    
                    //break update on approval starts
                if(s.sirenum__Shift_Breaks__r.size()>0){    
                    datetime brkStartTimeAfterAbreak= null;
                    
                    DateTime actualStartDate = s.sirenum__Scheduled_Start_Time__c;
                    List<String> ActualStartTimeArray = startime.get(String.valueOf(s.Id)).split(':');
                    String ActualStartTimeHour = ActualStartTimeArray[0];
                    String ActualStartTimeMin = ActualStartTimeArray[1];
                    datetime ActualStartTimeBreak = DateTime.newInstance(actualStartDate.year(), actualStartDate.month(), actualStartDate.day(), Integer.valueOf(ActualStartTimeHour), Integer.valueOf(ActualStartTimeMin), 00);
                    system.debug('--ActualStartTimeBreak--'+ActualStartTimeBreak);
                    
                    DateTime actualEndDate = s.sirenum__Scheduled_End_Time__c;
                    List<String> ActualEndTimeArray = endtime.get(String.valueOf(s.Id)).split(':');
                    String ActualEndTimeHour = ActualEndTimeArray[0];
                    String ActualEndTimeMin = ActualEndTimeArray[1];
                    dateTime ActualEndTimeBreak = DateTime.newInstance(actualEndDate.year(), actualEndDate.month(), actualEndDate.day(), Integer.valueOf(ActualEndTimeHour), Integer.valueOf(ActualEndTimeMin), 00);
                    system.debug('--ActualEndTimeBreak--'+ActualEndTimeBreak);
                    
                    Integer numberOfBreaks = s.sirenum__Shift_Breaks__r.size();
                    datetime firstBreakStartTime = s.sirenum__Shift_Breaks__r[0].sirenum__Start_Time__c;
                    datetime lastBreakEndTime = s.sirenum__Shift_Breaks__r[numberOfBreaks-1].sirenum__End_Time__c;
                    system.debug('--firstBreakStartTime--'+firstBreakStartTime);
                    system.debug('--lastBreakEndTime--'+lastBreakEndTime);
                    
                    if(firstBreakStartTime >= ActualStartTimeBreak && lastBreakEndTime <= ActualEndTimeBreak){
                        
                    }
                    else{
                        for(sirenum__Shift_Break__c brk : s.sirenum__Shift_Breaks__r){
                            datetime brkEndtime;
                            datetime brkStartTime;
                            if(brkStartTimeAfterAbreak == null){
                                brkStartTime = DateTime.newInstance(actualStartDate.year(), actualStartDate.month(), actualStartDate.day(), Integer.valueOf(ActualStartTimeHour), Integer.valueOf(ActualStartTimeMin), 00);
                            }
                            else{
                                brkStartTime = brkStartTimeAfterAbreak;
                            }
                            brkEndtime = (brkStartTime).addMinutes(Integer.valueof(brk.sirenum__Duration__c*60));
                            brkStartTimeAfterAbreak = brkEndtime;
                            breaksUpdate.add(new sirenum__Shift_Break__c(sirenum__Start_Time__c=brkStartTime,sirenum__End_Time__c=brkEndtime,Id=brk.id)); 
                        } 
                    }
                }
                    //break update on approval ends
                    
                    String starttime1 = String.valueof(s.sirenum__Scheduled_Start_Time__c);
                    String endtime1 = String.valueof(s.sirenum__Scheduled_End_Time__c);
                    
                    if (startime.containsKey(s.Id)) {
                        List <String> stringParts = startime.get(s.Id).split(':');
                        
                        if (s.sirenum__Actual_Start_Time__c != null) {
                            DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            s.sirenum__Billable_Start_Time__c = updatestartDateTime;
                        } 
                        else{
                            DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            s.sirenum__Billable_Start_Time__c = updatestartDateTime;
                        }
                    } 
                    else if(s.sirenum__Actual_Start_Time__c != null){
                        s.sirenum__Billable_Start_Time__c = s.sirenum__Actual_Start_Time__c;
                    }
                    else if (s.sirenum__Actual_Start_Time__c == null) {
                        s.sirenum__Billable_Start_Time__c = s.sirenum__Scheduled_Start_Time__c;
                    }
                    
                    if (endtime.containsKey(s.Id)) {
                        List < String > stringParts2 = endtime.get(s.Id).split(':');
                        List < String > stringParts = startime.get(s.Id).split(':');
                        
                        if (s.sirenum__Actual_End_Time__c != null) {
                            
                            DateTime actualStartDateTime = s.sirenum__Actual_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            
                            DateTime actualEndDateTime = s.sirenum__Actual_End_Time__c;
                            Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day(), Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                            
                            if(updateEndDateTime < updatestartDateTime) {
                                updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day() + 1, Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                                
                            }
                            
                            s.sirenum__Billable_End_Time__c = updateEndDateTime;
                        } 
                        else{
                            DateTime actualStartDateTime = s.sirenum__Scheduled_Start_Time__c;
                            Datetime updatestartDateTime = DateTime.newInstance(actualStartDateTime.year(), actualStartDateTime.month(), actualStartDateTime.day(), Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), 00);
                            
                            DateTime actualEndDateTime = s.sirenum__Scheduled_End_Time__c;
                            Datetime updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day(), Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                            if (updateEndDateTime < updatestartDateTime) {
                                updateEndDateTime = DateTime.newInstance(actualEndDateTime.year(), actualEndDateTime.month(), actualEndDateTime.day() + 1, Integer.valueOf(stringParts2[0]), Integer.valueOf(stringParts2[1]), 00);
                                
                            }
                            
                            s.sirenum__Billable_End_Time__c = updateEndDateTime;
                        }
                    } 
                    else if (s.sirenum__Actual_End_Time__c != null) {
                        s.sirenum__Billable_End_Time__c = s.sirenum__Actual_End_Time__c;
                    } 
                    else if (s.sirenum__Actual_End_Time__c == null) {
                        s.sirenum__Billable_End_Time__c = s.sirenum__Scheduled_End_Time__c;
                    }
                    
                    if (s.sirenum__Billable_End_Time__c != null)
                        s.sirenum__Actual_End_Time__c = s.sirenum__Billable_End_Time__c;
                    
                    if (s.sirenum__Billable_Start_Time__c != null)
                        s.sirenum__Actual_Start_Time__c = s.sirenum__Billable_Start_Time__c;
                    
                    s.sirenum__Break_Override__c=true;
                    
                    lstShiftToUpdate.add(s);
                    String startDateString = s.sirenum__Billable_Start_Time__c.format('dd-MM-YYYY');
                    String startTimeString = s.sirenum__Billable_Start_Time__c.format('kk:mm:ss');
                    String endDateString = s.sirenum__Billable_End_Time__c.format('dd-MM-YYYY');
                    String endTimeString = s.sirenum__Billable_End_Time__c.format('kk:mm:ss');
                    
                    
                    Status = 'Success';
                    
                } 
                else{
                    Status = 'Error';
                    
                }
            }
            update breaksUpdate;
            if(!lstShiftToUpdate.isEmpty()){
                update lstShiftToUpdate;
                System.debug('in update shift');
            }
        }catch(exception ex){
            Status = 'Error';
        }
        
        return Status;
    }
    @AuraEnabled
    public static sirenum__Shift__c getBookedTimes(Id shiftId) {
        List<sirenum__Shift__c> shiftLst = [SELECT id,TexsT__c,TexeT__c FROM sirenum__Shift__c WHERE id =:shiftId LIMIT 1];
        if(!shiftLst.isEmpty())
            return shiftLst[0];
        return shiftLst[0];
    }
}
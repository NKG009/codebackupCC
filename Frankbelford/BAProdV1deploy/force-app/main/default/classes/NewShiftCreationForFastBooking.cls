/**
* created by Espire team
* Ud[date by Musaddekur Rahman on 04/12/2020
* Summary of update: Added ORDER BY clause to return ordered list of Roles
* JIRA: PT1-180
*
* Test Classes: NewShiftCreationForFastBookingTest and TestNewShiftCreationForFastBooking
 */

public without sharing class NewShiftCreationForFastBooking{

    @Auraenabled
    public static List<sirenum__Site__c> getsitesList(){
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];

        List < Id > siteIds = new List < Id > ();
        List<Contact_Site_link__c> lstContactList = [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c FROM Contact_Site_link__c
                                                      WHERE IP_Contact__r.Id=:cont.id AND Account__r.Id=:cont.AccountId AND IP_PortalType__c!=null];
        System.debug(lstContactList.size()+'==lstContactList=='+lstContactList);
        for(Contact_Site_link__c conSiteLink : lstContactList){
            siteIds.add(conSiteLink.IP_Site__r.id);
        }
        List < sirenum__Site__c > sitesList = [SELECT id, name, sirenum__Operating_Company__c FROM sirenum__Site__c
                                                WHERE id IN: siteIds ORDER BY name ASC];
        return sitesList;
    }

    @Auraenabled
    public static List<sirenum__Team__c> getJobRoleList(){
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id = :u.contactId];
        List<sirenum__Team__c> jobRoleList = [SELECT id,Name FROM sirenum__Team__c
                                                where sirenum__Account__r.sirenum__Client__c =:cont.AccountId
                                                AND sirenum__Inactive__c = false
                                                ORDER BY Name ASC];
        return jobRoleList;
    }

    /**
       *  Description : Method to get Logged-In User Information
       *  @name : fetchUserInformation
       *  @param : None
       *  @return : User
       *  @throws exception-none
   */
    @AuraEnabled
    public static User fetchUserInformation() {
        return getUserInformation();
    }

    @Auraenabled
    public static String CreateNewShift(String siteId,String jobRoleId, String startTime, String endTime, String startDate, String endDate, String staffNumber,String InvoicePO){
        String stdatetime = DateFormater(startDate,startTime);
        String stdatetime1 = DateFormater(startDate,endTime);
        String eddatetime = DateFormater(endDate,endTime);
        String msg='';

        Date startdate1 = Date.valueOf(stdatetime);
        Date enddate1 = Date.valueOf(eddatetime);

        Integer datediff = startdate1.daysBetween(enddate1)+1;

        sirenum__site__c siterec = [SELECT id,Ownerid,IP_TempestDepartment__c, Owner.Email, Owner.Name, Name, sirenum__Operating_Company__r.name FROM sirenum__site__c WHERE id =:siteId];
        Id userId = UserInfo.getUserId();
        System.debug('USER ID '+userId);
        User u = [Select id,name from User where id =: userId];
        sirenum__Team__c  jobRole1 = [SELECT id,Name FROM sirenum__Team__c  WHERE id= :jobRoleId Limit 1];
        try{
            IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(siterec.IP_TempestDepartment__c);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add(branchemail.Email__c);
            mail.setToAddresses(sendTo);
            String subject = 'New Shift from '+siterec.sirenum__Operating_Company__r.name;
            mail.setSubject(subject);
            String body = 'Hi, <br><br>';
            body += u.name+' has submitted the following shift via the client portal.<br>';
            body += 'Site Name : '+siterec.Name+'<br>Job Role : '+jobRole1.name+'<br>Start Date : '+startDate+'<br>End Date : '+endDate+'<br>Start Time : '+startTime+'<br>End Time : '+endTime+'<br>Staff Number : '+staffNumber+'<br>' ;
            If(InvoicePO != ''){
                body += 'Invoice PO : '+ InvoicePO ;
            }

            body += '<br> Please contact them asap to confirm their request resolve their query.<br><br>';
            body += 'Thanks,<br> Jobscience.';
            mail.setHtmlBody(body);
            mails.add(mail);
            System.debug('===mails=='+mails);

            if(mails!=null){
                Messaging.sendEmail(mails);
            }

            Task tsk = new Task();
            tsk.Ownerid = siterec.OwnerId; //u.Id;
            tsk.WhatID = siterec.Id;
            tsk.Subject = 'Repeat Booking';
            tsk.ActivityDate = System.today();
            String comments = 'Site = '+siterec.name+'\n';
            comments += 'Job Role = '+jobRole1.name+'\n';
            comments += 'Required Staff = '+staffNumber+'\n';
            comments += 'Start Time = '+stdatetime+'\n';
            comments += 'End Time = '+eddatetime+'\n';
            if(InvoicePO != ''){
                comments += 'Invoice PO = '+InvoicePO;
            }

            tsk.Description = comments;
            insert tsk;
            SYstem.debug('Task created'+tsk);

            List<sirenum__Shift__c> newShiftlist = new List<sirenum__Shift__c>();
            for(integer i=0;i < datediff; i++) {
                sirenum__Shift__c newShift =  new sirenum__Shift__c();
                newShift.sirenum__Site__c = siteId;
                newShift.sirenum__Team__c = jobRoleId;
                newShift.sirenum__Broadcasts__c = Integer.valueOf(staffNumber);
                newShift.sirenum__Scheduled_Start_Time__c = datetime.valueOf(stdatetime).addDays(i);
                newShift.sirenum__Scheduled_End_Time__c = datetime.valueOf(stdatetime1).addDays(i);
                newShift.Invoice_PO_Optional__c = InvoicePO;
                newShiftlist.add(newShift);
                System.debug('newShift-->>'+newShift);

            }
            insert newShiftlist;
            msg = 'Request processed. Thank you';
        }catch(exception ex){
            System.debug(ex.getLineNumber()+'exception-->>'+ex.getMessage());
            msg = 'Request could not be automatically processed, the detail have been passed to the consultant that manages this site to action';
            String htmlbody = '<table  border="0" cellpadding="5" cellspacing="0" height="250" width="650"><tr><td class="previewCell">Dear '+ u.Name+
                    ',<br><br><br>This is a request from Logged in User for a new booking, Below are the details<br><br>Site: '+siterec.Name+
                    '<br><br>Job Role: '+jobrole1.Name+
                    '<br><br>No. Of Staff Needed: '+staffNumber+
                    '<br><br>Start Date and Time: '+stdatetime+
                    '<br><br>End Date and Time: '+eddatetime+
                    '<br><br><br>Thank you</td></tr></table>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(u.id);
            email.saveAsActivity = false;
            email.setHtmlBody(htmlbody);
            email.setSubject('New Shift Creation Failed');
            System.debug('email-->>'+email);
            if(!Test.isRunningTest()){
                //   Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
        }
        return msg;
    }

    public Static String DateFormater(String strDate, String strTime){
        String [] s = strDate.split('/');
        String newDate = '20'+s[2]+'-'+s[1]+'-'+s[0]+' '+strTime+':00.000';
        System.debug('=newDate='+newDate);
        return newDate;
    }

    @Auraenabled
    public static String CreateNewShiftForFastBooking(String siteId,String jobRoleId, String startDate, String endDate, String staffNumber){
        String message='';
        List<sirenum__site__c> siterec = new List<sirenum__site__c>();
        List<sirenum__Team__c>  jobRoleList = new List<sirenum__Team__c>();
        try{
            String strStartDate = startDate.replace('T',' ').replace('Z', '');
            Date dtStartDate = date.valueOf(strStartDate);

            String strEndDate = endDate.replace('T',' ').replace('Z', '');
            Date dtEndDate = date.valueOf(strEndDate);

            siterec = [Select id,Ownerid, Owner.Email, Owner.Name, Name from sirenum__site__c where id =:siteId];
            jobRoleList = [SELECT id,Name FROM sirenum__Team__c  WHERE id= :jobRoleId];

            Task tsk = new Task();
            if(!siterec.isEmpty()) tsk.Ownerid = siterec[0].OwnerId;
            if(!siterec.isEmpty())  tsk.WhatID  = siterec[0].Id;
            tsk.Subject = 'Repeat Booking';
            tsk.ActivityDate = System.today();
            String  comments = 'Site = '+siterec[0].name+'\n';
            comments += 'Job Role = '+jobRoleList[0].name+'\n';
            comments += 'Required Staff = '+staffNumber+'\n';
            comments += 'Start Time = '+startDate+'\n';
            comments += 'End Time = '+endDate;
            tsk.Description = comments;

            if(tsk!=null) {
                insert tsk;
            }
            SYstem.debug('Task created'+tsk);

            sirenum__Shift__c newShift =  new sirenum__Shift__c();
            newShift.sirenum__Site__c = siteId;
            newShift.sirenum__Team__c = jobRoleId;
            newShift.sirenum__Broadcasts__c = Integer.valueOf(staffNumber);
            newShift.sirenum__Scheduled_Start_Time__c = dtStartDate;//DateTime.valueOf('2017-07-21 00:00:00');//Datetime.valueOf(startDate);
            newShift.sirenum__Scheduled_End_Time__c = dtEndDate;//DateTime.valueOf('2017-07-22 00:00:00');//Datetime.valueOf(endDate);
            if(newShift!=null) {
                insert newShift;
            }
            System.debug('newShift-->>'+newShift);
            message = 'Request processed. Thank you';
        }catch(exception ex){
            System.debug(ex.getLineNumber()+'--exception-11->>'+ex.getMessage());
            message = 'Request could not be automatically processed, the detail have been passed to the consultant that manages this site to action';
            String htmlbody = '<table  border="0" cellpadding="5" cellspacing="0" height="250" width="650"><tr><td class="previewCell">Dear '+ siterec[0].Owner.Name+
                    ',<br><br><br>This is a request from Logged in User for a new booking, Below are the details<br><br>Site: '+siterec[0].Name+
                    '<br><br>Job Role: '+jobRoleList[0].Name+
                    '<br><br>No. Of Staff Needed: '+staffNumber+
                    '<br><br>Start Date and Time: '+startDate+
                    '<br><br>End Date and Time: '+endDate+
                    '<br><br><br>Thank you</td></tr></table>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(siterec[0].OwnerId);
            email.setHtmlBody(htmlbody);
            email.setSubject('New Shift Creation Failed');
            System.debug('email-->>'+email);
            if(!test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
        }
        return message;
    }

    /**
    *  Description : Method to get Logged-In User Information
    *  @name : getUserInformation
    *  @param : None
    *  @return : User
    *  @throws exception-none
    */
    @TestVisible
    private static User getUserInformation() {
        User user = [SELECT id, email, Name,username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, User_Image__c,state, localesidkey, mobilephone, extension, fax, contact.email
        FROM User WHERE id = :UserInfo.getUserId()];
        system.debug('++++++++++++++'+user);
        return User;
    }
}
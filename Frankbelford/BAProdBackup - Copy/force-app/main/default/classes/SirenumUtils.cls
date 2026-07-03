global without sharing class SirenumUtils {
    private static String shiftConfirmationTemplate = null;
    public static void sendShiftConfirmation(sirenum__Shift__c shift, String action) {
        //If the employee had opted out of email, do not email them
        if (shift.sirenum__Contact__r == null || shift.sirenum__Contact__r.HasOptedOutOfEmail) return;
        
        //If the global setting to send shift emails is turned off, do not send
        if (getShiftLogic().sirenum__Email_Shift_Confirmation__c == false) return;
        /*
        if (Test.isRunningTest()) {
            shiftConfirmationTemplate = 'Shift Action Email';
        } else {
            //Find the email template for the mail body
            if (shiftConfirmationTemplate == null) {
                List<EmailTemplate> t = [SELECT body FROM EmailTemplate WHERE Name = 'Shift Status Confirmation' LIMIT 1];
                if (t.size() == 0)
                    throw new SirenumException('Could not find template');
                shiftConfirmationTemplate = t[0].body;
            }
        }
        
        //Add data into the mail template, and send it
        String message = shiftConfirmationTemplate;
        message = message.replace('{!Name}', shift.sirenum__Contact__r.Name);
        message = message.replace('{!action}', action.toLowerCase());
        if (shift.sirenum__Actual_End_Time__c != null) {
            message = message.replace('{!Actual_Start_Time__c}', shift.sirenum__Actual_End_Time__c.format());
        } else {
            message = message.replace('{!Actual_Start_Time__c}', shift.sirenum__Actual_Start_Time__c.format());
        }

        //Take the shift confirmation address value from the shift logic to setReplyTo that address in the email
        sirenum__Shift_Logic__c sLogic = getShiftLogic();
        String replyToAddress = sLogic.sirenum__Shift_Confirmation_Address__c;

        SendEmailTo(message, action + ' ' + 'Confirm', shift.sirenum__contact__r.email, replyToAddress, false);*/
   }
   private static sirenum__Shift__c createShiftFromTemplate(Date day, sirenum__ShiftTemplate__c template) {
        /*DateTime startTime, endTime;
        String[] parts;
        
        if (template == null)
            return null;

        //Parse the shift start time
        Time tStart = parseTime(template.sirenum__Shift_Start_Time__c);
        startTime = DateTime.newInstance(day, tStart);
        
        //Parse the shift end time
        Integer dayMargin = 0;
        Time tEnd = parseTime(template.sirenum__Shift_End_Time__c);
        if (tEnd < tStart) {
            //End time smaller than start time? Must end the next day.
            dayMargin = 1;
        }
        endTime = DateTime.newInstance(day.addDays(dayMargin), tEnd);
        
        //Create shift object
        sirenum__Shift__c shift = new sirenum__Shift__c();
        
        shift.sirenum__Site__c = template.sirenum__Site__c;
        shift.sirenum__Scheduled_Start_Time__c = startTime;
        shift.sirenum__Scheduled_End_Time__c = endTime;
        shift.sirenum__Shift_Template__c = template.Id;
        shift.sirenum__Team__c = template.sirenum__Team__c;
        shift.sirenum__Job_Type__c = template.sirenum__Job_Type__c;
        
        
        
        
        return shift;*/
       return null;
    }
    /*public static sirenum__Shift__c createShiftFromTemplate(sirenum__TouchEntry__c touch) {
        return createShiftFromTemplate(touch, null, null);
    }
     public static sirenum__Shift__c createShiftFromTemplate(sirenum__TouchEntry__c touch, DateTime fromTime, DateTime toTime) {
        sirenum__ShiftTemplate__c result = null;
        Date day = touch.sirenum__touchTime__c.date();
        Time startTime;
        Datetime fullTime;
        Id site = null;
        
        //Retrieve the shift site from the touch location
        if (touch.sirenum__Location__r != null) {
            site = touch.sirenum__Location__r.sirenum__Site__c;
        }
        
        //Find out which teams the contact belongs to
        List<Id> teams = getTeamsForEmployee(touch.sirenum__contact_touched__c);
        List<Id> groups = getGroupsForEmployee(touch.sirenum__contact_touched__c);
        
        List<sirenum__ShiftTemplate__c> templates = null;
        //Get list of templates matching the location and group
        if (touch.sirenum__Location__r != null){
        templates =
            [SELECT Id, sirenum__Active_Days__c, sirenum__Team__c, sirenum__Job_Type__c, sirenum__Leniency__c, sirenum__Site__c, sirenum__Shift_Start_Time__c, 
            sirenum__Shift_End_Time__c 
             FROM sirenum__ShiftTemplate__c
             WHERE sirenum__Enabled__c = true
               AND (sirenum__Team__c IN :teams OR sirenum__Team__c = null)
               AND (sirenum__Sirenum_Group__c IN :groups OR sirenum__Sirenum_Group__c = null)
               AND (sirenum__Site__c =:site OR sirenum__Site__c = null)];
        }
        else{
              templates =
            [SELECT Id, sirenum__Active_Days__c, sirenum__Team__c, sirenum__Job_Type__c, sirenum__Leniency__c, sirenum__Site__c, sirenum__Shift_Start_Time__c, sirenum__Shift_End_Time__c 
             FROM sirenum__ShiftTemplate__c
             WHERE sirenum__Enabled__c = true
               AND (sirenum__Team__c IN :teams OR sirenum__Team__c = null)
               AND (sirenum__Sirenum_Group__c IN :groups OR sirenum__Sirenum_Group__c = null)
               ];
        }

        
        Long bestRating = 2147483648L, rating, leni, ratingTomorrow, ratingYesterday;
        Integer delta = 0;
        for (sirenum__ShiftTemplate__c t : templates) {
            delta = 0;
            startTime = parseTime(t.sirenum__Shift_Start_Time__c);
            fullTime = DateTime.newInstance(day, startTime);
            leni = (Long)(t.sirenum__Leniency__c * 60000); //Convert minutes to milliseconds

            //Rate the template by the difference in time between now and the shift start time
            rating = Math.abs(touch.sirenum__touchTime__c.getTime() - fullTime.getTime());
            ratingTomorrow = Math.abs(touch.sirenum__touchTime__c.getTime() - fullTime.addDays(1).getTime());
            ratingYesterday = Math.abs(touch.sirenum__touchTime__c.getTime() - fullTime.addDays(-1).getTime());
            
            if (ratingTomorrow < rating) {
                rating = ratingTomorrow;
                delta = 1;
            }
            if (ratingYesterday < rating) {
                rating = ratingYesterday;
                delta = -1;
            }

            system.debug('Leniency: ' + leni);            
            system.debug('Best rating: ' + rating + ', delta: ' + delta);
            
            fullTime = fullTime.addDays(delta);
            
            system.debug('Full Time: ' + String.valueOf(fullTime));
            system.debug('fromTime: ' + String.valueOf(fromTime));
            system.debug('toTime: ' + String.valueOf(toTime));
            if (fromTime != null && toTime != null) {
                //If min/max times have been defined, use those instead of the leniency (used in advance shift confirmation)
                if (fullTime < fromTime || fullTime > toTime)
                    continue;
            } else if (rating > leni) {
                //If the time difference is larger than the defined leniancy, skip this template
                continue;
            }
                
            system.debug('Rating passed leniency');
            system.debug('Active days: ' + t.sirenum__Active_Days__c);
            
          
            //Check that the template is active on the day of the shift
            if (t.sirenum__Active_Days__c != null && t.sirenum__Active_Days__c.length() > 0 && !t.sirenum__Active_Days__c.contains(fullTime.format('EEEE')))
                continue;
            
            system.debug('Passed active days check');
            
            //Is the rating better (smaller) than our current best? Then this template is better.
            if (rating < bestRating) {
                system.debug('Found possible template');
                result = t;
                bestRating = rating;
            }
        }
        
        if (result != null && fullTime != null)
            return createShiftFromTemplate(fullTime.date(), result);
        
        return null;
    }*/
     
   public static sirenum__Shift_Logic__c getShiftLogic() {
        sirenum__Shift_Logic__c sLogic = sirenum__Shift_Logic__c.getInstance();
        
        if (sLogic == null || sLogic.sirenum__Minimum_Shift_Length__c == null) {
            sLogic = new sirenum__Shift_Logic__c();
            sLogic.sirenum__Minimum_Shift_Length__c = 120; //120 Minutes
            sLogic.sirenum__Maximum_Shift_Length__c = 24; //24 Hours
            sLogic.sirenum__Maximum_Shift_Confirmation_Hours__c = 12;
            sLogic.sirenum__Minimum_Accuracy__c = 1500;
            sLogic.sirenum__Alert_Emails__c = '';
            sLogic.sirenum__emails_on_off__c = true;
            sLogic.sirenum__Chatter_feed_type__c ='Mixed';
            sLogic.sirenum__Week_Ending__c = 6;
            sLogic.sirenum__Confirmation_Reminder_Time__c = 160;
            sLogic.sirenum__Shift_Confirmation_Address__c = 'shiftconfirm@s-2xt5oiv8ozzn25oso961axymklf8n1xkkp1oxbb8nr2kpo2wfs.b-yiuseaw.bl.apex.salesforce.com';
            sLogic.sirenum__Checkin_Minutes_1__c = 5;
            sLogic.sirenum__Checkin_Minutes_2__c = 10;
            sLogic.sirenum__Maximum_Hours_per_Week__c = 72;
            sLogic.sirenum__Minimum_Break_Hours__c = 12;
            sLogic.sirenum__Default_Shift_Length__c = 9;
            sLogic.sirenum__Shift_Length_Warning__c = 12;
            sLogic.sirenum__Shift_End_Check_Interval__c = 120;
            sLogic.sirenum__Early_Shift_Start_Minutes__c = 120;
            sLogic.sirenum__Late_Shift_End_Minutes__c = 120;
            sLogic.sirenum__Risk_Time__c = 60;
            sLogic.sirenum__Check_End_Date__c = true;
            upsert sLogic;
         }
         
        if (sLogic.sirenum__Early_Shift_Start_Minutes__c == null)
            sLogic.sirenum__Early_Shift_Start_Minutes__c = 120;
         
        if (sLogic.sirenum__Late_Shift_End_Minutes__c == null)
            sLogic.sirenum__Late_Shift_End_Minutes__c = 120;
        
        return sLogic;
    }
    /* public static void SendEmailTo(String message, String title, String toAddress) {
            SendEmailTo(message, title, toAddress, null);
    }
    
    public static void SendEmailTo(String message, String title, String toAddress, String replyToAddr) {
            SendEmailTo(message, title, toAddress, replyToAddr, false);
    }

    public static void SendEmailTo(String message, String title, String toAddress, String replyToAddr, boolean isHTML) {
        //Don't send emails in test mode
        if (Test.isRunningTest()) return;
        
        //Validate we have an address to send to
        if (toAddress == null || toAddress.length() == 0) return;
        
  
        if (System.isFuture() || System.isBatch() || Test.isRunningTest()) {
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            String[] toAddresses = toAddress.split(',');
            
            if (replyToAddr == null)
                replyToAddr = 'sirenum@sirenum.com';
                
            mail.setReplyTo(replyToAddr);
            mail.setToAddresses(toAddresses);
            mail.setSubject(title);
            
            //Search for an organization-wide email address with the reply-from address.
            //If it exists, use it as the sender address.
            try {
                List<OrgWideEmailAddress> owe = new List<OrgWideEmailAddress>();
                
                owe = [select id, DisplayName from OrgWideEmailAddress WHERE Address = :replyToAddr];
                
                if (owe.size() > 0) {
                    mail.setOrgWideEmailAddressId(owe.get(0).Id);
                } else {
                    mail.setSenderDisplayName('Sirenum');
                }
            } catch (Exception e) {
                mail.setSenderDisplayName('Sirenum');
            }
            
            if (isHTML)
                mail.setHtmlBody(message);
            else
                mail.setPlainTextBody(message);
            if (!Test.isRunningTest())
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        } else {
            SendEmailToFuture(message, title, toAddress, replyToAddr, isHTML);
        }
    }*/
    global static Time parseTime(String value) {
        boolean isPM = false, isAM = false;

        Integer[] timeParts = new Integer[] {0,0,0};
        Integer timePart = 0;
        Integer multiplier = 1;

        Integer[] chars = value.getChars();
        Integer vLen = chars.size();

        for (Integer i=vLen - 1;i >= 0;i--) {
            Integer c = chars[i];
            
            if (c == 46 || c == 58 || c == 59 || multiplier >= 100) { //. : ; or too many digits
                if (multiplier > 1)
                    timePart++;
                multiplier = 1;
            } 
            
            if (c >= 48 && c <= 57) { //Digit
                Integer current = timeParts[timePart];

                timeParts[timePart] = current + (multiplier * (c - 48));
                multiplier *= 10;
            } else if (c == 80 || c == 112) { //p or P
                isPM = true;
                isAM = false;
            } else if (c == 65 || c == 97) { //a or A
                isPM = false;
                isAM = true;
            }
        }

        Integer hour, minute, second;
        if (timePart >= 2) {
            hour = timeParts[2];
            minute = timeParts[1];
            second = timeParts[0];
        } else if (timePart == 1) {
            hour = timeParts[1];
            minute = timeParts[0];
            second = 0;
        } else {
            hour = timeParts[0];
            minute = 0;
            second = 0;
        }

        if (hour < 12 && isPM) {
            hour += 12;
        } else if (hour >= 12 && isAM) {
            hour -= 12;
        }

        Time t = Time.newInstance(hour, minute, second, 0);

        return t;

        /*value = value.toLowerCase();
        isAM = (value.contains('a'));
        isPM = (value.contains('p'));

        value = value.replace('p', '').replace('a', '').replace('m', '').replace('.', ':').replace(' ', '');
        
        if (!value.contains(':') && value.length() > 2) {
            if (value.length() == 3)
                value = value.left(1) + ':' + value.subString(1);
            else
                value = value.left(2) + ':' + value.subString(2);
        }

        String[] parts = value.split(':');
        
        Integer h=0,m=0,s=0;
        h = Integer.valueOf(parts[0]);
        if (parts.size() > 1)
            m = Integer.valueOf(parts[1]);
        if (parts.size() > 2)
            s = Integer.valueOf(parts[2]);
        
        if (isPM && h < 12)
            h += 12;
        if (isAM && h >= 12)
            h -= 12;
            
        Time t = Time.newInstance(h,m,s, 0);
        
        return t;*/
    }
    
    /**
     * Formats a DateTime object as only the time: HH:MM
     */
    public static String formatTime(DateTime dt) {
        String result = '';
        if (dt.time().hour() < 10) result += '0';
        result += dt.time().hour();
        result += ':';
        if (dt.time().minute() < 10) result += '0';
        result += dt.time().minute();
        return result;
    }
   /*  @future
    public static void SendEmailToFuture(String message, String title, String toAddress, String replyToAddr, boolean isHTML) {
        SendEmailTo(message, title, toAddress, replyToAddr, isHTML);
    }*/
    
    public static List<Id> getTeamsForEmployee(Id contactId) {
        List<Id> result = new List<Id>();
        List<sirenum__Staff_Team_Membership__c> lst = [SELECT sirenum__Team__c 
        FROM sirenum__Staff_Team_Membership__c WHERE sirenum__Staff_Member__c =: contactId];
        for (sirenum__Staff_Team_Membership__c m : lst) {
            result.add(m.sirenum__Team__c);
        }
        return result;
    }
    
    /**
     * Returns a list of all groups the contact is a member of
     */
    public static List<Id> getGroupsForEmployee(Id contactId) {
        List<Id> result = new List<Id>();
        List<sirenum__SirenumGroup_Membership__c> lst = [SELECT sirenum__SirenumGroup__c FROM sirenum__SirenumGroup_Membership__c 
        WHERE sirenum__Contact__c =: contactId];
        for (sirenum__SirenumGroup_Membership__c m : lst) {
            result.add(m.sirenum__SirenumGroup__c);
        }
        return result;
    }
    public static sirenum__TouchEntry__c createNonTagTouch(Contact contact, String tagId) {
        return createNonTagTouch(contact, tagId, null, null, null);
    }
    
    public static sirenum__TouchEntry__c createNonTagTouch(Contact contact, String tagId, String ipAddress) {
        return createNonTagTouch(contact, tagId, null, null, null, null);
    }

    public static sirenum__TouchEntry__c createNonTagTouch(Contact contact, String tagId, Decimal lat, Decimal lng, Decimal accuracy) {
        return createNonTagTouch(contact, tagId, null, lat, lng, accuracy);
    }
        
    public static sirenum__TouchEntry__c createNonTagTouch(Contact contact, String tagId, String ipAddress, Decimal lat, Decimal lng, Decimal accuracy) {
        sirenum__TouchEntry__c touch = new sirenum__TouchEntry__c();
        touch.sirenum__Tag_UID__c = tagId;
        touch.sirenum__TouchTime__c = system.now();
        touch.sirenum__Developer_Mode__c = 'false';
        touch.sirenum__Contact_Touched__c = contact.id;
        

        
            insert touch;
     

        return touch;
    }
     private static Map<String, Shift_LogicHandler.Action> actionPhrases = null;
    /**
     * Returns a map of phrases, and their corresponding Shift Logic actions
     */
    public static Map<String, Shift_LogicHandler.Action> getActionPhrases() {
        if (actionPhrases == null) {
            actionPhrases = new Map<String, Shift_LogicHandler.Action>();
            /* Confirm Phrases */
            actionPhrases.put('on my way', Shift_LogicHandler.Action.Confirm);
            actionPhrases.put('i\'m coming', Shift_LogicHandler.Action.Confirm);
            actionPhrases.put('confirm', Shift_LogicHandler.Action.Confirm);
            
            /* Start Shift Phrases */
            actionPhrases.put('at the office', Shift_LogicHandler.Action.StartShift);
            actionPhrases.put('at work', Shift_LogicHandler.Action.StartShift);
            actionPhrases.put('sign in', Shift_LogicHandler.Action.StartShift);
            actionPhrases.put('signin', Shift_LogicHandler.Action.StartShift);
            actionPhrases.put('sing in', Shift_LogicHandler.Action.StartShift); //common typo
            actionPhrases.put('clock in', Shift_LogicHandler.Action.StartShift);
            
            /* End Shift Phrases */
            actionPhrases.put('left the office', Shift_LogicHandler.Action.EndShift);
            actionPhrases.put('left work', Shift_LogicHandler.Action.EndShift);
            actionPhrases.put('sign out', Shift_LogicHandler.Action.EndShift);
            actionPhrases.put('signout', Shift_LogicHandler.Action.EndShift);
            actionPhrases.put('sing out', Shift_LogicHandler.Action.EndShift); //common typo
            actionPhrases.put('clock out', Shift_LogicHandler.Action.EndShift);
        }
    
        return actionPhrases;
    }
     public static contact identifyContact(string cleanFromNumber){
        return identifyContact(cleanFromNumber, null);
    }
    public static contact identifyContact(string cleanFromNumber, string body){
        if(body == null)
            body = 'Unknown';
        sirenum__Sirenum_Global_Settings__c global_settings = sirenum__Sirenum_Global_Settings__c.getInstance(); 
        string noPrefix = cleanFromNumber.replace(global_settings.SMS_Country_Code__c, '');        
        string zs_number = cleanFromNumber.replace(global_settings.SMS_Country_Code__c, '0');
        string zzff_number = cleanFromNumber.replace(global_settings.SMS_Country_Code__c, '0044');
        system.debug('CleanedNumeber: ' + cleanFromNumber);
        
             
        List <Contact> contactList = [SELECT Id, MobilePhone, email,  ownerId 
                                             FROM Contact
                                             WHERE   mobilePhone =:cleanFromNumber
                                             or Phone =: cleanFromNumber
                                             or HomePhone =: cleanFromNumber
                                             or AssistantPhone =: cleanFromNumber
                                             or OtherPhone =: cleanFromNumber
                                             or sirenum__Additional_Phone_Sanitised__c =:cleanFromNumber
                                             or MobilePhone like: '%' + noPrefix
                                             or Phone LIKE: '%' +noPrefix 
                                             or HomePhone LIKE: '%' +noPrefix 
                                             or AssistantPhone LIKE: '%' +noPrefix 
                                             or OtherPhone LIKE: '%' +noPrefix  
                                             or sirenum__Additional_Phone_Sanitised__c like: '%' + noPrefix
                                             or MobilePhone like: zzff_number 
                                             or Phone LIKE: zzff_number 
                                             or HomePhone LIKE: zzff_number 
                                             or AssistantPhone LIKE: zzff_number 
                                             or OtherPhone LIKE: zzff_number 
                                             or sirenum__Additional_Phone_Sanitised__c LIKE: zzff_number 
                                             or MobilePhone like: zs_number 
                                             or Phone LIKE: zs_number 
                                             or HomePhone LIKE: zs_number 
                                             or AssistantPhone LIKE: zs_number 
                                             or OtherPhone LIKE: zs_number 
                                             or sirenum__Additional_Phone_Sanitised__c LIKE: zs_number 
                                             ORDER BY sirenum__Last_Timesheet__c DESC NULLS LAST];
                                             
        system.debug('Contacts Found : ' + contactList.size() );
         
        if(contactList.size() > 0) {            
           for (Contact contact : contactList){  
                createLog(contact.id,'From:' + cleanFromNumber+ ' - ' + body, 'Incomming SMS');   
            }   
            if(contactList.size() == 1)
                return contactList[0];
            else{
                for (Contact c : contactList)
                    return c;
                        
                return contactList[0];
            }     
        }    
        return null;
    }
    
    public static String formatPhone(String mNumber, String defaultcountryCode) {    
        String pureNumbers = mNumber.replaceAll('\\D', '');
        String countryCode = (defaultcountryCode != null) ? defaultcountryCode.replaceAll('\\D', '') : ''; 
        String plus = '+';
        
        if (countryCode == '')
            return mNumber;
            
        if (pureNumbers.startsWith(countryCode)){
            //number was 44 or +44, converted to +44
            return plus + pureNumbers;
        } else if(pureNumbers.startsWith('00')){           
            if(pureNumbers.length() >= 10  ){
                //Has country code and Number, 10 digits for UK and 10 digits for US
                String dblZeroClean = pureNumbers.removeStart('00');
                if(dblZeroClean.startsWith(countryCode)){
                    //number was 0044, converted to +44
                    return plus + dblZeroClean;
                }else if(dblZeroClean.length() > 11){
                    return plus + dblZeroClean; 
                }else {
                    //Mispelled (007583...) or doesnt have country code
                    return plus + countryCode + dblZeroClean;
                }
            } else if(pureNumbers.length() < 10){
                //Unknown but starts with 00
                return mNumber;
            }
        }else if(mNumber.startsWith('+')){
            //country code does not match phone pre-fix
            return plus +  pureNumbers;
        }else{
            //No country code, and number is long, probably another country
            if(pureNumbers.length() > 11)
                 return plus + pureNumbers;            
            else if(pureNumbers.length() <= 11
            && pureNumbers.length() > 9)
                return plus + countryCode + pureNumbers;
            else
                return mNumber;
        }
        
        return mNumber;
        
    }
    public static void createLog(string fromNumber, string message, string category){
        sirenum__Sirenum_Global_Settings__c global_settings = sirenum__Sirenum_Global_Settings__c.getInstance();
        String cleanFromNumber =  formatPhone(fromNumber, global_settings.SMS_Country_Code__c);            
        Contact sender = null;
        sender = identifyContact(cleanFromNumber);
        
        createLog(sender.id, message, category);
    }
    public static  void createLog(id contactId, string message, string category){
        sirenum__LogEntry__c text = new sirenum__LogEntry__c();
        text.sirenum__contact__c = contactId;
        text.sirenum__Details__c = message;
        text.sirenum__Category__c= category;
        insert text;
    }
     public static void createLog(string message, string category){
        sirenum__LogEntry__c text = new sirenum__LogEntry__c();
        text.sirenum__Details__c = message;
        text.sirenum__Category__c= category;
        insert text;
    }
    public class SirenumException extends exception{}
}
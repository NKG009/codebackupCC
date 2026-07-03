public without sharing class  TwilioClientController {   
    public String fromNumber{get;set;}
    public String toNumber{get;set;}
    public String body{get;set;}
    private static final Integer MAX_SHIFT_TIME_HOURS = 12;
    public PageReference response = new PageReference('https://');
     
    private static final String PARAM_USER =  'username=';
    private static final String PARAM_PASSWORD = 'password=';
    private static final String PARAM_MESSAGE = 'message=';
    private static final String PARAM_SENDER = 'sender=';
    private static final String PARAM_PHONE_NO = 'numbers=';
    private static final String PARAM_ENCODING = 'UTF-8';
    private static final String PROVIDER_TWILIO = 'Twilio';
    private static final Map<String, Shift_LogicHandler.Action> phrases;
    
    public  sirenum__Sirenum_Global_Settings__c  global_settings;
    
    public TwilioClientController() { 
    }
    static {
        //Add email-only phrases to the list of action phrases
        phrases = SirenumUtils.getActionPhrases().clone();
        phrases.put('start', Shift_LogicHandler.Action.StartShift);
        phrases.put('begin', Shift_LogicHandler.Action.StartShift);
        phrases.put('end', Shift_LogicHandler.Action.EndShift);
        phrases.put('finish', Shift_LogicHandler.Action.EndShift);
    }
    // Receiving.... 
    public pageReference init(){
          
        if(!Test.isRunningTest()){
            fromNumber = ApexPages.currentPage().getParameters().get('From');
            toNumber = ApexPages.currentPage().getParameters().get('To');
            body = ApexPages.currentPage().getParameters().get('Body'); 
        } 
        System.debug('FROM: ' + fromNumber);
        System.debug('TO: ' + toNumber);
        System.debug('BODY: ' + body);
        
               
        if(fromNumber != null && toNumber != null && body != null){            
            saveIncomingText();
        }else{
            sirenumUtils.createLog(fromNumber + ', ' + tonumber + ', ' + body, 'SMS Unhalted');
        }
        
        
        return null;
    }
    
 
    public void saveIncomingText() {    
        try{   
            global_settings = sirenum__Sirenum_Global_Settings__c.getInstance();
            String cleanFromNumber =  SirenumUtils.formatPhone(fromNumber, global_settings.SMS_Country_Code__c);
            system.debug('Clean From Save : ' + cleanFromNumber  );
            
            Contact sender = null;
            String contents = body;
            sirenum__Shift__c shift = null;
            sender = sirenumUtils.identifyContact(cleanFromNumber, body);
            system.debug('Sender: ' + sender);
            
             
            if(sender == null ){
                if(!Test.isRunningTest()){
                    sendSmsFuture(fromNumber, global_settings.SMS_Contact_not_found_Message__c, 0); 
                    sendEMAIL(global_settings.SMS_Contact_not_found_Message__c + '-', fromNumber, toNumber, body, 0, '');
                }
                sirenumUtils.createLog('Couldn\'t find contact on the system. -'+ fromNumber+ toNumber, 'SMS - NOT IN SYSTEM');
                return;
            }
       
            contents = contents.toLowerCase();
            Shift_LogicHandler.Action action = null;
            String touchType = '[Text]';
             
            Integer bestPosition = -1, position;
            action = null;
            
            boolean foundTrigger = false;           
            //Iterate over all trigger phrases
            for (String key : phrases.keySet()) {
                position = contents.indexOf(key);
                if (position >= 0) {
                    if (position < bestPosition || action == null) {
                        foundTrigger = true;
                        //Trigger found - perform the action
                        action = phrases.get(key);
                        bestPosition = position;
                    }
                }
            }
            if(!foundTrigger){
                if(!Test.isRunningTest())
                    sendSmsFuture(fromNumber, 'Dont understand "' + body + '".', 1);
                sirenumUtils.createLog('Dont understand "' + body + '".', 'SMS PARSE FAIL');
                return;
            }
            
            if (action == Shift_LogicHandler.Action.StartShift || action == Shift_LogicHandler.Action.EndShift) {
                //Activate shift logic to start/end a shift
                shift = Shift_LogicHandler.associateTouchToShift2(SirenumUtils.createNonTagTouch(sender, touchType), null, action);
                
                if (shift == null) {
                    if (action == Shift_LogicHandler.Action.EndShift){                        
                        sendSMSFUTURE(sender.id, 'You do not have started shifts', 1);
                        return;
                    }else
                        sendSMSFUTURE(sender.id, 'You have unfinished shift', 1);
                }

                shift = [SELECT Id, Name, sirenum__Is_Confirmed__c, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c, 
                sirenum__Site__c, sirenum__Site__r.name, sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Actual_Start_Time__c, 
                sirenum__Actual_End_Time__c, sirenum__Text_Messages_Received__c 
                        FROM sirenum__Shift__c 
                        WHERE id=:shift.id LIMIT 1][0];
                

               
                updateTextCounter(shift);
                Database.update(shift);
                
                string actionHapened='';
                if(action == Shift_LogicHandler.Action.StartShift)
                    actionHapened = 'Shift Started';
                else
                    actionHapened = 'Shift Ended';
                //sirenumUtils.createLog(fromNumber, actionHapened, 'SMS - Success');
                sendSmsFuture(fromNumber, actionHapened , 1);
                
               
            } else {
                //Find and confirm the sender's next shift
                shift = confirmNextShift(sender, fromNumber);                
                sendSms(fromNumber, 'Confirmed', 1);
            }
            
            
        }catch(Exception e ){
            string errorMsg = 'Error: ' + e.getMessage() + ' at line ' + e.getLineNumber() + ' - ';
            sendEMAIL(errorMsg, fromNumber, toNumber, body, 0, '');
            sirenumUtils.createLog(errorMsg, 'ERROR SMS');        
            system.debug('***' + errorMsg);
          
        }
    }
   
    
   
    static public String sendSms(id contactId, String message, Integer isTest) {
        
        list<contact> cons = [select id, MobilePhone ,  HomePhone , AssistantPhone ,OtherPhone , Phone 
                             from contact
                             where id =: contactId];
        if(cons.size() == 0)
            return null;
        string thePhone = '';                   
        if(cons[0].MobilePhone != null)
            thePhone = cons[0].MobilePhone;
        else if(cons[0].Phone != null)
            thePhone = cons[0].Phone;
        else if(cons[0].HomePhone != null)
            thePhone = cons[0].HomePhone;
        else if(cons[0].OtherPhone != null)
            thePhone = cons[0].OtherPhone;
        else if(cons[0].AssistantPhone != null)
            thePhone = cons[0].AssistantPhone;
        else
            return null;
        
        return sendSms(thePhone ,message,isTest);
    }
    @future (callout=true)
    public static void sendSMSFuture(String mobileNumber, String message, Integer isTest) {
        sendSms(mobileNumber, message, isTest);
    }
    @future(callout=true)
    public static void sendSMSFuture(id contactId, String message, Integer isTest) {
        sendSms(contactId, message, isTest);
    }
    public static  String sendSms(String mobileNumber, String message, Integer isTest) {
        //Log against contact
        
        sirenum__Sirenum_Global_Settings__c global_settings = sirenum__Sirenum_Global_Settings__c.getInstance();
        if(global_settings.SMS_Replies__c == false)
            return null;
        //Create URL-encoded parameter list
        List<String> settings = new List<String>();
        settings.add(EncodingUtil.urlEncode(global_settings.sirenum__SMS_Username__c, PARAM_ENCODING));
        settings.add(EncodingUtil.urlEncode(global_settings.sirenum__SMS_Password__c, PARAM_ENCODING));
        settings.add(EncodingUtil.urlEncode(message, PARAM_ENCODING));
        settings.add(EncodingUtil.urlEncode(global_settings.sirenum__SMS_Sender__c, PARAM_ENCODING));
        settings.add(EncodingUtil.urlEncode(mobileNumber, PARAM_ENCODING));
        
        String queryBody, endPoint;
        HttpRequest req = new HttpRequest();
        
        if (PROVIDER_TWILIO.equals(global_settings.sirenum__SMS_provider__c)) {
            //TWILIO
            queryBody = String.format('To={4}&From={3}&Body={2}', settings);
            endPoint = 'https://api.twilio.com/2010-04-01/Accounts/' + global_settings.sirenum__SMS_Username__c + '/Messages.json';
            
            //Set authentication            
            Blob authenticationHeader = Blob.valueOf(global_settings.sirenum__SMS_Username__c + ':' + global_settings.sirenum__SMS_Password__c);
            req.setHeader('Authorization', 'BASIC ' + EncodingUtil.base64Encode(authenticationHeader));
            
        } 
        
        // Create a new http object to send the request object  
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(QueryBody);
        
        // A response object is generated as a result of the request    
        Http http = new Http();
        System.debug(logginglevel.INFO, 'TextingModule: QueryString Body>>> '+req.getBody());
        if(Test.isRunningTest()){
            return 'success';
        }else{
            HTTPResponse res = http.send(req); //send request to other server
            // Log the XML content
            System.debug(logginglevel.INFO, 'TextingModule: ResponseString>>>'+res.getBody());
            
            return  res.getStatus();
        }
        sirenumUtils.createLog(mobileNumber+ ' : ' + message, 'SMS - Outbound');
        return null;
    }
    
    public static void sendEMAIL(string emailBody, string fromNumber, string toNumber, string body, integer type, string fromEmail){
        /*
            type 0 = debug error
            type 1 = debug success
            type 2 = send to confirm
       */
        try{
            sirenum__Sirenum_Global_Settings__c global_settings = sirenum__Sirenum_Global_Settings__c.getInstance();
            
            Messaging.reserveSingleEmailCapacity(1);        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
            String[] toAddresses = new String[] {global_settings.SMS_Errors_recepiend__c};           
            mail.setToAddresses(toAddresses);        
            mail.setReplyTo(global_settings.SMS_Errors_recepiend__c);        
            
            mail.setSenderDisplayName('SMS Support');   
           
            mail.setBccSender(false);        
            mail.setUseSignature(false);   
                           
            if(type == 0){
                mail.setSubject('New SMS ERROR');
                mail.setPlainTextBody(emailBody + ' New SMS received from ' + fromNumber + ' to ' + toNumber + ':' + body);        
                mail.setHtmlBody(emailBody + ' New SMS received from ' + fromNumber + ' to ' + toNumber + ':' + body ); 
            }else if(type == 1){
                 mail.setSubject('New SMS RECEIVED');
                mail.setPlainTextBody(emailBody + ' New SMS received from ' + fromNumber + ' to ' + toNumber + ':' + body);        
                mail.setHtmlBody(emailBody + ' New SMS received from ' + fromNumber + ' to ' + toNumber + ':' + body ); 
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e ){
            string errorMsg = 'Error: ' + e.getMessage() + ' at line ' + e.getLineNumber() + ' - ';
            sirenumUtils.createLog(errorMsg, 'SMS - Failed EMAIL');
           
        }
    }
    private static void updateTextCounter(sirenum__Shift__c shift) {
        //We keep a counter of all text messages received for expense returns
        Decimal texts = (shift.sirenum__Text_Messages_Received__c == null) ? 0 : shift.sirenum__Text_Messages_Received__c;
        texts += 1;
            shift.sirenum__Text_Messages_Received__c = texts;
        
    }
    
    public static sirenum__Shift__c confirmNextShift(Contact sender, string fromNumber) {
        return confirmNextShift(sender, false, fromNumber);
    }
    
    public static sirenum__Shift__c confirmNextShift(Contact sender, boolean isTextMessage, string fromNumber) {
        return confirmNextShift(sender, isTextMessage, true, fromNumber);
    }
    
    public static sirenum__Shift__c confirmNextShift(Contact sender, boolean isTextMessage, boolean createChatterFeed, string FromNumber) {
        Datetime maxShiftTime = system.now().addHours(MAX_SHIFT_TIME_HOURS);
        Datetime minShiftTime = system.now().addHours(-2); 
        sirenum__Shift__c shift = null;
        
        sirenum__ShiftTemplate__c temp = null;
        //Find a contact's upcoming scheduled shift

        List<sirenum__Shift__c> shifts;
            shifts = [SELECT Id, Name, sirenum__Is_Confirmed__c, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c, sirenum__Site__c, 
            sirenum__Site__r.name, sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Text_Messages_Received__c 
                    FROM sirenum__Shift__c 
                    WHERE sirenum__Contact__c = :sender.id 
                    AND sirenum__Scheduled_Start_Time__c < :maxShiftTime 
                    AND sirenum__Scheduled_Start_Time__c >= :minShiftTime 
                    AND sirenum__Cancelled__c = false 
                    ORDER BY sirenum__Scheduled_Start_Time__c];
        
      
        
      //If a shift was not found, check for shift templates coming up
        /*if (shifts.size() == 0) {
            sirenum__TouchEntry__c t = new sirenum__TouchEntry__c();
            t.sirenum__Contact_Touched__c = sender.Id;
            t.sirenum__Contact_Touched__r = sender;
            t.sirenum__TouchTime__c = system.now();
            
            //Attempt to create a shift from a template            
            if (shift != null) {
                //Shift found - add it to the result list
                    shift.sirenum__Contact__c = sender.Id;
                    shift.sirenum__Contact__r = sender;
              
                    temp = [SELECT Id, sirenum__Confirmed_Shifts__c, sirenum__Unconfirmed_Shifts__c 
                    FROM sirenum__ShiftTemplate__c 
                    WHERE id =: shift.sirenum__Shift_Template__c 
                    ORDER BY Name DESC];
                            
                    insert shift;
                
                if (temp != null) {
                    temp.sirenum__Shift__c=shift.id;
                    
                        if (temp.sirenum__Confirmed_Shifts__c == null)
                            temp.sirenum__Confirmed_Shifts__c = 1;
                        else
                            temp.sirenum__Confirmed_Shifts__c += 1;

                                
                        update temp;
                    
                    
                }
                shifts = new List<sirenum__Shift__c>();
                shifts.add(shift);
            }
        }
        */
        //Verify we found a shift
        if (shifts.size() == 0) {
            String previousTime = SirenumUtils.formatTime(minShiftTime);
            String toTime = SirenumUtils.formatTime(maxShiftTime);
            //TODO SEND SMS - Nothing to confirm
            sendSMSFuture(FromNumber, 'No shifts to confirm yet.', 1);
            return null;
            //throw new SirenumException('Exception no shifts found between: '+ previousTime  + ' ' + toTime );
        }

        for (sirenum__Shift__c s : shifts) {
            shift = s;
            if (shift.sirenum__Scheduled_Start_Time__c > system.now())
                break;
        }

        //Update shift confirmation status
        if (shift.sirenum__Is_Confirmed__c == true) {
            sendSMSFuture(shift.sirenum__Contact__c, 'Shift is confirmed', 1);
            throw new SirenumException ('Shift is confirmed');
        }
        
        updateTextCounter(shift);
        
        //Put all the shifts that are going to be confirmed in a list
        List<sirenum__Shift__c> shiftsToConfirm = new List<sirenum__Shift__c>();
        shiftsToConfirm.add(shift);
        
        //Check if there is a "following" shift - a shift that starts soon after the current shift ends
        DateTime maxFollowTime = shift.sirenum__Scheduled_End_Time__c.addHours(3);
        //Authorisation to read shifts has already been tested
        List<sirenum__Shift__c> followShifts = [SELECT Id, sirenum__Confirmed_Time__c 
                                            FROM sirenum__Shift__c 
                                            WHERE sirenum__Contact__c = :shift.sirenum__Contact__c 
                                            AND sirenum__Scheduled_Start_Time__c >= :shift.sirenum__Scheduled_End_Time__c 
                                            AND sirenum__Scheduled_Start_Time__c <= :maxFollowTime 
                                            AND sirenum__Cancelled__c = false];
        for (sirenum__Shift__c s : followShifts) {
            shiftsToConfirm.add(s);
        }
        
        for (sirenum__Shift__c s : shiftsToConfirm)
            s.sirenum__Confirmed_Time__c = system.now();
        Database.SaveResult[] ur = Database.update(shiftsToConfirm);
        
        for (Database.SaveResult r : ur) {
            if (!r.isSuccess())
                throw new SirenumException('Error confirming shift');
        }
        
          return shift;
    }
    
    public class PageException extends exception{}
    public class sirenumException extends exception{}
}
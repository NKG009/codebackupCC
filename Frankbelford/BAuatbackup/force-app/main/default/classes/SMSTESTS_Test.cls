@isTest
private class SMSTESTS_Test {
    /* TwilioController */
    public static void createSettings(){
        sirenum__Sirenum_Global_Settings__c gs = new sirenum__Sirenum_Global_Settings__c(
                                                SMS_Confirmation_EMAIL__c = 'Confirmed',
                                                SMS_Contact_not_found_Message__c = 'Contact not found',
                                                SMS_Country_Code__c= '+44',
                                                SMS_Errors_recepiend__c = 'James.Ridge@sirenum.com',
                                                SMS_Forward_to_email__c = true, 
                                                sirenum__SMS_Password__c = '0149c0fa97fe8e7bbb75684cfd6ea7d2',
                                                sirenum__SMS_Sender__c = '+447481340402',
                                                sirenum__SMS_Username__c = 'AC0447311ffd3bb268d458f82ae4a20576',
                                                sirenum__Contacts_Filter__c = 'firstName != null',
                                                sirenum__VAT__c = 20,
                                                sirenum__Scheduling_Hidden_Elements__c = 'test1,*test2',
                                                sirenum__SMS_provider__c = 'Twilio',
                                                SMS_Replies__c = true
                                                );
        insert gs;
        /*TwilioConfig__c tg = new TwilioConfig__c(name = 'Global',
                                                AccountSid__c = 'AC0447311ffd3bb268d458f82ae4a20576',
                                                ApplicationSid__c = 'AP046b3e0d7af25f9492a52ce96a6f353b',
                                                AuthToken__c = '0149c0fa97fe8e7bbb75684cfd6ea7d2',
                                                CallerId__c = '+447481340402',
                                                OwnerId__c = '');
        insert tg;*/
    }

    public static testmethod void messageDoubleStartAdhoc(){
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        createSettings();
        
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'Sign In';
        
        controller.init();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - Sign In ** ', messages);
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__AdHoc__c = 'Ad-Hoc'
                                        and sirenum__actual_start_time__c != null
                                        and sirenum__Published__c = true];
        //system.assertEquals(1, shifts.size());
        
        //Now sign in again
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'Sign In';
        
        controller.init();
      
        shifts = [select id
                    from sirenum__shift__c
                    where sirenum__contact__c =: c.id
                    and sirenum__AdHoc__c = 'Ad-Hoc'
                    ];
        //system.assertEquals(1, shifts.size());
        
        
        
    }
    
    public static testmethod void messageEndAdhoc(){
         account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        createSettings();
        
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'Sign In';
        
        controller.init();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - Sign In ** ', messages);
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__AdHoc__c = 'Ad-Hoc'
                                        and sirenum__actual_start_time__c != null
                                        and sirenum__Published__c = true];
        //system.assertEquals(1, shifts.size());
        
        //Now sign Out
        controller.body = 'Sign out';
        
        controller.init();
         shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__AdHoc__c = 'Ad-Hoc'
                                        and sirenum__actual_end_time__c != null
                                        ];
        //system.assertEquals(1, shifts.size());
        
    }
    
    public static testmethod void testEmail(){
        integer toBegin = Limits.getEmailInvocations();
        twilioclientcontroller.sendEMAIL('TestEmail', '07583331473', '010101010101', 'body of email', 0, '');
        integer toEnd = Limits.getEmailInvocations();
        
        system.assert(toBegin== toEnd);
    }
    public static testmethod void messageShiftConfirmNoShift(){
        
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        createSettings();
        
        test.startTest();
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'confirm';
        
        controller.init();
        test.stopTest();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        //system.assertEquals(5, le.size());
        system.assertEquals(1, le.size());
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__Confirmed_Time__c != null
                                      ];
        system.assertEquals(0, shifts.size());
        
    }
    
    public static testmethod void messageScheduledShiftConfirm2(){
        
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        sirenum__shift__c shift = new sirenum__shift__c(sirenum__scheduled_start_time__c = system.now().addMinutes(185),
                                                        sirenum__scheduled_end_time__c = system.now().addMinutes(360),
                                                        sirenum__contact__c = c.id);
        insert shift;
        createSettings();
        
        test.startTest();
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'ale confirm';
        
        controller.init();
        test.stopTest();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - ale confirm ** From:+447583331473 - Unknown ** Confirmed ** ', messages);
        system.assertEquals('From:+447583331473 - ale confirm ** ', messages);
        
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__Confirmed_Time__c != null
                                      ];
        system.assertEquals(1, shifts.size());
        
    }
    public static testmethod void messageScheduledShiftHTTPTest(){
        
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        sirenum__shift__c shift = new sirenum__shift__c(sirenum__scheduled_start_time__c = system.now().addMinutes(185),
                                                        sirenum__scheduled_end_time__c = system.now().addMinutes(360),
                                                        sirenum__contact__c = c.id);
        insert shift;
        createSettings();
        
        test.startTest();
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'confirm';
        
        controller.init();
        test.stopTest();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - confirm ** From:+447583331473 - Unknown ** Confirmed ** ', messages);
        system.assertEquals('From:+447583331473 - confirm ** ', messages);
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__Confirmed_Time__c != null
                                      ];
        system.assertEquals(1, shifts.size());
        
    }
    
    
    public static testmethod void messageScheduledShiftStart(){
        
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        sirenum__shift__c shift = new sirenum__shift__c(sirenum__scheduled_start_time__c = system.now().addMinutes(-5),
                                                        sirenum__scheduled_end_time__c = system.now().addMinutes(180),
                                                        sirenum__contact__c = c.id);
        insert shift;
        createSettings();
        
        test.startTest();
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'Sign in';
        
        controller.init();
        test.stopTest();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - Sign in ** From:+447583331473 - Unknown ** Shift Started ** ', messages);
        system.assertEquals('From:+447583331473 - Sign in ** ', messages);
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__actual_start_time__c != null
                                        and sirenum__start_touch__c != null];
        system.assertEquals(1, shifts.size());
        
    }
    
    
    public static testmethod void messageEndAdhocError(){
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        createSettings();
        
        test.startTest();
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'Sign out';
        
        controller.init();
        test.stopTest();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - Sign out ** From:+447583331473 - Unknown ** You do not have started shifts ** ', messages);
        system.assertEquals('From:+447583331473 - Sign out ** ', messages);
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__AdHoc__c = 'Ad-Hoc'];
        system.assertEquals(0, shifts.size());
        
    }
    
    public static testmethod void messageStartAdhoc(){
         account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        createSettings();
        
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'Sign In';
        
        controller.init();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        //system.assertEquals('From:+447583331473 - Sign In ** ', messages);
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c
                                        where sirenum__contact__c =: c.id
                                        and sirenum__AdHoc__c = 'Ad-Hoc'];
        //system.assertEquals(1, shifts.size());
        
    }
    
    
    public static testmethod void messageKnownParseError(){
         account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', 
                                    lastName = 'lName', 
                                    email= 'email@gmail.com', 
                                    accountId = a.id, 
                                    mobilephone = '+447583331473');
        insert c;
        createSettings();
        
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'body';
        
        controller.init();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        string messages = '';        
        for(sirenum__logentry__c l : le){
            messages  += l.sirenum__Details__c + ' ** ';
        }
        system.assertEquals('From:+447583331473 - body ** Dont understand "body". ** ', messages);
        
    }
    
    
    public static testmethod void messageUnknown(){
        createSettings();
        
        TwilioClientController controller = new TwilioClientController();
        controller.fromNumber= '+447583331473';
        controller.toNumber = '+447481340402';
        controller.body = 'body';
        
        controller.init();
        
        list<sirenum__logentry__c> le = [select id, name, sirenum__Category__c, sirenum__Details__c, sirenum__contact__c
                                        from sirenum__logentry__c];
        system.assertEquals(1, le.size());
        system.assertEquals('SMS - NOT IN SYSTEM', le[0].sirenum__Category__c);
        
    }
   
    /* SirenumUtilsTests */  
   /*
    public static testMethod void createShiftFromTemplate(){
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', lastName = 'lName', email= 'email@gmail.com', accountId = a.id);
        insert c;
        sirenum__TouchEntry__c t = new sirenum__TouchEntry__c();
        t.sirenum__Contact_Touched__c = c.Id;
        t.sirenum__Contact_Touched__r = c;
        t.sirenum__TouchTime__c = system.now();
        insert t;
        
        sirenumUtils.createShiftFromTemplate(t);
        
        list<sirenum__shift__c> shifts = [select id
                                        from sirenum__shift__c];
        system.assertEquals(0, shifts.size());
       
    }
    public static testMethod void SendEmailToFuture(){
        SirenumUtils.SendEmailToFuture('test','test','test','test',true);
      
    }
    
    
    public static testMethod void getTeamsForEmployee(){
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', lastName = 'lName', email= 'email@gmail.com', accountId = a.id);
        insert c;
        sirenum__Team__c t = new sirenum__Team__c(name ='test');
        insert t;
        sirenum__Staff_Team_Membership__c  stm = new sirenum__Staff_Team_Membership__c (sirenum__Staff_Member__c = c.id, 
                                                                                        sirenum__Team__c = t.id);
        insert stm;
        
        list<id> tfe = sirenumutils.getTeamsForEmployee(c.id);
        
        system.assertEquals(1, tfe.size());
    }
*/
    public static testMethod void createNonTagTouch(){
        account a = new account(name='test acc');
        insert a;
        contact c  = new contact(firstName = 'Name', lastName = 'lName', email= 'email@gmail.com', accountId = a.id);
        insert c;
        sirenum__TouchEntry__c te = sirenumUtils.createNonTagTouch(c, 'test');
        system.assertEquals(te.sirenum__Contact_Touched__c , c.id);
    }
    public static testMethod void getActionPhrases(){
        Map<String, Shift_LogicHandler.Action> mslh = sirenumutils.getActionPhrases();
        system.assertEquals(15, mslh.size());
    }
    public static testmethod void getShiftLogic(){
         sirenum__Shift_Logic__c  sl = SirenumUtils.getShiftLogic();
         
         sl = [select id, sirenum__Minimum_Shift_Length__c from sirenum__Shift_Logic__c  ];
         system.assertequals(120, sl.sirenum__Minimum_Shift_Length__c);
     }
     public static testmethod void getGroupsForEmployee(){
         account a = new account(name='test acc');
         insert a;
         contact c  = new contact(firstName = 'Name', lastName = 'lName', email= 'email@gmail.com', accountId = a.id);
         insert c;
         sirenum__SirenumGroup__c sg = new sirenum__SirenumGroup__c (name ='group');
         insert sg;
         sirenum__SirenumGroup_Membership__c sgm = new sirenum__SirenumGroup_Membership__c(sirenum__SirenumGroup__c  = sg.id, 
                                                                             sirenum__Contact__c  = c.id);
         insert sgm;
         list<id> groups = sirenumutils.getGroupsForEmployee(c.id);
         
         system.assertEquals(1, groups.size());
     }
     public static testmethod void testParseTime(){
        String t = '12:30';
        Time ti = SirenumUtils.parseTime(t);
        DateTime dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals(SirenumUtils.formatTime(dt), t);
        t = '12.30';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('12:30', SirenumUtils.formatTime(dt));
        t = '9';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('09:00', SirenumUtils.formatTime(dt));
        t = '900';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('09:00', SirenumUtils.formatTime(dt));
        t= '7AM';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('07:00', SirenumUtils.formatTime(dt));
        t= '123';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('01:23', SirenumUtils.formatTime(dt));
        t= '1513';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('15:13', SirenumUtils.formatTime(dt));
        t= '113PM';
        ti = SirenumUtils.parseTime(t);
        dt = DateTime.newInstance(1991,1,12,ti.hour(),ti.minute(),ti.second());
        system.assertEquals('13:13', SirenumUtils.formatTime(dt));
    }
    
}
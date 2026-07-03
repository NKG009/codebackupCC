@istest
public class Test_UpdateLastConGDPR {
    static testmethod void gdprSmsTest(){
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;
        
        smagicinteract__SMS_Template__c smsTemp = new smagicinteract__SMS_Template__c();
        smsTemp.smagicinteract__Name__c = 'SmsTempname';
        insert smsTemp;
        
        smagicinteract__smsMagic__c smsmagic = new smagicinteract__smsMagic__c ();
        smsMagic.smagicinteract__Direction__c = 'IN';
        smsMagic.smagicinteract__Contact__c = con.id;
        smsMagic.smagicinteract__PhoneNumber__c = '7467879191';
        smsMagic.smagicinteract__SenderId__c = '9876545678';
        smsMagic.smagicinteract__Message_Type__c = 'SMS';
        smsMagic.smagicinteract__SMSText__c = 'TestMessage';
        smsMagic.smagicinteract__SMS_Template__c = smsTemp.Id;
        smsMagic.smagicinteract__external_field__c = 'Test1234098';
        insert smsMagic;
        
    }
    static testmethod void gdprEmailTest1(){
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;
        
        Task tk = new Task();
        tk.ActivityDate = System.today();
        tk.WhoId = con.id;
        tk.Subject = 'testsubj';
        insert tk;
        
    	EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
       // email.ActivityId = tk.id;
        email.MessageIdentifier = 'outlook';
        insert email;
       
 
        
    }
    static testmethod void gdprEmailTest2(){
        emailfuture ab = new emailfuture();
        
    }
    
     static testmethod void gdprTask(){
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;
        
        Task tk = new Task();
        tk.ActivityDate = System.today();
        tk.IP_ActivityType__c = 'General Call';
        tk.WhoId = con.id;
        tk.Subject = 'testsubj';
        insert tk;
        
    }
    

}
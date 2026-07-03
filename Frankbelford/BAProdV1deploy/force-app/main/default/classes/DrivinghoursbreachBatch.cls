global class DrivinghoursbreachBatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    public List<String> contactname = new List<String>();
    public Map<Id,String> error = new Map<Id,String>();
    public Map<Id,String> emailerror = new Map<Id,String>();
    public Map<Id,String> emailsuccess = new Map<Id,String>();
    public List<sirenum__Timesheet_line__c> tsl = new List<sirenum__Timesheet_line__c>();
    public Map<String, String> conbranch = new Map<String, String>();
    public set<id> timesheetid = new Set<id>();
    public set<id> Contactset= new Set<id>();
    public List<String> branchlist = new List<String>();
    public Set<String> branchSet = new Set<String>();
    public List<String> conlist1 = new List<String>();
    public List<Contact> conlist = new List<Contact>();
    public Set<id>conlist2 = new Set<id>();
    public Map<id,Contact> conMap = new Map<id,Contact>();
    public List<Contact> updatelist = new List<Contact>();
    public List<IP_PayProfile__c> paylist = new List<IP_PayProfile__c>();
    public Map<Id,String> paymap = new Map<Id,String>();
    Date batchrun = System.today();
    String department;
    Date payrolldate = System.today().adddays(-3);
  //  Date payrolldate = System.today().adddays(2);
    Date mondate = System.today().adddays(-7);
   // String formattedDate = mondate.format('YYYY-MM-DD');
   String formattedDate = mondate.day()+'-'+mondate.month()+'-'+mondate.year();
    Date sundate = System.today().adddays(-1);
   String formattedDate1 = sundate.day()+'-'+sundate.month()+'-'+sundate.year();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
            System.debug('Payroll Date'+payrolldate );

        if(!Test.isRunningTest())
        {
        string query = 'Select id,sirenum__Timesheet__c,sirenum__Timesheet__r.Name,sirenum__Timesheet__r.sirenum__Worker__c,IP_TempestDepartment__c,IP_PresentedPayrollDateDateType__c,sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c,sirenum__Timesheet__r.sirenum__Total_Hours__c,sirenum__Timesheet__r.sirenum__Worker__r.IP_TempestDepartment__c,sirenum__Timesheet__r.sirenum__Team__r.name from sirenum__Timesheet_Line__c where IP_PresentedPayrollDateDateType__c=:payrolldate and  sirenum__Timesheet__r.sirenum__Team__r.sirenum__Job_Type__r.Driving_Applicable__c = TRUE';
         return Database.getQueryLocator(query);
        }
        else
        {
         string query = 'Select id,sirenum__Timesheet__c,sirenum__Timesheet__r.Name,sirenum__Timesheet__r.sirenum__Worker__c,IP_TempestDepartment__c,IP_PresentedPayrollDateDateType__c,sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c,sirenum__Timesheet__r.sirenum__Total_Hours__c,sirenum__Timesheet__r.sirenum__Worker__r.IP_TempestDepartment__c,sirenum__Timesheet__r.sirenum__Team__r.name from sirenum__Timesheet_Line__c where sirenum__Timesheet__r.sirenum__Team__r.sirenum__Job_Type__r.Driving_Applicable__c = TRUE';   
         return Database.getQueryLocator(query);
        }
           
    }
    
    
    global void execute(Database.BatchableContext BC, List<sirenum__Timesheet_Line__c> scope) 
    {  
        Contact conid = scope[0].sirenum__Timesheet__r.sirenum__Worker__r;
        ID contactid = scope[0].sirenum__Timesheet__r.sirenum__Worker__c;
        system.debug('Scope'+scope[0]);
          if(!timesheetid.contains(scope[0].sirenum__Timesheet__c))
        {
         if(scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c==null)
        {
        scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c = 0;
        }
        scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c = scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c+scope[0].sirenum__Timesheet__r.sirenum__Total_Hours__c;     
        System.debug('Scope hours'+scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c);
        if(scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c>60)
        {
            conbranch.put(String.valueOf(scope[0].sirenum__Timesheet__r.sirenum__Worker__c)+'+'+String.valueOF(scope[0].sirenum__Timesheet__c),scope[0].sirenum__Timesheet__r.sirenum__Worker__r.IP_TempestDepartment__c);
        } 
        }
        for(String key1:conbranch.keyset())
        {
           String abc1 = key1.split('\\+')[0]; 
           conlist2.add(abc1);
        }
        timesheetid.add(scope[0].sirenum__Timesheet__c);
        Contactset.add(contactid);
        updatelist = [Select id from Contact where id in:Contactset];
        for(Contact c: updatelist)
        {
        c.Total_driving_hours__c = scope[0].sirenum__Timesheet__r.sirenum__Worker__r.Total_driving_hours__c;
        }
        update updatelist;
        conlist = [Select id,IP_CandidateIDlegacy__c,Phone,Name,MobilePhone,Email,IP_TempestDepartment__c,Total_driving_hours__c from Contact where id in:conlist2];
        paylist = [Select id, IP_PayrollID__c,IP_Candidate__c from IP_PayProfile__c where IP_Candidate__c in:conlist2 and recordType.name = 'PAYE'];
        for(IP_PayProfile__c p: paylist)
        {
            paymap.put(p.IP_Candidate__c,p.IP_PayrollID__c);
        }
        System.debug('Key set'+conbranch.keyset());
        System.debug('contact list'+conlist);
        for(Contact c:conlist)
        {
            conMap.put(c.id,c);
        }
        System.debug('conMap'+conMap);
    }
    
    global void finish(Database.BatchableContext BC)
    {     
        for(String s: conbranch.values())
        {
            branchSet.add(s);
        }
        System.debug('**BranchSet**'+branchSet);
        branchlist.addAll(branchSet);
        System.debug('**BranchList**'+branchlist);
        for(integer i=0;i<branchlist.size();i++)
        {
            for(String key:conbranch.keyset())
            {
                if(branchlist[i]==conbranch.get(key))
                {
                    String abc = key.split('\\+')[0];
                    conList1.add(abc);
                    System.debug('Contact List split'+conList);
                }
            }
        String header = 'Candidate Name,Candidate Payroll ID,Candidate Mobile Number,Candidate Email,Total Driving Hours\n'; 
        string finalstr = header ;
        for(String c: conList1)
        {
                string recordString = '"'+conMap.get(c).Name+'","'+paymap.get(c)+'","'+conMap.get(c).MobilePhone+'","'+conMap.get(c).Email+'","'+conMap.get(c).Total_driving_hours__c+'"\n';
               System.debug('Contact name'+conMap.get(c).Name);
               finalstr = finalstr +recordString;
               department = String.valueOf(conMap.get(c).IP_TempestDepartment__c);
        }
        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
         String BranchtUserEmail = shiftemp.Email__c;
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'Driving Candidates Working Hours Breach Report.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {BranchtUserEmail};
         OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
        email.setOrgWideEmailAddressId(owd.Id);
        String subject ='Driving Candidates Working Hours Breach Report '+formattedDate + '- '+formattedDate1;
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        String messageBody = '<html><body>Dear All,<br></br>Please find attached the weekly report for driving candidates whose Total Hours across all driving timesheets exceed 60 hours.<br></br>Kind regards<br></br>BA Central Support Team</body></html>';
        email.sethtmlBody(messageBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        conList1.clear();
        }
       for(Contact c: updatelist)
       {
           c.Total_driving_hours__c = 0;
       }
       update updatelist;
    }   
}
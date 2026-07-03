public class AutoShifttobeApprovedController {
  public Id recipient_Id { get; set; }
  public Id relatedTo_Id { get; set; }
  public integer NoOfShifts { get; set; }
  public String comURL { get; set; }
  public String Name { get; set; }
  public String DayofWeek { get; set; }
  public String monthoftoday { get; set; }
  public String dttime { get; set; }
  public Integer TodayDate { get; set; }
  public String shiftAutoApproval_Count { get; set; }
  public DateTime dateNow { get; set; }
  @testVisible
  private Integer Shiftdetails { get; set; }
  @testVisible
  private user user1 { get; set; }
  public set<Id> siteId = new Set<Id>();

  public AutoShifttobeApprovedController() {
    Date dateToday = system.today();
    Date DateMonSht1 = dateToday.addDays(-7);
    Date DateSunSht1 = dateToday.addDays(-1);
    Date DateSatSht2 = dateToday.addDays(-9);
    Date DateFriSht2 = dateToday.addDays(-3);
    Date DateSunSht3 = dateToday.addDays(-8);
    Date DateSatSht3 = dateToday.addDays(-2);
    String Scheduledtimestart;
    String Scheduledtimeend;
    String Actualtimeend;
    String Actualtimestart;
    dateTime startDateTime = dateTime.newInstance(
      DateSatSht2.year(),
      DateSatSht2.month(),
      DateSatSht2.day(),
      0,
      0,
      0
    );
    dateTime endDateTime = dateTime.newInstance(
      DateSunSht1.year(),
      DateSunSht1.month(),
      DateSunSht1.day(),
      23,
      59,
      59
    );
    Date convertDate;
    Date CheckStartDate;
    DateTime val = DateTime.now();

    List<String> status = new List<String>();
    status.add('Awaiting approval');
    status.add('Not Yet Submitted');

    dateNow = DateTime.now();
    DayofWeek = dateNow.format('EEEE');
    TodayDate = dateNow.day();
    dttime = dateNow.format('HH:MM');
    Integer mon = dateNow.month();
    if (mon == 1) {
      monthoftoday = 'January';} else if (mon == 2) {monthoftoday = 'February';} else if (mon == 3) {monthoftoday = 'March';} else if (mon == 4) {
      monthoftoday = 'April';
    } else if (mon == 5) {
      monthoftoday = 'May';
    } else if (mon == 6) {
      monthoftoday = 'June';
    } else if (mon == 7) {
      monthoftoday = 'July';
    } else if (mon == 8) {
      monthoftoday = 'August';
    } else if (mon == 9) {
      monthoftoday = 'September';
    } else if (mon == 10) {
      monthoftoday = 'October';
    } else if (mon == 11) {
      monthoftoday = 'November';
    } else if (mon == 12) {
      monthoftoday = 'December';
    }

    Network clientUrl = [
      SELECT Id
      FROM Network
      WHERE name = 'Client Portal V2'
    ];
    comURL = Network.getLoginUrl(clientUrl.id);

    //  List<sirenum__Shift__c > ShiftForApproval = Database.Query(query);
    //  shiftAutoApproval_Count= u.NumberOfShifts__c;
  }
  public String getusercount() {
    User u = [SELECT id, NumberOfShifts__c FROM user WHERE id = :recipient_Id];
    shiftAutoApproval_Count = u.NumberOfShifts__c;
    return shiftAutoApproval_Count;
  }
  /* public  integer getShiftdetails()
    {
        DateTime dateNow=system.now();  
        Date dateToday=system.today();        
        Date DateMonSht1 =dateToday.addDays(-7);
        Date DateSunSht1 =dateToday.addDays(-1);
        Date DateSatSht2 =dateToday.addDays(-9);
        Date DateFriSht2 =dateToday.addDays(-3);
        Date DateSunSht3 =dateToday.addDays(-8);
        Date DateSatSht3 =dateToday.addDays(-2);
        String Scheduledtimestart;
        String Scheduledtimeend;
        String Actualtimeend;
        String Actualtimestart;
        dateTime startDateTime=dateTime.newInstance(DateSatSht2.year(),DateSatSht2.month(),DateSatSht2.day(),00,00,00);
        dateTime endDateTime=dateTime.newInstance(DateSunSht1.year(),DateSunSht1.month(),DateSunSht1.day(),23,59,59);
        Date convertDate;
        Date CheckStartDate;
        DateTime val = DateTime.now();
        dateNow = DateTime.now();
        List<String> status = new List<String>(); 
        Network clientUrl=[SELECT Id FROM Network where name='client']; 
        
        comURL = Network.getLoginUrl(clientUrl.id);
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        User u =[select id,firstname,contactID,contact.AccountID from user where id=:recipient_Id];
           
        List<Contact_Site_link__c> consiteLink = [SELECT id, Account__c,IP_Contact__c, IP_PortalType__c, IP_Site__c FROM Contact_Site_link__c WHERE IP_Contact__c=:u.contactID and IP_PortalType__c ='Primary Hours Approver' ];
     
         for(Contact_Site_link__c slink: consiteLink )
         {
         siteId.add(slink.IP_Site__c);
         }
           
       String Query ='SELECT id , sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name ,sirenum__Site__r.IP_Timesheet_Method__c ,sirenum__Site__r.IP_ScheduledAutoApproval__c,'+
            'IP_CandidateApproved__c ,Actuals_confirmed__c ,IP_ClientApproved__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,'+
            ' sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Billable_Start_Time__c,sirenum__Billable_End_Time__c,IP_ClientRejected__c,'+
            'sirenum__Allow_pay__c,sirenum__Allow_charge__c,Approved_By__c,Approved_Date_Time__c FROM sirenum__Shift__c '+
            'WHERE sirenum__Site__r.IP_Timesheet_Method__c=\'eTimesheet\' AND '+
            'sirenum__Site__r.IP_ScheduledAutoApproval__c=true AND '+
            '(IP_CandidateApproved__c =true OR Actuals_confirmed__c =true OR IP_ClientApproved__c=true) AND IP_ClientRejected__c=false '+
            'AND sirenum__Published__c=true AND sirenum__Cancelled__c=false AND '+
            'sirenum__Scheduled_Start_Time__c != Null AND sirenum__Scheduled_End_Time__c!= Null'+
            ' AND sirenum__Allow_pay__c=False AND sirenum__Allow_charge__c=False '+
            ' AND sirenum__Scheduled_Start_Time__c>=:startDateTime AND sirenum__Scheduled_Start_Time__c<=:endDateTime AND sirenum__Site__r.Id IN:'+siteId;
        
        List<sirenum__Shift__c > ShiftForApproval = Database.Query(query);
       
        NoOfShifts =  ShiftForApproval .size();
        return NoOfShifts;
    }
    */
  public String getuserDetails() {
    DateTime val = DateTime.now();
    List<String> status = new List<String>();
    status.add('Awaiting approval');
    status.add('Not Yet Submitted');
    User user1 = [
      SELECT id, firstname, contactID, contact.AccountID
      FROM user
      WHERE id = :recipient_Id
    ];
    Name = user1.FirstName;
    return Name;
  }
}
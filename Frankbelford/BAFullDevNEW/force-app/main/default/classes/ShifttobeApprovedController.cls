public class ShifttobeApprovedController {
  public Id recipient_Id { get; set; }
  public Id relatedTo_Id { get; set; }
  public integer NoOfShifts { get; set; }
  public String comURL { get; set; }
  public String Name { get; set; }
  private List<sirenum__Shift__c> Shiftdetails { get; set; }
  private user user1 { get; set; }
  public set<Id> siteId = new Set<Id>();

  public integer getShiftdetails() {
    DateTime val = DateTime.now();
    List<String> status = new List<String>();
    Network clientUrl = [
      SELECT Id
      FROM Network
      WHERE name = 'Client Portal V2'
    ];
    comURL = Network.getLoginUrl(clientUrl.id);
    status.add('Awaiting approval');
    status.add('Not Yet Submitted');
    User u = [
      SELECT id, firstname, contactID, contact.AccountID
      FROM user
      WHERE id = :recipient_Id
    ];

    List<Contact_Site_link__c> consiteLink = [
      SELECT id, Account__c, IP_Contact__c, IP_PortalType__c, IP_Site__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__c = :u.contactID
        AND IP_PortalType__c = 'Primary Hours Approver'
    ];

    for (Contact_Site_link__c slink : consiteLink) {
      siteId.add(slink.IP_Site__c);
    }

    List<sirenum__Shift__c> shiftList = [
      SELECT id, IP_BranchOfOwner__c
      FROM sirenum__Shift__c
      WHERE
        sirenum__Scheduled_End_Time__c <= :val
        AND sirenum__Published__c = TRUE
        AND sirenum__Site__c = :siteId
        AND IP_Status__c IN :status
        AND sirenum__Contact__c != NULL
        AND sirenum__Cancelled__c = FALSE
        AND sirenum__Site__r.IP_Timesheet_Method__c = 'eTimesheet'
        AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14
        AND IP_ClientRejected__c != TRUE
    ];
    NoOfShifts = shiftList.size();
    System.debug('====NoOfShifts===' + NoOfShifts);
    return NoOfShifts;
  }
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
    System.debug('====Name@@@===' + Name);
    return Name;
  }
}
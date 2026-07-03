public class LoginHistoryOnContactController {
  public List<LoginHistory> LoginHistory { get; set; }
  public boolean display { get; set; }
  public String username { get; set; }
  public integer actualvalue;
  public id contactId;
  public boolean flagfornext { get; set; }
  public boolean flagforpre { get; set; }
  public LoginHistoryOnContactController(
    ApexPages.StandardController controller
  ) {
    try {
      contactId = ApexPages.currentPage().getParameters().get('id');
    } catch (exception e) {
      display = false;
    }
    actualvalue = 0;
    flagforpre = true;
    flagfornext = false;
    loginrecords();
  }
  public void Nextbtn() {
    actualvalue = actualvalue + 5;
    flagforpre = false;
    integer flag = loginrecords();
    if (flag < 5) {
      flagfornext = true;
    } else {
      flagfornext = false;
    }
  }
  public void previousbtn() {
    actualvalue = actualvalue - 5;
    flagfornext = false;
    if (actualvalue > 0) {
      flagforpre = false;
    } else {
      flagforpre = true;
    }
    loginrecords();
  }
  public integer loginrecords() {
    try {
      contactId = ApexPages.currentPage().getParameters().get('id');
      System.debug('--contactId--' + contactId);
      User u = [
        SELECT id, ContactId, userName
        FROM user
        WHERE ContactId = :contactId
        LIMIT 1
      ];
      username = u.userName;
      LoginHistory = [
        SELECT UserId, LoginTime, Browser, Platform, Status, LoginURL
        FROM LoginHistory
        WHERE UserId = :u.Id
        ORDER BY LoginTime DESC
        LIMIT 5
        OFFSET :actualvalue
      ];

      if (LoginHistory.size() > 0) {
        display = true;
      }
    } catch (exception e) {
      display = false;
      return 0;
    }
    if (LoginHistory.size() > 0) {
      return LoginHistory.size();
    } else {
      return 0;
    }
  }
}
//SELECT Id, UserId, LoginTime, LoginType, SourceIp, LoginUrl, NetworkId, AuthenticationServiceId, LoginGeoId, TlsProtocol, CipherSuite, OptionsIsGet, OptionsIsPost, Browser, Platform, Status, Application, ClientVersion, ApiType, ApiVersion, CountryIso FROM LoginHistory
@isTest
public class Test_CPpayslipController {
    
	private class Mock implements HttpCalloutMock 
    {        
        public HTTPResponse respond(HTTPRequest req) 
        {
            HTTPResponse res = new HTTPResponse();
            if (req.getEndpoint().endsWith('token')) 
            {
                res.setBody('{"example":"test"}');
                res.setStatusCode(200); 
            }  
            else if (req.getEndpoint().endsWith('lookup')) 
            {
                res.setBody('{"example":"test"}');
                res.setStatusCode(200); 
            }
            else if (req.getEndpoint().endsWith('export')) 
            {
                res.setBody('{"example":"test"}');
                res.setStatusCode(200); 
            }          
            else 
            {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
            }
            return res;
        }
      }
        
      @isTest(seealldata=true)
      static void get_AccessToken(){
             Test.setMock(HttpCalloutMock.class, new Mock()); 
        	 Object res = CPpayslipController.getAccessToken();
        	 system.debug('resresresres--'+res);
        }
    
       @isTest(seealldata=false)
       static void test_UpdateToken(){
           
        ImpellamCPConnect__c setting = new ImpellamCPConnect__c();
        setting.Name='ImpellamConnect';
        setting.client_id__c='12';
        setting.client_secret__c='23';
        setting.HolidaysEndPointUrl__c='http://holiday.com';
        setting.PayslipEndPointUrl__c='http://payslip.com';
        setting.PayslipExportEndPointUrl__c='http://payslipExport.com';
        setting.PaySlipFolderID__c='';    
        setting.TokenExpiryDateTime__c='';
        setting.TokenURL__c='http://payslipExport.com';    
        setting.DocumentID__c='34';
        setting.ExpireAt__c=Datetime.now();
        setting.LiveToken__c='1234567';         
        insert  setting;    
           Map<String,String> credMap = new Map<String,String>();
           credMap.put('expires_at','2018-07-04T10:15:49.7579869+00:00');
           test.startTest();                      
           CPpayslipController.UpdateToken(credMap);        	
           test.stopTest();
        }
    
      @isTest(seealldata=true)
      static void get_Payslip(){
             Test.setMock(HttpCalloutMock.class, new Mock()); 
        	 Object res = CPpayslipController.getPayslip();
        	 system.debug('resresresres--'+res);
        }
    @isTest(seealldata=true)
      static void get_PayslipLookup(){
             Test.setMock(HttpCalloutMock.class, new Mock()); 
        	 List<Object> res = CPpayslipController.PayslipLookup('2017-12-01', '2018-01-31');
        	 system.debug('resresresres--'+res);
        }
    @isTest(seealldata=true)
      static void get_PrintPayslip(){
             Test.setMock(HttpCalloutMock.class, new Mock()); 
        	 String res = CPpayslipController.PrintPayslip('sdsds#aadad#adadad#sasasas');
        	 system.debug('resresresres--'+res);
        }
    @isTest
      static void get_user(){
          
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile pProfile = [Select Id from Profile where name = 'System Administrator'];
        User userP = new User(Username = System.now().millisecond() + 'portalUser123@test.com', ProfileId = pProfile.Id,
                              UserRoleId = portalRole.Id, Alias = 'pt123', Email = 'manish.mishra@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'l4848',
                              CommunityNickname = 'chec', IP_TempestDepartment__c='1062',IP_TempestID__c='1062',
                              IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US');
        insert userP;   
        contact con;
        Contact c1 ;
        sirenum__Timesheet__c sts;
        System.runAs(userP) {
            insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
            Account acc1 = new Account(Name = 'TestAccount', OwnerId = userP.Id );
            insert acc1;
            c1 = new Contact( FirstName = 'tt', Lastname = 'mm', AccountId = acc1.Id, Email = System.now().millisecond() + 'as@test.com');
            Database.insert(c1);            
        }
        
        Profile dProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        User userd = new User( Username = System.now().millisecond() + 'portalUser123@test.com',    ProfileId = dProfile.Id,
                              Alias = 'klkl', Email = 'user1@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'lnamemm',
                              ContactId=c1.id, CommunityNickname = 'checked', TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        Database.insert(userd);  
          
        User u = [select id , contactId from user where lastname = 'lnamemm' limit 1];
        System.runAs(u) {
            CPpayslipController.getUserId();            
        }
          
        }
}
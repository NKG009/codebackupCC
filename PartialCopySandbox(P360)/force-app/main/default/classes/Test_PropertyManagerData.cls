@isTest
public class Test_PropertyManagerData {
    @testSetup
    static void setup(){
        
 				Manage_Triggers__c cs1 = new Manage_Triggers__c();
			cs1.Name = 'AccountTrigger';
			cs1.isActive__c = true;
			insert cs1;        
    }
   
    @isTest
    public static void  Test_updatePropertyManagerData(){
            List<string> accIDS = new List<string>();
        List<contact>conlistexist= new List<contact>();
        List<Account> acclist= new List<Account>();
        //Id AgentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
        String fname;
        String lname;
        Id existedconid;
        String propertytreeExternalcontactid='';
        Boolean primarycontactfound=false;
       // Boolean samePropertyManagerexist=false;
        Boolean contactexists=false;
        Id existingACRId;
       // Set<id>existingAcrIDSet= new Set<Id>();
      //  Id acrpropertymanagerid;
            Test.setMock(HttpCalloutMock.class, new TestAgentsDataUpsert());
        User adminUsr = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];    
        Id AgentRecordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
        Id RealStateRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Real Estate Office').getRecordTypeId();
        Id PropertyRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();
		 Boolean samePropertyManagerexist=false;
        Id acrpropertymanagerid;
         Set<id>existingAcrIDSet= new Set<Id>();
        adminUsr.UserRoleId = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Di_Jones_Manager' LIMIT 1].Id;
        update adminUsr;
        System.runAs(adminUsr){
            
  			// PARENT ACCOUNT
            Account acc1 = new Account();
            acc1.Name = 'Account A';
            acc1.recordtypeID=RealStateRecordTypeId;
             acc1.External_ID__c='testExternalId1';
            insert acc1;
            System.assert(acc1.Id != null);
            // ACCOUNT
            Account acc2 = new Account();
            acc2.Name = 'Account B';
            acc2.recordtypeID=PropertyRecordTypeId;
            acc2.External_ID__c='testExternalId1test';
            acc2.ParentId=acc1.Id;
            insert acc2;
            System.assert(acc2.Id != null);
            //CONTACT 1
            Contact con1 = new Contact();
            con1.FirstName = 'Test';
            con1.LastName = 'User1';
            con1.recordTypeId=AgentRecordTypeId;
            con1.AccountId = acc1.Id;
            con1.External_ID__c='18f335b7-50b5-452e-a4b2-f9740ee3708d';
            insert con1;
                List<AccountContactRelation> acrs=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation  ];
            List<Contact> testacrs=new List<Contact>();
            for(AccountContactRelation tacr : acrs){
                System.debug('extid'+tacr.External_ID__c+'detail'+tacr.contactId);
                tacr.IsActive = true;
                tacr.roles='Property Manager';
                existingAcrIDSet.add(tacr.Id);
                if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
            
            update acrs;
                 
            System.assert(con1.Id != null);
//            acc2.RecordTypeId=sfrcdId;
  //          update acc2;
          if(tacr.External_ID__c =='18f335b7-50b5-452e-a4b2-f9740ee3708d' ){
                                        samePropertyManagerexist=true;
                                        acrpropertymanagerid=tacr.Id;
                                    }
            }
            // AccountContactRelation
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con1.Id;
            acr.IsActive = true;
           
            acr.External_ID__c='test';
            insert acr;
            System.assert(acr.Id != null);
            // CONTACT 2
              Contact con2 = new Contact();
			  con2.FirstName = 'Test';
			  con2.LastName = 'Usertest';
           	  con2.recordtypeId=AgentRecordTypeId;
              con2.External_ID__c='18f335b7-50b5-452e-a4b2-f9740ee370d';
              con2.AccountId = acc1.Id;
              insert con2;
           Id contactId = con2.Id;
            List<AccountContactRelation> acrslst=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation where ContactId=:con2.ID ];
             for(AccountContactRelation tacr : acrslst){
                tacr.External_ID__c='testexternalid';
                System.debug('extid'+tacr.External_ID__c+'detail'+tacr.contactId);
                tacr.IsActive = true;
               tacr.roles='Property Manager';
                if(tacr.External_ID__c==null){testacrs.add(new Contact(Id=tacr.ContactId));}
                
            }
            update acrslst;
            // USER 
            User usr = new User();
            usr.FirstName = 'Test';
            usr.LastName = 'User1';
            usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;  
            usr.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr.Email = 'test.user1@yopmail.com.ps360.test';
            usr.LanguageLocaleKey = 'en_US';
            usr.EmailEncodingKey = 'UTF-8';
            usr.LocaleSidKey = 'en_US';
            usr.TimeZoneSidKey = 'America/Los_Angeles';
            usr.Alias = 'Alias1';
            usr.Title = 'Title1';
            usr.ContactId = con1.Id;
            insert usr;
            System.assert(usr.Id != null);
            
             List<AccountContactRelation> acrslst1=[Select ID,accountId,ContactId, roles,External_Id__c,IsActive from AccountContactRelation where Id=:acr.Id ];
            for(AccountContactRelation tacr1 : acrslst1){
                tacr1.roles ='Property Manager';
                
            }
            	
            AccountContactRelation acr1=[Select id, roles from AccountContactRelation where id=:acr.Id ];
                            
                                
                                    acr.Roles='Property Manager';
                                    update acr;
            
            
                                
                            
               
           
           // ADD USER IN ACCOUNT Property_Office_Agent__c FIELD
             acc1.Property_Office_Agent__c = usr.Id;
            acc1.External_ID__c='testexternalid';
            update acc1;
            acc2.API_Agent_1_External_ID__c='testapi';
            acc2.API_Agent_2_External_ID__c='testexternalapi';
            update acc2;
            
List<String> rolesvalues= new List<String>();
               List<AccountContactRelation> acrslst2=[Select ID, roles from AccountContactRelation where roles!=null ];
          			 for(AccountContactRelation tacr2 : acrslst2){
                            
                               
                                    tacr2.Roles='Property Manager';
                                    update acrslst2;
                                
                            }    
            
					 AccountContactRelation acr2=[Select id, roles from AccountContactRelation where id=:acr.Id];
                           	if(acr2.Roles != 'Property Manager'){
                                    acr2.Roles='Property Manager';
                                    update acr;
                                }
                            
            
            
              
            
           ExternalAgentAccountContactRelation extACR = new ExternalAgentAccountContactRelation();
            	extACR.id= acc2.Id;
				system.debug('ext ACR' + extACR); 
            Test.startTest();
            PropertyManagerData.ContactRoleData(extACR.id);
            string datastr ='[{"first_name":"Alex","id":"10827f28-0f2c-42ff-a53c-fb43060d284a","last_name":"Massaoud","roles":[{"name":"Property Manager","property_management_contact":true}]},{"first_name":"Dominique","id":"426947dc-58dd-4507-9766-51dff2f31f78","last_name":"Zucaro","roles":[{"name":"Leasing Agent","property_management_contact":false},{"name":"Inspecting Agent","property_management_contact":false}]}]';
           PropertyManagerData.PropertyManagerDataupdate(acc2.id, datastr );
            Test.stopTest();
        } 
   
       
    }
    public class  TestAgentsDataUpsert implements HttpCalloutMock {
        public  HTTPResponse respond(HTTPRequest req) {   
             HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"first_name": "Test","last_name":"TestLast","id": "testexternalId","roles": [{"name": "Property Manager","property_management_contact": true }]}]');
            res.setStatusCode(200);
             return res;
        }
    } 
    public class  TestAgentsDataUpsertError implements HttpCalloutMock {
        public  HTTPResponse respond(HTTPRequest req) {       
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('["first_name": "Test","last_name":"TestLast","id": "testexternalid","roles": [{"name": "Property Management","property_management_contact": true }]]');
            res.setStatusCode(200);
            return res;
        }
    }      
}
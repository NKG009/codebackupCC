@isTest
public class SiteRecordCreationBatch_Test {
    
     

    @testSetup
    static void setup(){
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
			cs1.Name = 'AccountTrigger';
			cs1.isActive__c = True;
          	insert cs1;
        Manage_Triggers__c cs = new Manage_Triggers__c();
			cs.Name = 'ServiceAppointmentTrigger';
			cs.isActive__c = false;
          	insert cs;
         Id rctId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        account acct= new account();
        acct.name='tastacc';
        acct.RecordTypeId=rctId;
       insert acct;
        
        Id rctId1=Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Tenant').getRecordTypeId();
        Contact con = new Contact();
        con.RecordTypeId=rctId1;
         con.FirstName = 'ttTest';
	     con.LastName = 'ttUsertest';
         con.MobilePhone='9874632111';
         con.Email= 'test@test.com';
        con.Is_Primary__c=true;
        con.AccountId=acct.id;
        insert con;
         Id rctId2=Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Tenant').getRecordTypeId();
        Contact con1 = new Contact();
        con1.RecordTypeId=rctId2;
         con1.FirstName = 'ttTest1';
	     con1.LastName = 'ttUsertest1';
         con1.MobilePhone='98746321111';
         con1.Email= 'test@test1.com';
        con1.AccountId=acct.id;
        insert con1;
         Id rctId3=Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Tenant').getRecordTypeId();
        Contact con2 = new Contact();
        con2.RecordTypeId=rctId3;
         con2.FirstName = 'ttTest3';
	     con2.LastName = 'ttUsertest3';
         con2.MobilePhone='98746321113';
         con2.Email= 'test@test3.com';
        con2.AccountId=acct.id;
        insert con2;
         Id rctId5=Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Tenant').getRecordTypeId();
        Contact con3 = new Contact();
        con3.RecordTypeId=rctId5;
         con3.FirstName = 'ttest';
	     con3.LastName = 'ttUserest';
         con3.MobilePhone='987463111';
         con3.Email= 'test@tst.com';
        con3.AccountId=acct.id;
        insert con3;
        
        workorder wo = new workorder();
        wo.AccountId=acct.id;
        wo.Position__c=Null;
        insert wo;
        
        ServiceAppointment sa = new ServiceAppointment();
        sa.ParentRecordId=wo.Id;
       // sa.AccountId = acct.Id;
        sa.FSSK__FSK_Work_Order__c=wo.Id;
        sa.DueDate= system.now();
        sa.EarliestStartTime=system.now();
        insert sa;
    }
     static testmethod void testbatch(){
         test.startTest();
         ServiceAppointment sa=[select id,accountid,FSSK__FSK_Work_Order__c,FSSK__FSK_Work_Order__r.Position__c,Account.Recordtype.DeveloperName,(select id,Service_Appointment__c from Site_Contacts__r) from ServiceAppointment limit 1];
        SiteRecordCreationBatch srcb = new SiteRecordCreationBatch (null);
       system.debug('Position__c==='+sa.FSSK__FSK_Work_Order__r.Position__c);
        system.debug('rtypeid==='+sa.AccountId);
        system.debug('rtpena==='+  sa.Account.Recordtype.DeveloperName);
        system.debug('Site_Contacts__r====='+  sa.Site_Contacts__r.size()); 
     Database.executebatch(srcb);
        
      test.stopTest();   
    }

}
@isTest
public class TestWorkorderTriggerHandler {
      @testSetup
    static void setup(){
        
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = false;
        insert cs1;
         Manage_Triggers__c cs2 = new Manage_Triggers__c();
        cs2.Name = 'WorkOrderTrigger';
        cs2.isActive__c = true;
        insert cs2;
    }
  @isTest
    public static void testwoupdate(){
        
         Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
         	account acc= new account();
        	acc.name='paccount';
            acc.RecordTypeId=rcId;
            insert acc;
        
         Account acc1 = new Account();
            acc1.Name = 'Account A';
        	acc1.ParentId=acc.Id;
            insert acc1;
            System.assert(acc1.Id != null);
         Account acc2 = new Account();
            acc2.Name = 'Account B';
            acc2.ParentId=acc.Id;
        	acc2.Prop_Compliance_Recipient_Email__c='test@testing.com';
        	acc2.Prop_Compliance_Recipient_2__c='test2@test.com';
            insert acc2;
            System.assert(acc2.Id != null);            
            
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'User1';
        	con.Email='test@testing.com';
            con.AccountId = acc1.Id;
            insert con;
            System.assert(con.Id != null);
        
           Contact co = new Contact();
         co.FirstName='test1';
        co.LastName='tu';
        co.Email='test2@test.com';
        insert co;
        
            User usr1 = new User();
            usr1.FirstName = 'Test';
            usr1.LastName = 'User1';
            usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'PS360 Community Plus User' LIMIT 1].Id;    
            usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
            usr1.Email = 'test.user1@yopmail.com.ps360.test';
            usr1.LanguageLocaleKey = 'en_US';
            usr1.EmailEncodingKey = 'UTF-8';
            usr1.LocaleSidKey = 'en_US';
            usr1.TimeZoneSidKey = 'America/Los_Angeles';
            usr1.Alias = 'Alias1';
            usr1.Title = 'Title1';
            usr1.ContactId = con.Id;
            insert usr1;
            System.assert(usr1.Id != null);  
        
            acc.Power_User__c = usr1.Id;
            update acc;

            WorkOrder wor = new WorkOrder();
            wor.AccountId = acc2.Id;
            //wor.Status='New';
            List <WorkType> WTList = [SELECT Id, Name from WorkType WHERE Name='Smoke Alarm Service'];
            if(WTList.size()>0){
                wor.WorkTypeId = WTList[0].id;
            }
            insert wor;
            System.assert(wor.Id != null);
         wor.Status='Canceled';
        update wor;
         ServiceAppointment testsa=new ServiceAppointment(FSSK__FSK_Work_Order__c=wor.ID,
                                                            Status='None');
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = wor.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        
         wor.Status='Send Certificate';
          update wor;
        
         wor.Validation_Error__c=true;
        update wor;
        wor.Validation_Error__c=False;
        update wor;
      // insert testsa;
       
        try{
            }catch(Exception e){System.debug('e');}
    }
          //***Begin***Test of "UpdateFastFieldIdOfInsertedWO" Method***
    @isTest
    static void testUpdateFastFieldIdOfInsertedWO() {
        // Setup: Create a WorkOrder without FastFieldId__c
        RecordType PropertyRecordType = [SELECT Id FROM RecordType WHERE DeveloperName='Property'];
        Account accA = new Account();
            accA.Name = 'Account A';
            accA.RecordTypeId =PropertyRecordType.Id;
        Insert accA;
        WorkOrder wo = new WorkOrder();
        List <WorkType> WTList = [SELECT Id, Name from WorkType WHERE Name='Smoke Alarm Service'];
          if(WTList.size()>0){
                wo.WorkTypeId = WTList[0].id;
            }
        wo.AccountId = accA.Id;
        insert wo;
        // Ensure FastFieldId__c is null after insertion
        WorkOrder insertedWO = [SELECT Id, FastFieldId__c FROM WorkOrder WHERE Id = :wo.Id LIMIT 1];
        System.assert(insertedWO.FastFieldId__c != null);
        // Prepare the map as required by the method to be tested
        Map<Id, WorkOrder> newMap = new Map<Id, WorkOrder>();
        newMap.put(wo.Id, insertedWO);
        // Call the method to test
        Test.startTest();
        WorkOrderTriggerHandler.UpdateFastFieldIdOfInsertedWO(newMap);
        Test.stopTest();
        // Check the results after method execution
        WorkOrder updatedWO = [SELECT Id, FastFieldId__c FROM WorkOrder WHERE Id = :wo.Id LIMIT 1]; 
        // The FastFieldId__c should be updated to the record's ID
        System.assertEquals(wo.Id, updatedWO.FastFieldId__c);
    }
        //***End***Test of "UpdateFastFieldIdOfInsertedWO" Method***  
}
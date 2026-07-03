@isTest
private class Five9ReportingAutomationTEST {
static testMethod void Five9ReportingAutomation() {
  
  // create a new email and envelope object
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
  
  
  // setup the data for the email
 
  Five9_Call_Data__c a = new Five9_Call_Data__c();
   a.call_id__c = '1234';
   a.skill__c = 'Sales';
   insert a;
       
 
  // add an attachment
    Messaging.InboundEmail.BinaryAttachment tattachments = new Messaging.InboundEmail.BinaryAttachment();
    //tattachments.body = blob.valueOf('my attachment text');
    tattachments.fileName = 'textfile.csv';
    tattachments.body = Blob.valueOf('DATE__c,HALF_HOUR__c,ANI__c,CALL_ID__c,CALL_TYPE__c,CALLS1__c,CAMPAIGN__c,CAMPAIGN_TYPE__c,' +
                                        'CONTACTED__c,DISCONNECTED_FROM_HOLD__c,DISPOSITION1__c,DNIS__c,SERVICE_LEVEL1__c,' +
                                        'SESSION_ID__c,SKILL__c,SPEED_OF_ANSWER__c,AFTER_CALL_WORK_TIME__c,HOLD_TIME__c,' +
                                        'HOLDS1__c,QUEUE_WAIT_TIME__c,TALK_TIME_LESS_HOLD_AND_PARK__c,TRANSFERS1__c,' +
                                        'AGENT_GROUP__c,AGENT_ID__c,AGENT_NAME__c,Salesforce_TFNDescription__c\n' +
                                        '2023-01-01,12:30,123456,789,CustomerService,2,Marketing,CampaignType,Yes,No,Disposition1,' +
                                        '12345,High,98765,Skill1,30,5,10,15,20,25,3,4,AgentGroup1,1001,John Doe,Description');
    tattachments.mimeTypeSubType = 'text/plain';
    email.binaryAttachments =
        new Messaging.inboundEmail.BinaryAttachment[] { tattachments };
            
 
  
 
    // query for the contact the email service created
  Five9_Call_Data__c lstFive9_Call_Data = [select call_id__c, skill__c from Five9_Call_Data__c];
    
    Test.startTest();
    Five9ReportingAutomation testInbound = new Five9ReportingAutomation ();
    testInbound.handleInboundEmail(email, envelope);
    Test.stopTest();

      System.assertEquals(lstFive9_Call_Data.Call_id__c ,'1234');
      System.assertEquals(lstFive9_Call_Data.Skill__c,'Sales');
       


 }
}
@istest
private class Test_ExternalWorkerBatch{

    @isTest
static void testexecute1() 
    {   
        String query = 'Select id from Contact limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_Pass2ndTierToTempest__c';
        String Field2 = 'IP_LastPassedToTempest2ndTier__c';  
           
 
        Account acc =  TestDataFactory.create2ndTierSupplierAccount(1)[0];
        insert acc;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType condRecord = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];
       Date myDate = Date.newInstance(1980, 2, 17);
       //List<Contact> clist = new List<Contact>();
       //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
       Contact con = new Contact(Birthdate=myDate,
                                          Email='mm@gmail.com',
                                          FirstName='manish',
                                          LastName='mishra',
                                          IP_MailingAddressLine1__c='c260',
                                          IP_MailingAddressLine2__c='c2',
                                          IP_MailingAddressLine3__c='c3',
                                          IP_CandidateIDlegacy__c='d6tf233',
                                          IP_WorkerStartDate__c=system.today(),
                                          WTR_Completed__c=true,  
                                          MailingCity='ballia', 
                                          MailingCountry='india',
                                          MailingState='up',
                                          MailingPostalCode='277211',
                                          Salutation='Mr',
                                          Sirenum__National_Insurance__c='AA123456A',
                                          IP_PayFrequency__c=342,
                                          RecordTypeId = condRecord.Id,
                                          AccountID = acc.id,      
                                          IP_Pass2ndTierToTempest__c=true,
                                          MailingStreet = 'Mailing Street details',
                                		  smagicinteract__SMSOptOut__c = true,Phone = '+447890789065');
                    
       insert con;       
       
        test.startTest(); 
         ExternalWorkerBatch b = new ExternalWorkerBatch(query,Field1,Field2,GUID);    
        Database.executeBatch(b,1);
         ExternalWorkerEmergencyBatch b1 = new ExternalWorkerEmergencyBatch(query,Field1,Field2,GUID);    
        Database.executeBatch(b1,1);
       
        test.stopTest();
        
       }
    
    
}
@isTest
public class AssignmentEmergencyRestTest {

    // Utility method to insert test data
    static void setupTestData() {
        // Insert necessary setup data like Impellam_Settings__c and sirenum__Placement__c
        
        ///[sirenum__Contract__c, sirenum__Contact__c, sirenum__Job_Role__c, sirenum__Start_Date__c]: [sirenum__Contract__c, sirenum__Contact__c, sirenum__Job_Role__c, sirenum__Start_Date__c
        
        //Create Account acct
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        
        // Create test Contact
        Contact con = TestDataFactory.createCandidate(acct.Id, 1)[0];
        insert con;
        
        // Create jobRoll sirenum__Team__c
        sirenum__Team__c jobRoll = new sirenum__Team__c(Name = 'TestTeam');
        insert jobRoll;
        
        //Create pc sirenum__Payroll_Cycle__c
        sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
        pc.Name = 'Saturday - Friday';
        pc.sirenum__CyclePeriodUnits__c= 'Weeks';
        pc.sirenum__periodLength__c = Decimal.valueOf(7);
        pc.sirenum__StartingDate__c = Date.newInstance(2036, 03, 15);  
        insert pc;
        
        // Create ct sirenum__ProActiveContract__c
       // sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acct.id,con.id,1)[0];
       // ct.sirenum__PayrollCycle__c = pc.id;
       // insert ct;
        
        // Create sirenum__Placement__c record
       
        sirenum__ProActiveContract__c wfmContract = new sirenum__ProActiveContract__c();
         wfmContract.sirenum__Color_Code__c = 'color';
         wfmContract.sirenum__Client__c = acct.Id;
          wfmContract.sirenum__Contact__c  = con.Id;
        insert wfmContract;
        
        sirenum__Placement__c sirenumPlacement = new sirenum__Placement__c(
        	sirenum__Contract__c = wfmContract.Id,
            sirenum__Contact__c = con.Id,
            sirenum__Job_Role__c = jobRoll.Id,
            sirenum__Start_Date__c = Date.newInstance(2025, 3, 26)
        );
        insert sirenumPlacement; 

        // Create Impellam_Settings__c record
        Impellam_Settings__c setting = new Impellam_Settings__c(
            Name = 'AssignmentEmergencyRest',
            Limit__c = '10'
        );
        insert setting;

        // Create a list of sirenum__Placement__c records
        List<sirenum__Placement__c> placements = new List<sirenum__Placement__c>();
        
        for (Integer i = 0; i < 5; i++) {
            sirenum__Placement__c placement = new sirenum__Placement__c(
                IP_EmergencyPull__c = true,
                //IP_Department__c = '1069',
                GUID_placement__c = 'test-guid-' + i
               // IP_AssignmentRefForTempest__c = 'Ref-' + i
            );
            placements.add(placement);
        }
        insert placements;
    }

    // Test method for GET request
    @isTest
    static void testDoGet() {
        // Set up the test data
        setupTestData();

        // Set the request URI and context to simulate the REST API call
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/emergency/v1/collect/assignment/1069/test-guid-1';
        //RestContext.request.method = 'GET';

        // Set the response for the context
        RestContext.response = new RestResponse();
        
        // Call the actual method that processes the GET request
        AssignmentEmergencyRest.ResponseClass result = AssignmentEmergencyRest.doGet();

        // Assertions to check if the result is as expected
        System.assertEquals('true', result.success, 'Success flag should be true');
        System.assertEquals('Query executed successfully.', result.message, 'The message should match expected.');
        System.assertNotEquals(0, result.records.size(), 'There should be placement records returned');
    }

    // Test method for error case when no records are found
    @isTest
    static void testDoGetNoRecords() {
        // Set up the test data
        setupTestData();

        // Modify the URI to use a non-existing GUID
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/emergency/v1/collect/assignment/1069/non-existing-guid';
       // RestContext.request.method = 'GET';

        // Set the response for the context
        RestContext.response = new RestResponse();

        // Call the actual method that processes the GET request
        AssignmentEmergencyRest.ResponseClass result = AssignmentEmergencyRest.doGet();

        // Assertions to check if the result indicates no records
        System.assertEquals('false', result.success, 'Success flag should be false');
        System.assertEquals('Error in querying records', result.message, 'The message should indicate query error.');
        System.assertEquals(0, result.records.size(), 'There should be no placement records returned');
    }

    // Test method for exception handling
    @isTest
    static void testDoGetException() {
        // Set up the test data
        setupTestData();

        // Simulate an exception by modifying the request URI
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/emergency/v1/collect/assignment/1069/';
        //RestContext.request.method = 'GET';

        // Set the response for the context
        RestContext.response = new RestResponse();

        // Call the actual method that processes the GET request and simulate exception
        AssignmentEmergencyRest.ResponseClass result = AssignmentEmergencyRest.doGet();

        // Assertions to check if the result indicates an error due to exception
        System.assertEquals('false', result.success, 'Success flag should be false due to exception');
        System.assertNotEquals('Query executed successfully.', result.message, 'The message should indicate the exception.');
    }
}
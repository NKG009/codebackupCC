@IsTest
public class AddOrInsertRecordTest {

    @IsTest
    static void testAddOrInsertRecord() {
        
        Payroll_Swtich__c ps = new Payroll_Swtich__c();
        ps.Batch_check__c = true;
        ps.Name = 'Stoppayroll';
        insert ps;
        
        // Test the AddOrInsertRecord method here
        // Example: Calling the method with different parameters and verifying the results
		RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
          insert maincon; 
        List<SObject> inputCollection = new List<SObject>();
        inputCollection.add(maincon);

        AddOrInsertRecord.Requests request = new AddOrInsertRecord.Requests();
        request.inputCollection = inputCollection;
        request.inputRecord = maincon;
        request.index = 0;

        List<AddOrInsertRecord.Results> results = AddOrInsertRecord.addOrInsertRecord(new List<AddOrInsertRecord.Requests>{request});

        System.assertEquals(2, results[0].outputCollection.size(), 'The output collection should have two records.');
    }
}
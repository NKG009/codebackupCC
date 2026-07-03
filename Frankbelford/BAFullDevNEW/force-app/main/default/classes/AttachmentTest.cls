@isTest
public class AttachmentTest {
    
    public string lightningTheme ='Theme4d';

    static testMethod void Test1() {
     
        insert new IP_Shift_Template__c(name = '0000', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;

        id payRTId = Schema.SObjectType.TR1__Reference__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();

        TR1__Reference__c ref1 = new TR1__Reference__c();
        ref1.TR1__Person_Placed__c = con.id;
        ref1.Status__c = 'Expired';
        ref1.Reference_Received_Back_Manual_Upload__c = false;
        ref1.Name__c = 'Name1';
        ref1.Email__c = 'abc@123.com';
        //ref1.Verbal_Reference__c = true;
        ref1.Educational_Establishment__c = 'abc';
        ref1.Course_Start_Date__c = System.today();

        try{
            ref1.Status__c = 'Complete';
            ref1.Reference_Received_Back_Manual_Upload__c = true;
            insert ref1;
        }
        catch(Exception e) {
            string errormessage = e.getMessage();
        }
    }
	static testMethod void Test2() {
     
        AttachmentReferencetrggerHandler.getLightning = 'Theme4d';
		AttachmentReferencetrggerHandler.lightningTheme = 'Theme4d';
		insert new IP_Shift_Template__c(name = '0000', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;

        id payRTId = Schema.SObjectType.TR1__Reference__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();

        TR1__Reference__c ref1 = new TR1__Reference__c();
        ref1.TR1__Person_Placed__c = con.id;
        ref1.Status__c = 'Expired';
        ref1.Reference_Received_Back_Manual_Upload__c = false;
        ref1.Name__c = 'Name1';
        ref1.Email__c = 'abc@123.com';
        //ref1.Verbal_Reference__c = true;
        ref1.Educational_Establishment__c = 'abc';
        ref1.Course_Start_Date__c = System.today();
            
        try{
            ref1.Status__c = 'Complete';
            ref1.Reference_Received_Back_Manual_Upload__c = true;
            insert ref1;
        }
        catch(Exception e) {
            string errormessage = e.getMessage();
        }
    }
}
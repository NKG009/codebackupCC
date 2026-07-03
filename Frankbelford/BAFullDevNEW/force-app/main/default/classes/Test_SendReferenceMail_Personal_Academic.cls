@isTest
private class Test_SendReferenceMail_Personal_Academic{
    
    @testSetup static void setup() {
        
        //Insert Shift Template
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',
                                        IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',
                                        Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        
        //Insert Account
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        //Insert Payroll
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        //Insert Contact
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        insert con;
        
        id payRTId = Schema.SObjectType.TR1__Reference__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
        
        //Insert Reference
        TR1__Reference__c ref = new TR1__Reference__c();
        ref.TR1__Person_Placed__c = con.id;
        ref.Name__c = 'Name1';
        ref.Email__c = 'abc@123.com';
        ref.Verbal_Reference__c = true;
ref.Educational_Establishment__c = 'abc';
    ref.Course_Start_Date__c = System.today();
        insert ref;
    
    }

    private static testmethod void shiftDetailsPositive(){

        List<TR1__Reference__c> ref = [Select id from TR1__Reference__c limit 1];
        List<String> refid = new List<String>();
        refid.add(ref[0].id);
        
        test.startTest();
        SendReferenceMail_Personal_Academic.sendEmail(refid);
        Integer invocations = Limits.getEmailInvocations();
        test.stopTest();
        
       // System.assertEquals(1,invocations); 
    }
    
    private static testmethod void shiftDetailsNegative(){
        List<IP_Shift_Template__c> shiftTemplate = [Select id from IP_Shift_Template__c limit 1];
        delete shiftTemplate;
        
        List<TR1__Reference__c> ref = [Select id from TR1__Reference__c limit 1];
        List<String> refid = new List<String>();
        refid.add(ref[0].id);
        
        test.startTest();
        SendReferenceMail_Personal_Academic.sendEmail(refid);
        Integer invocations = Limits.getEmailInvocations();
        test.stopTest();
        System.assertEquals(0,invocations); 
    }
}
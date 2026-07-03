@istest
public class TestAssignmentFirstPassLogic {

    public static testmethod void testpasslogic1()
    {
         RecordType rtacc = [Select id from RecordType where developername='Candidate' and SobjectType='Account'];
        RecordType rtcon = [Select id from RecordType where developername='Candidate' and SobjectType='Contact'];
        
        Account a = new Account();
        a.name='Candidates';
        a.RecordTypeId=rtacc.Id;
        insert a;
        
        Contact c = new Contact();
        c.LastName='contacttest';
        c.IP_CategoryOfWork__c='Catering';
        c.RecordTypeId=rtcon.id;
        c.FirstName='test';
        c.AccountId=a.Id;
        insert c;
        
        Payroll_Swtich__c pay = new Payroll_Swtich__c();
        pay.Name = 'Stoppayroll'; // Match the name expected by the trigger
        pay.Batch_check__c = true;
        insert pay;
        
       sirenum__ProActiveContract__c tcontract = new sirenum__ProActiveContract__c();
        tcontract.name='test contract';
        tcontract.sirenum__Contact__c=c.id;
        tcontract.sirenum__Client__c=a.Id;
        insert tcontract;
        
        sirenum__Rota__c impsector = new sirenum__Rota__c();
        impsector.name='test sector';
        insert impsector;
        
        sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name='test job category';
        jobtype.Impellam_Sector__c=impsector.id;
        jobtype.Impellam_Core_Category__c='Administration -ADM';
        jobtype.Impellam_Job_Category__c='Administrator -OA001';
        insert jobtype;
        
        sirenum__Team__c jobrole = new sirenum__Team__c();
        jobrole.name='test role';
        jobrole.sirenum__Account__c=tcontract.Id;
        jobrole.sirenum__Job_Type__c=jobtype.Id;
        insert jobrole;
        
    sirenum__Placement__c placement = new sirenum__Placement__c();
        placement.name='test placement';
        placement.sirenum__Start_Date__c=system.today();
        placement.sirenum__Job_Role__c=jobrole.Id;
        placement.sirenum__Contract__c=tcontract.Id;
        placement.sirenum__Contact__c=c.Id;
        insert placement;
        
        test.startTest();
        
        sirenum__Timesheet__c timesheet = new sirenum__Timesheet__c();
        timesheet.sirenum__Worker__c=c.id;
        timesheet.sirenum__Week_Ending__c=system.today();
        timesheet.sirenum__Non_Taxed_Expenses__c=10.2;
        timesheet.sirenum__Taxed_Expenses__c=20.1;
        timesheet.sirenum__Non_Taxed_Deductions__c=10.5;
        timesheet.sirenum__Taxed_Deductions__c=5.2;
        insert timesheet;
        
       // List<sirenum__Timesheet_Line__c> tsl =  TestDataFactory.createTimeSheetLine(timesheet.Id, null, 1) ;
        //insert tsl;
        List<ID> ids = new List<ID>();
        ids.add(timesheet.id);
        AssignmentFirstPassLogic.CancelShiftSiteOnHold(ids);
        test.stopTest();
        
    }
    
}
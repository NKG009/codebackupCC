@isTest
public class TaskUpdateTest {
       static testMethod void Test1() {

     
   insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

    Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
insert con;

        id payRTId = Schema.SObjectType.ts2__Reference__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();


Task task= new task();
task.Subject='Please provide details for your referees';
task.status='Completed';
task.Whoid= con.id;
insert task;

Task task1= new task();
task1.Subject='Blue Arrow - Post Interview Information Request';
task1.status='Completed';
task1.Whoid=con.id;
insert task1;

Task task2= new task();
task2.Subject='Blue Arrow - Static Compliance Forms';
task2.status='Completed';
task2.Whoid=con.id;
insert task2;
           
           Task task3= new task();
task3.Subject='Driving Post Interview Request Forms';
task3.status='Completed';
task3.Whoid=con.id;
insert task3;
       }
}
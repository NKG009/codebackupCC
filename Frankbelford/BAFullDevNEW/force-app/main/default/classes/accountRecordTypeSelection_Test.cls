@isTest
public class accountRecordTypeSelection_Test {
    static testMethod void testMethod4()
    {
             
        
        Account acc1 = new Account();
        
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(acc1);
        accountRecordTypeSelection_Ext ext = new accountRecordTypeSelection_Ext(sc);
        ext.selectedrecordtype = 'Candidate';
        ext.nextPage();
        accountRecordTypeSelection_Ext ext1 = new accountRecordTypeSelection_Ext(sc);
        ext1.selectedrecordtype = 'Candidate1';
        ext1.nextPage();
        ext1.cancelredirect();
        accountRecordTypeSelection_Ext ext2 = new accountRecordTypeSelection_Ext(sc);
        ext2.selectedrecordtype = '2nd Tier Supplier';
        ext2.nextPage();
        accountRecordTypeSelection_Ext ext3 = new accountRecordTypeSelection_Ext(sc);
        ext3.selectedrecordtype = 'Client';
        ext3.nextPage();
        accountRecordTypeSelection_Ext ext4 = new accountRecordTypeSelection_Ext(sc);
        ext4.selectedrecordtype = 'Account';
        ext4.nextPage();
        test.stopTest();
        
    }
    
}
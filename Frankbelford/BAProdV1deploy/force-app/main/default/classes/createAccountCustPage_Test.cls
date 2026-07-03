@isTest
public class createAccountCustPage_Test {
    static testMethod void testMethod1()
    {
        Account acc1= new Account();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(acc1);
        ApexPages.currentPage().getParameters().put('recid', devRecordTypeId);
        createAccountCustPage_Ext ext = new createAccountCustPage_Ext(sc);
        ext.accRec.IP_Business_Type__c='Catering';
        ext.accRec.RecordTypeId=devRecordTypeId;
        ext.accRec.Name='TestAccount';
         PageReference testPageResults1 = ext.saveandredirect();
        test.stopTest();
    }
    static testMethod void testMethod2()
    {
        Account acc1= new Account();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(acc1);
        ApexPages.currentPage().getParameters().put('recid', devRecordTypeId);
        createAccountCustPage_Ext ext = new createAccountCustPage_Ext(sc);
        ext.accRec.IP_Business_Type__c='Catering';
        ext.accRec.RecordTypeId=devRecordTypeId;
        ext.accRec.Name='TestAccount';
        ext.accRec.IP_CompanyRegistrationNo__c='12345678';
        PageReference testPageResults1 = ext.saveandredirect();
        PageReference testPageResults2 = ext.cancelredirect();
        ext.checkduplicate();
        ext.saveandredirectallowbypass();
        test.stopTest();
    }
    
    static testMethod void testMethodDuplicateInsert(){ 
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        
        //Insert Account
        Account accinsert = new Account();
        accinsert.IP_Business_Type__c='Catering';
        accinsert.RecordTypeId=devRecordTypeId;
        accinsert.Name='TestAccount';
        accinsert.IP_CompanyRegistrationNo__c='12345678';
        insert accinsert;
        
        Account acc1= new Account();
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(acc1);
        ApexPages.currentPage().getParameters().put('recid', devRecordTypeId);
        createAccountCustPage_Ext ext = new createAccountCustPage_Ext(sc);
        ext.accRec.IP_Business_Type__c='Catering';
        ext.accRec.RecordTypeId=devRecordTypeId;
        ext.accRec.Name='TestAccount';
        ext.accRec.IP_CompanyRegistrationNo__c='12345678';
        PageReference testPageResults1 = ext.saveandredirect();
        PageReference testPageResults2 = ext.cancelredirect();
        ext.checkduplicate();
        ext.saveandredirectallowbypass();
        test.stopTest();
    }
}
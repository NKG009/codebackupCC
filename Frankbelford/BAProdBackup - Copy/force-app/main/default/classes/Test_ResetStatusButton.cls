@isTest
public class Test_ResetStatusButton{

static testMethod void Test1(){

        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        
        
        
        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Errored';
        batchheader.IP_State__c ='Processing';
        batchheader.IP_BatchType__c ='Capita';
        insert batchheader;


        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Test error';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_LinkField4__c = acc1.id;
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_LinkField4__c = '';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P9';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
        
        Test.startTest();
        ResetStatusButton.resetButtonMethod(batchheader.id);
        Test.stopTest();

}
static testMethod void Test2(){

        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        
        
        
        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Errored';
        batchheader.IP_State__c ='Processing';
        batchheader.IP_BatchType__c ='Netive';
        insert batchheader;


        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Test error';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_LinkField4__c = '';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P9';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
        
        Test.startTest();
        ResetStatusButton.resetButtonMethod(batchheader.id);
        Test.stopTest();

}
static testMethod void Test3(){

        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;

        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Errored';
        batchheader.IP_State__c ='Processing';
        batchheader.IP_BatchType__c ='Site Update';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Test error';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_LinkField4__c = '';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P9';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
        
        Test.startTest();
        ResetStatusButton.resetButtonMethod(batchheader.id);
        Test.stopTest();

}
static testMethod void Test4(){

        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;

        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Errored';
        batchheader.IP_State__c ='Processing';
        batchheader.IP_BatchType__c ='Topaz Global Account';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Test error';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_LinkField4__c = '';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P9';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
        
        Test.startTest();
        ResetStatusButton.resetButtonMethod(batchheader.id);
        Test.stopTest();

}
static testMethod void Test5(){

        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;

        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Errored';
        batchheader.IP_State__c ='Processing';
        batchheader.IP_BatchType__c ='Perm Placement';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Test error';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_LinkField4__c = '';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P9';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
        
        Test.startTest();
        ResetStatusButton.resetButtonMethod(batchheader.id);
        Test.stopTest();

}
static testMethod void Test6(){

        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;

        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Errored';
        batchheader.IP_State__c ='Processing';
        batchheader.IP_BatchType__c ='Umbrella Company';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Test error';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = 'testpay1';
        batchline2.IP_LinkField4__c = '';
        batchline2.IP_TextField1__c = 'testpay12';
        batchline2.IP_DateField2__c=Date.newInstance(2017,11,24);
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        batchline2.IP_CurrencyField1__c = 10;
        batchline2.IP_CurrencyField2__c = 11;
        batchline2.IP_TextField3__c = 'Standard Hours /P9';
        batchline2.IP_Number12d4Field1__c =12;
        insert batchline2; // legacycon
        
        Test.startTest();
        ResetStatusButton.resetButtonMethod(batchheader.id);
        Test.stopTest();

}

}
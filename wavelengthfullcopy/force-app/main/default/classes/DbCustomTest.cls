@IsTest
private class DbCustomTest {
    @IsTest
    private static void testInsert() {
        Test.startTest();
        
         ESAPI.encoder();
  
        
        Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(lead1, new Schema.SObjectField[] { Lead.LastName });
        
        Lead lead2 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(new List<Lead> { lead2 }, new Schema.SObjectField[] { Lead.LastName });
        
        Lead lead3 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(
                new List<Lead> { lead3 }, new Schema.SObjectField[] { Lead.LastName }, true);
        
        Lead lead4 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(lead4, 'LastName');
        
        Lead lead5 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(new List<Lead> { lead5 }, 'LastName');
        
        Lead lead6 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(new List<Lead> { lead6 }, 'LastName', true);
        
        Lead lead7 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(lead7, new List<String> { 'LastName' });
        
        Lead lead8 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(new List<Lead> { lead8 }, new List<String> { 'LastName' });
        
        Lead lead9 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        DbCustom.doInsert(new List<Lead> { lead9 }, new List<String> { 'LastName' }, true);
        
        
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testUpdate() {
        Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        insert lead1;
        
        Test.startTest();
        
        DbCustom.doUpdate(lead1, new Schema.SObjectField[] { Lead.LastName });
        DbCustom.doUpdate(new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName });
        DbCustom.doUpdate(
                new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName }, true);
        DbCustom.doUpdate(lead1, 'LastName');
        DbCustom.doUpdate(new List<Lead> { lead1 }, 'LastName');
        DbCustom.doUpdate(new List<Lead> { lead1 }, 'LastName', true);
        DbCustom.doUpdate(lead1, new List<String> { 'LastName' });
        DbCustom.doUpdate(new List<Lead> { lead1 }, new List<String> { 'LastName' });
        DbCustom.doUpdate(new List<Lead> { lead1 }, new List<String> { 'LastName' }, true);
    //    DbCustom.doUpdate(lead1);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testUpsert() {
        Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
        insert lead1;
        
        Test.startTest();
        
        DbCustom.doUpsert(lead1, new Schema.SObjectField[] { Lead.LastName });
        DbCustom.doUpsert(new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName });
        DbCustom.doUpsert(
                new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName }, null);
        DbCustom.doUpsert(lead1, 'LastName');
        DbCustom.doUpsert(new List<Lead> { lead1 }, 'LastName');
        DbCustom.doUpsert(new List<Lead> { lead1 }, 'LastName', null);
        DbCustom.doUpsert(lead1, new List<String> { 'LastName' });
        DbCustom.doUpsert(new List<Lead> { lead1 }, new List<String> { 'LastName' });
        DbCustom.doUpsert(new List<Lead> { lead1 }, new List<String> { 'LastName' }, null);
        DbCustom.doUpsert(lead1);
        DbCustom.isReadable(lead1);
            Test.stopTest();
    }
    
    @IsTest
    private static void testDelete() {
        List<Lead> leads = new List<Lead> {
                new Lead(LastName = 'Test', Company = 'Test', Status = 'Open'),
                new Lead(LastName = 'Test', Company = 'Test', Status = 'Open'),
                new Lead(LastName = 'Test', Company = 'Test', Status = 'Open')
        };
        insert leads;
        
        Test.startTest();
        
        DbCustom.doDelete(leads[0]);
        DbCustom.doDelete(new List<Lead> { leads[1] });
        DbCustom.doDelete(new List<Lead> { leads[2] }, true);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testPermissions() {
        Test.startTest();
        
     //   DbCustom.isReadable(Lead.SObjectType);
        DbCustom.isReadable(Lead.SObjectType, 'LastName');
    //    DbCustom.isReadable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        DbCustom.isInsertable(Lead.SObjectType);
        DbCustom.isInsertable(Lead.SObjectType, 'LastName');
        DbCustom.isInsertable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        DbCustom.isUpdatable(Lead.SObjectType);
        DbCustom.isUpdatable(Lead.SObjectType, 'LastName');
        DbCustom.isUpdatable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        DbCustom.isUpsertable(Lead.SObjectType);
        DbCustom.isUpsertable(Lead.SObjectType, 'LastName');
        DbCustom.isUpsertable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        DbCustom.isDeletable(Lead.SObjectType);
        
        try {
            DbCustom.isSettable(Lead.SObjectType);
        } catch (Exception e) {
        }
        
        try {
            DbCustom.isSettable(Lead.SObjectType, 'LastName');
        } catch (Exception e) {
        }
        
        try {
            DbCustom.isSettable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        } catch (Exception e) {
        }
        
        Test.stopTest();
    }

}
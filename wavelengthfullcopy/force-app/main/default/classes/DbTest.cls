@IsTest
private class DbTest {
	@IsTest
    private static void testInsert() {
        Test.startTest();
        
         ESAPI.encoder();
  
        
Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open',Email ='abhi22@gmail.com', Phone ='1123456789');
        Db.doInsert(lead1, new Schema.SObjectField[] { Lead.LastName });
        
        Lead lead2 = new Lead(LastName = 'Test12', Company = 'Test2', Status = 'Open',Email ='abhi2@gmail.com', Phone ='1123456789');
        Db.doInsert(new List<Lead> { lead2 }, new Schema.SObjectField[] { Lead.LastName });
        
        Lead lead3 = new Lead(LastName = 'Test13', Company = 'Test3', Status = 'Open',Email ='abhi12@gmail.com', Phone ='1123456789');
        Db.doInsert(
                new List<Lead> { lead3 }, new Schema.SObjectField[] { Lead.LastName }, true);
        
       Lead lead4 = new Lead(LastName = 'Test14', Company = 'Test14', Status = 'Open',Email ='abhi14@gmail.com', Phone ='1123456789');
        Db.doInsert(lead4, 'LastName');
        
        Lead lead5 = new Lead(LastName = 'Test15', Company = 'Test15', Status = 'Open',Email ='abhi15@gmail.com', Phone ='1123456789');
        Db.doInsert(new List<Lead> { lead5 }, 'LastName');
        
        Lead lead6 = new Lead(LastName = 'Test16', Company = 'Test16', Status = 'Open',Email ='abhi16@gmail.com', Phone ='1123456789');
        Db.doInsert(new List<Lead> { lead6 }, 'LastName', true);
        
        Lead lead7 = new Lead(LastName = 'Test17', Company = 'Test17', Status = 'Open',Email ='abhi17@gmail.com', Phone ='1123456789');
        Db.doInsert(lead7, new List<String> { 'LastName' });
        
        Lead lead8 = new Lead(LastName = 'Test18', Company = 'Test18', Status = 'Open',Email ='abhi18@gmail.com', Phone ='1123456789');
        Db.doInsert(new List<Lead> { lead8 }, new List<String> { 'LastName' });
        
        Lead lead9 = new Lead(LastName = 'Test19', Company = 'Test19', Status = 'Open',Email ='abhi19@gmail.com', Phone ='1123456789');
        Db.doInsert(new List<Lead> { lead9 }, new List<String> { 'LastName' }, true);
        
        
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testUpdate() {
        Lead lead1 = new Lead(LastName = 'Test18', Company = 'Test188', Status = 'Open',Email ='abhi198@gmail.com', Phone ='1123456789');
        insert lead1;
        
        Test.startTest();
        
        Db.doUpdate(lead1, new Schema.SObjectField[] { Lead.LastName });
        Db.doUpdate(new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName });
        Db.doUpdate(
                new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName }, true);
        Db.doUpdate(lead1, 'LastName');
        Db.doUpdate(new List<Lead> { lead1 }, 'LastName');
        Db.doUpdate(new List<Lead> { lead1 }, 'LastName', true);
        Db.doUpdate(lead1, new List<String> { 'LastName' });
        Db.doUpdate(new List<Lead> { lead1 }, new List<String> { 'LastName' });
        Db.doUpdate(new List<Lead> { lead1 }, new List<String> { 'LastName' }, true);
    //    Db.doUpdate(lead1);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testUpsert() {
        Lead lead1 = new Lead(LastName = 'Test19', Company = 'Test44', Status = 'Open',Email ='abhi1944@gmail.com', Phone ='1123456789');
		insert lead1;
        
        Test.startTest();
        
        Db.doUpsert(lead1, new Schema.SObjectField[] { Lead.LastName });
        Db.doUpsert(new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName });
        Db.doUpsert(
                new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName }, null);
        Db.doUpsert(lead1, 'LastName');
        Db.doUpsert(new List<Lead> { lead1 }, 'LastName');
        Db.doUpsert(new List<Lead> { lead1 }, 'LastName', null);
        Db.doUpsert(lead1, new List<String> { 'LastName' });
        Db.doUpsert(new List<Lead> { lead1 }, new List<String> { 'LastName' });
        Db.doUpsert(new List<Lead> { lead1 }, new List<String> { 'LastName' }, null);
        Db.doUpsert(lead1);
        Db.isReadable(lead1);
            Test.stopTest();
    }
    
    @IsTest
    private static void testDelete() {
       List<Lead> leads = new List<Lead> {
				new Lead(LastName = 'Test21', Company = 'Test', Status = 'Open',Email ='abhi@gmail.com', Phone ='1123456789'),
				new Lead(LastName = 'Test22', Company = 'Test', Status = 'Open',Email ='abhi@gmail.com', Phone ='1123456789'),
				new Lead(LastName = 'Test23', Company = 'Test', Status = 'Open',Email ='abhi@gmail.com', Phone ='1123456789')
		};
        insert leads;
        
        Test.startTest();
        
        Db.doDelete(leads[0]);
        Db.doDelete(new List<Lead> { leads[1] });
        Db.doDelete(new List<Lead> { leads[2] }, true);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testPermissions() {
        Test.startTest();
        
     //   Db.isReadable(Lead.SObjectType);
        Db.isReadable(Lead.SObjectType, 'LastName');
    //    Db.isReadable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        Db.isInsertable(Lead.SObjectType);
        Db.isInsertable(Lead.SObjectType, 'LastName');
        Db.isInsertable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        Db.isUpdatable(Lead.SObjectType);
        Db.isUpdatable(Lead.SObjectType, 'LastName');
        Db.isUpdatable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        Db.isUpsertable(Lead.SObjectType);
        Db.isUpsertable(Lead.SObjectType, 'LastName');
        Db.isUpsertable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        
        Db.isDeletable(Lead.SObjectType);
        
        try {
            Db.isSettable(Lead.SObjectType);
        } catch (Exception e) {
        }
        
        try {
            Db.isSettable(Lead.SObjectType, 'LastName');
        } catch (Exception e) {
        }
        
        try {
            Db.isSettable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
        } catch (Exception e) {
        }
        
        Test.stopTest();
    }
}
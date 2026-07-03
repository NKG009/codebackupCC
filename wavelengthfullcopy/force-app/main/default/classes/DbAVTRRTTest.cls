@IsTest
private class DbAVTRRTTest {
	@IsTest
	private static void testInsert() {
		Test.startTest();
		
		Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(lead1, new Schema.SObjectField[] { Lead.LastName });
		
		Lead lead2 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(new List<Lead> { lead2 }, new Schema.SObjectField[] { Lead.LastName });
		
		Lead lead3 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(
				new List<Lead> { lead3 }, new Schema.SObjectField[] { Lead.LastName }, true);
		
		Lead lead4 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(lead4, 'LastName');
		
		Lead lead5 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(new List<Lead> { lead5 }, 'LastName');
		
		Lead lead6 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(new List<Lead> { lead6 }, 'LastName', true);
		
		Lead lead7 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(lead7, new List<String> { 'LastName' });
		
		Lead lead8 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(new List<Lead> { lead8 }, new List<String> { 'LastName' });
		
		Lead lead9 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(new List<Lead> { lead9 }, new List<String> { 'LastName' }, true);
        
        Lead lead10 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		DbAVTRRT.doInsert(lead10 );
		
		Test.stopTest();
	}
	
	@IsTest
	private static void testUpdate() {
		Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		insert lead1;
		
		Test.startTest();
		
		DbAVTRRT.doUpdate(lead1, new Schema.SObjectField[] { Lead.LastName });
		DbAVTRRT.doUpdate(new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName });
		DbAVTRRT.doUpdate(
				new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName }, true);
		DbAVTRRT.doUpdate(lead1, 'LastName');
		DbAVTRRT.doUpdate(new List<Lead> { lead1 }, 'LastName');
		DbAVTRRT.doUpdate(new List<Lead> { lead1 }, 'LastName', true);
		DbAVTRRT.doUpdate(lead1, new List<String> { 'LastName' });
		DbAVTRRT.doUpdate(new List<Lead> { lead1 }, new List<String> { 'LastName' });
		DbAVTRRT.doUpdate(new List<Lead> { lead1 }, new List<String> { 'LastName' }, true);
        DbAVTRRT.doUpdate(lead1);
        DbAVTRRT.doUpdate(new List<Lead> { lead1 });
		
		Test.stopTest();
	}
	
	@IsTest
	private static void testUpsert() {
		Lead lead1 = new Lead(LastName = 'Test', Company = 'Test', Status = 'Open');
		insert lead1;
		
		Test.startTest();
		
		DbAVTRRT.doUpsert(lead1, new Schema.SObjectField[] { Lead.LastName });
		DbAVTRRT.doUpsert(new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName });
		DbAVTRRT.doUpsert(
				new List<Lead> { lead1 }, new Schema.SObjectField[] { Lead.LastName }, null);
		DbAVTRRT.doUpsert(lead1, 'LastName');
		DbAVTRRT.doUpsert(new List<Lead> { lead1 }, 'LastName');
		DbAVTRRT.doUpsert(new List<Lead> { lead1 }, 'LastName', null);
		DbAVTRRT.doUpsert(lead1, new List<String> { 'LastName' });
		DbAVTRRT.doUpsert(new List<Lead> { lead1 }, new List<String> { 'LastName' });
		DbAVTRRT.doUpsert(new List<Lead> { lead1 }, new List<String> { 'LastName' }, null);
		
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
		
		DbAVTRRT.doDelete(leads[0]);
		DbAVTRRT.doDelete(new List<Lead> { leads[1] });
		DbAVTRRT.doDelete(new List<Lead> { leads[2] }, true);
		
		Test.stopTest();
	}
	
	@IsTest
	private static void testPermissions() {
		Test.startTest();
		
		DbAVTRRT.isReadable(Lead.SObjectType);
		DbAVTRRT.isReadable(Lead.SObjectType, 'LastName');
		DbAVTRRT.isReadable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
		
		DbAVTRRT.isInsertable(Lead.SObjectType);
		DbAVTRRT.isInsertable(Lead.SObjectType, 'LastName');
		DbAVTRRT.isInsertable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
		
		DbAVTRRT.isUpdatable(Lead.SObjectType);
		DbAVTRRT.isUpdatable(Lead.SObjectType, 'LastName');
		DbAVTRRT.isUpdatable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
		
		DbAVTRRT.isUpsertable(Lead.SObjectType);
		DbAVTRRT.isUpsertable(Lead.SObjectType, 'LastName');
		DbAVTRRT.isUpsertable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
		
		DbAVTRRT.isDeletable(Lead.SObjectType);
		
		try {
			DbAVTRRT.isSettable(Lead.SObjectType);
		} catch (Exception e) {
		}
		
		try {
			DbAVTRRT.isSettable(Lead.SObjectType, 'LastName');
		} catch (Exception e) {
		}
		
		try {
			DbAVTRRT.isSettable(Lead.SObjectType, new Schema.SObjectField[] { Lead.LastName });
		} catch (Exception e) {
		}
		
		Test.stopTest();
	}
}
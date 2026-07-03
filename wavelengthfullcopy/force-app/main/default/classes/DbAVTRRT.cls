public without sharing class DbAVTRRT {
  public static final Schema.SObjectField[] NO_FLS = null;
  
  private static AVTRRT.Logger logger = new AVTRRT.Logger('Db');
  
  public static Savepoint setSavepoint() {
    // Create savepoint for functional code runs only.
    // For unit tests it is not required and may fall with
    // System.CalloutException: You have already created Savepoints.
    //      You cannot make callout after creating a Savepoint exception.
    return Test.isRunningTest() ? null : Database.setSavepoint();
  }
  
  public static List<Database.SaveResult> doInsert(SObject record) {
    return doInsert(new SObject[] {record});
  }
  
  public static List<Database.SaveResult> doInsert(SObject[] records) {
    return doInsertRun(records, getAllPopulatedFieldsString(records), true);
  }
  
  public static List<Database.SaveResult> doInsert(
      SObject record, Schema.SObjectField[] fields) {
    
    return doInsertRun(new List<SObject> { record }, fields, true);
  }
  
  public static List<Database.SaveResult> doInsert(
      List<SObject> records, Schema.SObjectField[] fields) {
    
    return doInsertRun(records, fields, true);
  }
  
  public static List<Database.SaveResult> doInsert(
      List<SObject> records, Schema.SObjectField[] fields, Boolean allOrNone) {
    
    return doInsertRun(records, fields, allOrNone);
  }
  
  public static List<Database.SaveResult> doInsert(
      SObject record, String fields) {
    
    return doInsertRun(new List<SObject> { record }, fields, true);
  }
  
  public static List<Database.SaveResult> doInsert(
      List<SObject> records, String fields) {
    
    return doInsertRun(records, fields, true);
  }
  
  public static List<Database.SaveResult> doInsert(
      List<SObject> records, String fields, Boolean allOrNone) {
    
    return doInsertRun(records, fields, allOrNone);
  }
  
  public static List<Database.SaveResult> doInsert(
      SObject record, List<String> fields) {
    
    return doInsertRun(new List<SObject> { record }, fields, true);
  }
  
  public static List<Database.SaveResult> doInsert(
      List<SObject> records, List<String> fields) {
    
    return doInsertRun(records, fields, true);
  }
  
  public static List<Database.SaveResult> doInsert(
      List<SObject> records, List<String> fields, Boolean allOrNone) {
    
    return doInsertRun(records, fields, allOrNone);
  }
  
  private static List<Database.SaveResult> doInsertRun(
      List<SObject> records, Object fields, Boolean allOrNone) {
    
    if (records.size() > 0) {
      if (fields instanceof String) {
        isInsertable(records[0].getSObjectType(), (String)fields);
      } else if (fields instanceof List<String>) {
        isInsertable(records[0].getSObjectType(), String.join((List<String>)fields, ','));
      } else {
        isInsertable(records[0].getSObjectType(), (Schema.SObjectField[])fields);
      }
      
      return Database.insert(records, allOrNone);
    }
    
    return null;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
  
  public static List<Database.SaveResult> doUpdate(SObject record) {
    return doUpdate(new SObject[] {record});
  }
  
  public static List<Database.SaveResult> doUpdate(SObject[] records) {
    return doUpdateRun(records, getAllPopulatedFieldsString(records), true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      SObject record, Schema.SObjectField[] fields) {
    
    return doUpdateRun(new List<SObject> { record }, fields, true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      List<SObject> records, Schema.SObjectField[] fields) {
    
    return doUpdateRun(records, fields, true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      List<SObject> records, Schema.SObjectField[] fields, Boolean allOrNone) {
    
    return doUpdateRun(records, fields, allOrNone);
  }
  
  public static List<Database.SaveResult> doUpdate(
      SObject record, String fields) {
    
    return doUpdateRun(new List<SObject> { record }, fields, true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      List<SObject> records, String fields) {
    
    return doUpdateRun(records, fields, true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      List<SObject> records, String fields, Boolean allOrNone) {
    
    return doUpdateRun(records, fields, allOrNone);
  }
  
  public static List<Database.SaveResult> doUpdate(
      SObject record, List<String> fields) {
    
    return doUpdateRun(new List<SObject> { record }, fields, true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      List<SObject> records, List<String> fields) {
    
    return doUpdateRun(records, fields, true);
  }
  
  public static List<Database.SaveResult> doUpdate(
      List<SObject> records, List<String> fields, Boolean allOrNone) {
    
    return doUpdateRun(records, fields, allOrNone);
  }
  
  private static List<Database.SaveResult> doUpdateRun(
      List<SObject> records, Object fields, Boolean allOrNone) {
    
    if (records.size() > 0) {
      if (fields instanceof String) {
        isUpdatable(records[0].getSObjectType(), (String)fields);
      } else if (fields instanceof List<String>) {
        isUpdatable(records[0].getSObjectType(), String.join((List<String>)fields, ','));
      } else {
        isUpdatable(records[0].getSObjectType(), (Schema.SObjectField[])fields);
      }
      
      return Database.update(records, allOrNone);
    }
    
    return null;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
  public static List<Database.UpsertResult> doUpsert(SObject record) {
    return doUpsert(new SObject[] {record});
  }
  
  public static List<Database.UpsertResult> doUpsert(SObject[] records) {
    return doUpsertRun(records, getAllPopulatedFieldsString(records), null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      SObject record, Schema.SObjectField[] fields) {
    
    return doUpsertRun(new List<SObject> { record }, fields, null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      List<SObject> records, Schema.SObjectField[] fields) {
    
    return doUpsertRun(records, fields, null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      List<SObject> records, Schema.SObjectField[] fields,
      Schema.SObjectField externalIdField) {
    
    return doUpsertRun(records, fields, externalIdField);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      SObject record, String fields) {
    
    return doUpsertRun(new List<SObject> { record }, fields, null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      List<SObject> records, String fields) {
    
    return doUpsertRun(records, fields, null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      List<SObject> records, String fields,
      Schema.SObjectField externalIdField) {
    
    return doUpsertRun(records, fields, externalIdField);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      SObject record, List<String> fields) {
    
    return doUpsertRun(new List<SObject> { record }, fields, null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      List<SObject> records, List<String> fields) {
    
    return doUpsertRun(records, fields, null);
  }
  
  public static List<Database.UpsertResult> doUpsert(
      List<SObject> records, List<String> fields,
      Schema.SObjectField externalIdField) {
    
    return doUpsertRun(records, fields, externalIdField);
  }
  
  private static List<SObject> dynamicCastToList(List<SObject> records) {
    // If we try to instantiate a generic SObject list and put the record there
    // then it will throw an error during upsert:
    //      "DML on generic List<SObject> only allowed for insert, update or delete".
    // To make it work we should instantiate the list of concrete type.
    // We can do this with dynamic Apex.
    
    String listType = 'List<' + records[0].getSObjectType() + '>';
    List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
    castRecords.addAll(records);
    
    return castRecords;
  }
  
  private static List<Database.UpsertResult> doUpsertRun(
      List<SObject> records, Object fields,
      Schema.SObjectField externalIdField) {
    
    if (records.size() > 0) {
      records = dynamicCastToList(records);
      
      if (fields instanceof String) {
        isUpsertable(records[0].getSObjectType(), (String)fields);
      } else if (fields instanceof List<String>) {
        isUpsertable(records[0].getSObjectType(), String.join((List<String>)fields, ','));
      } else {
        isUpsertable(records[0].getSObjectType(), (Schema.SObjectField[])fields);
      }
      
      if (externalIdField != null) {
        return Database.upsert(records, externalIdField);
      } else {
        return Database.upsert(records);
      }
    }
    
    return null;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
  
  public static List<Database.DeleteResult> doDelete(
      SObject record) {
    
    logger.log('doDelete', 'record', record);
    
    return doDelete(new List<SObject> { record }, true);
  }
  
  public static List<Database.DeleteResult> doDelete(
      List<SObject> records) {
    
    logger.log('doDelete', 'records', records);
    
    return doDelete(records, true);
  }
  
  public static List<Database.DeleteResult> doDelete(
      List<SObject> records, Boolean allOrNone) {
    
    logger.log('doDelete', 'records', records);
    logger.log('doDelete', 'allOrNone', allOrNone);
    
    if (records.size() > 0) {
      isDeletable(records[0].getSObjectType());
      
      // shows up in CheckMarx test as CRUD Delete vulnerability. FALSE POSITIVE.
      // above in isDeletable() we check for delete operation.
      return Database.delete(records, allOrNone);
    }
    
    return null;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
  
  public static void isReadable(SObject record) {
    logger.log('isReadable', 'record', record);
    
    if (record != null) {
      isReadable(
          record.getSObjectType(),
          getAllPopulatedFieldsString(new SObject[] {record}));
    }
  }
  
  public static void isReadable(SObject[] records) {
    logger.log('isReadable', 'records', records);
    
    if (records.size() > 0) {
      isReadable(records[0]);
    }
  }
  
  private static String getAllPopulatedFieldsString(SObject[] records) {
    logger.log('getAllPopulatedFieldsString', 'records', records);
    
    Set<String> populatedFields = new Set<String>();
    for (SObject record : records) {
      populatedFields.addAll(getPopulatedFields(record));
    }
    
    logger.log('getAllPopulatedFieldsString', 'populatedFields', populatedFields);
    
    return String.join(new List<String>(populatedFields), ',');
  }
  
  private static Set<String> getPopulatedFields(SObject record) {
    logger.log('getPopulatedFields', 'record', record);
    
    Set<String> populatedFields = new Set<String>();
    
    Map<String, Object> fieldNameToValue = record.getPopulatedFieldsAsMap();
    
    logger.log('getPopulatedFields', 'fieldNameToValue', fieldNameToValue);
    
    for (String fieldName : fieldNameToValue.keySet()) {
      Object value = fieldNameToValue.get(fieldName);
      
      logger.log('getPopulatedFields', 'fieldName', fieldName);
      logger.log('getPopulatedFields', 'value', value);
      
      if (value instanceof SObject) {
        logger.log('getPopulatedFields', 'value2', value);
        
        Set<String> parentPopulatedFields = getPopulatedFields((SObject)value);
        for (String parentPopulatedField : parentPopulatedFields) {
          populatedFields.add(fieldName + '.' + parentPopulatedField);
        }
      } else {
        populatedFields.add(fieldName);
      }
    }
    
    logger.log('getPopulatedFields', 'populatedFields', populatedFields);
    
    return populatedFields;
  }
  
  public static void isReadable(Schema.SObjectType sObjectType) {
    MetadataUtilNew.checkCrudFlsString(sObjectType, null, MetadataUtilNew.CHECK_READ);
  }
  
  public static void isReadable(Schema.SObjectType sObjectType, String fields) {
    MetadataUtilNew.checkCrudFlsString(sObjectType, fields, MetadataUtilNew.CHECK_READ);
  }
  
  public static void isReadable(Schema.SObjectType sObjectType, Schema.SObjectField[] fields) {
    MetadataUtilNew.checkCrudFls(sObjectType, fields, MetadataUtilNew.CHECK_READ);
  }
  
  public static void isSettable(Schema.SObjectType sObjectType) {
    MetadataUtilNew.checkCrudFlsString(sObjectType, null, getCrudOperationOfTrigger());
  }
  
  public static void isSettable(Schema.SObjectType sObjectType, String fields) {
    MetadataUtilNew.checkCrudFlsString(sObjectType, fields, getCrudOperationOfTrigger());
  }
  
  public static void isSettable(Schema.SObjectType sObjectType, Schema.SObjectField[] fields) {
    MetadataUtilNew.checkCrudFls(sObjectType, fields, getCrudOperationOfTrigger());
  }
  
  private static Integer getCrudOperationOfTrigger() {
    logger.log('getCrudOperationOfTrigger', 'Trigger.isInsert', Trigger.isInsert);
    
    if (!Trigger.isExecuting) {
      throw new DbException(
          'getCrudOperationOfTrigger: isSettable should be called from trigger only.');
    }
    
    Integer operation;
    if (Trigger.isBefore) {
      if (Trigger.isInsert) {
       operation = MetadataUtilNew.CHECK_INSERT;
      } else if (Trigger.isUpdate) {
       operation = MetadataUtilNew.CHECK_UPDATE;
      }
    }
    
    if (operation == null) {
      String context = Trigger.isBefore ? 'BEFORE ' : 'AFTER ';
      
      if (Trigger.isInsert) {
        context += 'INSERT';
      } else if (Trigger.isUpdate) {
        context += 'UPDATE';
      } else if (Trigger.isDelete) {
        context += 'DELETE';
      } else {
        context += 'UNDELETE';
      }
      
      throw new DbException(
          'getCrudOperationOfTrigger: isSettable should be called in trigger\'s ' +
              'before insert or before update only. Current context is ' +
              context + '.');
    }
    
    return operation;
  }
  
  public static void isInsertable(Schema.SObjectType sObjectType) {
     MetadataUtilNew.checkCrudFlsString(sObjectType, null, MetadataUtilNew.CHECK_INSERT);
  }
  
  public static void isInsertable(Schema.SObjectType sObjectType, String fields) {
     MetadataUtilNew.checkCrudFlsString(sObjectType, fields, MetadataUtilNew.CHECK_INSERT);
  }
  
  public static void isInsertable(Schema.SObjectType sObjectType, Schema.SObjectField[] fields) {
    MetadataUtilNew.checkCrudFls(sObjectType, fields, MetadataUtilNew.CHECK_INSERT);
  }
  
  public static void isUpdatable(Schema.SObjectType sObjectType) {
   MetadataUtilNew.checkCrudFlsString(sObjectType, null, MetadataUtilNew.CHECK_UPDATE);
  }
  
  public static void isUpdatable(Schema.SObjectType sObjectType, String fields) {
    MetadataUtilNew.checkCrudFlsString(sObjectType, fields, MetadataUtilNew.CHECK_UPDATE);
  }
  
  public static void isUpdatable(Schema.SObjectType sObjectType, Schema.SObjectField[] fields) {
   MetadataUtilNew.checkCrudFls(sObjectType, fields, MetadataUtilNew.CHECK_UPDATE);
  }
  
  public static void isUpsertable(Schema.SObjectType sObjectType) {
    MetadataUtilNew.checkCrudFls(sObjectType, null, MetadataUtilNew.CHECK_UPSERT);
  }
  
  public static void isUpsertable(Schema.SObjectType sObjectType, String fields) {
    MetadataUtilNew.checkCrudFlsString(sObjectType, fields, MetadataUtilNew.CHECK_UPSERT);
  }
  
  public static void isUpsertable(Schema.SObjectType sObjectType, Schema.SObjectField[] fields) {
   MetadataUtilNew.checkCrudFls(sObjectType, fields, MetadataUtilNew.CHECK_UPSERT);
  }
  
  public static void isDeletable(Schema.SObjectType sObjectType) {
    MetadataUtilNew.checkCrudFls(sObjectType, null, MetadataUtilNew.CHECK_DELETE);
  } 
  
  private with sharing class DbException extends Exception {
  }  
}
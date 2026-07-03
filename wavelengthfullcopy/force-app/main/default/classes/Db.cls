public inherited sharing class Db {
    
    
    public static final Schema.SObjectField[] NO_FLS = null;
    
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
        return doUpsertRun(new List<SObject> { record }, NO_FLS, null);
    }
    
    public static List<Database.UpsertResult> doUpsert(
        SObject record, Schema.SObjectField[] fields) {
            
            return doUpsertRun(new List<SObject> { record }, fields, null);
        }
    
    public static List<Database.UpsertResult> doUpsert(List<SObject> records) {
        return doUpsertRun(records, NO_FLS, null);
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
            
            return doDelete(new List<SObject> { record }, true);
        }
    
    public static List<Database.DeleteResult> doDelete(
        List<SObject> records) {
            
            return doDelete(records, true);
        }
    
    public static List<Database.DeleteResult> doDelete(
        List<SObject> records, Boolean allOrNone) {
            
            if (records.size() > 0) {
                isDeletable(records[0].getSObjectType());
                
                // shows up in CheckMarx test as CRUD Delete vulnerability. FALSE POSITIVE.
                // above in isDeletable() we check for delete operation.
                return Database.delete(records, allOrNone);
            }
            
            return null;
        }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public static void isReadable(Schema.sObjectType sObjectType) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, null, MetadataUtilNewCustom.CHECK_READ);
    }
    
    public static void isReadable(Schema.sObjectType sObjectType, String fields) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, fields, MetadataUtilNewCustom.CHECK_READ);
    }
    
    public static void isReadable(Schema.sObjectType sObjectType, Schema.SObjectField[] fields) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, fields, MetadataUtilNewCustom.CHECK_READ);
    }
    
    public static void isSettable(Schema.sObjectType sObjectType) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, null, getCrudOperationOfTrigger());
    }
    
    public static void isSettable(Schema.sObjectType sObjectType, String fields) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, fields, getCrudOperationOfTrigger());
    }
    
    public static void isSettable(Schema.sObjectType sObjectType, Schema.SObjectField[] fields) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, fields, getCrudOperationOfTrigger());
    }
    
    private static Integer getCrudOperationOfTrigger() {
        //logger.log('getCrudOperationOfTrigger', 'Trigger.isInsert', Trigger.isInsert);
        
        if (!Trigger.isExecuting) {
            throw new DbException(
                'getCrudOperationOfTrigger: isSettable should be called from trigger only.');
        }
        
        Integer operation;
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                operation = MetadataUtilNewCustom.CHECK_INSERT;
            } else if (Trigger.isUpdate) {
                operation = MetadataUtilNewCustom.CHECK_UPDATE;
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
    
    public static void isInsertable(Schema.sObjectType sObjectType) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, null, MetadataUtilNewCustom.CHECK_INSERT);
    }
    
    public static void isInsertable(Schema.sObjectType sObjectType, String fields) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, fields, MetadataUtilNewCustom.CHECK_INSERT);
    }
    
    public static void isInsertable(Schema.sObjectType sObjectType, Schema.SObjectField[] fields) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, fields, MetadataUtilNewCustom.CHECK_INSERT);
    }
    
    public static void isUpdatable(Schema.sObjectType sObjectType) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, null, MetadataUtilNewCustom.CHECK_UPDATE);
    }
    
    public static void isUpdatable(Schema.sObjectType sObjectType, String fields) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, fields, MetadataUtilNewCustom.CHECK_UPDATE);
    }
    
    public static void isUpdatable(Schema.sObjectType sObjectType, Schema.SObjectField[] fields) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, fields, MetadataUtilNewCustom.CHECK_UPDATE);
    }
    
    public static void isUpsertable(Schema.sObjectType sObjectType) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, null, MetadataUtilNewCustom.CHECK_UPSERT);
    }
    
    public static void isUpsertable(Schema.sObjectType sObjectType, String fields) {
        MetadataUtilNewCustom.checkCrudFlsString(sObjectType, fields, MetadataUtilNewCustom.CHECK_UPSERT);
    }
    
    public static void isUpsertable(Schema.sObjectType sObjectType, Schema.SObjectField[] fields) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, fields, MetadataUtilNewCustom.CHECK_UPSERT);
    }
    
    public static void isDeletable(Schema.sObjectType sObjectType) {
        MetadataUtilNewCustom.checkCrudFls(sObjectType, null, MetadataUtilNewCustom.CHECK_DELETE);
    }
    
    private with sharing class DbException extends Exception {}
    
    public static void isReadable(SObject[] records) {
        //  logger.log('isReadable', 'records', records);
        
        if (records.size() > 0) {
            isReadable(records[0]);
        }
    }
    
    public static void isReadable(SObject record) {
        //  logger.log('isReadable', 'record', record);
        
        if (record != null) {
            isReadable(
                record.getSObjectType(),
                getAllPopulatedFieldsString(new SObject[] {record}));
        }
    }
    
    private static String getAllPopulatedFieldsString(SObject[] records) {
        //  logger.log('getAllPopulatedFieldsString', 'records', records);
        
        Set<String> populatedFields = new Set<String>();
        for (SObject record : records) {
            populatedFields.addAll(getPopulatedFields(record));
        }
        
        //  logger.log('getAllPopulatedFieldsString', 'populatedFields', populatedFields);
        
        return String.join(new List<String>(populatedFields), ',');
    }
    
    private static Set<String> getPopulatedFields(SObject record) {
        //  logger.log('getPopulatedFields', 'record', record);
        
        Set<String> populatedFields = new Set<String>();
        
        if (record == null) {
            return populatedFields;
        }
        
        Map<String, Object> fieldNameToValue = record.getPopulatedFieldsAsMap();
        
        //  logger.log('getPopulatedFields', 'fieldNameToValue', fieldNameToValue);
        
        for (String fieldName : fieldNameToValue.keySet()) {
            Object value = fieldNameToValue.get(fieldName);
            
            //    logger.log('getPopulatedFields', 'fieldName', fieldName);
            //    logger.log('getPopulatedFields', 'value', value);
            
            SObject[] valueArray = castToSObjectArray(value);
            if (valueArray != null) { // Related list
                Db.isReadable(valueArray);
            } else if (value instanceof SObject) { // Parent record
                //      logger.log('getPopulatedFields', 'value2', value);
                
                Set<String> parentPopulatedFields = getPopulatedFields((SObject)value);
                for (String parentPopulatedField : parentPopulatedFields) {
                    populatedFields.add(fieldName + '.' + parentPopulatedField);
                }
            } else {
                populatedFields.add(fieldName);
            }
        }
        
        //  logger.log('getPopulatedFields', 'populatedFields', populatedFields);
        
        return populatedFields;
    }
    
    private static SObject[] castToSObjectArray(Object value) {
        try {
            return (SObject[])value;
        } catch (System.TypeException ex) {
            return null;
        }
    }
}
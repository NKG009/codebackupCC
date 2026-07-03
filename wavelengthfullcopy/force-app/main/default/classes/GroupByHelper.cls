/**
* @description Helper class for Grouping fields based on various criteria like by Id, etc.
*/
public without sharing class GroupByHelper {
//  private static Logger logger = new Logger('GroupByHelper');
  
  /**
* @name groupByField
* @param recordsToGroup List<sObject>
* @param keyField String
* @return Map<Object, List<sObject>>
*/
  // Usage: (Map<Object, List<TMS__Time__c>>)groupByField(times, 'TMS__Case__c');
  public static Map<Object, List<SObject>> groupByField(
      List<SObject> recordsToGroup, String keyField) {
    
    Map<Object, List<SObject>> keyToRecordsMap = new Map<Object, List<SObject>>();
    
    if (recordsToGroup != null) {
      for (SObject record : recordsToGroup) {
        Object key = MetadataUtilNew.getValue(record, keyField);
        
//        logger.log('groupByField', 'key', key);
        
        List<SObject> recordList = keyToRecordsMap.get(key);
        if (recordList == null) {
          recordList = new List<SObject>();
          keyToRecordsMap.put(key, recordList);
        }
        
        recordList.add(record);
      }
    }
    
    return keyToRecordsMap;
  }
  
  // Usage: Map<List<Object>, List<sObject>> keysToRecords = GroupByHelper.groupByFields(times, new List<String> { 'Project__c', 'Case__c' });
  public static Map<List<Object>, List<SObject>> groupByFields(
      List<SObject> recordsToGroup, List<String> keyFields) {
    
    Map<List<Object>, List<SObject>> keysToRecordsMap = new Map<List<Object>, List<SObject>>();
    
    if (recordsToGroup != null) {
      for (SObject record : recordsToGroup) {
        List<Object> keys = new List<Object>();
        
        for (String keyField : keyFields) {
          keys.add(MetadataUtilNew.getValue(record, keyField));
        }
        
        List<SObject> recordList = keysToRecordsMap.get(keys);
        if (recordList == null) {
          recordList = new List<SObject>();
          keysToRecordsMap.put(keys, recordList);
        }
        
        recordList.add(record);
      }
    }
    
    return keysToRecordsMap;
  }
  
  /**
* @name groupByFieldKeyId
* @param recordsToGroup List<sObject>
* @param keyField String
* @return Map<Id, List<sObject>>
*/
  public static Map<Id, List<SObject>> groupByFieldKeyId(
      List<SObject> recordsToGroup, String keyField) {
    
    Map<Id, List<SObject>> mapKeyId = new Map<Id, List<SObject>>();
    
    Map<Object, List<SObject>> mapKeyObject = groupByField(recordsToGroup, keyField);
    for (Object keyObj : mapKeyObject.keySet()) {
      Id keyId = (Id)keyObj;
      mapKeyId.put(keyId, mapKeyObject.get(keyObj));
    }
    
    return mapKeyId;
  }
  
  /**
* @name groupByFieldReturnSingle
* @param recordsToGroup List<sObject>
* @param keyField String
* @return Map<Object, sObject>
*/
  public static Map<Object, SObject> groupByFieldReturnSingle(
      List<SObject> recordsToGroup, String keyField) {
    
    Map<Object, SObject> result = new Map<Object, SObject>();
    
    Map<Object, List<SObject>> mapKeyObject = groupByField(recordsToGroup, keyField);
    for (Object keyObj : mapKeyObject.keySet()) {
      result.put(keyObj, mapKeyObject.get(keyObj)[0]);
    }
    
    return result;
  }
  
  /**
  * @name groupByIdToObject
  * @param recordsToGroup List<sObject>
  * @param keyField String
  * @return Map<Id, sObject>
  */
  public static Map<Id, SObject> groupByIdToObject(
      List<SObject> recordsToGroup, String keyField) {
    
    Map<Id, SObject> result = new Map<Id, SObject>();
    
    Map<Object, SObject> mapKeyObject = groupByFieldReturnSingle(recordsToGroup, keyField);
    for (Object keyObj : mapKeyObject.keySet()) {
      result.put((Id)keyObj, mapKeyObject.get(keyObj));
    }
    
    return result;
  }
  
  public static Set<Object> getFieldValues(List<SObject> records, String keyField) {
    Set<Object> fieldValues = new Set<Object>();
    
    for (SObject record : records) {
      fieldValues.add(MetadataUtilNew.getValue(record, keyField));
    }
    
    return fieldValues;
  }
  
  /**
  * @name getFieldValuesIds
  * @description Gets Set of field value ID.
  * @param records List<sObject>
  * @param keyField String
  * @return Set<Id>
  */
  public static Set<Id> getFieldValuesIds(List<SObject> records, String keyField) {
    Set<Id> fieldValues = new Set<Id>();
    
    for (SObject record : records) {
      fieldValues.add((Id)MetadataUtilNew.getValue(record, keyField));
    }
    
    return fieldValues;
  }
    
    public static Set<Id> getFieldValuesIds(
      SObject[] records, String keyField, Boolean includeNulls) {
    
    Set<Id> fieldValues = new Set<Id>();
    
    for (SObject record : records) {
      Id id = (Id)MetadataUtilNew.getValue(record, keyField);
      if (includeNulls || id != null) {
        fieldValues.add(id);
      }
    }
    
    return fieldValues;
  }
  
  /**
* @name getFieldValuesStrings
* @description Gets Set of field value String.
* @param records List<sObject>
* @param keyField String
* @return Set<String>
*/
  public static List<String> getFieldValuesStrings(List<SObject> records, String keyField) {
    List<String> fieldValues = new List<String>();
    
    for (SObject record : records) {
      fieldValues.add((String)MetadataUtilNew.getValue(record, keyField));
    }
    
    return fieldValues;
  }
  
  public static List<Date> getFieldValuesDates(List<SObject> records, String keyField) {
    List<Date> fieldValues = new List<Date>();
    
    for (SObject record : records) {
      fieldValues.add((Date)MetadataUtilNew.getValue(record, keyField));
    }
    
    return fieldValues;
  }
  
  public static List<String> removeBlankStrings(List<String> withBlank) {
    List<String> result = new List<String>();
    for (String record : withBlank) {
      if (String.isBlank(record)) {
        continue;
      }
      
      result.add(record);
    }
    
    return result;
  }
  
  public static List<SObject> filterBy(List<SObject> records, String criteria) {
    String[] criteriaParts;
    String operator;
    
    String[] allPossibleOperators = new String[] {'==', '!=', '<>'};
    for (String possibleOperator : allPossibleOperators) {
      operator = possibleOperator;
      
      criteriaParts = criteria.split(operator);
      if (criteriaParts.size() == 2) {
        criteriaParts[0] = criteriaParts[0].trim();
        criteriaParts[1] = criteriaParts[1].trim();
        
        if (criteriaParts[1] == 'null') {
          criteriaParts[1] = null;
        }
        
        break;
      }
    }
    
//    logger.log('filterBy', 'criteriaParts', criteriaParts);
//    logger.log('filterBy', 'operator', operator);
    
    /*String filterValueType;
    if (criteriaParts[1].startsWith('"')) {
      filterValueType = 'string';
      criteriaParts[1] = criteriaParts[1].removeStart('"').removeEnd('"');
    } else {
      filterValueType = 'number';
    }*/
    
    List<SObject> result = new List<SObject>();
    for (SObject record : records) {
//      logger.log('filterBy', 'record', record);
      
      Object value = MetadataUtilNew.getValue(record, criteriaParts[0]);
      
//      logger.log('filterBy', 'value', value);
      
      if (operator == '==' && value == criteriaParts[1]) {
        result.add(record);
      } else if ((operator == '!=' || operator == '<>') && value != criteriaParts[1]) {
        result.add(record);
      }
    }
    
//    logger.log('filterBy', 'result', result);
    
    return result;
  }
}
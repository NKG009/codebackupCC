/**
* @description class Implements methods to get meta data related details for fields and objects.
*/
global without sharing class MetadataUtilNew {
    global Schema.SObjectType sObjectType;
    
    private transient static Map<String, Schema.SObjectType> sObjectDescribesMap =
            Schema.getGlobalDescribe();
    private transient static Map<SObjectType, MetadataUtilNew> objectApiNameToMetadataUtil =
            new Map<SObjectType, MetadataUtilNew>();
    global static MetadataUtilNew getInstance(String objApiName) {
        Schema.SObjectType sObjectType = sObjectDescribesMap.get(objApiName.toLowerCase());
        if (sObjectType == null) {
            throw new MetadataException('sObject "' + objApiName + '" does not exist.');
        }
        return getInstance(sObjectType);
    }
    global static MetadataUtilNew getInstance(SObject obj) {
        return getInstance(obj.getSObjectType());
    }
    global static MetadataUtilNew getInstance(Id recordId) {
        return getInstance(recordId.getSobjectType());
    }
    global static MetadataUtilNew getInstance(Schema.SObjectType sObjectType) {
        MetadataUtilNew md = objectApiNameToMetadataUtil.get(sObjectType);
        
        if (md == null) {
            md = new MetadataUtilNew(sObjectType);
            
            objectApiNameToMetadataUtil.put(sObjectType, md);
        }
        return md;
    }
    
    private transient Schema.DescribeSObjectResult sObjectDescribeInner;
    global Schema.DescribeSObjectResult sObjectDescribe {
        get {
            if (sObjectDescribeInner == null) {
                sObjectDescribeInner = sObjectType.getDescribe();
            }
            return sObjectDescribeInner;
        }
        set {
            sObjectDescribeInner = value;
        }
    }
    
    private Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
    
    private static Map<Schema.SObjectField, Schema.DescribeFieldResult> fieldDescribeMap =
            new Map<Schema.SObjectField, Schema.DescribeFieldResult>();
    
    // private static LoggerCP logger = new LoggerCP('MetadataUtilNew');
    
    /**
    * @author Mikhail Ivanov
    * @date 09/18/2012
    * @description Constructor.
    * @param sObjectType sObject Type token.
            Example: MetadataUtilNew md = new MetadataUtilNew(Account.sObjectType);
    */
    global MetadataUtilNew(Schema.SObjectType sObjectType) {
        setMetadataClassesForObject(sObjectType);
    }
    
    global MetadataUtilNew(SObject obj) {
        setMetadataClassesForObject(obj.getSObjectType());
    }
    
    global MetadataUtilNew(Id recordId) {
        setMetadataClassesForObject(recordId.getSobjectType());
    }
    
    global MetadataUtilNew(String objApiName) {
        //logger.log('MetadataUtilNew', 'objApiName', objApiName);
        
        String objApiNameWithoutNamespace = objApiName;
        
       //  logger.log('MetadataUtilNew', 'sObjectDescribesMap', sObjectDescribesMap);
       //  logger.log('MetadataUtilNew', 'objApiNameWithoutNamespace', objApiNameWithoutNamespace);
        
        Schema.SObjectType sObjectType = sObjectDescribesMap.get(objApiNameWithoutNamespace);
        
        if (sObjectType != null) {
            setMetadataClassesForObject(sObjectType);
        } else {
            throw new MetadataException('sObject "' + '" does not exist.');
        }
    }

    private void setMetadataClassesForObject(Schema.SObjectType sObjectType) {
        // logger.log('MetadataUtilNew', 'setMetadataClassesForObject', sObjectType);
        
        this.sObjectType = sObjectType;
        this.sObjectDescribe = sObjectType.getDescribe();
        
        Map<String, Schema.SObjectField> fieldMapWith30vFields = sObjectDescribe.fields.getMap();
        remove30vFields(fieldMapWith30vFields);
    }
    
    private void remove30vFields(Map<String, Schema.SObjectField> fieldMapWith30vFields) {
        // Do a trick to workaround https://success.salesforce.com/issues_view?id=a1p30000000T3FOAA0
        SObject sObj = sObjectType.newSObject();
        for (String fieldName : fieldMapWith30vFields.keySet()) {
            try {
                sObj.get(fieldName);
                this.fieldMap.put(fieldName, fieldMapWith30vFields.get(fieldName));
            } catch (Exception ex) {
            }
        }
    }
    
    global String getObjectName() {
        return sObjectDescribe.getName();
    }
    
    global Schema.SObjectType getObjectType() {
        return sObjectType;
    }
    
    global Set<String> getAllFieldNames() {
        return fieldMap.keySet();
    }
    
    global List<Schema.SObjectField> getAllFieldsSObject() {
        return fieldMap.values();
    }
    
    global String getAllFieldsString() {
        List<String> sortedSObjectNames = new List<String>();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult describeFieldResult = field.getDescribe();
            
            if (describeFieldResult.getType() != Schema.DisplayType.LOCATION
                    && describeFieldResult.getType() != Schema.DisplayType.ADDRESS) {
                sortedSObjectNames.add(describeFieldResult.name);
            }
        }
        sortedSObjectNames.sort();
        
        return String.join(sortedSObjectNames, ',');
    }
    
    global String getAllFieldsString(
            List<Schema.SObjectField> parentRelationshipFields,
            List<Schema.SObjectField> childRelationshipFields) {
        
        Map<String, String> parentRelationshipNames =
                getParentRelationshipNames(parentRelationshipFields);
        
        List<String> childRelationshipNames =
                getChildRelationshipNames(childRelationshipFields);
        
        return getAllFieldsString(parentRelationshipNames, childRelationshipNames);
    }
    
    global String getAllFieldsString(
            Map<String, String> parentRelationshipNames,
            List<String> childRelationshipNames) {
        
        String queryParents = '';
        if (parentRelationshipNames != null) {
            for (String parentRelationshipName : parentRelationshipNames.keySet()) {
                String parentObjectAPIName = parentRelationshipNames.get(parentRelationshipName);
                
                MetadataUtilNew mdParent = new MetadataUtilNew(parentObjectAPIName);
                for (String parentFieldName : mdParent.getAllFieldNames()) {
                    queryParents += ', ' + parentRelationshipName + '.' + parentFieldName;
                }
            }
        }
        
        String queryChildren = '';
        if (childRelationshipNames != null) {
            for (String childRelationshipName : childRelationshipNames) {
                String childObjectAPIName
                        = getChildRelationshipNameByRelationshipName(childRelationshipName);
                
                MetadataUtilNew mdChild = new MetadataUtilNew(childObjectAPIName);
                
                MetadataUtilNew.checkCrudFls(
                        mdChild.sObjectType,
                        mdChild.fieldMap.values(),
                        MetadataUtilNew.CHECK_READ);
                
                String allChildFields = mdChild.getAllFieldsString();
                
                // logger.log('getAllFieldsString', 'allChildFields', allChildFields);
                
                queryChildren += ', (SELECT ' + allChildFields + ' FROM '
                        + childRelationshipName + ')';
            }
        }
        
        MetadataUtilNew.checkCrudFlsString(
                sObjectType,
                String.join(new List<String>(fieldMap.keySet()), ',') + queryParents,
                MetadataUtilNew.CHECK_READ);
        
        String allFields = getAllFieldsString();
        
        return allFields + queryParents + queryChildren;
    }
    
    global String makeWhereStatement(SObject sObjectWithValues) {
        String queryWhere = '';
        
        for (Schema.SObjectField field : getAllFieldsSObject()) {
            if (('' + field).startsWith('INVALID FIELD: ')) {
                continue;
            }
            
            Object fieldValue = sObjectWithValues.get(field);
            if (fieldValue != null) {
                String value = String.escapeSingleQuotes('' + fieldValue);
                
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                if (fieldDescribe.getType() == Schema.DisplayType.STRING ||
                        fieldDescribe.getType() == Schema.DisplayType.TEXTAREA) {
                    queryWhere += 'AND ' + field + ' LIKE \'%' + value + '%\' ';
                } else if (fieldDescribe.getType() == Schema.DisplayType.INTEGER ||
                        fieldDescribe.getType() == Schema.DisplayType.DOUBLE) {
                    queryWhere += 'AND ' + field + ' = ' + value + ' ';
                } else {
                    queryWhere += 'AND ' + field + ' = \'' + value + '\' ';
                }
            }
        }
        
        return queryWhere != '' ? queryWhere.substring(4) : '';
    }
    
    global SObject cloneById(Id id, List<String> relationshipNames) {
        SObject original = getRecordsById(new List<Id> { id }, null, relationshipNames)[0];
        
        SObject cloned = original.clone(false);
        MetadataUtilNew md = new MetadataUtilNew(cloned);
        DbAVTRRT.doInsert(cloned, md.getAllFieldsSObject());
        
        if (relationshipNames != null) {
            for (String relationshipName : relationshipNames) {
                List<SObject> originalChilds = original.getSObjects(relationshipName);
                if (originalChilds != null) {
                    List<SObject> clonedChilds = originalChilds.deepClone(false);
                    String parentFieldName = getFieldNameByRelationshipName(relationshipName);
                    for (SObject clonedChild : clonedChilds) {
                        clonedChild.put(parentFieldName, cloned.Id);
                    }
                    
                    if (clonedChilds.size() > 0) {
                        MetadataUtilNew mdChild = new MetadataUtilNew(clonedChilds[0]);
                        DbAVTRRT.doInsert(clonedChilds, mdChild.getAllFieldsSObject());
                    }
                }
            }
        }
        
        return cloned;
    }
    
    /**
    * @author Mikhail Ivanov
    * @date 12/09/2012
    * @description Gets the list of sObjects of current type including specified Parent
    *       and Child relationships.
    * @param idList List of Ids of records which should be returned.
    * @param v_parentRelationshipFields List of parent relationships lookup fields.
    *       If you don't want to retrieve parent records you should specify null.
    * @param v_childRelationshipFields List of child relationship fields which should be retrieved.
    *       If you don't want to retrieve children records you should specify null.
    * @return List<sObject> List of sObjects with specified parents and children.
    * @example v_account = (Account)md.getRecords(
                new Id[] {gen.account.Id},
                new List<Schema.sObjectField> { Account.ParentId },
                new List<Schema.sObjectField> { Contact.AccountId })[0];
    */
    global List<SObject> getRecords(List<Id> idList,
            List<Schema.SObjectField> v_parentRelationshipFields,
            List<Schema.SObjectField> v_childRelationshipFields) {
        
        return getRecords(idList, v_parentRelationshipFields, v_childRelationshipFields, null);
    }
    global List<SObject> getRecords(List<Id> idList,
            List<Schema.SObjectField> v_parentRelationshipFields,
            List<Schema.SObjectField> v_childRelationshipFields,
            Schema.SObjectField masterIdField) {
        
        Map<String, String> v_parentRelationshipNames =
                getParentRelationshipNames(v_parentRelationshipFields);
        
        List<String> v_childRelationshipNames =
                getChildRelationshipNames(v_childRelationshipFields);
        
        String whereIdField = (masterIdField != null)
                ? masterIdField.getDescribe().getName()
                : 'Id';
        
        return getRecordsById(
                idList, v_parentRelationshipNames, v_childRelationshipNames, whereIdField);
    }
    
    global DisplayType getFieldDisplayType(String compositeApiName) {
        List<String> apiPartList = (compositeApiName != null)
                ? compositeApiName.split('\\.')
                : new List<String>();
        
        Schema.SObjectType nextObjectApiType = getObjectType();
        for (Integer i = 0; i < apiPartList.size(); i++) {
            String apiPart = apiPartList[i];
            
            MetadataUtilNew md = new MetadataUtilNew(nextObjectApiType);
            if (i < apiPartList.size() - 1) {
                Schema.DescribeFieldResult field =
                        md.getFieldDescribeByFieldRelationshipApiName(apiPart);
                
                nextObjectApiType = getParentObjectApiTypeForLookupField(field.getSobjectField());
            } else {
                return md.getDescribeFieldResult(apiPart).getType();
            }
        }
        return null;
    }
    
    private Schema.DescribeFieldResult getFieldDescribeByFieldRelationshipApiName(
            String fieldRelationshipApiName) {
        
        for (Schema.SObjectField field : getAllFieldsSObject()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            /* logger.log('getFieldDescribeByFieldRelationshipApiName',
                    'fieldRelationshipApiName', fieldRelationshipApiName);
           logger.log('getFieldDescribeByFieldRelationshipApiName',
                    'fieldDescribe.getRelationshipName()', fieldDescribe.getRelationshipName());
            logger.log('getFieldDescribeByFieldRelationshipApiName',
                    'fieldDescribe.getName()', fieldDescribe.getName()); */
            
            if (fieldDescribe.getRelationshipName() == fieldRelationshipApiName) {
                return fieldDescribe;
            }
        }
        
        return null;
    }
    
    private Map<String, String> getParentRelationshipNames(
            List<Schema.SObjectField> v_parentRelationshipFields) {
        
        Map<String, String> v_parentRelationshipNames = new Map<String, String>();
        
        if (v_parentRelationshipFields != null) {
            for (Schema.SObjectField field : v_parentRelationshipFields) {
                
                String parentRelationshipName = getRelationshipNameForLookupField(field);
                
                String parentObjectApiName = getParentObjectApiNameForLookupField(field);
                
                v_parentRelationshipNames.put(parentRelationshipName, parentObjectApiName);
            }
        }
        
        return v_parentRelationshipNames;
    }
    
    private List<String> getChildRelationshipNames(
            List<Schema.SObjectField> v_childRelationshipFields) {
        
        List<String> v_childRelationshipNames = new List<String>();
        
        if (v_childRelationshipFields != null) {
            for (Schema.SObjectField field : v_childRelationshipFields) {
                String childRelationshipName
                        = getChildRelationshipNameByChildRelationshipSObjectField(field);
                
                v_childRelationshipNames.add(childRelationshipName);
            }
        }
        
        return v_childRelationshipNames;
    }
    
    private String getChildRelationshipNameByChildRelationshipSObjectField(
            Schema.SObjectField childRelationshipField) {
        
        for (Schema.ChildRelationship childRelationship
                : sObjectDescribe.getChildRelationships()) {
            if (childRelationship.getField() == childRelationshipField) {
                return childRelationship.getRelationshipName();
            }
        }
        
        return null;
    }
    
    public static String getParentObjectApiNameForLookupField(Schema.SObjectField sObjectField) {
        return getParentObjectDescribe(sObjectField).getName();
    }
    
    public static Schema.SObjectType getParentObjectApiTypeForLookupField(
            Schema.SObjectField sObjectField) {
        return getParentObjectDescribe(sObjectField).getSObjectType();
    }
    
    public static String getRelationshipNameForLookupField(Schema.SObjectField sObjectField) {
        return sObjectField.getDescribe().getRelationshipName();
    }
    
    public Schema.DescribeSObjectResult getParentObjectDescribe(String fieldApiName) {
        return getParentObjectDescribe(getSObjectField(fieldApiName));
    }
    
    private static Schema.DescribeSObjectResult getParentObjectDescribe(
            Schema.SObjectField sObjectField) {
        
        List<Schema.SObjectType> referenceSObjectTypeList =
                sObjectField.getDescribe().getReferenceTo();
        
        return referenceSObjectTypeList.size() > 0
                ? referenceSObjectTypeList[0].getDescribe() : null;
    }
    
    /**
    * @author Mikhail Ivanov
    * @date 15/08/2012
    * @description Gets the list of sObjects of current type including specified Parent
    *       and Child relationships.
    * @param idList List of Ids of records which should be returned.
    * @param parentRelationshipNames Map of parent relationships. Key is the Parent Relationship Name,
    *       value is a Local sObject API Name.
    *       If you don't want to retrieve parent records you should specify null.
    *       Example: new Map<String, String> {'Parent' => 'Account'}
    *       Note: If the sObject is from ' package, then sObject API Name should be without prefix.
    * @param v_childRelationshipNames List of child relationship names which should be retrieved.
    *       If you don't want to retrieve children records you should specify null.
    * @return List<sObject> List of sObjects with specified parents and childs.
    */
    global List<SObject> getRecordsById(List<Id> idList,
            Map<String, String> parentRelationshipNames,
            List<String> childRelationshipNames) {
        
        return getRecordsById(idList, parentRelationshipNames, childRelationshipNames, 'Id');
    }
    global List<SObject> getRecordsById(List<Id> idList,
            Map<String, String> parentRelationshipNames,
            List<String> childRelationshipNames,
            String whereIdField) {
        
        String objectAPIName = sObjectDescribe.getName();
        
        String allFields = getAllFieldsString(parentRelationshipNames, childRelationshipNames);
        
        // MetadataUtilNew.checkCrudFlsString is called inside of getAllFieldsString() above.
        
        MetadataUtilNew.checkCrudFlsString(
                new MetadataUtilNew(objectAPIName).sObjectType,
                whereIdField,
                MetadataUtilNew.CHECK_READ);
        
        String v_query =
                ' SELECT ' + allFields +
                        ' FROM ' + objectAPIName +
                        ' WHERE ' + String.escapeSingleQuotes(whereIdField) + ' IN :idList';
        
        List<SObject> v_resultList = Database.query(v_query);
        
        return v_resultList;
    }
    
    global void updateRecords(SObject source, SObject target) {
        for (String key : fieldMap.keySet()) {
            Object valueSource = source.get(key);
            Object valueTarget = target.get(key);
            if (valueSource != valueTarget) {
                try {
                    target.put(key, valueSource);
                } catch (System.SObjectException ex) {
                }
            }
        }
    }
    
    global Schema.SObjectField getSObjectField(String fieldName) {
        return String.isNotBlank(fieldName) ? fieldMap.get(fieldName.toLowerCase()) : null;
    }
    
    global Boolean isFieldExists(String fieldName) {
        return getSObjectField(fieldName) != null;
    }
    
    global Schema.DescribeFieldResult getDescribeFieldResult(String fieldName) {
        Schema.SObjectField sObjectField = getSObjectField(fieldName);
        return sObjectField != null ? getDescribeFieldResultStatic(sObjectField) : null;
    }
    
    global Schema.DescribeFieldResult getDescribeFieldResult(Schema.SObjectField sObjectField) {
        return getDescribeFieldResultStatic(sObjectField);
    }
    
    global static Schema.DescribeFieldResult getDescribeFieldResultStatic(
            Schema.SObjectField sObjectField) {
        
        Schema.DescribeFieldResult describeFieldResult = fieldDescribeMap.get(sObjectField);
        
        // logger.log('getDescribeFieldResult', 'describeFieldResult from cache', describeFieldResult);
        
        if (describeFieldResult == null) {
            describeFieldResult = sObjectField.getDescribe();
            fieldDescribeMap.put(sObjectField, describeFieldResult);
        }
        return describeFieldResult;
    }
    
    global String getFieldLabel(String fieldName) {
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(fieldName);
        return describeFieldResult != null ? describeFieldResult.label : null;
    }
    
    global String getFieldLabel(SObjectField sObjectField) {
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(sObjectField);
        return describeFieldResult != null ? describeFieldResult.label : null;
    }
    
    global Boolean isSortableField(String fieldName) {
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(fieldName);
        return describeFieldResult != null ? describeFieldResult.isSortable() : null;
    }
    
    global Boolean isEmailField(String fieldName) {
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(fieldName);
        return describeFieldResult != null
                ? describeFieldResult.getType() == Schema.DisplayType.EMAIL
                : null;
    }
    
    global Boolean isFormulaField(String fieldName) {
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(fieldName);
        return describeFieldResult != null ? describeFieldResult.isCalculated() : null;
    }
    
    global Object getFieldValue(String name, Object value) {
       //  logger.log('getFieldValue', 'name', name);
      //  logger.log('getFieldValue', 'value', value);
        
        if (value == null) {
            return null;
        }
        
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(name);
        if (describeFieldResult != null) {
            if (describeFieldResult.getType() == DisplayType.REFERENCE
                    && String.isNotBlank((String)value) && name != 'RecordTypeId') {
                return getRecordNameById((Id)value);
            }
        }
        
        return value;
    }
    
    global String getFieldValueAsString(String name, Object value) {
       // logger.log('getFieldValueAsString', 'name', name);
       // logger.log('getFieldValueAsString', 'value', value);
        
        if (value == null) {
            return null;
        }
        
        Schema.DescribeFieldResult describeFieldResult = getDescribeFieldResult(name);
        if (describeFieldResult != null) {
            if (describeFieldResult.getType() == DisplayType.REFERENCE
                    && String.isNotBlank((String)value)) {
                return getRecordNameById((Id)value);
            } else if (describeFieldResult.getType() == DisplayType.DATE) {
                return ((Date)value).format();
            }
        }
        
        return '' + value;
    }
    
    private static String getRecordNameById(Id id) {
       // logger.log('getRecordNameById', 'id', id);
        
        String objectAPIName = getObjectAPINameById(id);
        
        MetadataUtilNew.checkCrudFlsString(
                new MetadataUtilNew(objectAPIName).sObjectType,
                'Id, Name',
                MetadataUtilNew.CHECK_READ);
        
        SObject retObject = Database.query(
                ' SELECT Id, Name' +
                        ' FROM ' + objectAPIName +
                        ' WHERE Id = :id');
        
        return (String)retObject.get('Name');
    }
    
    global static String getObjectAPINameById(String idString) {
        return Id.valueOf(idString).getSobjectType().getDescribe().getName();
    }
    
    global String getChildRelationshipNameByRelationshipName(String name) {
       // logger.log('getChildRelationshipNameByRelationshipName', 'name', name);
        
        Schema.ChildRelationship rel = getChildRelationshipByRelationshipName(name);
        return rel.getChildSObject().getDescribe().getName();
    }
    
    global String getFieldNameByRelationshipName(String name) {
        Schema.ChildRelationship rel = getChildRelationshipByRelationshipName(name);
        return rel.getField().getDescribe().getName();
    }
    
    global Schema.ChildRelationship getChildRelationshipByRelationshipName(String name) {
        for (Schema.ChildRelationship rel : getAllChildRelationships()) {
            if (rel.relationshipName == name) {
                return rel;
            }
        }
        
        return null;
    }
    
    global List<String> getAllChildRelationshipsStrings() {
        List<String> result = new List<String>();
        for (Schema.ChildRelationship rel : getAllChildRelationships()) {
            if (rel.getRelationshipName() != null) {
                result.add(rel.getRelationshipName());
            }
        }
        result.sort();
        return result;
    }
    
    global List<Schema.ChildRelationship> getAllChildRelationships() {
        return sObjectDescribe.getChildRelationships();
    }
    
    global static String getWhereConstraint(String p, String e, String v, SObject searchObject) {
        if (p != null && e != null) {
            Schema.DescribeFieldResult f =
                    new MetadataUtilNew(searchObject).getDescribeFieldResult(p);
            
            if (f != null) {
                if (v == null || v == '') {
                    return p + ' ' + e + ' null ';
                }
                
                if (f.getType() == DisplayType.BOOLEAN) {
                    return p + ' = ' + v;
                }
                
                if (f.getType() == DisplayType.INTEGER
                        || f.getType() == DisplayType.PERCENT
                        || f.getType() == DisplayType.DOUBLE
                        || f.getType() == DisplayType.CURRENCY) {
                    return p + ' ' + e + ' ' + v;
                }
                
                if (f.getType() == DisplayType.DATE || f.getType() == DisplayType.DATETIME) {
                    if (f.getType() == DisplayType.DATE) {
                        Date d = Date.parse(v);
                        Datetime dTime = Datetime.newInstance(d.year(), d.month(), d.day());
                        return p + ' ' + e + ' ' + dTime.format('yyyy-MM-dd');
                    } else {
                        // In Visualforce page DateTime fields have date part only.
                        Date d = Date.parse(v);
                        Datetime dTime = Datetime.newInstance(d.year(), d.month(), d.day());
                        // Filters should by about date part only.
                        if (e == '=') {
                            return
                                    '(' + p + '>' + formatDateTimeToQueryString(dTime) + ' AND ' +
                                            p + '<' + formatDateTimeToQueryString(dTime.addDays(1)) + ')';
                        }
                        if (e == '!=') {
                            return
                                    '(' + p + '<' + formatDateTimeToQueryString(dTime) + ' OR ' +
                                            p + '>' + formatDateTimeToQueryString(dTime.addDays(1)) + ')';
                        }
                        if (e == '>') {
                            return '(' + p + '>' + formatDateTimeToQueryString(dTime.addDays(1)) + ')';
                        }
                        if (e == '<=') {
                            return '(' + p + '<' + formatDateTimeToQueryString(dTime.addDays(1)) + ')';
                        }
                        return p + e + formatDateTimeToQueryString(dTime);
                    }
                }
                if (f.getType() == DisplayType.MULTIPICKLIST) {
                    String[] values = String.escapeSingleQuotes(v).split(',');
                    String strs = '';
                    for (String st : values) {
                        if (!strs.equals('')) {
                            strs += ',';
                        }
                        strs += '\'' + st + '\'' ;
                    }
                    if (e.equals('=')) {
                        return p + ' includes (' + strs + ')';
                    }
                    if (e.equals('!=')) {
                        return p + ' excludes (' + strs + ')';
                    }
                    return p + ' ' + e + ' \'' + String.escapeSingleQuotes(v) + '\'';
                }
                //DisplayType.String, TextArea, Phone, Id, Picklist, Url
                if (e.equals('contains')) {
                    return p + ' like \'%' + String.escapeSingleQuotes(v) + '%\'';
                }
                if (e.equals('startswith')) {
                    return p + ' like \'' + String.escapeSingleQuotes(v) + '%\'';
                }
                if (e.equals('not contains')) {
                    return ' ( not ' + p + ' like \'%' + String.escapeSingleQuotes(v) + '%\'' + ')';
                }
                return p + ' ' + e + ' \'' + String.escapeSingleQuotes(v) + '\'';
            }
        }
        v = null;
        return '';
    }
    
    // Convert DateTime field to format SOSL understand.
    global static String formatDateTimeToQueryString(Datetime dTime) {
        return dTime.formatGmt('yyyy-MM-dd') + 'T' + dTime.formatGmt('HH:mm:ss') + 'Z';
    }
    
    global Object getValueByFieldType(String fieldName, String valueInStringFormat) {
        Schema.DescribeFieldResult describeField = getDescribeFieldResult(fieldName);
        
        if (describeField != null) {
            if (describeField.getType() == DisplayType.BOOLEAN) {
                return valueInStringFormat == '1' || valueInStringFormat == 'true' ? true : false;
            }
            
            if (describeField.getType() == DisplayType.INTEGER) {
                valueInStringFormat = valueInStringFormat.replaceAll('\\D', '');
                return valueInStringFormat != '' ? Integer.valueOf(valueInStringFormat) : null;
            }
            
            if (describeField.getType() == DisplayType.DOUBLE
                    || describeField.getType() == DisplayType.CURRENCY
                    || describeField.getType() == DisplayType.PERCENT) {
                
                valueInStringFormat = valueInStringFormat.replaceAll('\\D', '');
                return valueInStringFormat != '' ? Decimal.valueOf(valueInStringFormat) : null;
            }
            
            if (describeField.getType() == DisplayType.DATE) {
                return Date.parse(valueInStringFormat);
            }
        }
        
        return valueInStringFormat;
    }
    
    public static Object getValue(SObject record, String keyField) {
        Object value;
        
        String[] keyLevels = keyField.split('\\.');
        
        for (Integer i = 0; i < keyLevels.size(); i++) {
            String keyLevel = keyLevels[i];
            
            if (record != null) {
                if (i < keyLevels.size() - 1) {
                    record = (SObject)record.getSObject(keyLevel);
                } else {
                    value = record.get(keyLevel);
                }
            }
        }
        
        return value;
    }
    
    public Schema.RecordTypeInfo getRecordTypeByRecordId(Id recordId) {
        MetadataUtilNew.checkCrudFlsString(
                new MetadataUtilNew(sObjectDescribe.getName()).sObjectType,
                'RecordTypeId,Id',
                MetadataUtilNew.CHECK_READ);
        
        SObject obj = Database.query(
                ' SELECT RecordTypeId ' +
                        ' FROM ' + sObjectDescribe.getName() +
                        ' WHERE Id =: recordId');
        
        return getRecordTypeByRecordTypeId((Id)obj.get('RecordTypeId'));
    }
    
    public Schema.RecordTypeInfo getRecordTypeByRecordTypeId(Id recordTypeId) {
        Map<Id, Schema.RecordTypeInfo> recordTypeMap = sObjectDescribe.getRecordTypeInfosById();
        return recordTypeMap.get(recordTypeId);
    }
    
    public Id getRecordTypeIdByRecordTypeName(String recordTypeName) {
        Id[] recordTypeIds = getRecordTypeIdsByRecordTypeName(recordTypeName);
        
        return recordTypeIds.size() > 0 ? recordTypeIds[0] : null;
    }
    
    public Id[] getRecordTypeIdsByRecordTypeName(String recordTypeName) {
       // logger.log('getRecordTypeIdsByRecordTypeName', 'recordTypeName', recordTypeName);
        
        Map<String, Schema.RecordTypeInfo> recordTypeMap =
                sObjectDescribe.getRecordTypeInfosByName();
        
        Id[] recordTypeIds = new Id[] {};
        
        for (String recordTypeNameFromInfo : recordTypeMap.keySet()) {
          /* logger.log('getRecordTypeIdsByRecordTypeName',
                    'recordTypeNameFromInfo', recordTypeNameFromInfo); */
            
            if (areStringsMatched(recordTypeNameFromInfo, recordTypeName)) {
                recordTypeIds.add(recordTypeMap.get(recordTypeNameFromInfo).getRecordTypeId());
            }
        }
        
        return recordTypeIds;
    }
    
    public List<SelectOption> getAllRecordTypesAsSelectOptions(Boolean addNoneOption) {
        List<SelectOption> result = new List<SelectOption>();
        
        if (addNoneOption) {
            result.add(new SelectOption('', '--None--'));
        }
        
        Map<Id, String> recordTypesIdToName = getAllRecordTypesIdToName();
        
        for (Id recordTypeId : recordTypesIdToName.keySet()) {
            result.add(new SelectOption(recordTypeId, recordTypesIdToName.get(recordTypeId)));
        }
        
        return result;
    }
    
    public Map<Id, String> getAllRecordTypesIdToName() {
        Map<Id, String> result = new Map<Id, String>();
        
        Map<String, Schema.RecordTypeInfo> recordTypeMap =
                sObjectDescribe.getRecordTypeInfosByName();
        
        for (String recordTypeName : recordTypeMap.keySet()) {
            if (recordTypeName != 'Master') {
                result.put(recordTypeMap.get(recordTypeName).getRecordTypeId(), recordTypeName);
            }
        }
        
        return result;
    }
    
    /*
        Example: List<SelectOption> options = MetadataUtilNew.getAllSelectOptionsForField(
                sObjectType.Account.fields.Industry, true);
    */
    public static List<SelectOption> getAllSelectOptionsForField(
            Schema.DescribeFieldResult describeField, Boolean addNoneOption) {
        
        List<SelectOption> result = new List<SelectOption>();
        
        if (addNoneOption) {
            result.add(new SelectOption('', '--None--'));
        }
        
        Map<String, String> picklistValueToLabel = getAllPicklistValueToLabel(describeField);
        
        for (String picklistValue : picklistValueToLabel.keySet()) {
            result.add(new SelectOption(picklistValue, picklistValueToLabel.get(picklistValue)));
        }
        
        return result;
    }
    
    /*
        Example: Map<String, String> result = MetadataUtilNew.getAllPicklistValueToLabel(
                sObjectType.Account.fields.Industry);
    */
    public static Map<String, String> getAllPicklistValueToLabel(
            Schema.DescribeFieldResult describeField) {
        
        Map<String, String> result = new Map<String, String>();
        
        List<Schema.PicklistEntry> picklistValues = describeField.getPicklistValues();
        
        for (Schema.PicklistEntry picklistValue : picklistValues) {
            if (picklistValue.isActive()) {
                result.put(picklistValue.getValue(), picklistValue.getLabel());
            }
        }
        
        return result;
    }
    
    /**
    * Example:

        1. Insert or Update.

        MetadataUtilNew.checkCrudFls(
                Payments_to_Invoice__c.sObjectType,
                new Schema.sObjectField[] {
                        Payments_to_Invoice__c.Amount__c,
                        Payments_to_Invoice__c.Payment__c,
                        Payments_to_Invoice__c.Receivable__c},
                MetadataUtilNew.CHECK_INSERT | MetadataUtilNew.CHECK_UPDATE);

        2. Delete.

        MetadataUtilNew.checkCrudFls(
                Payments_to_Invoice__c.sObjectType,
                null,
                MetadataUtilNew.CHECK_DELETE);
    */
    public static Integer CHECK_READ = 1;
    public static Integer CHECK_INSERT = 2;
    public static Integer CHECK_UPDATE = 4;
    public static Integer CHECK_DELETE = 8;
    public static Integer CHECK_UPSERT = CHECK_INSERT | CHECK_UPDATE;
    
    public static Boolean THROW_WARNINGS = false;
    
    public static void checkCrudFlsString(
            Schema.SObjectType sObjectType,
            String fieldsToCheckString,
            Integer operationToCheck) {
        
        if (Site.getSiteId() != null) {
            return;
        }
        if (String.isBlank(fieldsToCheckString)) {
            checkCrudFls(sObjectType, null, operationToCheck);
            return;
        }
        
        Map<Schema.SObjectType, Set<Schema.SObjectField>> fieldsToCheckMap =
                new Map<Schema.SObjectType, Set<Schema.SObjectField>>();
        
        for (String fieldString : fieldsToCheckString.split(',')) {
            fieldString = fieldString.trim();
            
            String[] levels = fieldString.split('\\.');
            
            MetadataUtilNew mdOfLevel = MetadataUtilNew.getInstance(sObjectType);
            
            for (Integer i = 0; i < levels.size(); i++) {
                String level = levels[i];
                
              //  logger.log('checkCrudFlsString', 'level 1', level);
                
                String parentType;
                if (level.contains('(')) {
                    parentType = level.substringBetween('(', ')');
                    level = level.substringBefore('(');
                }
                
                if (i < levels.size() - 1) {
                    if (level.endsWith('__r')) {
                        level = level.removeEnd('__r') + '__c';
                    } else {
                        level = level + 'Id';
                    }
                    
                   // logger.log('checkCrudFlsString', 'level 2', level);
                    
                    Schema.DescribeFieldResult describeFieldResult =
                            mdOfLevel.getDescribeFieldResult(level);
                    
                    if (describeFieldResult == null) {
                        throwFieldNoFoundErrorMessage(mdOfLevel, level, fieldsToCheckString);
                    }
                    
                    if (describeFieldResult.isPermissionable()) {
                        addSObjectFieldToMap(
                                fieldsToCheckMap, mdOfLevel, level, fieldsToCheckString);
                    }
                    
                    if (describeFieldResult.isNamePointing()) {
                        if (parentType == null) {
                            throw new CrudFlsException(
                                    'checkCrudFls: Field ' + mdOfLevel.getObjectName() +
                                            '.' + level +
                                            ' cannot be checked. It does not work with ' +
                                            'multi-parent fields. ' +
                                            'For example, a task can have both ' +
                                            'the Contact/Lead ID (WhoId) field and ' +
                                            'the Opportunity/Account ID (WhatId) field. ' +
                                            '"FieldsToCheckString" is "'  + '".');
                        } else {
                            mdOfLevel = MetadataUtilNew.getInstance(parentType);
                        }
                    } else {
                        mdOfLevel = MetadataUtilNew.getInstance(
                                describeFieldResult.getReferenceTo()[0]);
                    }
                } else {
                    addSObjectFieldToMap(
                            fieldsToCheckMap, mdOfLevel, level, fieldsToCheckString);
                }
            }
        }
        
        for (Schema.SObjectType currentSObjectType : fieldsToCheckMap.keySet()) {
            Schema.SObjectField[] fieldsToCheck =
                    new List<Schema.SObjectField>(fieldsToCheckMap.get(currentSObjectType));
            checkCrudFls(currentSObjectType, fieldsToCheck, operationToCheck);
        }
    }
    
    private static void addSObjectFieldToMap(
            Map<Schema.SObjectType, Set<Schema.SObjectField>> fieldsToCheckMap,
            MetadataUtilNew mdOfLevel, String level, String fieldsToCheckString) {
        
        //logger.log('addSObjectFieldToMap',
        //      'mdOfLevel.getObjectName().level', mdOfLevel.getObjectName() + '.' + level);


        Set<Schema.SObjectField> fieldsToCheck =
                fieldsToCheckMap.get(mdOfLevel.sObjectType);

        if (fieldsToCheck == null) {
            fieldsToCheck = new Set<Schema.SObjectField>();
            fieldsToCheckMap.put(mdOfLevel.sObjectType, fieldsToCheck);
        }
        
        Schema.SObjectField field = mdOfLevel.getSObjectField(level);
        
        //logger.log('addSObjectFieldToMap', 'field', field);

        if (field == null) {
            throwFieldNoFoundErrorMessage(mdOfLevel, level, fieldsToCheckString);
        }
        fieldsToCheck.add(field);
    }
    
    private static void throwFieldNoFoundErrorMessage(
            MetadataUtilNew mdOfLevel, String fieldName, String fieldsToCheckString) {
        
        throw new CrudFlsException(
                'checkCrudFls: Field ' + mdOfLevel.getObjectName() + '.' +
                        ' does not exist. "FieldsToCheckString" is "'  + '"');
    }
    public static void checkCrudFls(
            Schema.SObjectType sObjectType,
            Schema.SObjectField[] fieldsToCheck,
            Integer operationToCheck) {
        
        if (Site.getSiteId() != null || true) {
            return;
        }
        
        MetadataUtilNew md = MetadataUtilNew.getInstance(sObjectType);
        
        //logger.log('checkCrudFls', 'getObjectName()', md.getObjectName());
        //logger.log('checkCrudFls', 'fieldsToCheck', fieldsToCheck);
        //logger.log('checkCrudFls', 'operationToCheck', operationToCheck);
        
        Boolean checkRead = (operationToCheck & CHECK_READ) != 0;
        Boolean checkInsert = (operationToCheck & CHECK_INSERT) != 0;
        Boolean checkUpdate = (operationToCheck & CHECK_UPDATE) != 0;
        Boolean checkDelete = (operationToCheck & CHECK_DELETE) != 0;
        
        //logger.log('checkCrudFls', 'checkRead', checkRead);
        //logger.log('checkCrudFls', 'checkInsert', checkInsert);
        //logger.log('checkCrudFls', 'checkUpdate', checkUpdate);
        //logger.log('checkCrudFls', 'checkDelete', checkDelete);

        //logger.log('checkCrudFls', 'sObjectDescribe.isAccessible()',
        //      md.sObjectDescribe.isAccessible());
        //logger.log('checkCrudFls', 'sObjectDescribe.isCreateable()',
        //      md.sObjectDescribe.isCreateable());
        //logger.log('checkCrudFls', 'sObjectDescribe.isUpdateable()',
        //      md.sObjectDescribe.isUpdateable());
        //logger.log('checkCrudFls', 'sObjectDescribe.isDeletable()',
        //      md.sObjectDescribe.isDeletable());

        List<String> errorsObject = new List<String>();
        
        if (checkRead && !md.sObjectDescribe.isAccessible()) {
            errorsObject.add('Current user has to have permissions to READ this object.');
        }
        
        if (checkInsert && !md.sObjectDescribe.isCreateable()) {
            errorsObject.add('Current user has to have permissions to CREATE this object.');
        }
        
        if (checkUpdate && !md.sObjectDescribe.isUpdateable()) {
            errorsObject.add('Current user has to have permissions to EDIT this object.');
        }
        
        if (checkDelete && !md.sObjectDescribe.isDeletable()) {
            errorsObject.add('Current user has to have permissions to DELETE this object.');
        }
        
        List<String> errorsFieldRead = new List<String>();
        List<String> errorsFieldCreate = new List<String>();
        List<String> errorsFieldEdit = new List<String>();
        
        if (fieldsToCheck != null) {
            for (Schema.SObjectField fieldToCheck : fieldsToCheck) {
                
                if (fieldToCheck == null) {
                    continue;
                }
                
                Schema.DescribeFieldResult fieldDescribe = md.getDescribeFieldResult(fieldToCheck);
                
               // logger.log('checkCrudFls', 'fieldDescribe.getName()', fieldDescribe.getName());
                
                if (!fieldDescribe.isPermissionable()
                        || fieldDescribe.getType() == Schema.DisplayType.ADDRESS) {
                    
                    logOrThrow('WARNING: field ' + md.getObjectName() +
                            '.' + fieldDescribe.getName() +
                            ' is not permissionable. Skipped.');
                    continue;
                }
                
                //logger.log('checkCrudFls', 'fieldDescribe.getName()', fieldDescribe.getName());
                //logger.log('checkCrudFls', 'fieldDescribe.isAccessible()',
                //fieldDescribe.isAccessible());
                //logger.log('checkCrudFls', 'fieldDescribe.isCreateable()',
                //fieldDescribe.isCreateable());
                //logger.log('checkCrudFls', 'fieldDescribe.isUpdateable()',
                //fieldDescribe.isUpdateable());
                
                if (checkRead && !fieldDescribe.isAccessible()) {
                    errorsFieldRead.add(fieldDescribe.getName());
                }
                
                if (fieldDescribe.isAutoNumber() || fieldDescribe.isCalculated()) {
                    logOrThrow('WARNING: field ' + md.getObjectName() +
                            '.' + fieldDescribe.getName() +
                            ' is an auto-number or formula. Skipped.');
                    
                    continue;
                }
                
                if (checkInsert && !fieldDescribe.isCreateable()) {
                    errorsFieldCreate.add(fieldDescribe.getName());
                }
                
                if (checkUpdate && !fieldDescribe.isUpdateable()) {
                    errorsFieldEdit.add(fieldDescribe.getName());
                }
            }
        }
        
        String error = '';
        
        if (errorsObject.size() > 0) {
            error += String.join(errorsObject, ' ') + ' ';
        }
        if (errorsFieldRead.size() > 0) {
            error +=
                    'Current user has to have permissions to READ values for the following fields of the object: ' +
                            String.join(errorsFieldRead, ', ')
                            + '. ';
        }
        if (errorsFieldCreate.size() > 0) {
            error +=
                    'Current user has to have permissions to CREATE values for the following fields of the object: ' +
                            String.join(errorsFieldCreate, ', ')
                            + '. ';
        }
        if (errorsFieldEdit.size() > 0) {
            error +=
                    'Current user has to have permissions to EDIT values for the following fields of the object: ' +
                            String.join(errorsFieldEdit, ', ')
                            + '. ';
        }
        
        if (String.isNotBlank(error)) {
            String errorsTitle =
                    'You don\'t have enough permissions to operate with an object ' +
                            md.getObjectName() +
                            '. ';
            
            throw new CrudFlsException(errorsTitle + error);
        }
    }
    
    // stringToCheck = any string
    // filterString can be: qwe, %qwe%, %qwe, qwe%.
    public static Boolean areStringsMatched(String stringToCheck, String filterString) {
        String stringToCheckLower = stringToCheck.toLowerCase();
        String filterStringLower = filterString.toLowerCase();
        
       // logger.log('areStringsMatched', 'stringToCheckLower', stringToCheckLower);
       // logger.log('areStringsMatched', 'filterStringLower', filterStringLower);
        
        if (filterString.startsWith('%') && filterString.endsWith('%')) {
            String filterStringLowerClear =
                    filterStringLower.removeStart('%').removeEnd('%');
            
            if (stringToCheckLower.contains(filterStringLowerClear)) {
                //logger.log('areStringsMatched', 'stringToCheckLower contains');
                
                return true;
            }
        } else if (filterString.startsWith('%')) {
            String filterStringLowerClear =
                    filterStringLower.removeStart('%');
            
            if (stringToCheckLower.endsWith(filterStringLowerClear)) {
              //  logger.log('areStringsMatched', 'stringToCheckLower endsWith');
                
                return true;
            }
        } else if (filterString.endsWith('%')) {
            String filterStringLowerClear =
                    filterStringLower.removeEnd('%');
            
            if (stringToCheckLower.startsWith(filterStringLowerClear)) {
             //   logger.log('areStringsMatched', 'stringToCheckLower startsWith');
                
                return true;
            }
        } else {
            if (stringToCheckLower == filterStringLower) {
              //  logger.log('areStringsMatched', 'stringToCheckLower equals');
                
                return true;
            }
        }
        
        return false;
    }
    
    private static void logOrThrow(String message) {
        if (THROW_WARNINGS) {
            throw new CrudFlsException(message);
        } else {
           // logger.log('checkCrudFls', message);
        }
    }
    
    public with sharing class MetadataException extends Exception {
    }
    
    public with sharing class CrudFlsException extends Exception {
    }
    
    // Deprecated
    
    global void updateChildFieldsFromParentFields(List<SObject> p_childRecords,
            Schema.SObjectField p_childToParentLookupField,
            Map<Schema.SObjectField, Schema.SObjectField> p_parentFieldsToChildFieldsMap) {
    }
    global List<Schema.SObjectField> getAllEditableFieldsSObject() {
        return null;
    }
    global String getObjectAPINameByParentRelationshipName(String parentRelationshipName) {
        return null;
    }
    
     public static Object getFieldValue(SObject record, String fieldName) {
        Object value;
        if (MetadataUtilNew.getInstance(record).isFieldExists(fieldName)) {
            value = record.get(fieldName);
        }
        
        return value;
    }
    
     public static SObject[] getRelationshipValue(SObject record, String relationshipName) {
        SObject[] value;
        if (MetadataUtilNew.getInstance(record).isRelationshipExists(relationshipName)) {
            value = record.getSObjects(relationshipName);
        }
        
        return value;
    }
    
     global Boolean isRelationshipExists(String relationshipName) {
        return getChildRelationshipByRelationshipName(relationshipName) != null;
    }
}
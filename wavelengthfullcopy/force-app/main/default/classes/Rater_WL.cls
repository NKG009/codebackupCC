global virtual with sharing class Rater_WL extends kruvi_staff.Rater_Shift {
    List<Scoring> SCORES = new List<Scoring> {
        new Scoring(Schema.SObjectType.Contact.fields.Category__c, Schema.SObjectType.AVTRRT__Job__c.fields.Category__c, 1),
        new Scoring(Schema.SObjectType.Contact.fields.Speciality__c, Schema.SObjectType.AVTRRT__Job__c.fields.Specialty_NEW__c, 3),
        new Scoring(Schema.SObjectType.Contact.fields.Sub_Specialty__c, Schema.SObjectType.AVTRRT__Job__c.fields.Sub_Specialty_New__c, 5),
        new Scoring(Schema.SObjectType.Contact.fields.Seniority_NEW__c, Schema.SObjectType.AVTRRT__Job__c.fields.Seniority_NEW__c, 5),
        new Scoring(Schema.SObjectType.Contact.fields.Employment_Preference__c, Schema.SObjectType.AVTRRT__Job__c.fields.Job_Type__c, 2)
    };

    global virtual override List<kruvi.Rater.Result> rate(String sObjectType, List<Map<String, Object>> items) {
        return rate(sObjectType, items, null);
    }

    global virtual override List<kruvi.Rater.Result> rate(String sObjectType, List<Map<String,Object>> items, Map<String,Object> mapSettings) {
        //Execute standard matching algorithm
        List<kruvi.Rater.Result> results = super.rate(sObjectType, items, mapSettings);

        //Score job attributes
        return scoreJobAttributes(results, items[0], mapSettings);
    }

    private AVTRRT__Job__c getJob(Id contractId) {
        //Make a list of required fields
        List<String> lstFields = new List<String>();
        lstFields.add('id');

        for (Scoring sc : SCORES) {
            lstFields.add(sc.jobField.getName());
        }

        List<AVTRRT__Job__c> jobs = Database.query('SELECT ' + String.join(lstFields, ',') + ' FROM AVTRRT__Job__c WHERE Isimio_Contract__c = :contractId');
        if (!jobs.isEmpty()) {
            return jobs[0];
        }
        return null;
    }

    private List<Contact> getCandidates(AVTRRT__Job__c job) {
        //Make a list of required fields
        List<String> lstFields = new List<String>();
        lstFields.add('id');

        //Get contact filter
        List<String> filters = new List<String>();

        Map<String, Object> mapValues = new Map<String, Object>();
        String filter;
        Integer i=0;
        for (Scoring sc : SCORES) {
            lstFields.add(sc.contactField.getName());

            if (job.get(sc.jobField.getSobjectField()) != null) {
                //Create a criteria for which values we're looking for in candidates
                String key = 'val' + (i++);

                if (sc.contactField.getType() == Schema.DisplayType.MULTIPICKLIST) {
                    //Multi picklist: find any contact with any of the values included in the picklist
                    filter = sc.contactField.getName() + ' INCLUDES (';
                    Integer j=0;
                    for (String attr : ((String)job.get(sc.jobField.getSobjectField())).split(';')) {
                        String key2 = key + '_' + (j++);
                        filter += ':' + key2 + ',';

                        mapValues.put(key2, attr);
                    }
                    filter = filter.removeEnd(',') + ')';
                } else {
                    //Other fields: find any contact with the same value as the field
                    filter = sc.contactField.getName() + ' = :' + key;

                    mapValues.put(key, job.get(sc.jobField.getSobjectField()));
                }

                filters.add(filter);
            }
        }

        //Add the standard contact filter
        List<kruvi__Schedule_Object__c> obj = [SELECT Id, kruvi__Filter__c FROM kruvi__Schedule_Object__c WHERE Name LIKE 'Contact'];

        //Prepare and execute query
        String strQuery = 'SELECT ' + String.join(lstFields, ',') + ' FROM Contact WHERE (' + obj[0].kruvi__Filter__c + ') ';
        
        if (!filters.isEmpty()) {
            strQuery += 'AND ((' + String.join(filters, ') OR (') + '))';
        }

        return (List<Contact>)Database.queryWithBinds(strQuery, mapValues, AccessLevel.USER_MODE);
    }

    private void add(Contact con, String factor, Decimal points, Decimal max, Map<Id, kruvi.Rater.Result> mapMatches) {
        Kruvi.Rater.Result res = mapMatches.get(con.Id);
        if (res == null) {
            res = new Kruvi.Rater.Result(con.Id);
            mapMatches.put(con.Id, res);
        }

        res.max += max;
        res.add(factor, points, max, (points / max) * 100);
    }

    @TestVisible private List<kruvi.Rater.Result> scoreJobAttributes(List<kruvi.Rater.Result> results, Map<String, Object> shift, Map<String,Object> mapSettings) {
        //Create a list of destination IDs
        String shiftId = (String)shift.get('id'); //Keep this as a string since matching shifts may have virtual IDs

        //Map existing results by contact ID
        Map<Id, kruvi.Rater.Result> mapMatches = new Map<Id, kruvi.Rater.Result>();
        for (kruvi.Rater.Result res : results) {
            mapMatches.put(res.matchId, res);
        }

        //Load relevant job
        AVTRRT__Job__c job = getJob((Id)shift.get('kruvi_staff__icontract__c'));

        if (job == null) {
            //No job, nothing we can do
            return mapMatches.values();
        }

        //Fetch contact records to get their attributes
        List<Contact> candidates = getCandidates(job);

        //Review each candidate against the job attributes
        for (Contact con : candidates) {
            for (Scoring sc : SCORES) {
                //Compare contact and job values
                String conValue = (String)con.get(sc.contactField.getSobjectField());
                String jobValue = (String)job.get(sc.jobField.getSobjectField());

                if (jobValue == null) {
                    //No value on the job, nothing to match
                    continue;
                }

                if (sc.contactField.getType() == Schema.DisplayType.MULTIPICKLIST) {
                    //Multi picklist: score for each matching attribute
                    Set<String> conValues = (conValue == null) ? new Set<String>() : new Set<String>(conValue.split(';'));
                    List<String> jobValues = jobValue.split(';');

                    if (!jobValues.isempty()) {
                        Decimal pointsPerItem = sc.points / Decimal.valueOf(jobValues.size());

                        for (String value : jobValues) {
                            if (conValues.contains(value)) {
                                add(con, value, pointsPerItem, pointsPerItem, mapMatches);
                            } else {
                                add(con, value, 0, pointsPerItem, mapMatches);
                            }
                        }
                    }
                } else {
                    //Regular field, match entire field
                    if (conValue != null && conValue.equalsIgnoreCase(jobValue)) {
                        add(con, jobValue, sc.points, sc.points, mapMatches);
                    } else {
                        add(con, jobValue, 0, sc.points, mapMatches);
                    }
                }
            }
        }

        return mapMatches.values();
    }

    public class Scoring {
        public Schema.DescribeFieldResult contactField;
        public Schema.DescribeFieldResult jobField;
        public Integer points;

        public Scoring(Schema.DescribeFieldResult contactField, Schema.DescribeFieldResult jobField, Integer points) {
            this.contactField = contactField;
            this.jobField = jobField;
            this.points = points;
        }
    }
}
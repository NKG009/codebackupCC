public with sharing class LMSEnrolmentController {

    @AuraEnabled(cacheable=true)
    public static List<LMS_Enrolment__c> getEnrolmentList(Id courseId, String status) {
        String q = 'SELECT Id, Status__c, Enrolment_Date__c, Completion_Date__c, Overall_Score__c, Certification_Flag__c, Learner__r.Name, LMS_Course__r.Name FROM LMS_Enrolment__c WHERE Id != null';
        if (courseId != null) q += ' AND LMS_Course__c = :courseId';
        if (String.isNotBlank(status)) q += ' AND Status__c = :status';
        q += ' ORDER BY Enrolment_Date__c DESC LIMIT 500';
        return Database.query(q);
    }

    @AuraEnabled
    public static Id enrolLearner(String enrolmentData) {
        LMS_Enrolment__c enrol = (LMS_Enrolment__c) JSON.deserialize(enrolmentData, LMS_Enrolment__c.class);
        enrol.Status__c = 'Not Started';
        insert enrol;
        return enrol.Id;
    }

    @AuraEnabled
    public static void withdrawLearner(Id enrolmentId) {
        update new LMS_Enrolment__c(Id = enrolmentId, Status__c = 'Withdrawn');
    }

   @AuraEnabled(cacheable=true)
public static Map<String, Object> getEnrolmentProgress(Id enrolmentId) {

    LMS_Enrolment__c enrol = [
        SELECT Id,
               Status__c,
               Enrolment_Date__c,
               Overall_Score__c,
               Learner__c,
               Learner__r.Name,
               LMS_Course__c,
               LMS_Course__r.Name
        FROM LMS_Enrolment__c
        WHERE Id = :enrolmentId
        LIMIT 1
    ];

    Set<Id> lessonIds = new Set<Id>();

    // Lessons directly attached to the course
    for (LMS_Course_Lesson__c cl : [
        SELECT LMS_Lesson__c
        FROM LMS_Course_Lesson__c
        WHERE LMS_Course__c = :enrol.LMS_Course__c
    ]) {
        lessonIds.add(cl.LMS_Lesson__c);
    }

    // Get classes associated with the course
    Set<Id> classIds = new Set<Id>();

    for (LMS_Course_Class__c cc : [
        SELECT LMS_Class__c
        FROM LMS_Course_Class__c
        WHERE LMS_Course__c = :enrol.LMS_Course__c
    ]) {
        classIds.add(cc.LMS_Class__c);
    }

    // Lessons attached to those classes
    if (!classIds.isEmpty()) {
        for (LMS_Class_Lesson__c cl : [
            SELECT LMS_Lesson__c
            FROM LMS_Class_Lesson__c
            WHERE LMS_Class__c IN :classIds
        ]) {
            lessonIds.add(cl.LMS_Lesson__c);
        }
    }

    List<LMS_Lesson_Progress__c> progress = new List<LMS_Lesson_Progress__c>();

    if (!lessonIds.isEmpty()) {
        progress = [
            SELECT Id,
                   Is_Complete__c,
                   Completed_Date__c,
                   Completed_Via__c,
                   Lesson__c,
                   Lesson__r.Name
            FROM LMS_Lesson_Progress__c
            WHERE Learner__c = :enrol.Learner__c
            AND Lesson__c IN :lessonIds
        ];
    }

    return new Map<String, Object>{
        'enrolment' => enrol,
        'lessonProgress' => progress
    };
}
}
public with sharing class LMSLessonController {

    @AuraEnabled(cacheable=false)
    public static List<LMS_Lesson__c> getLessonList() {
        return [SELECT Id, Name, Content_Type__c, Content_URL__c, Duration_Mins__c, Allow_Test_Out__c, Quiz__c, Quiz__r.Name
                FROM LMS_Lesson__c ORDER BY Name ASC LIMIT 500];
    }

    @AuraEnabled(cacheable=false)
    public static LMS_Lesson__c getLesson(Id lessonId) {
        if (lessonId == null) return new LMS_Lesson__c(Allow_Test_Out__c = false);
        return [SELECT Id, Name, Content_Type__c, Content_URL__c, Duration_Mins__c, Allow_Test_Out__c, Quiz__c
                FROM LMS_Lesson__c WHERE Id = :lessonId LIMIT 1];
    }

    @AuraEnabled
    public static Id saveLesson(String lessonData) {
        LMS_Lesson__c lesson = (LMS_Lesson__c) JSON.deserialize(lessonData, LMS_Lesson__c.class);
        upsert lesson;
        return lesson.Id;
    }

    @AuraEnabled
    public static void deleteLesson(Id lessonId) {
        delete [SELECT Id FROM LMS_Lesson__c WHERE Id = :lessonId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<LMS_Lesson__c> searchLessons(String searchTerm) {
        String s = '%' + searchTerm + '%';
        return [SELECT Id, Name, Content_Type__c, Duration_Mins__c FROM LMS_Lesson__c WHERE Name LIKE :s /*AND Is_Active__c = true*/ ORDER BY Name ASC LIMIT 50];
    }

    @AuraEnabled
    public static void addExistingLesson(Id lessonId, Id classId, Id courseId) {
        if (classId != null) {
            Integer seq = [SELECT COUNT() FROM LMS_Class_Lesson__c WHERE LMS_Class__c = :classId] + 1;
            insert new LMS_Class_Lesson__c(LMS_Class__c = classId, LMS_Lesson__c = lessonId, Sequence_Number__c = seq);
        } else if (courseId != null) {
            Integer seq = [SELECT COUNT() FROM LMS_Course_Lesson__c WHERE LMS_Course__c = :courseId] + 1;
            insert new LMS_Course_Lesson__c(LMS_Course__c = courseId, LMS_Lesson__c = lessonId, Sequence_Number__c = seq);
        }
    }

    @AuraEnabled
    public static void createAndAddLesson(String lessonData, Id classId, Id courseId) {
        LMS_Lesson__c lesson = (LMS_Lesson__c) JSON.deserialize(lessonData, LMS_Lesson__c.class);
        insert lesson;
        addExistingLesson(lesson.Id, classId, courseId);
    }

    @AuraEnabled(cacheable=true)
    public static LMS_Class__c getClass(Id classId) {
        if (classId == null) return new LMS_Class__c(Is_Published__c = false);
        return [SELECT Id, Name, Class_Code__c, Description__c, Is_Published__c
                FROM LMS_Class__c WHERE Id = :classId LIMIT 1];
    }

    @AuraEnabled
    public static Id saveClass(String classData) {
        LMS_Class__c cls = (LMS_Class__c) JSON.deserialize(classData, LMS_Class__c.class);
        upsert cls;
        return cls.Id;
    }
}
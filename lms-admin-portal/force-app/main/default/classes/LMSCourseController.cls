public with sharing class LMSCourseController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new Map<String, Object>();
        stats.put('publishedCourses', [SELECT COUNT() FROM LMS_Course__c WHERE Is_Published__c = true]);
        stats.put('activeLearners', [SELECT COUNT() FROM LMS_Enrolment__c WHERE Status__c != 'Withdrawn']);
        stats.put('totalQuestions', [SELECT COUNT() FROM LMS_Question__c WHERE Is_Active__c = true]);
        stats.put('certificationsIssued', [SELECT COUNT() FROM LMS_Certification__c]);
        stats.put('pendingGrading', [SELECT COUNT() FROM LMS_Quiz_Attempt__c WHERE Grading_Status__c = 'Pending Review']);
        Integer total = [SELECT COUNT() FROM LMS_Enrolment__c];
        Integer completed = [SELECT COUNT() FROM LMS_Enrolment__c WHERE Status__c = 'Certified'];
        stats.put('completionRate', total > 0 ? Math.roundToLong(100.0 * completed / total) : 0);
        return stats;
    }

    @AuraEnabled(cacheable=true)
    public static List<LMS_Course__c> getCourseList() {
        return [
            SELECT Id, Name, Course_Code__c, Category__c, Is_Published__c, Start_Date__c, End_Date__c,
                   Requires_Approval__c,
                   (SELECT Id FROM LMS_Enrolments__r),
                   (SELECT Id FROM LMS_Course_Class__r)
            FROM LMS_Course__c ORDER BY Name ASC
        ];
    }

    @AuraEnabled(cacheable=false)
    public static Map<String, Object> getCourseDetail(Id courseId) {
        if (courseId == null) return new Map<String, Object>{
            'course' => new LMS_Course__c(), 'classes' => new List<Object>(), 'directLessons' => new List<Object>()
        };
        LMS_Course__c course = [SELECT Id, Name, Course_Code__c, Description__c, Category__c, Start_Date__c, End_Date__c,
                                       Total_Credits__c, Is_Certification__c, Passing_Threshold__c, Is_Published__c, Final_Quiz__c,
                                       Requires_Approval__c
                                FROM LMS_Course__c WHERE Id = :courseId LIMIT 1];
        List<LMS_Course_Class__c> courseClasses = [
            SELECT Id, Sequence_Number__c, LMS_Class__c, LMS_Class__r.Name
            FROM LMS_Course_Class__c WHERE LMS_Course__c = :courseId ORDER BY Sequence_Number__c ASC
        ];
        List<Map<String, Object>> classTree = new List<Map<String, Object>>();
        for (LMS_Course_Class__c cc : courseClasses) {
            List<LMS_Class_Lesson__c> lessons = [
                SELECT Id, Sequence_Number__c, LMS_Lesson__c, LMS_Lesson__r.Name, LMS_Lesson__r.Content_Type__c, LMS_Lesson__r.Duration_Mins__c
                FROM LMS_Class_Lesson__c WHERE LMS_Class__c = :cc.LMS_Class__c ORDER BY Sequence_Number__c ASC
            ];
            classTree.add(new Map<String, Object>{
                'Id' => cc.LMS_Class__c, 'junctionId' => cc.Id, 'Name' => cc.LMS_Class__r.Name,
                'lessons' => lessons, 'hasLessons' => !lessons.isEmpty()
            });
        }
        List<LMS_Course_Lesson__c> directLessons = [
            SELECT Id, Sequence_Number__c, LMS_Lesson__c, LMS_Lesson__r.Name, LMS_Lesson__r.Content_Type__c, LMS_Lesson__r.Duration_Mins__c
            FROM LMS_Course_Lesson__c WHERE LMS_Course__c = :courseId ORDER BY Sequence_Number__c ASC
        ];
        return new Map<String, Object>{ 'course' => course, 'classes' => classTree, 'directLessons' => directLessons };
    }

    @AuraEnabled
    public static Id saveCourse(String courseData) {
        LMS_Course__c course = (LMS_Course__c) JSON.deserialize(courseData, LMS_Course__c.class);
        upsert course;
        return course.Id;
    }

    @AuraEnabled
    public static void deleteCourse(Id courseId) {
        delete [SELECT Id FROM LMS_Course__c WHERE Id = :courseId LIMIT 1];
    }

    @AuraEnabled
    public static void togglePublish(Id recordId, Boolean currentState) {
        update new LMS_Course__c(Id = recordId, Is_Published__c = !currentState);
    }

    @AuraEnabled
    public static void removeCourseClass(Id junctionId) {
        delete [SELECT Id FROM LMS_Course_Class__c WHERE Id = :junctionId LIMIT 1];
    }

    @AuraEnabled
    public static void removeCourseLesson(Id junctionId) {
        delete [SELECT Id FROM LMS_Course_Lesson__c WHERE Id = :junctionId LIMIT 1];
    }
	
    @AuraEnabled
    public static void removeClassLesson(Id junctionId) {
        delete [SELECT Id FROM LMS_Class_Lesson__c WHERE Id = :junctionId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getCourseOptions() {
        List<Map<String, Object>> opts = new List<Map<String, Object>>();
        for (LMS_Course__c c : [SELECT Id, Name FROM LMS_Course__c ORDER BY Name ASC])
            opts.add(new Map<String, Object>{ 'label' => c.Name, 'value' => c.Id });
        return opts;
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> searchRecords(String objectName, String searchTerm) {
        String sosl = 'FIND :searchTerm IN NAME FIELDS RETURNING ' + objectName + '(Id, Name) LIMIT 10';
        List<List<SObject>> results = Search.query(sosl);
        return results.isEmpty() ? new List<SObject>() : results[0];
    }
	
      @AuraEnabled
    public static void addClassToCourse(Id courseId, Id classId) {
        Integer seq = [SELECT COUNT() FROM LMS_Course_Class__c WHERE LMS_Course__c = :courseId] + 1;
        insert new LMS_Course_Class__c(LMS_Course__c = courseId, LMS_Class__c = classId, Sequence_Number__c = seq);
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecentActivity() {
        List<Map<String, Object>> activities = new List<Map<String, Object>>();
        for (LMS_Certification__c c : [SELECT Id, Learner__r.Name, LMS_Course__r.Name, CreatedDate FROM LMS_Certification__c ORDER BY CreatedDate DESC LIMIT 3])
            activities.add(new Map<String, Object>{ 'Id' => c.Id, 'text' => c.Learner__r.Name + ' certified in ' + c.LMS_Course__r.Name, 'type' => 'certification', 'timestamp' => c.CreatedDate });
        for (LMS_Enrolment__c e : [SELECT Id, Learner__r.Name, LMS_Course__r.Name, CreatedDate FROM LMS_Enrolment__c ORDER BY CreatedDate DESC LIMIT 3])
            activities.add(new Map<String, Object>{ 'Id' => e.Id, 'text' => e.Learner__r.Name + ' enrolled in ' + e.LMS_Course__r.Name, 'type' => 'enrolment', 'timestamp' => e.CreatedDate });
        activities.sort();
        return activities;
    }

}
public with sharing class LMSGradingController {

    @AuraEnabled(cacheable=true)
    public static Integer getPendingCount() {
        return [SELECT COUNT() FROM LMS_Quiz_Attempt__c WHERE Grading_Status__c = 'Pending Review'];
    }

    @AuraEnabled(cacheable=true)
    public static List<LMS_Quiz_Attempt__c> getGradingQueue(Id courseId, String status) {
        String q = 'SELECT Id, CreatedDate, Grading_Status__c, Score__c, Pass_Fail__c, ' +
                   'Learner__r.Name, LMS_Quiz__r.Name, LMS_Enrolment__r.LMS_Course__r.Name ' +
                   'FROM LMS_Quiz_Attempt__c WHERE Grading_Status__c != \'Auto-Graded\'';
        if (String.isNotBlank(courseId)) q += ' AND LMS_Enrolment__r.LMS_Course__c = :courseId';
        if (String.isNotBlank(status)) q += ' AND Grading_Status__c = :status';
        q += ' ORDER BY CreatedDate DESC LIMIT 200';
        return Database.query(q);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAttemptDetail(Id attemptId) {
        LMS_Quiz_Attempt__c attempt = [
            SELECT Id, CreatedDate, Score__c, Pass_Fail__c, Grading_Status__c,
                   Learner__r.Name, LMS_Quiz__r.Name, LMS_Enrolment__r.LMS_Course__r.Name
            FROM LMS_Quiz_Attempt__c WHERE Id = :attemptId LIMIT 1
        ];
        List<LMS_Answer__c> answers = [
            SELECT Id, Learner_Response__c, Is_Correct__c, Points_Awarded__c, Grading_Status__c,
                   Instructor_Comment__c, Learner_Feedback__c,
                   Question__r.Question_Text__c, Question__r.Question_Type__c, Question__r.Default_Points__c
            FROM LMS_Answer__c WHERE Quiz_Attempt__c = :attemptId
        ];
        return new Map<String, Object>{ 'attempt' => attempt, 'answers' => answers };
    }

    @AuraEnabled
    public static void saveGrades(Id attemptId, String answers) {
        List<LMS_Answer__c> answerList = (List<LMS_Answer__c>) JSON.deserialize(answers, List<LMS_Answer__c>.class);
        for (LMS_Answer__c a : answerList) a.Grading_Status__c = 'Graded';
        update answerList;
        AggregateResult ar = [SELECT SUM(Points_Awarded__c) total FROM LMS_Answer__c WHERE Quiz_Attempt__c = :attemptId];
        AggregateResult maxAr = [SELECT SUM(Question__r.Default_Points__c) maxPts FROM LMS_Answer__c WHERE Quiz_Attempt__c = :attemptId];
        Decimal totalPoints = (Decimal) ar.get('total');
        Decimal maxPoints = (Decimal) maxAr.get('maxPts');
        Decimal score = maxPoints > 0 ? (totalPoints / maxPoints * 100).setScale(1) : 0;
        LMS_Quiz_Attempt__c attempt = [SELECT Id, LMS_Quiz__r.Passing_Score__c FROM LMS_Quiz_Attempt__c WHERE Id = :attemptId LIMIT 1];
        attempt.Score__c = score;
        attempt.Grading_Status__c = 'Graded';
        attempt.Pass_Fail__c = score >= attempt.LMS_Quiz__r.Passing_Score__c ? 'Pass' : 'Fail';
        update attempt;
    }

    @AuraEnabled
    public static void issueCertification(Id attemptId) {
        LMS_Quiz_Attempt__c attempt = [
            SELECT Id, Learner__c, LMS_Enrolment__r.LMS_Course__c
            FROM LMS_Quiz_Attempt__c WHERE Id = :attemptId LIMIT 1
        ];
        insert new LMS_Certification__c(
            Learner__c = attempt.Learner__c,
            LMS_Course__c = attempt.LMS_Enrolment__r.LMS_Course__c,
            Date_Issued__c = Date.today(),
            Certificate_Number__c = 'CERT-' + String.valueOf(System.currentTimeMillis()),
            Certifying_Instructor__c = UserInfo.getUserId()
        );
        LMS_Enrolment__c enrol = [SELECT Id FROM LMS_Enrolment__c WHERE LMS_Course__c = :attempt.LMS_Enrolment__r.LMS_Course__c AND Learner__c = :attempt.Learner__c LIMIT 1];
        enrol.Status__c = 'Certified';
        update enrol;
    }
}
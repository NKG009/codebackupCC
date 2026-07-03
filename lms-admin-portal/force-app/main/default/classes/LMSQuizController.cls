public with sharing class LMSQuizController {

    @AuraEnabled(cacheable=true)
    public static LMS_Question__c getQuestion(Id questionId) {
        if (questionId == null) return new LMS_Question__c(Is_Active__c = true, Default_Points__c = 1);
        return [SELECT Id, Name, Question_Text__c, Question_Type__c, Option_A__c, Option_B__c, Option_C__c, Option_D__c,
                       Correct_Answer__c, Default_Points__c, Explanation__c, Is_Active__c
                FROM LMS_Question__c WHERE Id = :questionId LIMIT 1];
    }

     @AuraEnabled
    public static Id saveQuestion(String questionData) {
        // Deserialise into a generic map first to avoid Apex rejecting
        // system/read-only fields (e.g. CreatedDate, SystemModstamp) that
        // the LWC may have included from a prior getQuestion response.
        Map<String, Object> raw = (Map<String, Object>) JSON.deserializeUntyped(questionData);
        LMS_Question__c q = new LMS_Question__c();
        if (raw.containsKey('Id') && raw.get('Id') != null) q.Id = (Id) raw.get('Id');
        if (raw.containsKey('Name'))              q.Name               = (String)  raw.get('Name');
        if (raw.containsKey('Question_Text__c'))  q.Question_Text__c   = (String)  raw.get('Question_Text__c');
        if (raw.containsKey('Question_Type__c'))  q.Question_Type__c   = (String)  raw.get('Question_Type__c');
        if (raw.containsKey('Option_A__c'))       q.Option_A__c        = (String)  raw.get('Option_A__c');
        if (raw.containsKey('Option_B__c'))       q.Option_B__c        = (String)  raw.get('Option_B__c');
        if (raw.containsKey('Option_C__c'))       q.Option_C__c        = (String)  raw.get('Option_C__c');
        if (raw.containsKey('Option_D__c'))       q.Option_D__c        = (String)  raw.get('Option_D__c');
        if (raw.containsKey('Correct_Answer__c')) q.Correct_Answer__c  = (String)  raw.get('Correct_Answer__c');
        if (raw.containsKey('Explanation__c'))    q.Explanation__c     = (String)  raw.get('Explanation__c');
        if (raw.containsKey('Default_Points__c') && raw.get('Default_Points__c') != null)
            q.Default_Points__c = Decimal.valueOf(String.valueOf(raw.get('Default_Points__c')));
        if (raw.containsKey('Is_Active__c') && raw.get('Is_Active__c') != null)
            q.Is_Active__c = (Boolean) raw.get('Is_Active__c');
        upsert q;
        return q.Id;
    }

    @AuraEnabled
    public static List<LMS_Question__c> getQuestionList(String questionType, String searchTerm, Boolean activeOnly) {
        String soql = 'SELECT Id, Name, Question_Text__c, Question_Type__c, Default_Points__c, Is_Active__c FROM LMS_Question__c WHERE Id != null';
        if (activeOnly) soql += ' AND Is_Active__c = true';
        if (String.isNotBlank(questionType)) soql += ' AND Question_Type__c = :questionType';
        if (String.isNotBlank(searchTerm)) { String s = '%' + searchTerm + '%'; soql += ' AND Question_Text__c LIKE :s'; }
        soql += ' ORDER BY CreatedDate DESC LIMIT 200';
        return Database.query(soql);
    }

    @AuraEnabled
    public static Map<String, Object> getQuizDetail(Id quizId) {
        if (quizId == null) return new Map<String, Object>{ 'quiz' => new LMS_Quiz__c(), 'questions' => new List<Object>() };
        LMS_Quiz__c quiz = [SELECT Id, Name, Passing_Score__c FROM LMS_Quiz__c WHERE Id = :quizId LIMIT 1];
        List<LMS_Quiz_Question__c> junctions = [
            SELECT Id, Sequence_Number__c, Points_Override__c,
                   LMS_Question__c, LMS_Question__r.Question_Text__c, LMS_Question__r.Question_Type__c, LMS_Question__r.Default_Points__c
            FROM LMS_Quiz_Question__c WHERE LMS_Quiz__c = :quizId ORDER BY Sequence_Number__c ASC
        ];
        return new Map<String, Object>{ 'quiz' => quiz, 'questions' => junctions };
    }

    @AuraEnabled
    public static Id saveQuiz(String quizData) {
        LMS_Quiz__c q = (LMS_Quiz__c) JSON.deserialize(quizData, LMS_Quiz__c.class);
        upsert q;
        return q.Id;
    }

    @AuraEnabled
    public static void addQuestionToQuiz(Id quizId, Id questionId, Integer sequenceNum) {
        insert new LMS_Quiz_Question__c(LMS_Quiz__c = quizId, LMS_Question__c = questionId, Sequence_Number__c = sequenceNum);
    }

    @AuraEnabled
    public static void removeQuizQuestion(Id junctionId) {
        delete [SELECT Id FROM LMS_Quiz_Question__c WHERE Id = :junctionId LIMIT 1];
    }


// Additional methods appended

    @AuraEnabled
    public static List<LMS_Quiz__c> getQuizList() {
        return [SELECT Id, Name, Passing_Score__c,
                       (SELECT Id FROM LMS_Quiz_Question__r),
                       (SELECT Id FROM Lessons__r),
                       (SELECT Id FROM Courses__r)
                FROM LMS_Quiz__c ORDER BY Name ASC LIMIT 500];
    }

    @AuraEnabled
    public static void deleteQuiz(Id quizId) {
        delete [SELECT Id FROM LMS_Quiz__c WHERE Id = :quizId LIMIT 1];
    }

    @AuraEnabled
    public static void updateQuestionPoints(Id junctionId, Decimal points) {
        update new LMS_Quiz_Question__c(Id = junctionId, Points_Override__c = points);
    }

    @AuraEnabled
    public static Id duplicateQuestion(Id questionId) {
        LMS_Question__c orig = [SELECT Id, Question_Text__c, Question_Type__c, Option_A__c, Option_B__c, Option_C__c, Option_D__c, Correct_Answer__c, Default_Points__c, Explanation__c FROM LMS_Question__c WHERE Id = :questionId LIMIT 1];
        LMS_Question__c copy = orig.clone(false, true, false, false);
        copy.Name = orig.Name + ' (copy)';
        insert copy;
        return copy.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getQuizOptions() {
        List<Map<String, Object>> opts = new List<Map<String, Object>>();
        for (LMS_Quiz__c q : [SELECT Id, Name FROM LMS_Quiz__c ORDER BY Name ASC])
            opts.add(new Map<String, Object>{ 'label' => q.Name, 'value' => q.Id });
        return opts;
    }
}
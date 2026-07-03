public with sharing class LMSUserController {

    // Permission Set names — must match exactly what is deployed in the org
    private static final Set<String> LMS_PS_NAMES = new Set<String>{
        'LMS_Admin', 'LMS_Instructor', 'LMS_Instructor_Student', 'LMS_Student'
    };

    // Map PS name → display label
    private static final Map<String, String> PS_LABEL = new Map<String, String>{
        'LMS_Admin'              => 'Admin',
        'LMS_Instructor'         => 'Instructor',
        'LMS_Instructor_Student' => 'Instructor-Student',
        'LMS_Student'            => 'Student'
    };

    // Reverse map: display label → PS name
    private static final Map<String, String> LABEL_PS = new Map<String, String>{
        'Admin'               => 'LMS_Admin',
        'Instructor'          => 'LMS_Instructor',
        'Instructor-Student'  => 'LMS_Instructor_Student',
        'Student'             => 'LMS_Student'
    };

    /**
     * Build a userId → role label map from PermissionSetAssignment.
     * Each user gets at most one LMS Permission Set.
     */
    private static Map<Id, String> getRoleMap(Set<Id> userIds) {
        Map<Id, String> roleMap = new Map<Id, String>();
        for (PermissionSetAssignment psa : [
            SELECT AssigneeId, PermissionSet.Name
            FROM PermissionSetAssignment
            WHERE AssigneeId IN :userIds
            AND PermissionSet.Name IN :LMS_PS_NAMES
        ]) {
            roleMap.put(psa.AssigneeId, PS_LABEL.get(psa.PermissionSet.Name));
        }
        return roleMap;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getLmsUsers() {
        List<User> users = [
            SELECT Id, Name, Email
            FROM User
            WHERE IsActive = true
            AND UserType = 'Standard'
            ORDER BY Name ASC
            LIMIT 500
        ];

        Set<Id> userIds = new Map<Id, User>(users).keySet();
        Map<Id, String> roleMap = getRoleMap(userIds);

        // Count enrolments and certifications per user for the card display
        Map<Id, Integer> enrolCount = new Map<Id, Integer>();
        Map<Id, Integer> certCount  = new Map<Id, Integer>();

        for (AggregateResult ar : [
            SELECT Learner__c uid, COUNT(Id) cnt
            FROM LMS_Enrolment__c
            WHERE Status__c != 'Withdrawn'
            GROUP BY Learner__c
        ]) {
            enrolCount.put((Id)ar.get('uid'), (Integer)ar.get('cnt'));
        }

        for (AggregateResult ar : [
            SELECT Learner__c uid, COUNT(Id) cnt
            FROM LMS_Certification__c
            GROUP BY Learner__c
        ]) {
            certCount.put((Id)ar.get('uid'), (Integer)ar.get('cnt'));
        }

        List<Map<String, Object>> result = new List<Map<String, Object>>();
        for (User u : users) {
            result.add(new Map<String, Object>{
                'Id'         => u.Id,
                'Name'       => u.Name,
                'Email'      => u.Email,
                'lmsRole'    => roleMap.containsKey(u.Id) ? roleMap.get(u.Id) : 'Student',
                'enrolCount' => enrolCount.containsKey(u.Id) ? enrolCount.get(u.Id) : 0,
                'certCount'  => certCount.containsKey(u.Id)  ? certCount.get(u.Id)  : 0
            });
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getUserDetail(Id userId) {
        User u = [SELECT Id, Name, Email FROM User WHERE Id = :userId LIMIT 1];
        Map<Id, String> roleMap = getRoleMap(new Set<Id>{ userId });
        return new Map<String, Object>{
            'Id'      => u.Id,
            'Name'    => u.Name,
            'Email'   => u.Email,
            'lmsRole' => roleMap.containsKey(userId) ? roleMap.get(userId) : 'Student'
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> searchUsers(String searchTerm) {
        String s = '%' + searchTerm + '%';
        List<User> users = [
            SELECT Id, Name, Email
            FROM User
            WHERE IsActive = true
            AND (Name LIKE :s OR Email LIKE :s)
            ORDER BY Name ASC
            LIMIT 20
        ];
        // Return plain maps so LWC doesn't need the LMS_Role__c field
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        for (User u : users) {
            result.add(new Map<String, Object>{
                'Id'    => u.Id,
                'Name'  => u.Name,
                'Email' => u.Email
            });
        }
        return result;
    }

    /**
     * Assign a new LMS role to a user.
     * Removes any existing LMS Permission Set assignment first,
     * then inserts the new one — unless role = 'Student' and LMS_Student
     * is the default PS applied to all users, in which case skip the insert.
     */
    @AuraEnabled
    public static void updateUserRole(Id userId, String role) {
        // Remove all existing LMS PS assignments for this user
        List<PermissionSetAssignment> existing = [
            SELECT Id
            FROM PermissionSetAssignment
            WHERE AssigneeId = :userId
            AND PermissionSet.Name IN :LMS_PS_NAMES
        ];
        if (!existing.isEmpty()) delete existing;

        // Find the target Permission Set Id
        String psName = LABEL_PS.containsKey(role) ? LABEL_PS.get(role) : 'LMS_Student';
        PermissionSet ps = [
            SELECT Id FROM PermissionSet WHERE Name = :psName LIMIT 1
        ];

        insert new PermissionSetAssignment(
            AssigneeId    = userId,
            PermissionSetId = ps.Id
        );
    }
}
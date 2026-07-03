public inherited sharing class UserSelector {
    public static User getSingleUserThatIsNotMe(String userId) {
        return [SELECT Id, LanguageLocaleKey FROM User WHERE Id = :userId];
    }
}
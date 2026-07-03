//  https://targetrecruit.atlassian.net/browse/WAVE-303
//  Author: Priyanka
trigger ContactCustomTrigger on Contact (before insert) {
    if(trigger.isbefore && trigger.isInsert){
        for(Contact con : trigger.new){
            con.Category_New__c = null;
            con.Speciality__c =null;
            con.Seniority_NEW__c=null;
            con.Sub_Specialty__c =null;
            con.Job_Attribute__c =null;
            con.Employment_Preference__c = null;
        }
    }
}
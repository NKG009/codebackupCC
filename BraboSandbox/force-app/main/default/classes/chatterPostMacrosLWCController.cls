public with sharing class chatterPostMacrosLWCController {
    
    @AuraEnabled(cacheable = true)
    public static Internal_Macro__mdt Getpicklistval(Id recordid, decimal optionval) {
        return [select MasterLabel from Internal_Macro__mdt];
    }
    
    @AuraEnabled
    public static string postchatterrequest(Id recordid, decimal optionval) {
        string feeditemid;
        system.debug('recordid:'+recordid +'---optionval'+optionval);
        Internal_Macro__mdt IMre =[select LWC_Picklist_Values__c,Body_Of_Macro__c,MasterLabel from Internal_Macro__mdt where LWC_Picklist_Values__c=:optionval];
		ConnectApi.FeedItem feedItem = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText('internal', recordid, IMre.Body_Of_Macro__c);
        system.debug('feedItem:'+feedItem.id);
        feeditemid=feedItem.id;
        
        return feeditemid;
    }
}
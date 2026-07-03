/* This trigger was created by the Youreka package and is integral to it. 
Please do not delete */
trigger Youreka_AccountContactRelationLD_trigger on AccountContactRelation__c (after update){
    disco.Util.updateAnswersInLinkedSections(trigger.new,'AccountContactRelation__c');
}
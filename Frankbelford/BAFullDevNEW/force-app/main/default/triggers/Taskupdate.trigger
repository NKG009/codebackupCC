trigger Taskupdate on Task (after insert) {
    List<Contact> updatecontact = new List<Contact>();
    set<Id> conId = new set<Id>();
    set<Id> tskId = new set<Id>();
    System.debug('==================== trigger.new : '+Trigger.new);
    for(task t : Trigger.new) {
        System.debug('==================== task t : '+t);
         if(t.Subject.contains('Please provide details for your referees')  && t.whoId!=null && t.whoId.getsobjectType()== Contact.sobjectType){
           updatecontact.add(new Contact(Id = t.whoId,Reference_Status__c = 'Referee Request Sent')); 
        }
         if(t.Subject.contains('Welcome to Blue Arrow') && t.whoId!=null && t.whoId.getsobjectType()==Contact.sobjectType)
        {
            updatecontact.add(new Contact(id=t.Whoid,IP_Last_Consent_Requested__c = System.now(),IP_Last_Consent_Requested_By__c = UserInfo.getName()));
        }       
        if(t.Subject.contains( 'Blue Arrow - Post Interview Information Request') || t.Subject.contains('Blue Arrow - Static Compliance Forms' )||t.Subject.contains( 'Driving Post Interview Request Forms')  && t.whoId!=null && t.whoId.getsobjectType()==Contact.sobjectType){
           updatecontact.add(new Contact(Id = t.whoId,Reference_Status__c = 'Referee Request Sent',IP_Last_Consent_Requested__c = System.now(),IP_Last_Consent_Requested_By__c = UserInfo.getName())); 
        }
        
         tskId.add(t.id);
        if(t.IP_ActivityType__c == 'General Call' || t.IP_CandidateCallTypes__c == 'General Call'){ 
        conId.add(t.WhoID);}
    }
    if(!System.isBatch() && !System.isFuture()){
    emailfuture.emailmethod(conId,tskId);}
 update updatecontact;
}
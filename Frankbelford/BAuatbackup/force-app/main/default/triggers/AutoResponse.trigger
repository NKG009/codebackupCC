trigger AutoResponse on ts2__Application__c (after update,after insert) {
  
    set<id> sendapp = new Set<id>();
  if(Trigger.isUpdate)
    {
        for(ts2__Application__c app : trigger.new)
        {
             ts2__Application__c oldassgn = Trigger.oldMap.get(app.Id);
              SYstem.debug('old value'+oldassgn.ts2__Application_Status__c);
              SYstem.debug('new value'+app.ts2__Application_Status__c);
             if(oldassgn.ts2__Application_Status__c != app.ts2__Application_Status__c && app.ts2__Application_Status__c == 'Rejected')
             {
                 sendapp.add(app.id);
             }
        }
        SYstem.debug('check set'+sendapp);
       if(checkRecurautoresponse.runOnce())
       {
        if(!sendapp.isEmpty())
        {
            sendautoresponse.sendmail(sendapp);
        }
       }
    }
    if(Trigger.isInsert)
    {
        Map <String,Datetime> appcontactmap = new Map<String,Datetime>();
        for(ts2__Application__c  app : trigger.new)
        {
            appcontactmap.put(app.ts2__Candidate_Contact__c,app.createddate);
        }
        List<Contact> contactlist = [Select id, IP_LastContactedGDPR__c from Contact where id in :appcontactmap.keyset()];
        for(Contact c: contactlist)
        {
            c.IP_LastContactedGDPR__c = Date.valueOf(appcontactmap.get(c.id));
        }
        update contactlist;
    }
}
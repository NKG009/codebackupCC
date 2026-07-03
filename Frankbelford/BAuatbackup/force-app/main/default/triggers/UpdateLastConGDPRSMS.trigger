trigger UpdateLastConGDPRSMS on smagicinteract__smsMagic__c (after insert) {
set<Id> conId = new set<Id>();
    for(smagicinteract__smsMagic__c  smsrec : trigger.new )
    {    
        if(smsrec.smagicinteract__Direction__c == 'IN'){ 
        conId.add(smsrec.smagicinteract__Contact__c);}
    }

List<Contact> conList = new List<Contact>();
    for(Contact con: [Select id,IP_LastContactedGDPR__c from Contact where id =: conid]){
        con.IP_LastContactedGDPR__c = system.today();
        conList.add(con);

    }
    try{
    Update conList;}
    catch(Exception e){
    
    }
}
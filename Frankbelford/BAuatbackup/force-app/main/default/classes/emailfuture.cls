public class emailfuture{
    public emailfuture(){

    }
    @future
public static void emailmethod(set<Id> conId, set<Id> tskId){
 for(Task tk : [Select whoId from Task where Id =:tskId and (Id in (SELECT ActivityId FROM EmailMessage WHERE MessageIdentifier LIKE '%outlook%' or Status = '1')) ]){
        conId.add(tk.WhoID);
    }

List<Contact> conList = new List<Contact>();
    for(Contact con: [Select id,IP_LastContactedGDPR__c from Contact where id =: conId]){
        con.IP_LastContactedGDPR__c = system.today();
        conList.add(con);

    }
    try{
    Update conList;}
    catch(Exception e){
    
    }

}
}
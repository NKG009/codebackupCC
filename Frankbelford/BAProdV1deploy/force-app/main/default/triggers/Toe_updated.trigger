trigger Toe_updated on Contact (after update) {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
    if(!Payroll.Batch_check__c || Limits.getQueries() <90) {
        if(CheckRecursionTOE.runOnce()){
            set<ID> conID = new set<ID>();
            set<string> emailadd = new set<string>();
    for (SObject so : Trigger.old)
                {                  
                    Contact oldcon = (Contact)so;
                    Contact newcon = Trigger.newMap.get(so.Id);
        if(newcon.TOE_Completed__c != oldcon.TOE_Completed__c  && newcon.TOE_Completed__c == True){
           conID.add(newcon.Id); 
            //emailadd.add(con.email);
        }
    }
    if(conID.size()>0)
    {
        List<Contact> conlist = new List<Contact>();
        Toe_UserCreatedFuture.createUser(conID);
     
    }
    }}
}
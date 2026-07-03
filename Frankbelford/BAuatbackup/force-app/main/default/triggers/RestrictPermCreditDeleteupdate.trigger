trigger RestrictPermCreditDeleteupdate on ts2__Placement__c (before update, before delete) {

if(Trigger.IsDelete)
    {
    for(ts2__Placement__c  creditrec : [SELECT Id FROM ts2__Placement__c WHERE RecordType.Name = 'Perm Credits' and Id IN :Trigger.oldMap.KeySet()]){
       
        Trigger.oldMap.get(creditrec.Id).adderror('Once created Perm Credit record cannot be deleted');
       
    }
    }
}
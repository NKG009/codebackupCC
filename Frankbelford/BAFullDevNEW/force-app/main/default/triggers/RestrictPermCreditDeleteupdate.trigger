trigger RestrictPermCreditDeleteupdate on TR1__Closing_Report__c (before update, before delete) {

if(Trigger.IsDelete)
    {
    for(TR1__Closing_Report__c  creditrec : [SELECT Id FROM TR1__Closing_Report__c WHERE RecordType.Name = 'Perm Credits' and Id IN :Trigger.oldMap.KeySet()]){
       
        Trigger.oldMap.get(creditrec.Id).adderror('Once created Perm Credit record cannot be deleted');
       
    }
    }
}
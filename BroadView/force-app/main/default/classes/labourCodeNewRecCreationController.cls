public with sharing class labourCodeNewRecCreationController {
    @AuraEnabled(cacheable=true)
    public Static ServiceContract Getrecorddetail(Id recordId){
         system.debug('recordId'+recordId);
         Id woid =[select id,ParentRecordid from Serviceappointment where id=:recordId].ParentRecordid;
         Id Scontract=[select id,ServiceContractId from workorder where id=:woid].ServiceContractId;
        ServiceContract SC =[select id,(select id,Product2Id,Product2.name,Product2.Fixed__c from ContractLineItems) from Servicecontract where id=:Scontract limit 1];
        system.debug('ServiceContract'+SC);
        return SC;
        
    }
    
    @AuraEnabled(cacheable=true)
    public Static string Createlabourrec(Id recordId,Id prodid,id Slitemid, Integer hours){
        ContractLineItem CLI = [select id,TotalPrice,Quantity from ContractLineItem where id=:Slitemid limit 1];
        Labor_Codes__c lc = new Labor_Codes__c();
        lc.Service_Appointment__c=recordId;
        lc.Product__c=prodid;
        lc.Quantity__c=CLI.Quantity;
        if(hours==0){
        lc.Price__c=CLI.TotalPrice;
        }
        else{
           lc.Price__c=hours*CLI.TotalPrice;
        }
        insert lc;
        system.debug('labour code'+lc);
        
        return null;
    }
}
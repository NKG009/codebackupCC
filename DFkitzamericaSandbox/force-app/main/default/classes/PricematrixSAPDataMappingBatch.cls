public class PricematrixSAPDataMappingBatch implements Database.Batchable<SObject>, Database.Stateful {

    public String query = 'SELECT Id, SAP_Account_Number__c, SAP_Material_Number__c,Product__c,NET_Price__c,Product_Discount__c,Product_Sub_Category_Discount__c,Product_Category_Discount__c FROM Pricing_Matrix__c'+
                          'WHERE SAP_Account_Number__c != null OR SAP_Material_Number__c != null AND Active__c =true';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Pricing_Matrix__c> PMalldata) {
        System.debug('*******************************************PricematrixSAPDataMappingBatch  start**************************************************');
        Set<String> sapAccountNumbers = new Set<String>();
        Set<String> sapMaterialNumbers = new Set<String>();
		
        for (Pricing_Matrix__c pmrec : PMalldata) {
            if (pmrec.SAP_Account_Number__c != null)
                sapAccountNumbers.add(pmrec.SAP_Account_Number__c);

            if (pmrec.SAP_Material_Number__c != null)
                sapMaterialNumbers.add(pmrec.SAP_Material_Number__c);
        }

        Map<String, Id> accountMap = new Map<String, Id>();
        Map<Id, Account> accreclistmap = new Map<Id, Account>([SELECT Id, AccountNumber,ParentId FROM Account WHERE AccountNumber IN :sapAccountNumbers]);

        for (Account acc : accreclistmap.values()) {
            accountMap.put(acc.AccountNumber, acc.Id);            
        }

        Map<String, Id> productMap = new Map<String, Id>();
        for (Product2 prod : [
            SELECT Id, APTS_Material_Num__c
            FROM Product2
            WHERE APTS_Material_Num__c IN :sapMaterialNumbers
        ]) {
            productMap.put(prod.APTS_Material_Num__c, prod.Id);
        }

        List<Pricing_Matrix__c> pmrecupdate = new List<Pricing_Matrix__c>();

        for (Pricing_Matrix__c oi : PMalldata) {
            if (oi.SAP_Account_Number__c != null && 
                accountMap.containsKey(oi.SAP_Account_Number__c)) {
                    if(accreclistmap.get(accountMap.get(oi.SAP_Account_Number__c)).ParentId !=null){
                        oi.Parent_Account__c = accountMap.get(oi.SAP_Account_Number__c);
                    }
                    else{
                        oi.Customer_Account__c = accountMap.get(oi.SAP_Account_Number__c);
                    }
               
            }

            if (oi.SAP_Material_Number__c != null && 
                productMap.containsKey(oi.SAP_Material_Number__c)) {

                oi.Product__c = productMap.get(oi.SAP_Material_Number__c);
            }

                pmrecupdate.add(oi);
        }

        if (!pmrecupdate.isEmpty()) {
            update pmrecupdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Data Mapping Batch completed.');
    }
}
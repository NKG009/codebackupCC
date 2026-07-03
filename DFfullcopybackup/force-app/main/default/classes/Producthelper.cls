/****************************
* Name : Producthelper
* Description : Class to perform operations on trigger events on project object record.
****************************/

public class Producthelper {
   
    public void onAfterInsert(List<Product2> newList,Map<Id, Product2> oldMap)
        
    {
        
        for(Product2 product : newList ) 
        {
            Product2 oldProduct = oldMap.get(product.Id);
            System.debug('oldProduct ' + oldProduct.IsActive);
            System.debug('New Procuct '+product.IsActive);
            System.debug('Old Product ' + oldProduct.IsActive);
            if ((product.IsActive == True && oldProduct.IsActive==False )||(product.IsActive == True)) {
                List<Apttus_Config2__PriceList__c> pricelist = [Select id,Name,Apttus_Config2__Active__c,Apttus_Config2__Type__c from Apttus_Config2__PriceList__c where Name='Standard USD PriceList'];
                List<Apttus_Config2__PriceListItem__c> pricelistitems=[select id,Apttus_Config2__ListPrice__c,Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c=:oldProduct.id ];
                if(pricelistitems.size()==0){
                    Apttus_Config2__PriceListItem__c cp =new Apttus_Config2__PriceListItem__c();
                    
                    cp.Apttus_Config2__ProductId__c=product.id;
                    cp.Apttus_Config2__PriceListId__c= pricelist[0].id;
                    cp.Apttus_Config2__ChargeType__c='Standard';
                    cp.Apttus_Config2__PriceMethod__c='Per Unit';
                    cp.APTS_Pricing_Type_Code__c='One Time';
                    cp.Apttus_Config2__ListPrice__c=0.00;
                    insert cp;
                    
                }
            }
        }}
}
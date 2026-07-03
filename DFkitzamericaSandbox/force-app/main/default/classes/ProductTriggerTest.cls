/****************************
* Name : ProductTriggerTest
* Description : Class to handler  events on Producthelper.
****************************/

@isTest
public class ProductTriggerTest {
    @isTest 
    static void testBeforeInsertLineItemTrigger(){
        Account acc = Testutility.createAccount();
        insert acc;
        
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
       
        list<Product2> prods = new list<Product2>();
        prods.add(prod);
        
        Product2 oldprod = Testutility.createProduct();
        oldprod.IsActive=false;
        insert oldprod;
        oldprod.APTS_Material_Num__c='23';
        update oldprod;
        Apttus_Config2__PriceList__c priceList=Testutility.createPriceList();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        Apttus_Config2__PriceListItem__c priceListitem =Testutility.createpricelistitem(prod.id, priceList.id);
        insert priceListitem;
        
        Map <id,Product2> oldMap= new map<id,Product2>();
        Product2 productID= [select ID ,IsActive  from  Product2 where id =: oldprod.Id limit 1];     
        oldMap.put(prod.Id,productID);
        
        Producthelper helperClass = new Producthelper();
        helperClass.onAfterInsert(prods,oldMap);
        ProductTriggerHandler.onAfterInsert(prods,oldMap);
       
 
        priceListitem.APTS_Pricing_Type_Code__c='test';
        update priceListitem;
    }
     @isTest 
    static void onAfterInsert(){
        Account acc = Testutility.createAccount();
        insert acc;
        
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        list<Product2> prods = new list<Product2>();
        prods.add(prod);
        
        Product2 oldprod = Testutility.createProduct();
        oldprod.IsActive=false;
        insert oldprod;
        Apttus_Config2__PriceList__c priceList=Testutility.createPriceList();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        Apttus_Config2__PriceListItem__c priceListitem =Testutility.createpricelistitem(prod.id, priceList.id);
        insert priceListitem;
        
        
       
 
        priceListitem.APTS_Pricing_Type_Code__c='test';
        update priceListitem;
    }
}
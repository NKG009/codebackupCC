/*********************************************************
* Name : ProductInvetoryExt
* Description : Extension for ProductInvetoryPage Vf Page
**********************************************************/
public class ProductInvetoryExt {    
    public Product2 Prod {set;get;}    
    public String Body;    
    public InventoryData Inventdata;    
    public list<InventoryData.IDENT_Data> Indentlst {get; set;}    
    public list<InventoryData.WAREHOUSE_Data> WHlst {get; set;}
    
    public list<InventoryData.RESTOCK_Data> Restocklst {get; set;}
    
    public list<InventoryData.ETA_Data> ETAlst {get; set;}
    
    public list<InventoryData.ALLOCATION_Data> Allocationlst {get; set;}
    
    public Boolean restockmsg {get; set;}
    
    public Boolean Indentmsg {get; set;}
    
    public Boolean Allocationmsg {get; set;}
    
    public ProductInvetoryExt(ApexPages.StandardController stdController) {
        Prod = (Product2)stdController.getRecord();
        this.Prod = [select id,Name,APTS_Material_Num__c from Product2 where id = :Prod.id limit 1];
        
        Indentlst = new list<InventoryData.IDENT_Data>();
        WHlst = new list<InventoryData.WAREHOUSE_Data>();
         Restocklst = new list<InventoryData.RESTOCK_Data> ();
        ETAlst = new list<InventoryData.ETA_Data> ();
        Allocationlst = new list<InventoryData.ALLOCATION_Data>();
        
        InventoryCallout call = new InventoryCallout();  
        Body = call.callInventory(this.Prod.APTS_Material_Num__c, 'ALL');
        system.debug('body'+Body);
        if(Body != null){
        Inventdata = new  InventoryData(System.JSON.createParser(Body));        
        WHlst = Inventdata.WAREHOUSE.WAREHOUSE_Data; 
        }
        if(WHlst.size() == 0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning, 'No data recieved');
            ApexPages.addMessage(msg);
        }
    }  
    
    public void getMockDataForRestockOrderAndETA(){
        if(Inventdata != null) {
            Restocklst = Inventdata.RESTOCK.RESTOCK_Data;
            ETAlst = Inventdata.ETA.ETA_Data;
            
            if(Restocklst.size() == 0 && ETAlst.size() == 0){
                restockmsg = true;
            } else {
                if (Restocklst.size() < ETAlst.size()) {
                    String jsonBody = '{"PO_NUMBER": "","LINE_NUMBER": "","AVAIL_DATE": ""}';
                    JSONParser parser = JSON.createParser(jsonBody);
                    for(Integer i = Restocklst.size(); i < ETAlst.size(); i++) {
                        Restocklst.add(new InventoryData.RESTOCK_Data(parser));
                    }
                }
                
                for(Integer i = 0; i < ETAlst.size(); i++) {
                    Restocklst[i].ETA_REC_REQD_QTY_ALT_UOM = ETAlst[i].REC_REQD_QTY_ALT_UOM;
                    Restocklst[i].ETA_AVAIL_DATE = ETAlst[i].AVAIL_DATE; 	 
                }
            }
        }        
        else 
            restockmsg = true;
    }
           
    public void getMockDataForIndentETA(){
        if(Inventdata != null) {
            Indentlst = Inventdata.INDENT.IDENT_Data;
            if(Indentlst.size() == 0){
                Indentmsg = true;
            }
        }        
        else 
            Indentmsg = true;
    }
    
    public void getMockDataForAllocation(){
        if(Inventdata != null) { 
            Allocationlst = Inventdata.ALLOCATION.ALLOCATION_Data;
            if(Allocationlst.size() == 0){           
                Allocationmsg = true;
            }
        }        
        else 
            Allocationmsg = true;  
    }
    
    public pagereference close(){
        pagereference pg = new pagereference('/'+Prod.id);
        return pg;        
    }
    
}
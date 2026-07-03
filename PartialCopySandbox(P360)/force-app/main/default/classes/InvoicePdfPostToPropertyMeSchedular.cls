public class InvoicePdfPostToPropertyMeSchedular implements schedulable {
    
    public void execute(SchedulableContext sc){
        callingInvoicebatchclass();
    }
    
    
    public static void callingInvoicebatchclass(){
        set<id> AccParentidlist = new set<id>();
        for(OrderId_For_PropertyMeBills__c ordid : [select name,AccountParentID__c from OrderId_For_PropertyMeBills__c]){
            
            AccParentidlist.add(ordid.AccountParentID__c);
        } 
        system.debug('InvoiceOrderId__cdata '+AccParentidlist);
        for( id accid : AccParentidlist ){
            Database.executeBatch(new InvoicePdfPostToPropertyMeBatch(accid),1);
        }
        
    }
}
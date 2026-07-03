public with sharing class InvoiceTriggerHandler {

    public static void afterInsert(){
        InvoiceTriggerHelper.shareInvoices(Trigger.newMap.keySet());
        InvoiceTriggerHelper.InvoiceSharetoPowerUser(Trigger.newMap.keySet());
    }

    public static void afterUpdate(){
        InvoiceTriggerHelper.shareInvoices(Trigger.newMap.keySet());
    }    

}
global class creditnotecontroller {

@AuraEnabled
    public static ts2__Placement__c getplacementDetail(String placeid) {
    ts2__Placement__c ref = [Select id,IP_LastPassedToTempest__c,IP_InvoiceNumber__c,IP_InvoiceDate__c from ts2__Placement__c where id=:placeid];
    return ref;
  }
}
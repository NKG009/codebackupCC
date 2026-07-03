global class creditnotecontroller {

@AuraEnabled
    public static TR1__Closing_Report__c getplacementDetail(String placeid) {
      TR1__Closing_Report__c ref = [Select id,IP_LastPassedToTempest__c, IP_InvoiceNumber__c, TR1__Invoice_Date__c from TR1__Closing_Report__c where id=:placeid];
    return ref;
  }
}
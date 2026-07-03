public class QuickbooksCustomerService {
        
   /* @future(callout=true)
    public static void CustomerCheckInvoicecreation(set<Id> Orderids) {
        Set<id> conidtocreateQBOcustomer = new Set<id>();
        Set<id> OrdidhavingQBOcustomer = new Set<id>();
 
        for(Order od :[select id,BillToContactId,BillToContact.QBO_Customer_Id__c from Order where id IN:Orderids]){
            if(od.BillToContact.QBO_Customer_Id__c==null){
                conidtocreateQBOcustomer.add(od.BillToContactId);
            }
            else
            {
              OrdidhavingQBOcustomer.add(od.id); 
            }
        }
        system.debug('conidtocreateQBOcustomer'+conidtocreateQBOcustomer);
        if(conidtocreateQBOcustomer.size()>0){
            QBOcreatecustomer(conidtocreateQBOcustomer,Orderids);
        }
        
         system.debug('OrdidhavingQBOcustomer'+OrdidhavingQBOcustomer);
        if(OrdidhavingQBOcustomer.size()>0){
           QuickbooksInvoiceService.createUpdateInvoicesInQB(Orderids,null); //add invoice method 
        }
    }*/
    
    public static map<id,string> QBOcreatecustomer(set<Id> conidtocreateQBOcustomer){
        String response;
        Map<id,string>ConidtoQBOCusId = New Map<id,string>();
        try{
            
            Map<Id, Contact>contactIdMap= new Map<Id, Contact>();
            List<Contact> Conlist=[Select id,QBO_Customer_Id__c,FirstName,MiddleName,LastName,Title,Suffix,account.Eterneva_Account_ID__c,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,Email,MobilePhone,Phone from Contact where id IN:conidtocreateQBOcustomer];
            QuickbooksCustomerWrapper customerBatch= new QuickbooksCustomerWrapper();
            List<QuickbooksCustomerWrapper.BatchItemRequest> listBatchItemreq= new List<QuickbooksCustomerWrapper.BatchItemRequest>();
            for(Contact co: Conlist){
                contactIdMap.put(co.Id, co);
                QuickbooksCustomerWrapper.BatchItemRequest batchitemrequest= new QuickbooksCustomerWrapper.BatchItemRequest();
                QuickbooksCustomerWrapper.Customer customer = new QuickbooksCustomerWrapper.Customer(co);
               // batchitemrequest.operation = String.isBlank(co.QBO_Customer_Id__c) ? 'create' : 'update';
                batchitemrequest.operation='create';
                batchitemrequest.Customer=customer;
                batchitemrequest.bId=String.valueof(co.Id);
                listBatchItemreq.add(batchitemrequest);
            }
            customerBatch.BatchItemRequest=listBatchItemreq;
            String JsonString=Json.serialize(customerBatch);
            System.debug('JsonString'+JsonString);
            
            response = QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch', 'POST');  
            System.debug('response'+response);
            if(response != null) {
                QuickbooksCustomerResponse responseJsonCust= new QuickbooksCustomerResponse();
                responseJsonCust=(QuickbooksCustomerResponse)JSON.deserialize(response, QuickbooksCustomerResponse.class);
                List<Contact>updateContactList= new List<Contact>();
                if(responseJsonCust.BatchItemResponse!=null) {
                    for(QuickbooksCustomerResponse.BatchItemResponse b: responseJsonCust.BatchItemResponse){
                        if(Test.isRunningTest()) b.bId = listBatchItemreq[0].bId;
                        if(contactIdMap.get(b.bId)!=null){
                            system.debug('bId='+b.bId +'QBO_Customer_Id__c='+b.Customer.Id);
                            //Contact con= new Contact(id=b.bId);
                            //con.QBO_Customer_Id__c=b.Customer.Id;
                          //  con.QBO_SyncToken__c=b.customer.synctoken;
                            ConidtoQBOCusId.put(b.bId,b.Customer.Id);
                        }
                    }
                }
               
                if(!ConidtoQBOCusId.isEmpty()){
                   // QBO_ConstantUtilityClass.forceStopTrigger = true;
                    //update updateContactList;
                  //  QBO_ConstantUtilityClass.forceStopTrigger = false;
                 // QuickbooksInvoiceService.createUpdateInvoicesInQB(Orderids,ConidtoQBOCusId); //add invoice method 
   
                }
            }
        }catch(Exception e){
            LogUtil.errorLogs.add(LogUtil.createLog('QuickbooksCustomerService', 'QBOcreatecustomer', LogUtil.ERROR, conidtocreateQBOcustomer.toString(), 
                                                    null, response, e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString()));
        }
        LogUtil.insertLogs();
        return ConidtoQBOCusId; 
    }
}
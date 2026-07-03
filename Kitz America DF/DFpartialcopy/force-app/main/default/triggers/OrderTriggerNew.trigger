trigger OrderTriggerNew on Order (after insert,before Insert) {
    
    if(trigger.isbefore && trigger.isinsert){
        Map<Id,Id> ordtoqtemap = new Map<Id,Id>();
        for(order ord: trigger.new){
            if(ord.SBQQ__Quote__c !=null){
                ordtoqtemap.put(ord.Id,ord.SBQQ__Quote__c);
            }
            
            if(ordtoqtemap.size()>0){
                Map<ID,SBQQ__Quote__c> quotemap = new Map<ID,SBQQ__Quote__c>([Select Id,SBQQ__PrimaryContact__c,SBQQ__Account__c,Parent_Account_id__c,SBQQ__ShippingStreet__c,SBQQ__ShippingState__c,SBQQ__ShippingCity__c,SBQQ__ShippingCountry__c,SBQQ__ShippingPostalCode__c,CreatedDate  FROM SBQQ__Quote__c where ID IN: ordtoqtemap.values()]);
                for(order o: trigger.new){
                    SBQQ__Quote__c quoterec = quotemap.get(ordtoqtemap.get(o.Id));
                    o.Pricing_Date__c = quoterec.CreatedDate;
                    o.ShipToContactId= quoterec.SBQQ__PrimaryContact__c;
                    o.ShipToAccountId__c = quoterec.SBQQ__Account__c;
                    o.SoldToAccountId__c = quoterec.Parent_Account_id__c;
                    o.ShippingStreet =quoterec.SBQQ__ShippingStreet__c;
                    o.ShippingState = quoterec.SBQQ__ShippingState__c;
                    o.ShippingCity  = quoterec.SBQQ__ShippingCity__c;
                    o.ShippingCountry = quoterec.SBQQ__ShippingCountry__c;
                    o.ShippingPostalCode = quoterec.SBQQ__ShippingPostalCode__c;
                }
                
            }
            
        }
        
    }
    
	if (Trigger.isAfter && Trigger.isInsert) {
      // sendOrderConfirmation(Trigger.new);
    }

  /*  public static void sendOrderConfirmation(List<Order> newOrders) {

       
        List<Order> validOrders = new List<Order>();
        for (Order o : newOrders) {
            if (o.SBQQ__Quote__c != null && o.ShipToContactId != null) {
                validOrders.add(o);
            }
        }
        if (validOrders.isEmpty()) return;

      
        Set<Id> contactIds = new Set<Id>();
        for (Order o : validOrders) {
            contactIds.add(o.ShipToContactId);
        }

        Map<Id, Contact> contactMap = new Map<Id, Contact>(
            [SELECT Id, Email FROM Contact WHERE Id IN :contactIds]
        );

        /* -----------------------------
           Quote ↔ Order mapping
        ------------------------------ 
        Set<Id> quoteIds = new Set<Id>();
        Map<Id, Order> quoteOrderMap = new Map<Id, Order>();

        for (Order o : validOrders) {
            quoteIds.add(o.SBQQ__Quote__c);
            quoteOrderMap.put(o.SBQQ__Quote__c, o);
        }

        
        List<SBQQ__QuoteDocument__c> quoteDocs = [
            SELECT Id,
                   SBQQ__Quote__c,
                   SBQQ__DocumentId__c,
                   SBQQ__Version__c
            FROM SBQQ__QuoteDocument__c
            WHERE SBQQ__Quote__c IN :quoteIds
            ORDER BY SBQQ__Version__c DESC
        ];

        // Pick latest version per Quote
        Map<Id, SBQQ__QuoteDocument__c> latestDocPerQuote = new Map<Id, SBQQ__QuoteDocument__c>();
        for (SBQQ__QuoteDocument__c qd : quoteDocs) {
            if (!latestDocPerQuote.containsKey(qd.SBQQ__Quote__c)) {
                latestDocPerQuote.put(qd.SBQQ__Quote__c, qd);
            }
        }
        if (latestDocPerQuote.isEmpty()) return;

       
        Set<Id> documentIds = new Set<Id>();
        for (SBQQ__QuoteDocument__c qd : latestDocPerQuote.values()) {
            documentIds.add(qd.SBQQ__DocumentId__c);
        }

        Map<Id, Document> documentMap = new Map<Id, Document>(
            [SELECT Id, Name, Body FROM Document WHERE Id IN :documentIds]
        );


        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Id quoteId : latestDocPerQuote.keySet()) {

            Order ord = quoteOrderMap.get(quoteId);
            Contact con = contactMap.get(ord.ShipToContactId);
            SBQQ__QuoteDocument__c qd = latestDocPerQuote.get(quoteId);
            Document doc = documentMap.get(qd.SBQQ__DocumentId__c);

            if (con == null || String.isBlank(con.Email) || doc == null) continue;

            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setFileName(doc.Name + '.pdf');
            attach.setBody(doc.Body);

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { con.Email });
            email.setSubject('Order Confirmation - ' + ord.OrderNumber);
            email.setPlainTextBody(
                'Hello,\n\n' +
                'Your order has been successfully created.\n\n' +
                'Order Number: ' + ord.OrderNumber + '\n' +
                'Order Date: ' + ord.EffectiveDate + '\n' +
                'Status: ' + ord.Status + '\n\n' +
                'Please find the attached quote document.\n\n' +
                'Regards,\nSales Team'
            );
            email.setFileAttachments(
                new Messaging.EmailFileAttachment[] { attach }
            );

            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }*/
}